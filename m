Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbaGWFKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:10:52 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46910 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbaGWFKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:49 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 05/16] rcu: Add noreturn attribute to boost kthread
Date: Wed, 23 Jul 2014 01:09:42 -0400
Message-Id: <1406092194-13004-6-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_boost_kthread() runs in an infinite loop and does not return. This commit
adds the __noreturn attribute to the function.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index bac9797..dd53247 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1222,7 +1222,7 @@ static int rcu_boost(struct rcu_node *rnp)
  * Priority-boosting kthread.  One per leaf rcu_node and one for the
  * root rcu_node.
  */
-static int rcu_boost_kthread(void *arg)
+static __noreturn int rcu_boost_kthread(void *arg)
 {
 	struct rcu_node *rnp = (struct rcu_node *)arg;
 	int spincnt = 0;
@@ -1250,7 +1250,6 @@ static int rcu_boost_kthread(void *arg)
 	}
 	/* NOTREACHED */
 	trace_rcu_utilization(TPS("End boost kthread@notreached"));
-	return 0;
 }
 
 /*
-- 
2.0.0.rc2

