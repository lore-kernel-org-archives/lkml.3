Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaHDJhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:37:23 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59998 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHDJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:37:20 -0400
Date: Mon, 4 Aug 2014 11:37:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.17
Message-ID: <20140804093713.GA23049@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   # HEAD: 01c9db827146ce321562a992a5dbc1a49b1a99ce Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The main changes:

  * Torture-test updates
  * Callback-offloading changes
  * Maintainership changes
  * Update RCU documentation
  * Miscellaneous fixes

 Thanks,

	Ingo

------------------>
Fabian Frederick (1):
      rcu: Make rcu node arrays static const char * const

Joe Perches (2):
      rcu: Update rcu torture maintainership filename patterns
      scripts: Teach get_maintainer.pl about the new "R:" tag

Kees Cook (1):
      torture: Avoid format string leak to thead name

Paul E. McKenney (25):
      rcu: Export debug_init_rcu_head() and and debug_init_rcu_head()
      rcu: Reduce overhead of cond_resched() checks for RCU
      torture: Enable versions without CFcommon to function correctly
      torture: Clean up diagnostics from --buildonly runs
      MAINTAINERS: Add "R:" designated-reviewers tag
      rcu: Add designated reviewers for RCU
      rcu: Parallelize and economize NOCB kthread wakeups
      rcu: Don't offload callbacks unless specifically requested
      documentation: Clarify wake-up/memory-barrier relationship
      documentation: Add acquire/release barriers to pairing rules
      documentation: Add pointer to percpu-ref for RCU and refcount
      rcu: Update RCU maintainership
      rcu: Document deadlock-avoidance information for rcu_read_unlock()
      rcu: Handle obsolete references to TINY_PREEMPT_RCU
      signal: Explain local_irq_save() call
      rcu: Remove redundant ACCESS_ONCE() from tick_do_timer_cpu
      rcu: Eliminate read-modify-write ACCESS_ONCE() calls
      rcu: Loosen __call_rcu()'s rcu_head alignment constraint
      rcu: Allow post-unlock reference for rt_mutex
      rcu: Simplify priority boosting by putting rt_mutex in rcu_node
      rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs
      rcu: Don't use NMIs to dump other CPUs' stacks
      rcu: Remove CONFIG_PROVE_RCU_DELAY
      rcu: Fix __rcu_reclaim() to use true/false for bool
      rcu: Allow for NULL tick_nohz_full_mask when nohz_full= missing

Pranith Kumar (4):
      documentation: Update reference, kerneltrap.org no longer works
      rcu: Check both root and current rcu_node when setting up future grace period
      rcu: Fix a sparse warning in rcu_initiate_boost()
      rcu: Fix a sparse warning in rcu_report_unblock_qs_rnp()

Shan Wei (1):
      rcu: Use __this_cpu_read() instead of per_cpu_ptr()


 Documentation/RCU/RTFP.txt                         |   4 +-
 Documentation/RCU/rcuref.txt                       |   9 +
 Documentation/kernel-parameters.txt                |  13 +
 Documentation/memory-barriers.txt                  |  27 +-
 MAINTAINERS                                        |  18 +-
 include/linux/init_task.h                          |   9 +-
 include/linux/rcupdate.h                           |  91 +++---
 include/linux/sched.h                              |   6 -
 include/linux/tick.h                               |  20 ++
 init/Kconfig                                       |   6 +-
 kernel/rcu/rcu.h                                   |   8 +-
 kernel/rcu/srcu.c                                  |   4 +-
 kernel/rcu/tree.c                                  | 199 ++++++++++----
 kernel/rcu/tree.h                                  |  42 ++-
 kernel/rcu/tree_plugin.h                           | 304 +++++++++++++++++----
 kernel/rcu/update.c                                |  25 +-
 kernel/sched/core.c                                |   7 +-
 kernel/signal.c                                    |   4 +
 kernel/time/tick-sched.c                           |  10 +
 kernel/torture.c                                   |   2 +-
 lib/Kconfig.debug                                  |  14 -
 scripts/get_maintainer.pl                          |  22 +-
 .../selftests/rcutorture/bin/kvm-recheck.sh        |   8 +-
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   9 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      |  21 +-
 .../selftests/rcutorture/configs/rcu/TREE01        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE02        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE02-T      |   1 -
 .../selftests/rcutorture/configs/rcu/TREE03        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE04        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE05        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE06        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE07        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE08        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE08-T      |   1 -
 .../selftests/rcutorture/configs/rcu/TREE09        |   1 -
 .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           |   1 -
 .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          |   1 -
 .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           |   1 -
 .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           |   1 -
 .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  |   1 -
 41 files changed, 629 insertions(+), 269 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 2f0fcb2..f29bcbc 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -2451,8 +2451,8 @@ lot of {Linux} into your technology!!!"
 ,month="February"
 ,year="2010"
 ,note="Available:
-\url{http://kerneltrap.com/mailarchive/linux-netdev/2010/2/26/6270589}
-[Viewed March 20, 2011]"
+\url{http://thread.gmane.org/gmane.linux.network/153338}
+[Viewed June 9, 2014]"
 ,annotation={
 	Use a pair of list_head structures to support RCU-protected
 	resizable hash tables.
diff --git a/Documentation/RCU/rcuref.txt b/Documentation/RCU/rcuref.txt
index 141d531..613033f 100644
--- a/Documentation/RCU/rcuref.txt
+++ b/Documentation/RCU/rcuref.txt
@@ -1,5 +1,14 @@
 Reference-count design for elements of lists/arrays protected by RCU.
 
+
+Please note that the percpu-ref feature is likely your first
+stop if you need to combine reference counts and RCU.  Please see
+include/linux/percpu-refcount.h for more information.  However, in
+those unusual cases where percpu-ref would consume too much memory,
+please read on.
+
+------------------------------------------------------------------------
+
 Reference counting on elements of lists which are protected by traditional
 reader/writer spinlocks or semaphores are straightforward:
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1b9aa8..6439c93 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2790,6 +2790,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			leaf rcu_node structure.  Useful for very large
 			systems.
 
+	rcutree.jiffies_till_sched_qs= [KNL]
+			Set required age in jiffies for a
+			given grace period before RCU starts
+			soliciting quiescent-state help from
+			rcu_note_context_switch().
+
 	rcutree.jiffies_till_first_fqs= [KNL]
 			Set delay from grace-period initialization to
 			first attempt to force quiescent states.
@@ -2801,6 +2807,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			quiescent states.  Units are jiffies, minimum
 			value is one, and maximum value is HZ.
 
+	rcutree.rcu_nocb_leader_stride= [KNL]
+			Set the number of NOCB kthread groups, which
+			defaults to the square root of the number of
+			CPUs.  Larger numbers reduces the wakeup overhead
+			on the per-CPU grace-period kthreads, but increases
+			that same overhead on each group's leader.
+
 	rcutree.qhimark= [KNL]
 			Set threshold of queued RCU callbacks beyond which
 			batch limiting is disabled.
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f1dc4a2..a4de88f 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -757,10 +757,14 @@ SMP BARRIER PAIRING
 When dealing with CPU-CPU interactions, certain types of memory barrier should
 always be paired.  A lack of appropriate pairing is almost certainly an error.
 
-A write barrier should always be paired with a data dependency barrier or read
-barrier, though a general barrier would also be viable.  Similarly a read
-barrier or a data dependency barrier should always be paired with at least an
-write barrier, though, again, a general barrier is viable:
+General barriers pair with each other, though they also pair with
+most other types of barriers, albeit without transitivity.  An acquire
+barrier pairs with a release barrier, but both may also pair with other
+barriers, including of course general barriers.  A write barrier pairs
+with a data dependency barrier, an acquire barrier, a release barrier,
+a read barrier, or a general barrier.  Similarly a read barrier or a
+data dependency barrier pairs with a write barrier, an acquire barrier,
+a release barrier, or a general barrier:
 
 	CPU 1		      CPU 2
 	===============	      ===============
@@ -1893,6 +1897,21 @@ between the STORE to indicate the event and the STORE to set TASK_RUNNING:
 	    <general barrier>		  STORE current->state
 	LOAD event_indicated
 
+To repeat, this write memory barrier is present if and only if something
+is actually awakened.  To see this, consider the following sequence of
+events, where X and Y are both initially zero:
+
+	CPU 1				CPU 2
+	===============================	===============================
+	X = 1;				STORE event_indicated
+	smp_mb();			wake_up();
+	Y = 1;				wait_event(wq, Y == 1);
+	wake_up();			  load from Y sees 1, no memory barrier
+					load from X might see 0
+
+In contrast, if a wakeup does occur, CPU 2's load from X would be guaranteed
+to see 1.
+
 The available waker functions include:
 
 	complete();
diff --git a/MAINTAINERS b/MAINTAINERS
index e31c874..6b829e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -70,6 +70,8 @@ Descriptions of section entries:
 
 	P: Person (obsolete)
 	M: Mail patches to: FullName <address@domain>
+	R: Designated reviewer: FullName <address@domain>
+	   These reviewers should be CCed on patches.
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
@@ -7426,10 +7428,14 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
-F:	kernel/rcu/torture.c
+F:	kernel/rcu/rcutorture.c
 
 RCUTORTURE TEST FRAMEWORK
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+M:	Josh Triplett <josh@joshtriplett.org>
+R:	Steven Rostedt <rostedt@goodmis.org>
+R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+R:	Lai Jiangshan <laijs@cn.fujitsu.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
@@ -7452,8 +7458,11 @@ S:	Supported
 F:	net/rds/
 
 READ-COPY UPDATE (RCU)
-M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+M:	Josh Triplett <josh@joshtriplett.org>
+R:	Steven Rostedt <rostedt@goodmis.org>
+R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+R:	Lai Jiangshan <laijs@cn.fujitsu.com>
 L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
@@ -7463,7 +7472,7 @@ X:	Documentation/RCU/torture.txt
 F:	include/linux/rcu*
 X:	include/linux/srcu.h
 F:	kernel/rcu/
-X:	kernel/rcu/torture.c
+X:	kernel/torture.c
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
@@ -8236,6 +8245,9 @@ F:	mm/sl?b*
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+M:	Josh Triplett <josh@joshtriplett.org>
+R:	Steven Rostedt <rostedt@goodmis.org>
+R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6df7f9f..2bb4c4f3 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -102,12 +102,6 @@ extern struct group_info init_groups;
 #define INIT_IDS
 #endif
 
-#ifdef CONFIG_RCU_BOOST
-#define INIT_TASK_RCU_BOOST()						\
-	.rcu_boost_mutex = NULL,
-#else
-#define INIT_TASK_RCU_BOOST()
-#endif
 #ifdef CONFIG_TREE_PREEMPT_RCU
 #define INIT_TASK_RCU_TREE_PREEMPT()					\
 	.rcu_blocked_node = NULL,
@@ -119,8 +113,7 @@ extern struct group_info init_groups;
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
-	INIT_TASK_RCU_TREE_PREEMPT()					\
-	INIT_TASK_RCU_BOOST()
+	INIT_TASK_RCU_TREE_PREEMPT()
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5a75d19..d231aa1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -44,7 +44,6 @@
 #include <linux/debugobjects.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
-#include <linux/percpu.h>
 #include <asm/barrier.h>
 
 extern int rcu_expedited; /* for sysctl */
@@ -300,41 +299,6 @@ bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
 
 /*
- * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
- */
-
-#define RCU_COND_RESCHED_LIM 256	/* ms vs. 100s of ms. */
-DECLARE_PER_CPU(int, rcu_cond_resched_count);
-void rcu_resched(void);
-
-/*
- * Is it time to report RCU quiescent states?
- *
- * Note unsynchronized access to rcu_cond_resched_count.  Yes, we might
- * increment some random CPU's count, and possibly also load the result from
- * yet another CPU's count.  We might even clobber some other CPU's attempt
- * to zero its counter.  This is all OK because the goal is not precision,
- * but rather reasonable amortization of rcu_note_context_switch() overhead
- * and extremely high probability of avoiding RCU CPU stall warnings.
- * Note that this function has to be preempted in just the wrong place,
- * many thousands of times in a row, for anything bad to happen.
- */
-static inline bool rcu_should_resched(void)
-{
-	return raw_cpu_inc_return(rcu_cond_resched_count) >=
-	       RCU_COND_RESCHED_LIM;
-}
-
-/*
- * Report quiscent states to RCU if it is time to do so.
- */
-static inline void rcu_cond_resched(void)
-{
-	if (unlikely(rcu_should_resched()))
-		rcu_resched();
-}
-
-/*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
  */
@@ -358,9 +322,19 @@ void wait_rcu_gp(call_rcu_func_t crf);
  * initialization.
  */
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+void init_rcu_head(struct rcu_head *head);
+void destroy_rcu_head(struct rcu_head *head);
 void init_rcu_head_on_stack(struct rcu_head *head);
 void destroy_rcu_head_on_stack(struct rcu_head *head);
 #else /* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void init_rcu_head(struct rcu_head *head)
+{
+}
+
+static inline void destroy_rcu_head(struct rcu_head *head)
+{
+}
+
 static inline void init_rcu_head_on_stack(struct rcu_head *head)
 {
 }
@@ -852,15 +826,14 @@ static inline void rcu_preempt_sleep_check(void)
  * read-side critical section that would block in a !PREEMPT kernel.
  * But if you want the full story, read on!
  *
- * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU), it
- * is illegal to block while in an RCU read-side critical section.  In
- * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
- * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
- * be preempted, but explicit blocking is illegal.  Finally, in preemptible
- * RCU implementations in real-time (with -rt patchset) kernel builds,
- * RCU read-side critical sections may be preempted and they may also
- * block, but only when acquiring spinlocks that are subject to priority
- * inheritance.
+ * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU),
+ * it is illegal to block while in an RCU read-side critical section.
+ * In preemptible RCU implementations (TREE_PREEMPT_RCU) in CONFIG_PREEMPT
+ * kernel builds, RCU read-side critical sections may be preempted,
+ * but explicit blocking is illegal.  Finally, in preemptible RCU
+ * implementations in real-time (with -rt patchset) kernel builds, RCU
+ * read-side critical sections may be preempted and they may also block, but
+ * only when acquiring spinlocks that are subject to priority inheritance.
  */
 static inline void rcu_read_lock(void)
 {
@@ -884,6 +857,34 @@ static inline void rcu_read_lock(void)
 /**
  * rcu_read_unlock() - marks the end of an RCU read-side critical section.
  *
+ * In most situations, rcu_read_unlock() is immune from deadlock.
+ * However, in kernels built with CONFIG_RCU_BOOST, rcu_read_unlock()
+ * is responsible for deboosting, which it does via rt_mutex_unlock().
+ * Unfortunately, this function acquires the scheduler's runqueue and
+ * priority-inheritance spinlocks.  This means that deadlock could result
+ * if the caller of rcu_read_unlock() already holds one of these locks or
+ * any lock that is ever acquired while holding them.
+ *
+ * That said, RCU readers are never priority boosted unless they were
+ * preempted.  Therefore, one way to avoid deadlock is to make sure
+ * that preemption never happens within any RCU read-side critical
+ * section whose outermost rcu_read_unlock() is called with one of
+ * rt_mutex_unlock()'s locks held.  Such preemption can be avoided in
+ * a number of ways, for example, by invoking preempt_disable() before
+ * critical section's outermost rcu_read_lock().
+ *
+ * Given that the set of locks acquired by rt_mutex_unlock() might change
+ * at any time, a somewhat more future-proofed approach is to make sure
+ * that that preemption never happens within any RCU read-side critical
+ * section whose outermost rcu_read_unlock() is called with irqs disabled.
+ * This approach relies on the fact that rt_mutex_unlock() currently only
+ * acquires irq-disabled locks.
+ *
+ * The second of these two approaches is best in most situations,
+ * however, the first approach can also be useful, at least to those
+ * developers willing to keep abreast of the set of locks acquired by
+ * rt_mutex_unlock().
+ *
  * See rcu_read_lock() for more information.
  */
 static inline void rcu_read_unlock(void)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..3cfbc05 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1270,9 +1270,6 @@ struct task_struct {
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rcu_boost_mutex;
-#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -2009,9 +2006,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	p->rcu_boost_mutex = NULL;
-#endif /* #ifdef CONFIG_RCU_BOOST */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..06cc093 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -12,6 +12,7 @@
 #include <linux/hrtimer.h>
 #include <linux/context_tracking_state.h>
 #include <linux/cpumask.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -162,6 +163,7 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 #ifdef CONFIG_NO_HZ_FULL
 extern bool tick_nohz_full_running;
 extern cpumask_var_t tick_nohz_full_mask;
+extern cpumask_var_t housekeeping_mask;
 
 static inline bool tick_nohz_full_enabled(void)
 {
@@ -194,6 +196,24 @@ static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
 #endif
 
+static inline bool is_housekeeping_cpu(int cpu)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_enabled())
+		return cpumask_test_cpu(cpu, housekeeping_mask);
+#endif
+	return true;
+}
+
+static inline void housekeeping_affine(struct task_struct *t)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_enabled())
+		set_cpus_allowed_ptr(t, housekeeping_mask);
+
+#endif
+}
+
 static inline void tick_nohz_full_check(void)
 {
 	if (tick_nohz_full_enabled())
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99..41066e4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -505,7 +505,7 @@ config PREEMPT_RCU
 	def_bool TREE_PREEMPT_RCU
 	help
 	  This option enables preemptible-RCU code that is common between
-	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
+	  TREE_PREEMPT_RCU and, in the old days, TINY_PREEMPT_RCU.
 
 config RCU_STALL_COMMON
 	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
@@ -737,7 +737,7 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL
+	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -751,7 +751,7 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL
+	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index bfda272..ff1a6de 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -99,6 +99,10 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 
 void kfree(const void *);
 
+/*
+ * Reclaim the specified callback, either by invoking it (non-lazy case)
+ * or freeing it directly (lazy case).  Return true if lazy, false otherwise.
+ */
 static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
@@ -108,12 +112,12 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
 		rcu_lock_release(&rcu_callback_map);
-		return 1;
+		return true;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
 		rcu_lock_release(&rcu_callback_map);
-		return 0;
+		return false;
 	}
 }
 
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index c639556..e037f3e 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -298,9 +298,9 @@ int __srcu_read_lock(struct srcu_struct *sp)
 
 	idx = ACCESS_ONCE(sp->completed) & 0x1;
 	preempt_disable();
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
+	__this_cpu_inc(sp->per_cpu_ref->c[idx]);
 	smp_mb(); /* B */  /* Avoid leaking the critical section. */
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
+	__this_cpu_inc(sp->per_cpu_ref->seq[idx]);
 	preempt_enable();
 	return idx;
 }
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba773..1b70cb6 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -206,6 +206,70 @@ void rcu_bh_qs(int cpu)
 	rdp->passed_quiesce = 1;
 }
 
