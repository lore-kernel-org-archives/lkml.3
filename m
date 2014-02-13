Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaBMM52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:57:28 -0500
Received: from mout.web.de ([212.227.15.3]:59980 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbaBMM5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:57:23 -0500
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 2/2] kconfig: trivial - adjust comments
Date: Thu, 13 Feb 2014 13:57:21 +0100
Message-ID: <1552040.ObFWAZURHi@tacticalops>
User-Agent: KMail/4.12.2 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.12.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:T2Fv1wWBMfJF+iOz6PyfI/6vdMsWTIS2PawuoSN2jcM1ef4QEUN
 8/Xt49yex9zL3n460bs+uE+WzHD4hF1vFhPQmmUqtZyH4PVzaLn6urhittQZDNLs8oYk3OR
 gBzX4JOij82gy6aL5ORDCvpJIxNy4u4A9bDdGG5amofEEp2BlshaRZJFvviK6vylN9Ryj6U
 byiiUSmboPXU0/gIsxfTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Thu, 13 Feb 2014 12:17:06 +0100
Subject: [PATCH 2/2] kconfig: trivial - adjust comments

the line
(a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
is probably copy & paste from above, missing the adjustment done in the code.
It should probably read
(a!='b') && (a='c') -> 'b'='c' ? 'n' : a='c'

the second case is similar:
(a!='m') && (a!='n') -> (a='m')
should be
(a!='m') && (a!='n') -> (a='y')

This patch intentionally violates the checkpatch.pl style check by keeping C99 comments:
there are many of them, and consequently they all should be converted, but this is beyond
the scope of this patch.

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/expr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index 4aa171b..4b73854 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -460,7 +460,7 @@ static struct expr *expr_join_and(struct expr *e1, struct expr *e2)
 							     : expr_alloc_symbol(&symbol_no);
 		}
 		if (e1->type == E_UNEQUAL && e2->type == E_EQUAL) {
-			// (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
+			// (a!='b') && (a='c') -> 'b'='c' ? 'n' : a='c'
 			sym2 = e2->right.sym;
 			if ((e1->right.sym->flags & SYMBOL_CONST) && (sym2->flags & SYMBOL_CONST))
 				return sym2 != e1->right.sym ? expr_alloc_comp(E_EQUAL, sym1, sym2)
@@ -481,7 +481,7 @@ static struct expr *expr_join_and(struct expr *e1, struct expr *e2)
 		if (e1->type == E_UNEQUAL && e2->type == E_UNEQUAL &&
 			   ((e1->right.sym == &symbol_mod && e2->right.sym == &symbol_no) ||
 			    (e1->right.sym == &symbol_no && e2->right.sym == &symbol_mod)))
-			// (a!='m') && (a!='n') -> (a='m')
+			// (a!='m') && (a!='n') -> (a='y')
 			return expr_alloc_comp(E_EQUAL, sym1, &symbol_yes);
 
 		if ((e1->type == E_SYMBOL && e2->type == E_EQUAL && e2->right.sym == &symbol_mod) ||
-- 
1.8.3.2


