Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3GAJ0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:26:51 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48399 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3GAJ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:26:45 -0400
Date: Mon, 1 Jul 2013 11:26:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.11
Message-ID: <20130701092640.GA15384@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   HEAD: 2fd1b487884310d0aa0c0640179dc7490ad86313 Merge tag 'v3.10' into sched/core

The main changes:

 - load-calculation cleanups and improvements, by Alex Shi
 - various nohz related tidying up of statisics, by Frederic Weisbecker
 - factor out /proc functions to kernel/sched/proc.c, by Paul Gortmaker 
 - simplify the RT policy scheduler, by Kirill Tkhai
 - various fixes and cleanups

 Thanks,

	Ingo

------------------>
Alex Shi (13):
      Revert "sched: Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking"
      sched: Move a few runnable tg variables into CONFIG_SMP
      sched: Set an initial value of runnable avg for new forked task
      sched: Fix sleep time double accounting in enqueue entity
      sched: Update cpu load after task_tick
      sched: Compute runnable load avg in cpu_load and cpu_avg_load_per_task
      sched: Consider runnable load average in move_tasks()
      sched: Change cfs_rq load avg to unsigned long
      sched/tg: Use 'unsigned long' for load variable in task group
      sched/cfs_rq: Change atomic64_t removed_load to atomic_long_t
      sched/tg: Remove tg.load_weight
      sched: Change get_rq_runnable_load() to static and inline
      sched/debug: Remove CONFIG_FAIR_GROUP_SCHED mask

Frederic Weisbecker (5):
      sched: Update rq clock before migrating tasks out of dying CPU
      sched: Update rq clock before setting fair group shares
      sched: Update rq clock before calling check_preempt_curr()
      sched: Update rq clock earlier in unthrottle_cfs_rq
      sched: Use an accessor to read the rq clock

Gerald Schaefer (1):
      sched/autogroup: Fix race with task_groups list

Joe Perches (1):
      sched: Don't mix use of typedef ctl_table and struct ctl_table

Kamalesh Babulal (5):
      sched/fair: Remove unused variable from expire_cfs_rq_runtime()
      sched/debug: Add load-tracking statistics to task
      sched/fair: Fix typo describing flags in enqueue_entity
      sched: Fix typo in struct sched_avg member description
      sched/debug: Fix formatting of /proc/<PID>/sched

Kirill Tkhai (1):
      sched/rt: Simplify pull_rt_task() logic and remove .leaf_rt_rq_list

Michael Wang (2):
      sched: Refine the code in unthrottle_cfs_rq()
      sched: Femove the useless declaration in kernel/sched/fair.c

Nathan Zimmer (1):
      sched: Use this_rq() helper

Neil Zhang (1):
      sched: Remove redundant update_runtime notifier

Paul Gortmaker (2):
      sched: Factor out load calculation code from sched/core.c --> sched/proc.c
      sched: Move update_load_*() methods from sched.h to fair.c

Stanislaw Gruszka (1):
      sched: Use swap() macro in scale_stime()

Viresh Kumar (9):
      sched: Rename sched.c as sched/core.c in comments and Documentation
      sched: Remove unused params of build_sched_domain()
      sched: Optimize build_sched_domains() for saving first SD node for a cpu
      sched: Don't initialize alloc_state in build_sched_domains()
      sched: Don't set sd->child to NULL when it is already NULL
      sched: Create for_each_sd_topology()
      sched: Use cached value of span instead of calling sched_domain_span()
      sched: Fix memory leakage in build_sched_groups()
      sched: Remove WARN_ON(!sd) from init_sched_groups_power()


 Documentation/cgroups/cpusets.txt                 |   2 +-
 Documentation/rt-mutex-design.txt                 |   2 +-
 Documentation/scheduler/sched-domains.txt         |   4 +-
 Documentation/spinlocks.txt                       |   2 +-
 Documentation/virtual/uml/UserModeLinux-HOWTO.txt |   4 +-
 arch/avr32/kernel/process.c                       |   2 +-
 arch/cris/include/arch-v10/arch/bitops.h          |   2 +-
 arch/ia64/kernel/head.S                           |   2 +-
 arch/mips/kernel/mips-mt-fpaff.c                  |   4 +-
 arch/mips/kernel/scall32-o32.S                    |   5 +-
 arch/powerpc/include/asm/mmu_context.h            |   2 +-
 arch/tile/include/asm/processor.h                 |   2 +-
 arch/tile/kernel/stack.c                          |   2 +-
 arch/um/kernel/sysrq.c                            |   2 +-
 include/linux/completion.h                        |   2 +-
 include/linux/perf_event.h                        |   2 +-
 include/linux/sched.h                             |   9 +-
 include/linux/spinlock_up.h                       |   2 +-
 include/uapi/asm-generic/unistd.h                 |   2 +-
 kernel/cpuset.c                                   |   4 +-
 kernel/sched/Makefile                             |   2 +-
 kernel/sched/auto_group.c                         |   3 +-
 kernel/sched/core.c                               | 637 ++--------------------
 kernel/sched/cputime.c                            |   5 +-
 kernel/sched/debug.c                              |  37 +-
 kernel/sched/fair.c                               | 175 +++---
 kernel/sched/proc.c                               | 591 ++++++++++++++++++++
 kernel/sched/rt.c                                 | 132 +----
 kernel/sched/sched.h                              |  71 +--
 kernel/sched/stats.h                              |   8 +-
 kernel/sched/stop_task.c                          |   8 +-
 kernel/time.c                                     |   2 +-
 kernel/workqueue_internal.h                       |   2 +-
 33 files changed, 844 insertions(+), 887 deletions(-)
 create mode 100644 kernel/sched/proc.c

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 12e01d4..7740038 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -373,7 +373,7 @@ can become very uneven.
 1.7 What is sched_load_balance ?
 --------------------------------
 
-The kernel scheduler (kernel/sched.c) automatically load balances
+The kernel scheduler (kernel/sched/core.c) automatically load balances
 tasks.  If one CPU is underutilized, kernel code running on that
 CPU will look for tasks on other more overloaded CPUs and move those
 tasks to itself, within the constraints of such placement mechanisms
diff --git a/Documentation/rt-mutex-design.txt b/Documentation/rt-mutex-design.txt
index 33ed800..a5bcd7f 100644
--- a/Documentation/rt-mutex-design.txt
+++ b/Documentation/rt-mutex-design.txt
@@ -384,7 +384,7 @@ priority back.
 __rt_mutex_adjust_prio examines the result of rt_mutex_getprio, and if the
 result does not equal the task's current priority, then rt_mutex_setprio
 is called to adjust the priority of the task to the new priority.
-Note that rt_mutex_setprio is defined in kernel/sched.c to implement the
+Note that rt_mutex_setprio is defined in kernel/sched/core.c to implement the
 actual change in priority.
 
 It is interesting to note that __rt_mutex_adjust_prio can either increase
diff --git a/Documentation/scheduler/sched-domains.txt b/Documentation/scheduler/sched-domains.txt
index 443f0c7..4af80b1 100644
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -25,7 +25,7 @@ is treated as one entity. The load of a group is defined as the sum of the
 load of each of its member CPUs, and only when the load of a group becomes
 out of balance are tasks moved between groups.
 
-In kernel/sched.c, trigger_load_balance() is run periodically on each CPU
+In kernel/sched/core.c, trigger_load_balance() is run periodically on each CPU
 through scheduler_tick(). It raises a softirq after the next regularly scheduled
 rebalancing event for the current runqueue has arrived. The actual load
 balancing workhorse, run_rebalance_domains()->rebalance_domains(), is then run
@@ -62,7 +62,7 @@ struct sched_domain fields, SD_FLAG_*, SD_*_INIT to get an idea of
 the specifics and what to tune.
 
 Architectures may retain the regular override the default SD_*_INIT flags
-while using the generic domain builder in kernel/sched.c if they wish to
+while using the generic domain builder in kernel/sched/core.c if they wish to
 retain the traditional SMT->SMP->NUMA topology (or some subset of that). This
 can be done by #define'ing ARCH_HASH_SCHED_TUNE.
 
diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
index 9dbe885..97eaf57 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/spinlocks.txt
@@ -137,7 +137,7 @@ don't block on each other (and thus there is no dead-lock wrt interrupts.
 But when you do the write-lock, you have to use the irq-safe version. 
 
 For an example of being clever with rw-locks, see the "waitqueue_lock" 
-handling in kernel/sched.c - nothing ever _changes_ a wait-queue from
+handling in kernel/sched/core.c - nothing ever _changes_ a wait-queue from
 within an interrupt, they only read the queue in order to know whom to
 wake up. So read-locks are safe (which is good: they are very common
 indeed), while write-locks need to protect themselves against interrupts.
diff --git a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt b/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
index a5f8436..f4099ca 100644
--- a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
+++ b/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
@@ -3127,7 +3127,7 @@
            at process_kern.c:156
        #3  0x1006a052 in switch_to (prev=0x50072000, next=0x507e8000, last=0x50072000)
            at process_kern.c:161
-       #4  0x10001d12 in schedule () at sched.c:777
+       #4  0x10001d12 in schedule () at core.c:777
        #5  0x1006a744 in __down (sem=0x507d241c) at semaphore.c:71
        #6  0x1006aa10 in __down_failed () at semaphore.c:157
        #7  0x1006c5d8 in segv_handler (sc=0x5006e940) at trap_user.c:174
@@ -3191,7 +3191,7 @@
            at process_kern.c:161
        161       _switch_to(prev, next);
        (gdb)
-       #4  0x10001d12 in schedule () at sched.c:777
+       #4  0x10001d12 in schedule () at core.c:777
        777             switch_to(prev, next, prev);
        (gdb)
        #5  0x1006a744 in __down (sem=0x507d241c) at semaphore.c:71
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index e7b6149..c273100 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -341,7 +341,7 @@ unsigned long get_wchan(struct task_struct *p)
 		 * is actually quite ugly. It might be possible to
 		 * determine the frame size automatically at build
 		 * time by doing this:
-		 *   - compile sched.c
+		 *   - compile sched/core.c
 		 *   - disassemble the resulting sched.o
 		 *   - look for 'sub sp,??' shortly after '<schedule>:'
 		 */
diff --git a/arch/cris/include/arch-v10/arch/bitops.h b/arch/cris/include/arch-v10/arch/bitops.h
index be85f6d..03d9cfd 100644
--- a/arch/cris/include/arch-v10/arch/bitops.h
+++ b/arch/cris/include/arch-v10/arch/bitops.h
@@ -17,7 +17,7 @@ static inline unsigned long cris_swapnwbrlz(unsigned long w)
 	   in another register:
 	   !  __asm__ ("swapnwbr %2\n\tlz %2,%0"
 	   !	      : "=r,r" (res), "=r,X" (dummy) : "1,0" (w));
