Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaLHB43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:56:29 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:55261 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaLHB41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:56:27 -0500
From: Christoph Jaeger <cj@linux.com>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com, Christoph Jaeger <cj@linux.com>
Subject: [PATCH 1/3] kconfig: regenerate parser
Date: Sun,  7 Dec 2014 20:49:18 -0500
Message-Id: <0bf50ad9bc78f6944ebf5d5b1f8c9bdff223185f.1418003065.git.cj@linux.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
In-Reply-To: <cover.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regenerate the Kconfig parser with Bison 3.0.2 in preparation for a following
commit. Otherwise the changes caused by the more recent Bison version would be
intermingled with functional changes.

Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 scripts/kconfig/zconf.tab.c_shipped | 1244 ++++++++++++++++-------------------
 1 file changed, 561 insertions(+), 683 deletions(-)

diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index de5e84e..0864c7d 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1,19 +1,19 @@
-/* A Bison parser, made by GNU Bison 2.5.  */
+/* A Bison parser, made by GNU Bison 3.0.2.  */
 
 /* Bison implementation for Yacc-like parsers in C
-   
-      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
-   
+
+   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.
+
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
-   
+
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
-   
+
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
 
@@ -26,7 +26,7 @@
    special exception, which will cause the skeleton and the resulting
    Bison output files to be licensed under the GNU General Public
    License without this special exception.
-   
+
    This special exception was added by the Free Software Foundation in
    version 2.2 of Bison.  */
 
@@ -44,7 +44,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.5"
+#define YYBISON_VERSION "3.0.2"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -58,18 +58,16 @@
 /* Pull parsers.  */
 #define YYPULL 1
 
-/* Using locations.  */
-#define YYLSP_NEEDED 0
 
 /* Substitute the variable and function names.  */
 #define yyparse         zconfparse
 #define yylex           zconflex
 #define yyerror         zconferror
-#define yylval          zconflval
-#define yychar          zconfchar
 #define yydebug         zconfdebug
 #define yynerrs         zconfnerrs
 
+#define yylval          zconflval
+#define yychar          zconfchar
 
 /* Copy the first part of user declarations.  */
 
@@ -108,10 +106,13 @@ static struct menu *current_menu, *current_entry;
 
 
 
-/* Enabling traces.  */
-#ifndef YYDEBUG
-# define YYDEBUG 1
-#endif
+# ifndef YY_NULLPTR
+#  if defined __cplusplus && 201103L <= __cplusplus
+#   define YY_NULLPTR nullptr
+#  else
+#   define YY_NULLPTR 0
+#  endif
+# endif
 
 /* Enabling verbose error messages.  */
 #ifdef YYERROR_VERBOSE
@@ -121,58 +122,60 @@ static struct menu *current_menu, *current_entry;
 # define YYERROR_VERBOSE 0
 #endif
 
-/* Enabling the token table.  */
-#ifndef YYTOKEN_TABLE
-# define YYTOKEN_TABLE 0
-#endif
 
+/* Debug traces.  */
+#ifndef YYDEBUG
+# define YYDEBUG 1
+#endif
+#if YYDEBUG
+extern int zconfdebug;
+#endif
 
-/* Tokens.  */
+/* Token type.  */
 #ifndef YYTOKENTYPE
 # define YYTOKENTYPE
-   /* Put the tokens into the symbol table, so that GDB and other debuggers
-      know about them.  */
-   enum yytokentype {
-     T_MAINMENU = 258,
-     T_MENU = 259,
-     T_ENDMENU = 260,
-     T_SOURCE = 261,
-     T_CHOICE = 262,
-     T_ENDCHOICE = 263,
-     T_COMMENT = 264,
-     T_CONFIG = 265,
-     T_MENUCONFIG = 266,
-     T_HELP = 267,
-     T_HELPTEXT = 268,
-     T_IF = 269,
-     T_ENDIF = 270,
-     T_DEPENDS = 271,
-     T_OPTIONAL = 272,
-     T_PROMPT = 273,
-     T_TYPE = 274,
-     T_DEFAULT = 275,
-     T_SELECT = 276,
-     T_RANGE = 277,
-     T_VISIBLE = 278,
-     T_OPTION = 279,
-     T_ON = 280,
-     T_WORD = 281,
-     T_WORD_QUOTE = 282,
-     T_UNEQUAL = 283,
-     T_CLOSE_PAREN = 284,
-     T_OPEN_PAREN = 285,
-     T_EOL = 286,
-     T_OR = 287,
-     T_AND = 288,
-     T_EQUAL = 289,
-     T_NOT = 290
-   };
+  enum yytokentype
+  {
+    T_MAINMENU = 258,
+    T_MENU = 259,
+    T_ENDMENU = 260,
+    T_SOURCE = 261,
+    T_CHOICE = 262,
+    T_ENDCHOICE = 263,
+    T_COMMENT = 264,
+    T_CONFIG = 265,
+    T_MENUCONFIG = 266,
+    T_HELP = 267,
+    T_HELPTEXT = 268,
+    T_IF = 269,
+    T_ENDIF = 270,
+    T_DEPENDS = 271,
+    T_OPTIONAL = 272,
+    T_PROMPT = 273,
+    T_TYPE = 274,
+    T_DEFAULT = 275,
+    T_SELECT = 276,
+    T_RANGE = 277,
+    T_VISIBLE = 278,
+    T_OPTION = 279,
+    T_ON = 280,
+    T_WORD = 281,
+    T_WORD_QUOTE = 282,
+    T_UNEQUAL = 283,
+    T_CLOSE_PAREN = 284,
+    T_OPEN_PAREN = 285,
+    T_EOL = 286,
+    T_OR = 287,
+    T_AND = 288,
+    T_EQUAL = 289,
+    T_NOT = 290
+  };
 #endif
 
-
-
+/* Value type.  */
 #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
-typedef union YYSTYPE
+typedef union YYSTYPE YYSTYPE;
+union YYSTYPE
 {
 
 
@@ -184,14 +187,18 @@ typedef union YYSTYPE
 	const struct kconf_id *id;
 
 
-
-} YYSTYPE;
+};
 # define YYSTYPE_IS_TRIVIAL 1
-# define yystype YYSTYPE /* obsolescent; will be withdrawn */
 # define YYSTYPE_IS_DECLARED 1
 #endif
 
 
+extern YYSTYPE zconflval;
+
+int zconfparse (void);
+
+
+
 /* Copy the second part of user declarations.  */
 
 
@@ -212,11 +219,8 @@ typedef unsigned char yytype_uint8;
 
 #ifdef YYTYPE_INT8
 typedef YYTYPE_INT8 yytype_int8;
-#elif (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
-typedef signed char yytype_int8;
 #else
-typedef short int yytype_int8;
+typedef signed char yytype_int8;
 #endif
 
 #ifdef YYTYPE_UINT16
@@ -236,8 +240,7 @@ typedef short int yytype_int16;
 #  define YYSIZE_T __SIZE_TYPE__
 # elif defined size_t
 #  define YYSIZE_T size_t
-# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
+# elif ! defined YYSIZE_T
 #  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
 #  define YYSIZE_T size_t
 # else
@@ -251,38 +254,67 @@ typedef short int yytype_int16;
 # if defined YYENABLE_NLS && YYENABLE_NLS
 #  if ENABLE_NLS
 #   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
-#   define YY_(msgid) dgettext ("bison-runtime", msgid)
+#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
 #  endif
 # endif
 # ifndef YY_
-#  define YY_(msgid) msgid
+#  define YY_(Msgid) Msgid
+# endif
+#endif
+
+#ifndef YY_ATTRIBUTE
+# if (defined __GNUC__                                               \
+      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
+     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
+#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
+# else
+#  define YY_ATTRIBUTE(Spec) /* empty */
+# endif
+#endif
+
+#ifndef YY_ATTRIBUTE_PURE
+# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
+#endif
+
+#ifndef YY_ATTRIBUTE_UNUSED
+# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
+#endif
+
+#if !defined _Noreturn \
+     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
+# if defined _MSC_VER && 1200 <= _MSC_VER
+#  define _Noreturn __declspec (noreturn)
+# else
+#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
 # endif
 #endif
 
 /* Suppress unused-variable warnings by "using" E.  */
 #if ! defined lint || defined __GNUC__
-# define YYUSE(e) ((void) (e))
+# define YYUSE(E) ((void) (E))
 #else
-# define YYUSE(e) /* empty */
+# define YYUSE(E) /* empty */
 #endif
 
-/* Identity function, used to suppress warnings about constant conditions.  */
-#ifndef lint
-# define YYID(n) (n)
-#else
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
-static int
-YYID (int yyi)
+#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
+/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
+# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
+    _Pragma ("GCC diagnostic push") \
+    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
+    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
+# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
+    _Pragma ("GCC diagnostic pop")
 #else
