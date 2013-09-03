Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab3ICVFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:05:02 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:35343 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab3ICVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:04:57 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/3] kconfig: regenerate bison parser
Date: Tue,  3 Sep 2013 23:04:46 +0200
Message-Id: <1378242287-12759-2-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Regenerate bison parser after changes made in:
    b1a4fe3: kconfig: do not special-case 'MODULES' symbol

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/zconf.tab.c_shipped | 562 +++++++++++++++++++-----------------
 1 file changed, 298 insertions(+), 264 deletions(-)

diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index f636141..25ae16a 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1,9 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+/* A Bison parser, made by GNU Bison 2.5.  */
 
-/* Skeleton implementation for Bison's Yacc-like parsers in C
+/* Bison implementation for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -45,7 +44,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.4.3"
+#define YYBISON_VERSION "2.5"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -302,11 +301,11 @@ YYID (yyi)
 #    define alloca _alloca
 #   else
 #    define YYSTACK_ALLOC alloca
-#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#     ifndef _STDLIB_H
-#      define _STDLIB_H 1
+#     ifndef EXIT_SUCCESS
+#      define EXIT_SUCCESS 0
 #     endif
 #    endif
 #   endif
@@ -329,24 +328,24 @@ YYID (yyi)
 #  ifndef YYSTACK_ALLOC_MAXIMUM
 #   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
 #  endif
-#  if (defined __cplusplus && ! defined _STDLIB_H \
+#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
        && ! ((defined YYMALLOC || defined malloc) \
 	     && (defined YYFREE || defined free)))
 #   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#   ifndef _STDLIB_H
-#    define _STDLIB_H 1
+#   ifndef EXIT_SUCCESS
+#    define EXIT_SUCCESS 0
 #   endif
 #  endif
 #  ifndef YYMALLOC
 #   define YYMALLOC malloc
-#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
 #   endif
 #  endif
 #  ifndef YYFREE
 #   define YYFREE free
-#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void free (void *); /* INFRINGES ON USER NAME SPACE */
 #   endif
@@ -375,23 +374,7 @@ union yyalloc
      ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
       + YYSTACK_GAP_MAXIMUM)
 
-/* Copy COUNT objects from FROM to TO.  The source and destination do
-   not overlap.  */
-# ifndef YYCOPY
-#  if defined __GNUC__ && 1 < __GNUC__
-#   define YYCOPY(To, From, Count) \
-      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
-#  else
-#   define YYCOPY(To, From, Count)		\
-      do					\
-	{					\
-	  YYSIZE_T yyi;				\
-	  for (yyi = 0; yyi < (Count); yyi++)	\
-	    (To)[yyi] = (From)[yyi];		\
-	}					\
-      while (YYID (0))
-#  endif
-# endif
+# define YYCOPY_NEEDED 1
 
 /* Relocate STACK from its old location to the new one.  The
    local variables YYSIZE and YYSTACKSIZE give the old and new number of
@@ -411,6 +394,26 @@ union yyalloc
 
 #endif
 
+#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
+/* Copy COUNT objects from FROM to TO.  The source and destination do
+   not overlap.  */
+# ifndef YYCOPY
+#  if defined __GNUC__ && 1 < __GNUC__
+#   define YYCOPY(To, From, Count) \
+      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
+#  else
+#   define YYCOPY(To, From, Count)		\
+      do					\
+	{					\
+	  YYSIZE_T yyi;				\
+	  for (yyi = 0; yyi < (Count); yyi++)	\
+	    (To)[yyi] = (From)[yyi];		\
+	}					\
+      while (YYID (0))
+#  endif
+# endif
+#endif /* !YYCOPY_NEEDED */
+
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  11
 /* YYLAST -- Last index in YYTABLE.  */
