Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab3D3G6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:58:17 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52321 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3D3G6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:58:13 -0400
Date: Tue, 30 Apr 2013 08:58:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.10
Message-ID: <20130430065808.GA19736@gmail.com>
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

   HEAD: 25f55d9d01ad7a7ad248fd5af1d22675ffd202c5 sched: Fix init NOHZ_IDLE flag

The main changes in this development cycle were:

  - full dynticks preparatory work by Frederic Weisbecker

  - factor out the cpu time accounting code better, by Li Zefan

  - multi-CPU load balancer cleanups and improvements by Joonsoo Kim

  - various smaller fixes and cleanups

 Thanks,

	Ingo

------------------>
Andrei Epure (3):
      sched: Spelling fix
      sched: Fix variable name misnomer, add comments
      sched: Document task_struct::personality field

Frederic Weisbecker (7):
      context_tracking: Move exception handling to generic code
      context_tracking: Restore correct previous context state on exception exit
      context_tracking: Restore preempted context state after preempt_schedule_irq()
      cputime: Dynamically scale cputime for full dynticks accounting
      context_tracking: Enable probes by default for selftesting
      math64: New div64_u64_rem helper
      sched: Lower chances of cputime scaling overflow

Ingo Molnar (1):
      sched/cpuacct/UML: Fix header file dependency bug on the UML build

Joonsoo Kim (6):
      sched: Change position of resched_cpu() in load_balance()
      sched: Explicitly cpu_idle_type checking in rebalance_domains()
      sched: Don't consider other cpus in our group in case of NEWLY_IDLE
      sched: Move up affinity check to mitigate useless redoing overhead
      sched: Rename load_balance_tmpmask to load_balance_mask
      sched: Prevent to re-select dst-cpu in load_balance()

Li Zefan (22):
      sched: Remove some dummy functions
      sched: Remove test_sd_parent()
      sched: Move SCHED_LOAD_SHIFT macros to kernel/sched/sched.h
      sched: Move struct sched_group to kernel/sched/sched.h
      sched: Move wake flags to kernel/sched/sched.h
      sched: Move struct sched_class to kernel/sched/sched.h
      sched: Make default_scale_freq_power() static
      sched: Move group scheduling functions out of include/linux/sched.h
      sched: Remove double declaration of root_task_group
      sched: Fix update_group_power() prototype placement to fix build warning when !CONFIG_SMP
      sched: Split cpuacct code out of core.c
      sched: Split cpuacct code out of sched.h
      sched/cpuacct: Add cpuacct_init()
      sched/cpuacct: Add cpuacct_acount_field()
      sched/cpuacct: Remove redundant NULL checks in cpuacct_charge()
      sched/cpuacct: Remove redundant NULL checks in cpuacct_acount_field()
      sched/cpuacct: Clean up cpuacct.h
      sched/cpuacct: Allocate per_cpu cpuusage for root cpuacct statically
      sched/cpuacct: Initialize root cpuacct earlier
      sched/cpuacct: Initialize cpuacct subsystem earlier
      sched/cpuacct: No need to check subsys active state
      cgroup: Kill subsys.active flag

Libin (1):
      sched: Fix comment in rebalance_domains()

Peter Zijlstra (1):
      sched/tracing: Allow tracing the preemption decision on wakeup

Vincent Guittot (2):
      sched: Fix wrong rq's runnable_avg update with rt tasks
      sched: Fix init NOHZ_IDLE flag

Viresh Kumar (1):
      sched: Fix typo inside comment

Zhang Hang (1):
      sched: Simplify can_migrate_task()


 arch/x86/include/asm/context_tracking.h |  21 ---
 arch/x86/kernel/kvm.c                   |   8 +-
 arch/x86/kernel/traps.c                 |  68 +++++---
 arch/x86/mm/fault.c                     |   8 +-
 include/linux/cgroup.h                  |   1 -
 include/linux/context_tracking.h        |  24 ++-
 include/linux/math64.h                  |  19 +-
 include/linux/sched.h                   | 204 +---------------------
 init/Kconfig                            |   1 +
 kernel/cgroup.c                         |   3 -
 kernel/fork.c                           |   2 +-
 kernel/sched/Makefile                   |   1 +
 kernel/sched/core.c                     | 254 ++-------------------------
 kernel/sched/cpuacct.c                  | 296 ++++++++++++++++++++++++++++++++
 kernel/sched/cpuacct.h                  |  17 ++
 kernel/sched/cputime.c                  | 214 ++++++++++++-----------
 kernel/sched/fair.c                     | 148 +++++++++-------
 kernel/sched/idle_task.c                |  16 ++
 kernel/sched/sched.h                    | 219 +++++++++++++++++------
 lib/div64.c                             |  19 +-
 20 files changed, 834 insertions(+), 709 deletions(-)
 create mode 100644 kernel/sched/cpuacct.c
 create mode 100644 kernel/sched/cpuacct.h

diff --git a/arch/x86/include/asm/context_tracking.h b/arch/x86/include/asm/context_tracking.h
index 1616562..1fe4970 100644
--- a/arch/x86/include/asm/context_tracking.h
+++ b/arch/x86/include/asm/context_tracking.h
@@ -1,31 +1,10 @@
 #ifndef _ASM_X86_CONTEXT_TRACKING_H
 #define _ASM_X86_CONTEXT_TRACKING_H
 
-#ifndef __ASSEMBLY__
-#include <linux/context_tracking.h>
-#include <asm/ptrace.h>
-
-static inline void exception_enter(struct pt_regs *regs)
-{
-	user_exit();
-}
-
-static inline void exception_exit(struct pt_regs *regs)
-{
-#ifdef CONFIG_CONTEXT_TRACKING
-	if (user_mode(regs))
-		user_enter();
-#endif
-}
-
-#else /* __ASSEMBLY__ */
-
 #ifdef CONFIG_CONTEXT_TRACKING
 # define SCHEDULE_USER call schedule_user
 #else
 # define SCHEDULE_USER call schedule
 #endif
 
-#endif /* !__ASSEMBLY__ */
-
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b686a90..cd6d9a5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -20,6 +20,7 @@
  *   Authors: Anthony Liguori <aliguori@us.ibm.com>
  */
 
+#include <linux/context_tracking.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/kvm_para.h>
@@ -43,7 +44,6 @@
 #include <asm/apicdef.h>
 #include <asm/hypervisor.h>
 #include <asm/kvm_guest.h>
-#include <asm/context_tracking.h>
 
 static int kvmapf = 1;
 
@@ -254,16 +254,18 @@ EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
 dotraplinkage void __kprobes
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
+	enum ctx_state prev_state;
+
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
 		do_page_fault(regs, error_code);
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		exception_enter(regs);
+		prev_state = exception_enter();
 		exit_idle();
 		kvm_async_pf_task_wait((u32)read_cr2());
-		exception_exit(regs);
+		exception_exit(prev_state);
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 68bda7a..ff6d227 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/context_tracking.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/spinlock.h>
@@ -55,8 +56,6 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
-#include <asm/context_tracking.h>
-
 #include <asm/mach_traps.h>
 
 #ifdef CONFIG_X86_64