-	   confuses gcc (sched.c, gcc from cris-dist-1.14).  */
+	   confuses gcc (core.c, gcc from cris-dist-1.14).  */
 
 	unsigned long res;
 	__asm__ ("swapnwbr %0 \n\t"
diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index 9be4e49..991ca33 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -1035,7 +1035,7 @@ END(ia64_delay_loop)
  * Return a CPU-local timestamp in nano-seconds.  This timestamp is
  * NOT synchronized across CPUs its return value must never be
  * compared against the values returned on another CPU.  The usage in
- * kernel/sched.c ensures that.
+ * kernel/sched/core.c ensures that.
  *
  * The return-value of sched_clock() is NOT supposed to wrap-around.
  * If it did, it would cause some scheduling hiccups (at the worst).
diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index fd814e0..cb09862 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -27,12 +27,12 @@ unsigned long mt_fpemul_threshold;
  * FPU affinity with the user's requested processor affinity.
  * This code is 98% identical with the sys_sched_setaffinity()
  * and sys_sched_getaffinity() system calls, and should be
- * updated when kernel/sched.c changes.
+ * updated when kernel/sched/core.c changes.
  */
 
 /*
  * find_process_by_pid - find a process with a matching PID value.
- * used in sys_sched_set/getaffinity() in kernel/sched.c, so
+ * used in sys_sched_set/getaffinity() in kernel/sched/core.c, so
  * cloned here.
  */
 static inline struct task_struct *find_process_by_pid(pid_t pid)
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 9b36424..e9127ec 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -476,8 +476,9 @@ einval: li	v0, -ENOSYS
 	/*
 	 * For FPU affinity scheduling on MIPS MT processors, we need to
 	 * intercept sys_sched_xxxaffinity() calls until we get a proper hook
-	 * in kernel/sched.c.  Considered only temporary we only support these
-	 * hooks for the 32-bit kernel - there is no MIPS64 MT processor atm.
+	 * in kernel/sched/core.c.  Considered only temporary we only support
+	 * these hooks for the 32-bit kernel - there is no MIPS64 MT processor
+	 * atm.
 	 */
 	sys	mipsmt_sys_sched_setaffinity	3
 	sys	mipsmt_sys_sched_getaffinity	3
diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index a73668a..b467530 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -38,7 +38,7 @@ extern void drop_cop(unsigned long acop, struct mm_struct *mm);
 
 /*
  * switch_mm is the entry point called from the architecture independent
- * code in kernel/sched.c
+ * code in kernel/sched/core.c
  */
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 2b70dfb..b3f1049 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -225,7 +225,7 @@ extern int do_work_pending(struct pt_regs *regs, u32 flags);
 
 /*
  * Return saved (kernel) PC of a blocked thread.
- * Only used in a printk() in kernel/sched.c, so don't work too hard.
+ * Only used in a printk() in kernel/sched/core.c, so don't work too hard.
  */
 #define thread_saved_pc(t)   ((t)->thread.pc)
 
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index ed258b8..af8dfc9 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -442,7 +442,7 @@ void _KBacktraceIterator_init_current(struct KBacktraceIterator *kbt, ulong pc,
 				regs_to_pt_regs(&regs, pc, lr, sp, r52));
 }
 
