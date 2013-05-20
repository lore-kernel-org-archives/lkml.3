Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab3ETO3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:29:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56981 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab3ETO3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:29:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/6] rcu: Convert rcutree_plugin.h printk calls
Date: Mon, 20 May 2013 07:28:45 -0700
Message-Id: <1369060129-28173-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060129-28173-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520142819.GA27123@linux.vnet.ibm.com>
 <1369060129-28173-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-7408-0000-0000-00001061EAA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit converts printk() calls to the corresponding pr_*() calls.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree_plugin.h | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3db5a37..207844e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -53,38 +53,37 @@ static char __initdata nocb_buf[NR_CPUS * 5];
 static void __init rcu_bootup_announce_oddness(void)
 {
 #ifdef CONFIG_RCU_TRACE
-	printk(KERN_INFO "\tRCU debugfs-based tracing is enabled.\n");
+	pr_info("\tRCU debugfs-based tracing is enabled.\n");
 #endif
 #if (defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 64) || (!defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 32)
-	printk(KERN_INFO "\tCONFIG_RCU_FANOUT set to non-default value of %d\n",
+	pr_info("\tCONFIG_RCU_FANOUT set to non-default value of %d\n",
 	       CONFIG_RCU_FANOUT);
 #endif
 #ifdef CONFIG_RCU_FANOUT_EXACT
-	printk(KERN_INFO "\tHierarchical RCU autobalancing is disabled.\n");
+	pr_info("\tHierarchical RCU autobalancing is disabled.\n");
 #endif
 #ifdef CONFIG_RCU_FAST_NO_HZ
-	printk(KERN_INFO
-	       "\tRCU dyntick-idle grace-period acceleration is enabled.\n");
+	pr_info("\tRCU dyntick-idle grace-period acceleration is enabled.\n");
 #endif
 #ifdef CONFIG_PROVE_RCU
-	printk(KERN_INFO "\tRCU lockdep checking is enabled.\n");
+	pr_info("\tRCU lockdep checking is enabled.\n");
 #endif
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
-	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
+	pr_info("\tRCU torture testing starts during boot.\n");
 #endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
-	printk(KERN_INFO "\tDump stacks of tasks blocking RCU-preempt GP.\n");
+	pr_info("\tDump stacks of tasks blocking RCU-preempt GP.\n");
 #endif
 #if defined(CONFIG_RCU_CPU_STALL_INFO)
-	printk(KERN_INFO "\tAdditional per-CPU info printed with stalls.\n");
+	pr_info("\tAdditional per-CPU info printed with stalls.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
-	printk(KERN_INFO "\tFour-level hierarchy is enabled.\n");
+	pr_info("\tFour-level hierarchy is enabled.\n");
 #endif
 	if (rcu_fanout_leaf != CONFIG_RCU_FANOUT_LEAF)
-		printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
+		pr_info("\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
-		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
+		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 	if (!have_rcu_nocb_mask) {
@@ -123,7 +122,7 @@ static int rcu_preempted_readers_exp(struct rcu_node *rnp);
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO "Preemptible hierarchical RCU implementation.\n");
+	pr_info("Preemptible hierarchical RCU implementation.\n");
 	rcu_bootup_announce_oddness();
 }
 
@@ -490,13 +489,13 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
 
 static void rcu_print_task_stall_begin(struct rcu_node *rnp)
 {
-	printk(KERN_ERR "\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
+	pr_err("\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
 	       rnp->level, rnp->grplo, rnp->grphi);
 }
 
 static void rcu_print_task_stall_end(void)
 {
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
@@ -526,7 +525,7 @@ static int rcu_print_task_stall(struct rcu_node *rnp)
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry) {
-		printk(KERN_CONT " P%d", t->pid);
+		pr_cont(" P%d", t->pid);
 		ndetected++;
 	}
 	rcu_print_task_stall_end();
@@ -942,7 +941,7 @@ static struct rcu_state *rcu_state = &rcu_sched_state;
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+	pr_info("Hierarchical RCU implementation.\n");
 	rcu_bootup_announce_oddness();
 }
 
@@ -1883,7 +1882,7 @@ static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 /* Initiate the stall-info list. */
 static void print_cpu_stall_info_begin(void)
 {
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 /*
@@ -1914,7 +1913,7 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 		ticks_value = rsp->gpnum - rdp->gpnum;
 	}
 	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
-	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
+	pr_err("\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
 	       cpu, ticks_value, ticks_title,
 	       atomic_read(&rdtp->dynticks) & 0xfff,
 	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
@@ -1925,7 +1924,7 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 /* Terminate the stall-info list. */
 static void print_cpu_stall_info_end(void)
 {
-	printk(KERN_ERR "\t");
+	pr_err("\t");
 }
 
 /* Zero ->ticks_this_gp for all flavors of RCU. */
@@ -1948,17 +1947,17 @@ static void increment_cpu_stall_ticks(void)
 
 static void print_cpu_stall_info_begin(void)
 {
-	printk(KERN_CONT " {");
+	pr_cont(" {");
 }
 
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 {
-	printk(KERN_CONT " %d", cpu);
+	pr_cont(" %d", cpu);
 }
 
 static void print_cpu_stall_info_end(void)
 {
-	printk(KERN_CONT "} ");
+	pr_cont("} ");
 }
 
 static void zero_cpu_stall_ticks(struct rcu_data *rdp)
-- 
1.8.1.5

