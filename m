Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaIVROe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:14:34 -0400
Received: from mout.web.de ([212.227.17.11]:54051 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbaIVROK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:14:10 -0400
From: Martin Walch <walch.martin@web.de>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Walch <walch.martin@web.de>
Subject: [PATCH v2 2/2] kconfig: trivial - adjust comments
Date: Mon, 22 Sep 2014 19:13:19 +0200
Message-Id: <1411405999-20212-3-git-send-email-walch.martin@web.de>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1411405999-20212-1-git-send-email-walch.martin@web.de>
References: <3491939.FtiyjGE4Of@tacticalops>
 <1411405999-20212-1-git-send-email-walch.martin@web.de>
X-Provags-ID: V03:K0:RUZ9ANPSqwiwZptojjAJRPJ3K02Nt7Td6lDonLuAVMLM2RIIZZO
 nMO/LkkvOYaHaOFk8HMmLiNVLnY1d3/KiIMQSCnbUw42S60cYlwEki6jqvPF7g2Tf4RRAA6
 42F1iyZQ3Mq8yoDOvHh2MNkt04XegtAVOf8L4jJEsBx8vUuF9y84apWA1ztAmRMQLvlvTXW
 thq4G30Rwflgc4yUIWgGg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.5.5

