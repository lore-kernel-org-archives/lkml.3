Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161047AbaDRVk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:40:57 -0400
Received: from mout.web.de ([212.227.15.4]:55772 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161025AbaDRVkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:40:45 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH v2 2/2] kconfig: trivial - adjust comments
Date: Fri, 18 Apr 2014 23:34:26 +0200
Message-ID: <2160545.7ZIeUE2WQO@tacticalops>
User-Agent: KMail/4.12.3 (Linux/3.12.13-gentoo-gnu; KDE/4.12.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:i8BUvGSg4XDACF0CFAw4p8ZOU5uhNvKww7HTdpCdgoKqenlN4hh
 8L7wyxsDUBEfNZZzzqYnC5gDIJJe62A1hW2mvjAzxCCGCp1TY+yVpL3LwQb2vuyb4c1r97i
 7syUm2JKv2tQdHrNun8I+EM2tcSNrSnNH8bOlhJLOkXeiplMNfp2OiJfi9WCP8jtp2IF3z8
 GpHgXQXCe8vehx0H6oNDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Fri, 18 Apr 2014 22:15:37 +0200
Subject: [PATCH v2 2/2] kconfig: trivial - adjust comments

Replace any C99 comments with traditional ones (/*...*/).

Also fix the contents of two comments:

1) the second occurrence of
(a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
is probably copy & paste from above, missing the adjustment corresponding
to the code.
It should probably read
(a!='b') && (a='c') -> 'b'='c' ? 'n' : a='c'

2) that one is similar:
(a!='m') && (a!='n') -> (a='m')
it should be
(a!='m') && (a!='n') -> (a='y')

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/expr.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index 4aa171b..c840e52 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -326,7 +326,7 @@ struct expr *expr_trans_bool(struct expr *e)
 		e->right.expr = expr_trans_bool(e->right.expr);
 		break;
 	case E_UNEQUAL:
-		// FOO!=n -> FOO
+		/* FOO!=n -> FOO */
 		if (e->left.sym->type == S_TRISTATE) {
 			if (e->right.sym == &symbol_no) {
 				e->type = E_SYMBOL;
@@ -375,19 +375,19 @@ static struct expr *expr_join_or(struct expr *e1, struct expr *e2)
 		if (e1->type == E_EQUAL && e2->type == E_EQUAL &&
 		    ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_mod) ||
 		     (e1->right.sym == &symbol_mod && e2->right.sym == &symbol_yes))) {
-			// (a='y') || (a='m') -> (a!='n')
+			/* (a='y') || (a='m') -> (a!='n') */
 			return expr_alloc_comp(E_UNEQUAL, sym1, &symbol_no);
 		}
 		if (e1->type == E_EQUAL && e2->type == E_EQUAL &&
 		    ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_no) ||
 		     (e1->right.sym == &symbol_no && e2->right.sym == &symbol_yes))) {
-			// (a='y') || (a='n') -> (a!='m')
+			/* (a='y') || (a='n') -> (a!='m') */
 			return expr_alloc_comp(E_UNEQUAL, sym1, &symbol_mod);
 		}
 		if (e1->type == E_EQUAL && e2->type == E_EQUAL &&
 		    ((e1->right.sym == &symbol_mod && e2->right.sym == &symbol_no) ||
 		     (e1->right.sym == &symbol_no && e2->right.sym == &symbol_mod))) {
-			// (a='m') || (a='n') -> (a!='y')
+			/* (a='m') || (a='n') -> (a!='y') */
 			return expr_alloc_comp(E_UNEQUAL, sym1, &symbol_yes);
 		}
 	}
@@ -438,29 +438,29 @@ static struct expr *expr_join_and(struct expr *e1, struct expr *e2)
 
 	if ((e1->type == E_SYMBOL && e2->type == E_EQUAL && e2->right.sym == &symbol_yes) ||
 	    (e2->type == E_SYMBOL && e1->type == E_EQUAL && e1->right.sym == &symbol_yes))
-		// (a) && (a='y') -> (a='y')
+		/* (a) && (a='y') -> (a='y') */
 		return expr_alloc_comp(E_EQUAL, sym1, &symbol_yes);
 
 	if ((e1->type == E_SYMBOL && e2->type == E_UNEQUAL && e2->right.sym == &symbol_no) ||
 	    (e2->type == E_SYMBOL && e1->type == E_UNEQUAL && e1->right.sym == &symbol_no))
-		// (a) && (a!='n') -> (a)
+		/* (a) && (a!='n') -> (a) */
 		return expr_alloc_symbol(sym1);
 
 	if ((e1->type == E_SYMBOL && e2->type == E_UNEQUAL && e2->right.sym == &symbol_mod) ||
 	    (e2->type == E_SYMBOL && e1->type == E_UNEQUAL && e1->right.sym == &symbol_mod))