@@ -529,18 +532,18 @@ static const yytype_int8 yyrhs[] =
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
-       0,   104,   104,   104,   106,   106,   108,   110,   111,   112,
-     113,   114,   115,   119,   123,   123,   123,   123,   123,   123,
-     123,   123,   127,   128,   129,   130,   131,   132,   136,   137,
-     143,   151,   157,   165,   175,   177,   178,   179,   180,   181,
-     182,   185,   193,   199,   209,   215,   221,   224,   226,   237,
-     238,   243,   252,   257,   265,   268,   270,   271,   272,   273,
-     274,   277,   283,   294,   300,   310,   312,   317,   325,   333,
-     336,   338,   339,   340,   345,   352,   359,   364,   372,   375,
-     377,   378,   379,   382,   390,   397,   404,   410,   417,   419,
-     420,   421,   424,   432,   434,   435,   438,   445,   447,   452,
-     453,   456,   457,   458,   462,   463,   466,   467,   470,   471,
-     472,   473,   474,   475,   476,   479,   480,   483,   484
+       0,   103,   103,   103,   105,   105,   107,   109,   110,   111,
+     112,   113,   114,   118,   122,   122,   122,   122,   122,   122,
+     122,   122,   126,   127,   128,   129,   130,   131,   135,   136,
+     142,   150,   156,   164,   174,   176,   177,   178,   179,   180,
+     181,   184,   192,   198,   208,   214,   220,   223,   225,   236,
+     237,   242,   251,   256,   264,   267,   269,   270,   271,   272,
+     273,   276,   282,   293,   299,   309,   311,   316,   324,   332,
+     335,   337,   338,   339,   344,   351,   358,   363,   371,   374,
+     376,   377,   378,   381,   389,   396,   403,   409,   416,   418,
+     419,   420,   423,   431,   433,   434,   437,   444,   446,   451,
+     452,   455,   456,   457,   461,   462,   465,   466,   469,   470,
+     471,   472,   473,   474,   475,   478,   479,   482,   483
 };
 #endif
 
@@ -615,8 +618,8 @@ static const yytype_uint8 yyr2[] =
        3,     3,     2,     3,     3,     1,     1,     0,     1
 };
 
-/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
-   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
+/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
+   Performed when YYTABLE doesn't specify something else to do.  Zero
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
@@ -691,8 +694,7 @@ static const yytype_int16 yypgoto[] =
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
-   number is the opposite.  If zero, do what YYDEFACT says.
-   If YYTABLE_NINF, syntax error.  */
+   number is the opposite.  If YYTABLE_NINF, syntax error.  */
 #define YYTABLE_NINF -86
 static const yytype_int16 yytable[] =
 {
@@ -728,6 +730,12 @@ static const yytype_int16 yytable[] =
      184
 };
 
+#define yypact_value_is_default(yystate) \
+  ((yystate) == (-90))
+
+#define yytable_value_is_error(yytable_value) \
+  YYID (0)
+
 static const yytype_int16 yycheck[] =
 {
        1,    67,    68,    10,    93,    94,    76,     3,    76,    14,
@@ -821,7 +829,6 @@ do								\
     {								\
       yychar = (Token);						\
       yylval = (Value);						\
-      yytoken = YYTRANSLATE (yychar);				\
       YYPOPSTACK (1);						\
       goto yybackup;						\
     }								\
@@ -863,19 +870,10 @@ while (YYID (0))
 #endif
 
 
-/* YY_LOCATION_PRINT -- Print the location on the stream.
-   This macro was not mandated originally: define only if we know
-   we won't break user code: when these are the locations we know.  */
+/* This macro is provided for backward compatibility. */
 
 #ifndef YY_LOCATION_PRINT
-# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
-#  define YY_LOCATION_PRINT(File, Loc)			\
-     fprintf (File, "%d.%d-%d.%d",			\
-	      (Loc).first_line, (Loc).first_column,	\
-	      (Loc).last_line,  (Loc).last_column)
-# else
-#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
-# endif
+# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
 #endif
 
 
@@ -1067,7 +1065,6 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif
 
-
 
 #if YYERROR_VERBOSE
 
@@ -1170,115 +1167,142 @@ yytnamerr (char *yyres, const char *yystr)
 }
 # endif
 