-/* This is called only from kernel/sched.c, with esp == NULL */
+/* This is called only from kernel/sched/core.c, with esp == NULL */
 void show_stack(struct task_struct *task, unsigned long *esp)
 {
 	struct KBacktraceIterator kbt;
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 7d101a2..0dc4d1c 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -39,7 +39,7 @@ void show_trace(struct task_struct *task, unsigned long * stack)
 static const int kstack_depth_to_print = 24;
 
 /* This recently started being used in arch-independent code too, as in
- * kernel/sched.c.*/
+ * kernel/sched/core.c.*/
 void show_stack(struct task_struct *task, unsigned long *esp)
 {
 	unsigned long *stack;
diff --git a/include/linux/completion.h b/include/linux/completion.h
index 33f0280..3cd574d 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -5,7 +5,7 @@
  * (C) Copyright 2001 Linus Torvalds
  *
  * Atomic wait-for-completion handler data structures.
- * See kernel/sched.c for details.
+ * See kernel/sched/core.c for details.
  */
 
 #include <linux/wait.h>
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c5b6dbf..8650c73 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -802,7 +802,7 @@ static inline void perf_restore_debug_store(void)			{ }
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
 /*
- * This has to have a higher priority than migration_notifier in sched.c.
+ * This has to have a higher priority than migration_notifier in sched/core.c.
  */
 #define perf_cpu_notifier(fn)						\
 do {									\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..ec80684 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -924,7 +924,7 @@ struct load_weight {
 struct sched_avg {
 	/*
 	 * These sums represent an infinite geometric series and so are bound
-	 * above by 1024/(1-y).  Thus we only need a u32 to store them for for all
+	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
 	 * choices of y < 1-2^(-32)*1024.
 	 */
 	u32 runnable_avg_sum, runnable_avg_period;
@@ -994,12 +994,7 @@ struct sched_entity {
 	struct cfs_rq		*my_q;
 #endif
 
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	/* Per-entity load-tracking */
 	struct sched_avg	avg;
 #endif
diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index e2369c1..8b3ac0d 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -67,7 +67,7 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 
 #else /* DEBUG_SPINLOCK */
 #define arch_spin_is_locked(lock)	((void)(lock), 0)
-/* for sched.c and kernel_lock.c: */
+/* for sched/core.c and kernel_lock.c: */
 # define arch_spin_lock(lock)		do { barrier(); (void)(lock); } while (0)
 # define arch_spin_lock_flags(lock, flags)	do { barrier(); (void)(lock); } while (0)
 # define arch_spin_unlock(lock)	do { barrier(); (void)(lock); } while (0)
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 0cc74c4..a20a9b4 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -361,7 +361,7 @@ __SYSCALL(__NR_syslog, sys_syslog)
 #define __NR_ptrace 117
 __SYSCALL(__NR_ptrace, sys_ptrace)
 
-/* kernel/sched.c */
+/* kernel/sched/core.c */
 #define __NR_sched_setparam 118
 __SYSCALL(__NR_sched_setparam, sys_sched_setparam)
 #define __NR_sched_setscheduler 119
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 64b3f79..902d13f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -540,7 +540,7 @@ static void update_domain_attr_tree(struct sched_domain_attr *dattr,
  * This function builds a partial partition of the systems CPUs
  * A 'partial partition' is a set of non-overlapping subsets whose
  * union is a subset of that set.
- * The output of this function needs to be passed to kernel/sched.c
+ * The output of this function needs to be passed to kernel/sched/core.c
  * partition_sched_domains() routine, which will rebuild the scheduler's
  * load balancing domains (sched domains) as specified by that partial
  * partition.
@@ -569,7 +569,7 @@ static void update_domain_attr_tree(struct sched_domain_attr *dattr,
  *	   is a subset of one of these domains, while there are as
  *	   many such domains as possible, each as small as possible.
  * doms  - Conversion of 'csa' to an array of cpumasks, for passing to
- *	   the kernel/sched.c routine partition_sched_domains() in a
+ *	   the kernel/sched/core.c routine partition_sched_domains() in a
  *	   convenient format, that can be easily compared to the prior
  *	   value to determine what partition elements (sched domains)
  *	   were changed (added or removed.)
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index deaf90e..54adcf3 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -11,7 +11,7 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
-obj-y += core.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
+obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 64de5f8..4a07353 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -77,8 +77,6 @@ static inline struct autogroup *autogroup_create(void)
 	if (IS_ERR(tg))
 		goto out_free;
 
-	sched_online_group(tg, &root_task_group);
-
 	kref_init(&ag->kref);
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
@@ -98,6 +96,7 @@ static inline struct autogroup *autogroup_create(void)
 #endif
 	tg->autogroup = ag;
 
+	sched_online_group(tg, &root_task_group);
 	return ag;
 
 out_free:
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b3350..9b1f2e5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -679,7 +679,7 @@ void sched_avg_update(struct rq *rq)
 {
 	s64 period = sched_avg_period();
 
-	while ((s64)(rq->clock - rq->age_stamp) > period) {
+	while ((s64)(rq_clock(rq) - rq->age_stamp) > period) {
 		/*
 		 * Inline assembly required to prevent the compiler
 		 * optimising this loop into a divmod call.
@@ -1340,7 +1340,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 		p->sched_class->task_woken(rq, p);
 
 	if (rq->idle_stamp) {
-		u64 delta = rq->clock - rq->idle_stamp;
+		u64 delta = rq_clock(rq) - rq->idle_stamp;
 		u64 max = 2*sysctl_sched_migration_cost;
 
 		if (delta > max)
@@ -1377,6 +1377,8 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 
 	rq = __task_rq_lock(p);
 	if (p->on_rq) {
+		/* check_preempt_curr() may use rq clock */
+		update_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
 		ret = 1;
 	}
@@ -1609,15 +1611,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
-	p->se.avg.runnable_avg_period = 0;
-	p->se.avg.runnable_avg_sum = 0;
-#endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
@@ -1761,6 +1754,8 @@ void wake_up_new_task(struct task_struct *p)
 	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
+	/* Initialize new task's runnable average */
+	init_task_runnable_average(p);
 	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
 	p->on_rq = 1;
@@ -2069,575 +2064,6 @@ unsigned long nr_iowait_cpu(int cpu)
 	return atomic_read(&this->nr_iowait);
 }
 
-unsigned long this_cpu_load(void)
-{
-	struct rq *this = this_rq();
-	return this->cpu_load[0];
-}
-
-
-/*
- * Global load-average calculations
- *
- * We take a distributed and async approach to calculating the global load-avg
- * in order to minimize overhead.
- *
- * The global load average is an exponentially decaying average of nr_running +
- * nr_uninterruptible.
- *
- * Once every LOAD_FREQ:
- *
- *   nr_active = 0;
- *   for_each_possible_cpu(cpu)
- *   	nr_active += cpu_of(cpu)->nr_running + cpu_of(cpu)->nr_uninterruptible;
- *
- *   avenrun[n] = avenrun[0] * exp_n + nr_active * (1 - exp_n)
- *
- * Due to a number of reasons the above turns in the mess below:
- *
- *  - for_each_possible_cpu() is prohibitively expensive on machines with
- *    serious number of cpus, therefore we need to take a distributed approach
- *    to calculating nr_active.
- *
- *        \Sum_i x_i(t) = \Sum_i x_i(t) - x_i(t_0) | x_i(t_0) := 0
- *                      = \Sum_i { \Sum_j=1 x_i(t_j) - x_i(t_j-1) }
- *
- *    So assuming nr_active := 0 when we start out -- true per definition, we
- *    can simply take per-cpu deltas and fold those into a global accumulate
- *    to obtain the same result. See calc_load_fold_active().
- *
- *    Furthermore, in order to avoid synchronizing all per-cpu delta folding
- *    across the machine, we assume 10 ticks is sufficient time for every
- *    cpu to have completed this task.
- *
- *    This places an upper-bound on the IRQ-off latency of the machine. Then
- *    again, being late doesn't loose the delta, just wrecks the sample.
- *
- *  - cpu_rq()->nr_uninterruptible isn't accurately tracked per-cpu because
- *    this would add another cross-cpu cacheline miss and atomic operation
- *    to the wakeup path. Instead we increment on whatever cpu the task ran
- *    when it went into uninterruptible state and decrement on whatever cpu
- *    did the wakeup. This means that only the sum of nr_uninterruptible over
- *    all cpus yields the correct result.
- *
- *  This covers the NO_HZ=n code, for extra head-aches, see the comment below.
- */
-
-/* Variables and functions for calc_load */
-static atomic_long_t calc_load_tasks;
-static unsigned long calc_load_update;
-unsigned long avenrun[3];
-EXPORT_SYMBOL(avenrun); /* should be removed */
-
-/**
- * get_avenrun - get the load average array
- * @loads:	pointer to dest load array
- * @offset:	offset to add
- * @shift:	shift count to shift the result left
- *
- * These values are estimates at best, so no need for locking.
- */
-void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
-{
-	loads[0] = (avenrun[0] + offset) << shift;
-	loads[1] = (avenrun[1] + offset) << shift;
-	loads[2] = (avenrun[2] + offset) << shift;
-}
-
-static long calc_load_fold_active(struct rq *this_rq)
-{
-	long nr_active, delta = 0;
-
-	nr_active = this_rq->nr_running;
-	nr_active += (long) this_rq->nr_uninterruptible;
-
-	if (nr_active != this_rq->calc_load_active) {
-		delta = nr_active - this_rq->calc_load_active;
-		this_rq->calc_load_active = nr_active;
-	}
-
-	return delta;
-}
-
-/*
- * a1 = a0 * e + a * (1 - e)
- */
-static unsigned long
-calc_load(unsigned long load, unsigned long exp, unsigned long active)
-{
-	load *= exp;
-	load += active * (FIXED_1 - exp);
-	load += 1UL << (FSHIFT - 1);
-	return load >> FSHIFT;
-}
-
-#ifdef CONFIG_NO_HZ_COMMON
-/*
- * Handle NO_HZ for the global load-average.
- *
- * Since the above described distributed algorithm to compute the global
- * load-average relies on per-cpu sampling from the tick, it is affected by
- * NO_HZ.
- *
- * The basic idea is to fold the nr_active delta into a global idle-delta upon
- * entering NO_HZ state such that we can include this as an 'extra' cpu delta
- * when we read the global state.
- *
- * Obviously reality has to ruin such a delightfully simple scheme:
- *
- *  - When we go NO_HZ idle during the window, we can negate our sample
- *    contribution, causing under-accounting.
- *
- *    We avoid this by keeping two idle-delta counters and flipping them
- *    when the window starts, thus separating old and new NO_HZ load.
- *
- *    The only trick is the slight shift in index flip for read vs write.
- *
- *        0s            5s            10s           15s
- *          +10           +10           +10           +10
- *        |-|-----------|-|-----------|-|-----------|-|
- *    r:0 0 1           1 0           0 1           1 0
- *    w:0 1 1           0 0           1 1           0 0
- *
- *    This ensures we'll fold the old idle contribution in this window while
- *    accumlating the new one.
- *
- *  - When we wake up from NO_HZ idle during the window, we push up our
- *    contribution, since we effectively move our sample point to a known
- *    busy state.
- *
- *    This is solved by pushing the window forward, and thus skipping the
- *    sample, for this cpu (effectively using the idle-delta for this cpu which
- *    was in effect at the time the window opened). This also solves the issue
- *    of having to deal with a cpu having been in NOHZ idle for multiple
- *    LOAD_FREQ intervals.
- *
- * When making the ILB scale, we should try to pull this in as well.
- */
-static atomic_long_t calc_load_idle[2];
-static int calc_load_idx;
-
-static inline int calc_load_write_idx(void)
-{
-	int idx = calc_load_idx;
-
-	/*
-	 * See calc_global_nohz(), if we observe the new index, we also
-	 * need to observe the new update time.
-	 */
-	smp_rmb();
-
-	/*
-	 * If the folding window started, make sure we start writing in the
-	 * next idle-delta.
-	 */
-	if (!time_before(jiffies, calc_load_update))
-		idx++;
-
-	return idx & 1;
-}
-
-static inline int calc_load_read_idx(void)
-{
-	return calc_load_idx & 1;
-}
-
-void calc_load_enter_idle(void)
-{
-	struct rq *this_rq = this_rq();
-	long delta;
-
-	/*
-	 * We're going into NOHZ mode, if there's any pending delta, fold it
-	 * into the pending idle delta.
-	 */
-	delta = calc_load_fold_active(this_rq);
-	if (delta) {
-		int idx = calc_load_write_idx();
-		atomic_long_add(delta, &calc_load_idle[idx]);
-	}
-}
-
-void calc_load_exit_idle(void)
-{
-	struct rq *this_rq = this_rq();
-
-	/*
-	 * If we're still before the sample window, we're done.
-	 */
-	if (time_before(jiffies, this_rq->calc_load_update))
-		return;
-
-	/*
-	 * We woke inside or after the sample window, this means we're already
-	 * accounted through the nohz accounting, so skip the entire deal and
-	 * sync up for the next window.
-	 */
-	this_rq->calc_load_update = calc_load_update;
-	if (time_before(jiffies, this_rq->calc_load_update + 10))
-		this_rq->calc_load_update += LOAD_FREQ;
-}
-
-static long calc_load_fold_idle(void)
-{
-	int idx = calc_load_read_idx();
-	long delta = 0;
-
-	if (atomic_long_read(&calc_load_idle[idx]))
-		delta = atomic_long_xchg(&calc_load_idle[idx], 0);
-
-	return delta;
-}
-
-/**
- * fixed_power_int - compute: x^n, in O(log n) time
- *
- * @x:         base of the power
- * @frac_bits: fractional bits of @x
- * @n:         power to raise @x to.
- *
- * By exploiting the relation between the definition of the natural power
- * function: x^n := x*x*...*x (x multiplied by itself for n times), and
- * the binary encoding of numbers used by computers: n := \Sum n_i * 2^i,
- * (where: n_i \elem {0, 1}, the binary vector representing n),
- * we find: x^n := x^(\Sum n_i * 2^i) := \Prod x^(n_i * 2^i), which is
- * of course trivially computable in O(log_2 n), the length of our binary
- * vector.
- */
-static unsigned long
-fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
-{
-	unsigned long result = 1UL << frac_bits;
-
-	if (n) for (;;) {
-		if (n & 1) {
-			result *= x;
-			result += 1UL << (frac_bits - 1);
-			result >>= frac_bits;
-		}
-		n >>= 1;
-		if (!n)
-			break;
-		x *= x;
-		x += 1UL << (frac_bits - 1);
-		x >>= frac_bits;
-	}
-
-	return result;
-}
-
-/*
- * a1 = a0 * e + a * (1 - e)
- *
- * a2 = a1 * e + a * (1 - e)
- *    = (a0 * e + a * (1 - e)) * e + a * (1 - e)
- *    = a0 * e^2 + a * (1 - e) * (1 + e)
- *
- * a3 = a2 * e + a * (1 - e)
- *    = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
- *    = a0 * e^3 + a * (1 - e) * (1 + e + e^2)
- *
- *  ...
- *
- * an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1) [1]
- *    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
- *    = a0 * e^n + a * (1 - e^n)
- *
- * [1] application of the geometric series:
- *
- *              n         1 - x^(n+1)
- *     S_n := \Sum x^i = -------------
- *             i=0          1 - x
- */
-static unsigned long
-calc_load_n(unsigned long load, unsigned long exp,
-	    unsigned long active, unsigned int n)
-{
-
-	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
-}
-
-/*
- * NO_HZ can leave us missing all per-cpu ticks calling
- * calc_load_account_active(), but since an idle CPU folds its delta into
- * calc_load_tasks_idle per calc_load_account_idle(), all we need to do is fold
- * in the pending idle delta if our idle period crossed a load cycle boundary.
- *
- * Once we've updated the global active value, we need to apply the exponential
- * weights adjusted to the number of cycles missed.
- */
-static void calc_global_nohz(void)
-{
-	long delta, active, n;
-
-	if (!time_before(jiffies, calc_load_update + 10)) {
-		/*
-		 * Catch-up, fold however many we are behind still
-		 */
-		delta = jiffies - calc_load_update - 10;
-		n = 1 + (delta / LOAD_FREQ);
-
-		active = atomic_long_read(&calc_load_tasks);
-		active = active > 0 ? active * FIXED_1 : 0;
-
-		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
-		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
-		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
-
-		calc_load_update += n * LOAD_FREQ;
-	}
-
-	/*
-	 * Flip the idle index...
-	 *
-	 * Make sure we first write the new time then flip the index, so that
-	 * calc_load_write_idx() will see the new time when it reads the new
-	 * index, this avoids a double flip messing things up.
-	 */
-	smp_wmb();
-	calc_load_idx++;
-}
-#else /* !CONFIG_NO_HZ_COMMON */
-
-static inline long calc_load_fold_idle(void) { return 0; }
-static inline void calc_global_nohz(void) { }
-
-#endif /* CONFIG_NO_HZ_COMMON */
-
-/*
- * calc_load - update the avenrun load estimates 10 ticks after the
- * CPUs have updated calc_load_tasks.
- */
-void calc_global_load(unsigned long ticks)
-{
-	long active, delta;
-
-	if (time_before(jiffies, calc_load_update + 10))
-		return;
-
-	/*
-	 * Fold the 'old' idle-delta to include all NO_HZ cpus.
-	 */
-	delta = calc_load_fold_idle();
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks);
-
-	active = atomic_long_read(&calc_load_tasks);
-	active = active > 0 ? active * FIXED_1 : 0;
-
-	avenrun[0] = calc_load(avenrun[0], EXP_1, active);
-	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
-	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
-
-	calc_load_update += LOAD_FREQ;
-
-	/*
-	 * In case we idled for multiple LOAD_FREQ intervals, catch up in bulk.
-	 */
-	calc_global_nohz();
-}
-
-/*
- * Called from update_cpu_load() to periodically update this CPU's
- * active count.
- */
-static void calc_load_account_active(struct rq *this_rq)
-{
-	long delta;
-
-	if (time_before(jiffies, this_rq->calc_load_update))
-		return;
-
-	delta  = calc_load_fold_active(this_rq);
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks);
-
-	this_rq->calc_load_update += LOAD_FREQ;
-}
-
-/*
- * End of global load-average stuff
- */
-
-/*
- * The exact cpuload at various idx values, calculated at every tick would be
- * load = (2^idx - 1) / 2^idx * load + 1 / 2^idx * cur_load
- *
- * If a cpu misses updates for n-1 ticks (as it was idle) and update gets called
- * on nth tick when cpu may be busy, then we have:
- * load = ((2^idx - 1) / 2^idx)^(n-1) * load
- * load = (2^idx - 1) / 2^idx) * load + 1 / 2^idx * cur_load
- *
- * decay_load_missed() below does efficient calculation of
- * load = ((2^idx - 1) / 2^idx)^(n-1) * load
- * avoiding 0..n-1 loop doing load = ((2^idx - 1) / 2^idx) * load
- *
- * The calculation is approximated on a 128 point scale.
- * degrade_zero_ticks is the number of ticks after which load at any
- * particular idx is approximated to be zero.
- * degrade_factor is a precomputed table, a row for each load idx.
- * Each column corresponds to degradation factor for a power of two ticks,
- * based on 128 point scale.
- * Example:
- * row 2, col 3 (=12) says that the degradation at load idx 2 after
- * 8 ticks is 12/128 (which is an approximation of exact factor 3^8/4^8).
- *
- * With this power of 2 load factors, we can degrade the load n times
- * by looking at 1 bits in n and doing as many mult/shift instead of
- * n mult/shifts needed by the exact degradation.
- */
-#define DEGRADE_SHIFT		7
-static const unsigned char
-		degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
-static const unsigned char
-		degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
-					{0, 0, 0, 0, 0, 0, 0, 0},
-					{64, 32, 8, 0, 0, 0, 0, 0},
-					{96, 72, 40, 12, 1, 0, 0},
-					{112, 98, 75, 43, 15, 1, 0},
-					{120, 112, 98, 76, 45, 16, 2} };
-
-/*
- * Update cpu_load for any missed ticks, due to tickless idle. The backlog
- * would be when CPU is idle and so we just decay the old load without
- * adding any new load.
- */
-static unsigned long
-decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
-{
-	int j = 0;
-
-	if (!missed_updates)
-		return load;
-
-	if (missed_updates >= degrade_zero_ticks[idx])
-		return 0;
-
-	if (idx == 1)
-		return load >> missed_updates;
-
-	while (missed_updates) {
-		if (missed_updates % 2)
-			load = (load * degrade_factor[idx][j]) >> DEGRADE_SHIFT;
-
-		missed_updates >>= 1;
-		j++;
-	}
-	return load;
-}
-
-/*
- * Update rq->cpu_load[] statistics. This function is usually called every
- * scheduler tick (TICK_NSEC). With tickless idle this will not be called
- * every tick. We fix it up based on jiffies.
- */
-static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
-			      unsigned long pending_updates)
-{
-	int i, scale;
-
-	this_rq->nr_load_updates++;
-
-	/* Update our load: */
-	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
-	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
-		unsigned long old_load, new_load;
-
-		/* scale is effectively 1 << i now, and >> i divides by scale */
-
-		old_load = this_rq->cpu_load[i];
-		old_load = decay_load_missed(old_load, pending_updates - 1, i);
-		new_load = this_load;
-		/*
-		 * Round up the averaging division if load is increasing. This
-		 * prevents us from getting stuck on 9 if the load is 10, for
-		 * example.
-		 */
-		if (new_load > old_load)
-			new_load += scale - 1;
-
-		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
-	}
-
-	sched_avg_update(this_rq);
-}
-
-#ifdef CONFIG_NO_HZ_COMMON
-/*
- * There is no sane way to deal with nohz on smp when using jiffies because the
- * cpu doing the jiffies update might drift wrt the cpu doing the jiffy reading
- * causing off-by-one errors in observed deltas; {0,2} instead of {1,1}.
- *
- * Therefore we cannot use the delta approach from the regular tick since that
- * would seriously skew the load calculation. However we'll make do for those
- * updates happening while idle (nohz_idle_balance) or coming out of idle
- * (tick_nohz_idle_exit).
- *
- * This means we might still be one tick off for nohz periods.
- */
-
-/*
- * Called from nohz_idle_balance() to update the load ratings before doing the
- * idle balance.
- */
-void update_idle_cpu_load(struct rq *this_rq)
-{
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
-	unsigned long pending_updates;
-
-	/*
-	 * bail if there's load or we're actually up-to-date.
-	 */
-	if (load || curr_jiffies == this_rq->last_load_update_tick)
-		return;
-
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	this_rq->last_load_update_tick = curr_jiffies;
-
-	__update_cpu_load(this_rq, load, pending_updates);
-}
-
-/*
- * Called from tick_nohz_idle_exit() -- try and fix up the ticks we missed.
- */
-void update_cpu_load_nohz(void)
-{
-	struct rq *this_rq = this_rq();
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long pending_updates;
-
-	if (curr_jiffies == this_rq->last_load_update_tick)
-		return;
-
-	raw_spin_lock(&this_rq->lock);
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	if (pending_updates) {
-		this_rq->last_load_update_tick = curr_jiffies;
-		/*
-		 * We were idle, this means load 0, the current load might be
-		 * !0 due to remote wakeups and the sort.
-		 */
-		__update_cpu_load(this_rq, 0, pending_updates);
-	}
-	raw_spin_unlock(&this_rq->lock);
-}
-#endif /* CONFIG_NO_HZ_COMMON */
-
-/*
- * Called from scheduler_tick()
- */
-static void update_cpu_load_active(struct rq *this_rq)
-{
-	/*
-	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
-	 */
-	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
-
-	calc_load_account_active(this_rq);
-}
-
 #ifdef CONFIG_SMP
 
 /*
@@ -2686,7 +2112,7 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 
 	if (task_current(rq, p)) {
 		update_rq_clock(rq);
-		ns = rq->clock_task - p->se.exec_start;
+		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
 			ns = 0;
 	}
@@ -2739,8 +2165,8 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	update_cpu_load_active(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
@@ -4960,6 +4386,13 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
+	/*
+	 * put_prev_task() and pick_next_task() sched
+	 * class method both need to have an up-to-date
+	 * value of rq->clock[_task]
+	 */
+	update_rq_clock(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
@@ -5093,7 +4526,7 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 	return table;
 }
 
-static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
+static struct ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 {
 	struct ctl_table *entry, *table;
 	struct sched_domain *sd;
@@ -5907,7 +5340,7 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 	get_group(cpu, sdd, &sd->groups);
 	atomic_inc(&sd->groups->ref);
 
-	if (cpu != cpumask_first(sched_domain_span(sd)))
+	if (cpu != cpumask_first(span))
 		return 0;
 
 	lockdep_assert_held(&sched_domains_mutex);
@@ -5917,12 +5350,12 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 
 	for_each_cpu(i, span) {
 		struct sched_group *sg;
-		int group = get_group(i, sdd, &sg);
-		int j;
+		int group, j;
 
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
+		group = get_group(i, sdd, &sg);
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
 		cpumask_setall(sched_group_mask(sg));
@@ -5960,7 +5393,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
 	struct sched_group *sg = sd->groups;
 
-	WARN_ON(!sd || !sg);
+	WARN_ON(!sg);
 
 	do {
 		sg->group_weight = cpumask_weight(sched_group_cpus(sg));
@@ -6125,6 +5558,9 @@ static struct sched_domain_topology_level default_topology[] = {
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#define for_each_sd_topology(tl)			\
+	for (tl = sched_domain_topology; tl->init; tl++)
+
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
@@ -6422,7 +5858,7 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 	struct sched_domain_topology_level *tl;
 	int j;
 
-	for (tl = sched_domain_topology; tl->init; tl++) {
+	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
 		sdd->sd = alloc_percpu(struct sched_domain *);
@@ -6475,7 +5911,7 @@ static void __sdt_free(const struct cpumask *cpu_map)
 	struct sched_domain_topology_level *tl;
 	int j;
 
-	for (tl = sched_domain_topology; tl->init; tl++) {
+	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
@@ -6503,9 +5939,8 @@ static void __sdt_free(const struct cpumask *cpu_map)
 }
 
 struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
-		struct s_data *d, const struct cpumask *cpu_map,
-		struct sched_domain_attr *attr, struct sched_domain *child,
-		int cpu)
+		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+		struct sched_domain *child, int cpu)
 {
 	struct sched_domain *sd = tl->init(tl, cpu);
 	if (!sd)
@@ -6516,8 +5951,8 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		sd->level = child->level + 1;
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
+		sd->child = child;
 	}
-	sd->child = child;
 	set_domain_attribute(sd, attr);
 
 	return sd;
@@ -6530,7 +5965,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 static int build_sched_domains(const struct cpumask *cpu_map,
 			       struct sched_domain_attr *attr)
 {
-	enum s_alloc alloc_state = sa_none;
+	enum s_alloc alloc_state;
 	struct sched_domain *sd;
 	struct s_data d;
 	int i, ret = -ENOMEM;
@@ -6544,18 +5979,15 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->init; tl++) {
-			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+		for_each_sd_topology(tl) {
+			sd = build_sched_domain(tl, cpu_map, attr, sd, i);
+			if (tl == sched_domain_topology)
+				*per_cpu_ptr(d.sd, i) = sd;
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
 			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
 				break;
 		}
-
-		while (sd->child)
-			sd = sd->child;
-
-		*per_cpu_ptr(d.sd, i) = sd;
 	}
 
 	/* Build the groups for the domains */
@@ -6867,9 +6299,6 @@ void __init sched_init_smp(void)
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 
-	/* RT runtime code needs to handle some hotplug events */
-	hotcpu_notifier(update_runtime, 0);
-
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index b5ccba2..a7959e0 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -515,9 +515,8 @@ static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
 
 	for (;;) {
 		/* Make sure "rtime" is the bigger of stime/rtime */
-		if (stime > rtime) {
-			u64 tmp = rtime; rtime = stime; stime = tmp;
-		}
+		if (stime > rtime)
+			swap(rtime, stime);
 
 		/* Make sure 'total' fits in 32 bits */
 		if (total >> 32)
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 75024a6..e076bdd 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -209,22 +209,24 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->nr_spread_over);
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
-#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
+	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
-	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
+	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
-			(unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
-	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
 			cfs_rq->tg_runnable_contrib);
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+			atomic_long_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
 			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
+#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
@@ -493,15 +495,16 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
 						get_nr_threads(p));
 	SEQ_printf(m,
-		"---------------------------------------------------------\n");
+		"---------------------------------------------------------"
+		"----------\n");
 #define __P(F) \
-	SEQ_printf(m, "%-35s:%21Ld\n", #F, (long long)F)
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)F)
 #define P(F) \
-	SEQ_printf(m, "%-35s:%21Ld\n", #F, (long long)p->F)
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)p->F)
 #define __PN(F) \
-	SEQ_printf(m, "%-35s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)F))
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)F))
 #define PN(F) \
-	SEQ_printf(m, "%-35s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
 
 	PN(se.exec_start);
 	PN(se.vruntime);
@@ -560,12 +563,18 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	}
 #endif
 	__P(nr_switches);
-	SEQ_printf(m, "%-35s:%21Ld\n",
+	SEQ_printf(m, "%-45s:%21Ld\n",
 		   "nr_voluntary_switches", (long long)p->nvcsw);
-	SEQ_printf(m, "%-35s:%21Ld\n",
+	SEQ_printf(m, "%-45s:%21Ld\n",
 		   "nr_involuntary_switches", (long long)p->nivcsw);
 
 	P(se.load.weight);
+#ifdef CONFIG_SMP
+	P(se.avg.runnable_avg_sum);
+	P(se.avg.runnable_avg_period);
+	P(se.avg.load_avg_contrib);
+	P(se.avg.decay_count);
+#endif
 	P(policy);
 	P(prio);
 #undef PN
@@ -579,7 +588,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 
 		t0 = cpu_clock(this_cpu);
 		t1 = cpu_clock(this_cpu);
-		SEQ_printf(m, "%-35s:%21Ld\n",
+		SEQ_printf(m, "%-45s:%21Ld\n",
 			   "clock-delta", (long long)(t1-t0));
 	}
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..f77f9c5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -113,6 +113,24 @@ unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
 #endif
 
+static inline void update_load_add(struct load_weight *lw, unsigned long inc)
+{
+	lw->weight += inc;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
+{
+	lw->weight -= dec;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_set(struct load_weight *lw, unsigned long w)
+{
+	lw->weight = w;
+	lw->inv_weight = 0;
+}
+
 /*
  * Increase the granularity value when there are more CPUs,
  * because with more CPUs the 'effective latency' as visible
@@ -662,6 +680,26 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+#ifdef CONFIG_SMP
+static inline void __update_task_entity_contrib(struct sched_entity *se);
+
+/* Give new task start runnable values to heavy its load in infant time */
+void init_task_runnable_average(struct task_struct *p)
+{
+	u32 slice;
+
+	p->se.avg.decay_count = 0;
+	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
+	p->se.avg.runnable_avg_sum = slice;
+	p->se.avg.runnable_avg_period = slice;
+	__update_task_entity_contrib(&p->se);
+}
+#else
+void init_task_runnable_average(struct task_struct *p)
+{
+}
+#endif
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -686,7 +724,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock_task;
+	u64 now = rq_clock_task(rq_of(cfs_rq));
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -718,7 +756,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	schedstat_set(se->statistics.wait_start, rq_of(cfs_rq)->clock);
+	schedstat_set(se->statistics.wait_start, rq_clock(rq_of(cfs_rq)));
 }
 
 /*
@@ -738,14 +776,14 @@ static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	schedstat_set(se->statistics.wait_max, max(se->statistics.wait_max,
-			rq_of(cfs_rq)->clock - se->statistics.wait_start));
+			rq_clock(rq_of(cfs_rq)) - se->statistics.wait_start));
 	schedstat_set(se->statistics.wait_count, se->statistics.wait_count + 1);
 	schedstat_set(se->statistics.wait_sum, se->statistics.wait_sum +
-			rq_of(cfs_rq)->clock - se->statistics.wait_start);
+			rq_clock(rq_of(cfs_rq)) - se->statistics.wait_start);
 #ifdef CONFIG_SCHEDSTATS
 	if (entity_is_task(se)) {
 		trace_sched_stat_wait(task_of(se),
-			rq_of(cfs_rq)->clock - se->statistics.wait_start);
+			rq_clock(rq_of(cfs_rq)) - se->statistics.wait_start);
 	}
 #endif
 	schedstat_set(se->statistics.wait_start, 0);
@@ -771,7 +809,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	/*
 	 * We are starting a new run period:
 	 */
-	se->exec_start = rq_of(cfs_rq)->clock_task;
+	se->exec_start = rq_clock_task(rq_of(cfs_rq));
 }
 
 /**************************************************
@@ -1037,7 +1075,7 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	 * to gain a more accurate current total weight. See
 	 * update_cfs_rq_load_contribution().
 	 */
-	tg_weight = atomic64_read(&tg->load_avg);
+	tg_weight = atomic_long_read(&tg->load_avg);
 	tg_weight -= cfs_rq->tg_load_contrib;
 	tg_weight += cfs_rq->load.weight;
 
@@ -1110,8 +1148,7 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -1319,13 +1356,13 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update)
 {
 	struct task_group *tg = cfs_rq->tg;
-	s64 tg_contrib;
+	long tg_contrib;
 
 	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
-	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
-		atomic64_add(tg_contrib, &tg->load_avg);
+	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
+		atomic_long_add(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
 	}
 }
@@ -1360,8 +1397,8 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	u64 contrib;
 
 	contrib = cfs_rq->tg_load_contrib * tg->shares;
-	se->avg.load_avg_contrib = div64_u64(contrib,
-					     atomic64_read(&tg->load_avg) + 1);
+	se->avg.load_avg_contrib = div_u64(contrib,
+				     atomic_long_read(&tg->load_avg) + 1);
 
 	/*
 	 * For group entities we need to compute a correction term in the case
@@ -1480,8 +1517,9 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	if (!decays && !force_update)
 		return;
 
-	if (atomic64_read(&cfs_rq->removed_load)) {
-		u64 removed_load = atomic64_xchg(&cfs_rq->removed_load, 0);
+	if (atomic_long_read(&cfs_rq->removed_load)) {
+		unsigned long removed_load;
+		removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
 		subtract_blocked_load_contrib(cfs_rq, removed_load);
 	}
 
@@ -1497,7 +1535,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
-	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
+	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 
@@ -1510,9 +1548,13 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
 	 * accumulated while sleeping.
+	 *
+	 * Newly forked tasks are enqueued with se->avg.decay_count == 0, they
+	 * are seen by enqueue_entity_load_avg() as a migration with an already
+	 * constructed load_avg_contrib.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
-		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
+		se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
 		if (se->avg.decay_count) {
 			/*
 			 * In a wake-up migration we have to approximate the
@@ -1530,7 +1572,13 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		}
 		wakeup = 0;
 	} else {
-		__synchronize_entity_decay(se);
+		/*
+		 * Task re-woke on same cpu (or else migrate_task_rq_fair()
+		 * would have made count negative); we must be careful to avoid
+		 * double-accounting blocked time after synchronizing decays.
+		 */
+		se->avg.last_runnable_update += __synchronize_entity_decay(se)
+							<< 20;
 	}
 
 	/* migrated tasks did not contribute to our blocked load */
@@ -1607,7 +1655,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		tsk = task_of(se);
 
 	if (se->statistics.sleep_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->statistics.sleep_start;
+		u64 delta = rq_clock(rq_of(cfs_rq)) - se->statistics.sleep_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -1624,7 +1672,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		}
 	}
 	if (se->statistics.block_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->statistics.block_start;
+		u64 delta = rq_clock(rq_of(cfs_rq)) - se->statistics.block_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -1712,7 +1760,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
 	 * Update the normalized vruntime before updating min_vruntime
-	 * through callig update_curr().
+	 * through calling update_curr().
 	 */
 	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
 		se->vruntime += cfs_rq->min_vruntime;
@@ -1805,9 +1853,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 			struct task_struct *tsk = task_of(se);
 
 			if (tsk->state & TASK_INTERRUPTIBLE)
-				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
+				se->statistics.sleep_start = rq_clock(rq_of(cfs_rq));
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				se->statistics.block_start = rq_of(cfs_rq)->clock;
+				se->statistics.block_start = rq_clock(rq_of(cfs_rq));
 		}
 #endif
 	}