-		// (a) && (a!='m') -> (a='y')
+		/* (a) && (a!='m') -> (a='y') */
 		return expr_alloc_comp(E_EQUAL, sym1, &symbol_yes);
 
 	if (sym1->type == S_TRISTATE) {
 		if (e1->type == E_EQUAL && e2->type == E_UNEQUAL) {
-			// (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
+			/* (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b' */
 			sym2 = e1->right.sym;
 			if ((e2->right.sym->flags & SYMBOL_CONST) && (sym2->flags & SYMBOL_CONST))
 				return sym2 != e2->right.sym ? expr_alloc_comp(E_EQUAL, sym1, sym2)
 							     : expr_alloc_symbol(&symbol_no);
 		}
 		if (e1->type == E_UNEQUAL && e2->type == E_EQUAL) {
-			// (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
+			/* (a!='b') && (a='c') -> 'b'='c' ? 'n' : a='c' */
 			sym2 = e2->right.sym;
 			if ((e1->right.sym->flags & SYMBOL_CONST) && (sym2->flags & SYMBOL_CONST))
 				return sym2 != e1->right.sym ? expr_alloc_comp(E_EQUAL, sym1, sym2)
@@ -469,19 +469,19 @@ static struct expr *expr_join_and(struct expr *e1, struct expr *e2)
 		if (e1->type == E_UNEQUAL && e2->type == E_UNEQUAL &&
 			   ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_no) ||
 			    (e1->right.sym == &symbol_no && e2->right.sym == &symbol_yes)))
-			// (a!='y') && (a!='n') -> (a='m')
+			/* (a!='y') && (a!='n') -> (a='m') */
 			return expr_alloc_comp(E_EQUAL, sym1, &symbol_mod);
 
 		if (e1->type == E_UNEQUAL && e2->type == E_UNEQUAL &&
 			   ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_mod) ||
 			    (e1->right.sym == &symbol_mod && e2->right.sym == &symbol_yes)))
-			// (a!='y') && (a!='m') -> (a='n')
+			/* (a!='y') && (a!='m') -> (a='n') */
 			return expr_alloc_comp(E_EQUAL, sym1, &symbol_no);
 
 		if (e1->type == E_UNEQUAL && e2->type == E_UNEQUAL &&
 			   ((e1->right.sym == &symbol_mod && e2->right.sym == &symbol_no) ||
 			    (e1->right.sym == &symbol_no && e2->right.sym == &symbol_mod)))
-			// (a!='m') && (a!='n') -> (a='m')
+			/* (a!='m') && (a!='n') -> (a='y') */
 			return expr_alloc_comp(E_EQUAL, sym1, &symbol_yes);
 
 		if ((e1->type == E_SYMBOL && e2->type == E_EQUAL && e2->right.sym == &symbol_mod) ||
@@ -641,7 +641,7 @@ struct expr *expr_transform(struct expr *e)
 	case E_NOT:
 		switch (e->left.expr->type) {
 		case E_NOT:
-			// !!a -> a
+			/* !!a -> a */
 			tmp = e->left.expr->left.expr;
 			free(e->left.expr);
 			free(e);
@@ -650,14 +650,14 @@ struct expr *expr_transform(struct expr *e)
 			break;
 		case E_EQUAL:
 		case E_UNEQUAL:
-			// !a='x' -> a!='x'
+			/* !a='x' -> a!='x' */
 			tmp = e->left.expr;
 			free(e);
 			e = tmp;
 			e->type = e->type == E_EQUAL ? E_UNEQUAL : E_EQUAL;
 			break;
 		case E_OR:
-			// !(a || b) -> !a && !b
+			/* !(a || b) -> !a && !b */
 			tmp = e->left.expr;
 			e->type = E_AND;
 			e->right.expr = expr_alloc_one(E_NOT, tmp->right.expr);
@@ -666,7 +666,7 @@ struct expr *expr_transform(struct expr *e)
 			e = expr_transform(e);
 			break;
 		case E_AND:
-			// !(a && b) -> !a || !b
+			/* !(a && b) -> !a || !b */
 			tmp = e->left.expr;
 			e->type = E_OR;
 			e->right.expr = expr_alloc_one(E_NOT, tmp->right.expr);
@@ -676,7 +676,7 @@ struct expr *expr_transform(struct expr *e)
 			break;
 		case E_SYMBOL:
 			if (e->left.expr->left.sym == &symbol_yes) {
-				// !'y' -> 'n'
+				/* !'y' -> 'n' */
 				tmp = e->left.expr;
 				free(e);
 				e = tmp;
@@ -685,7 +685,7 @@ struct expr *expr_transform(struct expr *e)
 				break;
 			}
 			if (e->left.expr->left.sym == &symbol_mod) {
-				// !'m' -> 'm'
+				/* !'m' -> 'm' */
 				tmp = e->left.expr;
 				free(e);
 				e = tmp;
@@ -694,7 +694,7 @@ struct expr *expr_transform(struct expr *e)
 				break;
 			}
 			if (e->left.expr->left.sym == &symbol_no) {
-				// !'n' -> 'y'
+				/* !'n' -> 'y' */
 				tmp = e->left.expr;
 				free(e);
 				e = tmp;
-- 
1.8.3.2