-/* Copy into YYRESULT an error message about the unexpected token
-   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
-   including the terminating null byte.  If YYRESULT is null, do not
-   copy anything; just return the number of bytes that would be
-   copied.  As a special case, return 0 if an ordinary "syntax error"
-   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
-   size calculation.  */
-static YYSIZE_T
-yysyntax_error (char *yyresult, int yystate, int yychar)
-{
-  int yyn = yypact[yystate];
+/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
+   about the unexpected token YYTOKEN for the state stack whose top is
+   YYSSP.
 
-  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
-    return 0;
-  else
+   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
+   not large enough to hold the message.  In that case, also set
+   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
+   required number of bytes is too large to store.  */
+static int
+yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
+                yytype_int16 *yyssp, int yytoken)
+{
+  YYSIZE_T yysize0 = yytnamerr (0, yytname[yytoken]);
+  YYSIZE_T yysize = yysize0;
+  YYSIZE_T yysize1;
+  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
+  /* Internationalized format string. */
+  const char *yyformat = 0;
+  /* Arguments of yyformat. */
+  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
+  /* Number of reported tokens (one for the "unexpected", one per
+     "expected"). */
+  int yycount = 0;
+
+  /* There are many possibilities here to consider:
+     - Assume YYFAIL is not used.  It's too flawed to consider.  See
+       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
+       for details.  YYERROR is fine as it does not invoke this
+       function.
+     - If this state is a consistent state with a default action, then
+       the only way this function was invoked is if the default action
+       is an error action.  In that case, don't check for expected
+       tokens because there are none.
+     - The only way there can be no lookahead present (in yychar) is if
+       this state is a consistent state with a default action.  Thus,
+       detecting the absence of a lookahead is sufficient to determine
+       that there is no unexpected or expected token to report.  In that
+       case, just report a simple "syntax error".
+     - Don't assume there isn't a lookahead just because this state is a
+       consistent state with a default action.  There might have been a
+       previous inconsistent state, consistent state with a non-default
+       action, or user semantic action that manipulated yychar.
+     - Of course, the expected token list depends on states to have
+       correct lookahead information, and it depends on the parser not
+       to perform extra reductions after fetching a lookahead from the
+       scanner and before detecting a syntax error.  Thus, state merging
+       (from LALR or IELR) and default reductions corrupt the expected
+       token list.  However, the list is correct for canonical LR with
+       one exception: it will still contain any token that will not be
+       accepted due to an error action in a later state.
+  */
+  if (yytoken != YYEMPTY)
     {
-      int yytype = YYTRANSLATE (yychar);
-      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
-      YYSIZE_T yysize = yysize0;
-      YYSIZE_T yysize1;
-      int yysize_overflow = 0;
-      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
-      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
-      int yyx;
-
-# if 0
-      /* This is so xgettext sees the translatable formats that are
-	 constructed on the fly.  */
-      YY_("syntax error, unexpected %s");
-      YY_("syntax error, unexpected %s, expecting %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
-# endif
-      char *yyfmt;
-      char const *yyf;
-      static char const yyunexpected[] = "syntax error, unexpected %s";
-      static char const yyexpecting[] = ", expecting %s";
-      static char const yyor[] = " or %s";
-      char yyformat[sizeof yyunexpected
-		    + sizeof yyexpecting - 1
-		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
-		       * (sizeof yyor - 1))];
-      char const *yyprefix = yyexpecting;
-
-      /* Start YYX at -YYN if negative to avoid negative indexes in
-	 YYCHECK.  */
-      int yyxbegin = yyn < 0 ? -yyn : 0;
-
-      /* Stay within bounds of both yycheck and yytname.  */
-      int yychecklim = YYLAST - yyn + 1;
-      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
-      int yycount = 1;
-
-      yyarg[0] = yytname[yytype];
-      yyfmt = yystpcpy (yyformat, yyunexpected);
-
-      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
-	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
-	  {
-	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
-	      {
-		yycount = 1;
-		yysize = yysize0;
-		yyformat[sizeof yyunexpected - 1] = '\0';
-		break;
-	      }
-	    yyarg[yycount++] = yytname[yyx];
-	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
-	    yysize_overflow |= (yysize1 < yysize);
-	    yysize = yysize1;
-	    yyfmt = yystpcpy (yyfmt, yyprefix);
-	    yyprefix = yyor;
-	  }
+      int yyn = yypact[*yyssp];
+      yyarg[yycount++] = yytname[yytoken];
+      if (!yypact_value_is_default (yyn))
+        {
+          /* Start YYX at -YYN if negative to avoid negative indexes in
+             YYCHECK.  In other words, skip the first -YYN actions for
+             this state because they are default actions.  */
+          int yyxbegin = yyn < 0 ? -yyn : 0;
+          /* Stay within bounds of both yycheck and yytname.  */
+          int yychecklim = YYLAST - yyn + 1;
+          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
+          int yyx;
+
+          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
+            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
+                && !yytable_value_is_error (yytable[yyx + yyn]))
+              {
+                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
+                  {
+                    yycount = 1;
+                    yysize = yysize0;
+                    break;
+                  }
+                yyarg[yycount++] = yytname[yyx];
+                yysize1 = yysize + yytnamerr (0, yytname[yyx]);
+                if (! (yysize <= yysize1
+                       && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+                  return 2;
+                yysize = yysize1;
+              }
+        }
+    }
 
-      yyf = YY_(yyformat);
-      yysize1 = yysize + yystrlen (yyf);
-      yysize_overflow |= (yysize1 < yysize);
-      yysize = yysize1;
+  switch (yycount)
+    {
+# define YYCASE_(N, S)                      \
+      case N:                               \
+        yyformat = S;                       \
+      break
+      YYCASE_(0, YY_("syntax error"));
+      YYCASE_(1, YY_("syntax error, unexpected %s"));
+      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
+      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
+      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
+      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
+# undef YYCASE_
+    }
 
-      if (yysize_overflow)
-	return YYSIZE_MAXIMUM;
+  yysize1 = yysize + yystrlen (yyformat);
+  if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+    return 2;
+  yysize = yysize1;
 
-      if (yyresult)
-	{
-	  /* Avoid sprintf, as that infringes on the user's name space.
-	     Don't have undefined behavior even if the translation
-	     produced a string with the wrong number of "%s"s.  */
-	  char *yyp = yyresult;
-	  int yyi = 0;
-	  while ((*yyp = *yyf) != '\0')
-	    {
-	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
-		{
-		  yyp += yytnamerr (yyp, yyarg[yyi++]);
-		  yyf += 2;
-		}
-	      else
-		{
-		  yyp++;
-		  yyf++;
-		}
-	    }
-	}
-      return yysize;
+  if (*yymsg_alloc < yysize)
+    {
+      *yymsg_alloc = 2 * yysize;
+      if (! (yysize <= *yymsg_alloc
+             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
+        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
+      return 1;
     }
+
+  /* Avoid sprintf, as that infringes on the user's name space.
+     Don't have undefined behavior even if the translation
+     produced a string with the wrong number of "%s"s.  */
+  {
+    char *yyp = *yymsg;
+    int yyi = 0;
+    while ((*yyp = *yyformat) != '\0')
+      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
+        {
+          yyp += yytnamerr (yyp, yyarg[yyi++]);
+          yyformat += 2;
+        }
+      else
+        {
+          yyp++;
+          yyformat++;
+        }
+  }
+  return 0;
 }
 #endif /* YYERROR_VERBOSE */
-
 
 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
@@ -1341,6 +1365,7 @@ yydestruct (yymsg, yytype, yyvaluep)
     }
 }
 
+
 /* Prevent warnings from -Wmissing-prototypes.  */
 #ifdef YYPARSE_PARAM
 #if defined __STDC__ || defined __cplusplus
@@ -1367,10 +1392,9 @@ YYSTYPE yylval;
 int yynerrs;
 
 
-
-/*-------------------------.
-| yyparse or yypush_parse.  |
-`-------------------------*/
+/*----------.
+| yyparse.  |
+`----------*/
 
 #ifdef YYPARSE_PARAM
 #if (defined __STDC__ || defined __C99__FUNC__ \
@@ -1394,8 +1418,6 @@ yyparse ()
 #endif
 #endif
 {
-
-
     int yystate;
     /* Number of tokens to shift before error messages enabled.  */
     int yyerrstatus;
@@ -1550,7 +1572,7 @@ yybackup:
 
   /* First try to decide what to do without reference to lookahead token.  */
   yyn = yypact[yystate];
-  if (yyn == YYPACT_NINF)
+  if (yypact_value_is_default (yyn))
     goto yydefault;
 
   /* Not known => get a lookahead token if don't already have one.  */
@@ -1581,8 +1603,8 @@ yybackup:
   yyn = yytable[yyn];
   if (yyn <= 0)
     {
-      if (yyn == 0 || yyn == YYTABLE_NINF)
-	goto yyerrlab;
+      if (yytable_value_is_error (yyn))
+        goto yyerrlab;
       yyn = -yyn;
       goto yyreduce;
     }
@@ -1637,34 +1659,34 @@ yyreduce:
     {
         case 10:
 
-    { zconf_error("unexpected end statement"); ;}
+    { zconf_error("unexpected end statement"); }
     break;
 
   case 11:
 
-    { zconf_error("unknown statement \"%s\"", (yyvsp[(2) - (4)].string)); ;}
+    { zconf_error("unknown statement \"%s\"", (yyvsp[(2) - (4)].string)); }
     break;
 
   case 12:
 
     {
 	zconf_error("unexpected option \"%s\"", kconf_id_strings + (yyvsp[(2) - (4)].id)->name);
-;}
+}
     break;
 
   case 13:
 
-    { zconf_error("invalid statement"); ;}
+    { zconf_error("invalid statement"); }
     break;
 
   case 28:
 
-    { zconf_error("unknown option \"%s\"", (yyvsp[(1) - (3)].string)); ;}
+    { zconf_error("unknown option \"%s\"", (yyvsp[(1) - (3)].string)); }
     break;
 
   case 29:
 
-    { zconf_error("invalid option"); ;}
+    { zconf_error("invalid option"); }
     break;
 
   case 30:
@@ -1674,7 +1696,7 @@ yyreduce:
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
 	printd(DEBUG_PARSE, "%s:%d:config %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
   case 31:
@@ -1682,7 +1704,7 @@ yyreduce:
     {
 	menu_end_entry();
 	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 32:
@@ -1692,7 +1714,7 @@ yyreduce:
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
 	printd(DEBUG_PARSE, "%s:%d:menuconfig %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
   case 33:
@@ -1704,7 +1726,7 @@ yyreduce:
 		zconfprint("warning: menuconfig statement without prompt");
 	menu_end_entry();
 	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 41:
@@ -1714,7 +1736,7 @@ yyreduce:
 	printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
 		zconf_curname(), zconf_lineno(),
 		(yyvsp[(1) - (3)].id)->stype);
-;}
+}
     break;
 
   case 42:
@@ -1722,7 +1744,7 @@ yyreduce:
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 43:
@@ -1734,7 +1756,7 @@ yyreduce:
 	printd(DEBUG_PARSE, "%s:%d:default(%u)\n",
 		zconf_curname(), zconf_lineno(),
 		(yyvsp[(1) - (4)].id)->stype);
-;}
+}
     break;
 
   case 44:
@@ -1742,7 +1764,7 @@ yyreduce:
     {
 	menu_add_symbol(P_SELECT, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 45:
@@ -1750,7 +1772,7 @@ yyreduce:
     {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[(2) - (5)].symbol), (yyvsp[(3) - (5)].symbol)), (yyvsp[(4) - (5)].expr));
 	printd(DEBUG_PARSE, "%s:%d:range\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 48:
@@ -1762,17 +1784,17 @@ yyreduce:
 	else
 		zconfprint("warning: ignoring unknown option %s", (yyvsp[(2) - (3)].string));
 	free((yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
   case 49:
 
-    { (yyval.string) = NULL; ;}
+    { (yyval.string) = NULL; }
     break;
 
   case 50:
 
-    { (yyval.string) = (yyvsp[(2) - (2)].string); ;}
+    { (yyval.string) = (yyvsp[(2) - (2)].string); }
     break;
 
   case 51:
@@ -1783,14 +1805,14 @@ yyreduce:
 	menu_add_entry(sym);
 	menu_add_expr(P_CHOICE, NULL, NULL);
 	printd(DEBUG_PARSE, "%s:%d:choice\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 52:
 
     {
 	(yyval.menu) = menu_add_menu();
-;}
+}
     break;
 
   case 53:
@@ -1800,7 +1822,7 @@ yyreduce:
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endchoice\n", zconf_curname(), zconf_lineno());
 	}
-;}
+}
     break;
 
   case 61:
