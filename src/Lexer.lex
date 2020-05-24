import java_cup.runtime.*;

%% 

%class Lexer
%unicode
%cup
%line
%debug
%column
%state STRING_STATE
%state STRING

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
  StringBuffer string = new StringBuffer();
%}
Underscore = "_"
LineTerminator = \n|\r|\r\n
Space = [ \t\f] | {LineTerminator}
Whitespace = \r|\n|\r\n|" "|"\t"
Letter = [a-zA-Z]
string = \" {Letter}* \"
char_string = \' [^\']* \'
Digit = [0-9]
Identifier = ({Letter} ({Underscore} | {Letter} | {Digit})*)| [a-zA-EG-SU-Z]
Integer = {Digit}+
float = {Integer}"."{Digit}+
rational = ({Integer}"_")?{Digit}+"/"{Digit}+
True = "T"
False = "F"

Newline = \r|\n|\r\n
SingleLineComment = "#"[^\r\n]*{Newline}?
MultiLineComment = "/#"[^"#/"]* "#/"

%%

<YYINITIAL> {

	//KEYWORDS
	"int" 		{ return symbol(sym.INT_TYPE); }
	"rat" 		{ return symbol(sym.RAT_TYPE); }
	"float" 	{ return symbol(sym.FLOAT_TYPE); }
	"char" 		{ return symbol(sym.CHAR_TYPE); }

	"seq" 		{return symbol(sym.SEC_TYPE);}
	"alias" 	{return symbol(sym.ALIAS);}

	"loop"		{ return symbol(sym.LOOP); }
	"pool"		{ return symbol(sym.POOL); }
	"if"		{ return symbol(sym.IF); }
	"fi"		{ return symbol(sym.FI); }
	"then"		{ return symbol(sym.THEN); }
	"else"		{ return symbol(sym.ELSE); }
	"break"		{ return symbol(sym.BREAK); }
	"fdef"		{ return symbol(sym.FDEF); }
	"tdef"		{ return symbol(sym.TDEF); }
	"alias"		{ return symbol(sym.ALIAS); }
	"read"		{ return symbol(sym.READ); }
	"print"		{ return symbol(sym.PRINT); }
	"main"		{ return symbol(sym.MAIN); }
	"return"	{ return symbol(sym.RETURN); }
	"true"		{ return symbol(sym.TRUE); }
	"false"		{ return symbol(sym.FALSE); }

	// SYMBOLS
	"("			{ return symbol(sym.LPAREN); }
	")"			{ return symbol(sym.RPAREN); }
	"."			{ return symbol(sym.DOT); }
	","			{ return symbol(sym.COMMA); }
	"["			{ return symbol(sym.LEFTBRAKET); }
	"]"			{ return symbol(sym.RIGHTBRAKET); }
	"{"			{ return symbol(sym.LEFTBRACE); }
	"}"			{ return symbol(sym.RIGHTBRACE); }
	";"			{ return symbol(sym.SEMICOL); }
	":"			{ return symbol(sym.COLON); }
	"<"			{ return symbol(sym.LESSTHAN); }
	">"			{ return symbol(sym.GREATERTHAN); }

	// OPERATORS
	"||"		{ return symbol(sym.OR); }
	"&&"		{ return symbol(sym.AND); }
	"!"			{ return symbol(sym.NOT); }
	"::"		{ return symbol(sym.CONCAT); }
	":="		{ return symbol(sym.ASSIGN); }
	"<="		{ return symbol(sym.LTOREQ); }
	">="		{ return symbol(sym.GTOREQ); }
	"*"			{ return symbol(sym.MULT); }
	"in"		{ return symbol(sym.IN); }
	"^"			{ return symbol(sym.POWER); }
	"/"			{ return symbol(sym.DIV); }
	"-"			{ return symbol(sym.MINUS); }
	"+"			{ return symbol(sym.PLUS); }
	"="			{ return symbol(sym.EQUAL); }
	\"{string}*\" {return symbol(sym.STRING); }


	//STRING LITERALS
	{Identifier}		{ return symbol(sym.IDENTIFIER, yytext()); }
	{float}				{ return symbol(sym.FLOAT); }
	{rational}			{ return symbol(sym.RAT); }
	{string}			{ return symbol(sym.STRING); }
	{char_string}       { return symbol(sym.CHAR); }

  	{Integer}     		{ return symbol(sym.INTEGER, Integer.parseInt(yytext())); }

	{Whitespace}			{}
	{Newline} 			{}
	{SingleLineComment} 		{}
	{MultiLineComment}		{}

}


[^]  {
    System.out.println("Error in line "
        + (yyline+1) +": Invalid input '" + yytext()+"'");
    return symbol(sym.BADCHAR);
}
