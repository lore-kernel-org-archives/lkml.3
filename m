Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaFFReo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:34:44 -0400
Received: from mout.web.de ([212.227.17.12]:52536 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaFFRem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:42 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>
Subject: [PATCHv2 01/13] list: Use argument hlist_add_after names from rcu variant
Date: Fri,  6 Jun 2014 19:34:20 +0200
Message-Id: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V03:K0:lTiBs9fL31fOhDhL3JgxioNH8YDR72tt3FHVa4s36oqo8R2QE8Q
 eS6h389RJcK+Fm4z2esq9h1yrgSzC1ta5JNPquKCde8aY3fFAaXnBufnxQgl9apMH7v1ElX
 zRdiLXJGAYNLul2OFoJGCvRwXZzjmd3nh+yC3obmd50juYb0He6mNaxlr41F3FIwoNBuIjJ
 l4KjVgM5KtcT8gEQ3Z84A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

The argument names of the hlist_add_after are poorly chosen because they look
the same as the ones from hlist_add_before but have to be used completely
different. This easily confuses the reader. The creator of the 
hlist_add_after_rcu function has made a lot better choice.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
---
v2:
Splitted into two patches

 include/linux/list.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index ef95941..624ec7f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -654,15 +654,15 @@ static inline void hlist_add_before(struct hlist_node *n,
 	*(n->pprev) = n;
 }
 
-static inline void hlist_add_after(struct hlist_node *n,
-					struct hlist_node *next)
+static inline void hlist_add_after(struct hlist_node *prev,
+				   struct hlist_node *n)
 {
-	next->next = n->next;
-	n->next = next;
-	next->pprev = &n->next;
+	n->next = prev->next;
+	prev->next = n;
+	n->pprev = &prev->next;
 
-	if(next->next)
-		next->next->pprev  = &next->next;
+	if (n->next)
+		n->next->pprev  = &n->next;
 }
 
 /* after that we'll appear to be on some hlist and hlist_del will work */
-- 
2.0.0