@@ -176,34 +175,38 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	exception_enter(regs);						\
+	enum ctx_state prev_state;					\
+									\
+	prev_state = exception_enter();					\
 	if (notify_die(DIE_TRAP, str, regs, error_code,			\
 			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(regs);					\
+		exception_exit(prev_state);				\
 		return;							\
 	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
-	exception_exit(regs);						\
+	exception_exit(prev_state);					\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
+	enum ctx_state prev_state;					\
+									\
 	info.si_signo = signr;						\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
-	exception_enter(regs);						\
+	prev_state = exception_enter();					\
 	if (notify_die(DIE_TRAP, str, regs, error_code,			\
 			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(regs);					\
+		exception_exit(prev_state);				\
 		return;							\
 	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
-	exception_exit(regs);						\
+	exception_exit(prev_state);					\
 }
 
 DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
@@ -226,14 +229,16 @@ DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
 		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
 		preempt_conditional_sti(regs);
 		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
 		preempt_conditional_cli(regs);
 	}
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -241,7 +246,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
 
-	exception_enter(regs);
+	exception_enter();
 	/* Return not checked because double check cannot be ignored */
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
@@ -261,8 +266,9 @@ dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
+	enum ctx_state prev_state;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 	conditional_sti(regs);
 
 #ifdef CONFIG_X86_32
@@ -300,12 +306,14 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 	force_sig(SIGSEGV, tsk);
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 /* May run on IST stack. */
 dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
 {
+	enum ctx_state prev_state;
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/*
 	 * ftrace must be first, everything else may cause a recursive crash.
@@ -315,7 +323,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	    ftrace_int3_handler(regs))
 		return;
 #endif
-	exception_enter(regs);
+	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -336,7 +344,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 #ifdef CONFIG_X86_64
@@ -393,11 +401,12 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
+	enum ctx_state prev_state;
 	int user_icebp = 0;
 	unsigned long dr6;
 	int si_code;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 
 	get_debugreg(dr6, 6);
 
@@ -467,7 +476,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	debug_stack_usage_dec();
 
 exit:
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 /*
@@ -561,17 +570,21 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	math_error(regs, error_code, X86_TRAP_MF);
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	math_error(regs, error_code, X86_TRAP_XF);
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 dotraplinkage void
@@ -639,7 +652,9 @@ EXPORT_SYMBOL_GPL(math_state_restore);
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	BUG_ON(use_eager_fpu());
 
 #ifdef CONFIG_MATH_EMULATION
@@ -650,7 +665,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 
 		info.regs = regs;
 		math_emulate(&info);
-		exception_exit(regs);
+		exception_exit(prev_state);
 		return;
 	}
 #endif
@@ -658,15 +673,16 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 #ifdef CONFIG_X86_32
 	conditional_sti(regs);
 #endif
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 {
 	siginfo_t info;
+	enum ctx_state prev_state;
 
-	exception_enter(regs);
+	prev_state = exception_enter();
 	local_irq_enable();
 
 	info.si_signo = SIGILL;
@@ -678,7 +694,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 		do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
 			&info);
 	}
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
 #endif
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2b97525..fa8c02d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -13,12 +13,12 @@
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 #include <linux/prefetch.h>		/* prefetchw			*/
+#include <linux/context_tracking.h>	/* exception_enter(), ...	*/
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
-#include <asm/context_tracking.h>	/* exception_enter(), ...	*/
 
 /*
  * Page fault error code bits:
@@ -1222,7 +1222,9 @@ good_area:
 dotraplinkage void __kprobes
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
-	exception_enter(regs);
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
 	__do_page_fault(regs, error_code);
-	exception_exit(regs);
+	exception_exit(prev_state);
 }
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 900af59..95c02c0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -458,7 +458,6 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup *root);
 
 	int subsys_id;
-	int active;
 	int disabled;
 	int early_init;
 	/*
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index b28d161..365f4a6 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -1,9 +1,9 @@
 #ifndef _LINUX_CONTEXT_TRACKING_H
 #define _LINUX_CONTEXT_TRACKING_H
 
-#ifdef CONFIG_CONTEXT_TRACKING
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#include <asm/ptrace.h>
 
 struct context_tracking {
 	/*
@@ -13,12 +13,13 @@ struct context_tracking {
 	 * may be further optimized using static keys.
 	 */
 	bool active;
-	enum {
+	enum ctx_state {
 		IN_KERNEL = 0,
 		IN_USER,
 	} state;
 };
 
+#ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
 static inline bool context_tracking_in_user(void)
@@ -33,12 +34,31 @@ static inline bool context_tracking_active(void)
 
 extern void user_enter(void);
 extern void user_exit(void);
+
+static inline enum ctx_state exception_enter(void)
+{
+	enum ctx_state prev_ctx;
+
+	prev_ctx = this_cpu_read(context_tracking.state);
+	user_exit();
+
+	return prev_ctx;
+}
+
+static inline void exception_exit(enum ctx_state prev_ctx)
+{
+	if (prev_ctx == IN_USER)
+		user_enter();
+}
+
 extern void context_tracking_task_switch(struct task_struct *prev,
 					 struct task_struct *next);
 #else
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
+static inline enum ctx_state exception_enter(void) { return 0; }
+static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
 						struct task_struct *next) { }
 #endif /* !CONFIG_CONTEXT_TRACKING */
diff --git a/include/linux/math64.h b/include/linux/math64.h
index b8ba855..931a619 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -30,6 +30,15 @@ static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 }
 
 /**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor
+ */
+static inline u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
  * div64_u64 - unsigned 64bit divide with 64bit divisor
  */
 static inline u64 div64_u64(u64 dividend, u64 divisor)
@@ -61,8 +70,16 @@ static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
 #endif
 
+#ifndef div64_u64_rem
+extern u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder);
+#endif
+
 #ifndef div64_u64
-extern u64 div64_u64(u64 dividend, u64 divisor);
+static inline u64 div64_u64(u64 dividend, u64 divisor)
+{
+	u64 remainder;
+	return div64_u64_rem(dividend, divisor, &remainder);
+}
 #endif
 
 #ifndef div64_s64
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..a25168f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -127,18 +127,6 @@ extern void proc_sched_show_task(struct task_struct *p, struct seq_file *m);
 extern void proc_sched_set_task(struct task_struct *p);
 extern void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
-#else
-static inline void
-proc_sched_show_task(struct task_struct *p, struct seq_file *m)
-{
-}
-static inline void proc_sched_set_task(struct task_struct *p)
-{
-}
-static inline void
-print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
-{
-}
 #endif
 
 /*
@@ -570,7 +558,7 @@ struct signal_struct {
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
 #endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
@@ -768,31 +756,6 @@ enum cpu_idle_type {
 };
 
 /*
- * Increase resolution of nice-level calculations for 64-bit architectures.
- * The extra resolution improves shares distribution and load balancing of
- * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
- * hierarchies, especially on larger systems. This is not a user-visible change
- * and does not change the user-interface for setting shares/weights.
- *
- * We increase resolution only if we have enough bits to allow this increased
- * resolution (i.e. BITS_PER_LONG > 32). The costs for increasing resolution
- * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
- * increased costs.
- */
-#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
-# define SCHED_LOAD_RESOLUTION	10
-# define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
-# define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
-#else
-# define SCHED_LOAD_RESOLUTION	0
-# define scale_load(w)		(w)
-# define scale_load_down(w)	(w)
-#endif
-
-#define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
-#define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
-
-/*
  * Increase resolution of cpu_power calculations
  */
 #define SCHED_POWER_SHIFT	10