-static int
-YYID (yyi)
-    int yyi;
+# define YY_INITIAL_VALUE(Value) Value
 #endif
-{
-  return yyi;
-}
+#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
+# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
+# define YY_IGNORE_MAYBE_UNINITIALIZED_END
 #endif
+#ifndef YY_INITIAL_VALUE
+# define YY_INITIAL_VALUE(Value) /* Nothing. */
+#endif
+
 
 #if ! defined yyoverflow || YYERROR_VERBOSE
 
@@ -301,9 +333,9 @@ YYID (yyi)
 #    define alloca _alloca
 #   else
 #    define YYSTACK_ALLOC alloca
-#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
+#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
 #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
+      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
 #     ifndef EXIT_SUCCESS
 #      define EXIT_SUCCESS 0
 #     endif
@@ -313,8 +345,8 @@ YYID (yyi)
 # endif
 
 # ifdef YYSTACK_ALLOC
-   /* Pacify GCC's `empty if-body' warning.  */
-#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
+   /* Pacify GCC's 'empty if-body' warning.  */
+#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
 #  ifndef YYSTACK_ALLOC_MAXIMUM
     /* The OS might guarantee only one guard page at the bottom of the stack,
        and a page size can be as small as 4096 bytes.  So we cannot safely
@@ -330,7 +362,7 @@ YYID (yyi)
 #  endif
 #  if (defined __cplusplus && ! defined EXIT_SUCCESS \
        && ! ((defined YYMALLOC || defined malloc) \
-	     && (defined YYFREE || defined free)))
+             && (defined YYFREE || defined free)))
 #   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
 #   ifndef EXIT_SUCCESS
 #    define EXIT_SUCCESS 0
@@ -338,15 +370,13 @@ YYID (yyi)
 #  endif
 #  ifndef YYMALLOC
 #   define YYMALLOC malloc
-#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
+#   if ! defined malloc && ! defined EXIT_SUCCESS
 void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
 #   endif
 #  endif
 #  ifndef YYFREE
 #   define YYFREE free
-#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
+#   if ! defined free && ! defined EXIT_SUCCESS
 void free (void *); /* INFRINGES ON USER NAME SPACE */
 #   endif
 #  endif
@@ -356,7 +386,7 @@ void free (void *); /* INFRINGES ON USER NAME SPACE */
 
 #if (! defined yyoverflow \
      && (! defined __cplusplus \
-	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
+         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
 
 /* A type that is properly aligned for any stack member.  */
 union yyalloc
@@ -381,35 +411,35 @@ union yyalloc
    elements in the stack, and YYPTR gives the new location of the
    stack.  Advance YYPTR to a properly aligned location for the next
    stack.  */
-# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
-    do									\
-      {									\
-	YYSIZE_T yynewbytes;						\
-	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
-	Stack = &yyptr->Stack_alloc;					\
-	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
-	yyptr += yynewbytes / sizeof (*yyptr);				\
-      }									\
-    while (YYID (0))
+# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
+    do                                                                  \
+      {                                                                 \
+        YYSIZE_T yynewbytes;                                            \
+        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
+        Stack = &yyptr->Stack_alloc;                                    \
+        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
+        yyptr += yynewbytes / sizeof (*yyptr);                          \
+      }                                                                 \
+    while (0)
 
 #endif
 
 #if defined YYCOPY_NEEDED && YYCOPY_NEEDED
-/* Copy COUNT objects from FROM to TO.  The source and destination do
+/* Copy COUNT objects from SRC to DST.  The source and destination do
    not overlap.  */
 # ifndef YYCOPY
 #  if defined __GNUC__ && 1 < __GNUC__
-#   define YYCOPY(To, From, Count) \
-      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
+#   define YYCOPY(Dst, Src, Count) \
+      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
 #  else
-#   define YYCOPY(To, From, Count)		\
-      do					\
-	{					\
-	  YYSIZE_T yyi;				\
-	  for (yyi = 0; yyi < (Count); yyi++)	\
-	    (To)[yyi] = (From)[yyi];		\
-	}					\
-      while (YYID (0))
+#   define YYCOPY(Dst, Src, Count)              \
+      do                                        \
+        {                                       \
+          YYSIZE_T yyi;                         \
+          for (yyi = 0; yyi < (Count); yyi++)   \
+            (Dst)[yyi] = (Src)[yyi];            \
+        }                                       \
+      while (0)
 #  endif
 # endif
 #endif /* !YYCOPY_NEEDED */
@@ -425,17 +455,19 @@ union yyalloc
 #define YYNNTS  50
 /* YYNRULES -- Number of rules.  */
 #define YYNRULES  118
-/* YYNRULES -- Number of states.  */
+/* YYNSTATES -- Number of states.  */
 #define YYNSTATES  191
 
-/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
+/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
+   by yylex, with out-of-bounds checking.  */
 #define YYUNDEFTOK  2
 #define YYMAXUTOK   290
 
-#define YYTRANSLATE(YYX)						\
+#define YYTRANSLATE(YYX)                                                \
   ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
 
-/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
+/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
+   as returned by yylex, without out-of-bounds checking.  */
 static const yytype_uint8 yytranslate[] =
 {
        0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
@@ -471,65 +503,7 @@ static const yytype_uint8 yytranslate[] =
 };
 
 #if YYDEBUG
-/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
-   YYRHS.  */
-static const yytype_uint16 yyprhs[] =
-{
-       0,     0,     3,     6,     8,    11,    13,    14,    17,    20,
-      23,    26,    31,    36,    40,    42,    44,    46,    48,    50,
-      52,    54,    56,    58,    60,    62,    64,    66,    68,    72,
-      75,    79,    82,    86,    89,    90,    93,    96,    99,   102,
-     105,   108,   112,   117,   122,   127,   133,   137,   138,   142,
-     143,   146,   150,   153,   155,   159,   160,   163,   166,   169,
-     172,   175,   180,   184,   187,   192,   193,   196,   200,   202,
-     206,   207,   210,   213,   216,   220,   224,   228,   230,   234,
-     235,   238,   241,   244,   248,   252,   255,   258,   261,   262,
-     265,   268,   271,   276,   277,   280,   283,   286,   287,   290,
-     292,   294,   297,   300,   303,   305,   308,   309,   312,   314,
-     318,   322,   326,   329,   333,   337,   339,   341,   342
-};
-
-/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
-static const yytype_int8 yyrhs[] =
-{
-      37,     0,    -1,    81,    38,    -1,    38,    -1,    63,    39,
-      -1,    39,    -1,    -1,    39,    41,    -1,    39,    55,    -1,
-      39,    67,    -1,    39,    80,    -1,    39,    26,     1,    31,
-      -1,    39,    40,     1,    31,    -1,    39,     1,    31,    -1,
-      16,    -1,    18,    -1,    19,    -1,    21,    -1,    17,    -1,
-      22,    -1,    20,    -1,    23,    -1,    31,    -1,    61,    -1,
-      71,    -1,    44,    -1,    46,    -1,    69,    -1,    26,     1,
-      31,    -1,     1,    31,    -1,    10,    26,    31,    -1,    43,
-      47,    -1,    11,    26,    31,    -1,    45,    47,    -1,    -1,
-      47,    48,    -1,    47,    49,    -1,    47,    75,    -1,    47,
-      73,    -1,    47,    42,    -1,    47,    31,    -1,    19,    78,
-      31,    -1,    18,    79,    82,    31,    -1,    20,    83,    82,
-      31,    -1,    21,    26,    82,    31,    -1,    22,    84,    84,
-      82,    31,    -1,    24,    50,    31,    -1,    -1,    50,    26,
-      51,    -1,    -1,    34,    79,    -1,     7,    85,    31,    -1,
-      52,    56,    -1,    80,    -1,    53,    58,    54,    -1,    -1,
-      56,    57,    -1,    56,    75,    -1,    56,    73,    -1,    56,
-      31,    -1,    56,    42,    -1,    18,    79,    82,    31,    -1,
-      19,    78,    31,    -1,    17,    31,    -1,    20,    26,    82,
-      31,    -1,    -1,    58,    41,    -1,    14,    83,    81,    -1,
-      80,    -1,    59,    62,    60,    -1,    -1,    62,    41,    -1,
-      62,    67,    -1,    62,    55,    -1,     3,    79,    81,    -1,
-       4,    79,    31,    -1,    64,    76,    74,    -1,    80,    -1,
-      65,    68,    66,    -1,    -1,    68,    41,    -1,    68,    67,
-      -1,    68,    55,    -1,     6,    79,    31,    -1,     9,    79,
-      31,    -1,    70,    74,    -1,    12,    31,    -1,    72,    13,
-      -1,    -1,    74,    75,    -1,    74,    31,    -1,    74,    42,
-      -1,    16,    25,    83,    31,    -1,    -1,    76,    77,    -1,
-      76,    31,    -1,    23,    82,    -1,    -1,    79,    82,    -1,
-      26,    -1,    27,    -1,     5,    31,    -1,     8,    31,    -1,
-      15,    31,    -1,    31,    -1,    81,    31,    -1,    -1,    14,
-      83,    -1,    84,    -1,    84,    34,    84,    -1,    84,    28,
-      84,    -1,    30,    83,    29,    -1,    35,    83,    -1,    83,
-      32,    83,    -1,    83,    33,    83,    -1,    26,    -1,    27,
-      -1,    -1,    26,    -1
-};
-
-/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
+  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
        0,   103,   103,   103,   105,   105,   107,   109,   110,   111,
@@ -547,7 +521,7 @@ static const yytype_uint16 yyrline[] =
 };
 #endif
 
