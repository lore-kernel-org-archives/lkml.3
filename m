Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaGWFMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:12:17 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:62255 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbaGWFLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:11:04 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 12/16] rcu: Rename rcu_spawn_gp_kthread() to  rcu_spawn_kthreads()
Date: Wed, 23 Jul 2014 01:09:49 -0400
Message-Id: <1406092194-13004-13-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are currently spawning all the threads from this functions. This commit
renames the function so that it reflects the current scenario better.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 3b20ad2..afd54e2 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3501,9 +3501,10 @@ static int rcu_pm_notify(struct notifier_block *self,
 }
 
 /*
- * Spawn the kthreads that handle each RCU flavor's grace periods.
+ * Spawn the kthreads that handle each RCU flavor's grace periods
+ * and the no-cb and boost kthreads.
  */
-static int __init rcu_spawn_gp_kthread(void)
+static int __init rcu_spawn_kthreads(void)
 {
 	unsigned long flags;
 	struct rcu_node *rnp;
@@ -3523,7 +3524,7 @@ static int __init rcu_spawn_gp_kthread(void)
 	rcu_spawn_boost_kthreads();
 	return 0;
 }
-early_initcall(rcu_spawn_gp_kthread);
+early_initcall(rcu_spawn_kthreads);
 
 /*
  * This function is invoked towards the end of the scheduler's initialization
-- 
2.0.0.rc2

