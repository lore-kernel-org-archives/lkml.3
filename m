Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbaGWFKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:10:49 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:44133 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaGWFKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:47 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 04/16] rcu: Remove redundant check for an online CPU
Date: Wed, 23 Jul 2014 01:09:41 -0400
Message-Id: <1406092194-13004-5-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_prcess_callbacks() is the softirq handler for RCU which is raised from
invoke_rcu_core() which is called from __call_rcu_core().

Each of these three functions checks if the cpu is online. We can remove the
redundant ones. This commit removes one of these redundant check.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 72e0b1f..044946e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2563,8 +2563,6 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	struct rcu_state *rsp;
 
-	if (cpu_is_offline(smp_processor_id()))
-		return;
 	trace_rcu_utilization(TPS("Start RCU core"));
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
-- 
2.0.0.rc2

