Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbbAGSTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:19:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46779 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbbAGSTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/12] rcu: Make _batches_completed() functions return unsigned long
Date: Wed,  7 Jan 2015 10:19:28 -0800
Message-Id: <1420654779-11213-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0017-0000-0000-000007BDE459
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Long ago, the various ->completed fields were of type long, but now are
unsigned long due to signed-integer-overflow concerns.  However, the
various _batches_completed() functions remained of type long, even though
their only purpose in life is to return the corresponding ->completed
field.  This patch cleans this up by changing these functions' return
types to unsigned long.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h  | 4 ++--
 include/linux/rcutree.h  | 6 +++---
 kernel/rcu/tree.c        | 4 ++--
 kernel/rcu/tree.h        | 2 +-
 kernel/rcu/tree_plugin.h | 6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 0e5366200154..91f7e4c37800 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -94,7 +94,7 @@ static inline void rcu_virt_note_context_switch(int cpu)
 /*
  * Return the number of grace periods.
  */
-static inline long rcu_batches_completed(void)
+static inline unsigned long rcu_batches_completed(void)
 {
 	return 0;
 }
@@ -102,7 +102,7 @@ static inline long rcu_batches_completed(void)
 /*
  * Return the number of bottom-half grace periods.
  */
-static inline long rcu_batches_completed_bh(void)
+static inline unsigned long rcu_batches_completed_bh(void)
 {
 	return 0;
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 52953790dcca..9885bfb6b123 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -81,9 +81,9 @@ void cond_synchronize_rcu(unsigned long oldstate);
 
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
-long rcu_batches_completed(void);
-long rcu_batches_completed_bh(void);
-long rcu_batches_completed_sched(void);
+unsigned long rcu_batches_completed(void);
+unsigned long rcu_batches_completed_bh(void);
+unsigned long rcu_batches_completed_sched(void);
 void show_rcu_gp_kthreads(void);
 
 void rcu_force_quiescent_state(void);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4c106fcc0d54..e26d78712e16 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -317,7 +317,7 @@ static int rcu_pending(void);
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
  */
-long rcu_batches_completed_sched(void)
+unsigned long rcu_batches_completed_sched(void)
 {
 	return rcu_sched_state.completed;
 }
@@ -326,7 +326,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
 /*
  * Return the number of RCU BH batches processed thus far for debug & stats.
  */
-long rcu_batches_completed_bh(void)
+unsigned long rcu_batches_completed_bh(void)
 {
 	return rcu_bh_state.completed;
 }
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8e7b1843896e..1a07d7379ac6 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -546,7 +546,7 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
-long rcu_batches_completed(void);
+unsigned long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(void);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3ec85cb5d544..f69300d4a51f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -117,7 +117,7 @@ static void __init rcu_bootup_announce(void)
  * Return the number of RCU-preempt batches processed thus far
  * for debug and statistics.
  */
-static long rcu_batches_completed_preempt(void)
+static unsigned long rcu_batches_completed_preempt(void)
 {
 	return rcu_preempt_state.completed;
 }
@@ -126,7 +126,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_preempt);
 /*
  * Return the number of RCU batches processed thus far for debug & stats.
  */
-long rcu_batches_completed(void)
+unsigned long rcu_batches_completed(void)
 {
 	return rcu_batches_completed_preempt();
 }
@@ -935,7 +935,7 @@ static void __init rcu_bootup_announce(void)
 /*
  * Return the number of RCU batches processed thus far for debug & stats.
  */
-long rcu_batches_completed(void)
+unsigned long rcu_batches_completed(void)
 {
 	return rcu_batches_completed_sched();
 }
-- 
1.8.1.5