-#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
+#if YYDEBUG || YYERROR_VERBOSE || 0
 /* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
    First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
 static const char *const yytname[] =
@@ -568,13 +542,13 @@ static const char *const yytname[] =
   "menu_entry", "menu_end", "menu_stmt", "menu_block", "source_stmt",
   "comment", "comment_stmt", "help_start", "help", "depends_list",
   "depends", "visibility_list", "visible", "prompt_stmt_opt", "prompt",
-  "end", "nl", "if_expr", "expr", "symbol", "word_opt", 0
+  "end", "nl", "if_expr", "expr", "symbol", "word_opt", YY_NULLPTR
 };
 #endif
 
 # ifdef YYPRINT
-/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
-   token YYLEX-NUM.  */
+/* YYTOKNUM[NUM] -- (External) token number corresponding to the
+   (internal) symbol number NUM (which must be that of a token).  */
 static const yytype_uint16 yytoknum[] =
 {
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
@@ -584,80 +558,18 @@ static const yytype_uint16 yytoknum[] =
 };
 # endif
 
-/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
-static const yytype_uint8 yyr1[] =
-{
-       0,    36,    37,    37,    38,    38,    39,    39,    39,    39,
-      39,    39,    39,    39,    40,    40,    40,    40,    40,    40,
-      40,    40,    41,    41,    41,    41,    41,    41,    42,    42,
-      43,    44,    45,    46,    47,    47,    47,    47,    47,    47,
-      47,    48,    48,    48,    48,    48,    49,    50,    50,    51,
-      51,    52,    53,    54,    55,    56,    56,    56,    56,    56,
-      56,    57,    57,    57,    57,    58,    58,    59,    60,    61,
-      62,    62,    62,    62,    63,    64,    65,    66,    67,    68,
-      68,    68,    68,    69,    70,    71,    72,    73,    74,    74,
-      74,    74,    75,    76,    76,    76,    77,    78,    78,    79,
-      79,    80,    80,    80,    81,    81,    82,    82,    83,    83,
-      83,    83,    83,    83,    83,    84,    84,    85,    85
-};
+#define YYPACT_NINF -90
 
-/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
-static const yytype_uint8 yyr2[] =
-{
-       0,     2,     2,     1,     2,     1,     0,     2,     2,     2,
-       2,     4,     4,     3,     1,     1,     1,     1,     1,     1,
-       1,     1,     1,     1,     1,     1,     1,     1,     3,     2,
-       3,     2,     3,     2,     0,     2,     2,     2,     2,     2,
-       2,     3,     4,     4,     4,     5,     3,     0,     3,     0,
-       2,     3,     2,     1,     3,     0,     2,     2,     2,     2,
-       2,     4,     3,     2,     4,     0,     2,     3,     1,     3,
-       0,     2,     2,     2,     3,     3,     3,     1,     3,     0,
-       2,     2,     2,     3,     3,     2,     2,     2,     0,     2,
-       2,     2,     4,     0,     2,     2,     2,     0,     2,     1,
-       1,     2,     2,     2,     1,     2,     0,     2,     1,     3,
-       3,     3,     2,     3,     3,     1,     1,     0,     1
-};
+#define yypact_value_is_default(Yystate) \
+  (!!((Yystate) == (-90)))
 
-/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
-   Performed when YYTABLE doesn't specify something else to do.  Zero
-   means the default is an error.  */
-static const yytype_uint8 yydefact[] =
-{
-       6,     0,   104,     0,     3,     0,     6,     6,    99,   100,
-       0,     1,     0,     0,     0,     0,   117,     0,     0,     0,
-       0,     0,     0,    14,    18,    15,    16,    20,    17,    19,
-      21,     0,    22,     0,     7,    34,    25,    34,    26,    55,
-      65,     8,    70,    23,    93,    79,     9,    27,    88,    24,
-      10,     0,   105,     2,    74,    13,     0,   101,     0,   118,
-       0,   102,     0,     0,     0,   115,   116,     0,     0,     0,
-     108,   103,     0,     0,     0,     0,     0,     0,     0,    88,
-       0,     0,    75,    83,    51,    84,    30,    32,     0,   112,
-       0,     0,    67,     0,     0,    11,    12,     0,     0,     0,
-       0,    97,     0,     0,     0,    47,     0,    40,    39,    35,
-      36,     0,    38,    37,     0,     0,    97,     0,    59,    60,
-      56,    58,    57,    66,    54,    53,    71,    73,    69,    72,
-      68,   106,    95,     0,    94,    80,    82,    78,    81,    77,
-      90,    91,    89,   111,   113,   114,   110,   109,    29,    86,
-       0,   106,     0,   106,   106,   106,     0,     0,     0,    87,
-      63,   106,     0,   106,     0,    96,     0,     0,    41,    98,
-       0,     0,   106,    49,    46,    28,     0,    62,     0,   107,
-      92,    42,    43,    44,     0,     0,    48,    61,    64,    45,
-      50
-};
+#define YYTABLE_NINF -86
 
-/* YYDEFGOTO[NTERM-NUM].  */
-static const yytype_int16 yydefgoto[] =
-{
-      -1,     3,     4,     5,    33,    34,   108,    35,    36,    37,
-      38,    74,   109,   110,   157,   186,    39,    40,   124,    41,
-      76,   120,    77,    42,   128,    43,    78,     6,    44,    45,
-     137,    46,    80,    47,    48,    49,   111,   112,    81,   113,
-      79,   134,   152,   153,    50,     7,   165,    69,    70,    60
-};
+#define yytable_value_is_error(Yytable_value) \
+  0
 
-/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
-   STATE-NUM.  */
-#define YYPACT_NINF -90
+  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
+     STATE-NUM.  */
 static const yytype_int16 yypact[] =
 {
        4,    42,   -90,    96,   -90,   111,   -90,    15,   -90,   -90,
@@ -682,7 +594,34 @@ static const yytype_int16 yypact[] =
      -90
 };
 
-/* YYPGOTO[NTERM-NUM].  */
+  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
+     Performed when YYTABLE does not specify something else to do.  Zero
+     means the default is an error.  */
+static const yytype_uint8 yydefact[] =
+{
+       6,     0,   104,     0,     3,     0,     6,     6,    99,   100,
+       0,     1,     0,     0,     0,     0,   117,     0,     0,     0,
+       0,     0,     0,    14,    18,    15,    16,    20,    17,    19,
+      21,     0,    22,     0,     7,    34,    25,    34,    26,    55,
+      65,     8,    70,    23,    93,    79,     9,    27,    88,    24,
+      10,     0,   105,     2,    74,    13,     0,   101,     0,   118,
+       0,   102,     0,     0,     0,   115,   116,     0,     0,     0,
+     108,   103,     0,     0,     0,     0,     0,     0,     0,    88,
+       0,     0,    75,    83,    51,    84,    30,    32,     0,   112,
+       0,     0,    67,     0,     0,    11,    12,     0,     0,     0,
+       0,    97,     0,     0,     0,    47,     0,    40,    39,    35,
+      36,     0,    38,    37,     0,     0,    97,     0,    59,    60,
+      56,    58,    57,    66,    54,    53,    71,    73,    69,    72,
+      68,   106,    95,     0,    94,    80,    82,    78,    81,    77,
+      90,    91,    89,   111,   113,   114,   110,   109,    29,    86,
+       0,   106,     0,   106,   106,   106,     0,     0,     0,    87,
+      63,   106,     0,   106,     0,    96,     0,     0,    41,    98,
+       0,     0,   106,    49,    46,    28,     0,    62,     0,   107,
+      92,    42,    43,    44,     0,     0,    48,    61,    64,    45,
+      50
+};
+
+  /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
      -90,   -90,   269,   271,   -90,    23,   -70,   -90,   -90,   -90,
@@ -692,10 +631,19 @@ static const yytype_int16 yypgoto[] =
      -90,   -90,   169,    -1,    27,    -7,   118,   -66,   -89,   -90
 };
 