+static DEFINE_PER_CPU(int, rcu_sched_qs_mask);
+
+static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
+	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
+	.dynticks = ATOMIC_INIT(1),
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	.dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE,
+	.dynticks_idle = ATOMIC_INIT(1),
+#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+};
+
+/*
+ * Let the RCU core know that this CPU has gone through the scheduler,
+ * which is a quiescent state.  This is called when the need for a
+ * quiescent state is urgent, so we burn an atomic operation and full
+ * memory barriers to let the RCU core know about it, regardless of what
+ * this CPU might (or might not) do in the near future.
+ *
+ * We inform the RCU core by emulating a zero-duration dyntick-idle
+ * period, which we in turn do by incrementing the ->dynticks counter
+ * by two.
+ */
+static void rcu_momentary_dyntick_idle(void)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+	struct rcu_dynticks *rdtp;
+	int resched_mask;
+	struct rcu_state *rsp;
+
+	local_irq_save(flags);
+
+	/*
+	 * Yes, we can lose flag-setting operations.  This is OK, because
+	 * the flag will be set again after some delay.
+	 */
+	resched_mask = raw_cpu_read(rcu_sched_qs_mask);
+	raw_cpu_write(rcu_sched_qs_mask, 0);
+
+	/* Find the flavor that needs a quiescent state. */
+	for_each_rcu_flavor(rsp) {
+		rdp = raw_cpu_ptr(rsp->rda);
+		if (!(resched_mask & rsp->flavor_mask))
+			continue;
+		smp_mb(); /* rcu_sched_qs_mask before cond_resched_completed. */
+		if (ACCESS_ONCE(rdp->mynode->completed) !=
+		    ACCESS_ONCE(rdp->cond_resched_completed))
+			continue;
+
+		/*
+		 * Pretend to be momentarily idle for the quiescent state.
+		 * This allows the grace-period kthread to record the
+		 * quiescent state, with no need for this CPU to do anything
+		 * further.
+		 */
+		rdtp = this_cpu_ptr(&rcu_dynticks);
+		smp_mb__before_atomic(); /* Earlier stuff before QS. */
+		atomic_add(2, &rdtp->dynticks);  /* QS. */
+		smp_mb__after_atomic(); /* Later stuff after QS. */
+		break;
+	}
+	local_irq_restore(flags);
+}
+
 /*
  * Note a context switch.  This is a quiescent state for RCU-sched,
  * and requires special handling for preemptible RCU.
@@ -216,19 +280,12 @@ void rcu_note_context_switch(int cpu)
 	trace_rcu_utilization(TPS("Start context switch"));
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
+	if (unlikely(raw_cpu_read(rcu_sched_qs_mask)))
+		rcu_momentary_dyntick_idle();
 	trace_rcu_utilization(TPS("End context switch"));
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
-static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
-	.dynticks = ATOMIC_INIT(1),
-#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
-	.dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE,
-	.dynticks_idle = ATOMIC_INIT(1),
-#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
-};
-
 static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
 static long qhimark = 10000;	/* If this many pending, ignore blimit. */
 static long qlowmark = 100;	/* Once only this many pending, use blimit. */
@@ -243,6 +300,13 @@ static ulong jiffies_till_next_fqs = ULONG_MAX;
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
 
+/*
+ * How long the grace period must be before we start recruiting
+ * quiescent-state help from rcu_note_context_switch().
+ */
+static ulong jiffies_till_sched_qs = HZ / 20;
+module_param(jiffies_till_sched_qs, ulong, 0644);
+
 static bool rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 				  struct rcu_data *rdp);
 static void force_qs_rnp(struct rcu_state *rsp,
@@ -853,6 +917,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 				    bool *isidle, unsigned long *maxj)
 {
 	unsigned int curr;
+	int *rcrmp;
 	unsigned int snap;
 
 	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
@@ -893,27 +958,43 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	}
 
 	/*
-	 * There is a possibility that a CPU in adaptive-ticks state
-	 * might run in the kernel with the scheduling-clock tick disabled
-	 * for an extended time period.  Invoke rcu_kick_nohz_cpu() to
-	 * force the CPU to restart the scheduling-clock tick in this
-	 * CPU is in this state.
-	 */
-	rcu_kick_nohz_cpu(rdp->cpu);
-
-	/*
-	 * Alternatively, the CPU might be running in the kernel
-	 * for an extended period of time without a quiescent state.
-	 * Attempt to force the CPU through the scheduler to gain the
-	 * needed quiescent state, but only if the grace period has gone
-	 * on for an uncommonly long time.  If there are many stuck CPUs,
-	 * we will beat on the first one until it gets unstuck, then move
-	 * to the next.  Only do this for the primary flavor of RCU.
+	 * A CPU running for an extended time within the kernel can
+	 * delay RCU grace periods.  When the CPU is in NO_HZ_FULL mode,
+	 * even context-switching back and forth between a pair of
+	 * in-kernel CPU-bound tasks cannot advance grace periods.
+	 * So if the grace period is old enough, make the CPU pay attention.
+	 * Note that the unsynchronized assignments to the per-CPU
+	 * rcu_sched_qs_mask variable are safe.  Yes, setting of
+	 * bits can be lost, but they will be set again on the next
+	 * force-quiescent-state pass.  So lost bit sets do not result
+	 * in incorrect behavior, merely in a grace period lasting
+	 * a few jiffies longer than it might otherwise.  Because
+	 * there are at most four threads involved, and because the
+	 * updates are only once every few jiffies, the probability of
+	 * lossage (and thus of slight grace-period extension) is
+	 * quite low.
+	 *
+	 * Note that if the jiffies_till_sched_qs boot/sysfs parameter
+	 * is set too high, we override with half of the RCU CPU stall
+	 * warning delay.
 	 */