@@ -817,62 +780,6 @@ enum cpu_idle_type {
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
-struct sched_group_power {
-	atomic_t ref;
-	/*
-	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
-	 * single CPU.
-	 */
-	unsigned int power, power_orig;
-	unsigned long next_update;
-	/*
-	 * Number of busy cpus in this group.
-	 */
-	atomic_t nr_busy_cpus;
-
-	unsigned long cpumask[0]; /* iteration mask */
-};
-
-struct sched_group {
-	struct sched_group *next;	/* Must be a circular list */
-	atomic_t ref;
-
-	unsigned int group_weight;
-	struct sched_group_power *sgp;
-
-	/*
-	 * The CPUs this group covers.
-	 *
-	 * NOTE: this field is variable length. (Allocated dynamically
-	 * by attaching extra space to the end of the structure,
-	 * depending on how many CPUs the kernel has booted up with)
-	 */
-	unsigned long cpumask[0];
-};
-
-static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
-{
-	return to_cpumask(sg->cpumask);
-}
-
-/*
- * cpumask masking which cpus in the group are allowed to iterate up the domain
- * tree.
- */
-static inline struct cpumask *sched_group_mask(struct sched_group *sg)
-{
-	return to_cpumask(sg->sgp->cpumask);
-}
-
-/**
- * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
- * @group: The group whose first cpu is to be returned.
- */
-static inline unsigned int group_first_cpu(struct sched_group *group)
-{
-	return cpumask_first(sched_group_cpus(group));
-}
-
 struct sched_domain_attr {
 	int relax_domain_level;
 };
@@ -883,6 +790,8 @@ struct sched_domain_attr {
 
 extern int sched_domain_level_max;
 
+struct sched_group;
+
 struct sched_domain {
 	/* These fields must be setup */
 	struct sched_domain *parent;	/* top domain must be null terminated */
@@ -899,6 +808,8 @@ struct sched_domain {
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
+
+	int nohz_idle;			/* NOHZ IDLE status */
 	int flags;			/* See SD_* */
 	int level;
 
@@ -971,18 +882,6 @@ extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
 void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 
-/* Test a flag in parent sched domain */
-static inline int test_sd_parent(struct sched_domain *sd, int flag)
-{
-	if (sd->parent && (sd->parent->flags & flag))
-		return 1;
-
-	return 0;
-}
-
-unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
-unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
-
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
 #else /* CONFIG_SMP */
@@ -1017,72 +916,6 @@ struct mempolicy;
 struct pipe_inode_info;
 struct uts_namespace;
 
-struct rq;
-struct sched_domain;
-
-/*
- * wake flags
- */
-#define WF_SYNC		0x01		/* waker goes to sleep after wakup */
-#define WF_FORK		0x02		/* child wakeup after fork */
-#define WF_MIGRATED	0x04		/* internal use, task got migrated */
-
-#define ENQUEUE_WAKEUP		1
-#define ENQUEUE_HEAD		2
-#ifdef CONFIG_SMP
-#define ENQUEUE_WAKING		4	/* sched_class::task_waking was called */
-#else
-#define ENQUEUE_WAKING		0
-#endif
-
-#define DEQUEUE_SLEEP		1
-
-struct sched_class {
-	const struct sched_class *next;
-
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
-	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
-	void (*yield_task) (struct rq *rq);
-	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
-
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
-
-	struct task_struct * (*pick_next_task) (struct rq *rq);
-	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
-
-#ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
-	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
-
-	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
-	void (*post_schedule) (struct rq *this_rq);
-	void (*task_waking) (struct task_struct *task);
-	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
-
-	void (*set_cpus_allowed)(struct task_struct *p,
-				 const struct cpumask *newmask);
-
-	void (*rq_online)(struct rq *rq);
-	void (*rq_offline)(struct rq *rq);
-#endif
-
-	void (*set_curr_task) (struct rq *rq);
-	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_fork) (struct task_struct *p);
-
-	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
-	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
-	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
-			     int oldprio);
-
-	unsigned int (*get_rr_interval) (struct rq *rq,
-					 struct task_struct *task);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*task_move_group) (struct task_struct *p, int on_rq);
-#endif
-};
-
 struct load_weight {
 	unsigned long weight, inv_weight;
 };
@@ -1274,8 +1107,10 @@ struct task_struct {
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
-	/* ??? */
+
+	/* Used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
+
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
@@ -1327,7 +1162,7 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
 #endif
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
@@ -2681,28 +2516,7 @@ extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
 extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
 #ifdef CONFIG_CGROUP_SCHED
-
 extern struct task_group root_task_group;
-
-extern struct task_group *sched_create_group(struct task_group *parent);
-extern void sched_online_group(struct task_group *tg,
-			       struct task_group *parent);
-extern void sched_destroy_group(struct task_group *tg);
-extern void sched_offline_group(struct task_group *tg);
-extern void sched_move_task(struct task_struct *tsk);
-#ifdef CONFIG_FAIR_GROUP_SCHED
-extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
-extern unsigned long sched_group_shares(struct task_group *tg);
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-extern int sched_group_set_rt_runtime(struct task_group *tg,
-				      long rt_runtime_us);
-extern long sched_group_rt_runtime(struct task_group *tg);
-extern int sched_group_set_rt_period(struct task_group *tg,
-				      long rt_period_us);
-extern long sched_group_rt_period(struct task_group *tg);
-extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
-#endif
 #endif /* CONFIG_CGROUP_SCHED */
 
 extern int task_can_switch_user(struct user_struct *up,
diff --git a/init/Kconfig b/init/Kconfig
index 22616cd..8a1dac2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -509,6 +509,7 @@ config RCU_USER_QS
 config CONTEXT_TRACKING_FORCE
 	bool "Force context tracking"
 	depends on CONTEXT_TRACKING
+	default CONTEXT_TRACKING
 	help
 	  Probe on user/kernel boundaries by default in order to
 	  test the features that rely on it such as userspace RCU extended
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..5c46281 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4468,7 +4468,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
-	ss->active = 1;
 	BUG_ON(online_css(ss, dummytop));
 
 	mutex_unlock(&cgroup_mutex);
@@ -4573,7 +4572,6 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	}
 	write_unlock(&css_set_lock);
 
-	ss->active = 1;
 	ret = online_css(ss, dummytop);
 	if (ret)
 		goto err_unload;
@@ -4614,7 +4612,6 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	mutex_lock(&cgroup_mutex);
 
 	offline_css(ss, dummytop);
-	ss->active = 0;
 
 	if (ss->use_id)
 		idr_destroy(&ss->idr);
diff --git a/kernel/fork.c b/kernel/fork.c
index 8d932b1..f3146ed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1230,7 +1230,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->utime = p->stime = p->gtime = 0;
 	p->utimescaled = p->stimescaled = 0;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index f06d249..deaf90e 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
+obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..cb49b2a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1288,8 +1288,8 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 static void
 ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
-	trace_sched_wakeup(p, true);
 	check_preempt_curr(rq, p, wake_flags);
+	trace_sched_wakeup(p, true);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -3082,11 +3082,13 @@ EXPORT_SYMBOL(preempt_schedule);
 asmlinkage void __sched preempt_schedule_irq(void)
 {
 	struct thread_info *ti = current_thread_info();
+	enum ctx_state prev_state;
 
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
-	user_exit();
+	prev_state = exception_enter();
+
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
@@ -3100,6 +3102,8 @@ asmlinkage void __sched preempt_schedule_irq(void)
 		 */
 		barrier();
 	} while (need_resched());
+
+	exception_exit(prev_state);
 }
 
 #endif /* CONFIG_PREEMPT */
@@ -6248,7 +6252,7 @@ static void sched_init_numa(void)
 	 * 'level' contains the number of unique distances, excluding the
 	 * identity distance node_distance(i,i).
 	 *
-	 * The sched_domains_nume_distance[] array includes the actual distance
+	 * The sched_domains_numa_distance[] array includes the actual distance
 	 * numbers.
 	 */
 
@@ -6861,11 +6865,15 @@ int in_sched_functions(unsigned long addr)
 }
 
 #ifdef CONFIG_CGROUP_SCHED
