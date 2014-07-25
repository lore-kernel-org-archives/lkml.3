Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbaGYQ15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:27:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:65409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934112AbaGYQ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:27:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,732,1400050800"; 
   d="scan'208";a="578993966"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] sched: Resolve some shadow warnings
Date: Fri, 25 Jul 2014 09:27:35 -0700
Message-Id: <1406305655-19019-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Using names like down and up, which are well-known semaphore
functions, makes those functions unavailable. This can be a
trap for the future, should there be reason to call down or
up here. Mostly it is just noise, so make it go away by using
other names.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 kernel/sched/sched.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f..a5f0f42 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -253,17 +253,17 @@ struct task_group {
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 extern int walk_tg_tree_from(struct task_group *from,
-			     tg_visitor down, tg_visitor up, void *data);
+			     tg_visitor in, tg_visitor out, void *data);
 
 /*
- * Iterate the full tree, calling @down when first entering a node and @up when
+ * Iterate the full tree, calling @in when first entering a node and @out when
  * leaving it for the final time.
  *
  * Caller must hold rcu_lock or sufficient equivalent.
  */
-static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+static inline int walk_tg_tree(tg_visitor in, tg_visitor out, void *data)
 {
-	return walk_tg_tree_from(&root_task_group, down, up, data);
+	return walk_tg_tree_from(&root_task_group, in, out, data);
 }
 
 extern int tg_nop(struct task_group *tg, void *data);
-- 
1.9.3