-	if (rdp->rsp == rcu_state_p &&
+	rcrmp = &per_cpu(rcu_sched_qs_mask, rdp->cpu);
+	if (ULONG_CMP_GE(jiffies,
+			 rdp->rsp->gp_start + jiffies_till_sched_qs) ||
 	    ULONG_CMP_GE(jiffies, rdp->rsp->jiffies_resched)) {
-		rdp->rsp->jiffies_resched += 5;
-		resched_cpu(rdp->cpu);
+		if (!(ACCESS_ONCE(*rcrmp) & rdp->rsp->flavor_mask)) {
+			ACCESS_ONCE(rdp->cond_resched_completed) =
+				ACCESS_ONCE(rdp->mynode->completed);
+			smp_mb(); /* ->cond_resched_completed before *rcrmp. */
+			ACCESS_ONCE(*rcrmp) =
+				ACCESS_ONCE(*rcrmp) + rdp->rsp->flavor_mask;
+			resched_cpu(rdp->cpu);  /* Force CPU into scheduler. */
+			rdp->rsp->jiffies_resched += 5; /* Enable beating. */
+		} else if (ULONG_CMP_GE(jiffies, rdp->rsp->jiffies_resched)) {
+			/* Time to beat on that CPU again! */
+			resched_cpu(rdp->cpu);  /* Force CPU into scheduler. */
+			rdp->rsp->jiffies_resched += 5; /* Re-enable beating. */
+		}
 	}
 
 	return 0;
@@ -932,10 +1013,7 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 }
 
 /*
- * Dump stacks of all tasks running on stalled CPUs.  This is a fallback
- * for architectures that do not implement trigger_all_cpu_backtrace().
- * The NMI-triggered stack traces are more accurate because they are
- * printed by the target CPU.
+ * Dump stacks of all tasks running on stalled CPUs.
  */
 static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
 {
@@ -1013,7 +1091,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
 	if (ndetected == 0)
 		pr_err("INFO: Stall ended before state dump start\n");
-	else if (!trigger_all_cpu_backtrace())
+	else
 		rcu_dump_cpu_stacks(rsp);
 
 	/* Complain about tasks blocking the grace period. */
@@ -1044,8 +1122,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
 		jiffies - rsp->gp_start,
 		(long)rsp->gpnum, (long)rsp->completed, totqlen);
-	if (!trigger_all_cpu_backtrace())
-		dump_stack();
+	rcu_dump_cpu_stacks(rsp);
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, ACCESS_ONCE(rsp->jiffies_stall)))
@@ -1224,10 +1301,16 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 	 * believe that a grace period is in progress, then we must wait
 	 * for the one following, which is in "c".  Because our request
 	 * will be noticed at the end of the current grace period, we don't
-	 * need to explicitly start one.
+	 * need to explicitly start one.  We only do the lockless check
+	 * of rnp_root's fields if the current rcu_node structure thinks
+	 * there is no grace period in flight, and because we hold rnp->lock,
+	 * the only possible change is when rnp_root's two fields are
+	 * equal, in which case rnp_root->gpnum might be concurrently
+	 * incremented.  But that is OK, as it will just result in our
+	 * doing some extra useless work.
 	 */
 	if (rnp->gpnum != rnp->completed ||
-	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
+	    ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)) {
 		rnp->need_future_gp[c & 0x1]++;
 		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleaf"));
 		goto out;
@@ -1564,11 +1647,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->level, rnp->grplo,
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
-#ifdef CONFIG_PROVE_RCU_DELAY
-		if ((prandom_u32() % (rcu_num_nodes + 1)) == 0 &&
-		    system_state == SYSTEM_RUNNING)
-			udelay(200);
-#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
 	}
 
@@ -2266,7 +2344,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 	smp_mb(); /* List handling before counting for rcu_barrier(). */
 	rdp->qlen_lazy -= count_lazy;
-	ACCESS_ONCE(rdp->qlen) -= count;
+	ACCESS_ONCE(rdp->qlen) = rdp->qlen - count;
 	rdp->n_cbs_invoked += count;
 
 	/* Reinstate batch limit if we have worked down the excess. */
@@ -2404,14 +2482,14 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	struct rcu_node *rnp_old = NULL;
 
 	/* Funnel through hierarchy to reduce memory contention. */
-	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
+	rnp = __this_cpu_read(rsp->rda->mynode);
 	for (; rnp != NULL; rnp = rnp->parent) {
 		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
 		      !raw_spin_trylock(&rnp->fqslock);
 		if (rnp_old != NULL)
 			raw_spin_unlock(&rnp_old->fqslock);
 		if (ret) {
-			ACCESS_ONCE(rsp->n_force_qs_lh)++;
+			rsp->n_force_qs_lh++;
 			return;
 		}
 		rnp_old = rnp;
@@ -2423,7 +2501,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
-		ACCESS_ONCE(rsp->n_force_qs_lh)++;
+		rsp->n_force_qs_lh++;
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
@@ -2581,7 +2659,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	unsigned long flags;
 	struct rcu_data *rdp;
 
-	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
+	WARN_ON_ONCE((unsigned long)head & 0x1); /* Misaligned rcu_head! */
 	if (debug_rcu_head_queue(head)) {
 		/* Probable double call_rcu(), so leak the callback. */
 		ACCESS_ONCE(head->func) = rcu_leak_callback;
@@ -2612,7 +2690,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		local_irq_restore(flags);
 		return;
 	}
-	ACCESS_ONCE(rdp->qlen)++;
+	ACCESS_ONCE(rdp->qlen) = rdp->qlen + 1;
 	if (lazy)
 		rdp->qlen_lazy++;
 	else
@@ -3176,7 +3254,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * ACCESS_ONCE() to prevent the compiler from speculating
 	 * the increment to precede the early-exit check.
 	 */
-	ACCESS_ONCE(rsp->n_barrier_done)++;
+	ACCESS_ONCE(rsp->n_barrier_done) = rsp->n_barrier_done + 1;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 1);
 	_rcu_barrier_trace(rsp, "Inc1", -1, rsp->n_barrier_done);
 	smp_mb(); /* Order ->n_barrier_done increment with below mechanism. */
@@ -3226,7 +3304,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 
 	/* Increment ->n_barrier_done to prevent duplicate work. */
 	smp_mb(); /* Keep increment after above mechanism. */
-	ACCESS_ONCE(rsp->n_barrier_done)++;
+	ACCESS_ONCE(rsp->n_barrier_done) = rsp->n_barrier_done + 1;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 0);
 	_rcu_barrier_trace(rsp, "Inc2", -1, rsp->n_barrier_done);
 	smp_mb(); /* Keep increment before caller's subsequent code. */
