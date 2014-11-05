Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaKERnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:43:04 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47025 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaKERlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:44 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/10] rcu: Rename "empty" to "empty_norm" in preparation for boost rework
Date: Wed,  5 Nov 2014 09:41:27 -0800
Message-Id: <1415209294-2534-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141105174109.GA1306@linux.vnet.ibm.com>
 <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-0029-0000-0000-000005661B83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit undertakes a simple variable renaming to make way for
some rework of RCU priority boosting.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index d59913ef8360..3d22f0b2dea9 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -313,8 +313,8 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  */
 void rcu_read_unlock_special(struct task_struct *t)
 {
-	int empty;
 	int empty_exp;
+	int empty_norm;
 	int empty_exp_now;
 	unsigned long flags;
 	struct list_head *np;
@@ -367,7 +367,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
-		empty = !rcu_preempt_blocked_readers_cgp(rnp);
+		empty_norm = !rcu_preempt_blocked_readers_cgp(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		np = rcu_next_node_entry(t, rnp);
@@ -393,7 +393,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 		 * so we must take a snapshot of the expedited state.
 		 */
 		empty_exp_now = !rcu_preempted_readers_exp(rnp);
-		if (!empty && !rcu_preempt_blocked_readers_cgp(rnp)) {
+		if (!empty_norm && !rcu_preempt_blocked_readers_cgp(rnp)) {
 			trace_rcu_quiescent_state_report(TPS("preempt_rcu"),
 							 rnp->gpnum,
 							 0, rnp->qsmask,
-- 
1.8.1.5

