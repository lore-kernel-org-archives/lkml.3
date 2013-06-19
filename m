Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab3FSSkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:40:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40115 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab3FSSke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:40:34 -0400
Date: Wed, 19 Jun 2013 11:40:00 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-0a0fca9d832b704f116a25badd1ca8c16771dcac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <cdff76a265326ab8d71922a1db5be599f20aad45.1370329560.git.viresh.kumar@linaro.org>
References: <cdff76a265326ab8d71922a1db5be599f20aad45.1370329560.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rename sched.c as sched/
 core.c in comments and Documentation
Git-Commit-ID: 0a0fca9d832b704f116a25badd1ca8c16771dcac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:40:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a0fca9d832b704f116a25badd1ca8c16771dcac
Gitweb:     http://git.kernel.org/tip/0a0fca9d832b704f116a25badd1ca8c16771dcac
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 4 Jun 2013 13:10:24 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:42 +0200

sched: Rename sched.c as sched/core.c in comments and Documentation

Most of the stuff from kernel/sched.c was moved to kernel/sched/core.c long time
back and the comments/Documentation never got updated.

I figured it out when I was going through sched-domains.txt and so thought of
fixing it globally.

I haven't crossed check if the stuff that is referenced in sched/core.c by all
these files is still present and hasn't changed as that wasn't the motive behind
this patch.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/cdff76a265326ab8d71922a1db5be599f20aad45.1370329560.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/cgroups/cpusets.txt                 | 2 +-
 Documentation/rt-mutex-design.txt                 | 2 +-
 Documentation/scheduler/sched-domains.txt         | 4 ++--
 Documentation/spinlocks.txt                       | 2 +-
 Documentation/virtual/uml/UserModeLinux-HOWTO.txt | 4 ++--
 arch/avr32/kernel/process.c                       | 2 +-
 arch/cris/include/arch-v10/arch/bitops.h          | 2 +-
 arch/ia64/kernel/head.S                           | 2 +-
 arch/mips/kernel/mips-mt-fpaff.c                  | 4 ++--
 arch/mips/kernel/scall32-o32.S                    | 5 +++--
 arch/powerpc/include/asm/mmu_context.h            | 2 +-
 arch/tile/include/asm/processor.h                 | 2 +-
 arch/tile/kernel/stack.c                          | 2 +-
 arch/um/kernel/sysrq.c                            | 2 +-
 include/linux/completion.h                        | 2 +-
 include/linux/perf_event.h                        | 2 +-
 include/linux/spinlock_up.h                       | 2 +-
 include/uapi/asm-generic/unistd.h                 | 2 +-
 kernel/cpuset.c                                   | 4 ++--
 kernel/time.c                                     | 2 +-
 kernel/workqueue_internal.h                       | 2 +-
 21 files changed, 27 insertions(+), 26 deletions(-)

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
index f463a46..5ec99e5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -803,7 +803,7 @@ static inline void perf_restore_debug_store(void)			{ }
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
 /*
- * This has to have a higher priority than migration_notifier in sched.c.
+ * This has to have a higher priority than migration_notifier in sched/core.c.
  */
 #define perf_cpu_notifier(fn)						\
 do {									\
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