+/*
+ * Default task group.
+ * Every task in system belongs to this group at bootup.
+ */
 struct task_group root_task_group;
 LIST_HEAD(task_groups);
 #endif
 
-DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DECLARE_PER_CPU(cpumask_var_t, load_balance_mask);
 
 void __init sched_init(void)
 {
@@ -6902,7 +6910,7 @@ void __init sched_init(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
-			per_cpu(load_balance_tmpmask, i) = (void *)ptr;
+			per_cpu(load_balance_mask, i) = (void *)ptr;
 			ptr += cpumask_size();
 		}
 #endif /* CONFIG_CPUMASK_OFFSTACK */
@@ -6928,12 +6936,6 @@ void __init sched_init(void)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-#ifdef CONFIG_CGROUP_CPUACCT
-	root_cpuacct.cpustat = &kernel_cpustat;
-	root_cpuacct.cpuusage = alloc_percpu(u64);
-	/* Too early, not expected to fail */
-	BUG_ON(!root_cpuacct.cpuusage);
-#endif
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
@@ -7455,7 +7457,7 @@ unlock:
 	return err;
 }
 
-int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
+static int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
 
@@ -7467,7 +7469,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
-long sched_group_rt_runtime(struct task_group *tg)
+static long sched_group_rt_runtime(struct task_group *tg)
 {
 	u64 rt_runtime_us;
 
@@ -7479,7 +7481,7 @@ long sched_group_rt_runtime(struct task_group *tg)
 	return rt_runtime_us;
 }
 