-/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
-   positive, shift that token.  If negative, reduce the rule which
-   number is the opposite.  If YYTABLE_NINF, syntax error.  */
-#define YYTABLE_NINF -86
+  /* YYDEFGOTO[NTERM-NUM].  */
+static const yytype_int16 yydefgoto[] =
+{
+      -1,     3,     4,     5,    33,    34,   108,    35,    36,    37,
+      38,    74,   109,   110,   157,   186,    39,    40,   124,    41,
+      76,   120,    77,    42,   128,    43,    78,     6,    44,    45,
+     137,    46,    80,    47,    48,    49,   111,   112,    81,   113,
+      79,   134,   152,   153,    50,     7,   165,    69,    70,    60
+};
+
+  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
+     positive, shift that token.  If negative, reduce the rule whose
+     number is the opposite.  If YYTABLE_NINF, syntax error.  */
 static const yytype_int16 yytable[] =
 {
       10,    88,    89,    54,   146,   147,   119,     1,   122,   164,
@@ -730,12 +678,6 @@ static const yytype_int16 yytable[] =
      184
 };
 
-#define yypact_value_is_default(yystate) \
-  ((yystate) == (-90))
-
-#define yytable_value_is_error(yytable_value) \
-  YYID (0)
-
 static const yytype_int16 yycheck[] =
 {
        1,    67,    68,    10,    93,    94,    76,     3,    76,    14,
@@ -770,8 +712,8 @@ static const yytype_int16 yycheck[] =
      172
 };
 
-/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
-   symbol of state STATE-NUM.  */
+  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
+     symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
        0,     3,    31,    37,    38,    39,    63,    81,    26,    27,
@@ -796,94 +738,75 @@ static const yytype_uint8 yystos[] =
       79
 };
 
-#define yyerrok		(yyerrstatus = 0)
-#define yyclearin	(yychar = YYEMPTY)
-#define YYEMPTY		(-2)
-#define YYEOF		0
-
-#define YYACCEPT	goto yyacceptlab
-#define YYABORT		goto yyabortlab
-#define YYERROR		goto yyerrorlab
-
-
-/* Like YYERROR except do call yyerror.  This remains here temporarily
-   to ease the transition to the new meaning of YYERROR, for GCC.
-   Once GCC version 2 has supplanted version 1, this can go.  However,
-   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
-   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
-   discussed.  */
-
-#define YYFAIL		goto yyerrlab
-#if defined YYFAIL
-  /* This is here to suppress warnings from the GCC cpp's
-     -Wunused-macros.  Normally we don't worry about that warning, but
-     some users do, and we want to make it easy for users to remove
-     YYFAIL uses, which will produce warnings from Bison 2.5.  */
-#endif
+  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
+static const yytype_uint8 yyr1[] =
+{
+       0,    36,    37,    37,    38,    38,    39,    39,    39,    39,
+      39,    39,    39,    39,    40,    40,    40,    40,    40,    40,
+      40,    40,    41,    41,    41,    41,    41,    41,    42,    42,
+      43,    44,    45,    46,    47,    47,    47,    47,    47,    47,
+      47,    48,    48,    48,    48,    48,    49,    50,    50,    51,
+      51,    52,    53,    54,    55,    56,    56,    56,    56,    56,
+      56,    57,    57,    57,    57,    58,    58,    59,    60,    61,
+      62,    62,    62,    62,    63,    64,    65,    66,    67,    68,
+      68,    68,    68,    69,    70,    71,    72,    73,    74,    74,
+      74,    74,    75,    76,    76,    76,    77,    78,    78,    79,
+      79,    80,    80,    80,    81,    81,    82,    82,    83,    83,
+      83,    83,    83,    83,    83,    84,    84,    85,    85
+};
 
-#define YYRECOVERING()  (!!yyerrstatus)
+  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
+static const yytype_uint8 yyr2[] =
+{
+       0,     2,     2,     1,     2,     1,     0,     2,     2,     2,
+       2,     4,     4,     3,     1,     1,     1,     1,     1,     1,
+       1,     1,     1,     1,     1,     1,     1,     1,     3,     2,
+       3,     2,     3,     2,     0,     2,     2,     2,     2,     2,
+       2,     3,     4,     4,     4,     5,     3,     0,     3,     0,
+       2,     3,     2,     1,     3,     0,     2,     2,     2,     2,
+       2,     4,     3,     2,     4,     0,     2,     3,     1,     3,
+       0,     2,     2,     2,     3,     3,     3,     1,     3,     0,
+       2,     2,     2,     3,     3,     2,     2,     2,     0,     2,
+       2,     2,     4,     0,     2,     2,     2,     0,     2,     1,
+       1,     2,     2,     2,     1,     2,     0,     2,     1,     3,
+       3,     3,     2,     3,     3,     1,     1,     0,     1
+};
 
-#define YYBACKUP(Token, Value)					\
-do								\
-  if (yychar == YYEMPTY && yylen == 1)				\
-    {								\
-      yychar = (Token);						\
-      yylval = (Value);						\
-      YYPOPSTACK (1);						\
-      goto yybackup;						\
-    }								\
-  else								\
-    {								\
-      yyerror (YY_("syntax error: cannot back up")); \
-      YYERROR;							\
-    }								\
-while (YYID (0))
-
-
-#define YYTERROR	1
-#define YYERRCODE	256
-
-
-/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
-   If N is 0, then set CURRENT to the empty location which ends
-   the previous symbol: RHS[0] (always defined).  */
-
-#define YYRHSLOC(Rhs, K) ((Rhs)[K])
-#ifndef YYLLOC_DEFAULT
-# define YYLLOC_DEFAULT(Current, Rhs, N)				\
-    do									\
-      if (YYID (N))                                                    \
-	{								\
-	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
-	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
-	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
-	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
-	}								\
-      else								\
-	{								\
-	  (Current).first_line   = (Current).last_line   =		\
-	    YYRHSLOC (Rhs, 0).last_line;				\
-	  (Current).first_column = (Current).last_column =		\
-	    YYRHSLOC (Rhs, 0).last_column;				\
-	}								\
-    while (YYID (0))
-#endif
 
+#define yyerrok         (yyerrstatus = 0)
+#define yyclearin       (yychar = YYEMPTY)
+#define YYEMPTY         (-2)
+#define YYEOF           0
 
-/* This macro is provided for backward compatibility. */
+#define YYACCEPT        goto yyacceptlab
+#define YYABORT         goto yyabortlab
+#define YYERROR         goto yyerrorlab
 
-#ifndef YY_LOCATION_PRINT
-# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
-#endif
 
+#define YYRECOVERING()  (!!yyerrstatus)
+
+#define YYBACKUP(Token, Value)                                  \
+do                                                              \
+  if (yychar == YYEMPTY)                                        \
+    {                                                           \
+      yychar = (Token);                                         \
+      yylval = (Value);                                         \
+      YYPOPSTACK (yylen);                                       \
+      yystate = *yyssp;                                         \
+      goto yybackup;                                            \
+    }                                                           \
+  else                                                          \
+    {                                                           \
+      yyerror (YY_("syntax error: cannot back up")); \
+      YYERROR;                                                  \
+    }                                                           \
+while (0)
+
+/* Error token number */
+#define YYTERROR        1
+#define YYERRCODE       256
 
-/* YYLEX -- calling `yylex' with the right arguments.  */
 
-#ifdef YYLEX_PARAM
-# define YYLEX yylex (YYLEX_PARAM)
-#else
-# define YYLEX yylex ()
-#endif
 
 /* Enable debugging if requested.  */
 #if YYDEBUG
@@ -893,54 +816,46 @@ while (YYID (0))
 #  define YYFPRINTF fprintf
 # endif
 
-# define YYDPRINTF(Args)			\
-do {						\
-  if (yydebug)					\
-    YYFPRINTF Args;				\
-} while (YYID (0))
+# define YYDPRINTF(Args)                        \
+do {                                            \
+  if (yydebug)                                  \
+    YYFPRINTF Args;                             \
+} while (0)
 
-# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
-do {									  \
-  if (yydebug)								  \
-    {									  \
-      YYFPRINTF (stderr, "%s ", Title);					  \
-      yy_symbol_print (stderr,						  \
-		  Type, Value); \
-      YYFPRINTF (stderr, "\n");						  \
-    }									  \
-} while (YYID (0))
+/* This macro is provided for backward compatibility. */
+#ifndef YY_LOCATION_PRINT
+# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
+#endif
 
 
-/*--------------------------------.
-| Print this symbol on YYOUTPUT.  |
-`--------------------------------*/
+# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
+do {                                                                      \
+  if (yydebug)                                                            \
+    {                                                                     \
+      YYFPRINTF (stderr, "%s ", Title);                                   \
+      yy_symbol_print (stderr,                                            \
+                  Type, Value); \
+      YYFPRINTF (stderr, "\n");                                           \
+    }                                                                     \
+} while (0)
+
+
+/*----------------------------------------.
+| Print this symbol's value on YYOUTPUT.  |
+`----------------------------------------*/
 