@@ -3483,14 +3561,17 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 static void __init rcu_init_one(struct rcu_state *rsp,
 		struct rcu_data __percpu *rda)
 {
-	static char *buf[] = { "rcu_node_0",
-			       "rcu_node_1",
-			       "rcu_node_2",
-			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */
-	static char *fqs[] = { "rcu_node_fqs_0",
-			       "rcu_node_fqs_1",
-			       "rcu_node_fqs_2",
-			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const buf[] = {
+		"rcu_node_0",
+		"rcu_node_1",
+		"rcu_node_2",
+		"rcu_node_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const fqs[] = {
+		"rcu_node_fqs_0",
+		"rcu_node_fqs_1",
+		"rcu_node_fqs_2",
+		"rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
+	static u8 fl_mask = 0x1;
 	int cpustride = 1;
 	int i;
 	int j;
@@ -3509,6 +3590,8 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 	for (i = 1; i < rcu_num_lvls; i++)
 		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
 	rcu_init_levelspread(rsp);
+	rsp->flavor_mask = fl_mask;
+	fl_mask <<= 1;
 
 	/* Initialize the elements themselves, starting from the leaves. */
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bf2c1e6..71e64c7 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -172,6 +172,14 @@ struct rcu_node {
 				/*  queued on this rcu_node structure that */
 				/*  are blocking the current grace period, */
 				/*  there can be no such task. */
+	struct completion boost_completion;
+				/* Used to ensure that the rt_mutex used */
+				/*  to carry out the boosting is fully */
+				/*  released with no future boostee accesses */
+				/*  before that rt_mutex is re-initialized. */
+	struct rt_mutex boost_mtx;
+				/* Used only for the priority-boosting */
+				/*  side effect, not as a lock. */
 	unsigned long boost_time;
 				/* When to start boosting (jiffies). */
 	struct task_struct *boost_kthread_task;
@@ -307,6 +315,9 @@ struct rcu_data {
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
+	unsigned long cond_resched_completed;
+					/* Grace period that needs help */
+					/*  from cond_resched(). */
 
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
@@ -331,11 +342,29 @@ struct rcu_data {
 	struct rcu_head **nocb_tail;
 	atomic_long_t nocb_q_count;	/* # CBs waiting for kthread */
 	atomic_long_t nocb_q_count_lazy; /*  (approximate). */
+	struct rcu_head *nocb_follower_head; /* CBs ready to invoke. */
+	struct rcu_head **nocb_follower_tail;
+	atomic_long_t nocb_follower_count; /* # CBs ready to invoke. */
+	atomic_long_t nocb_follower_count_lazy; /*  (approximate). */
 	int nocb_p_count;		/* # CBs being invoked by kthread */
 	int nocb_p_count_lazy;		/*  (approximate). */
 	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
 	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
+
+	/* The following fields are used by the leader, hence own cacheline. */
+	struct rcu_head *nocb_gp_head ____cacheline_internodealigned_in_smp;
+					/* CBs waiting for GP. */
+	struct rcu_head **nocb_gp_tail;
+	long nocb_gp_count;
+	long nocb_gp_count_lazy;
+	bool nocb_leader_wake;		/* Is the nocb leader thread awake? */
+	struct rcu_data *nocb_next_follower;
+					/* Next follower in wakeup chain. */
+
+	/* The following fields are used by the follower, hence new cachline. */
+	struct rcu_data *nocb_leader ____cacheline_internodealigned_in_smp;
+					/* Leader CPU takes GP-end wakeups. */
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	/* 8) RCU CPU stall data. */
@@ -392,6 +421,7 @@ struct rcu_state {
 	struct rcu_node *level[RCU_NUM_LVLS];	/* Hierarchy levels. */
 	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
 	u8 levelspread[RCU_NUM_LVLS];		/* kids/node in each level. */
+	u8 flavor_mask;				/* bit in flavor mask. */
 	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
 		     void (*func)(struct rcu_head *head));
@@ -563,7 +593,7 @@ static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
-static void rcu_kick_nohz_cpu(int cpu);
+static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
 static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
@@ -583,8 +613,14 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 /* Sum up queue lengths for tracing. */
 static inline void rcu_nocb_q_lengths(struct rcu_data *rdp, long *ql, long *qll)
 {
-	*ql = atomic_long_read(&rdp->nocb_q_count) + rdp->nocb_p_count;
-	*qll = atomic_long_read(&rdp->nocb_q_count_lazy) + rdp->nocb_p_count_lazy;
+	*ql = atomic_long_read(&rdp->nocb_q_count) +
+	      rdp->nocb_p_count +
+	      atomic_long_read(&rdp->nocb_follower_count) +
+	      rdp->nocb_p_count + rdp->nocb_gp_count;
+	*qll = atomic_long_read(&rdp->nocb_q_count_lazy) +
+	       rdp->nocb_p_count_lazy +
+	       atomic_long_read(&rdp->nocb_follower_count_lazy) +
+	       rdp->nocb_p_count_lazy + rdp->nocb_gp_count_lazy;
 }
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 static inline void rcu_nocb_q_lengths(struct rcu_data *rdp, long *ql, long *qll)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cbc2c45..00dc411 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -33,6 +33,7 @@
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
+#include "../locking/rtmutex_common.h"
 #define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
 #else
 #define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
@@ -336,7 +337,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 	unsigned long flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rbmp = NULL;
+	bool drop_boost_mutex = false;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
 	int special;
@@ -398,11 +399,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
-		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
-		if (t->rcu_boost_mutex) {
-			rbmp = t->rcu_boost_mutex;
-			t->rcu_boost_mutex = NULL;
-		}
+		/* Snapshot ->boost_mtx ownership with rcu_node lock held. */
+		drop_boost_mutex = rt_mutex_owner(&rnp->boost_mtx) == t;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -427,8 +425,10 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (rbmp)
-			rt_mutex_unlock(rbmp);
+		if (drop_boost_mutex) {
+			rt_mutex_unlock(&rnp->boost_mtx);
+			complete(&rnp->boost_completion);
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -988,6 +988,7 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 
 /* Because preemptible RCU does not exist, no quieting of tasks. */
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
 {
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
@@ -1149,7 +1150,6 @@ static void rcu_wake_cond(struct task_struct *t, int status)
 static int rcu_boost(struct rcu_node *rnp)
 {
 	unsigned long flags;
-	struct rt_mutex mtx;
 	struct task_struct *t;
 	struct list_head *tb;
 
@@ -1200,11 +1200,15 @@ static int rcu_boost(struct rcu_node *rnp)
 	 * section.
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
-	rt_mutex_init_proxy_locked(&mtx, t);
-	t->rcu_boost_mutex = &mtx;
+	rt_mutex_init_proxy_locked(&rnp->boost_mtx, t);
+	init_completion(&rnp->boost_completion);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
-	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+	/* Lock only for side effect: boosts task t's priority. */
+	rt_mutex_lock(&rnp->boost_mtx);
+	rt_mutex_unlock(&rnp->boost_mtx);  /* Then keep lockdep happy. */
+
+	/* Wait for boostee to be done w/boost_mtx before reinitializing. */
+	wait_for_completion(&rnp->boost_completion);
 
 	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||
 	       ACCESS_ONCE(rnp->boost_tasks) != NULL;
@@ -1256,6 +1260,7 @@ static int rcu_boost_kthread(void *arg)
  * about it going away.
  */
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
 {
 	struct task_struct *t;
 
@@ -1491,6 +1496,7 @@ static void rcu_prepare_kthreads(int cpu)
 #else /* #ifdef CONFIG_RCU_BOOST */
 
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
 {
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
@@ -2060,6 +2066,22 @@ bool rcu_is_nocb_cpu(int cpu)
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
+ * Kick the leader kthread for this NOCB group.
+ */
+static void wake_nocb_leader(struct rcu_data *rdp, bool force)
+{
+	struct rcu_data *rdp_leader = rdp->nocb_leader;
+
+	if (!ACCESS_ONCE(rdp_leader->nocb_kthread))
+		return;
+	if (!ACCESS_ONCE(rdp_leader->nocb_leader_wake) || force) {
+		/* Prior xchg orders against prior callback enqueue. */
+		ACCESS_ONCE(rdp_leader->nocb_leader_wake) = true;
+		wake_up(&rdp_leader->nocb_wq);
+	}
+}
+
+/*
  * Enqueue the specified string of rcu_head structures onto the specified
  * CPU's no-CBs lists.  The CPU is specified by rdp, the head of the
  * string by rhp, and the tail of the string by rhtp.  The non-lazy/lazy
@@ -2093,7 +2115,8 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 	len = atomic_long_read(&rdp->nocb_q_count);
 	if (old_rhpp == &rdp->nocb_head) {
 		if (!irqs_disabled_flags(flags)) {
-			wake_up(&rdp->nocb_wq); /* ... if queue was empty ... */
+			/* ... if queue was empty ... */
+			wake_nocb_leader(rdp, false);
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
@@ -2103,7 +2126,8 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 		}
 		rdp->qlen_last_fqs_check = 0;
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
-		wake_up_process(t); /* ... or if many callbacks queued. */
+		/* ... or if many callbacks queued. */
+		wake_nocb_leader(rdp, true);
 		rdp->qlen_last_fqs_check = LONG_MAX / 2;
 		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
 	} else {
@@ -2213,13 +2237,150 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 }
 
 /*
+ * Leaders come here to wait for additional callbacks to show up.
+ * This function does not return until callbacks appear.
+ */
+static void nocb_leader_wait(struct rcu_data *my_rdp)
+{
+	bool firsttime = true;
+	bool gotcbs;
+	struct rcu_data *rdp;
+	struct rcu_head **tail;
+
+wait_again:
+
+	/* Wait for callbacks to appear. */
+	if (!rcu_nocb_poll) {
+		trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu, "Sleep");
+		wait_event_interruptible(my_rdp->nocb_wq,
+					 ACCESS_ONCE(my_rdp->nocb_leader_wake));
+		/* Memory barrier handled by smp_mb() calls below and repoll. */
+	} else if (firsttime) {
+		firsttime = false; /* Don't drown trace log with "Poll"! */
+		trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu, "Poll");
+	}
+
+	/*
+	 * Each pass through the following loop checks a follower for CBs.
+	 * We are our own first follower.  Any CBs found are moved to
+	 * nocb_gp_head, where they await a grace period.
+	 */
+	gotcbs = false;
+	for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower) {
+		rdp->nocb_gp_head = ACCESS_ONCE(rdp->nocb_head);
+		if (!rdp->nocb_gp_head)
+			continue;  /* No CBs here, try next follower. */
+
+		/* Move callbacks to wait-for-GP list, which is empty. */
+		ACCESS_ONCE(rdp->nocb_head) = NULL;
+		rdp->nocb_gp_tail = xchg(&rdp->nocb_tail, &rdp->nocb_head);
+		rdp->nocb_gp_count = atomic_long_xchg(&rdp->nocb_q_count, 0);
+		rdp->nocb_gp_count_lazy =
+			atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
+		gotcbs = true;
+	}
+
+	/*
+	 * If there were no callbacks, sleep a bit, rescan after a
+	 * memory barrier, and go retry.
+	 */
+	if (unlikely(!gotcbs)) {
+		if (!rcu_nocb_poll)
+			trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu,
+					    "WokeEmpty");
+		flush_signals(current);
+		schedule_timeout_interruptible(1);
+
+		/* Rescan in case we were a victim of memory ordering. */
+		my_rdp->nocb_leader_wake = false;
+		smp_mb();  /* Ensure _wake false before scan. */
+		for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower)
+			if (ACCESS_ONCE(rdp->nocb_head)) {
+				/* Found CB, so short-circuit next wait. */
+				my_rdp->nocb_leader_wake = true;
+				break;
+			}
+		goto wait_again;
+	}
+
+	/* Wait for one grace period. */
+	rcu_nocb_wait_gp(my_rdp);
+
+	/*
+	 * We left ->nocb_leader_wake set to reduce cache thrashing.
+	 * We clear it now, but recheck for new callbacks while
+	 * traversing our follower list.
+	 */
+	my_rdp->nocb_leader_wake = false;
+	smp_mb(); /* Ensure _wake false before scan of ->nocb_head. */
+
+	/* Each pass through the following loop wakes a follower, if needed. */
+	for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower) {
+		if (ACCESS_ONCE(rdp->nocb_head))
+			my_rdp->nocb_leader_wake = true; /* No need to wait. */
+		if (!rdp->nocb_gp_head)
+			continue; /* No CBs, so no need to wake follower. */
+
+		/* Append callbacks to follower's "done" list. */
+		tail = xchg(&rdp->nocb_follower_tail, rdp->nocb_gp_tail);
+		*tail = rdp->nocb_gp_head;
+		atomic_long_add(rdp->nocb_gp_count, &rdp->nocb_follower_count);
+		atomic_long_add(rdp->nocb_gp_count_lazy,
+				&rdp->nocb_follower_count_lazy);
+		if (rdp != my_rdp && tail == &rdp->nocb_follower_head) {
+			/*
+			 * List was empty, wake up the follower.
+			 * Memory barriers supplied by atomic_long_add().
+			 */
+			wake_up(&rdp->nocb_wq);
+		}
+	}
+
+	/* If we (the leader) don't have CBs, go wait some more. */
+	if (!my_rdp->nocb_follower_head)
+		goto wait_again;
+}
+
+/*
+ * Followers come here to wait for additional callbacks to show up.
+ * This function does not return until callbacks appear.
+ */
+static void nocb_follower_wait(struct rcu_data *rdp)
+{
+	bool firsttime = true;
+
+	for (;;) {
+		if (!rcu_nocb_poll) {
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    "FollowerSleep");
+			wait_event_interruptible(rdp->nocb_wq,
+						 ACCESS_ONCE(rdp->nocb_follower_head));
+		} else if (firsttime) {
+			/* Don't drown trace log with "Poll"! */
+			firsttime = false;
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, "Poll");
+		}
+		if (smp_load_acquire(&rdp->nocb_follower_head)) {
+			/* ^^^ Ensure CB invocation follows _head test. */
+			return;
+		}
+		if (!rcu_nocb_poll)
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    "WokeEmpty");
+		flush_signals(current);
+		schedule_timeout_interruptible(1);
+	}
+}
+
+/*
  * Per-rcu_data kthread, but only for no-CBs CPUs.  Each kthread invokes
- * callbacks queued by the corresponding no-CBs CPU.
+ * callbacks queued by the corresponding no-CBs CPU, however, there is
+ * an optional leader-follower relationship so that the grace-period
+ * kthreads don't have to do quite so many wakeups.
  */
 static int rcu_nocb_kthread(void *arg)
 {
 	int c, cl;
-	bool firsttime = 1;
 	struct rcu_head *list;
 	struct rcu_head *next;
 	struct rcu_head **tail;
@@ -2227,41 +2388,22 @@ static int rcu_nocb_kthread(void *arg)
 
 	/* Each pass through this loop invokes one batch of callbacks */
 	for (;;) {
-		/* If not polling, wait for next batch of callbacks. */
-		if (!rcu_nocb_poll) {
-			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-					    TPS("Sleep"));
-			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
-			/* Memory barrier provide by xchg() below. */
-		} else if (firsttime) {
-			firsttime = 0;
-			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-					    TPS("Poll"));
-		}
-		list = ACCESS_ONCE(rdp->nocb_head);
-		if (!list) {
-			if (!rcu_nocb_poll)
-				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-						    TPS("WokeEmpty"));
-			schedule_timeout_interruptible(1);
-			flush_signals(current);
-			continue;
-		}
-		firsttime = 1;
-		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-				    TPS("WokeNonEmpty"));
-
-		/*
-		 * Extract queued callbacks, update counts, and wait
-		 * for a grace period to elapse.
-		 */
-		ACCESS_ONCE(rdp->nocb_head) = NULL;
-		tail = xchg(&rdp->nocb_tail, &rdp->nocb_head);
-		c = atomic_long_xchg(&rdp->nocb_q_count, 0);
-		cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
-		ACCESS_ONCE(rdp->nocb_p_count) += c;
-		ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
-		rcu_nocb_wait_gp(rdp);
+		/* Wait for callbacks. */
+		if (rdp->nocb_leader == rdp)
+			nocb_leader_wait(rdp);
+		else
+			nocb_follower_wait(rdp);
+
+		/* Pull the ready-to-invoke callbacks onto local list. */
+		list = ACCESS_ONCE(rdp->nocb_follower_head);
+		BUG_ON(!list);
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, "WokeNonEmpty");
+		ACCESS_ONCE(rdp->nocb_follower_head) = NULL;
+		tail = xchg(&rdp->nocb_follower_tail, &rdp->nocb_follower_head);
+		c = atomic_long_xchg(&rdp->nocb_follower_count, 0);
+		cl = atomic_long_xchg(&rdp->nocb_follower_count_lazy, 0);
+		rdp->nocb_p_count += c;
+		rdp->nocb_p_count_lazy += cl;
 
 		/* Each pass through the following loop invokes a callback. */
 		trace_rcu_batch_start(rdp->rsp->name, cl, c, -1);
