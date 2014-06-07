Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaFGQkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:40:24 -0400
Received: from mout.web.de ([212.227.17.11]:57664 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaFGQkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:40:19 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>
Subject: [PATCHv3 3/3] klist: Use same naming scheme as hlist for klist_add_after
Date: Sat,  7 Jun 2014 18:40:11 +0200
Message-Id: <1402159211-12629-3-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402159211-12629-1-git-send-email-kenhelias@web.de>
References: <1402159211-12629-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:pVY4plztHYIVNNNcMvwze7A2vcD/qvJqpuZGfTyc4sKd4pjZx33
 Fe8K9aWClcR6whq4tRjlKwVlopy3q9LlYHKUApzouQsCPUdap++nflpBvsEAQlVHhGgNuAt
 xUn78Dt4znwN58x3gqwZGvWmxFA3gRAezHSLsWJ+Kp5hWO5pvJg6GFzInyf5fVvpMvzsV78
 t9vtAykwTxH1gpP+jr2yQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

The name was modified from hlist_add_after to hlist_add_behind when adjusting
the order of arguments to match the one with klist_add_after. This is
necessary to avoid old code to compile against it when it would use it
the wrong way.

It would be good when klist would also follow this naming scheme to have a
consistent experience in all available list implementations.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
---
 include/linux/klist.h | 2 +-
 lib/klist.c           | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index a370ce5..61e5b72 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -44,7 +44,7 @@ struct klist_node {
 
 extern void klist_add_tail(struct klist_node *n, struct klist *k);
 extern void klist_add_head(struct klist_node *n, struct klist *k);
-extern void klist_add_after(struct klist_node *n, struct klist_node *pos);
+extern void klist_add_behind(struct klist_node *n, struct klist_node *pos);
 extern void klist_add_before(struct klist_node *n, struct klist_node *pos);
 
 extern void klist_del(struct klist_node *n);
diff --git a/lib/klist.c b/lib/klist.c
index 358a368..89b485a 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -140,11 +140,11 @@ void klist_add_tail(struct klist_node *n, struct klist *k)
 EXPORT_SYMBOL_GPL(klist_add_tail);
 
 /**
- * klist_add_after - Init a klist_node and add it after an existing node
+ * klist_add_behind - Init a klist_node and add it after an existing node
  * @n: node we're adding.
  * @pos: node to put @n after
  */
-void klist_add_after(struct klist_node *n, struct klist_node *pos)
+void klist_add_behind(struct klist_node *n, struct klist_node *pos)
 {
 	struct klist *k = knode_klist(pos);
 
@@ -153,7 +153,7 @@ void klist_add_after(struct klist_node *n, struct klist_node *pos)
 	list_add(&n->n_node, &pos->n_node);
 	spin_unlock(&k->k_lock);
 }
-EXPORT_SYMBOL_GPL(klist_add_after);
+EXPORT_SYMBOL_GPL(klist_add_behind);
 
 /**
  * klist_add_before - Init a klist_node and add it before an existing node
-- 
2.0.0