@@ -2082,7 +2130,7 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 	if (unlikely(cfs_rq->throttle_count))
 		return cfs_rq->throttled_clock_task;
 
-	return rq_of(cfs_rq)->clock_task - cfs_rq->throttled_clock_task_time;
+	return rq_clock_task(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
 }
 
 /* returns 0 on failure to allocate runtime */
@@ -2138,10 +2186,9 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-	struct rq *rq = rq_of(cfs_rq);
 
 	/* if the deadline is ahead of our clock, nothing to do */
-	if (likely((s64)(rq->clock - cfs_rq->runtime_expires) < 0))
+	if (likely((s64)(rq_clock(rq_of(cfs_rq)) - cfs_rq->runtime_expires) < 0))
 		return;
 
 	if (cfs_rq->runtime_remaining < 0)
@@ -2230,7 +2277,7 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 #ifdef CONFIG_SMP
 	if (!cfs_rq->throttle_count) {
 		/* adjust cfs_rq_clock_task() */
-		cfs_rq->throttled_clock_task_time += rq->clock_task -
+		cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
 					     cfs_rq->throttled_clock_task;
 	}
 #endif
@@ -2245,7 +2292,7 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 
 	/* group is entering throttled state, stop time */
 	if (!cfs_rq->throttle_count)
