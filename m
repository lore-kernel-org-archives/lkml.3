Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbaGWFKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:10:42 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:33997 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbaGWFKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:40 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 01/16] rcu: Use rcu_num_nodes instead of NUM_RCU_NODES
Date: Wed, 23 Jul 2014 01:09:38 -0400
Message-Id: <1406092194-13004-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUM_RCU_NODES is set at build time and is usually a huge number. We calculate
the actual number of rcu nodes necessary at boot time based on nr_cpu_ids in
rcu_init_geometry() and store it in rcu_num_nodes. We should use this variable
instead of NUM_RCU_NODES.

This commit changes all such NUM_RCU_NODES uses to rcu_num_nodes.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c31eb28..f07b643 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -885,7 +885,7 @@ void synchronize_rcu_expedited(void)
 	/* Snapshot current state of ->blkd_tasks lists. */
 	rcu_for_each_leaf_node(rsp, rnp)
 		sync_rcu_preempt_exp_init(rsp, rnp);
-	if (NUM_RCU_NODES > 1)
+	if (rcu_num_nodes > 1)
 		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
 
 	put_online_cpus();
@@ -1475,7 +1475,7 @@ static void __init rcu_spawn_boost_kthreads(void)
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
 	rnp = rcu_get_root(rcu_state_p);
 	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
-	if (NUM_RCU_NODES > 1) {
+	if (rcu_num_nodes > 1) {
 		rcu_for_each_leaf_node(rcu_state_p, rnp)
 			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	}
-- 
2.0.0.rc2