@@ -1808,7 +1830,7 @@ yyreduce:
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 62:
@@ -1821,7 +1843,7 @@ yyreduce:
 			(yyvsp[(1) - (3)].id)->stype);
 	} else
 		YYERROR;
-;}
+}
     break;
 
   case 63:
@@ -1829,7 +1851,7 @@ yyreduce:
     {
 	current_entry->sym->flags |= SYMBOL_OPTIONAL;
 	printd(DEBUG_PARSE, "%s:%d:optional\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 64:
@@ -1841,7 +1863,7 @@ yyreduce:
 			zconf_curname(), zconf_lineno());
 	} else
 		YYERROR;
-;}
+}
     break;
 
   case 67:
@@ -1851,7 +1873,7 @@ yyreduce:
 	menu_add_entry(NULL);
 	menu_add_dep((yyvsp[(2) - (3)].expr));
 	(yyval.menu) = menu_add_menu();
-;}
+}
     break;
 
   case 68:
@@ -1861,14 +1883,14 @@ yyreduce:
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endif\n", zconf_curname(), zconf_lineno());
 	}
-;}
+}
     break;
 
   case 74:
 
     {
 	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
-;}
+}
     break;
 
   case 75:
@@ -1877,14 +1899,14 @@ yyreduce:
 	menu_add_entry(NULL);
 	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
 	printd(DEBUG_PARSE, "%s:%d:menu\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 76:
 
     {
 	(yyval.menu) = menu_add_menu();
-;}
+}
     break;
 
   case 77:
@@ -1894,7 +1916,7 @@ yyreduce:
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endmenu\n", zconf_curname(), zconf_lineno());
 	}
-;}
+}
     break;
 
   case 83:
@@ -1902,7 +1924,7 @@ yyreduce:
     {
 	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
 	zconf_nextfile((yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
   case 84:
@@ -1911,14 +1933,14 @@ yyreduce:
 	menu_add_entry(NULL);
 	menu_add_prompt(P_COMMENT, (yyvsp[(2) - (3)].string), NULL);
 	printd(DEBUG_PARSE, "%s:%d:comment\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 85:
 
     {
 	menu_end_entry();
-;}
+}
     break;
 
   case 86:
@@ -1926,14 +1948,14 @@ yyreduce:
     {
 	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
 	zconf_starthelp();
-;}
+}
     break;
 
   case 87:
 
     {
 	current_entry->help = (yyvsp[(2) - (2)].string);
-;}
+}
     break;
 
   case 92:
@@ -1941,102 +1963,113 @@ yyreduce:
     {
 	menu_add_dep((yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
   case 96:
 
     {
 	menu_add_visibility((yyvsp[(2) - (2)].expr));
-;}
+}
     break;
 
   case 98:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].expr));
-;}
+}
     break;
 
   case 101:
 
-    { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
+    { (yyval.id) = (yyvsp[(1) - (2)].id); }
     break;
 
   case 102:
 
-    { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
+    { (yyval.id) = (yyvsp[(1) - (2)].id); }
     break;
 
   case 103:
 
-    { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
+    { (yyval.id) = (yyvsp[(1) - (2)].id); }
     break;
 
   case 106:
 
-    { (yyval.expr) = NULL; ;}
+    { (yyval.expr) = NULL; }
     break;
 
   case 107:
 
-    { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
+    { (yyval.expr) = (yyvsp[(2) - (2)].expr); }
     break;
 
   case 108:
 
-    { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); ;}
+    { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); }
     break;
 
   case 109:
 
-    { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
+    { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); }
     break;
 
   case 110:
 
-    { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
+    { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); }
     break;
 
   case 111:
 
-    { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
+    { (yyval.expr) = (yyvsp[(2) - (3)].expr); }
     break;
 
   case 112:
 
-    { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); ;}
+    { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); }
     break;
 
   case 113:
 
-    { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
+    { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); }
     break;
 
   case 114:
 
-    { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
+    { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); }
     break;
 
   case 115:
 
-    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); ;}
+    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); }
     break;
 
   case 116:
 
-    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); ;}
+    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); }
     break;
 
   case 117:
 
-    { (yyval.string) = NULL; ;}
+    { (yyval.string) = NULL; }
     break;
 
 
 
       default: break;
     }
+  /* User semantic actions sometimes alter yychar, and that requires
+     that yytoken be updated with the new translation.  We take the
+     approach of translating immediately before every use of yytoken.
+     One alternative is translating here after every semantic action,
+     but that translation would be missed if the semantic action invokes
+     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
+     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
+     incorrect destructor might then be invoked immediately.  In the
+     case of YYERROR or YYBACKUP, subsequent parser actions might lead
+     to an incorrect destructor call or verbose syntax error message
+     before the lookahead is translated.  */
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
 
   YYPOPSTACK (yylen);