-int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
+static int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 {
 	u64 rt_runtime, rt_period;
 
@@ -7492,7 +7494,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
-long sched_group_rt_period(struct task_group *tg)
+static long sched_group_rt_period(struct task_group *tg)
 {
 	u64 rt_period_us;
 
@@ -7527,7 +7529,7 @@ static int sched_rt_global_constraints(void)
 	return ret;
 }
 
-int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
+static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 {
 	/* Don't accept realtime tasks when there is no way for them to run */
 	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
@@ -8035,226 +8037,6 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
-#ifdef CONFIG_CGROUP_CPUACCT
-
-/*
- * CPU accounting code for task groups.
- *
- * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
- * (balbir@in.ibm.com).
- */
-
-struct cpuacct root_cpuacct;
-
-/* create a new cpu accounting group */
-static struct cgroup_subsys_state *cpuacct_css_alloc(struct cgroup *cgrp)
-{
-	struct cpuacct *ca;
-
-	if (!cgrp->parent)
-		return &root_cpuacct.css;
-
-	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
-	if (!ca)
-		goto out;
-
-	ca->cpuusage = alloc_percpu(u64);
-	if (!ca->cpuusage)
-		goto out_free_ca;
-
-	ca->cpustat = alloc_percpu(struct kernel_cpustat);
-	if (!ca->cpustat)
-		goto out_free_cpuusage;
-
-	return &ca->css;
-
-out_free_cpuusage:
-	free_percpu(ca->cpuusage);
-out_free_ca:
-	kfree(ca);
-out:
-	return ERR_PTR(-ENOMEM);
-}
-
-/* destroy an existing cpu accounting group */
-static void cpuacct_css_free(struct cgroup *cgrp)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-
-	free_percpu(ca->cpustat);
-	free_percpu(ca->cpuusage);
-	kfree(ca);
-}
-
-static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
-{
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-	u64 data;
-
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
-	 */
-	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	data = *cpuusage;
-	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	data = *cpuusage;
-#endif
-
-	return data;
-}
-
-static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
-{
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
-	 */
-	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	*cpuusage = val;
-	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	*cpuusage = val;
-#endif
-}
-
-/* return total cpu usage (in nanoseconds) of a group */
-static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-	u64 totalcpuusage = 0;
-	int i;
-
-	for_each_present_cpu(i)
-		totalcpuusage += cpuacct_cpuusage_read(ca, i);
-
-	return totalcpuusage;
-}
-
-static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
-								u64 reset)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-	int err = 0;
-	int i;
-
-	if (reset) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	for_each_present_cpu(i)
-		cpuacct_cpuusage_write(ca, i, 0);
-
-out:
-	return err;
-}
-
-static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
-				   struct seq_file *m)
-{
-	struct cpuacct *ca = cgroup_ca(cgroup);
-	u64 percpu;
-	int i;
-
-	for_each_present_cpu(i) {
-		percpu = cpuacct_cpuusage_read(ca, i);
-		seq_printf(m, "%llu ", (unsigned long long) percpu);
-	}
-	seq_printf(m, "\n");
-	return 0;
-}
-
-static const char *cpuacct_stat_desc[] = {
-	[CPUACCT_STAT_USER] = "user",
-	[CPUACCT_STAT_SYSTEM] = "system",
-};
-
-static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
-			      struct cgroup_map_cb *cb)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-	int cpu;
-	s64 val = 0;
-
-	for_each_online_cpu(cpu) {
-		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_USER];
-		val += kcpustat->cpustat[CPUTIME_NICE];
-	}
-	val = cputime64_to_clock_t(val);
-	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
-
-	val = 0;
-	for_each_online_cpu(cpu) {
-		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_SYSTEM];
-		val += kcpustat->cpustat[CPUTIME_IRQ];
-		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
-	}
-
-	val = cputime64_to_clock_t(val);
-	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
-
-	return 0;
-}
-
-static struct cftype files[] = {
-	{
-		.name = "usage",
-		.read_u64 = cpuusage_read,
-		.write_u64 = cpuusage_write,
-	},
-	{
-		.name = "usage_percpu",
-		.read_seq_string = cpuacct_percpu_seq_read,
-	},
-	{
-		.name = "stat",
-		.read_map = cpuacct_stats_show,
-	},
-	{ }	/* terminate */
-};
-
-/*
- * charge this task's execution time to its accounting group.
- *
- * called with rq->lock held.
- */
-void cpuacct_charge(struct task_struct *tsk, u64 cputime)
-{
-	struct cpuacct *ca;
-	int cpu;
-
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
-	cpu = task_cpu(tsk);
-
-	rcu_read_lock();
-
-	ca = task_ca(tsk);
-
-	for (; ca; ca = parent_ca(ca)) {
-		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-		*cpuusage += cputime;
-	}
-
-	rcu_read_unlock();
-}
-
-struct cgroup_subsys cpuacct_subsys = {
-	.name = "cpuacct",
-	.css_alloc = cpuacct_css_alloc,
-	.css_free = cpuacct_css_free,
-	.subsys_id = cpuacct_subsys_id,
-	.base_cftypes = files,
-};
-#endif	/* CONFIG_CGROUP_CPUACCT */
-
 void dump_cpu_task(int cpu)
 {
 	pr_info("Task dump for CPU %d:\n", cpu);
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
new file mode 100644
index 0000000..dbb7e2c
--- /dev/null
+++ b/kernel/sched/cpuacct.c
@@ -0,0 +1,296 @@
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/cpumask.h>
+#include <linux/seq_file.h>
+#include <linux/rcupdate.h>
+#include <linux/kernel_stat.h>
+#include <linux/err.h>
+
+#include "sched.h"
+
+/*
+ * CPU accounting code for task groups.
+ *
+ * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
+ * (balbir@in.ibm.com).
+ */
+
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+
+	CPUACCT_STAT_NSTATS,
+};
+
+/* track cpu usage of a group of tasks and its child groups */
+struct cpuacct {
+	struct cgroup_subsys_state css;
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 __percpu *cpuusage;
+	struct kernel_cpustat __percpu *cpustat;
+};
+
+/* return cpu accounting group corresponding to this container */
+static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+/* return cpu accounting group to which this task belongs */
+static inline struct cpuacct *task_ca(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+static inline struct cpuacct *__parent_ca(struct cpuacct *ca)
+{
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
+static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
+static struct cpuacct root_cpuacct = {
+	.cpustat	= &kernel_cpustat,
+	.cpuusage	= &root_cpuacct_cpuusage,
+};
+
+/* create a new cpu accounting group */
+static struct cgroup_subsys_state *cpuacct_css_alloc(struct cgroup *cgrp)
+{
+	struct cpuacct *ca;
+
+	if (!cgrp->parent)
+		return &root_cpuacct.css;
+
+	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	if (!ca)
+		goto out;
+
+	ca->cpuusage = alloc_percpu(u64);
+	if (!ca->cpuusage)
+		goto out_free_ca;
+
+	ca->cpustat = alloc_percpu(struct kernel_cpustat);
+	if (!ca->cpustat)
+		goto out_free_cpuusage;
+
+	return &ca->css;
+
+out_free_cpuusage:
+	free_percpu(ca->cpuusage);
+out_free_ca:
+	kfree(ca);
+out:
+	return ERR_PTR(-ENOMEM);
+}
+
+/* destroy an existing cpu accounting group */
+static void cpuacct_css_free(struct cgroup *cgrp)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+
+	free_percpu(ca->cpustat);
+	free_percpu(ca->cpuusage);
+	kfree(ca);
+}
+
+static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
+{
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 data;
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	data = *cpuusage;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	data = *cpuusage;
+#endif
+
+	return data;
+}
+
+static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+{
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	*cpuusage = val;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	*cpuusage = val;
+#endif
+}
+
+/* return total cpu usage (in nanoseconds) of a group */
+static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	u64 totalcpuusage = 0;
+	int i;
+
+	for_each_present_cpu(i)
+		totalcpuusage += cpuacct_cpuusage_read(ca, i);
+
+	return totalcpuusage;
+}
+
+static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
+								u64 reset)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int err = 0;
+	int i;
+
+	if (reset) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	for_each_present_cpu(i)
+		cpuacct_cpuusage_write(ca, i, 0);
+
+out:
+	return err;
+}
+
+static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgroup);
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpuacct_cpuusage_read(ca, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
+static const char * const cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_USER] = "user",
+	[CPUACCT_STAT_SYSTEM] = "system",
+};
+
+static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
+			      struct cgroup_map_cb *cb)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int cpu;
+	s64 val = 0;
+
+	for_each_online_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+		val += kcpustat->cpustat[CPUTIME_USER];
+		val += kcpustat->cpustat[CPUTIME_NICE];
+	}
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
+
+	val = 0;
+	for_each_online_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+		val += kcpustat->cpustat[CPUTIME_SYSTEM];
+		val += kcpustat->cpustat[CPUTIME_IRQ];
+		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
+	}
+
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
+
+	return 0;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "usage",
+		.read_u64 = cpuusage_read,
+		.write_u64 = cpuusage_write,
+	},
+	{
+		.name = "usage_percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+	},
+	{
+		.name = "stat",
+		.read_map = cpuacct_stats_show,
+	},
+	{ }	/* terminate */
+};
+
+/*
+ * charge this task's execution time to its accounting group.
+ *
+ * called with rq->lock held.
+ */
+void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+{
+	struct cpuacct *ca;
+	int cpu;
+
+	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
+
+	ca = task_ca(tsk);
+
+	while (true) {
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+		*cpuusage += cputime;
+
+		ca = parent_ca(ca);
+		if (!ca)
+			break;
+	}
+
+	rcu_read_unlock();
+}
+
+/*
+ * Add user/system time to cpuacct.
+ *
+ * Note: it's the caller that updates the account of the root cgroup.
+ */
+void cpuacct_account_field(struct task_struct *p, int index, u64 val)
+{
+	struct kernel_cpustat *kcpustat;
+	struct cpuacct *ca;
+
+	rcu_read_lock();
+	ca = task_ca(p);
+	while (ca != &root_cpuacct) {
+		kcpustat = this_cpu_ptr(ca->cpustat);
+		kcpustat->cpustat[index] += val;
+		ca = __parent_ca(ca);
+	}
+	rcu_read_unlock();
+}
+
+struct cgroup_subsys cpuacct_subsys = {
+	.name		= "cpuacct",
+	.css_alloc	= cpuacct_css_alloc,
+	.css_free	= cpuacct_css_free,
+	.subsys_id	= cpuacct_subsys_id,
+	.base_cftypes	= files,
+	.early_init	= 1,
+};
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
new file mode 100644
index 0000000..ed60562
--- /dev/null
+++ b/kernel/sched/cpuacct.h
@@ -0,0 +1,17 @@
+#ifdef CONFIG_CGROUP_CPUACCT
+
+extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+extern void cpuacct_account_field(struct task_struct *p, int index, u64 val);
+
+#else
+
+static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+{
+}
+
+static inline void
+cpuacct_account_field(struct task_struct *p, int index, u64 val)
+{
+}
+
+#endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..33508dc 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -115,10 +115,6 @@ static int irqtime_account_si_update(void)
 static inline void task_group_account_field(struct task_struct *p, int index,
 					    u64 tmp)
 {
-#ifdef CONFIG_CGROUP_CPUACCT
-	struct kernel_cpustat *kcpustat;
-	struct cpuacct *ca;
-#endif
 	/*
 	 * Since all updates are sure to touch the root cgroup, we
 	 * get ourselves ahead and touch it first. If the root cgroup
@@ -127,19 +123,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 */
 	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
 
-#ifdef CONFIG_CGROUP_CPUACCT
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
-	rcu_read_lock();
-	ca = task_ca(p);
-	while (ca && (ca != &root_cpuacct)) {
-		kcpustat = this_cpu_ptr(ca->cpustat);
-		kcpustat->cpustat[index] += tmp;
-		ca = parent_ca(ca);
-	}
-	rcu_read_unlock();
-#endif
+	cpuacct_account_field(p, index, tmp);
 }
 
 /*
@@ -388,82 +372,10 @@ static inline void irqtime_account_process_tick(struct task_struct *p, int user_
 						struct rq *rq) {}
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
-/*
- * Account a single tick of cpu time.
- * @p: the process that the cpu time gets accounted to
- * @user_tick: indicates if the tick is a user or a system tick
- */
-void account_process_tick(struct task_struct *p, int user_tick)
-{
-	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	struct rq *rq = this_rq();
-
-	if (vtime_accounting_enabled())
-		return;
-
-	if (sched_clock_irqtime) {
-		irqtime_account_process_tick(p, user_tick, rq);
-		return;
-	}
-
-	if (steal_account_process_tick())
-		return;
-
-	if (user_tick)
-		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
-	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
-		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
-				    one_jiffy_scaled);
-	else
-		account_idle_time(cputime_one_jiffy);
-}
-
-/*
- * Account multiple ticks of steal time.
- * @p: the process from which the cpu time has been stolen
- * @ticks: number of stolen ticks
- */
-void account_steal_ticks(unsigned long ticks)
-{
-	account_steal_time(jiffies_to_cputime(ticks));
-}
-
-/*
- * Account multiple ticks of idle time.
- * @ticks: number of stolen ticks
- */
-void account_idle_ticks(unsigned long ticks)
-{
-
-	if (sched_clock_irqtime) {
-		irqtime_account_idle_ticks(ticks);
-		return;
-	}
-
-	account_idle_time(jiffies_to_cputime(ticks));
-}
-#endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
-
 /*
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	*ut = p->utime;
-	*st = p->stime;
-}
-
-void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	struct task_cputime cputime;
-
-	thread_group_cputime(p, &cputime);
-
-	*ut = cputime.utime;
-	*st = cputime.stime;
-}
 
 #ifndef __ARCH_HAS_VTIME_TASK_SWITCH
 void vtime_task_switch(struct task_struct *prev)
@@ -518,21 +430,111 @@ void vtime_account_irq_enter(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
+void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	*ut = p->utime;
+	*st = p->stime;
+}
 
-#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
+void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct task_cputime cputime;
 
-static cputime_t scale_stime(cputime_t stime, cputime_t rtime, cputime_t total)
+	thread_group_cputime(p, &cputime);
+
+	*ut = cputime.utime;
+	*st = cputime.stime;
+}
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
+/*
+ * Account a single tick of cpu time.
+ * @p: the process that the cpu time gets accounted to
+ * @user_tick: indicates if the tick is a user or a system tick
+ */
+void account_process_tick(struct task_struct *p, int user_tick)
 {
-	u64 temp = (__force u64) rtime;
+	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	struct rq *rq = this_rq();
 
-	temp *= (__force u64) stime;
+	if (vtime_accounting_enabled())
+		return;
+
+	if (sched_clock_irqtime) {
+		irqtime_account_process_tick(p, user_tick, rq);
+		return;
+	}
+
+	if (steal_account_process_tick())
+		return;
 
-	if (sizeof(cputime_t) == 4)
-		temp = div_u64(temp, (__force u32) total);
+	if (user_tick)
+		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
+		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
+				    one_jiffy_scaled);
 	else