-		cfs_rq->throttled_clock_task = rq->clock_task;
+		cfs_rq->throttled_clock_task = rq_clock_task(rq);
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -2284,7 +2331,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_clock = rq->clock;
+	cfs_rq->throttled_clock = rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -2298,15 +2345,17 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	int enqueue = 1;
 	long task_delta;
 
-	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+	se = cfs_rq->tg->se[cpu_of(rq)];
 
 	cfs_rq->throttled = 0;
+
+	update_rq_clock(rq);
+
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
+	cfs_b->throttled_time += rq_clock(rq) - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
-	update_rq_clock(rq);
 	/* update hierarchical throttle state */
 	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
 
@@ -2599,10 +2648,6 @@ static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	throttle_cfs_rq(cfs_rq);
 }
 
-static inline u64 default_cfs_period(void);
-static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
-static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
-
 static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
 {
 	struct cfs_bandwidth *cfs_b =
@@ -2706,7 +2751,7 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 #else /* CONFIG_CFS_BANDWIDTH */
 static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 {
-	return rq_of(cfs_rq)->clock_task;
+	return rq_clock_task(rq_of(cfs_rq));
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
@@ -2919,7 +2964,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2964,9 +3009,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return load_avg / nr_running;
 
 	return 0;
 }
@@ -3416,12 +3462,6 @@ unlock:
 }
 
 /*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
-/*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
@@ -3441,10 +3481,10 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 	 */
 	if (se->avg.decay_count) {
 		se->avg.decay_count = -__synchronize_entity_decay(se);
-		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
+		atomic_long_add(se->avg.load_avg_contrib,
+						&cfs_rq->removed_load);
 	}
 }
-#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -3946,7 +3986,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
+	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 
@@ -4141,11 +4181,11 @@ static int tg_load_down(struct task_group *tg, void *data)
 	long cpu = (long)data;
 
 	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
+		load = cpu_rq(cpu)->avg.load_avg_contrib;
 	} else {
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+		load = div64_ul(load * tg->se[cpu]->avg.load_avg_contrib,
+				tg->parent->cfs_rq[cpu]->runnable_load_avg + 1);
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
@@ -4171,12 +4211,9 @@ static void update_h_load(long cpu)
 static unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	unsigned long load;
-
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
 
-	return load;
+	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
+			cfs_rq->runnable_load_avg + 1);
 }
 #else
 static inline void update_blocked_averages(int cpu)