-/*ARGSUSED*/
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
 static void
 yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
-#else
-static void
-yy_symbol_value_print (yyoutput, yytype, yyvaluep)
-    FILE *yyoutput;
-    int yytype;
-    YYSTYPE const * const yyvaluep;
-#endif
 {
+  FILE *yyo = yyoutput;
+  YYUSE (yyo);
   if (!yyvaluep)
     return;
 # ifdef YYPRINT
   if (yytype < YYNTOKENS)
     YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
-# else
-  YYUSE (yyoutput);
 # endif
-  switch (yytype)
-    {
-      default:
-	break;
-    }
+  YYUSE (yytype);
 }
 
 
@@ -948,22 +863,11 @@ yy_symbol_value_print (yyoutput, yytype, yyvaluep)
 | Print this symbol on YYOUTPUT.  |
 `--------------------------------*/
 
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
 static void
 yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
-#else
-static void
-yy_symbol_print (yyoutput, yytype, yyvaluep)
-    FILE *yyoutput;
-    int yytype;
-    YYSTYPE const * const yyvaluep;
-#endif
 {
-  if (yytype < YYNTOKENS)
-    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
-  else
-    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);
+  YYFPRINTF (yyoutput, "%s %s (",
+             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);
 
   yy_symbol_value_print (yyoutput, yytype, yyvaluep);
   YYFPRINTF (yyoutput, ")");
@@ -974,16 +878,8 @@ yy_symbol_print (yyoutput, yytype, yyvaluep)
 | TOP (included).                                                   |
 `------------------------------------------------------------------*/
 
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
 static void
 yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
-#else
-static void
-yy_stack_print (yybottom, yytop)
-    yytype_int16 *yybottom;
-    yytype_int16 *yytop;
-#endif
 {
   YYFPRINTF (stderr, "Stack now");
   for (; yybottom <= yytop; yybottom++)
@@ -994,49 +890,42 @@ yy_stack_print (yybottom, yytop)
   YYFPRINTF (stderr, "\n");
 }
 
-# define YY_STACK_PRINT(Bottom, Top)				\
-do {								\
-  if (yydebug)							\
-    yy_stack_print ((Bottom), (Top));				\
-} while (YYID (0))
+# define YY_STACK_PRINT(Bottom, Top)                            \
+do {                                                            \
+  if (yydebug)                                                  \
+    yy_stack_print ((Bottom), (Top));                           \
+} while (0)
 
 
 /*------------------------------------------------.
 | Report that the YYRULE is going to be reduced.  |
 `------------------------------------------------*/
 
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
-static void
-yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
-#else
 static void
-yy_reduce_print (yyvsp, yyrule)
-    YYSTYPE *yyvsp;
-    int yyrule;
-#endif
+yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
 {
+  unsigned long int yylno = yyrline[yyrule];
   int yynrhs = yyr2[yyrule];
   int yyi;
-  unsigned long int yylno = yyrline[yyrule];
   YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
-	     yyrule - 1, yylno);
+             yyrule - 1, yylno);
   /* The symbols being reduced.  */
   for (yyi = 0; yyi < yynrhs; yyi++)
     {
       YYFPRINTF (stderr, "   $%d = ", yyi + 1);
-      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
-		       &(yyvsp[(yyi + 1) - (yynrhs)])
-		       		       );
+      yy_symbol_print (stderr,
+                       yystos[yyssp[yyi + 1 - yynrhs]],
+                       &(yyvsp[(yyi + 1) - (yynrhs)])
+                                              );
       YYFPRINTF (stderr, "\n");
     }
 }
 
-# define YY_REDUCE_PRINT(Rule)		\
-do {					\
-  if (yydebug)				\
-    yy_reduce_print (yyvsp, Rule); \
-} while (YYID (0))
+# define YY_REDUCE_PRINT(Rule)          \
+do {                                    \
+  if (yydebug)                          \
+    yy_reduce_print (yyssp, yyvsp, Rule); \
+} while (0)
 
 /* Nonzero means print parse trace.  It is left uninitialized so that
    multiple parsers can coexist.  */
@@ -1050,7 +939,7 @@ int yydebug;
 
 
 /* YYINITDEPTH -- initial size of the parser's stacks.  */
-#ifndef	YYINITDEPTH
+#ifndef YYINITDEPTH
 # define YYINITDEPTH 200
 #endif
 
@@ -1073,15 +962,8 @@ int yydebug;
 #   define yystrlen strlen
 #  else
 /* Return the length of YYSTR.  */
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
 static YYSIZE_T
 yystrlen (const char *yystr)
-#else
-static YYSIZE_T
-yystrlen (yystr)
-    const char *yystr;
-#endif
 {
   YYSIZE_T yylen;
   for (yylen = 0; yystr[yylen]; yylen++)
@@ -1097,16 +979,8 @@ yystrlen (yystr)
 #  else
 /* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
    YYDEST.  */
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
 static char *
 yystpcpy (char *yydest, const char *yysrc)
-#else
-static char *
-yystpcpy (yydest, yysrc)
-    char *yydest;
-    const char *yysrc;
-#endif
 {
   char *yyd = yydest;
   const char *yys = yysrc;
@@ -1136,27 +1010,27 @@ yytnamerr (char *yyres, const char *yystr)
       char const *yyp = yystr;
 
       for (;;)
-	switch (*++yyp)
-	  {
-	  case '\'':
-	  case ',':
-	    goto do_not_strip_quotes;
-
-	  case '\\':
-	    if (*++yyp != '\\')
-	      goto do_not_strip_quotes;
-	    /* Fall through.  */
-	  default:
-	    if (yyres)
-	      yyres[yyn] = *yyp;
-	    yyn++;
-	    break;
-
-	  case '"':
-	    if (yyres)
-	      yyres[yyn] = '\0';
-	    return yyn;
-	  }
+        switch (*++yyp)
+          {
+          case '\'':
+          case ',':
+            goto do_not_strip_quotes;
+
+          case '\\':
+            if (*++yyp != '\\')
+              goto do_not_strip_quotes;
+            /* Fall through.  */
+          default:
+            if (yyres)
+              yyres[yyn] = *yyp;
+            yyn++;
+            break;
+
+          case '"':
+            if (yyres)
+              yyres[yyn] = '\0';
+            return yyn;
+          }
     do_not_strip_quotes: ;
     }
 
@@ -1179,12 +1053,11 @@ static int
 yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                 yytype_int16 *yyssp, int yytoken)
 {
-  YYSIZE_T yysize0 = yytnamerr (0, yytname[yytoken]);
+  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
   YYSIZE_T yysize = yysize0;
-  YYSIZE_T yysize1;
   enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
   /* Internationalized format string. */
-  const char *yyformat = 0;
+  const char *yyformat = YY_NULLPTR;
   /* Arguments of yyformat. */
   char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
   /* Number of reported tokens (one for the "unexpected", one per
@@ -1192,10 +1065,6 @@ yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
   int yycount = 0;
 
   /* There are many possibilities here to consider:
-     - Assume YYFAIL is not used.  It's too flawed to consider.  See
-       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
-       for details.  YYERROR is fine as it does not invoke this
-       function.
      - If this state is a consistent state with a default action, then
        the only way this function was invoked is if the default action
        is an error action.  In that case, don't check for expected
@@ -1244,11 +1113,13 @@ yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                     break;
                   }
                 yyarg[yycount++] = yytname[yyx];
-                yysize1 = yysize + yytnamerr (0, yytname[yyx]);
-                if (! (yysize <= yysize1
-                       && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
-                  return 2;
-                yysize = yysize1;
+                {
+                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
+                  if (! (yysize <= yysize1
+                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+                    return 2;
+                  yysize = yysize1;
+                }
               }
         }
     }
@@ -1268,10 +1139,12 @@ yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
 # undef YYCASE_
     }
 
-  yysize1 = yysize + yystrlen (yyformat);
-  if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
-    return 2;
-  yysize = yysize1;
+  {
+    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
+    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+      return 2;
+    yysize = yysize1;
+  }
 
   if (*yymsg_alloc < yysize)
     {
@@ -1308,78 +1181,58 @@ yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
 | Release the memory associated to this symbol.  |
 `-----------------------------------------------*/
 
-/*ARGSUSED*/
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
 static void
 yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
-#else
-static void
-yydestruct (yymsg, yytype, yyvaluep)
-    const char *yymsg;
-    int yytype;
-    YYSTYPE *yyvaluep;
-#endif
 {
   YYUSE (yyvaluep);
-
   if (!yymsg)
     yymsg = "Deleting";
   YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);
 
+  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
   switch (yytype)
     {
-      case 53: /* "choice_entry" */
+          case 53: /* choice_entry  */
 
-	{
+      {
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
-		(yyvaluep->menu)->file->name, (yyvaluep->menu)->lineno);
-	if (current_menu == (yyvaluep->menu))
+		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
+	if (current_menu == ((*yyvaluep).menu))
 		menu_end_menu();
-};
+}
+
+        break;
 
-	break;
-      case 59: /* "if_entry" */
+    case 59: /* if_entry  */
 
-	{
+      {
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
-		(yyvaluep->menu)->file->name, (yyvaluep->menu)->lineno);
-	if (current_menu == (yyvaluep->menu))
+		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
+	if (current_menu == ((*yyvaluep).menu))
 		menu_end_menu();
-};
+}
+
+        break;
 