-		temp = div64_u64(temp, (__force u64) total);
+		account_idle_time(cputime_one_jiffy);
+}
 
-	return (__force cputime_t) temp;
+/*
+ * Account multiple ticks of steal time.
+ * @p: the process from which the cpu time has been stolen
+ * @ticks: number of stolen ticks
+ */
+void account_steal_ticks(unsigned long ticks)
+{
+	account_steal_time(jiffies_to_cputime(ticks));
+}
+
+/*
+ * Account multiple ticks of idle time.
+ * @ticks: number of stolen ticks
+ */
+void account_idle_ticks(unsigned long ticks)
+{
+
+	if (sched_clock_irqtime) {
+		irqtime_account_idle_ticks(ticks);
+		return;
+	}
+
+	account_idle_time(jiffies_to_cputime(ticks));
+}
+
+/*
+ * Perform (stime * rtime) / total with reduced chances
+ * of multiplication overflows by using smaller factors
+ * like quotient and remainders of divisions between
+ * rtime and total.
+ */
+static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
+{
+	u64 rem, res, scaled;
+
+	if (rtime >= total) {
+		/*
+		 * Scale up to rtime / total then add
+		 * the remainder scaled to stime / total.
+		 */
+		res = div64_u64_rem(rtime, total, &rem);
+		scaled = stime * res;
+		scaled += div64_u64(stime * rem, total);
+	} else {
+		/*
+		 * Same in reverse: scale down to total / rtime
+		 * then substract that result scaled to
+		 * to the remaining part.
+		 */
+		res = div64_u64_rem(total, rtime, &rem);
+		scaled = div64_u64(stime, res);
+		scaled -= div64_u64(scaled * rem, total);
+	}
+
+	return (__force cputime_t) scaled;
 }
 
 /*
@@ -545,6 +547,12 @@ static void cputime_adjust(struct task_cputime *curr,
 {
 	cputime_t rtime, stime, total;
 
+	if (vtime_accounting_enabled()) {
+		*ut = curr->utime;
+		*st = curr->stime;
+		return;
+	}
+
 	stime = curr->stime;
 	total = stime + curr->utime;
 
@@ -560,10 +568,14 @@ static void cputime_adjust(struct task_cputime *curr,
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
-	if (total)
-		stime = scale_stime(stime, rtime, total);
-	else
+	if (!rtime) {
+		stime = 0;
+	} else if (!total) {
 		stime = rtime;
+	} else {
+		stime = scale_stime((__force u64)stime,
+				    (__force u64)rtime, (__force u64)total);
+	}
 
 	/*
 	 * If the tick based count grows faster than the scheduler one,
@@ -597,7 +609,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 	thread_group_cputime(p, &cputime);
 	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
-#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
+#endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static unsigned long long vtime_delta(struct task_struct *tsk)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..8bf7081 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -431,13 +431,13 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
  * Scheduling class tree data structure manipulation methods:
  */
 
-static inline u64 max_vruntime(u64 min_vruntime, u64 vruntime)
+static inline u64 max_vruntime(u64 max_vruntime, u64 vruntime)
 {
-	s64 delta = (s64)(vruntime - min_vruntime);
+	s64 delta = (s64)(vruntime - max_vruntime);
 	if (delta > 0)
-		min_vruntime = vruntime;
+		max_vruntime = vruntime;
 
-	return min_vruntime;
+	return max_vruntime;
 }
 
 static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
@@ -473,6 +473,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
+	/* ensure we never gain time by being placed backwards. */
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
 #ifndef CONFIG_64BIT
 	smp_wmb();
@@ -652,7 +653,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 /*
- * We calculate the vruntime slice of a to be inserted task
+ * We calculate the vruntime slice of a to-be-inserted task.
  *
  * vs = s/w
  */
@@ -1562,6 +1563,27 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
+
+/*
+ * Update the rq's load with the elapsed running time before entering
+ * idle. if the last scheduled task is not a CFS task, idle_enter will
+ * be the only way to update the runnable statistic.
+ */
+void idle_enter_fair(struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 1);
+}
+
+/*
+ * Update the rq's load with the elapsed idle time before a task is
+ * scheduled. if the newly scheduled task is not a CFS task, idle_exit will
+ * be the only way to update the runnable statistic.
+ */
+void idle_exit_fair(struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 0);
+}
+
 #else
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
@@ -3874,12 +3896,16 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	int tsk_cache_hot = 0;
 	/*
 	 * We do not migrate tasks that are:
-	 * 1) running (obviously), or
+	 * 1) throttled_lb_pair, or
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
-	 * 3) are cache-hot on their current CPU.
+	 * 3) running (obviously), or
+	 * 4) are cache-hot on their current CPU.
 	 */
+	if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+		return 0;
+
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
-		int new_dst_cpu;
+		int cpu;
 
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 
@@ -3894,12 +3920,15 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		if (!env->dst_grpmask || (env->flags & LBF_SOME_PINNED))
 			return 0;
 
-		new_dst_cpu = cpumask_first_and(env->dst_grpmask,
-						tsk_cpus_allowed(p));
-		if (new_dst_cpu < nr_cpu_ids) {
-			env->flags |= LBF_SOME_PINNED;
-			env->new_dst_cpu = new_dst_cpu;
+		/* Prevent to re-select dst_cpu via env's cpus */
+		for_each_cpu_and(cpu, env->dst_grpmask, env->cpus) {
+			if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) {
+				env->flags |= LBF_SOME_PINNED;
+				env->new_dst_cpu = cpu;
+				break;
+			}
 		}
+
 		return 0;
 	}
 
@@ -3920,20 +3949,17 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
-#ifdef CONFIG_SCHEDSTATS
+
 		if (tsk_cache_hot) {
 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
-#endif
+
 		return 1;
 	}
 
