Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbaGWFLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:11:40 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:43967 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbaGWFLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:11:10 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 15/16] rcu: Check for a nocb cpu before trying to spawn nocb threads
Date: Wed, 23 Jul 2014 01:09:52 -0400
Message-Id: <1406092194-13004-16-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit tries to spawn nocb kthreads only when the CPU is marked as a nocb
cpu. This is a minor optimization.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 541c776..8abff0a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1490,7 +1490,8 @@ static void rcu_prepare_kthreads(int cpu)
 		return;
 
 	rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
-	rcu_spawn_all_nocb_kthreads(cpu);
+	if (rcu_is_nocb_cpu(cpu))
+		rcu_spawn_all_nocb_kthreads(cpu);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
-- 
2.0.0.rc2