-	break;
-      case 65: /* "menu_entry" */
+    case 65: /* menu_entry  */
 
-	{
+      {
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
-		(yyvaluep->menu)->file->name, (yyvaluep->menu)->lineno);
-	if (current_menu == (yyvaluep->menu))
+		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
+	if (current_menu == ((*yyvaluep).menu))
 		menu_end_menu();
-};
+}
+
+        break;
 
-	break;
 
       default:
-	break;
+        break;
     }
+  YY_IGNORE_MAYBE_UNINITIALIZED_END
 }
 
 
-/* Prevent warnings from -Wmissing-prototypes.  */
-#ifdef YYPARSE_PARAM
-#if defined __STDC__ || defined __cplusplus
-int yyparse (void *YYPARSE_PARAM);
-#else
-int yyparse ();
-#endif
-#else /* ! YYPARSE_PARAM */
-#if defined __STDC__ || defined __cplusplus
-int yyparse (void);
-#else
-int yyparse ();
-#endif
-#endif /* ! YYPARSE_PARAM */
 
 
 /* The lookahead symbol.  */
@@ -1387,7 +1240,6 @@ int yychar;
 
 /* The semantic value of the lookahead symbol.  */
 YYSTYPE yylval;
-
 /* Number of syntax errors so far.  */
 int yynerrs;
 
@@ -1396,37 +1248,18 @@ int yynerrs;
 | yyparse.  |
 `----------*/
 
-#ifdef YYPARSE_PARAM
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
-int
-yyparse (void *YYPARSE_PARAM)
-#else
-int
-yyparse (YYPARSE_PARAM)
-    void *YYPARSE_PARAM;
-#endif
-#else /* ! YYPARSE_PARAM */
-#if (defined __STDC__ || defined __C99__FUNC__ \
-     || defined __cplusplus || defined _MSC_VER)
 int
 yyparse (void)
-#else
-int
-yyparse ()
-
-#endif
-#endif
 {
     int yystate;
     /* Number of tokens to shift before error messages enabled.  */
     int yyerrstatus;
 
     /* The stacks and their tools:
-       `yyss': related to states.
-       `yyvs': related to semantic values.
+       'yyss': related to states.
+       'yyvs': related to semantic values.
 
-       Refer to the stacks thru separate pointers, to allow yyoverflow
+       Refer to the stacks through separate pointers, to allow yyoverflow
        to reallocate them elsewhere.  */
 
     /* The state stack.  */
@@ -1444,7 +1277,7 @@ yyparse ()
   int yyn;
   int yyresult;
   /* Lookahead token as an internal (translated) token number.  */
-  int yytoken;
+  int yytoken = 0;
   /* The variables used to return semantic value and location from the
      action routines.  */
   YYSTYPE yyval;
@@ -1462,9 +1295,8 @@ yyparse ()
      Keep to zero when no symbol should be popped.  */
   int yylen = 0;
 
-  yytoken = 0;
-  yyss = yyssa;
-  yyvs = yyvsa;
+  yyssp = yyss = yyssa;
+  yyvsp = yyvs = yyvsa;
   yystacksize = YYINITDEPTH;
 
   YYDPRINTF ((stderr, "Starting parse\n"));
@@ -1473,14 +1305,6 @@ yyparse ()
   yyerrstatus = 0;
   yynerrs = 0;
   yychar = YYEMPTY; /* Cause a token to be read.  */
-
-  /* Initialize stack pointers.
-     Waste one element of value and location stack
-     so that they stay on the same level as the state stack.
-     The wasted elements are never initialized.  */
-  yyssp = yyss;
-  yyvsp = yyvs;
-
   goto yysetstate;
 
 /*------------------------------------------------------------.
@@ -1501,23 +1325,23 @@ yyparse ()
 
 #ifdef yyoverflow
       {
-	/* Give user a chance to reallocate the stack.  Use copies of
-	   these so that the &'s don't force the real ones into
-	   memory.  */
-	YYSTYPE *yyvs1 = yyvs;
-	yytype_int16 *yyss1 = yyss;
-
-	/* Each stack pointer address is followed by the size of the
-	   data in use in that stack, in bytes.  This used to be a
-	   conditional around just the two extra args, but that might
-	   be undefined if yyoverflow is a macro.  */
-	yyoverflow (YY_("memory exhausted"),
-		    &yyss1, yysize * sizeof (*yyssp),
-		    &yyvs1, yysize * sizeof (*yyvsp),
-		    &yystacksize);
-
-	yyss = yyss1;
-	yyvs = yyvs1;
+        /* Give user a chance to reallocate the stack.  Use copies of
+           these so that the &'s don't force the real ones into
+           memory.  */
+        YYSTYPE *yyvs1 = yyvs;
+        yytype_int16 *yyss1 = yyss;
+
+        /* Each stack pointer address is followed by the size of the
+           data in use in that stack, in bytes.  This used to be a
+           conditional around just the two extra args, but that might
+           be undefined if yyoverflow is a macro.  */
+        yyoverflow (YY_("memory exhausted"),
+                    &yyss1, yysize * sizeof (*yyssp),
+                    &yyvs1, yysize * sizeof (*yyvsp),
+                    &yystacksize);
+
+        yyss = yyss1;
+        yyvs = yyvs1;
       }
 #else /* no yyoverflow */
 # ifndef YYSTACK_RELOCATE
@@ -1525,22 +1349,22 @@ yyparse ()
 # else
       /* Extend the stack our own way.  */
       if (YYMAXDEPTH <= yystacksize)
-	goto yyexhaustedlab;
+        goto yyexhaustedlab;
       yystacksize *= 2;
       if (YYMAXDEPTH < yystacksize)
-	yystacksize = YYMAXDEPTH;
+        yystacksize = YYMAXDEPTH;
 
       {
-	yytype_int16 *yyss1 = yyss;
-	union yyalloc *yyptr =
-	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
-	if (! yyptr)
-	  goto yyexhaustedlab;
-	YYSTACK_RELOCATE (yyss_alloc, yyss);
-	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
+        yytype_int16 *yyss1 = yyss;
+        union yyalloc *yyptr =
+          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
+        if (! yyptr)
+          goto yyexhaustedlab;
+        YYSTACK_RELOCATE (yyss_alloc, yyss);
+        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
 #  undef YYSTACK_RELOCATE
-	if (yyss1 != yyssa)
-	  YYSTACK_FREE (yyss1);
+        if (yyss1 != yyssa)
+          YYSTACK_FREE (yyss1);
       }
 # endif
 #endif /* no yyoverflow */
@@ -1549,10 +1373,10 @@ yyparse ()
       yyvsp = yyvs + yysize - 1;
 
       YYDPRINTF ((stderr, "Stack size increased to %lu\n",
-		  (unsigned long int) yystacksize));
+                  (unsigned long int) yystacksize));
 
       if (yyss + yystacksize - 1 <= yyssp)
-	YYABORT;
+        YYABORT;
     }
 
   YYDPRINTF ((stderr, "Entering state %d\n", yystate));
@@ -1581,7 +1405,7 @@ yybackup:
   if (yychar == YYEMPTY)
     {
       YYDPRINTF ((stderr, "Reading a token: "));
-      yychar = YYLEX;
+      yychar = yylex ();
     }
 
   if (yychar <= YYEOF)
@@ -1621,7 +1445,9 @@ yybackup:
   yychar = YYEMPTY;
 
   yystate = yyn;
+  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
   *++yyvsp = yylval;
+  YY_IGNORE_MAYBE_UNINITIALIZED_END
 
   goto yynewstate;
 
@@ -1644,7 +1470,7 @@ yyreduce:
   yylen = yyr2[yyn];
 
   /* If YYLEN is nonzero, implement the default value of the action:
-     `$$ = $1'.
+     '$$ = $1'.
 
      Otherwise, the following line sets YYVAL to garbage.
      This behavior is undocumented and Bison