-	if (tsk_cache_hot) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
-		return 0;
-	}
-	return 1;
+	schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
+	return 0;
 }
 
 /*
@@ -3948,9 +3974,6 @@ static int move_one_task(struct lb_env *env)
 	struct task_struct *p, *n;
 
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
-		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
-			continue;
-
 		if (!can_migrate_task(p, env))
 			continue;
 
@@ -4002,7 +4025,7 @@ static int move_tasks(struct lb_env *env)
 			break;
 		}
 
-		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+		if (!can_migrate_task(p, env))
 			goto next;
 
 		load = task_h_load(p);
@@ -4013,9 +4036,6 @@ static int move_tasks(struct lb_env *env)
 		if ((load / 2) > env->imbalance)
 			goto next;
 
-		if (!can_migrate_task(p, env))
-			goto next;
-
 		move_task(p, env);
 		pulled++;
 		env->imbalance -= load;
@@ -4245,7 +4265,7 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
-unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
 }
@@ -4255,7 +4275,7 @@ unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
 	return default_scale_freq_power(sd, cpu);
 }
 
-unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = sd->span_weight;
 	unsigned long smt_gain = sd->smt_gain;
@@ -4270,7 +4290,7 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 	return default_scale_smt_power(sd, cpu);
 }
 
-unsigned long scale_rt_power(int cpu)
+static unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available, age_stamp, avg;
@@ -4960,7 +4980,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
-DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DEFINE_PER_CPU(cpumask_var_t, load_balance_mask);
 
 static int need_active_balance(struct lb_env *env)
 {
@@ -4991,11 +5011,10 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			int *balance)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
-	int lb_iterations, max_lb_iterations;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
 
 	struct lb_env env = {
 		.sd		= sd,
@@ -5007,8 +5026,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.cpus		= cpus,
 	};
 
+	/*
+	 * For NEWLY_IDLE load_balancing, we don't need to consider
+	 * other cpus in our group
+	 */
+	if (idle == CPU_NEWLY_IDLE)
+		env.dst_grpmask = NULL;
+
 	cpumask_copy(cpus, cpu_active_mask);
-	max_lb_iterations = cpumask_weight(env.dst_grpmask);
 
 	schedstat_inc(sd, lb_count[idle]);
 
@@ -5034,7 +5059,6 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
-	lb_iterations = 1;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -5061,17 +5085,17 @@ more_balance:
 		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
-		if (env.flags & LBF_NEED_BREAK) {
-			env.flags &= ~LBF_NEED_BREAK;
-			goto more_balance;
-		}
-
 		/*
 		 * some other cpu did the load balance for us.
 		 */
 		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
 			resched_cpu(env.dst_cpu);
 
+		if (env.flags & LBF_NEED_BREAK) {
+			env.flags &= ~LBF_NEED_BREAK;
+			goto more_balance;
+		}
+
 		/*
 		 * Revisit (affine) tasks on src_cpu that couldn't be moved to
 		 * us and move them to an alternate dst_cpu in our sched_group
@@ -5091,14 +5115,17 @@ more_balance:
 		 * moreover subsequent load balance cycles should correct the
 		 * excess load moved.
 		 */
-		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0 &&
-				lb_iterations++ < max_lb_iterations) {
+		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
 
 			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
 			env.flags	&= ~LBF_SOME_PINNED;
 			env.loop	 = 0;
 			env.loop_break	 = sched_nr_migrate_break;
+
+			/* Prevent to re-select dst_cpu via env's cpus */
+			cpumask_clear_cpu(env.dst_cpu, env.cpus);
+
 			/*
 			 * Go back to "more_balance" rather than "redo" since we
 			 * need to continue with same src_cpu.
@@ -5219,8 +5246,6 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
-	update_rq_runnable_avg(this_rq, 1);
-
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
@@ -5395,13 +5420,16 @@ static inline void set_cpu_sd_state_busy(void)
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
 
-	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
-
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+
+	if (!sd || !sd->nohz_idle)
+		goto unlock;
+	sd->nohz_idle = 0;
+
+	for (; sd; sd = sd->parent)
 		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+unlock:
 	rcu_read_unlock();
 }
 
@@ -5410,13 +5438,16 @@ void set_cpu_sd_state_idle(void)
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
 
-	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	set_bit(NOHZ_IDLE, nohz_flags(cpu));
-
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+
+	if (!sd || sd->nohz_idle)
+		goto unlock;
+	sd->nohz_idle = 1;
+
+	for (; sd; sd = sd->parent)
 		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+unlock:
 	rcu_read_unlock();
 }
 
@@ -5468,7 +5499,7 @@ void update_max_interval(void)
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
  *
- * Balancing parameters are set up in arch_init_sched_domains.
+ * Balancing parameters are set up in init_sched_domains.
  */
 static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
@@ -5506,10 +5537,11 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
-				 * We've pulled tasks over so either we're no
-				 * longer idle.
+				 * The LBF_SOME_PINNED logic could have changed
+				 * env->dst_cpu, so we can't know our idle
+				 * state even if we migrated tasks. Update it.
 				 */
-				idle = CPU_NOT_IDLE;
+				idle = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
 		}
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b6baf37..b8ce773 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,6 +13,16 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
+
+static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
+{
+	idle_exit_fair(rq);
+}
+
+static void post_schedule_idle(struct rq *rq)
+{
+	idle_enter_fair(rq);
+}
 #endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
@@ -25,6 +35,10 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
+#ifdef CONFIG_SMP
+	/* Trigger the post schedule to do an idle_enter for CFS */
+	rq->post_schedule = 1;
+#endif
 	return rq->idle;
 }
 
@@ -86,6 +100,8 @@ const struct sched_class idle_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
+	.pre_schedule		= pre_schedule_idle,
+	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..4c225c4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -7,6 +7,7 @@
 #include <linux/stop_machine.h>
 
 #include "cpupri.h"
+#include "cpuacct.h"
 
 extern __read_mostly int scheduler_running;
 
@@ -33,6 +34,31 @@ extern __read_mostly int scheduler_running;
  */
 #define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
 
+/*
+ * Increase resolution of nice-level calculations for 64-bit architectures.
+ * The extra resolution improves shares distribution and load balancing of
+ * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
+ * hierarchies, especially on larger systems. This is not a user-visible change
+ * and does not change the user-interface for setting shares/weights.
+ *
+ * We increase resolution only if we have enough bits to allow this increased
+ * resolution (i.e. BITS_PER_LONG > 32). The costs for increasing resolution
+ * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
+ * increased costs.
+ */
+#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
+# define SCHED_LOAD_RESOLUTION	10
+# define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
+# define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
+#else
+# define SCHED_LOAD_RESOLUTION	0
+# define scale_load(w)		(w)
+# define scale_load_down(w)	(w)
+#endif
+
+#define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
+#define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
+
 #define NICE_0_LOAD		SCHED_LOAD_SCALE
 #define NICE_0_SHIFT		SCHED_LOAD_SHIFT
 
@@ -154,11 +180,6 @@ struct task_group {
 #define MAX_SHARES	(1UL << 18)
 #endif
 
-/* Default task group.
- *	Every task in system belong to this group at bootup.
- */
-extern struct task_group root_task_group;
-
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 extern int walk_tg_tree_from(struct task_group *from,
@@ -196,6 +217,18 @@ extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent);
 
+extern struct task_group *sched_create_group(struct task_group *parent);
+extern void sched_online_group(struct task_group *tg,
+			       struct task_group *parent);
+extern void sched_destroy_group(struct task_group *tg);
+extern void sched_offline_group(struct task_group *tg);
+
+extern void sched_move_task(struct task_struct *tsk);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
+#endif
+
 #else /* CONFIG_CGROUP_SCHED */
 
 struct cfs_bandwidth { };
@@ -547,6 +580,62 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_id);
 