@@ -4189,7 +4226,7 @@ static inline void update_h_load(long cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.load.weight;
+	return p->se.avg.load_avg_contrib;
 }
 #endif
 
@@ -4302,7 +4339,7 @@ static unsigned long scale_rt_power(int cpu)
 	age_stamp = ACCESS_ONCE(rq->age_stamp);
 	avg = ACCESS_ONCE(rq->rt_avg);
 
-	total = sched_avg_period() + (rq->clock - age_stamp);
+	total = sched_avg_period() + (rq_clock(rq) - age_stamp);
 
 	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
@@ -5241,7 +5278,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
-	this_rq->idle_stamp = this_rq->clock;
+	this_rq->idle_stamp = rq_clock(this_rq);
 
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
@@ -5418,10 +5455,9 @@ static inline void nohz_balance_exit_idle(int cpu)
 static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
-	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
 
 	if (!sd || !sd->nohz_idle)
 		goto unlock;
@@ -5436,10 +5472,9 @@ unlock:
 void set_cpu_sd_state_idle(void)
 {
 	struct sched_domain *sd;
-	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
 
 	if (!sd || sd->nohz_idle)
 		goto unlock;
@@ -5848,7 +5883,7 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 		se->vruntime -= cfs_rq->min_vruntime;
 	}
 
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	/*
 	* Remove our load from contribution when we leave sched_fair
 	* and ensure we don't carry in an old decay_count if we
@@ -5907,9 +5942,9 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
-	atomic64_set(&cfs_rq->removed_load, 0);
+	atomic_long_set(&cfs_rq->removed_load, 0);
 #endif
 }
 
@@ -6091,6 +6126,9 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		se = tg->se[i];
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
+
+		/* Possible calls to update_curr() need rq clock */
+		update_rq_clock(rq);
 		for_each_sched_entity(se)
 			update_cfs_shares(group_cfs_rq(se));
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
@@ -6146,9 +6184,8 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-#endif
+
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
new file mode 100644
index 0000000..16f5a30
--- /dev/null
+++ b/kernel/sched/proc.c
@@ -0,0 +1,591 @@
+/*
+ *  kernel/sched/proc.c
+ *
+ *  Kernel load calculations, forked from sched/core.c
+ */
+
+#include <linux/export.h>
+
+#include "sched.h"
+
+unsigned long this_cpu_load(void)
+{
+	struct rq *this = this_rq();
+	return this->cpu_load[0];
+}
+
+
+/*
+ * Global load-average calculations
+ *
+ * We take a distributed and async approach to calculating the global load-avg
+ * in order to minimize overhead.
+ *
+ * The global load average is an exponentially decaying average of nr_running +
+ * nr_uninterruptible.
+ *
+ * Once every LOAD_FREQ:
+ *
+ *   nr_active = 0;
+ *   for_each_possible_cpu(cpu)
+ *	nr_active += cpu_of(cpu)->nr_running + cpu_of(cpu)->nr_uninterruptible;
+ *
+ *   avenrun[n] = avenrun[0] * exp_n + nr_active * (1 - exp_n)
+ *
+ * Due to a number of reasons the above turns in the mess below:
+ *
+ *  - for_each_possible_cpu() is prohibitively expensive on machines with
+ *    serious number of cpus, therefore we need to take a distributed approach
+ *    to calculating nr_active.
+ *
+ *        \Sum_i x_i(t) = \Sum_i x_i(t) - x_i(t_0) | x_i(t_0) := 0
+ *                      = \Sum_i { \Sum_j=1 x_i(t_j) - x_i(t_j-1) }
+ *
+ *    So assuming nr_active := 0 when we start out -- true per definition, we
+ *    can simply take per-cpu deltas and fold those into a global accumulate
+ *    to obtain the same result. See calc_load_fold_active().
+ *
+ *    Furthermore, in order to avoid synchronizing all per-cpu delta folding
+ *    across the machine, we assume 10 ticks is sufficient time for every
+ *    cpu to have completed this task.
+ *
+ *    This places an upper-bound on the IRQ-off latency of the machine. Then
+ *    again, being late doesn't loose the delta, just wrecks the sample.
+ *
+ *  - cpu_rq()->nr_uninterruptible isn't accurately tracked per-cpu because
+ *    this would add another cross-cpu cacheline miss and atomic operation
+ *    to the wakeup path. Instead we increment on whatever cpu the task ran
+ *    when it went into uninterruptible state and decrement on whatever cpu
+ *    did the wakeup. This means that only the sum of nr_uninterruptible over
+ *    all cpus yields the correct result.
+ *
+ *  This covers the NO_HZ=n code, for extra head-aches, see the comment below.
+ */
+
+/* Variables and functions for calc_load */
+atomic_long_t calc_load_tasks;
+unsigned long calc_load_update;
+unsigned long avenrun[3];
+EXPORT_SYMBOL(avenrun); /* should be removed */
+
+/**
+ * get_avenrun - get the load average array
+ * @loads:	pointer to dest load array
+ * @offset:	offset to add
+ * @shift:	shift count to shift the result left
+ *
+ * These values are estimates at best, so no need for locking.
+ */
+void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
+{
+	loads[0] = (avenrun[0] + offset) << shift;
+	loads[1] = (avenrun[1] + offset) << shift;
+	loads[2] = (avenrun[2] + offset) << shift;
+}
+
+long calc_load_fold_active(struct rq *this_rq)
+{
+	long nr_active, delta = 0;
+
+	nr_active = this_rq->nr_running;
+	nr_active += (long) this_rq->nr_uninterruptible;
+
+	if (nr_active != this_rq->calc_load_active) {
+		delta = nr_active - this_rq->calc_load_active;
+		this_rq->calc_load_active = nr_active;
+	}
+
+	return delta;
+}
+
+/*
+ * a1 = a0 * e + a * (1 - e)
+ */
+static unsigned long
+calc_load(unsigned long load, unsigned long exp, unsigned long active)
+{
+	load *= exp;
+	load += active * (FIXED_1 - exp);
+	load += 1UL << (FSHIFT - 1);
+	return load >> FSHIFT;
+}
+
+#ifdef CONFIG_NO_HZ_COMMON
+/*
+ * Handle NO_HZ for the global load-average.
+ *
+ * Since the above described distributed algorithm to compute the global
+ * load-average relies on per-cpu sampling from the tick, it is affected by
+ * NO_HZ.
+ *
+ * The basic idea is to fold the nr_active delta into a global idle-delta upon
+ * entering NO_HZ state such that we can include this as an 'extra' cpu delta
+ * when we read the global state.
+ *
+ * Obviously reality has to ruin such a delightfully simple scheme:
+ *
+ *  - When we go NO_HZ idle during the window, we can negate our sample
+ *    contribution, causing under-accounting.
+ *
+ *    We avoid this by keeping two idle-delta counters and flipping them
+ *    when the window starts, thus separating old and new NO_HZ load.
+ *
+ *    The only trick is the slight shift in index flip for read vs write.
+ *
+ *        0s            5s            10s           15s
+ *          +10           +10           +10           +10
+ *        |-|-----------|-|-----------|-|-----------|-|
+ *    r:0 0 1           1 0           0 1           1 0
+ *    w:0 1 1           0 0           1 1           0 0
+ *
+ *    This ensures we'll fold the old idle contribution in this window while
+ *    accumlating the new one.
+ *
+ *  - When we wake up from NO_HZ idle during the window, we push up our
+ *    contribution, since we effectively move our sample point to a known
+ *    busy state.
+ *
+ *    This is solved by pushing the window forward, and thus skipping the
+ *    sample, for this cpu (effectively using the idle-delta for this cpu which
+ *    was in effect at the time the window opened). This also solves the issue
+ *    of having to deal with a cpu having been in NOHZ idle for multiple
+ *    LOAD_FREQ intervals.
+ *
+ * When making the ILB scale, we should try to pull this in as well.
+ */
+static atomic_long_t calc_load_idle[2];
+static int calc_load_idx;
+
+static inline int calc_load_write_idx(void)
+{
+	int idx = calc_load_idx;
+
+	/*
+	 * See calc_global_nohz(), if we observe the new index, we also
+	 * need to observe the new update time.
+	 */
+	smp_rmb();
+
+	/*
+	 * If the folding window started, make sure we start writing in the
+	 * next idle-delta.
+	 */
+	if (!time_before(jiffies, calc_load_update))
+		idx++;
+
+	return idx & 1;
+}
+
+static inline int calc_load_read_idx(void)
+{
+	return calc_load_idx & 1;
+}
+
+void calc_load_enter_idle(void)
+{
+	struct rq *this_rq = this_rq();
+	long delta;
+
+	/*
+	 * We're going into NOHZ mode, if there's any pending delta, fold it
+	 * into the pending idle delta.
+	 */
+	delta = calc_load_fold_active(this_rq);
+	if (delta) {
+		int idx = calc_load_write_idx();
+		atomic_long_add(delta, &calc_load_idle[idx]);
+	}
+}
+
+void calc_load_exit_idle(void)
+{
+	struct rq *this_rq = this_rq();
+
+	/*
+	 * If we're still before the sample window, we're done.
+	 */
+	if (time_before(jiffies, this_rq->calc_load_update))
+		return;
+
+	/*
+	 * We woke inside or after the sample window, this means we're already
+	 * accounted through the nohz accounting, so skip the entire deal and
+	 * sync up for the next window.
+	 */
+	this_rq->calc_load_update = calc_load_update;
+	if (time_before(jiffies, this_rq->calc_load_update + 10))
+		this_rq->calc_load_update += LOAD_FREQ;
+}
+
+static long calc_load_fold_idle(void)
+{
+	int idx = calc_load_read_idx();
+	long delta = 0;
+
+	if (atomic_long_read(&calc_load_idle[idx]))
+		delta = atomic_long_xchg(&calc_load_idle[idx], 0);
+
+	return delta;
+}
+
+/**
+ * fixed_power_int - compute: x^n, in O(log n) time
+ *
+ * @x:         base of the power
+ * @frac_bits: fractional bits of @x
+ * @n:         power to raise @x to.
+ *
+ * By exploiting the relation between the definition of the natural power
+ * function: x^n := x*x*...*x (x multiplied by itself for n times), and
+ * the binary encoding of numbers used by computers: n := \Sum n_i * 2^i,
+ * (where: n_i \elem {0, 1}, the binary vector representing n),
+ * we find: x^n := x^(\Sum n_i * 2^i) := \Prod x^(n_i * 2^i), which is
+ * of course trivially computable in O(log_2 n), the length of our binary
+ * vector.
+ */
+static unsigned long
+fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
+{
+	unsigned long result = 1UL << frac_bits;
+
+	if (n) for (;;) {
+		if (n & 1) {
+			result *= x;
+			result += 1UL << (frac_bits - 1);
+			result >>= frac_bits;
+		}
+		n >>= 1;
+		if (!n)
+			break;
+		x *= x;
+		x += 1UL << (frac_bits - 1);
+		x >>= frac_bits;
+	}
+
+	return result;
+}
+
+/*
+ * a1 = a0 * e + a * (1 - e)
+ *
+ * a2 = a1 * e + a * (1 - e)
+ *    = (a0 * e + a * (1 - e)) * e + a * (1 - e)
+ *    = a0 * e^2 + a * (1 - e) * (1 + e)
+ *
+ * a3 = a2 * e + a * (1 - e)
+ *    = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
+ *    = a0 * e^3 + a * (1 - e) * (1 + e + e^2)
+ *
+ *  ...
+ *
+ * an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1) [1]
+ *    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
+ *    = a0 * e^n + a * (1 - e^n)
+ *
+ * [1] application of the geometric series:
+ *
+ *              n         1 - x^(n+1)
+ *     S_n := \Sum x^i = -------------
+ *             i=0          1 - x
+ */
+static unsigned long
+calc_load_n(unsigned long load, unsigned long exp,
+	    unsigned long active, unsigned int n)
+{
+
+	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
+}
+
+/*
+ * NO_HZ can leave us missing all per-cpu ticks calling
+ * calc_load_account_active(), but since an idle CPU folds its delta into
+ * calc_load_tasks_idle per calc_load_account_idle(), all we need to do is fold
+ * in the pending idle delta if our idle period crossed a load cycle boundary.
+ *
+ * Once we've updated the global active value, we need to apply the exponential
+ * weights adjusted to the number of cycles missed.
+ */
+static void calc_global_nohz(void)
+{
+	long delta, active, n;
+
+	if (!time_before(jiffies, calc_load_update + 10)) {
+		/*
+		 * Catch-up, fold however many we are behind still
+		 */
+		delta = jiffies - calc_load_update - 10;
+		n = 1 + (delta / LOAD_FREQ);
+
+		active = atomic_long_read(&calc_load_tasks);
+		active = active > 0 ? active * FIXED_1 : 0;
+
+		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
+
+		calc_load_update += n * LOAD_FREQ;
+	}
+
+	/*
+	 * Flip the idle index...
+	 *
+	 * Make sure we first write the new time then flip the index, so that
+	 * calc_load_write_idx() will see the new time when it reads the new
+	 * index, this avoids a double flip messing things up.
+	 */
+	smp_wmb();
+	calc_load_idx++;
+}
+#else /* !CONFIG_NO_HZ_COMMON */
+
+static inline long calc_load_fold_idle(void) { return 0; }
+static inline void calc_global_nohz(void) { }
+
+#endif /* CONFIG_NO_HZ_COMMON */
+
+/*
+ * calc_load - update the avenrun load estimates 10 ticks after the
+ * CPUs have updated calc_load_tasks.
+ */
+void calc_global_load(unsigned long ticks)
+{
+	long active, delta;
+
+	if (time_before(jiffies, calc_load_update + 10))
+		return;
+
+	/*
+	 * Fold the 'old' idle-delta to include all NO_HZ cpus.
+	 */
+	delta = calc_load_fold_idle();
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+
+	active = atomic_long_read(&calc_load_tasks);
+	active = active > 0 ? active * FIXED_1 : 0;
+
+	avenrun[0] = calc_load(avenrun[0], EXP_1, active);
+	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
+	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
+
+	calc_load_update += LOAD_FREQ;
+
+	/*
+	 * In case we idled for multiple LOAD_FREQ intervals, catch up in bulk.
+	 */
+	calc_global_nohz();
+}
+
+/*
+ * Called from update_cpu_load() to periodically update this CPU's
+ * active count.
+ */
+static void calc_load_account_active(struct rq *this_rq)
+{
+	long delta;
+
+	if (time_before(jiffies, this_rq->calc_load_update))
+		return;
+
+	delta  = calc_load_fold_active(this_rq);
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+
+	this_rq->calc_load_update += LOAD_FREQ;
+}
+
+/*
+ * End of global load-average stuff
+ */
+
+/*
+ * The exact cpuload at various idx values, calculated at every tick would be
+ * load = (2^idx - 1) / 2^idx * load + 1 / 2^idx * cur_load
+ *
+ * If a cpu misses updates for n-1 ticks (as it was idle) and update gets called
+ * on nth tick when cpu may be busy, then we have:
+ * load = ((2^idx - 1) / 2^idx)^(n-1) * load
+ * load = (2^idx - 1) / 2^idx) * load + 1 / 2^idx * cur_load
+ *
+ * decay_load_missed() below does efficient calculation of
+ * load = ((2^idx - 1) / 2^idx)^(n-1) * load
+ * avoiding 0..n-1 loop doing load = ((2^idx - 1) / 2^idx) * load
+ *
+ * The calculation is approximated on a 128 point scale.
+ * degrade_zero_ticks is the number of ticks after which load at any
+ * particular idx is approximated to be zero.
+ * degrade_factor is a precomputed table, a row for each load idx.
+ * Each column corresponds to degradation factor for a power of two ticks,
+ * based on 128 point scale.
+ * Example:
+ * row 2, col 3 (=12) says that the degradation at load idx 2 after
+ * 8 ticks is 12/128 (which is an approximation of exact factor 3^8/4^8).
+ *
+ * With this power of 2 load factors, we can degrade the load n times
+ * by looking at 1 bits in n and doing as many mult/shift instead of
+ * n mult/shifts needed by the exact degradation.
+ */
+#define DEGRADE_SHIFT		7
+static const unsigned char
+		degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
+static const unsigned char
+		degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
+					{0, 0, 0, 0, 0, 0, 0, 0},
+					{64, 32, 8, 0, 0, 0, 0, 0},
+					{96, 72, 40, 12, 1, 0, 0},
+					{112, 98, 75, 43, 15, 1, 0},
+					{120, 112, 98, 76, 45, 16, 2} };
+
+/*
+ * Update cpu_load for any missed ticks, due to tickless idle. The backlog
+ * would be when CPU is idle and so we just decay the old load without
+ * adding any new load.
+ */
+static unsigned long
+decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
+{
+	int j = 0;
+
+	if (!missed_updates)
+		return load;
+
+	if (missed_updates >= degrade_zero_ticks[idx])
+		return 0;
+
+	if (idx == 1)
+		return load >> missed_updates;
+
+	while (missed_updates) {
+		if (missed_updates % 2)
+			load = (load * degrade_factor[idx][j]) >> DEGRADE_SHIFT;
+
+		missed_updates >>= 1;
+		j++;
+	}
+	return load;
+}
+
+/*
+ * Update rq->cpu_load[] statistics. This function is usually called every
+ * scheduler tick (TICK_NSEC). With tickless idle this will not be called
+ * every tick. We fix it up based on jiffies.
+ */
+static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
+			      unsigned long pending_updates)
+{
+	int i, scale;
+
+	this_rq->nr_load_updates++;
+
+	/* Update our load: */
+	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
+	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
+		unsigned long old_load, new_load;
+
+		/* scale is effectively 1 << i now, and >> i divides by scale */
+
+		old_load = this_rq->cpu_load[i];
+		old_load = decay_load_missed(old_load, pending_updates - 1, i);
+		new_load = this_load;
+		/*
+		 * Round up the averaging division if load is increasing. This
+		 * prevents us from getting stuck on 9 if the load is 10, for
+		 * example.
+		 */
+		if (new_load > old_load)
+			new_load += scale - 1;
+
+		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
+	}
+
+	sched_avg_update(this_rq);
+}
+
+#ifdef CONFIG_SMP
+static inline unsigned long get_rq_runnable_load(struct rq *rq)
+{
+	return rq->cfs.runnable_load_avg;
+}
+#else
+static inline unsigned long get_rq_runnable_load(struct rq *rq)
+{
+	return rq->load.weight;
+}
+#endif
+
+#ifdef CONFIG_NO_HZ_COMMON
+/*
+ * There is no sane way to deal with nohz on smp when using jiffies because the
+ * cpu doing the jiffies update might drift wrt the cpu doing the jiffy reading
+ * causing off-by-one errors in observed deltas; {0,2} instead of {1,1}.
+ *
+ * Therefore we cannot use the delta approach from the regular tick since that
+ * would seriously skew the load calculation. However we'll make do for those
+ * updates happening while idle (nohz_idle_balance) or coming out of idle
+ * (tick_nohz_idle_exit).
+ *
+ * This means we might still be one tick off for nohz periods.
+ */
+
+/*
+ * Called from nohz_idle_balance() to update the load ratings before doing the
+ * idle balance.
+ */
+void update_idle_cpu_load(struct rq *this_rq)
+{
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long load = get_rq_runnable_load(this_rq);
+	unsigned long pending_updates;
+
+	/*
+	 * bail if there's load or we're actually up-to-date.
+	 */
+	if (load || curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	this_rq->last_load_update_tick = curr_jiffies;
+
+	__update_cpu_load(this_rq, load, pending_updates);
+}
+
+/*
+ * Called from tick_nohz_idle_exit() -- try and fix up the ticks we missed.
+ */
+void update_cpu_load_nohz(void)
+{
+	struct rq *this_rq = this_rq();
+	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+	unsigned long pending_updates;
+
+	if (curr_jiffies == this_rq->last_load_update_tick)
+		return;
+
+	raw_spin_lock(&this_rq->lock);
+	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
+	if (pending_updates) {
+		this_rq->last_load_update_tick = curr_jiffies;
+		/*
+		 * We were idle, this means load 0, the current load might be
+		 * !0 due to remote wakeups and the sort.
+		 */
+		__update_cpu_load(this_rq, 0, pending_updates);
+	}
+	raw_spin_unlock(&this_rq->lock);
+}
+#endif /* CONFIG_NO_HZ */
+
+/*
+ * Called from scheduler_tick()
+ */
+void update_cpu_load_active(struct rq *this_rq)
+{
+	unsigned long load = get_rq_runnable_load(this_rq);
+	/*
+	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
+	 */
+	this_rq->last_load_update_tick = jiffies;
+	__update_cpu_load(this_rq, load, 1);
+
+	calc_load_account_active(this_rq);
+}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 127a2c4..01970c8 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -399,20 +399,6 @@ static inline struct task_group *next_task_group(struct task_group *tg)
 		(iter = next_task_group(iter)) &&			\
 		(rt_rq = iter->rt_rq[cpu_of(rq)]);)
 