@@ -2064,6 +2097,10 @@ yyreduce:
 | yyerrlab -- here on detecting error |
 `------------------------------------*/
 yyerrlab:
+  /* Make sure we have latest lookahead translation.  See comments at
+     user semantic actions for why this is necessary.  */
+  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);
+
   /* If not already recovering from an error, report this error.  */
   if (!yyerrstatus)
     {
@@ -2071,37 +2108,36 @@ yyerrlab:
 #if ! YYERROR_VERBOSE
       yyerror (YY_("syntax error"));
 #else
+# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
+                                        yyssp, yytoken)
       {
-	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
-	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
-	  {
-	    YYSIZE_T yyalloc = 2 * yysize;
-	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
-	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
-	    if (yymsg != yymsgbuf)
-	      YYSTACK_FREE (yymsg);
-	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
-	    if (yymsg)
-	      yymsg_alloc = yyalloc;
-	    else
-	      {
-		yymsg = yymsgbuf;
-		yymsg_alloc = sizeof yymsgbuf;
-	      }
-	  }
-
-	if (0 < yysize && yysize <= yymsg_alloc)
-	  {
-	    (void) yysyntax_error (yymsg, yystate, yychar);
-	    yyerror (yymsg);
-	  }
-	else
-	  {
-	    yyerror (YY_("syntax error"));
-	    if (yysize != 0)
-	      goto yyexhaustedlab;
-	  }
+        char const *yymsgp = YY_("syntax error");
+        int yysyntax_error_status;
+        yysyntax_error_status = YYSYNTAX_ERROR;
+        if (yysyntax_error_status == 0)
+          yymsgp = yymsg;
+        else if (yysyntax_error_status == 1)
+          {
+            if (yymsg != yymsgbuf)
+              YYSTACK_FREE (yymsg);
+            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
+            if (!yymsg)
+              {
+                yymsg = yymsgbuf;
+                yymsg_alloc = sizeof yymsgbuf;
+                yysyntax_error_status = 2;
+              }
+            else
+              {
+                yysyntax_error_status = YYSYNTAX_ERROR;
+                yymsgp = yymsg;
+              }
+          }
+        yyerror (yymsgp);
+        if (yysyntax_error_status == 2)
+          goto yyexhaustedlab;
       }
+# undef YYSYNTAX_ERROR
 #endif
     }
 
@@ -2160,7 +2196,7 @@ yyerrlab1:
   for (;;)
     {
       yyn = yypact[yystate];
-      if (yyn != YYPACT_NINF)
+      if (!yypact_value_is_default (yyn))
 	{
 	  yyn += YYTERROR;
 	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
@@ -2219,8 +2255,13 @@ yyexhaustedlab:
 
 yyreturn:
   if (yychar != YYEMPTY)
-     yydestruct ("Cleanup: discarding lookahead",
-		 yytoken, &yylval);
+    {
+      /* Make sure we have latest lookahead translation.  See comments at
+         user semantic actions for why this is necessary.  */
+      yytoken = YYTRANSLATE (yychar);
+      yydestruct ("Cleanup: discarding lookahead",
+                  yytoken, &yylval);
+    }
   /* Do not reclaim the symbols of the rule which action triggered
      this YYABORT or YYACCEPT.  */
   YYPOPSTACK (yylen);
@@ -2256,9 +2297,6 @@ void conf_parse(const char *name)
 
 	sym_init();
 	_menu_init();
-	modules_sym = sym_lookup(NULL, 0);
-	modules_sym->type = S_BOOLEAN;
-	modules_sym->flags |= SYMBOL_AUTO;
 	rootmenu.prompt = menu_add_prompt(P_MENU, "Linux Kernel Configuration", NULL);
 
 	if (getenv("ZCONF_DEBUG"))
@@ -2266,12 +2304,8 @@ void conf_parse(const char *name)
 	zconfparse();
 	if (zconfnerrs)
 		exit(1);
-	if (!modules_sym->prop) {
-		struct property *prop;
-
-		prop = prop_alloc(P_DEFAULT, modules_sym);
-		prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
-	}
+	if (!modules_sym)
+		modules_sym = sym_find( "n" );
 
 	rootmenu.prompt->text = _(rootmenu.prompt->text);
 	rootmenu.prompt->text = sym_expand_string_value(rootmenu.prompt->text);
-- 
1.8.1.2