+struct sched_group_power {
+	atomic_t ref;
+	/*
+	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
+	 * single CPU.
+	 */
+	unsigned int power, power_orig;
+	unsigned long next_update;
+	/*
+	 * Number of busy cpus in this group.
+	 */
+	atomic_t nr_busy_cpus;
+
+	unsigned long cpumask[0]; /* iteration mask */
+};
+
+struct sched_group {
+	struct sched_group *next;	/* Must be a circular list */
+	atomic_t ref;
+
+	unsigned int group_weight;
+	struct sched_group_power *sgp;
+
+	/*
+	 * The CPUs this group covers.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 */
+	unsigned long cpumask[0];
+};
+
+static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
+{
+	return to_cpumask(sg->cpumask);
+}
+
+/*
+ * cpumask masking which cpus in the group are allowed to iterate up the domain
+ * tree.
+ */
+static inline struct cpumask *sched_group_mask(struct sched_group *sg)
+{
+	return to_cpumask(sg->sgp->cpumask);
+}
+
+/**
+ * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
+ * @group: The group whose first cpu is to be returned.
+ */
+static inline unsigned int group_first_cpu(struct sched_group *group)
+{
+	return cpumask_first(sched_group_cpus(group));
+}
+
 extern int group_balance_cpu(struct sched_group *sg);
 
 #endif /* CONFIG_SMP */
@@ -784,6 +873,12 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 }
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
+/*
+ * wake flags
+ */
+#define WF_SYNC		0x01		/* waker goes to sleep after wakeup */
+#define WF_FORK		0x02		/* child wakeup after fork */
+#define WF_MIGRATED	0x4		/* internal use, task got migrated */
 
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
@@ -856,14 +951,61 @@ static const u32 prio_to_wmult[40] = {
  /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
 };
 
-/* Time spent by the tasks of the cpu accounting group executing in ... */
-enum cpuacct_stat_index {
-	CPUACCT_STAT_USER,	/* ... user mode */
-	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+#define ENQUEUE_WAKEUP		1
+#define ENQUEUE_HEAD		2
+#ifdef CONFIG_SMP
+#define ENQUEUE_WAKING		4	/* sched_class::task_waking was called */
+#else
+#define ENQUEUE_WAKING		0
+#endif
 
-	CPUACCT_STAT_NSTATS,
-};
+#define DEQUEUE_SLEEP		1
+
+struct sched_class {
+	const struct sched_class *next;
+
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
+	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
+	void (*yield_task) (struct rq *rq);
+	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
+
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
+
+	struct task_struct * (*pick_next_task) (struct rq *rq);
+	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
+
+#ifdef CONFIG_SMP
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
+
+	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
+	void (*post_schedule) (struct rq *this_rq);
+	void (*task_waking) (struct task_struct *task);
+	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
+
+	void (*set_cpus_allowed)(struct task_struct *p,
+				 const struct cpumask *newmask);
 
+	void (*rq_online)(struct rq *rq);
+	void (*rq_offline)(struct rq *rq);
+#endif
+
+	void (*set_curr_task) (struct rq *rq);
+	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
+	void (*task_fork) (struct task_struct *p);
+
+	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
+	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
+	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
+			     int oldprio);
+
+	unsigned int (*get_rr_interval) (struct rq *rq,
+					 struct task_struct *task);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	void (*task_move_group) (struct task_struct *p, int on_rq);
+#endif
+};
 
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
@@ -877,9 +1019,23 @@ extern const struct sched_class idle_sched_class;
 
 #ifdef CONFIG_SMP
 
+extern void update_group_power(struct sched_domain *sd, int cpu);
+
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
+/*
+ * Only depends on SMP, FAIR_GROUP_SCHED may be removed when runnable_avg
+ * becomes useful in lb
+ */
+#if defined(CONFIG_FAIR_GROUP_SCHED)
+extern void idle_enter_fair(struct rq *this_rq);
+extern void idle_exit_fair(struct rq *this_rq);
+#else
+static inline void idle_enter_fair(struct rq *this_rq) {}
+static inline void idle_exit_fair(struct rq *this_rq) {}
+#endif
+
 #else	/* CONFIG_SMP */
 
 static inline void idle_balance(int cpu, struct rq *rq)
@@ -891,7 +1047,6 @@ static inline void idle_balance(int cpu, struct rq *rq)
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
-extern void update_group_power(struct sched_domain *sd, int cpu);
 extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
@@ -904,45 +1059,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern void update_idle_cpu_load(struct rq *this_rq);
 
-#ifdef CONFIG_CGROUP_CPUACCT
-#include <linux/cgroup.h>
-/* track cpu usage of a group of tasks and its child groups */
-struct cpuacct {
-	struct cgroup_subsys_state css;
-	/* cpuusage holds pointer to a u64-type object on every cpu */
-	u64 __percpu *cpuusage;
-	struct kernel_cpustat __percpu *cpustat;
-};
-
-extern struct cgroup_subsys cpuacct_subsys;
-extern struct cpuacct root_cpuacct;
-
-/* return cpu accounting group corresponding to this container */
-static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
-{
-	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-/* return cpu accounting group to which this task belongs */
-static inline struct cpuacct *task_ca(struct task_struct *tsk)
-{
-	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-static inline struct cpuacct *parent_ca(struct cpuacct *ca)
-{
-	if (!ca || !ca->css.cgroup->parent)
-		return NULL;
-	return cgroup_ca(ca->css.cgroup->parent);
-}
-
-extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
-#else
-static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
-#endif
-
 #ifdef CONFIG_PARAVIRT
 static inline u64 steal_ticks(u64 steal)
 {
@@ -1187,7 +1303,6 @@ extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 enum rq_nohz_flag_bits {
 	NOHZ_TICK_STOPPED,
 	NOHZ_BALANCE_KICK,
-	NOHZ_IDLE,
 };
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
diff --git a/lib/div64.c b/lib/div64.c
index a163b6c..3af5728 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -79,9 +79,10 @@ EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /**
- * div64_u64 - unsigned 64bit divide with 64bit divisor
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor and 64bit remainder
  * @dividend:	64bit dividend
  * @divisor:	64bit divisor
+ * @remainder:  64bit remainder
  *
  * This implementation is a modified version of the algorithm proposed
  * by the book 'Hacker's Delight'.  The original source and full proof
@@ -89,27 +90,33 @@ EXPORT_SYMBOL(div_s64_rem);
  *
  * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c.txt'
  */
-#ifndef div64_u64
-u64 div64_u64(u64 dividend, u64 divisor)
+#ifndef div64_u64_rem
+u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
 {
 	u32 high = divisor >> 32;
 	u64 quot;
 
 	if (high == 0) {
-		quot = div_u64(dividend, divisor);
+		u32 rem32;
+		quot = div_u64_rem(dividend, divisor, &rem32);
+		*remainder = rem32;
 	} else {
 		int n = 1 + fls(high);
 		quot = div_u64(dividend >> n, divisor >> n);
 
 		if (quot != 0)
 			quot--;
-		if ((dividend - quot * divisor) >= divisor)
+
+		*remainder = dividend - quot * divisor;
+		if (*remainder >= divisor) {
 			quot++;
+			*remainder -= divisor;
+		}
 	}
 
 	return quot;
 }
-EXPORT_SYMBOL(div64_u64);
+EXPORT_SYMBOL(div64_u64_rem);
 #endif
 
 /**
