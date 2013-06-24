Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3FXTc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:32:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:47562 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3FXTcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:32:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@freedesktop.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 29/32] rcu: delete __cpuinit usage from all rcu files
Date: Mon, 24 Jun 2013 15:30:34 -0400
Message-ID: <1372102237-8757-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the drivers/rcu uses of the __cpuinit macros
from all C files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 kernel/rcutorture.c     | 6 +++---
 kernel/rcutree.c        | 6 +++---
 kernel/rcutree.h        | 4 ++--
 kernel/rcutree_plugin.h | 6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index b1fa551..f4871e5 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1476,7 +1476,7 @@ rcu_torture_shutdown(void *arg)
  * Execute random CPU-hotplug operations at the interval specified
  * by the onoff_interval.
  */
-static int __cpuinit
+static int
 rcu_torture_onoff(void *arg)
 {
 	int cpu;
@@ -1558,7 +1558,7 @@ rcu_torture_onoff(void *arg)
 	return 0;
 }
 
-static int __cpuinit
+static int
 rcu_torture_onoff_init(void)
 {
 	int ret;
@@ -1601,7 +1601,7 @@ static void rcu_torture_onoff_cleanup(void)
  * CPU-stall kthread.  It waits as specified by stall_cpu_holdoff, then
  * induces a CPU stall for the time specified by stall_cpu.
  */
-static int __cpuinit rcu_torture_stall(void *args)
+static int rcu_torture_stall(void *args)
 {
 	unsigned long stop_at;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e08abb9..068de3a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2910,7 +2910,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
  * can accept some slop in the rsp->completed access due to the fact
  * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
-static void __cpuinit
+static void
 rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 {
 	unsigned long flags;
@@ -2962,7 +2962,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	mutex_unlock(&rsp->onoff_mutex);
 }
 
-static void __cpuinit rcu_prepare_cpu(int cpu)
+static void rcu_prepare_cpu(int cpu)
 {
 	struct rcu_state *rsp;
 
@@ -2974,7 +2974,7 @@ static void __cpuinit rcu_prepare_cpu(int cpu)
 /*
  * Handle CPU online/offline notification events.
  */
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+static int rcu_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4a39d36..b383258 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -521,10 +521,10 @@ static void invoke_rcu_callbacks_kthread(void);
 static bool rcu_is_callbacks_kthread(void);
 #ifdef CONFIG_RCU_BOOST
 static void rcu_preempt_do_callbacks(void);
-static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
-static void __cpuinit rcu_prepare_kthreads(int cpu);
+static void rcu_prepare_kthreads(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
 static void rcu_idle_count_callbacks_posted(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 63098a5..769e12e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1352,7 +1352,7 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
  * already exist.  We only create this kthread for preemptible RCU.
  * Returns zero if all is well, a negated errno otherwise.
  */
-static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp)
 {
 	int rnp_index = rnp - &rsp->node[0];
@@ -1507,7 +1507,7 @@ static int __init rcu_spawn_kthreads(void)
 }
 early_initcall(rcu_spawn_kthreads);
 
-static void __cpuinit rcu_prepare_kthreads(int cpu)
+static void rcu_prepare_kthreads(int cpu)
 {
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
@@ -1549,7 +1549,7 @@ static int __init rcu_scheduler_really_started(void)
 }
 early_initcall(rcu_scheduler_really_started);
 
-static void __cpuinit rcu_prepare_kthreads(int cpu)
+static void rcu_prepare_kthreads(int cpu)
 {
 }
 
-- 
1.8.1.2