@@ -2305,7 +2447,7 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 	if (!rcu_nocb_need_deferred_wakeup(rdp))
 		return;
 	ACCESS_ONCE(rdp->nocb_defer_wakeup) = false;
-	wake_up(&rdp->nocb_wq);
+	wake_nocb_leader(rdp, false);
 	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
 }
 
@@ -2314,19 +2456,57 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 	rdp->nocb_tail = &rdp->nocb_head;
 	init_waitqueue_head(&rdp->nocb_wq);
+	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
 }
 
-/* Create a kthread for each RCU flavor for each no-CBs CPU. */
+/* How many follower CPU IDs per leader?  Default of -1 for sqrt(nr_cpu_ids). */
+static int rcu_nocb_leader_stride = -1;
+module_param(rcu_nocb_leader_stride, int, 0444);
+
+/*
+ * Create a kthread for each RCU flavor for each no-CBs CPU.
+ * Also initialize leader-follower relationships.
+ */
 static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 {
 	int cpu;
+	int ls = rcu_nocb_leader_stride;
+	int nl = 0;  /* Next leader. */
 	struct rcu_data *rdp;
+	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
+	struct rcu_data *rdp_prev = NULL;
 	struct task_struct *t;
 
 	if (rcu_nocb_mask == NULL)
 		return;
+#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
+	if (tick_nohz_full_running)
+		cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
+#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
+	if (ls == -1) {
+		ls = int_sqrt(nr_cpu_ids);
+		rcu_nocb_leader_stride = ls;
+	}
+
+	/*
+	 * Each pass through this loop sets up one rcu_data structure and
+	 * spawns one rcu_nocb_kthread().
+	 */
 	for_each_cpu(cpu, rcu_nocb_mask) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (rdp->cpu >= nl) {
+			/* New leader, set up for followers & next leader. */
+			nl = DIV_ROUND_UP(rdp->cpu + 1, ls) * ls;
+			rdp->nocb_leader = rdp;
+			rdp_leader = rdp;
+		} else {
+			/* Another follower, link to previous leader. */
+			rdp->nocb_leader = rdp_leader;
+			rdp_prev->nocb_next_follower = rdp;
+		}
+		rdp_prev = rdp;
+
+		/* Spawn the kthread for this CPU. */
 		t = kthread_run(rcu_nocb_kthread, rdp,
 				"rcuo%c/%d", rsp->abbr, cpu);
 		BUG_ON(IS_ERR(t));
@@ -2404,7 +2584,7 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
  * if an adaptive-ticks CPU is failing to respond to the current grace
  * period and has not be idle from an RCU perspective, kick it.
  */
-static void rcu_kick_nohz_cpu(int cpu)
+static void __maybe_unused rcu_kick_nohz_cpu(int cpu)
 {
 #ifdef CONFIG_NO_HZ_FULL
 	if (tick_nohz_full_cpu(cpu))
@@ -2843,12 +3023,16 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
  */
 static void rcu_bind_gp_kthread(void)
 {
-#ifdef CONFIG_NO_HZ_FULL
-	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
+	int __maybe_unused cpu;
 
-	if (cpu < 0 || cpu >= nr_cpu_ids)
+	if (!tick_nohz_full_enabled())
 		return;
-	if (raw_smp_processor_id() != cpu)
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	cpu = tick_do_timer_cpu;
+	if (cpu >= 0 && cpu < nr_cpu_ids && raw_smp_processor_id() != cpu)
 		set_cpus_allowed_ptr(current, cpumask_of(cpu));
-#endif /* #ifdef CONFIG_NO_HZ_FULL */
+#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+	if (!is_housekeeping_cpu(raw_smp_processor_id()))
+		housekeeping_affine(current);
+#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 }
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index a2aeb4d..4056d79 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -90,9 +90,6 @@ void __rcu_read_unlock(void)
 	} else {
 		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
-#ifdef CONFIG_PROVE_RCU_DELAY
-		udelay(10); /* Make preemption more probable. */
-#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
@@ -200,12 +197,12 @@ void wait_rcu_gp(call_rcu_func_t crf)
 EXPORT_SYMBOL_GPL(wait_rcu_gp);
 
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
-static inline void debug_init_rcu_head(struct rcu_head *head)
+void init_rcu_head(struct rcu_head *head)
 {
 	debug_object_init(head, &rcuhead_debug_descr);
 }
 
-static inline void debug_rcu_head_free(struct rcu_head *head)
+void destroy_rcu_head(struct rcu_head *head)
 {
 	debug_object_free(head, &rcuhead_debug_descr);
 }
@@ -350,21 +347,3 @@ static int __init check_cpu_stall_init(void)
 early_initcall(check_cpu_stall_init);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
-
-/*
- * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
- */
-
-DEFINE_PER_CPU(int, rcu_cond_resched_count);
-
-/*
- * Report a set of RCU quiescent states, for use by cond_resched()
- * and friends.  Out of line due to being called infrequently.
- */
-void rcu_resched(void)
-{
-	preempt_disable();
-	__this_cpu_write(rcu_cond_resched_count, 0);
-	rcu_note_context_switch(smp_processor_id());
-	preempt_enable();
-}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b..bc1638b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4147,7 +4147,6 @@ static void __cond_resched(void)
 
 int __sched _cond_resched(void)
 {
-	rcu_cond_resched();
 	if (should_resched()) {
 		__cond_resched();
 		return 1;
@@ -4166,18 +4165,15 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int __cond_resched_lock(spinlock_t *lock)
 {
-	bool need_rcu_resched = rcu_should_resched();
 	int resched = should_resched();
 	int ret = 0;
 
 	lockdep_assert_held(lock);
 
-	if (spin_needbreak(lock) || resched || need_rcu_resched) {
+	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
 		if (resched)
 			__cond_resched();
-		else if (unlikely(need_rcu_resched))
-			rcu_resched();
 		else
 			cpu_relax();
 		ret = 1;
@@ -4191,7 +4187,6 @@ int __sched __cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
-	rcu_cond_resched();  /* BH disabled OK, just recording QSes. */
 	if (should_resched()) {
 		local_bh_enable();
 		__cond_resched();
diff --git a/kernel/signal.c b/kernel/signal.c
index a4077e9..40b76e3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1263,6 +1263,10 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 	struct sighand_struct *sighand;
 
 	for (;;) {
+		/*
+		 * Disable interrupts early to avoid deadlocks.
+		 * See rcu_read_unlock() comment header for details.
+		 */
 		local_irq_save(*flags);
 		rcu_read_lock();
 		sighand = rcu_dereference(tsk->sighand);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..f784d83 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -154,6 +154,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 
 #ifdef CONFIG_NO_HZ_FULL
 cpumask_var_t tick_nohz_full_mask;
+cpumask_var_t housekeeping_mask;
 bool tick_nohz_full_running;
 
 static bool can_stop_full_tick(void)
@@ -281,6 +282,7 @@ static int __init tick_nohz_full_setup(char *str)
 	int cpu;
 
 	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+	alloc_bootmem_cpumask_var(&housekeeping_mask);
 	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
 		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
 		return 1;
@@ -291,6 +293,8 @@ static int __init tick_nohz_full_setup(char *str)
 		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
 		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
 	}
+	cpumask_andnot(housekeeping_mask,
+		       cpu_possible_mask, tick_nohz_full_mask);
 	tick_nohz_full_running = true;
 
 	return 1;
@@ -332,9 +336,15 @@ static int tick_nohz_init_all(void)
 		pr_err("NO_HZ: Can't allocate full dynticks cpumask\n");
 		return err;
 	}
+	if (!alloc_cpumask_var(&housekeeping_mask, GFP_KERNEL)) {
+		pr_err("NO_HZ: Can't allocate not-full dynticks cpumask\n");
+		return err;
+	}
 	err = 0;
 	cpumask_setall(tick_nohz_full_mask);
 	cpumask_clear_cpu(smp_processor_id(), tick_nohz_full_mask);
+	cpumask_clear(housekeeping_mask);
+	cpumask_set_cpu(smp_processor_id(), housekeeping_mask);
 	tick_nohz_full_running = true;
 #endif
 	return err;
diff --git a/kernel/torture.c b/kernel/torture.c
index 40bb511..d600af2 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -708,7 +708,7 @@ int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
 	int ret = 0;
 
 	VERBOSE_TOROUT_STRING(m);
-	*tp = kthread_run(fn, arg, s);
+	*tp = kthread_run(fn, arg, "%s", s);
 	if (IS_ERR(*tp)) {
 		ret = PTR_ERR(*tp);
 		VERBOSE_TOROUT_ERRSTRING(f);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa..12132e4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1131,20 +1131,6 @@ config PROVE_RCU_REPEATEDLY
 
 	 Say N if you are unsure.
 
-config PROVE_RCU_DELAY
-	bool "RCU debugging: preemptible RCU race provocation"
-	depends on DEBUG_KERNEL && PREEMPT_RCU
-	default n
-	help
-	 There is a class of races that involve an unlikely preemption
-	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
-	 been set to INT_MIN.  This feature inserts a delay at that
-	 point to increase the probability of these races.
-
-	 Say Y to increase probability of preemption of __rcu_read_unlock().
-
-	 Say N if you are unsure.
-
 config SPARSE_RCU_POINTER
 	bool "RCU debugging: sparse-based checks for pointer usage"
 	default n
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 4198788..d701627 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -21,6 +21,7 @@ my $lk_path = "./";
 my $email = 1;
 my $email_usename = 1;
 my $email_maintainer = 1;
+my $email_reviewer = 1;
 my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
@@ -202,6 +203,7 @@ if (!GetOptions(
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'mailmap!' => \$email_use_mailmap,
 		'm!' => \$email_maintainer,
+		'r!' => \$email_reviewer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
 		's!' => \$email_subscriber_list,
@@ -260,7 +262,8 @@ if ($sections) {
 }
 
 if ($email &&
-    ($email_maintainer + $email_list + $email_subscriber_list +
+    ($email_maintainer + $email_reviewer +
+     $email_list + $email_subscriber_list +
      $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
     die "$P: Please select at least 1 email option\n";
 }
@@ -750,6 +753,7 @@ MAINTAINER field selection options:
     --hg-since => hg history to use (default: $email_hg_since)
     --interactive => display a menu (mostly useful if used with the --git option)
     --m => include maintainer(s) if any
+    --r => include reviewer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
     --s => include subscriber only list(s) if any
@@ -1064,6 +1068,22 @@ sub add_categories {
 		    my $role = get_maintainer_role($i);
 		    push_email_addresses($pvalue, $role);
 		}
+	    } elsif ($ptype eq "R") {
+		my ($name, $address) = parse_email($pvalue);
+		if ($name eq "") {
+		    if ($i > 0) {
+			my $tv = $typevalue[$i - 1];
+			if ($tv =~ m/^(\C):\s*(.*)/) {
+			    if ($1 eq "P") {
+				$name = $2;
+				$pvalue = format_email($name, $address, $email_usename);
+			    }
+			}
+		    }
+		}
+		if ($email_reviewer) {
+		    push_email_addresses($pvalue, 'reviewer');
+		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
 	    } elsif ($ptype eq "W") {
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index ee1f6ca..3f6c9b7 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -54,10 +54,16 @@ do
 			if test -f "$i/qemu-cmd"
 			then
 				print_bug qemu failed
+				echo "   $i"
+			elif test -f "$i/buildonly"
+			then
+				echo Build-only run, no boot/test
+				configcheck.sh $i/.config $i/ConfigFragment
+				parse-build.sh $i/Make.out $configfile
 			else
 				print_bug Build failed
+				echo "   $i"
 			fi
-			echo "   $i"
 		fi
 	done
 done
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 27e544e..0f69dcb 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -42,6 +42,7 @@ grace=120
 
 T=/tmp/kvm-test-1-run.sh.$$
 trap 'rm -rf $T' 0
+touch $T
 
 . $KVM/bin/functions.sh
 . $KVPATH/ver_functions.sh
@@ -131,7 +132,10 @@ boot_args=$6
 
 cd $KVM
 kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
-echo ' ---' `date`: Starting kernel
+if test -z "$TORTURE_BUILDONLY"
+then
+	echo ' ---' `date`: Starting kernel
+fi
 
 # Generate -smp qemu argument.
 qemu_args="-nographic $qemu_args"
@@ -157,12 +161,13 @@ boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
 # Generate kernel-version-specific boot parameters
 boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
 
-echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 if test -n "$TORTURE_BUILDONLY"
 then
 	echo Build-only run specified, boot/test omitted.
+	touch $resdir/buildonly
 	exit 0
 fi
+echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 ( $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
 qemu_pid=$!
 commandcompleted=0
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 40285c5..589e9c3 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -340,12 +340,18 @@ function dump(first, pastlast)
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "rm -f " builddir ".ready"
-		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date`";
-		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date` >> " rd "/log";
+		print "if test -z \"$TORTURE_BUILDONLY\""
+		print "then"
+		print "\techo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date`";
+		print "\techo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date` >> " rd "/log";
+		print "fi"
 	}
 	print "wait"
-	print "echo ---- All kernel runs complete. `date`";
-	print "echo ---- All kernel runs complete. `date` >> " rd "/log";
+	print "if test -z \"$TORTURE_BUILDONLY\""
+	print "then"
+	print "\techo ---- All kernel runs complete. `date`";
+	print "\techo ---- All kernel runs complete. `date` >> " rd "/log";
+	print "fi"
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "echo ----", cfr[j], cpusr[j] ovf ": Build/run results:";
@@ -385,10 +391,7 @@ echo
 echo
 echo " --- `date` Test summary:"
 echo Results directory: $resdir/$ds
-if test -z "$TORTURE_BUILDONLY"
-then
-	kvm-recheck.sh $resdir/$ds
-fi
+kvm-recheck.sh $resdir/$ds
 ___EOF___
 
 if test "$dryrun" = script
@@ -403,7 +406,7 @@ then
 		sed -e 's/:.*$//' -e 's/^echo //'
 	exit 0
 else
-	# Not a dryru, so run the script.
+	# Not a dryrun, so run the script.
 	sh $T/script
 fi
 
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
index 9c827ec..063b707 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -15,7 +15,6 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ZERO=y
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
index 1a777b5..ea119ba 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
index 61c8d9c..19cf948 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE03 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
index c1f111c..f4567fb 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE03
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
@@ -14,7 +14,6 @@ CONFIG_RCU_FANOUT_LEAF=4
 CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE04 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
index 7dbd27c..0a262fb 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE04
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
index d0f32e5..3a06b97 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE05
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
@@ -18,7 +18,6 @@ CONFIG_RCU_NOCB_CPU_NONE=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_PROVE_RCU=y
-CONFIG_PROVE_RCU_DELAY=y
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE06 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
index 2e477df..8f084cc 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE06
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
@@ -19,7 +19,6 @@ CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_PROVE_RCU=y
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
index 042f86e..ab62255 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE07
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
@@ -17,7 +17,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
index 3438cee..69a2e25 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
index bf4523d..a0f32fb 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
@@ -18,7 +18,6 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE09 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
index 81e4f7c..b7a62a5 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE09
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
@@ -13,7 +13,6 @@ CONFIG_SUSPEND=n
 CONFIG_HIBERNATION=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
index ef624ce..a55c008 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
@@ -13,7 +13,6 @@ CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
 #CHECK#CONFIG_TREE_PREEMPT_RCU=y
 CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
 CONFIG_DEBUG_OBJECTS=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
 CONFIG_RT_MUTEXES=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
index ef624ce..a55c008 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
@@ -13,7 +13,6 @@ CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
 #CHECK#CONFIG_TREE_PREEMPT_RCU=y
 CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
 CONFIG_DEBUG_OBJECTS=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
 CONFIG_RT_MUTEXES=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
index ef624ce..a55c008 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
@@ -13,7 +13,6 @@ CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
 #CHECK#CONFIG_TREE_PREEMPT_RCU=y
 CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
 CONFIG_DEBUG_OBJECTS=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
 CONFIG_RT_MUTEXES=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
index ef624ce..a55c008 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
+++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
@@ -13,7 +13,6 @@ CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
 #CHECK#CONFIG_TREE_PREEMPT_RCU=y
 CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
 CONFIG_DEBUG_OBJECTS=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
 CONFIG_RT_MUTEXES=y
diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
index adbb76c..3e588db 100644
--- a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
+++ b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
@@ -14,7 +14,6 @@ CONFIG_NO_HZ_FULL_SYSIDLE -- Do one.
 CONFIG_PREEMPT -- Do half.  (First three and #8.)
 CONFIG_PROVE_LOCKING -- Do all but two, covering CONFIG_PROVE_RCU and not.
 CONFIG_PROVE_RCU -- Do all but one under CONFIG_PROVE_LOCKING.
-CONFIG_PROVE_RCU_DELAY -- Do one.
 CONFIG_RCU_BOOST -- one of TREE_PREEMPT_RCU.
 CONFIG_RCU_BOOST_PRIO -- set to 2 for _BOOST testing.
 CONFIG_RCU_CPU_STALL_INFO -- do one with and without _VERBOSE.