-static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-	list_add_rcu(&rt_rq->leaf_rt_rq_list,
-			&rq_of_rt_rq(rt_rq)->leaf_rt_rq_list);
-}
-
-static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-	list_del_rcu(&rt_rq->leaf_rt_rq_list);
-}
-
-#define for_each_leaf_rt_rq(rt_rq, rq) \
-	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = rt_se->parent)
 
@@ -472,7 +458,7 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 #ifdef CONFIG_SMP
 static inline const struct cpumask *sched_rt_period_mask(void)
 {
-	return cpu_rq(smp_processor_id())->rd->span;
+	return this_rq()->rd->span;
 }
 #else
 static inline const struct cpumask *sched_rt_period_mask(void)
@@ -509,17 +495,6 @@ typedef struct rt_rq *rt_rq_iter_t;
 #define for_each_rt_rq(rt_rq, iter, rq) \
 	for ((void) iter, rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
-static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-}
-
-static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
-{
-}
-
-#define for_each_leaf_rt_rq(rt_rq, rq) \
-	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = NULL)
 
@@ -699,15 +674,6 @@ balanced:
 	}
 }
 
-static void disable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__disable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
 static void __enable_runtime(struct rq *rq)
 {
 	rt_rq_iter_t iter;
@@ -732,37 +698,6 @@ static void __enable_runtime(struct rq *rq)
 	}
 }
 