@@ -1660,43 +1486,50 @@ yyreduce:
         case 10:
 
     { zconf_error("unexpected end statement"); }
+
     break;
 
   case 11:
 
-    { zconf_error("unknown statement \"%s\"", (yyvsp[(2) - (4)].string)); }
+    { zconf_error("unknown statement \"%s\"", (yyvsp[-2].string)); }
+
     break;
 
   case 12:
 
     {
-	zconf_error("unexpected option \"%s\"", kconf_id_strings + (yyvsp[(2) - (4)].id)->name);
+	zconf_error("unexpected option \"%s\"", kconf_id_strings + (yyvsp[-2].id)->name);
 }
+
     break;
 
   case 13:
 
     { zconf_error("invalid statement"); }
+
     break;
 
   case 28:
 
-    { zconf_error("unknown option \"%s\"", (yyvsp[(1) - (3)].string)); }
+    { zconf_error("unknown option \"%s\"", (yyvsp[-2].string)); }
+
     break;
 
   case 29:
 
     { zconf_error("invalid option"); }
+
     break;
 
   case 30:
 
     {
-	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
+	struct symbol *sym = sym_lookup((yyvsp[-1].string), 0);
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
-	printd(DEBUG_PARSE, "%s:%d:config %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
+	printd(DEBUG_PARSE, "%s:%d:config %s\n", zconf_curname(), zconf_lineno(), (yyvsp[-1].string));
 }
+
     break;
 
   case 31:
@@ -1705,16 +1538,18 @@ yyreduce:
 	menu_end_entry();
 	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 32:
 
     {
-	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
+	struct symbol *sym = sym_lookup((yyvsp[-1].string), 0);
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
-	printd(DEBUG_PARSE, "%s:%d:menuconfig %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
+	printd(DEBUG_PARSE, "%s:%d:menuconfig %s\n", zconf_curname(), zconf_lineno(), (yyvsp[-1].string));
 }
+
     break;
 
   case 33:
@@ -1727,85 +1562,95 @@ yyreduce:
 	menu_end_entry();
 	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 41:
 
     {
-	menu_set_type((yyvsp[(1) - (3)].id)->stype);
+	menu_set_type((yyvsp[-2].id)->stype);
 	printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
 		zconf_curname(), zconf_lineno(),
-		(yyvsp[(1) - (3)].id)->stype);
+		(yyvsp[-2].id)->stype);
 }
+
     break;
 
   case 42:
 
     {
-	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
+	menu_add_prompt(P_PROMPT, (yyvsp[-2].string), (yyvsp[-1].expr));
 	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 43:
 
     {
-	menu_add_expr(P_DEFAULT, (yyvsp[(2) - (4)].expr), (yyvsp[(3) - (4)].expr));
-	if ((yyvsp[(1) - (4)].id)->stype != S_UNKNOWN)
-		menu_set_type((yyvsp[(1) - (4)].id)->stype);
+	menu_add_expr(P_DEFAULT, (yyvsp[-2].expr), (yyvsp[-1].expr));
+	if ((yyvsp[-3].id)->stype != S_UNKNOWN)
+		menu_set_type((yyvsp[-3].id)->stype);
 	printd(DEBUG_PARSE, "%s:%d:default(%u)\n",
 		zconf_curname(), zconf_lineno(),
-		(yyvsp[(1) - (4)].id)->stype);
+		(yyvsp[-3].id)->stype);
 }
+
     break;
 
   case 44:
 
     {
-	menu_add_symbol(P_SELECT, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
+	menu_add_symbol(P_SELECT, sym_lookup((yyvsp[-2].string), 0), (yyvsp[-1].expr));
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 45:
 
     {
-	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[(2) - (5)].symbol), (yyvsp[(3) - (5)].symbol)), (yyvsp[(4) - (5)].expr));
+	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[-3].symbol), (yyvsp[-2].symbol)), (yyvsp[-1].expr));
 	printd(DEBUG_PARSE, "%s:%d:range\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 48:
 
     {
-	const struct kconf_id *id = kconf_id_lookup((yyvsp[(2) - (3)].string), strlen((yyvsp[(2) - (3)].string)));
+	const struct kconf_id *id = kconf_id_lookup((yyvsp[-1].string), strlen((yyvsp[-1].string)));
 	if (id && id->flags & TF_OPTION)
-		menu_add_option(id->token, (yyvsp[(3) - (3)].string));
+		menu_add_option(id->token, (yyvsp[0].string));
 	else
-		zconfprint("warning: ignoring unknown option %s", (yyvsp[(2) - (3)].string));
-	free((yyvsp[(2) - (3)].string));
+		zconfprint("warning: ignoring unknown option %s", (yyvsp[-1].string));
+	free((yyvsp[-1].string));
 }
+
     break;
 
   case 49:
 
     { (yyval.string) = NULL; }
+
     break;
 
   case 50:
 
-    { (yyval.string) = (yyvsp[(2) - (2)].string); }
+    { (yyval.string) = (yyvsp[0].string); }
+
     break;
 
   case 51:
 
     {
-	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), SYMBOL_CHOICE);
+	struct symbol *sym = sym_lookup((yyvsp[-1].string), SYMBOL_CHOICE);
 	sym->flags |= SYMBOL_AUTO;
 	menu_add_entry(sym);
 	menu_add_expr(P_CHOICE, NULL, NULL);
 	printd(DEBUG_PARSE, "%s:%d:choice\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 52:
@@ -1813,37 +1658,41 @@ yyreduce:
     {
 	(yyval.menu) = menu_add_menu();
 }
+
     break;
 
   case 53:
 
     {
-	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_CHOICE, T_ENDCHOICE)) {
+	if (zconf_endtoken((yyvsp[0].id), T_CHOICE, T_ENDCHOICE)) {
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endchoice\n", zconf_curname(), zconf_lineno());
 	}
 }
+
     break;
 
   case 61:
 
     {
-	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
+	menu_add_prompt(P_PROMPT, (yyvsp[-2].string), (yyvsp[-1].expr));
 	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 62:
 
     {
-	if ((yyvsp[(1) - (3)].id)->stype == S_BOOLEAN || (yyvsp[(1) - (3)].id)->stype == S_TRISTATE) {
-		menu_set_type((yyvsp[(1) - (3)].id)->stype);
+	if ((yyvsp[-2].id)->stype == S_BOOLEAN || (yyvsp[-2].id)->stype == S_TRISTATE) {
+		menu_set_type((yyvsp[-2].id)->stype);
 		printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
 			zconf_curname(), zconf_lineno(),
-			(yyvsp[(1) - (3)].id)->stype);
+			(yyvsp[-2].id)->stype);
 	} else
 		YYERROR;
 }
+
     break;
 
   case 63:
@@ -1852,18 +1701,20 @@ yyreduce:
 	current_entry->sym->flags |= SYMBOL_OPTIONAL;
 	printd(DEBUG_PARSE, "%s:%d:optional\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 64:
 
     {
-	if ((yyvsp[(1) - (4)].id)->stype == S_UNKNOWN) {
-		menu_add_symbol(P_DEFAULT, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
+	if ((yyvsp[-3].id)->stype == S_UNKNOWN) {
+		menu_add_symbol(P_DEFAULT, sym_lookup((yyvsp[-2].string), 0), (yyvsp[-1].expr));
 		printd(DEBUG_PARSE, "%s:%d:default\n",
 			zconf_curname(), zconf_lineno());
 	} else
 		YYERROR;
 }
+
     break;
 
   case 67:
@@ -1871,35 +1722,39 @@ yyreduce:
     {
 	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
 	menu_add_entry(NULL);
-	menu_add_dep((yyvsp[(2) - (3)].expr));
+	menu_add_dep((yyvsp[-1].expr));
 	(yyval.menu) = menu_add_menu();
 }
+
     break;
 
   case 68:
 
     {
-	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_IF, T_ENDIF)) {
+	if (zconf_endtoken((yyvsp[0].id), T_IF, T_ENDIF)) {
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endif\n", zconf_curname(), zconf_lineno());
 	}
 }
+
     break;
 
   case 74:
 
     {
-	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
+	menu_add_prompt(P_MENU, (yyvsp[-1].string), NULL);
 }
+
     break;
 
   case 75:
 
     {
 	menu_add_entry(NULL);
-	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
+	menu_add_prompt(P_MENU, (yyvsp[-1].string), NULL);
 	printd(DEBUG_PARSE, "%s:%d:menu\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 76:
@@ -1907,33 +1762,37 @@ yyreduce:
     {
 	(yyval.menu) = menu_add_menu();
 }
+
     break;
 
   case 77:
 
     {
-	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_MENU, T_ENDMENU)) {
+	if (zconf_endtoken((yyvsp[0].id), T_MENU, T_ENDMENU)) {
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endmenu\n", zconf_curname(), zconf_lineno());
 	}
 }
+
     break;
 
   case 83:
 
     {
-	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
-	zconf_nextfile((yyvsp[(2) - (3)].string));
+	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[-1].string));
+	zconf_nextfile((yyvsp[-1].string));
 }
+
     break;
 
   case 84:
 
     {
 	menu_add_entry(NULL);
-	menu_add_prompt(P_COMMENT, (yyvsp[(2) - (3)].string), NULL);
+	menu_add_prompt(P_COMMENT, (yyvsp[-1].string), NULL);
 	printd(DEBUG_PARSE, "%s:%d:comment\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 85:
@@ -1941,6 +1800,7 @@ yyreduce:
     {
 	menu_end_entry();
 }
+
     break;
 
   case 86:
@@ -1949,110 +1809,130 @@ yyreduce:
 	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
 	zconf_starthelp();
 }
+
     break;
 
   case 87:
 
     {
-	current_entry->help = (yyvsp[(2) - (2)].string);
+	current_entry->help = (yyvsp[0].string);
 }
+
     break;
 
   case 92:
 
     {
-	menu_add_dep((yyvsp[(3) - (4)].expr));
+	menu_add_dep((yyvsp[-1].expr));
 	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
 }
+
     break;
 
   case 96:
 
     {
-	menu_add_visibility((yyvsp[(2) - (2)].expr));
+	menu_add_visibility((yyvsp[0].expr));
 }
+
     break;
 
   case 98:
 
     {
-	menu_add_prompt(P_PROMPT, (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].expr));
+	menu_add_prompt(P_PROMPT, (yyvsp[-1].string), (yyvsp[0].expr));
 }
+
     break;
 
   case 101:
 
-    { (yyval.id) = (yyvsp[(1) - (2)].id); }
+    { (yyval.id) = (yyvsp[-1].id); }
+
     break;
 
   case 102:
 
-    { (yyval.id) = (yyvsp[(1) - (2)].id); }
+    { (yyval.id) = (yyvsp[-1].id); }
+
     break;
 
   case 103:
 
-    { (yyval.id) = (yyvsp[(1) - (2)].id); }
+    { (yyval.id) = (yyvsp[-1].id); }
+
     break;
 
   case 106:
 
     { (yyval.expr) = NULL; }
+
     break;
 
   case 107:
 
-    { (yyval.expr) = (yyvsp[(2) - (2)].expr); }
+    { (yyval.expr) = (yyvsp[0].expr); }
+
     break;
 
   case 108:
 
-    { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); }
+    { (yyval.expr) = expr_alloc_symbol((yyvsp[0].symbol)); }
+
     break;
 
   case 109:
 
-    { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); }
+    { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }
+
     break;
 
   case 110:
 
-    { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); }
+    { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[-2].symbol), (yyvsp[0].symbol)); }
+
     break;
 
   case 111:
 
-    { (yyval.expr) = (yyvsp[(2) - (3)].expr); }
+    { (yyval.expr) = (yyvsp[-1].expr); }
+
     break;
 
   case 112:
 
-    { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); }
+    { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[0].expr)); }
+
     break;
 
   case 113:
 
-    { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); }
+    { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[-2].expr), (yyvsp[0].expr)); }
+
     break;
 
   case 114:
 
-    { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); }
+    { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[-2].expr), (yyvsp[0].expr)); }
+
     break;
 
   case 115:
 
-    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); }
+    { (yyval.symbol) = sym_lookup((yyvsp[0].string), 0); free((yyvsp[0].string)); }
+
     break;
 
   case 116:
 
-    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); }
+    { (yyval.symbol) = sym_lookup((yyvsp[0].string), SYMBOL_CONST); free((yyvsp[0].string)); }
+
     break;
 
   case 117:
 
     { (yyval.string) = NULL; }
+
     break;
 
 
@@ -2078,7 +1958,7 @@ yyreduce:
 
   *++yyvsp = yyval;
 
-  /* Now `shift' the result of the reduction.  Determine what state
+  /* Now 'shift' the result of the reduction.  Determine what state
      that goes to, based on the state we popped back to and the rule
      number reduced by.  */
 
@@ -2093,9 +1973,9 @@ yyreduce:
   goto yynewstate;
 
 
-/*------------------------------------.
-| yyerrlab -- here on detecting error |
-`------------------------------------*/
+/*--------------------------------------.
+| yyerrlab -- here on detecting error.  |
+`--------------------------------------*/
 yyerrlab:
   /* Make sure we have latest lookahead translation.  See comments at
      user semantic actions for why this is necessary.  */
@@ -2146,20 +2026,20 @@ yyerrlab:
   if (yyerrstatus == 3)
     {
       /* If just tried and failed to reuse lookahead token after an
-	 error, discard it.  */
+         error, discard it.  */
 
       if (yychar <= YYEOF)
-	{
-	  /* Return failure if at end of input.  */
-	  if (yychar == YYEOF)
-	    YYABORT;
-	}
+        {
+          /* Return failure if at end of input.  */
+          if (yychar == YYEOF)
+            YYABORT;
+        }
       else
-	{
-	  yydestruct ("Error: discarding",
-		      yytoken, &yylval);
-	  yychar = YYEMPTY;
-	}
+        {
+          yydestruct ("Error: discarding",
+                      yytoken, &yylval);
+          yychar = YYEMPTY;
+        }
     }
 
   /* Else will try to reuse lookahead token after shifting the error
@@ -2178,7 +2058,7 @@ yyerrorlab:
   if (/*CONSTCOND*/ 0)
      goto yyerrorlab;
 
-  /* Do not reclaim the symbols of the rule which action triggered
+  /* Do not reclaim the symbols of the rule whose action triggered
      this YYERROR.  */
   YYPOPSTACK (yylen);
   yylen = 0;
@@ -2191,35 +2071,37 @@ yyerrorlab:
 | yyerrlab1 -- common code for both syntax error and YYERROR.  |
 `-------------------------------------------------------------*/
 yyerrlab1:
-  yyerrstatus = 3;	/* Each real token shifted decrements this.  */
+  yyerrstatus = 3;      /* Each real token shifted decrements this.  */
 
   for (;;)
     {
       yyn = yypact[yystate];
       if (!yypact_value_is_default (yyn))
-	{
-	  yyn += YYTERROR;
-	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
-	    {
-	      yyn = yytable[yyn];
-	      if (0 < yyn)
-		break;
-	    }
-	}
+        {
+          yyn += YYTERROR;
+          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
+            {
+              yyn = yytable[yyn];
+              if (0 < yyn)
+                break;
+            }
+        }
 
       /* Pop the current state because it cannot handle the error token.  */
       if (yyssp == yyss)
-	YYABORT;
+        YYABORT;
 
 
       yydestruct ("Error: popping",
-		  yystos[yystate], yyvsp);
+                  yystos[yystate], yyvsp);
       YYPOPSTACK (1);
       yystate = *yyssp;
       YY_STACK_PRINT (yyss, yyssp);
     }
 
+  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
   *++yyvsp = yylval;
+  YY_IGNORE_MAYBE_UNINITIALIZED_END
 
 
   /* Shift the error token.  */
@@ -2243,7 +2125,7 @@ yyabortlab:
   yyresult = 1;
   goto yyreturn;
 
-#if !defined(yyoverflow) || YYERROR_VERBOSE
+#if !defined yyoverflow || YYERROR_VERBOSE
 /*-------------------------------------------------.
 | yyexhaustedlab -- memory exhaustion comes here.  |
 `-------------------------------------------------*/
@@ -2262,14 +2144,14 @@ yyreturn:
       yydestruct ("Cleanup: discarding lookahead",
                   yytoken, &yylval);
     }
-  /* Do not reclaim the symbols of the rule which action triggered
+  /* Do not reclaim the symbols of the rule whose action triggered
      this YYABORT or YYACCEPT.  */
   YYPOPSTACK (yylen);
   YY_STACK_PRINT (yyss, yyssp);
   while (yyssp != yyss)
     {
       yydestruct ("Cleanup: popping",
-		  yystos[*yyssp], yyvsp);
+                  yystos[*yyssp], yyvsp);
       YYPOPSTACK (1);
     }
 #ifndef yyoverflow
@@ -2280,14 +2162,11 @@ yyreturn:
   if (yymsg != yymsgbuf)
     YYSTACK_FREE (yymsg);
 #endif
-  /* Make sure YYID is used.  */
-  return YYID (yyresult);
+  return yyresult;
 }
 
 
 
-
-
 void conf_parse(const char *name)
 {
 	struct symbol *sym;
@@ -2535,4 +2414,3 @@ void zconfdump(FILE *out)
 #include "expr.c"
 #include "symbol.c"
 #include "menu.c"
-
-- 
2.1.0