-static void enable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__enable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	int cpu = (int)(long)hcpu;
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		disable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		enable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
 static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
@@ -926,7 +861,7 @@ static void update_curr_rt(struct rq *rq)
 	if (curr->sched_class != &rt_sched_class)
 		return;
 
-	delta_exec = rq->clock_task - curr->se.exec_start;
+	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
 	if (unlikely((s64)delta_exec <= 0))
 		return;
 
@@ -936,7 +871,7 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
 
-	curr->se.exec_start = rq->clock_task;
+	curr->se.exec_start = rq_clock_task(rq);
 	cpuacct_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
@@ -1106,9 +1041,6 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	if (!rt_rq->rt_nr_running)
-		list_add_leaf_rt_rq(rt_rq);
-
 	if (head)
 		list_add(&rt_se->run_list, queue);
 	else
@@ -1128,8 +1060,6 @@ static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
-	if (!rt_rq->rt_nr_running)
-		list_del_leaf_rt_rq(rt_rq);
 }
 
 /*
@@ -1385,7 +1315,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	} while (rt_rq);
 
 	p = rt_task_of(rt_se);
-	p->se.exec_start = rq->clock_task;
+	p->se.exec_start = rq_clock_task(rq);
 
 	return p;
 }
@@ -1434,42 +1364,24 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 	return 0;
 }
 
-/* Return the second highest RT task, NULL otherwise */
-static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
+/*
+ * Return the highest pushable rq's task, which is suitable to be executed
+ * on the cpu, NULL otherwise
+ */
+static struct task_struct *pick_highest_pushable_task(struct rq *rq, int cpu)
 {
-	struct task_struct *next = NULL;
-	struct sched_rt_entity *rt_se;
-	struct rt_prio_array *array;
-	struct rt_rq *rt_rq;
-	int idx;
-
-	for_each_leaf_rt_rq(rt_rq, rq) {
-		array = &rt_rq->active;
-		idx = sched_find_first_bit(array->bitmap);
-next_idx:
-		if (idx >= MAX_RT_PRIO)
-			continue;
-		if (next && next->prio <= idx)
-			continue;
-		list_for_each_entry(rt_se, array->queue + idx, run_list) {
-			struct task_struct *p;
+	struct plist_head *head = &rq->rt.pushable_tasks;
+	struct task_struct *p;
 
-			if (!rt_entity_is_task(rt_se))
-				continue;
+	if (!has_pushable_tasks(rq))
+		return NULL;
 
-			p = rt_task_of(rt_se);
-			if (pick_rt_task(rq, p, cpu)) {
-				next = p;
-				break;
-			}
-		}
-		if (!next) {
-			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-			goto next_idx;
-		}
+	plist_for_each_entry(p, head, pushable_tasks) {
+		if (pick_rt_task(rq, p, cpu))
+			return p;
 	}
 
-	return next;
+	return NULL;
 }
 
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
@@ -1743,12 +1655,10 @@ static int pull_rt_task(struct rq *this_rq)
 		double_lock_balance(this_rq, src_rq);
 
 		/*
-		 * Are there still pullable RT tasks?
+		 * We can pull only a task, which is pushable
+		 * on its rq, and no others.
 		 */
-		if (src_rq->rt.rt_nr_running <= 1)
-			goto skip;
-
-		p = pick_next_highest_task_rt(src_rq, this_cpu);
+		p = pick_highest_pushable_task(src_rq, this_cpu);
 
 		/*
 		 * Do we have an RT task that preempts
@@ -2037,7 +1947,7 @@ static void set_curr_task_rt(struct rq *rq)
 {
 	struct task_struct *p = rq->curr;
 
-	p->se.exec_start = rq->clock_task;
+	p->se.exec_start = rq_clock_task(rq);
 
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ce39224..ef0a7b2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -10,8 +10,16 @@
 #include "cpupri.h"
 #include "cpuacct.h"
 
+struct rq;
+
 extern __read_mostly int scheduler_running;
 
+extern unsigned long calc_load_update;
+extern atomic_long_t calc_load_tasks;
+
+extern long calc_load_fold_active(struct rq *this_rq);
+extern void update_cpu_load_active(struct rq *this_rq);
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -140,10 +148,11 @@ struct task_group {
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
 
-	atomic_t load_weight;
-	atomic64_t load_avg;
+#ifdef	CONFIG_SMP
+	atomic_long_t load_avg;
 	atomic_t runnable_avg;
 #endif
+#endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity **rt_se;
@@ -261,26 +270,21 @@ struct cfs_rq {
 #endif
 
 #ifdef CONFIG_SMP
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	/*
 	 * CFS Load tracking
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
 	 * This allows for the description of both thread and group usage (in
 	 * the FAIR_GROUP_SCHED case).
 	 */
-	u64 runnable_load_avg, blocked_load_avg;
-	atomic64_t decay_counter, removed_load;
+	unsigned long runnable_load_avg, blocked_load_avg;
+	atomic64_t decay_counter;
 	u64 last_decay;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-/* These always depend on CONFIG_FAIR_GROUP_SCHED */
+	atomic_long_t removed_load;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	/* Required to track per-cpu representation of a task_group */
 	u32 tg_runnable_contrib;
-	u64 tg_load_contrib;
+	unsigned long tg_load_contrib;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
@@ -353,7 +357,6 @@ struct rt_rq {
 	unsigned long rt_nr_boosted;
 
 	struct rq *rq;
-	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
 #endif
 };
@@ -540,6 +543,16 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+static inline u64 rq_clock(struct rq *rq)
+{
+	return rq->clock;
+}
+
+static inline u64 rq_clock_task(struct rq *rq)
+{
+	return rq->clock_task;
+}
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
@@ -884,24 +897,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #define WF_FORK		0x02		/* child wakeup after fork */
 #define WF_MIGRATED	0x4		/* internal use, task got migrated */
 
-static inline void update_load_add(struct load_weight *lw, unsigned long inc)
-{
-	lw->weight += inc;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
-{
-	lw->weight -= dec;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_set(struct load_weight *lw, unsigned long w)
-{
-	lw->weight = w;
-	lw->inv_weight = 0;
-}
-
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
@@ -1028,17 +1023,8 @@ extern void update_group_power(struct sched_domain *sd, int cpu);
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
-/*
- * Only depends on SMP, FAIR_GROUP_SCHED may be removed when runnable_avg
- * becomes useful in lb
- */
-#if defined(CONFIG_FAIR_GROUP_SCHED)
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
-#else
-static inline void idle_enter_fair(struct rq *this_rq) {}
-static inline void idle_exit_fair(struct rq *this_rq) {}
-#endif
 
 #else	/* CONFIG_SMP */
 
@@ -1051,7 +1037,6 @@ static inline void idle_balance(int cpu, struct rq *rq)
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
-extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 
@@ -1063,6 +1048,8 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern void update_idle_cpu_load(struct rq *this_rq);
 
+extern void init_task_runnable_average(struct task_struct *p);
+
 #ifdef CONFIG_PARAVIRT
 static inline u64 steal_ticks(u64 steal)
 {
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2ef90a5..17d7065 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -61,7 +61,7 @@ static inline void sched_info_reset_dequeued(struct task_struct *t)
  */
 static inline void sched_info_dequeued(struct task_struct *t)
 {
-	unsigned long long now = task_rq(t)->clock, delta = 0;
+	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
 
 	if (unlikely(sched_info_on()))
 		if (t->sched_info.last_queued)
@@ -79,7 +79,7 @@ static inline void sched_info_dequeued(struct task_struct *t)
  */
 static void sched_info_arrive(struct task_struct *t)
 {
-	unsigned long long now = task_rq(t)->clock, delta = 0;
+	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
@@ -100,7 +100,7 @@ static inline void sched_info_queued(struct task_struct *t)
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = task_rq(t)->clock;
+			t->sched_info.last_queued = rq_clock(task_rq(t));
 }
 
 /*
@@ -112,7 +112,7 @@ static inline void sched_info_queued(struct task_struct *t)
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
-	unsigned long long delta = task_rq(t)->clock -
+	unsigned long long delta = rq_clock(task_rq(t)) -
 					t->sched_info.last_arrival;
 
 	rq_sched_info_depart(task_rq(t), delta);
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index da5eb5b..e08fbee 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -28,7 +28,7 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 	struct task_struct *stop = rq->stop;
 
 	if (stop && stop->on_rq) {
-		stop->se.exec_start = rq->clock_task;
+		stop->se.exec_start = rq_clock_task(rq);
 		return stop;
 	}
 
@@ -57,7 +57,7 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	struct task_struct *curr = rq->curr;
 	u64 delta_exec;
 
-	delta_exec = rq->clock_task - curr->se.exec_start;
+	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
@@ -67,7 +67,7 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
 
-	curr->se.exec_start = rq->clock_task;
+	curr->se.exec_start = rq_clock_task(rq);
 	cpuacct_charge(curr, delta_exec);
 }
 
@@ -79,7 +79,7 @@ static void set_curr_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	stop->se.exec_start = rq->clock_task;
+	stop->se.exec_start = rq_clock_task(rq);
 }
 
 static void switched_to_stop(struct rq *rq, struct task_struct *p)
diff --git a/kernel/time.c b/kernel/time.c
index d3617db..7c7964c 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -11,7 +11,7 @@
  * Modification history kernel/time.c
  *
  * 1993-09-02    Philip Gladstone
- *      Created file with time related functions from sched.c and adjtimex()
+ *      Created file with time related functions from sched/core.c and adjtimex()
  * 1993-10-08    Torsten Duwe
  *      adjtime interface update and CMOS clock write code
  * 1995-08-13    Torsten Duwe
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index ad83c96..7e2204d 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -64,7 +64,7 @@ static inline struct worker *current_wq_worker(void)
 
 /*
  * Scheduler hooks for concurrency managed workqueue.  Only to be used from
- * sched.c and workqueue.c.
+ * sched/core.c and workqueue.c.
  */
 void wq_worker_waking_up(struct task_struct *task, int cpu);
 struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu);
