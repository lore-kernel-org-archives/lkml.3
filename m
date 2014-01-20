Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaATMyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:54:05 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54535 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaATMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:53:58 -0500
Date: Mon, 20 Jan 2014 13:53:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.14
Message-ID: <20140120125353.GA11427@gmail.com>
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

   # HEAD: eaad45132c564ce377e6dce05e78e08e456d5315 sched: Fix __sched_setscheduler() nice test

The main changes:

 - Add the initial implementation of SCHED_DEADLINE support: a
   real-time scheduling policy where tasks that meet their deadlines 
   and periodically execute their instances in less than their
   runtime quota see real-time scheduling and won't miss any of their 
   deadlines. Tasks that go over their quota get delayed.
   (Available to privileged users for now.)

 - Clean up and fix preempt_enable_no_resched() abuse all around the 
   tree.

 - Do sched_clock() performance optimizations on x86 and elsewhere.

 - Fix and improve auto-NUMA balancing.

 - Fix and clean up the idle loop.

 - Apply various cleanups and fixes.

 Thanks,

	Ingo

------------------>
Daniel Lezcano (8):
      sched: Reduce trigger_load_balance() parameters
      sched: Reduce nohz_kick_needed() parameters
      sched: Pass 'struct rq' to on_null_domain()
      sched: Remove unused parameter from find_new_ilb()
      sched: Remove unused parameter from nohz_balancer_kick()
      sched: Pass 'struct rq' to rebalance_domains()
      sched: Pass 'struct rq' to nohz_idle_balance()
      sched: Factor out the on_null_domain() checks in trigger_load_balance()

Dario Faggioli (7):
      sched: Add sched_class->task_dead() method
      sched: Add new scheduler syscalls to support an extended scheduling parameters ABI
      sched/deadline: Add SCHED_DEADLINE structures & implementation
      sched/deadline: Add SCHED_DEADLINE avg_update accounting
      sched/deadline: Add latency tracing for SCHED_DEADLINE tasks
      sched/deadline: Add SCHED_DEADLINE inheritance logic
      sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks

Fengguang Wu (1):
      sched/deadline: Fix sparse static warnings

H. Peter Anvin (2):
      x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers
      x86, idle: Add memory barriers around clflush in mwait_play_dead()

Harald Gustafsson (1):
      sched/deadline: Add period support for SCHED_DEADLINE tasks

Juri Lelli (4):
      sched/deadline: Add SCHED_DEADLINE SMP-related data structures & logic
      sched/deadline: speed up SCHED_DEADLINE pushes with a push-heap
      sched/deadline: No need to check p if dl_se is valid
      sched/core: Fix htmldocs warnings

Kamalesh Babulal (1):
      sched/fair: Clean up update_sg_lb_stats() a bit

Oleg Nesterov (3):
      tasks/fork: Remove unnecessary child->exit_state
      tasks/exit: Remove unused task_is_dead() method
      sched: Check TASK_DEAD rather than EXIT_DEAD in schedule_debug()

Peter Zijlstra (26):
      x86, acpi, idle: Restructure the mwait idle routines
      rtmutex: Turn the plist into an rb-tree
      sched/deadline: Fix up the smp-affinity mask tests
      sched/deadline: Remove the sysctl_sched_dl knobs
      sched/deadline: Fix hotplug admission control
      locking: Optimize lock_bh functions
      sched/preempt: Take away preempt_enable_no_resched() from modules
      sched/clock, x86: Use mul_u64_u32_shr() for native_sched_clock()
      sched/clock, x86: Move some cyc2ns() code around
      sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
      sched/clock: Remove local_irq_disable() from the clocks
      sched/clock, x86: Use a static_key for sched_clock_stable
      sched/clock: Fix up clear_sched_clock_stable()
      sched/clock, x86: Avoid a runtime condition in native_sched_clock()
      sched/preempt, locking: Rework local_bh_{dis,en}able()
      sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
      sched, net: Clean up preempt_enable_no_resched() abuse
      sched, net: Fixup busy_loop_us_clock()
      sched, thermal: Clean up preempt_enable_no_resched() abuse
      m68k: Fix build warning in mac_via.h
      sched/deadline: Remove unused variables
      sched: Preserve the nice level over sched_setscheduler() and sched_setparam() calls
      sched: Fix up scheduler syscall LTP fails
      sched: Fix up attr::sched_priority warning
      sched: Move SCHED_RESET_ON_FORK into attr::sched_flags
      sched: Fix __sched_setscheduler() nice test

Shigeru Yoshida (1):
      sched: Fix a trivial syntax misuse

Vincent Guittot (1):
      sched/fair: Move load idx selection in find_idlest_group

Wanpeng Li (5):
      sched/numa: Drop idx field of task_numa_env struct
      sched/numa: Drop sysctl_numa_balancing_settle_count sysctl
      sched/numa: Use wrapper function task_node to get node which task is on
      sched/numa: Use wrapper function task_faults_idx to calculate index in group_faults
      sched/numa: Fix period_slot recalculation


 Documentation/sysctl/kernel.txt    |    5 -
 arch/arm/include/asm/unistd.h      |    2 +-
 arch/arm/include/uapi/asm/unistd.h |    2 +
 arch/arm/kernel/calls.S            |    2 +
 arch/m68k/include/asm/mac_via.h    |    2 +
 arch/x86/include/asm/mwait.h       |   43 +
 arch/x86/include/asm/processor.h   |   23 -
 arch/x86/include/asm/timer.h       |   77 +-
 arch/x86/kernel/acpi/cstate.c      |   23 -
 arch/x86/kernel/cpu/amd.c          |    2 +-
 arch/x86/kernel/cpu/intel.c        |    2 +-
 arch/x86/kernel/cpu/perf_event.c   |   16 +-
 arch/x86/kernel/smpboot.c          |    2 +
 arch/x86/kernel/tsc.c              |  318 +++++--
 arch/x86/platform/uv/tlb_uv.c      |   66 +-
 arch/x86/syscalls/syscall_32.tbl   |    2 +
 arch/x86/syscalls/syscall_64.tbl   |    2 +
 drivers/acpi/acpi_pad.c            |    5 +-
 drivers/acpi/processor_idle.c      |   15 -
 drivers/idle/intel_idle.c          |   11 +-
 drivers/thermal/intel_powerclamp.c |    6 +-
 include/linux/bottom_half.h        |   32 +-
 include/linux/hardirq.h            |    1 +
 include/linux/init_task.h          |   10 +
 include/linux/preempt.h            |   37 +-
 include/linux/preempt_mask.h       |   16 +-
 include/linux/rtmutex.h            |   18 +-
 include/linux/rwlock_api_smp.h     |   12 +-
 include/linux/sched.h              |  141 +++-
 include/linux/sched/deadline.h     |   24 +
 include/linux/sched/rt.h           |    5 +
 include/linux/sched/sysctl.h       |    1 -
 include/linux/spinlock_api_smp.h   |   12 +-
 include/linux/spinlock_api_up.h    |   16 +-
 include/linux/syscalls.h           |    6 +
 include/linux/uaccess.h            |    5 +-
 include/net/busy_poll.h            |   19 +-
 include/uapi/linux/sched.h         |    6 +
 kernel/cpu/idle.c                  |   17 +-
 kernel/fork.c                      |   12 +-
 kernel/futex.c                     |    2 +
 kernel/hrtimer.c                   |    3 +-
 kernel/locking/rtmutex-debug.c     |    8 +-
 kernel/locking/rtmutex.c           |  166 +++-
 kernel/locking/rtmutex_common.h    |   23 +-
 kernel/sched/Makefile              |    5 +-
 kernel/sched/clock.c               |   78 +-
 kernel/sched/core.c                |  822 +++++++++++++++---
 kernel/sched/cpudeadline.c         |  216 +++++
 kernel/sched/cpudeadline.h         |   33 +
 kernel/sched/deadline.c            | 1640 ++++++++++++++++++++++++++++++++++++
 kernel/sched/debug.c               |    4 +-
 kernel/sched/fair.c                |   83 +-
 kernel/sched/rt.c                  |    2 +-
 kernel/sched/sched.h               |  146 +++-
 kernel/sched/stop_task.c           |    2 +-
 kernel/softirq.c                   |   39 +-
 kernel/sysctl.c                    |    7 -
 kernel/time/tick-sched.c           |    2 +-
 kernel/trace/ring_buffer.c         |    2 +-
 kernel/trace/trace_sched_wakeup.c  |   65 +-
 kernel/trace/trace_selftest.c      |   33 +-
 net/ipv4/tcp.c                     |    4 +-
 63 files changed, 3775 insertions(+), 626 deletions(-)
 create mode 100644 include/linux/sched/deadline.h
 create mode 100644 kernel/sched/cpudeadline.c
 create mode 100644 kernel/sched/cpudeadline.h
 create mode 100644 kernel/sched/deadline.c

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 26b7ee4..6d48640 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -428,11 +428,6 @@ rate for each task.
 numa_balancing_scan_size_mb is how many megabytes worth of pages are
 scanned for a given scan.
 
-numa_balancing_settle_count is how many scan periods must complete before
-the schedule balancer stops pushing the task towards a preferred node. This
-gives the scheduler a chance to place the task on an alternative node if the
-preferred node is overloaded.
-
 numa_balancing_migrate_deferred is how many page migrations get skipped
 unconditionally, after a page migration is skipped because a page is shared
 with other tasks. This reduces page migration overhead, and determines
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 141baa3..acabef1 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -15,7 +15,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define __NR_syscalls  (380)
+#define __NR_syscalls  (384)
 #define __ARM_NR_cmpxchg		(__ARM_NR_BASE+0x00fff0)
 
 #define __ARCH_WANT_STAT64
diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
index af33b44..fb5584d 100644
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -406,6 +406,8 @@
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
 #define __NR_kcmp			(__NR_SYSCALL_BASE+378)
 #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
+#define __NR_sched_setattr		(__NR_SYSCALL_BASE+380)
+#define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
 
 /*
  * This may need to be greater than __NR_last_syscall+1 in order to
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index c6ca7e3..166e945 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -389,6 +389,8 @@
 		CALL(sys_process_vm_writev)
 		CALL(sys_kcmp)
 		CALL(sys_finit_module)
+/* 380 */	CALL(sys_sched_setattr)
+		CALL(sys_sched_getattr)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/m68k/include/asm/mac_via.h b/arch/m68k/include/asm/mac_via.h
index aeeedf8..fe3fc9a 100644
--- a/arch/m68k/include/asm/mac_via.h
+++ b/arch/m68k/include/asm/mac_via.h
@@ -254,6 +254,8 @@
 extern volatile __u8 *via1,*via2;
 extern int rbv_present,via_alt_mapping;
 
+struct irq_desc;
+
 extern void via_register_interrupts(void);
 extern void via_irq_enable(int);
 extern void via_irq_disable(int);
diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 2f366d0..1da25a5 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_MWAIT_H
 #define _ASM_X86_MWAIT_H
 
+#include <linux/sched.h>
+
 #define MWAIT_SUBSTATE_MASK		0xf
 #define MWAIT_CSTATE_MASK		0xf
 #define MWAIT_SUBSTATE_SIZE		4
@@ -13,4 +15,45 @@
 
 #define MWAIT_ECX_INTERRUPT_BREAK	0x1
 
+static inline void __monitor(const void *eax, unsigned long ecx,
+			     unsigned long edx)
+{
+	/* "monitor %eax, %ecx, %edx;" */
+	asm volatile(".byte 0x0f, 0x01, 0xc8;"
+		     :: "a" (eax), "c" (ecx), "d"(edx));
+}
+
+static inline void __mwait(unsigned long eax, unsigned long ecx)
+{
+	/* "mwait %eax, %ecx;" */
+	asm volatile(".byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
+}
+
+/*
+ * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
+ * which can obviate IPI to trigger checking of need_resched.
+ * We execute MONITOR against need_resched and enter optimized wait state
+ * through MWAIT. Whenever someone changes need_resched, we would be woken
+ * up from MWAIT (without an IPI).
+ *
+ * New with Core Duo processors, MWAIT can take some hints based on CPU
+ * capability.
+ */
+static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
+{
+	if (!current_set_polling_and_test()) {
+		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+			mb();
+			clflush((void *)&current_thread_info()->flags);
+			mb();
+		}
+
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		if (!need_resched())
+			__mwait(eax, ecx);
+	}
+	current_clr_polling();
+}
+
 #endif /* _ASM_X86_MWAIT_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..24821f5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -700,29 +700,6 @@ static inline void sync_core(void)
 #endif
 }
 
-static inline void __monitor(const void *eax, unsigned long ecx,
-			     unsigned long edx)
-{
-	/* "monitor %eax, %ecx, %edx;" */
-	asm volatile(".byte 0x0f, 0x01, 0xc8;"
-		     :: "a" (eax), "c" (ecx), "d"(edx));
-}
-
-static inline void __mwait(unsigned long eax, unsigned long ecx)
-{
-	/* "mwait %eax, %ecx;" */
-	asm volatile(".byte 0x0f, 0x01, 0xc9;"
-		     :: "a" (eax), "c" (ecx));
-}
-
-static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
-{
-	trace_hardirqs_on();
-	/* "mwait %eax, %ecx;" */
-	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
-		     :: "a" (eax), "c" (ecx));
-}
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_amd_e400_c1e_mask(void);
 
diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 34baa0e..3de54ef 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -4,6 +4,7 @@
 #include <linux/pm.h>
 #include <linux/percpu.h>
 #include <linux/interrupt.h>
+#include <linux/math64.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
@@ -12,68 +13,26 @@ extern int recalibrate_cpu_khz(void);
 
 extern int no_timer_check;
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
+/*
+ * We use the full linear equation: f(x) = a + b*x, in order to allow
+ * a continuous function in the face of dynamic freq changes.
  *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
+ * Continuity means that when our frequency changes our slope (b); we want to
+ * ensure that: f(t) == f'(t), which gives: a + b*t == a' + b'*t.
  *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
+ * Without an offset (a) the above would not be possible.
  *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- *
- * In:
- *
- * ns = cycles * cyc2ns_scale / SC
- *
- * Although we may still have enough bits to store the value of ns,
- * in some cases, we may not have enough bits to store cycles * cyc2ns_scale,
- * leading to an incorrect result.
- *
- * To avoid this, we can decompose 'cycles' into quotient and remainder
- * of division by SC.  Then,
- *
- * ns = (quot * SC + rem) * cyc2ns_scale / SC
- *    = quot * cyc2ns_scale + (rem * cyc2ns_scale) / SC
- *
- *			- sqazi@google.com
+ * See the comment near cycles_2_ns() for details on how we compute (b).
  */
-
-DECLARE_PER_CPU(unsigned long, cyc2ns);
-DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
-
-static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
-{
-	int cpu = smp_processor_id();
-	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
-	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
-			(1UL << CYC2NS_SCALE_FACTOR));
-	return ns;
-}
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	unsigned long long ns;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	ns = __cycles_2_ns(cyc);
-	local_irq_restore(flags);
-
-	return ns;
-}
+struct cyc2ns_data {
+	u32 cyc2ns_mul;
+	u32 cyc2ns_shift;
+	u64 cyc2ns_offset;
+	u32 __count;
+	/* u32 hole */
+}; /* 24 bytes -- do not grow */
+
+extern struct cyc2ns_data *cyc2ns_read_begin(void);
+extern void cyc2ns_read_end(struct cyc2ns_data *);
 
 #endif /* _ASM_X86_TIMER_H */
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index d2b7f27..e69182f 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -150,29 +150,6 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-	if (!need_resched()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(ax, cx);
-	}
-}
-
 void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
 {
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bca023b..8bc79cd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -487,7 +487,7 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		if (!check_tsc_unstable())
-			sched_clock_stable = 1;
+			set_sched_clock_stable();
 	}
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ea04b34..1a439c0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -93,7 +93,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		if (!check_tsc_unstable())
-			sched_clock_stable = 1;
+			set_sched_clock_stable();
 	}
 
 	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8e13293..b886451 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1883,21 +1883,27 @@ static struct pmu pmu = {
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
+	struct cyc2ns_data *data;
+
 	userpg->cap_user_time = 0;
 	userpg->cap_user_time_zero = 0;
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
+	data = cyc2ns_read_begin();
+
 	userpg->cap_user_time = 1;
-	userpg->time_mult = this_cpu_read(cyc2ns);
-	userpg->time_shift = CYC2NS_SCALE_FACTOR;
-	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
+	userpg->time_mult = data->cyc2ns_mul;
+	userpg->time_shift = data->cyc2ns_shift;
+	userpg->time_offset = data->cyc2ns_offset - now;
 
 	userpg->cap_user_time_zero = 1;
-	userpg->time_zero = this_cpu_read(cyc2ns_offset);
+	userpg->time_zero = data->cyc2ns_offset;
+
+	cyc2ns_read_end(data);
 }
 
 /*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 85dc05a..f5252c4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1417,7 +1417,9 @@ static inline void mwait_play_dead(void)
 		 * The WBINVD is insufficient due to the spurious-wakeup
 		 * case where we return around the loop.
 		 */
+		mb();
 		clflush(mwait_ptr);
+		mb();
 		__monitor(mwait_ptr, 0, 0);
 		mb();
 		__mwait(eax, 0);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d4..6377fb2 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -11,6 +11,7 @@
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
 #include <linux/timex.h>
+#include <linux/static_key.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
@@ -37,13 +38,244 @@ static int __read_mostly tsc_unstable;
    erroneous rdtsc usage on !cpu_has_tsc processors */
 static int __read_mostly tsc_disabled = -1;
 
+static struct static_key __use_tsc = STATIC_KEY_INIT;
+
 int tsc_clocksource_reliable;
+
+/*
+ * Use a ring-buffer like data structure, where a writer advances the head by
+ * writing a new data entry and a reader advances the tail when it observes a
+ * new entry.
+ *
+ * Writers are made to wait on readers until there's space to write a new
+ * entry.
+ *
+ * This means that we can always use an {offset, mul} pair to compute a ns
+ * value that is 'roughly' in the right direction, even if we're writing a new
+ * {offset, mul} pair during the clock read.
+ *
+ * The down-side is that we can no longer guarantee strict monotonicity anymore
+ * (assuming the TSC was that to begin with), because while we compute the
+ * intersection point of the two clock slopes and make sure the time is
+ * continuous at the point of switching; we can no longer guarantee a reader is
+ * strictly before or after the switch point.
+ *
+ * It does mean a reader no longer needs to disable IRQs in order to avoid
+ * CPU-Freq updates messing with his times, and similarly an NMI reader will
+ * no longer run the risk of hitting half-written state.
+ */
+
+struct cyc2ns {
+	struct cyc2ns_data data[2];	/*  0 + 2*24 = 48 */
+	struct cyc2ns_data *head;	/* 48 + 8    = 56 */
+	struct cyc2ns_data *tail;	/* 56 + 8    = 64 */
+}; /* exactly fits one cacheline */
+
+static DEFINE_PER_CPU_ALIGNED(struct cyc2ns, cyc2ns);
+
+struct cyc2ns_data *cyc2ns_read_begin(void)
+{
+	struct cyc2ns_data *head;
+
+	preempt_disable();
+
+	head = this_cpu_read(cyc2ns.head);
+	/*
+	 * Ensure we observe the entry when we observe the pointer to it.
+	 * matches the wmb from cyc2ns_write_end().
+	 */
+	smp_read_barrier_depends();
+	head->__count++;
+	barrier();
+
+	return head;
+}
+
+void cyc2ns_read_end(struct cyc2ns_data *head)
+{
+	barrier();
+	/*
+	 * If we're the outer most nested read; update the tail pointer
+	 * when we're done. This notifies possible pending writers
+	 * that we've observed the head pointer and that the other
+	 * entry is now free.
+	 */
+	if (!--head->__count) {
+		/*
+		 * x86-TSO does not reorder writes with older reads;
+		 * therefore once this write becomes visible to another
+		 * cpu, we must be finished reading the cyc2ns_data.
+		 *
+		 * matches with cyc2ns_write_begin().
+		 */
+		this_cpu_write(cyc2ns.tail, head);
+	}
+	preempt_enable();
+}
+
+/*
+ * Begin writing a new @data entry for @cpu.
+ *
+ * Assumes some sort of write side lock; currently 'provided' by the assumption
+ * that cpufreq will call its notifiers sequentially.
+ */
+static struct cyc2ns_data *cyc2ns_write_begin(int cpu)
+{
+	struct cyc2ns *c2n = &per_cpu(cyc2ns, cpu);
+	struct cyc2ns_data *data = c2n->data;
+
+	if (data == c2n->head)
+		data++;
+
+	/* XXX send an IPI to @cpu in order to guarantee a read? */
+
+	/*
+	 * When we observe the tail write from cyc2ns_read_end(),
+	 * the cpu must be done with that entry and its safe
+	 * to start writing to it.
+	 */
+	while (c2n->tail == data)
+		cpu_relax();
+
+	return data;
+}
+
+static void cyc2ns_write_end(int cpu, struct cyc2ns_data *data)
+{
+	struct cyc2ns *c2n = &per_cpu(cyc2ns, cpu);
+
+	/*
+	 * Ensure the @data writes are visible before we publish the
+	 * entry. Matches the data-depencency in cyc2ns_read_begin().
+	 */
+	smp_wmb();
+
+	ACCESS_ONCE(c2n->head) = data;
+}
+
+/*
+ * Accelerators for sched_clock()
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *              ns = cycles / (freq / ns_per_sec)
+ *              ns = cycles * (ns_per_sec / freq)
+ *              ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *              ns = cycles * (10^6 / cpu_khz)
+ *
+ *      Then we use scaling math (suggested by george@mvista.com) to get:
+ *              ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *              ns = cycles * cyc2ns_scale / SC
+ *
+ *      And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better precision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+static void cyc2ns_data_init(struct cyc2ns_data *data)
+{
+	data->cyc2ns_mul = 1U << CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_offset = 0;
+	data->__count = 0;
+}
+
+static void cyc2ns_init(int cpu)
+{
+	struct cyc2ns *c2n = &per_cpu(cyc2ns, cpu);
+
+	cyc2ns_data_init(&c2n->data[0]);
+	cyc2ns_data_init(&c2n->data[1]);
+
+	c2n->head = c2n->data;
+	c2n->tail = c2n->data;
+}
+
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	struct cyc2ns_data *data, *tail;
+	unsigned long long ns;
+
+	/*
+	 * See cyc2ns_read_*() for details; replicated in order to avoid
+	 * an extra few instructions that came with the abstraction.
+	 * Notable, it allows us to only do the __count and tail update
+	 * dance when its actually needed.
+	 */
+
+	preempt_disable();
+	data = this_cpu_read(cyc2ns.head);
+	tail = this_cpu_read(cyc2ns.tail);
+
+	if (likely(data == tail)) {
+		ns = data->cyc2ns_offset;
+		ns += mul_u64_u32_shr(cyc, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+	} else {
+		data->__count++;
+
+		barrier();
+
+		ns = data->cyc2ns_offset;
+		ns += mul_u64_u32_shr(cyc, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+
+		barrier();
+
+		if (!--data->__count)
+			this_cpu_write(cyc2ns.tail, data);
+	}
+	preempt_enable();
+
+	return ns;
+}
+
+/* XXX surely we already have this someplace in the kernel?! */
+#define DIV_ROUND(n, d) (((n) + ((d) / 2)) / (d))
+
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
+{
+	unsigned long long tsc_now, ns_now;
+	struct cyc2ns_data *data;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	if (!cpu_khz)
+		goto done;
+
+	data = cyc2ns_write_begin(cpu);
+
+	rdtscll(tsc_now);
+	ns_now = cycles_2_ns(tsc_now);
+
+	/*
+	 * Compute a new multiplier as per the above comment and ensure our
+	 * time function is continuous; see the comment near struct
+	 * cyc2ns_data.
+	 */
+	data->cyc2ns_mul = DIV_ROUND(NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR, cpu_khz);
+	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_offset = ns_now -
+		mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+
+	cyc2ns_write_end(cpu, data);
+
+done:
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
+}
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
 u64 native_sched_clock(void)
 {
-	u64 this_offset;
+	u64 tsc_now;
 
 	/*
 	 * Fall back to jiffies if there's no TSC available:
@@ -53,16 +285,16 @@ u64 native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achieve it. )
 	 */
-	if (unlikely(tsc_disabled)) {
+	if (!static_key_false(&__use_tsc)) {
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 	}
 
 	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
+	rdtscll(tsc_now);
 
 	/* return the value in ns */
-	return __cycles_2_ns(this_offset);
+	return cycles_2_ns(tsc_now);
 }
 
 /* We need to define a real function for sched_clock, to override the
@@ -589,61 +821,11 @@ int recalibrate_cpu_khz(void)
 EXPORT_SYMBOL(recalibrate_cpu_khz);
 
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *              ns = cycles / (freq / ns_per_sec)
- *              ns = cycles * (ns_per_sec / freq)
- *              ns = cycles * (10^9 / (cpu_khz * 10^3))
- *              ns = cycles * (10^6 / cpu_khz)
- *
- *      Then we use scaling math (suggested by george@mvista.com) to get:
- *              ns = cycles * (10^6 * SC / cpu_khz) / SC
- *              ns = cycles * cyc2ns_scale / SC
- *
- *      And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-
-DEFINE_PER_CPU(unsigned long, cyc2ns);
-DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
-
-static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
-{
-	unsigned long long tsc_now, ns_now, *offset;
-	unsigned long flags, *scale;
-
-	local_irq_save(flags);
-	sched_clock_idle_sleep_event();
-
-	scale = &per_cpu(cyc2ns, cpu);
-	offset = &per_cpu(cyc2ns_offset, cpu);
-
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
-	if (cpu_khz) {
-		*scale = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) +
-				cpu_khz / 2) / cpu_khz;
-		*offset = ns_now - mult_frac(tsc_now, *scale,
-					     (1UL << CYC2NS_SCALE_FACTOR));
-	}
-
-	sched_clock_idle_wakeup_event(0);
-	local_irq_restore(flags);
-}
-
 static unsigned long long cyc2ns_suspend;
 
 void tsc_save_sched_clock_state(void)
 {
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	cyc2ns_suspend = sched_clock();
@@ -663,16 +845,26 @@ void tsc_restore_sched_clock_state(void)
 	unsigned long flags;
 	int cpu;
 
-	if (!sched_clock_stable)
+	if (!sched_clock_stable())
 		return;
 
 	local_irq_save(flags);
 
-	__this_cpu_write(cyc2ns_offset, 0);
+	/*
+	 * We're comming out of suspend, there's no concurrency yet; don't
+	 * bother being nice about the RCU stuff, just write to both
+	 * data fields.
+	 */
+
+	this_cpu_write(cyc2ns.data[0].cyc2ns_offset, 0);
+	this_cpu_write(cyc2ns.data[1].cyc2ns_offset, 0);
+
 	offset = cyc2ns_suspend - sched_clock();
 
-	for_each_possible_cpu(cpu)
-		per_cpu(cyc2ns_offset, cpu) = offset;
+	for_each_possible_cpu(cpu) {
+		per_cpu(cyc2ns.data[0].cyc2ns_offset, cpu) = offset;
+		per_cpu(cyc2ns.data[1].cyc2ns_offset, cpu) = offset;
+	}
 
 	local_irq_restore(flags);
 }
@@ -795,7 +987,7 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		sched_clock_stable = 0;
+		clear_sched_clock_stable();
 		disable_sched_clock_irqtime();
 		pr_info("Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
@@ -995,14 +1187,18 @@ void __init tsc_init(void)
 	 * speed as the bootup CPU. (cpufreq notifiers will fix this
 	 * up if their speed diverges)
 	 */
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		cyc2ns_init(cpu);
 		set_cyc2ns_scale(cpu_khz, cpu);
+	}
 
 	if (tsc_disabled > 0)
 		return;
 
 	/* now allow native_sched_clock() to use rdtsc */
+
 	tsc_disabled = 0;
+	static_key_slow_inc(&__use_tsc);
 
 	if (!no_sched_irq_time)
 		enable_sched_clock_irqtime();
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index efe4d72..dfe605a 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -433,15 +433,49 @@ static void reset_with_ipi(struct pnmask *distribution, struct bau_control *bcp)
 	return;
 }
 
-static inline unsigned long cycles_2_us(unsigned long long cyc)
+/*
+ * Not to be confused with cycles_2_ns() from tsc.c; this gives a relative
+ * number, not an absolute. It converts a duration in cycles to a duration in
+ * ns.
+ */
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
+	struct cyc2ns_data *data = cyc2ns_read_begin();
 	unsigned long long ns;
-	unsigned long us;
-	int cpu = smp_processor_id();
 
-	ns =  (cyc * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR;
-	us = ns / 1000;
-	return us;
+	ns = mul_u64_u32_shr(cyc, data->cyc2ns_mul, data->cyc2ns_shift);
+
+	cyc2ns_read_end(data);
+	return ns;
+}
+
+/*
+ * The reverse of the above; converts a duration in ns to a duration in cycles.
+ */ 
+static inline unsigned long long ns_2_cycles(unsigned long long ns)
+{
+	struct cyc2ns_data *data = cyc2ns_read_begin();
+	unsigned long long cyc;
+
+	cyc = (ns << data->cyc2ns_shift) / data->cyc2ns_mul;
+
+	cyc2ns_read_end(data);
+	return cyc;
+}
+
+static inline unsigned long cycles_2_us(unsigned long long cyc)
+{
+	return cycles_2_ns(cyc) / NSEC_PER_USEC;
+}
+
+static inline cycles_t sec_2_cycles(unsigned long sec)
+{
+	return ns_2_cycles(sec * NSEC_PER_SEC);
+}
+
+static inline unsigned long long usec_2_cycles(unsigned long usec)
+{
+	return ns_2_cycles(usec * NSEC_PER_USEC);
 }
 
 /*
@@ -668,16 +702,6 @@ static int wait_completion(struct bau_desc *bau_desc,
 								bcp, try);
 }
 
-static inline cycles_t sec_2_cycles(unsigned long sec)
-{
-	unsigned long ns;
-	cycles_t cyc;
-
-	ns = sec * 1000000000;
-	cyc = (ns << CYC2NS_SCALE_FACTOR)/(per_cpu(cyc2ns, smp_processor_id()));
-	return cyc;
-}
-
 /*
  * Our retries are blocked by all destination sw ack resources being
  * in use, and a timeout is pending. In that case hardware immediately
@@ -1327,16 +1351,6 @@ static void ptc_seq_stop(struct seq_file *file, void *data)
 {
 }
 
-static inline unsigned long long usec_2_cycles(unsigned long microsec)
-{
-	unsigned long ns;
-	unsigned long long cyc;
-
-	ns = microsec * 1000;
-	cyc = (ns << CYC2NS_SCALE_FACTOR)/(per_cpu(cyc2ns, smp_processor_id()));
-	return cyc;
-}
-
 /*
  * Display the statistics thru /proc/sgi_uv/ptc_statistics
  * 'data' points to the cpu number
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index aabfb83..96bc506 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -357,3 +357,5 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
+351	i386	sched_setattr		sys_sched_setattr
+352	i386	sched_getattr		sys_sched_getattr
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65d..a12bddc 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,8 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	sched_setattr		sys_sched_setattr
+315	common	sched_getattr		sys_sched_getattr
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index fc6008f..509452a 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -193,10 +193,7 @@ static int power_saving_thread(void *data)
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 			stop_critical_timings();
 
-			__monitor((void *)&current_thread_info()->flags, 0, 0);
-			smp_mb();
-			if (!need_resched())
-				__mwait(power_saving_mwait_eax, 1);
+			mwait_idle_with_hints(power_saving_mwait_eax, 1);
 
 			start_critical_timings();
 			if (lapic_marked_unstable)
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 644516d..f90c56c 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -727,11 +727,6 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	lapic_timer_state_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 
@@ -785,11 +780,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	/*
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
@@ -841,11 +831,6 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		}
 	}
 
-	if (cx->entry_method == ACPI_CSTATE_FFH) {
-		if (current_set_polling_and_test())
-			return -EINVAL;
-	}
-
 	acpi_unlazy_tlb(smp_processor_id());
 
 	/* Tell the scheduler that we are going deep-idle: */
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 797ed29..6c0e045 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -377,16 +377,7 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
-	if (!current_set_polling_and_test()) {
-
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(eax, ecx);
-	}
+	mwait_idle_with_hints(eax, ecx);
 
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 8f181b3..d833c8f 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -438,14 +438,12 @@ static int clamp_thread(void *arg)
 			 */
 			local_touch_nmi();
 			stop_critical_timings();
-			__monitor((void *)&current_thread_info()->flags, 0, 0);
-			cpu_relax(); /* allow HT sibling to run */
-			__mwait(eax, ecx);
+			mwait_idle_with_hints(eax, ecx);
 			start_critical_timings();
 			atomic_inc(&idle_wakeup_counter);
 		}
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
+		preempt_enable();
 	}
 	del_timer_sync(&wakeup_timer);
 	clear_bit(cpunr, cpu_clamping_mask);
diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
index 27b1bcf..86c12c9 100644
--- a/include/linux/bottom_half.h
+++ b/include/linux/bottom_half.h
@@ -1,9 +1,35 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
-extern void local_bh_disable(void);
+#include <linux/preempt.h>
+#include <linux/preempt_mask.h>
+
+#ifdef CONFIG_TRACE_IRQFLAGS
+extern void __local_bh_disable_ip(unsigned long ip, unsigned int cnt);
+#else
+static __always_inline void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
+{
+	preempt_count_add(cnt);
+	barrier();
+}
+#endif
+
+static inline void local_bh_disable(void)
+{
+	__local_bh_disable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
+}
+
 extern void _local_bh_enable(void);
-extern void local_bh_enable(void);
-extern void local_bh_enable_ip(unsigned long ip);
+extern void __local_bh_enable_ip(unsigned long ip, unsigned int cnt);
+
+static inline void local_bh_enable_ip(unsigned long ip)
+{
+	__local_bh_enable_ip(ip, SOFTIRQ_DISABLE_OFFSET);
+}
+
+static inline void local_bh_enable(void)
+{
+	__local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
+}
 
 #endif /* _LINUX_BH_H */
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d9cf963..12d5f97 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
 #include <linux/vtime.h>
+#include <asm/hardirq.h>
 
 
 extern void synchronize_irq(unsigned int irq);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index b0ed422..f0e5238 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -11,6 +11,7 @@
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
 #include <linux/seqlock.h>
+#include <linux/rbtree.h>
 #include <net/net_namespace.h>
 #include <linux/sched/rt.h>
 
@@ -154,6 +155,14 @@ extern struct task_group root_task_group;
 
 #define INIT_TASK_COMM "swapper"
 
+#ifdef CONFIG_RT_MUTEXES
+# define INIT_RT_MUTEXES(tsk)						\
+	.pi_waiters = RB_ROOT,						\
+	.pi_waiters_leftmost = NULL,
+#else
+# define INIT_RT_MUTEXES(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -221,6 +230,7 @@ extern struct task_group root_task_group;
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ(tsk)						\
+	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
 }
 
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index a3d9dc8..59749fc 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -64,7 +64,11 @@ do { \
 } while (0)
 
 #else
-#define preempt_enable() preempt_enable_no_resched()
+#define preempt_enable() \
+do { \
+	barrier(); \
+	preempt_count_dec(); \
+} while (0)
 #define preempt_check_resched() do { } while (0)
 #endif
 
@@ -93,7 +97,11 @@ do { \
 		__preempt_schedule_context(); \
 } while (0)
 #else
-#define preempt_enable_notrace() preempt_enable_no_resched_notrace()
+#define preempt_enable_notrace() \
+do { \
+	barrier(); \
+	__preempt_count_dec(); \
+} while (0)
 #endif
 
 #else /* !CONFIG_PREEMPT_COUNT */
@@ -116,6 +124,31 @@ do { \
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
+#ifdef MODULE
+/*
+ * Modules have no business playing preemption tricks.
+ */
+#undef sched_preempt_enable_no_resched
+#undef preempt_enable_no_resched
+#undef preempt_enable_no_resched_notrace
+#undef preempt_check_resched
+#endif
+
+#ifdef CONFIG_PREEMPT
+#define preempt_set_need_resched() \
+do { \
+	set_preempt_need_resched(); \
+} while (0)
+#define preempt_fold_need_resched() \
+do { \
+	if (tif_need_resched()) \
+		set_preempt_need_resched(); \
+} while (0)
+#else
+#define preempt_set_need_resched() do { } while (0)
+#define preempt_fold_need_resched() do { } while (0)
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 struct preempt_notifier;
diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index d169820..dbeec4d 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -2,7 +2,6 @@
 #define LINUX_PREEMPT_MASK_H
 
 #include <linux/preempt.h>
-#include <asm/hardirq.h>
 
 /*
  * We put the hardirq and softirq counter into the preemption
@@ -79,6 +78,21 @@
 #endif
 
 /*
+ * The preempt_count offset needed for things like:
+ *
+ *  spin_lock_bh()
+ *
+ * Which need to disable both preemption (CONFIG_PREEMPT_COUNT) and
+ * softirqs, such that unlock sequences of:
+ *
+ *  spin_unlock();
+ *  local_bh_enable();
+ *
+ * Work as expected.
+ */
+#define SOFTIRQ_LOCK_OFFSET (SOFTIRQ_DISABLE_OFFSET + PREEMPT_CHECK_OFFSET)
+
+/*
  * Are we running in atomic context?  WARNING: this macro cannot
  * always detect atomic context; in particular, it cannot know about
  * held spinlocks in non-preemptible kernels.  Thus it should not be
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index de17134..3aed8d7 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -13,7 +13,7 @@
 #define __LINUX_RT_MUTEX_H
 
 #include <linux/linkage.h>
-#include <linux/plist.h>
+#include <linux/rbtree.h>
 #include <linux/spinlock_types.h>
 
 extern int max_lock_depth; /* for sysctl */
@@ -22,12 +22,14 @@ extern int max_lock_depth; /* for sysctl */
  * The rt_mutex structure
  *
  * @wait_lock:	spinlock to protect the structure
- * @wait_list:	pilist head to enqueue waiters in priority order
+ * @waiters:	rbtree root to enqueue waiters in priority order
+ * @waiters_leftmost: top waiter
  * @owner:	the mutex owner
  */
 struct rt_mutex {
 	raw_spinlock_t		wait_lock;
-	struct plist_head	wait_list;
+	struct rb_root          waiters;
+	struct rb_node          *waiters_leftmost;
 	struct task_struct	*owner;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	int			save_state;
@@ -66,7 +68,7 @@ struct hrtimer_sleeper;
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
 	{ .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
-	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \
+	, .waiters = RB_ROOT \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)}
 
@@ -98,12 +100,4 @@ extern int rt_mutex_trylock(struct rt_mutex *lock);
 
 extern void rt_mutex_unlock(struct rt_mutex *lock);
 
-#ifdef CONFIG_RT_MUTEXES
-# define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters),	\
-	INIT_RT_MUTEX_DEBUG(tsk)
-#else
-# define INIT_RT_MUTEXES(tsk)
-#endif
-
 #endif
diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 9c9f049..5b9b84b 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -172,8 +172,7 @@ static inline void __raw_read_lock_irq(rwlock_t *lock)
 
 static inline void __raw_read_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
@@ -200,8 +199,7 @@ static inline void __raw_write_lock_irq(rwlock_t *lock)
 
 static inline void __raw_write_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
@@ -250,8 +248,7 @@ static inline void __raw_read_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
@@ -275,8 +272,7 @@ static inline void __raw_write_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 #endif /* __LINUX_RWLOCK_API_SMP_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53f97eb..ffccdad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -16,6 +16,7 @@ struct sched_param {
 #include <linux/types.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
+#include <linux/plist.h>
 #include <linux/rbtree.h>
 #include <linux/thread_info.h>
 #include <linux/cpumask.h>
@@ -56,6 +57,70 @@ struct sched_param {
 
 #include <asm/processor.h>
 
+#define SCHED_ATTR_SIZE_VER0	48	/* sizeof first published struct */
+
+/*
+ * Extended scheduling parameters data structure.
+ *
+ * This is needed because the original struct sched_param can not be
+ * altered without introducing ABI issues with legacy applications
+ * (e.g., in sched_getparam()).
+ *
+ * However, the possibility of specifying more than just a priority for
+ * the tasks may be useful for a wide variety of application fields, e.g.,
+ * multimedia, streaming, automation and control, and many others.
+ *
+ * This variant (sched_attr) is meant at describing a so-called
+ * sporadic time-constrained task. In such model a task is specified by:
+ *  - the activation period or minimum instance inter-arrival time;
+ *  - the maximum (or average, depending on the actual scheduling
+ *    discipline) computation time of all instances, a.k.a. runtime;
+ *  - the deadline (relative to the actual activation time) of each
+ *    instance.
+ * Very briefly, a periodic (sporadic) task asks for the execution of
+ * some specific computation --which is typically called an instance--
+ * (at most) every period. Moreover, each instance typically lasts no more
+ * than the runtime and must be completed by time instant t equal to
+ * the instance activation time + the deadline.
+ *
+ * This is reflected by the actual fields of the sched_attr structure:
+ *
+ *  @size		size of the structure, for fwd/bwd compat.
+ *
+ *  @sched_policy	task's scheduling policy
+ *  @sched_flags	for customizing the scheduler behaviour
+ *  @sched_nice		task's nice value      (SCHED_NORMAL/BATCH)
+ *  @sched_priority	task's static priority (SCHED_FIFO/RR)
+ *  @sched_deadline	representative of the task's deadline
+ *  @sched_runtime	representative of the task's runtime
+ *  @sched_period	representative of the task's period
+ *
+ * Given this task model, there are a multiplicity of scheduling algorithms
+ * and policies, that can be used to ensure all the tasks will make their
+ * timing constraints.
+ *
+ * As of now, the SCHED_DEADLINE policy (sched_dl scheduling class) is the
+ * only user of this new interface. More information about the algorithm
+ * available in the scheduling class file or in Documentation/.
+ */
+struct sched_attr {
+	u32 size;
+
+	u32 sched_policy;
+	u64 sched_flags;
+
+	/* SCHED_NORMAL, SCHED_BATCH */
+	s32 sched_nice;
+
+	/* SCHED_FIFO, SCHED_RR */
+	u32 sched_priority;
+
+	/* SCHED_DEADLINE */
+	u64 sched_runtime;
+	u64 sched_deadline;
+	u64 sched_period;
+};
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -168,7 +233,6 @@ extern char ___assert_task_state[1 - 2*!!(
 
 #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
-#define task_is_dead(task)	((task)->exit_state != 0)
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
@@ -1029,6 +1093,51 @@ struct sched_rt_entity {
 #endif
 };
 
+struct sched_dl_entity {
+	struct rb_node	rb_node;
+
+	/*
+	 * Original scheduling parameters. Copied here from sched_attr
+	 * during sched_setscheduler2(), they will remain the same until
+	 * the next sched_setscheduler2().
+	 */
+	u64 dl_runtime;		/* maximum runtime for each instance	*/
+	u64 dl_deadline;	/* relative deadline of each instance	*/
+	u64 dl_period;		/* separation of two instances (period) */
+	u64 dl_bw;		/* dl_runtime / dl_deadline		*/
+
+	/*
+	 * Actual scheduling parameters. Initialized with the values above,
+	 * they are continously updated during task execution. Note that
+	 * the remaining runtime could be < 0 in case we are in overrun.
+	 */
+	s64 runtime;		/* remaining runtime for this instance	*/
+	u64 deadline;		/* absolute deadline for this instance	*/
+	unsigned int flags;	/* specifying the scheduler behaviour	*/
+
+	/*
+	 * Some bool flags:
+	 *
+	 * @dl_throttled tells if we exhausted the runtime. If so, the
+	 * task has to wait for a replenishment to be performed at the
+	 * next firing of dl_timer.
+	 *
+	 * @dl_new tells if a new instance arrived. If so we must
+	 * start executing it with full runtime and reset its absolute
+	 * deadline;
+	 *
+	 * @dl_boosted tells if we are boosted due to DI. If so we are
+	 * outside bandwidth enforcement mechanism (but only until we
+	 * exit the critical section).
+	 */
+	int dl_throttled, dl_new, dl_boosted;
+
+	/*
+	 * Bandwidth enforcement timer. Each -deadline task has its
+	 * own bandwidth to be enforced, thus we need one timer per task.
+	 */
+	struct hrtimer dl_timer;
+};
 
 struct rcu_node;
 
@@ -1065,6 +1174,7 @@ struct task_struct {
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group *sched_task_group;
 #endif
+	struct sched_dl_entity dl;
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -1098,6 +1208,7 @@ struct task_struct {
 	struct list_head tasks;
 #ifdef CONFIG_SMP
 	struct plist_node pushable_tasks;
+	struct rb_node pushable_dl_tasks;
 #endif
 
 	struct mm_struct *mm, *active_mm;
@@ -1249,9 +1360,12 @@ struct task_struct {
 
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
-	struct plist_head pi_waiters;
+	struct rb_root pi_waiters;
+	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
+	/* Top pi_waiters task */
+	struct task_struct *pi_top_task;
 #endif
 
 #ifdef CONFIG_DEBUG_MUTEXES
@@ -1880,7 +1994,9 @@ static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
  * but then during bootup it turns out that sched_clock()
  * is reliable after all:
  */
-extern int sched_clock_stable;
+extern int sched_clock_stable(void);
+extern void set_sched_clock_stable(void);
+extern void clear_sched_clock_stable(void);
 
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
@@ -1959,6 +2075,8 @@ extern int sched_setscheduler(struct task_struct *, int,
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern int sched_setattr(struct task_struct *,
+			 const struct sched_attr *);
 extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
@@ -2038,7 +2156,7 @@ extern void wake_up_new_task(struct task_struct *tsk);
 #else
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
-extern void sched_fork(unsigned long clone_flags, struct task_struct *p);
+extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
@@ -2627,6 +2745,21 @@ static inline bool __must_check current_clr_polling_and_test(void)
 }
 #endif
 
+static inline void current_clr_polling(void)
+{
+	__current_clr_polling();
+
+	/*
+	 * Ensure we check TIF_NEED_RESCHED after we clear the polling bit.
+	 * Once the bit is cleared, we'll get IPIs with every new
+	 * TIF_NEED_RESCHED and the IPI handler, scheduler_ipi(), will also
+	 * fold.
+	 */
+	smp_mb(); /* paired with resched_task() */
+
+	preempt_fold_need_resched();
+}
+
 static __always_inline bool need_resched(void)
 {
 	return unlikely(tif_need_resched());
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
new file mode 100644
index 0000000..9d303b8
--- /dev/null
+++ b/include/linux/sched/deadline.h
@@ -0,0 +1,24 @@
+#ifndef _SCHED_DEADLINE_H
+#define _SCHED_DEADLINE_H
+
+/*
+ * SCHED_DEADLINE tasks has negative priorities, reflecting
+ * the fact that any of them has higher prio than RT and
+ * NORMAL/BATCH tasks.
+ */
+
+#define MAX_DL_PRIO		0
+
+static inline int dl_prio(int prio)
+{
+	if (unlikely(prio < MAX_DL_PRIO))
+		return 1;
+	return 0;
+}
+
+static inline int dl_task(struct task_struct *p)
+{
+	return dl_prio(p->prio);
+}
+
+#endif /* _SCHED_DEADLINE_H */
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 440434d..34e4ebe 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -35,6 +35,7 @@ static inline int rt_task(struct task_struct *p)
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern struct task_struct *rt_mutex_get_top_task(struct task_struct *task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
@@ -45,6 +46,10 @@ static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
+static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
+{
+	return NULL;
+}
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 41467f8..31e0193 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -48,7 +48,6 @@ extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_settle_count;
 
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index bdb9993..42dfab8 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -131,8 +131,7 @@ static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
 
 static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
@@ -174,20 +173,17 @@ static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 }
 
 static inline int __raw_spin_trylock_bh(raw_spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	if (do_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	return 0;
 }
 
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index af1f472..d0d1888 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -24,11 +24,14 @@
  * flags straight, to suppress compiler warnings of unused lock
  * variables, and to add the proper checker annotations:
  */
+#define ___LOCK(lock) \
+  do { __acquire(lock); (void)(lock); } while (0)
+
 #define __LOCK(lock) \
-  do { preempt_disable(); __acquire(lock); (void)(lock); } while (0)
+  do { preempt_disable(); ___LOCK(lock); } while (0)
 
 #define __LOCK_BH(lock) \
-  do { local_bh_disable(); __LOCK(lock); } while (0)
+  do { __local_bh_disable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); ___LOCK(lock); } while (0)
 
 #define __LOCK_IRQ(lock) \
   do { local_irq_disable(); __LOCK(lock); } while (0)
@@ -36,12 +39,15 @@
 #define __LOCK_IRQSAVE(lock, flags) \
   do { local_irq_save(flags); __LOCK(lock); } while (0)
 
+#define ___UNLOCK(lock) \
+  do { __release(lock); (void)(lock); } while (0)
+
 #define __UNLOCK(lock) \
-  do { preempt_enable(); __release(lock); (void)(lock); } while (0)
+  do { preempt_enable(); ___UNLOCK(lock); } while (0)
 
 #define __UNLOCK_BH(lock) \
-  do { preempt_enable_no_resched(); local_bh_enable(); \
-	  __release(lock); (void)(lock); } while (0)
+  do { __local_bh_enable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); \
+       ___UNLOCK(lock); } while (0)
 
 #define __UNLOCK_IRQ(lock) \
   do { local_irq_enable(); __UNLOCK(lock); } while (0)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 94273bb..40ed9e9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -38,6 +38,7 @@ struct rlimit;
 struct rlimit64;
 struct rusage;
 struct sched_param;
+struct sched_attr;
 struct sel_arg_struct;
 struct semaphore;
 struct sembuf;
@@ -279,9 +280,14 @@ asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setattr(pid_t pid,
+					struct sched_attr __user *attr);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_getattr(pid_t pid,
+					struct sched_attr __user *attr,
+					unsigned int size);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 9d8cf05..ecd3319 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -25,13 +25,16 @@ static inline void pagefault_disable(void)
 
 static inline void pagefault_enable(void)
 {
+#ifndef CONFIG_PREEMPT
 	/*
 	 * make sure to issue those last loads/stores before enabling
 	 * the pagefault handler again.
 	 */
 	barrier();
 	preempt_count_dec();
-	preempt_check_resched();
+#else
+	preempt_enable();
+#endif
 }
 
 #ifndef ARCH_HAS_NOCACHE_UACCESS
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 829627d..1d67fb6 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -42,27 +42,10 @@ static inline bool net_busy_loop_on(void)
 	return sysctl_net_busy_poll;
 }
 
-/* a wrapper to make debug_smp_processor_id() happy
- * we can use sched_clock() because we don't care much about precision
- * we only care that the average is bounded
- */
-#ifdef CONFIG_DEBUG_PREEMPT
-static inline u64 busy_loop_us_clock(void)
-{
-	u64 rc;
-
-	preempt_disable_notrace();
-	rc = sched_clock();
-	preempt_enable_no_resched_notrace();
-
-	return rc >> 10;
-}
-#else /* CONFIG_DEBUG_PREEMPT */
 static inline u64 busy_loop_us_clock(void)
 {
-	return sched_clock() >> 10;
+	return local_clock() >> 10;
 }
-#endif /* CONFIG_DEBUG_PREEMPT */
 
 static inline unsigned long sk_busy_loop_end_time(struct sock *sk)
 {
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 5a0f945..34f9d73 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -39,8 +39,14 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+#define SCHED_DEADLINE		6
+
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
 
+/*
+ * For the sched_{set,get}attr() calls
+ */
+#define SCHED_FLAG_RESET_ON_FORK	0x01
 
 #endif /* _UAPI_LINUX_SCHED_H */
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 988573a..277f494 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -105,14 +105,17 @@ static void cpu_idle_loop(void)
 				__current_set_polling();
 			}
 			arch_cpu_idle_exit();
-			/*
-			 * We need to test and propagate the TIF_NEED_RESCHED
-			 * bit here because we might not have send the
-			 * reschedule IPI to idle tasks.
-			 */
-			if (tif_need_resched())
-				set_preempt_need_resched();
 		}
+
+		/*
+		 * Since we fell out of the loop above, we know
+		 * TIF_NEED_RESCHED must be set, propagate it into
+		 * PREEMPT_NEED_RESCHED.
+		 *
+		 * This is required because for polling idle loops we will
+		 * not have had an IPI to fold the state for us.
+		 */
+		preempt_set_need_resched();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
 	}
diff --git a/kernel/fork.c b/kernel/fork.c
index 5721f0e..01b450a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1087,8 +1087,10 @@ static void rt_mutex_init_task(struct task_struct *p)
 {
 	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init(&p->pi_waiters);
+	p->pi_waiters = RB_ROOT;
+	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
+	p->pi_top_task = NULL;
 #endif
 }
 
@@ -1311,7 +1313,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(clone_flags, p);
+	retval = sched_fork(clone_flags, p);
+	if (retval)
+		goto bad_fork_cleanup_policy;
 
 	retval = perf_event_init_task(p);
 	if (retval)
@@ -1403,13 +1407,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->tgid = p->pid;
 	}
 
-	p->pdeath_signal = 0;
-	p->exit_state = 0;
-
 	p->nr_dirtied = 0;
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
 
+	p->pdeath_signal = 0;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
diff --git a/kernel/futex.c b/kernel/futex.c
index f6ff019..679531c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2316,6 +2316,8 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * code while we sleep on uaddr.
 	 */
 	debug_rt_mutex_init_waiter(&rt_waiter);
+	RB_CLEAR_NODE(&rt_waiter.pi_tree_entry);
+	RB_CLEAR_NODE(&rt_waiter.tree_entry);
 	rt_waiter.task = NULL;
 
 	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 383319b..0909436 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -46,6 +46,7 @@
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/deadline.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
 
@@ -1610,7 +1611,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	unsigned long slack;
 
 	slack = current->timer_slack_ns;
-	if (rt_task(current))
+	if (dl_task(current) || rt_task(current))
 		slack = 0;
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
diff --git a/kernel/locking/rtmutex-debug.c b/kernel/locking/rtmutex-debug.c
index 13b243a..49b2ed3 100644
--- a/kernel/locking/rtmutex-debug.c
+++ b/kernel/locking/rtmutex-debug.c
@@ -24,7 +24,7 @@
 #include <linux/kallsyms.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
-#include <linux/plist.h>
+#include <linux/rbtree.h>
 #include <linux/fs.h>
 #include <linux/debug_locks.h>
 
@@ -57,7 +57,7 @@ static void printk_lock(struct rt_mutex *lock, int print_owner)
 
 void rt_mutex_debug_task_free(struct task_struct *task)
 {
-	DEBUG_LOCKS_WARN_ON(!plist_head_empty(&task->pi_waiters));
+	DEBUG_LOCKS_WARN_ON(!RB_EMPTY_ROOT(&task->pi_waiters));
 	DEBUG_LOCKS_WARN_ON(task->pi_blocked_on);
 }
 
@@ -154,16 +154,12 @@ void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock)
 void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
 {
 	memset(waiter, 0x11, sizeof(*waiter));
-	plist_node_init(&waiter->list_entry, MAX_PRIO);
-	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
 	waiter->deadlock_task_pid = NULL;
 }
 
 void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 {
 	put_pid(waiter->deadlock_task_pid);
-	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->list_entry));
-	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 	memset(waiter, 0x22, sizeof(*waiter));
 }
 
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 0dd6aec..2e960a2 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/deadline.h>
 #include <linux/timer.h>
 
 #include "rtmutex_common.h"
@@ -91,10 +92,107 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
 }
 #endif
 
+static inline int
+rt_mutex_waiter_less(struct rt_mutex_waiter *left,
+		     struct rt_mutex_waiter *right)
+{
+	if (left->prio < right->prio)
+		return 1;
+
+	/*
+	 * If both waiters have dl_prio(), we check the deadlines of the
+	 * associated tasks.
+	 * If left waiter has a dl_prio(), and we didn't return 1 above,
+	 * then right waiter has a dl_prio() too.
+	 */
+	if (dl_prio(left->prio))
+		return (left->task->dl.deadline < right->task->dl.deadline);
+
+	return 0;
+}
+
+static void
+rt_mutex_enqueue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	struct rb_node **link = &lock->waiters.rb_node;
+	struct rb_node *parent = NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost = 1;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rt_mutex_waiter, tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		lock->waiters_leftmost = &waiter->tree_entry;
+
+	rb_link_node(&waiter->tree_entry, parent, link);
+	rb_insert_color(&waiter->tree_entry, &lock->waiters);
+}
+
+static void
+rt_mutex_dequeue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	if (RB_EMPTY_NODE(&waiter->tree_entry))
+		return;
+
+	if (lock->waiters_leftmost == &waiter->tree_entry)
+		lock->waiters_leftmost = rb_next(&waiter->tree_entry);
+
+	rb_erase(&waiter->tree_entry, &lock->waiters);
+	RB_CLEAR_NODE(&waiter->tree_entry);
+}
+
+static void
+rt_mutex_enqueue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
+{
+	struct rb_node **link = &task->pi_waiters.rb_node;
+	struct rb_node *parent = NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost = 1;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rt_mutex_waiter, pi_tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		task->pi_waiters_leftmost = &waiter->pi_tree_entry;
+
+	rb_link_node(&waiter->pi_tree_entry, parent, link);
+	rb_insert_color(&waiter->pi_tree_entry, &task->pi_waiters);
+}
+
+static void
+rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
+{
+	if (RB_EMPTY_NODE(&waiter->pi_tree_entry))
+		return;
+
+	if (task->pi_waiters_leftmost == &waiter->pi_tree_entry)
+		task->pi_waiters_leftmost = rb_next(&waiter->pi_tree_entry);
+
+	rb_erase(&waiter->pi_tree_entry, &task->pi_waiters);
+	RB_CLEAR_NODE(&waiter->pi_tree_entry);
+}
+
 /*
- * Calculate task priority from the waiter list priority
+ * Calculate task priority from the waiter tree priority
  *
- * Return task->normal_prio when the waiter list is empty or when
+ * Return task->normal_prio when the waiter tree is empty or when
  * the waiter is not allowed to do priority boosting
  */
 int rt_mutex_getprio(struct task_struct *task)
@@ -102,10 +200,18 @@ int rt_mutex_getprio(struct task_struct *task)
 	if (likely(!task_has_pi_waiters(task)))
 		return task->normal_prio;
 
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
+	return min(task_top_pi_waiter(task)->prio,
 		   task->normal_prio);
 }
 
+struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
+{
+	if (likely(!task_has_pi_waiters(task)))
+		return NULL;
+
+	return task_top_pi_waiter(task)->task;
+}
+
 /*
  * Adjust the priority of a task, after its pi_waiters got modified.
  *
@@ -115,7 +221,7 @@ static void __rt_mutex_adjust_prio(struct task_struct *task)
 {
 	int prio = rt_mutex_getprio(task);
 
-	if (task->prio != prio)
+	if (task->prio != prio || dl_prio(prio))
 		rt_mutex_setprio(task, prio);
 }
 
@@ -233,7 +339,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * When deadlock detection is off then we check, if further
 	 * priority adjustment is necessary.
 	 */
-	if (!detect_deadlock && waiter->list_entry.prio == task->prio)
+	if (!detect_deadlock && waiter->prio == task->prio)
 		goto out_unlock_pi;
 
 	lock = waiter->lock;
@@ -254,9 +360,9 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	top_waiter = rt_mutex_top_waiter(lock);
 
 	/* Requeue the waiter */
-	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->list_entry.prio = task->prio;
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
+	waiter->prio = task->prio;
+	rt_mutex_enqueue(lock, waiter);
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -280,17 +386,15 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
-		plist_del(&top_waiter->pi_list_entry, &task->pi_waiters);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, top_waiter);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 
 	} else if (top_waiter == waiter) {
 		/* Deboost the owner */
-		plist_del(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, waiter);
 		waiter = rt_mutex_top_waiter(lock);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 	}
 
@@ -355,7 +459,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	 * 3) it is top waiter
 	 */
 	if (rt_mutex_has_waiters(lock)) {
-		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio) {
+		if (task->prio >= rt_mutex_top_waiter(lock)->prio) {
 			if (!waiter || waiter != rt_mutex_top_waiter(lock))
 				return 0;
 		}
@@ -369,7 +473,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 
 		/* remove the queued waiter. */
 		if (waiter) {
-			plist_del(&waiter->list_entry, &lock->wait_list);
+			rt_mutex_dequeue(lock, waiter);
 			task->pi_blocked_on = NULL;
 		}
 
@@ -379,8 +483,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 		 */
 		if (rt_mutex_has_waiters(lock)) {
 			top = rt_mutex_top_waiter(lock);
-			top->pi_list_entry.prio = top->list_entry.prio;
-			plist_add(&top->pi_list_entry, &task->pi_waiters);
+			rt_mutex_enqueue_pi(task, top);
 		}
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
@@ -416,13 +519,12 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
-	plist_node_init(&waiter->list_entry, task->prio);
-	plist_node_init(&waiter->pi_list_entry, task->prio);
+	waiter->prio = task->prio;
 
 	/* Get the top priority waiter on the lock */
 	if (rt_mutex_has_waiters(lock))
 		top_waiter = rt_mutex_top_waiter(lock);
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_enqueue(lock, waiter);
 
 	task->pi_blocked_on = waiter;
 
@@ -433,8 +535,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
-		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
-		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
+		rt_mutex_dequeue_pi(owner, top_waiter);
+		rt_mutex_enqueue_pi(owner, waiter);
 
 		__rt_mutex_adjust_prio(owner);
 		if (owner->pi_blocked_on)
@@ -486,7 +588,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	 * boosted mode and go back to normal after releasing
 	 * lock->wait_lock.
 	 */
-	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
+	rt_mutex_dequeue_pi(current, waiter);
 
 	rt_mutex_set_owner(lock, NULL);
 
@@ -510,7 +612,7 @@ static void remove_waiter(struct rt_mutex *lock,
 	int chain_walk = 0;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
-	plist_del(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
@@ -521,13 +623,13 @@ static void remove_waiter(struct rt_mutex *lock,
 
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
-		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
+		rt_mutex_dequeue_pi(owner, waiter);
 
 		if (rt_mutex_has_waiters(lock)) {
 			struct rt_mutex_waiter *next;
 
 			next = rt_mutex_top_waiter(lock);
-			plist_add(&next->pi_list_entry, &owner->pi_waiters);
+			rt_mutex_enqueue_pi(owner, next);
 		}
 		__rt_mutex_adjust_prio(owner);
 
@@ -537,8 +639,6 @@ static void remove_waiter(struct rt_mutex *lock,
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
-	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-
 	if (!chain_walk)
 		return;
 
@@ -565,7 +665,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
-	if (!waiter || waiter->list_entry.prio == task->prio) {
+	if (!waiter || (waiter->prio == task->prio &&
+			!dl_prio(task->prio))) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
@@ -638,6 +739,8 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	int ret = 0;
 
 	debug_rt_mutex_init_waiter(&waiter);
+	RB_CLEAR_NODE(&waiter.pi_tree_entry);
+	RB_CLEAR_NODE(&waiter.tree_entry);
 
 	raw_spin_lock(&lock->wait_lock);
 
@@ -904,7 +1007,8 @@ void __rt_mutex_init(struct rt_mutex *lock, const char *name)
 {
 	lock->owner = NULL;
 	raw_spin_lock_init(&lock->wait_lock);
-	plist_head_init(&lock->wait_list);
+	lock->waiters = RB_ROOT;
+	lock->waiters_leftmost = NULL;
 
 	debug_rt_mutex_init(lock, name);
 }
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index 53a66c8..7431a9c 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -40,13 +40,13 @@ extern void schedule_rt_mutex_test(struct rt_mutex *lock);
  * This is the control structure for tasks blocked on a rt_mutex,
  * which is allocated on the kernel stack on of the blocked task.
  *
- * @list_entry:		pi node to enqueue into the mutex waiters list
- * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
+ * @tree_entry:		pi node to enqueue into the mutex waiters tree
+ * @pi_tree_entry:	pi node to enqueue into the mutex owner waiters tree
  * @task:		task reference to the blocked task
  */
 struct rt_mutex_waiter {
-	struct plist_node	list_entry;
-	struct plist_node	pi_list_entry;
+	struct rb_node          tree_entry;
+	struct rb_node          pi_tree_entry;
 	struct task_struct	*task;
 	struct rt_mutex		*lock;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
@@ -54,14 +54,15 @@ struct rt_mutex_waiter {
 	struct pid		*deadlock_task_pid;
 	struct rt_mutex		*deadlock_lock;
 #endif
+	int prio;
 };
 
 /*
- * Various helpers to access the waiters-plist:
+ * Various helpers to access the waiters-tree:
  */
 static inline int rt_mutex_has_waiters(struct rt_mutex *lock)
 {
-	return !plist_head_empty(&lock->wait_list);
+	return !RB_EMPTY_ROOT(&lock->waiters);
 }
 
 static inline struct rt_mutex_waiter *
@@ -69,8 +70,8 @@ rt_mutex_top_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *w;
 
-	w = plist_first_entry(&lock->wait_list, struct rt_mutex_waiter,
-			       list_entry);
+	w = rb_entry(lock->waiters_leftmost, struct rt_mutex_waiter,
+		     tree_entry);
 	BUG_ON(w->lock != lock);
 
 	return w;
@@ -78,14 +79,14 @@ rt_mutex_top_waiter(struct rt_mutex *lock)
 
 static inline int task_has_pi_waiters(struct task_struct *p)
 {
-	return !plist_head_empty(&p->pi_waiters);
+	return !RB_EMPTY_ROOT(&p->pi_waiters);
 }
 
 static inline struct rt_mutex_waiter *
 task_top_pi_waiter(struct task_struct *p)
 {
-	return plist_first_entry(&p->pi_waiters, struct rt_mutex_waiter,
-				  pi_list_entry);
+	return rb_entry(p->pi_waiters_leftmost, struct rt_mutex_waiter,
+			pi_tree_entry);
 }
 
 /*
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 7b62140..9a95c8c 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -11,9 +11,10 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
-obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
+obj-y += core.o proc.o clock.o cputime.o
+obj-y += idle_task.o fair.o rt.o deadline.o stop_task.o
 obj-y += wait.o completion.o
-obj-$(CONFIG_SMP) += cpupri.o
+obj-$(CONFIG_SMP) += cpupri.o cpudeadline.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c3ae144..6bd6a67 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -26,9 +26,10 @@
  * at 0 on boot (but people really shouldn't rely on that).
  *
  * cpu_clock(i)       -- can be used from any context, including NMI.
- * sched_clock_cpu(i) -- must be used with local IRQs disabled (implied by NMI)
  * local_clock()      -- is cpu_clock() on the current cpu.
  *
+ * sched_clock_cpu(i)
+ *
  * How:
  *
  * The implementation either uses sched_clock() when
@@ -50,15 +51,6 @@
  * Furthermore, explicit sleep and wakeup hooks allow us to account for time
  * that is otherwise invisible (TSC gets stopped).
  *
- *
- * Notes:
- *
- * The !IRQ-safetly of sched_clock() and sched_clock_cpu() comes from things
- * like cpufreq interrupts that can change the base clock (TSC) multiplier
- * and cause funny jumps in time -- although the filtering provided by
- * sched_clock_cpu() should mitigate serious artifacts we cannot rely on it
- * in general since for !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK we fully rely on
- * sched_clock().
  */
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
@@ -66,6 +58,8 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/static_key.h>
+#include <linux/workqueue.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -82,7 +76,37 @@ EXPORT_SYMBOL_GPL(sched_clock);
 __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-__read_mostly int sched_clock_stable;
+static struct static_key __sched_clock_stable = STATIC_KEY_INIT;
+
+int sched_clock_stable(void)
+{
+	if (static_key_false(&__sched_clock_stable))
+		return false;
+	return true;
+}
+
+void set_sched_clock_stable(void)
+{
+	if (!sched_clock_stable())
+		static_key_slow_dec(&__sched_clock_stable);
+}
+
+static void __clear_sched_clock_stable(struct work_struct *work)
+{
+	/* XXX worry about clock continuity */
+	if (sched_clock_stable())
+		static_key_slow_inc(&__sched_clock_stable);
+}
+
+static DECLARE_WORK(sched_clock_work, __clear_sched_clock_stable);
+
+void clear_sched_clock_stable(void)
+{
+	if (keventd_up())
+		schedule_work(&sched_clock_work);
+	else
+		__clear_sched_clock_stable(&sched_clock_work);
+}
 
 struct sched_clock_data {
 	u64			tick_raw;
@@ -242,20 +266,20 @@ u64 sched_clock_cpu(int cpu)
 	struct sched_clock_data *scd;
 	u64 clock;
 
-	WARN_ON_ONCE(!irqs_disabled());
-
-	if (sched_clock_stable)
+	if (sched_clock_stable())
 		return sched_clock();
 
 	if (unlikely(!sched_clock_running))
 		return 0ull;
 
+	preempt_disable();
 	scd = cpu_sdc(cpu);
 
 	if (cpu != smp_processor_id())
 		clock = sched_clock_remote(scd);
 	else
 		clock = sched_clock_local(scd);
+	preempt_enable();
 
 	return clock;
 }
@@ -265,7 +289,7 @@ void sched_clock_tick(void)
 	struct sched_clock_data *scd;
 	u64 now, now_gtod;
 
-	if (sched_clock_stable)
+	if (sched_clock_stable())
 		return;
 
 	if (unlikely(!sched_clock_running))
@@ -316,14 +340,10 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
  */
 u64 cpu_clock(int cpu)
 {
-	u64 clock;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	clock = sched_clock_cpu(cpu);
-	local_irq_restore(flags);
+	if (static_key_false(&__sched_clock_stable))
+		return sched_clock_cpu(cpu);
 
-	return clock;
+	return sched_clock();
 }
 
 /*
@@ -335,14 +355,10 @@ u64 cpu_clock(int cpu)
  */
 u64 local_clock(void)
 {
-	u64 clock;
-	unsigned long flags;
+	if (static_key_false(&__sched_clock_stable))
+		return sched_clock_cpu(raw_smp_processor_id());
 
-	local_irq_save(flags);
-	clock = sched_clock_cpu(smp_processor_id());
-	local_irq_restore(flags);
-
-	return clock;
+	return sched_clock();
 }
 
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
@@ -362,12 +378,12 @@ u64 sched_clock_cpu(int cpu)
 
 u64 cpu_clock(int cpu)
 {
-	return sched_clock_cpu(cpu);
+	return sched_clock();
 }
 
 u64 local_clock(void)
 {
-	return sched_clock_cpu(0);
+	return sched_clock();
 }
 
 #endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..36c951b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -296,8 +296,6 @@ __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
-
-
 /*
  * __task_rq_lock - lock the rq @p resides on.
  */
@@ -899,7 +897,9 @@ static inline int normal_prio(struct task_struct *p)
 {
 	int prio;
 
-	if (task_has_rt_policy(p))
+	if (task_has_dl_policy(p))
+		prio = MAX_DL_PRIO-1;
+	else if (task_has_rt_policy(p))
 		prio = MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio = __normal_prio(p);
@@ -945,7 +945,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p);
 		p->sched_class->switched_to(rq, p);
-	} else if (oldprio != p->prio)
+	} else if (oldprio != p->prio || dl_task(p))
 		p->sched_class->prio_changed(rq, p, oldprio);
 }
 
@@ -1499,8 +1499,7 @@ void scheduler_ipi(void)
 	 * TIF_NEED_RESCHED remotely (for the first time) will also send
 	 * this IPI.
 	 */
-	if (tif_need_resched())
-		set_preempt_need_resched();
+	preempt_fold_need_resched();
 
 	if (llist_empty(&this_rq()->wake_list)
 			&& !tick_nohz_full_cpu(smp_processor_id())
@@ -1717,6 +1716,13 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 
+	RB_CLEAR_NODE(&p->dl.rb_node);
+	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	p->dl.dl_runtime = p->dl.runtime = 0;
+	p->dl.dl_deadline = p->dl.deadline = 0;
+	p->dl.dl_period = 0;
+	p->dl.flags = 0;
+
 	INIT_LIST_HEAD(&p->rt.run_list);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -1768,7 +1774,7 @@ void set_numabalancing_state(bool enabled)
 /*
  * fork()/clone()-time setup:
  */
-void sched_fork(unsigned long clone_flags, struct task_struct *p)
+int sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long flags;
 	int cpu = get_cpu();
@@ -1790,7 +1796,7 @@ void sched_fork(unsigned long clone_flags, struct task_struct *p)
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (task_has_rt_policy(p)) {
+		if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
@@ -1807,8 +1813,14 @@ void sched_fork(unsigned long clone_flags, struct task_struct *p)
 		p->sched_reset_on_fork = 0;
 	}
 
-	if (!rt_prio(p->prio))
+	if (dl_prio(p->prio)) {
+		put_cpu();
+		return -EAGAIN;
+	} else if (rt_prio(p->prio)) {
+		p->sched_class = &rt_sched_class;
+	} else {
 		p->sched_class = &fair_sched_class;
+	}
 
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
@@ -1834,11 +1846,124 @@ void sched_fork(unsigned long clone_flags, struct task_struct *p)
 	init_task_preempt_count(p);
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
+	RB_CLEAR_NODE(&p->pushable_dl_tasks);
 #endif
 
 	put_cpu();
+	return 0;
+}
+
+unsigned long to_ratio(u64 period, u64 runtime)
+{
+	if (runtime == RUNTIME_INF)
+		return 1ULL << 20;
+
+	/*
+	 * Doing this here saves a lot of checks in all
+	 * the calling paths, and returning zero seems
+	 * safe for them anyway.
+	 */
+	if (period == 0)
+		return 0;
+
+	return div64_u64(runtime << 20, period);
+}
+
+#ifdef CONFIG_SMP
+inline struct dl_bw *dl_bw_of(int i)
+{
+	return &cpu_rq(i)->rd->dl_bw;
 }
 
+static inline int dl_bw_cpus(int i)
+{
+	struct root_domain *rd = cpu_rq(i)->rd;
+	int cpus = 0;
+
+	for_each_cpu_and(i, rd->span, cpu_active_mask)
+		cpus++;
+
+	return cpus;
+}
+#else
+inline struct dl_bw *dl_bw_of(int i)
+{
+	return &cpu_rq(i)->dl.dl_bw;
+}
+
+static inline int dl_bw_cpus(int i)
+{
+	return 1;
+}
+#endif
+
+static inline
+void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw -= tsk_bw;
+}
+
+static inline
+void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw += tsk_bw;
+}
+
+static inline
+bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
+{
+	return dl_b->bw != -1 &&
+	       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
+}
+
+/*
+ * We must be sure that accepting a new task (or allowing changing the
+ * parameters of an existing one) is consistent with the bandwidth
+ * constraints. If yes, this function also accordingly updates the currently
+ * allocated bandwidth to reflect the new situation.
+ *
+ * This function is called while holding p's rq->lock.
+ */
+static int dl_overflow(struct task_struct *p, int policy,
+		       const struct sched_attr *attr)
+{
+
+	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
+	u64 period = attr->sched_period;
+	u64 runtime = attr->sched_runtime;
+	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
+	int cpus, err = -1;
+
+	if (new_bw == p->dl.dl_bw)
+		return 0;
+
+	/*
+	 * Either if a task, enters, leave, or stays -deadline but changes
+	 * its parameters, we may need to update accordingly the total
+	 * allocated bandwidth of the container.
+	 */
+	raw_spin_lock(&dl_b->lock);
+	cpus = dl_bw_cpus(task_cpu(p));
+	if (dl_policy(policy) && !task_has_dl_policy(p) &&
+	    !__dl_overflow(dl_b, cpus, 0, new_bw)) {
+		__dl_add(dl_b, new_bw);
+		err = 0;
+	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
+		   !__dl_overflow(dl_b, cpus, p->dl.dl_bw, new_bw)) {
+		__dl_clear(dl_b, p->dl.dl_bw);
+		__dl_add(dl_b, new_bw);
+		err = 0;
+	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
+		__dl_clear(dl_b, p->dl.dl_bw);
+		err = 0;
+	}
+	raw_spin_unlock(&dl_b->lock);
+
+	return err;
+}
+
+extern void init_dl_bw(struct dl_bw *dl_b);
+
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
@@ -2003,6 +2128,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (unlikely(prev_state == TASK_DEAD)) {
 		task_numa_free(prev);
 
+		if (prev->sched_class->task_dead)
+			prev->sched_class->task_dead(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
@@ -2296,7 +2424,7 @@ void scheduler_tick(void)
 
 #ifdef CONFIG_SMP
 	rq->idle_balance = idle_cpu(cpu);
-	trigger_load_balance(rq, cpu);
+	trigger_load_balance(rq);
 #endif
 	rq_last_tick_reset(rq);
 }
@@ -2414,10 +2542,10 @@ static inline void schedule_debug(struct task_struct *prev)
 {
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
-	 * schedule() atomically, we ignore that path for now.
-	 * Otherwise, whine if we are scheduling when we should not be.
+	 * schedule() atomically, we ignore that path. Otherwise whine
+	 * if we are scheduling when we should not.
 	 */
-	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
+	if (unlikely(in_atomic_preempt_off() && prev->state != TASK_DEAD))
 		__schedule_bug(prev);
 	rcu_sleep_check();
 
@@ -2761,11 +2889,11 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	int oldprio, on_rq, running;
+	int oldprio, on_rq, running, enqueue_flag = 0;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
-	BUG_ON(prio < 0 || prio > MAX_PRIO);
+	BUG_ON(prio > MAX_PRIO);
 
 	rq = __task_rq_lock(p);
 
@@ -2788,6 +2916,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	}
 
 	trace_sched_pi_setprio(p, prio);
+	p->pi_top_task = rt_mutex_get_top_task(p);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
@@ -2797,23 +2926,49 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	if (rt_prio(prio))
+	/*
+	 * Boosting condition are:
+	 * 1. -rt task is running and holds mutex A
+	 *      --> -dl task blocks on mutex A
+	 *
+	 * 2. -dl task is running and holds mutex A
+	 *      --> -dl task blocks on mutex A and could preempt the
+	 *          running task
+	 */
+	if (dl_prio(prio)) {
+		if (!dl_prio(p->normal_prio) || (p->pi_top_task &&
+			dl_entity_preempt(&p->pi_top_task->dl, &p->dl))) {
+			p->dl.dl_boosted = 1;
+			p->dl.dl_throttled = 0;
+			enqueue_flag = ENQUEUE_REPLENISH;
+		} else
+			p->dl.dl_boosted = 0;
+		p->sched_class = &dl_sched_class;
+	} else if (rt_prio(prio)) {
+		if (dl_prio(oldprio))
+			p->dl.dl_boosted = 0;
+		if (oldprio < prio)
+			enqueue_flag = ENQUEUE_HEAD;
 		p->sched_class = &rt_sched_class;
-	else
+	} else {
+		if (dl_prio(oldprio))
+			p->dl.dl_boosted = 0;
 		p->sched_class = &fair_sched_class;
+	}
 
 	p->prio = prio;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
+		enqueue_task(rq, p, enqueue_flag);
 
 	check_class_changed(rq, p, prev_class, oldprio);
 out_unlock:
 	__task_rq_unlock(rq);
 }
 #endif
+
 void set_user_nice(struct task_struct *p, long nice)
 {
 	int old_prio, delta, on_rq;
@@ -2831,9 +2986,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
-	 * SCHED_FIFO/SCHED_RR:
+	 * SCHED_DEADLINE, SCHED_FIFO or SCHED_RR:
 	 */
-	if (task_has_rt_policy(p)) {
+	if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -2988,22 +3143,95 @@ static struct task_struct *find_process_by_pid(pid_t pid)
 	return pid ? find_task_by_vpid(pid) : current;
 }
 
-/* Actually do priority change: must hold rq lock. */
+/*
+ * This function initializes the sched_dl_entity of a newly becoming
+ * SCHED_DEADLINE task.
+ *
+ * Only the static values are considered here, the actual runtime and the
+ * absolute deadline will be properly calculated when the task is enqueued
+ * for the first time with its new policy.
+ */
 static void
-__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
+__setparam_dl(struct task_struct *p, const struct sched_attr *attr)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	init_dl_task_timer(dl_se);
+	dl_se->dl_runtime = attr->sched_runtime;
+	dl_se->dl_deadline = attr->sched_deadline;
+	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
+	dl_se->flags = attr->sched_flags;
+	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
+	dl_se->dl_throttled = 0;
+	dl_se->dl_new = 1;
+}
+
+/* Actually do priority change: must hold pi & rq lock. */
+static void __setscheduler(struct rq *rq, struct task_struct *p,
+			   const struct sched_attr *attr)
 {
+	int policy = attr->sched_policy;
+
+	if (policy == -1) /* setparam */
+		policy = p->policy;
+
 	p->policy = policy;
-	p->rt_priority = prio;
+
+	if (dl_policy(policy))
+		__setparam_dl(p, attr);
+	else if (fair_policy(policy))
+		p->static_prio = NICE_TO_PRIO(attr->sched_nice);
+
+	/*
+	 * __sched_setscheduler() ensures attr->sched_priority == 0 when
+	 * !rt_policy. Always setting this ensures that things like
+	 * getparam()/getattr() don't report silly values for !rt tasks.
+	 */
+	p->rt_priority = attr->sched_priority;
+
 	p->normal_prio = normal_prio(p);
-	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
-	if (rt_prio(p->prio))
+
+	if (dl_prio(p->prio))
+		p->sched_class = &dl_sched_class;
+	else if (rt_prio(p->prio))
 		p->sched_class = &rt_sched_class;
 	else
 		p->sched_class = &fair_sched_class;
+
 	set_load_weight(p);
 }
 
+static void
+__getparam_dl(struct task_struct *p, struct sched_attr *attr)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	attr->sched_priority = p->rt_priority;
+	attr->sched_runtime = dl_se->dl_runtime;
+	attr->sched_deadline = dl_se->dl_deadline;
+	attr->sched_period = dl_se->dl_period;
+	attr->sched_flags = dl_se->flags;
+}
+
+/*
+ * This function validates the new parameters of a -deadline task.
+ * We ask for the deadline not being zero, and greater or equal
+ * than the runtime, as well as the period of being zero or
+ * greater than deadline. Furthermore, we have to be sure that
+ * user parameters are above the internal resolution (1us); we
+ * check sched_runtime only since it is always the smaller one.
+ */
+static bool
+__checkparam_dl(const struct sched_attr *attr)
+{
+	return attr && attr->sched_deadline != 0 &&
+		(attr->sched_period == 0 ||
+		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
+		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0  &&
+		attr->sched_runtime >= (2 << (DL_SCALE - 1));
+}
+
 /*
  * check the target process has a UID that matches the current process's
  */
@@ -3020,10 +3248,12 @@ static bool check_same_owner(struct task_struct *p)
 	return match;
 }
 
-static int __sched_setscheduler(struct task_struct *p, int policy,
-				const struct sched_param *param, bool user)
+static int __sched_setscheduler(struct task_struct *p,
+				const struct sched_attr *attr,
+				bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
+	int policy = attr->sched_policy;
 	unsigned long flags;
 	const struct sched_class *prev_class;
 	struct rq *rq;
@@ -3037,31 +3267,40 @@ recheck:
 		reset_on_fork = p->sched_reset_on_fork;
 		policy = oldpolicy = p->policy;
 	} else {
-		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
-		policy &= ~SCHED_RESET_ON_FORK;
+		reset_on_fork = !!(attr->sched_flags & SCHED_FLAG_RESET_ON_FORK);
 
-		if (policy != SCHED_FIFO && policy != SCHED_RR &&
+		if (policy != SCHED_DEADLINE &&
+				policy != SCHED_FIFO && policy != SCHED_RR &&
 				policy != SCHED_NORMAL && policy != SCHED_BATCH &&
 				policy != SCHED_IDLE)
 			return -EINVAL;
 	}
 
+	if (attr->sched_flags & ~(SCHED_FLAG_RESET_ON_FORK))
+		return -EINVAL;
+
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
 	 * SCHED_BATCH and SCHED_IDLE is 0.
 	 */
-	if (param->sched_priority < 0 ||
-	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
-	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
+	if ((p->mm && attr->sched_priority > MAX_USER_RT_PRIO-1) ||
+	    (!p->mm && attr->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if (rt_policy(policy) != (param->sched_priority != 0))
+	if ((dl_policy(policy) && !__checkparam_dl(attr)) ||
+	    (rt_policy(policy) != (attr->sched_priority != 0)))
 		return -EINVAL;
 
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
+		if (fair_policy(policy)) {
+			if (attr->sched_nice < TASK_NICE(p) &&
+			    !can_nice(p, attr->sched_nice))
+				return -EPERM;
+		}
+
 		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio =
 					task_rlimit(p, RLIMIT_RTPRIO);
@@ -3071,8 +3310,8 @@ recheck:
 				return -EPERM;
 
 			/* can't increase priority */
-			if (param->sched_priority > p->rt_priority &&
-			    param->sched_priority > rlim_rtprio)
+			if (attr->sched_priority > p->rt_priority &&
+			    attr->sched_priority > rlim_rtprio)
 				return -EPERM;
 		}
 
@@ -3120,14 +3359,21 @@ recheck:
 	/*
 	 * If not changing anything there's no need to proceed further:
 	 */
-	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
-			param->sched_priority == p->rt_priority))) {
+	if (unlikely(policy == p->policy)) {
+		if (fair_policy(policy) && attr->sched_nice != TASK_NICE(p))
+			goto change;
+		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
+			goto change;
+		if (dl_policy(policy))
+			goto change;
+
 		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
+change:
 
-#ifdef CONFIG_RT_GROUP_SCHED
 	if (user) {
+#ifdef CONFIG_RT_GROUP_SCHED
 		/*
 		 * Do not allow realtime tasks into groups that have no runtime
 		 * assigned.
@@ -3138,8 +3384,24 @@ recheck:
 			task_rq_unlock(rq, p, &flags);
 			return -EPERM;
 		}
-	}
 #endif
+#ifdef CONFIG_SMP
+		if (dl_bandwidth_enabled() && dl_policy(policy)) {
+			cpumask_t *span = rq->rd->span;
+
+			/*
+			 * Don't allow tasks with an affinity mask smaller than
+			 * the entire root_domain to become SCHED_DEADLINE. We
+			 * will also fail if there's no bandwidth available.
+			 */
+			if (!cpumask_subset(span, &p->cpus_allowed) ||
+			    rq->rd->dl_bw.bw == 0) {
+				task_rq_unlock(rq, p, &flags);
+				return -EPERM;
+			}
+		}
+#endif
+	}
 
 	/* recheck policy now with rq lock held */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
@@ -3147,6 +3409,17 @@ recheck:
 		task_rq_unlock(rq, p, &flags);
 		goto recheck;
 	}
+
+	/*
+	 * If setscheduling to SCHED_DEADLINE (or changing the parameters
+	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
+	 * is available.
+	 */
+	if ((dl_policy(policy) || dl_task(p)) && dl_overflow(p, policy, attr)) {
+		task_rq_unlock(rq, p, &flags);
+		return -EBUSY;
+	}
+
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -3158,7 +3431,7 @@ recheck:
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	__setscheduler(rq, p, policy, param->sched_priority);
+	__setscheduler(rq, p, attr);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
@@ -3173,6 +3446,26 @@ recheck:
 	return 0;
 }
 
+static int _sched_setscheduler(struct task_struct *p, int policy,
+			       const struct sched_param *param, bool check)
+{
+	struct sched_attr attr = {
+		.sched_policy   = policy,
+		.sched_priority = param->sched_priority,
+		.sched_nice	= PRIO_TO_NICE(p->static_prio),
+	};
+
+	/*
+	 * Fixup the legacy SCHED_RESET_ON_FORK hack
+	 */
+	if (policy & SCHED_RESET_ON_FORK) {
+		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
+		policy &= ~SCHED_RESET_ON_FORK;
+		attr.sched_policy = policy;
+	}
+
+	return __sched_setscheduler(p, &attr, check);
+}
 /**
  * sched_setscheduler - change the scheduling policy and/or RT priority of a thread.
  * @p: the task in question.
@@ -3186,10 +3479,16 @@ recheck:
 int sched_setscheduler(struct task_struct *p, int policy,
 		       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, true);
+	return _sched_setscheduler(p, policy, param, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
 
+int sched_setattr(struct task_struct *p, const struct sched_attr *attr)
+{
+	return __sched_setscheduler(p, attr, true);
+}
+EXPORT_SYMBOL_GPL(sched_setattr);
+
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
  * @p: the task in question.
@@ -3206,7 +3505,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, false);
+	return _sched_setscheduler(p, policy, param, false);
 }
 
 static int
@@ -3231,6 +3530,79 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 	return retval;
 }
 
+/*
+ * Mimics kernel/events/core.c perf_copy_attr().
+ */
+static int sched_copy_attr(struct sched_attr __user *uattr,
+			   struct sched_attr *attr)
+{
+	u32 size;
+	int ret;
+
+	if (!access_ok(VERIFY_WRITE, uattr, SCHED_ATTR_SIZE_VER0))
+		return -EFAULT;
+
+	/*
+	 * zero the full structure, so that a short copy will be nice.
+	 */
+	memset(attr, 0, sizeof(*attr));
+
+	ret = get_user(size, &uattr->size);
+	if (ret)
+		return ret;
+
+	if (size > PAGE_SIZE)	/* silly large */
+		goto err_size;
+
+	if (!size)		/* abi compat */
+		size = SCHED_ATTR_SIZE_VER0;
+
+	if (size < SCHED_ATTR_SIZE_VER0)
+		goto err_size;
+
+	/*
+	 * If we're handed a bigger struct than we know of,
+	 * ensure all the unknown bits are 0 - i.e. new
+	 * user-space does not rely on any kernel feature
+	 * extensions we dont know about yet.
+	 */
+	if (size > sizeof(*attr)) {
+		unsigned char __user *addr;
+		unsigned char __user *end;
+		unsigned char val;
+
+		addr = (void __user *)uattr + sizeof(*attr);
+		end  = (void __user *)uattr + size;
+
+		for (; addr < end; addr++) {
+			ret = get_user(val, addr);
+			if (ret)
+				return ret;
+			if (val)
+				goto err_size;
+		}
+		size = sizeof(*attr);
+	}
+
+	ret = copy_from_user(attr, uattr, size);
+	if (ret)
+		return -EFAULT;
+
+	/*
+	 * XXX: do we want to be lenient like existing syscalls; or do we want
+	 * to be strict and return an error on out-of-bounds values?
+	 */
+	attr->sched_nice = clamp(attr->sched_nice, -20, 19);
+
+out:
+	return ret;
+
+err_size:
+	put_user(sizeof(*attr), &uattr->size);
+	ret = -E2BIG;
+	goto out;
+}
+
 /**
  * sys_sched_setscheduler - set/change the scheduler policy and RT priority
  * @pid: the pid in question.
@@ -3262,6 +3634,33 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 }
 
 /**
+ * sys_sched_setattr - same as above, but with extended sched_attr
+ * @pid: the pid in question.
+ * @uattr: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE2(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr)
+{
+	struct sched_attr attr;
+	struct task_struct *p;
+	int retval;
+
+	if (!uattr || pid < 0)
+		return -EINVAL;
+
+	if (sched_copy_attr(uattr, &attr))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval = -ESRCH;
+	p = find_process_by_pid(pid);
+	if (p != NULL)
+		retval = sched_setattr(p, &attr);
+	rcu_read_unlock();
+
+	return retval;
+}
+
+/**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
  *
@@ -3316,6 +3715,10 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	if (retval)
 		goto out_unlock;
 
+	if (task_has_dl_policy(p)) {
+		retval = -EINVAL;
+		goto out_unlock;
+	}
 	lp.sched_priority = p->rt_priority;
 	rcu_read_unlock();
 
@@ -3331,6 +3734,96 @@ out_unlock:
 	return retval;
 }
 
+static int sched_read_attr(struct sched_attr __user *uattr,
+			   struct sched_attr *attr,
+			   unsigned int usize)
+{
+	int ret;
+
+	if (!access_ok(VERIFY_WRITE, uattr, usize))
+		return -EFAULT;
+
+	/*
+	 * If we're handed a smaller struct than we know of,
+	 * ensure all the unknown bits are 0 - i.e. old
+	 * user-space does not get uncomplete information.
+	 */
+	if (usize < sizeof(*attr)) {
+		unsigned char *addr;
+		unsigned char *end;
+
+		addr = (void *)attr + usize;
+		end  = (void *)attr + sizeof(*attr);
+
+		for (; addr < end; addr++) {
+			if (*addr)
+				goto err_size;
+		}
+
+		attr->size = usize;
+	}
+
+	ret = copy_to_user(uattr, attr, usize);
+	if (ret)
+		return -EFAULT;
+
+out:
+	return ret;
+
+err_size:
+	ret = -E2BIG;
+	goto out;
+}
+
+/**
+ * sys_sched_getattr - similar to sched_getparam, but with sched_attr
+ * @pid: the pid in question.
+ * @uattr: structure containing the extended parameters.
+ * @size: sizeof(attr) for fwd/bwd comp.
+ */
+SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
+		unsigned int, size)
+{
+	struct sched_attr attr = {
+		.size = sizeof(struct sched_attr),
+	};
+	struct task_struct *p;
+	int retval;
+
+	if (!uattr || pid < 0 || size > PAGE_SIZE ||
+	    size < SCHED_ATTR_SIZE_VER0)
+		return -EINVAL;
+
+	rcu_read_lock();
+	p = find_process_by_pid(pid);
+	retval = -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval = security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	attr.sched_policy = p->policy;
+	if (p->sched_reset_on_fork)
+		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
+	if (task_has_dl_policy(p))
+		__getparam_dl(p, &attr);
+	else if (task_has_rt_policy(p))
+		attr.sched_priority = p->rt_priority;
+	else
+		attr.sched_nice = TASK_NICE(p);
+
+	rcu_read_unlock();
+
+	retval = sched_read_attr(uattr, &attr, size);
+	return retval;
+
+out_unlock:
+	rcu_read_unlock();
+	return retval;
+}
+
 long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 {
 	cpumask_var_t cpus_allowed, new_mask;
@@ -3375,8 +3868,26 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	if (retval)
 		goto out_unlock;
 
+
 	cpuset_cpus_allowed(p, cpus_allowed);
 	cpumask_and(new_mask, in_mask, cpus_allowed);
+
+	/*
+	 * Since bandwidth control happens on root_domain basis,
+	 * if admission test is enabled, we only admit -deadline
+	 * tasks allowed to run on all the CPUs in the task's
+	 * root_domain.
+	 */
+#ifdef CONFIG_SMP
+	if (task_has_dl_policy(p)) {
+		const struct cpumask *span = task_rq(p)->rd->span;
+
+		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
+			retval = -EBUSY;
+			goto out_unlock;
+		}
+	}
+#endif
 again:
 	retval = set_cpus_allowed_ptr(p, new_mask);
 
@@ -3653,7 +4164,7 @@ again:
 	}
 
 	double_rq_lock(rq, p_rq);
-	while (task_rq(p) != p_rq) {
+	if (task_rq(p) != p_rq) {
 		double_rq_unlock(rq, p_rq);
 		goto again;
 	}
@@ -3742,6 +4253,7 @@ SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
 	case SCHED_RR:
 		ret = MAX_USER_RT_PRIO-1;
 		break;
+	case SCHED_DEADLINE:
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
@@ -3768,6 +4280,7 @@ SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
 	case SCHED_RR:
 		ret = 1;
 		break;
+	case SCHED_DEADLINE:
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
@@ -4514,13 +5027,31 @@ static int sched_cpu_active(struct notifier_block *nfb,
 static int sched_cpu_inactive(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
+	unsigned long flags;
+	long cpu = (long)hcpu;
+
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-		set_cpu_active((long)hcpu, false);
+		set_cpu_active(cpu, false);
+
+		/* explicitly allow suspend */
+		if (!(action & CPU_TASKS_FROZEN)) {
+			struct dl_bw *dl_b = dl_bw_of(cpu);
+			bool overflow;
+			int cpus;
+
+			raw_spin_lock_irqsave(&dl_b->lock, flags);
+			cpus = dl_bw_cpus(cpu);
+			overflow = __dl_overflow(dl_b, cpus, 0, 0);
+			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+			if (overflow)
+				return notifier_from_errno(-EBUSY);
+		}
 		return NOTIFY_OK;
-	default:
-		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_DONE;
 }
 
 static int __init migration_init(void)
@@ -4739,6 +5270,8 @@ static void free_rootdomain(struct rcu_head *rcu)
 	struct root_domain *rd = container_of(rcu, struct root_domain, rcu);
 
 	cpupri_cleanup(&rd->cpupri);
+	cpudl_cleanup(&rd->cpudl);
+	free_cpumask_var(rd->dlo_mask);
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
 	free_cpumask_var(rd->span);
@@ -4790,8 +5323,14 @@ static int init_rootdomain(struct root_domain *rd)
 		goto out;
 	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->dlo_mask, GFP_KERNEL))
 		goto free_online;
+	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+		goto free_dlo_mask;
+
+	init_dl_bw(&rd->dl_bw);
+	if (cpudl_init(&rd->cpudl) != 0)
+		goto free_dlo_mask;
 
 	if (cpupri_init(&rd->cpupri) != 0)
 		goto free_rto_mask;
@@ -4799,6 +5338,8 @@ static int init_rootdomain(struct root_domain *rd)
 
 free_rto_mask:
 	free_cpumask_var(rd->rto_mask);
+free_dlo_mask:
+	free_cpumask_var(rd->dlo_mask);
 free_online:
 	free_cpumask_var(rd->online);
 free_span:
@@ -6150,6 +6691,7 @@ void __init sched_init_smp(void)
 	free_cpumask_var(non_isolated_cpus);
 
 	init_sched_rt_class();
+	init_sched_dl_class();
 }
 #else
 void __init sched_init_smp(void)
@@ -6219,13 +6761,15 @@ void __init sched_init(void)
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 	}
 
+	init_rt_bandwidth(&def_rt_bandwidth,
+			global_rt_period(), global_rt_runtime());
+	init_dl_bandwidth(&def_dl_bandwidth,
+			global_rt_period(), global_rt_runtime());
+
 #ifdef CONFIG_SMP
 	init_defrootdomain();
 #endif
 
-	init_rt_bandwidth(&def_rt_bandwidth,
-			global_rt_period(), global_rt_runtime());
-
 #ifdef CONFIG_RT_GROUP_SCHED
 	init_rt_bandwidth(&root_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
@@ -6249,6 +6793,7 @@ void __init sched_init(void)
 		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
+		init_dl_rq(&rq->dl, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
@@ -6320,10 +6865,6 @@ void __init sched_init(void)
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
 #endif
 
-#ifdef CONFIG_RT_MUTEXES
-	plist_head_init(&init_task.pi_waiters);
-#endif
-
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */
@@ -6397,13 +6938,16 @@ EXPORT_SYMBOL(__might_sleep);
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
 	const struct sched_class *prev_class = p->sched_class;
+	struct sched_attr attr = {
+		.sched_policy = SCHED_NORMAL,
+	};
 	int old_prio = p->prio;
 	int on_rq;
 
 	on_rq = p->on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
-	__setscheduler(rq, p, SCHED_NORMAL, 0);
+	__setscheduler(rq, p, &attr);
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
 		resched_task(rq->curr);
@@ -6433,7 +6977,7 @@ void normalize_rt_tasks(void)
 		p->se.statistics.block_start	= 0;
 #endif
 
-		if (!rt_task(p)) {
+		if (!dl_task(p) && !rt_task(p)) {
 			/*
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
@@ -6628,16 +7172,6 @@ void sched_move_task(struct task_struct *tsk)
 }
 #endif /* CONFIG_CGROUP_SCHED */
 
-#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
-static unsigned long to_ratio(u64 period, u64 runtime)
-{
-	if (runtime == RUNTIME_INF)
-		return 1ULL << 20;
-
-	return div64_u64(runtime << 20, period);
-}
-#endif
-
 #ifdef CONFIG_RT_GROUP_SCHED
 /*
  * Ensure that the real time constraints are schedulable.
@@ -6811,24 +7345,13 @@ static long sched_group_rt_period(struct task_group *tg)
 	do_div(rt_period_us, NSEC_PER_USEC);
 	return rt_period_us;
 }
+#endif /* CONFIG_RT_GROUP_SCHED */
 
+#ifdef CONFIG_RT_GROUP_SCHED
 static int sched_rt_global_constraints(void)
 {
-	u64 runtime, period;
 	int ret = 0;
 
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
-	runtime = global_rt_runtime();
-	period = global_rt_period();
-
-	/*
-	 * Sanity check on the sysctl variables.
-	 */
-	if (runtime > period && runtime != RUNTIME_INF)
-		return -EINVAL;
-
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
 	ret = __rt_schedulable(NULL, 0, 0);
@@ -6851,17 +7374,7 @@ static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 static int sched_rt_global_constraints(void)
 {
 	unsigned long flags;
-	int i;
-
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
-	/*
-	 * There's always some RT tasks in the root group
-	 * -- migration, kstopmachine etc..
-	 */
-	if (sysctl_sched_rt_runtime == 0)
-		return -EBUSY;
+	int i, ret = 0;
 
 	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	for_each_possible_cpu(i) {
@@ -6873,36 +7386,88 @@ static int sched_rt_global_constraints(void)
 	}
 	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 
-	return 0;
+	return ret;
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-int sched_rr_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos)
+static int sched_dl_global_constraints(void)
 {
-	int ret;
-	static DEFINE_MUTEX(mutex);
+	u64 runtime = global_rt_runtime();
+	u64 period = global_rt_period();
+	u64 new_bw = to_ratio(period, runtime);
+	int cpu, ret = 0;
 
-	mutex_lock(&mutex);
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-	/* make sure that internally we keep jiffies */
-	/* also, writing zero resets timeslice to default */
-	if (!ret && write) {
-		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
-			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	/*
+	 * Here we want to check the bandwidth not being set to some
+	 * value smaller than the currently allocated bandwidth in
+	 * any of the root_domains.
+	 *
+	 * FIXME: Cycling on all the CPUs is overdoing, but simpler than
+	 * cycling on root_domains... Discussion on different/better
+	 * solutions is welcome!
+	 */
+	for_each_possible_cpu(cpu) {
+		struct dl_bw *dl_b = dl_bw_of(cpu);
+
+		raw_spin_lock(&dl_b->lock);
+		if (new_bw < dl_b->total_bw)
+			ret = -EBUSY;
+		raw_spin_unlock(&dl_b->lock);
+
+		if (ret)
+			break;
 	}
-	mutex_unlock(&mutex);
+
 	return ret;
 }
 
+static void sched_dl_do_global(void)
+{
+	u64 new_bw = -1;
+	int cpu;
+
+	def_dl_bandwidth.dl_period = global_rt_period();
+	def_dl_bandwidth.dl_runtime = global_rt_runtime();
+
+	if (global_rt_runtime() != RUNTIME_INF)
+		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
+
+	/*
+	 * FIXME: As above...
+	 */
+	for_each_possible_cpu(cpu) {
+		struct dl_bw *dl_b = dl_bw_of(cpu);
+
+		raw_spin_lock(&dl_b->lock);
+		dl_b->bw = new_bw;
+		raw_spin_unlock(&dl_b->lock);
+	}
+}
+
+static int sched_rt_global_validate(void)
+{
+	if (sysctl_sched_rt_period <= 0)
+		return -EINVAL;
+
+	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void sched_rt_do_global(void)
+{
+	def_rt_bandwidth.rt_runtime = global_rt_runtime();
+	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int ret;
 	int old_period, old_runtime;
 	static DEFINE_MUTEX(mutex);
+	int ret;
 
 	mutex_lock(&mutex);
 	old_period = sysctl_sched_rt_period;
@@ -6911,21 +7476,50 @@ int sched_rt_handler(struct ctl_table *table, int write,
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 
 	if (!ret && write) {
+		ret = sched_rt_global_validate();
+		if (ret)
+			goto undo;
+
 		ret = sched_rt_global_constraints();
-		if (ret) {
-			sysctl_sched_rt_period = old_period;
-			sysctl_sched_rt_runtime = old_runtime;
-		} else {
-			def_rt_bandwidth.rt_runtime = global_rt_runtime();
-			def_rt_bandwidth.rt_period =
-				ns_to_ktime(global_rt_period());
-		}
+		if (ret)
+			goto undo;
+
+		ret = sched_dl_global_constraints();
+		if (ret)
+			goto undo;
+
+		sched_rt_do_global();
+		sched_dl_do_global();
+	}
+	if (0) {
+undo:
+		sysctl_sched_rt_period = old_period;
+		sysctl_sched_rt_runtime = old_runtime;
 	}
 	mutex_unlock(&mutex);
 
 	return ret;
 }
 
+int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	/* make sure that internally we keep jiffies */
+	/* also, writing zero resets timeslice to default */
+	if (!ret && write) {
+		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
+			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	}
+	mutex_unlock(&mutex);
+	return ret;
+}
+
 #ifdef CONFIG_CGROUP_SCHED
 
 static inline struct task_group *css_tg(struct cgroup_subsys_state *css)
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
new file mode 100644
index 0000000..045fc74
--- /dev/null
+++ b/kernel/sched/cpudeadline.c
@@ -0,0 +1,216 @@
+/*
+ *  kernel/sched/cpudl.c
+ *
+ *  Global CPU deadline management
+ *
+ *  Author: Juri Lelli <j.lelli@sssup.it>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; version 2
+ *  of the License.
+ */
+
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include "cpudeadline.h"
+
+static inline int parent(int i)
+{
+	return (i - 1) >> 1;
+}
+
+static inline int left_child(int i)
+{
+	return (i << 1) + 1;
+}
+
+static inline int right_child(int i)
+{
+	return (i << 1) + 2;
+}
+
+static inline int dl_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+static void cpudl_exchange(struct cpudl *cp, int a, int b)
+{
+	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
+
+	swap(cp->elements[a], cp->elements[b]);
+	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
+}
+
+static void cpudl_heapify(struct cpudl *cp, int idx)
+{
+	int l, r, largest;
+
+	/* adapted from lib/prio_heap.c */
+	while(1) {
+		l = left_child(idx);
+		r = right_child(idx);
+		largest = idx;
+
+		if ((l < cp->size) && dl_time_before(cp->elements[idx].dl,
+							cp->elements[l].dl))
+			largest = l;
+		if ((r < cp->size) && dl_time_before(cp->elements[largest].dl,
+							cp->elements[r].dl))
+			largest = r;
+		if (largest == idx)
+			break;
+
+		/* Push idx down the heap one level and bump one up */
+		cpudl_exchange(cp, largest, idx);
+		idx = largest;
+	}
+}
+
+static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
+{
+	WARN_ON(idx > num_present_cpus() || idx == IDX_INVALID);
+
+	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
+		cp->elements[idx].dl = new_dl;
+		cpudl_heapify(cp, idx);
+	} else {
+		cp->elements[idx].dl = new_dl;
+		while (idx > 0 && dl_time_before(cp->elements[parent(idx)].dl,
+					cp->elements[idx].dl)) {
+			cpudl_exchange(cp, idx, parent(idx));
+			idx = parent(idx);
+		}
+	}
+}
+
+static inline int cpudl_maximum(struct cpudl *cp)
+{
+	return cp->elements[0].cpu;
+}
+
+/*
+ * cpudl_find - find the best (later-dl) CPU in the system
+ * @cp: the cpudl max-heap context
+ * @p: the task
+ * @later_mask: a mask to fill in with the selected CPUs (or NULL)
+ *
+ * Returns: int - best CPU (heap maximum if suitable)
+ */
+int cpudl_find(struct cpudl *cp, struct task_struct *p,
+	       struct cpumask *later_mask)
+{
+	int best_cpu = -1;
+	const struct sched_dl_entity *dl_se = &p->dl;
+
+	if (later_mask && cpumask_and(later_mask, cp->free_cpus,
+			&p->cpus_allowed) && cpumask_and(later_mask,
+			later_mask, cpu_active_mask)) {
+		best_cpu = cpumask_any(later_mask);
+		goto out;
+	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
+			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
+		best_cpu = cpudl_maximum(cp);
+		if (later_mask)
+			cpumask_set_cpu(best_cpu, later_mask);
+	}
+
+out:
+	WARN_ON(best_cpu > num_present_cpus() && best_cpu != -1);
+
+	return best_cpu;
+}
+
+/*
+ * cpudl_set - update the cpudl max-heap
+ * @cp: the cpudl max-heap context
+ * @cpu: the target cpu
+ * @dl: the new earliest deadline for this cpu
+ *
+ * Notes: assumes cpu_rq(cpu)->lock is locked
+ *
+ * Returns: (void)
+ */
+void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
+{
+	int old_idx, new_cpu;
+	unsigned long flags;
+
+	WARN_ON(cpu > num_present_cpus());
+
+	raw_spin_lock_irqsave(&cp->lock, flags);
+	old_idx = cp->cpu_to_idx[cpu];
+	if (!is_valid) {
+		/* remove item */
+		if (old_idx == IDX_INVALID) {
+			/*
+			 * Nothing to remove if old_idx was invalid.
+			 * This could happen if a rq_offline_dl is
+			 * called for a CPU without -dl tasks running.
+			 */
+			goto out;
+		}
+		new_cpu = cp->elements[cp->size - 1].cpu;
+		cp->elements[old_idx].dl = cp->elements[cp->size - 1].dl;
+		cp->elements[old_idx].cpu = new_cpu;
+		cp->size--;
+		cp->cpu_to_idx[new_cpu] = old_idx;
+		cp->cpu_to_idx[cpu] = IDX_INVALID;
+		while (old_idx > 0 && dl_time_before(
+				cp->elements[parent(old_idx)].dl,
+				cp->elements[old_idx].dl)) {
+			cpudl_exchange(cp, old_idx, parent(old_idx));
+			old_idx = parent(old_idx);
+		}
+		cpumask_set_cpu(cpu, cp->free_cpus);
+                cpudl_heapify(cp, old_idx);
+
+		goto out;
+	}
+
+	if (old_idx == IDX_INVALID) {
+		cp->size++;
+		cp->elements[cp->size - 1].dl = 0;
+		cp->elements[cp->size - 1].cpu = cpu;
+		cp->cpu_to_idx[cpu] = cp->size - 1;
+		cpudl_change_key(cp, cp->size - 1, dl);
+		cpumask_clear_cpu(cpu, cp->free_cpus);
+	} else {
+		cpudl_change_key(cp, old_idx, dl);
+	}
+
+out:
+	raw_spin_unlock_irqrestore(&cp->lock, flags);
+}
+
+/*
+ * cpudl_init - initialize the cpudl structure
+ * @cp: the cpudl max-heap context
+ */
+int cpudl_init(struct cpudl *cp)
+{
+	int i;
+
+	memset(cp, 0, sizeof(*cp));
+	raw_spin_lock_init(&cp->lock);
+	cp->size = 0;
+	for (i = 0; i < NR_CPUS; i++)
+		cp->cpu_to_idx[i] = IDX_INVALID;
+	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_setall(cp->free_cpus);
+
+	return 0;
+}
+
+/*
+ * cpudl_cleanup - clean up the cpudl structure
+ * @cp: the cpudl max-heap context
+ */
+void cpudl_cleanup(struct cpudl *cp)
+{
+	/*
+	 * nothing to do for the moment
+	 */
+}
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
new file mode 100644
index 0000000..a202789
--- /dev/null
+++ b/kernel/sched/cpudeadline.h
@@ -0,0 +1,33 @@
+#ifndef _LINUX_CPUDL_H
+#define _LINUX_CPUDL_H
+
+#include <linux/sched.h>
+
+#define IDX_INVALID     -1
+
+struct array_item {
+	u64 dl;
+	int cpu;
+};
+
+struct cpudl {
+	raw_spinlock_t lock;
+	int size;
+	int cpu_to_idx[NR_CPUS];
+	struct array_item elements[NR_CPUS];
+	cpumask_var_t free_cpus;
+};
+
+
+#ifdef CONFIG_SMP
+int cpudl_find(struct cpudl *cp, struct task_struct *p,
+	       struct cpumask *later_mask);
+void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
+int cpudl_init(struct cpudl *cp);
+void cpudl_cleanup(struct cpudl *cp);
+#else
+#define cpudl_set(cp, cpu, dl) do { } while (0)
+#define cpudl_init() do { } while (0)
+#endif /* CONFIG_SMP */
+
+#endif /* _LINUX_CPUDL_H */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
new file mode 100644
index 0000000..0de2482
--- /dev/null
+++ b/kernel/sched/deadline.c
@@ -0,0 +1,1640 @@
+/*
+ * Deadline Scheduling Class (SCHED_DEADLINE)
+ *
+ * Earliest Deadline First (EDF) + Constant Bandwidth Server (CBS).
+ *
+ * Tasks that periodically executes their instances for less than their
+ * runtime won't miss any of their deadlines.
+ * Tasks that are not periodic or sporadic or that tries to execute more
+ * than their reserved bandwidth will be slowed down (and may potentially
+ * miss some of their deadlines), and won't affect any other task.
+ *
+ * Copyright (C) 2012 Dario Faggioli <raistlin@linux.it>,
+ *                    Juri Lelli <juri.lelli@gmail.com>,
+ *                    Michael Trimarchi <michael@amarulasolutions.com>,
+ *                    Fabio Checconi <fchecconi@gmail.com>
+ */
+#include "sched.h"
+
+#include <linux/slab.h>
+
+struct dl_bandwidth def_dl_bandwidth;
+
+static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se)
+{
+	return container_of(dl_se, struct task_struct, dl);
+}
+
+static inline struct rq *rq_of_dl_rq(struct dl_rq *dl_rq)
+{
+	return container_of(dl_rq, struct rq, dl);
+}
+
+static inline struct dl_rq *dl_rq_of_se(struct sched_dl_entity *dl_se)
+{
+	struct task_struct *p = dl_task_of(dl_se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->dl;
+}
+
+static inline int on_dl_rq(struct sched_dl_entity *dl_se)
+{
+	return !RB_EMPTY_NODE(&dl_se->rb_node);
+}
+
+static inline int is_leftmost(struct task_struct *p, struct dl_rq *dl_rq)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	return dl_rq->rb_leftmost == &dl_se->rb_node;
+}
+
+void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime)
+{
+	raw_spin_lock_init(&dl_b->dl_runtime_lock);
+	dl_b->dl_period = period;
+	dl_b->dl_runtime = runtime;
+}
+
+extern unsigned long to_ratio(u64 period, u64 runtime);
+
+void init_dl_bw(struct dl_bw *dl_b)
+{
+	raw_spin_lock_init(&dl_b->lock);
+	raw_spin_lock(&def_dl_bandwidth.dl_runtime_lock);
+	if (global_rt_runtime() == RUNTIME_INF)
+		dl_b->bw = -1;
+	else
+		dl_b->bw = to_ratio(global_rt_period(), global_rt_runtime());
+	raw_spin_unlock(&def_dl_bandwidth.dl_runtime_lock);
+	dl_b->total_bw = 0;
+}
+
+void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
+{
+	dl_rq->rb_root = RB_ROOT;
+
+#ifdef CONFIG_SMP
+	/* zero means no -deadline tasks */
+	dl_rq->earliest_dl.curr = dl_rq->earliest_dl.next = 0;
+
+	dl_rq->dl_nr_migratory = 0;
+	dl_rq->overloaded = 0;
+	dl_rq->pushable_dl_tasks_root = RB_ROOT;
+#else
+	init_dl_bw(&dl_rq->dl_bw);
+#endif
+}
+
+#ifdef CONFIG_SMP
+
+static inline int dl_overloaded(struct rq *rq)
+{
+	return atomic_read(&rq->rd->dlo_count);
+}
+
+static inline void dl_set_overload(struct rq *rq)
+{
+	if (!rq->online)
+		return;
+
+	cpumask_set_cpu(rq->cpu, rq->rd->dlo_mask);
+	/*
+	 * Must be visible before the overload count is
+	 * set (as in sched_rt.c).
+	 *
+	 * Matched by the barrier in pull_dl_task().
+	 */
+	smp_wmb();
+	atomic_inc(&rq->rd->dlo_count);
+}
+
+static inline void dl_clear_overload(struct rq *rq)
+{
+	if (!rq->online)
+		return;
+
+	atomic_dec(&rq->rd->dlo_count);
+	cpumask_clear_cpu(rq->cpu, rq->rd->dlo_mask);
+}
+
+static void update_dl_migration(struct dl_rq *dl_rq)
+{
+	if (dl_rq->dl_nr_migratory && dl_rq->dl_nr_total > 1) {
+		if (!dl_rq->overloaded) {
+			dl_set_overload(rq_of_dl_rq(dl_rq));
+			dl_rq->overloaded = 1;
+		}
+	} else if (dl_rq->overloaded) {
+		dl_clear_overload(rq_of_dl_rq(dl_rq));
+		dl_rq->overloaded = 0;
+	}
+}
+
+static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
+{
+	struct task_struct *p = dl_task_of(dl_se);
+	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
+
+	dl_rq->dl_nr_total++;
+	if (p->nr_cpus_allowed > 1)
+		dl_rq->dl_nr_migratory++;
+
+	update_dl_migration(dl_rq);
+}
+
+static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
+{
+	struct task_struct *p = dl_task_of(dl_se);
+	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
+
+	dl_rq->dl_nr_total--;
+	if (p->nr_cpus_allowed > 1)
+		dl_rq->dl_nr_migratory--;
+
+	update_dl_migration(dl_rq);
+}
+
+/*
+ * The list of pushable -deadline task is not a plist, like in
+ * sched_rt.c, it is an rb-tree with tasks ordered by deadline.
+ */
+static void enqueue_pushable_dl_task(struct rq *rq, struct task_struct *p)
+{
+	struct dl_rq *dl_rq = &rq->dl;
+	struct rb_node **link = &dl_rq->pushable_dl_tasks_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct task_struct *entry;
+	int leftmost = 1;
+
+	BUG_ON(!RB_EMPTY_NODE(&p->pushable_dl_tasks));
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct task_struct,
+				 pushable_dl_tasks);
+		if (dl_entity_preempt(&p->dl, &entry->dl))
+			link = &parent->rb_left;
+		else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		dl_rq->pushable_dl_tasks_leftmost = &p->pushable_dl_tasks;
+
+	rb_link_node(&p->pushable_dl_tasks, parent, link);
+	rb_insert_color(&p->pushable_dl_tasks, &dl_rq->pushable_dl_tasks_root);
+}
+
+static void dequeue_pushable_dl_task(struct rq *rq, struct task_struct *p)
+{
+	struct dl_rq *dl_rq = &rq->dl;
+
+	if (RB_EMPTY_NODE(&p->pushable_dl_tasks))
+		return;
+
+	if (dl_rq->pushable_dl_tasks_leftmost == &p->pushable_dl_tasks) {
+		struct rb_node *next_node;
+
+		next_node = rb_next(&p->pushable_dl_tasks);
+		dl_rq->pushable_dl_tasks_leftmost = next_node;
+	}
+
+	rb_erase(&p->pushable_dl_tasks, &dl_rq->pushable_dl_tasks_root);
+	RB_CLEAR_NODE(&p->pushable_dl_tasks);
+}
+
+static inline int has_pushable_dl_tasks(struct rq *rq)
+{
+	return !RB_EMPTY_ROOT(&rq->dl.pushable_dl_tasks_root);
+}
+
+static int push_dl_task(struct rq *rq);
+
+#else
+
+static inline
+void enqueue_pushable_dl_task(struct rq *rq, struct task_struct *p)
+{
+}
+
+static inline
+void dequeue_pushable_dl_task(struct rq *rq, struct task_struct *p)
+{
+}
+
+static inline
+void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
+{
+}
+
+static inline
+void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
+{
+}
+
+#endif /* CONFIG_SMP */
+
+static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
+static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags);
+static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
+				  int flags);
+
+/*
+ * We are being explicitly informed that a new instance is starting,
+ * and this means that:
+ *  - the absolute deadline of the entity has to be placed at
+ *    current time + relative deadline;
+ *  - the runtime of the entity has to be set to the maximum value.
+ *
+ * The capability of specifying such event is useful whenever a -deadline
+ * entity wants to (try to!) synchronize its behaviour with the scheduler's
+ * one, and to (try to!) reconcile itself with its own scheduling
+ * parameters.
+ */
+static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se,
+				       struct sched_dl_entity *pi_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
+
+	/*
+	 * We use the regular wall clock time to set deadlines in the
+	 * future; in fact, we must consider execution overheads (time
+	 * spent on hardirq context, etc.).
+	 */
+	dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+	dl_se->runtime = pi_se->dl_runtime;
+	dl_se->dl_new = 0;
+}
+
+/*
+ * Pure Earliest Deadline First (EDF) scheduling does not deal with the
+ * possibility of a entity lasting more than what it declared, and thus
+ * exhausting its runtime.
+ *
+ * Here we are interested in making runtime overrun possible, but we do
+ * not want a entity which is misbehaving to affect the scheduling of all
+ * other entities.
+ * Therefore, a budgeting strategy called Constant Bandwidth Server (CBS)
+ * is used, in order to confine each entity within its own bandwidth.
+ *
+ * This function deals exactly with that, and ensures that when the runtime
+ * of a entity is replenished, its deadline is also postponed. That ensures
+ * the overrunning entity can't interfere with other entity in the system and
+ * can't make them miss their deadlines. Reasons why this kind of overruns
+ * could happen are, typically, a entity voluntarily trying to overcome its
+ * runtime, or it just underestimated it during sched_setscheduler_ex().
+ */
+static void replenish_dl_entity(struct sched_dl_entity *dl_se,
+				struct sched_dl_entity *pi_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	BUG_ON(pi_se->dl_runtime <= 0);
+
+	/*
+	 * This could be the case for a !-dl task that is boosted.
+	 * Just go with full inherited parameters.
+	 */
+	if (dl_se->dl_deadline == 0) {
+		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
+	}
+
+	/*
+	 * We keep moving the deadline away until we get some
+	 * available runtime for the entity. This ensures correct
+	 * handling of situations where the runtime overrun is
+	 * arbitrary large.
+	 */
+	while (dl_se->runtime <= 0) {
+		dl_se->deadline += pi_se->dl_period;
+		dl_se->runtime += pi_se->dl_runtime;
+	}
+
+	/*
+	 * At this point, the deadline really should be "in
+	 * the future" with respect to rq->clock. If it's
+	 * not, we are, for some reason, lagging too much!
+	 * Anyway, after having warn userspace abut that,
+	 * we still try to keep the things running by
+	 * resetting the deadline and the budget of the
+	 * entity.
+	 */
+	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
+		static bool lag_once = false;
+
+		if (!lag_once) {
+			lag_once = true;
+			printk_sched("sched: DL replenish lagged to much\n");
+		}
+		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
+	}
+}
+
+/*
+ * Here we check if --at time t-- an entity (which is probably being
+ * [re]activated or, in general, enqueued) can use its remaining runtime
+ * and its current deadline _without_ exceeding the bandwidth it is
+ * assigned (function returns true if it can't). We are in fact applying
+ * one of the CBS rules: when a task wakes up, if the residual runtime
+ * over residual deadline fits within the allocated bandwidth, then we
+ * can keep the current (absolute) deadline and residual budget without
+ * disrupting the schedulability of the system. Otherwise, we should
+ * refill the runtime and set the deadline a period in the future,
+ * because keeping the current (absolute) deadline of the task would
+ * result in breaking guarantees promised to other tasks.
+ *
+ * This function returns true if:
+ *
+ *   runtime / (deadline - t) > dl_runtime / dl_period ,
+ *
+ * IOW we can't recycle current parameters.
+ *
+ * Notice that the bandwidth check is done against the period. For
+ * task with deadline equal to period this is the same of using
+ * dl_deadline instead of dl_period in the equation above.
+ */
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
+			       struct sched_dl_entity *pi_se, u64 t)
+{
+	u64 left, right;
+
+	/*
+	 * left and right are the two sides of the equation above,
+	 * after a bit of shuffling to use multiplications instead
+	 * of divisions.
+	 *
+	 * Note that none of the time values involved in the two
+	 * multiplications are absolute: dl_deadline and dl_runtime
+	 * are the relative deadline and the maximum runtime of each
+	 * instance, runtime is the runtime left for the last instance
+	 * and (deadline - t), since t is rq->clock, is the time left
+	 * to the (absolute) deadline. Even if overflowing the u64 type
+	 * is very unlikely to occur in both cases, here we scale down
+	 * as we want to avoid that risk at all. Scaling down by 10
+	 * means that we reduce granularity to 1us. We are fine with it,
+	 * since this is only a true/false check and, anyway, thinking
+	 * of anything below microseconds resolution is actually fiction
+	 * (but still we want to give the user that illusion >;).
+	 */
+	left = (pi_se->dl_period >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
+	right = ((dl_se->deadline - t) >> DL_SCALE) *
+		(pi_se->dl_runtime >> DL_SCALE);
+
+	return dl_time_before(right, left);
+}
+
+/*
+ * When a -deadline entity is queued back on the runqueue, its runtime and
+ * deadline might need updating.
+ *
+ * The policy here is that we update the deadline of the entity only if:
+ *  - the current deadline is in the past,
+ *  - using the remaining runtime with the current deadline would make
+ *    the entity exceed its bandwidth.
+ */
+static void update_dl_entity(struct sched_dl_entity *dl_se,
+			     struct sched_dl_entity *pi_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	/*
+	 * The arrival of a new instance needs special treatment, i.e.,
+	 * the actual scheduling parameters have to be "renewed".
+	 */
+	if (dl_se->dl_new) {
+		setup_new_dl_entity(dl_se, pi_se);
+		return;
+	}
+
+	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
+	    dl_entity_overflow(dl_se, pi_se, rq_clock(rq))) {
+		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
+	}
+}
+
+/*
+ * If the entity depleted all its runtime, and if we want it to sleep
+ * while waiting for some new execution time to become available, we
+ * set the bandwidth enforcement timer to the replenishment instant
+ * and try to activate it.
+ *
+ * Notice that it is important for the caller to know if the timer
+ * actually started or not (i.e., the replenishment instant is in
+ * the future or in the past).
+ */
+static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+	ktime_t now, act;
+	ktime_t soft, hard;
+	unsigned long range;
+	s64 delta;
+
+	if (boosted)
+		return 0;
+	/*
+	 * We want the timer to fire at the deadline, but considering
+	 * that it is actually coming from rq->clock and not from
+	 * hrtimer's time base reading.
+	 */
+	act = ns_to_ktime(dl_se->deadline);
+	now = hrtimer_cb_get_time(&dl_se->dl_timer);
+	delta = ktime_to_ns(now) - rq_clock(rq);
+	act = ktime_add_ns(act, delta);
+
+	/*
+	 * If the expiry time already passed, e.g., because the value
+	 * chosen as the deadline is too small, don't even try to
+	 * start the timer in the past!
+	 */
+	if (ktime_us_delta(act, now) < 0)
+		return 0;
+
+	hrtimer_set_expires(&dl_se->dl_timer, act);
+
+	soft = hrtimer_get_softexpires(&dl_se->dl_timer);
+	hard = hrtimer_get_expires(&dl_se->dl_timer);
+	range = ktime_to_ns(ktime_sub(hard, soft));
+	__hrtimer_start_range_ns(&dl_se->dl_timer, soft,
+				 range, HRTIMER_MODE_ABS, 0);
+
+	return hrtimer_active(&dl_se->dl_timer);
+}
+
+/*
+ * This is the bandwidth enforcement timer callback. If here, we know
+ * a task is not on its dl_rq, since the fact that the timer was running
+ * means the task is throttled and needs a runtime replenishment.
+ *
+ * However, what we actually do depends on the fact the task is active,
+ * (it is on its rq) or has been removed from there by a call to
+ * dequeue_task_dl(). In the former case we must issue the runtime
+ * replenishment and add the task back to the dl_rq; in the latter, we just
+ * do nothing but clearing dl_throttled, so that runtime and deadline
+ * updating (and the queueing back to dl_rq) will be done by the
+ * next call to enqueue_task_dl().
+ */
+static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
+{
+	struct sched_dl_entity *dl_se = container_of(timer,
+						     struct sched_dl_entity,
+						     dl_timer);
+	struct task_struct *p = dl_task_of(dl_se);
+	struct rq *rq = task_rq(p);
+	raw_spin_lock(&rq->lock);
+
+	/*
+	 * We need to take care of a possible races here. In fact, the
+	 * task might have changed its scheduling policy to something
+	 * different from SCHED_DEADLINE or changed its reservation
+	 * parameters (through sched_setscheduler()).
+	 */
+	if (!dl_task(p) || dl_se->dl_new)
+		goto unlock;
+
+	sched_clock_tick();
+	update_rq_clock(rq);
+	dl_se->dl_throttled = 0;
+	if (p->on_rq) {
+		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
+		if (task_has_dl_policy(rq->curr))
+			check_preempt_curr_dl(rq, p, 0);
+		else
+			resched_task(rq->curr);
+#ifdef CONFIG_SMP
+		/*
+		 * Queueing this task back might have overloaded rq,
+		 * check if we need to kick someone away.
+		 */
+		if (has_pushable_dl_tasks(rq))
+			push_dl_task(rq);
+#endif
+	}
+unlock:
+	raw_spin_unlock(&rq->lock);
+
+	return HRTIMER_NORESTART;
+}
+
+void init_dl_task_timer(struct sched_dl_entity *dl_se)
+{
+	struct hrtimer *timer = &dl_se->dl_timer;
+
+	if (hrtimer_active(timer)) {
+		hrtimer_try_to_cancel(timer);
+		return;
+	}
+
+	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	timer->function = dl_task_timer;
+}
+
+static
+int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+	int dmiss = dl_time_before(dl_se->deadline, rq_clock(rq));
+	int rorun = dl_se->runtime <= 0;
+
+	if (!rorun && !dmiss)
+		return 0;
+
+	/*
+	 * If we are beyond our current deadline and we are still
+	 * executing, then we have already used some of the runtime of
+	 * the next instance. Thus, if we do not account that, we are
+	 * stealing bandwidth from the system at each deadline miss!
+	 */
+	if (dmiss) {
+		dl_se->runtime = rorun ? dl_se->runtime : 0;
+		dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
+	}
+
+	return 1;
+}
+
+/*
+ * Update the current task's runtime statistics (provided it is still
+ * a -deadline task and has not been removed from the dl_rq).
+ */
+static void update_curr_dl(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+	struct sched_dl_entity *dl_se = &curr->dl;
+	u64 delta_exec;
+
+	if (!dl_task(curr) || !on_dl_rq(dl_se))
+		return;
+
+	/*
+	 * Consumed budget is computed considering the time as
+	 * observed by schedulable tasks (excluding time spent
+	 * in hardirq context, etc.). Deadlines are instead
+	 * computed using hard walltime. This seems to be the more
+	 * natural solution, but the full ramifications of this
+	 * approach need further study.
+	 */
+	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+		      max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start = rq_clock_task(rq);
+	cpuacct_charge(curr, delta_exec);
+
+	sched_rt_avg_update(rq, delta_exec);
+
+	dl_se->runtime -= delta_exec;
+	if (dl_runtime_exceeded(rq, dl_se)) {
+		__dequeue_task_dl(rq, curr, 0);
+		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
+			dl_se->dl_throttled = 1;
+		else
+			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
+
+		if (!is_leftmost(curr, &rq->dl))
+			resched_task(curr);
+	}
+
+	/*
+	 * Because -- for now -- we share the rt bandwidth, we need to
+	 * account our runtime there too, otherwise actual rt tasks
+	 * would be able to exceed the shared quota.
+	 *
+	 * Account to the root rt group for now.
+	 *
+	 * The solution we're working towards is having the RT groups scheduled
+	 * using deadline servers -- however there's a few nasties to figure
+	 * out before that can happen.
+	 */
+	if (rt_bandwidth_enabled()) {
+		struct rt_rq *rt_rq = &rq->rt;
+
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_time += delta_exec;
+		/*
+		 * We'll let actual RT tasks worry about the overflow here, we
+		 * have our own CBS to keep us inline -- see above.
+		 */
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+	}
+}
+
+#ifdef CONFIG_SMP
+
+static struct task_struct *pick_next_earliest_dl_task(struct rq *rq, int cpu);
+
+static inline u64 next_deadline(struct rq *rq)
+{
+	struct task_struct *next = pick_next_earliest_dl_task(rq, rq->cpu);
+
+	if (next && dl_prio(next->prio))
+		return next->dl.deadline;
+	else
+		return 0;
+}
+
+static void inc_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
+{
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	if (dl_rq->earliest_dl.curr == 0 ||
+	    dl_time_before(deadline, dl_rq->earliest_dl.curr)) {
+		/*
+		 * If the dl_rq had no -deadline tasks, or if the new task
+		 * has shorter deadline than the current one on dl_rq, we
+		 * know that the previous earliest becomes our next earliest,
+		 * as the new task becomes the earliest itself.
+		 */
+		dl_rq->earliest_dl.next = dl_rq->earliest_dl.curr;
+		dl_rq->earliest_dl.curr = deadline;
+		cpudl_set(&rq->rd->cpudl, rq->cpu, deadline, 1);
+	} else if (dl_rq->earliest_dl.next == 0 ||
+		   dl_time_before(deadline, dl_rq->earliest_dl.next)) {
+		/*
+		 * On the other hand, if the new -deadline task has a
+		 * a later deadline than the earliest one on dl_rq, but
+		 * it is earlier than the next (if any), we must
+		 * recompute the next-earliest.
+		 */
+		dl_rq->earliest_dl.next = next_deadline(rq);
+	}
+}
+
+static void dec_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
+{
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	/*
+	 * Since we may have removed our earliest (and/or next earliest)
+	 * task we must recompute them.
+	 */
+	if (!dl_rq->dl_nr_running) {
+		dl_rq->earliest_dl.curr = 0;
+		dl_rq->earliest_dl.next = 0;
+		cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
+	} else {
+		struct rb_node *leftmost = dl_rq->rb_leftmost;
+		struct sched_dl_entity *entry;
+
+		entry = rb_entry(leftmost, struct sched_dl_entity, rb_node);
+		dl_rq->earliest_dl.curr = entry->deadline;
+		dl_rq->earliest_dl.next = next_deadline(rq);
+		cpudl_set(&rq->rd->cpudl, rq->cpu, entry->deadline, 1);
+	}
+}
+
+#else
+
+static inline void inc_dl_deadline(struct dl_rq *dl_rq, u64 deadline) {}
+static inline void dec_dl_deadline(struct dl_rq *dl_rq, u64 deadline) {}
+
+#endif /* CONFIG_SMP */
+
+static inline
+void inc_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
+{
+	int prio = dl_task_of(dl_se)->prio;
+	u64 deadline = dl_se->deadline;
+
+	WARN_ON(!dl_prio(prio));
+	dl_rq->dl_nr_running++;
+
+	inc_dl_deadline(dl_rq, deadline);
+	inc_dl_migration(dl_se, dl_rq);
+}
+
+static inline
+void dec_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
+{
+	int prio = dl_task_of(dl_se)->prio;
+
+	WARN_ON(!dl_prio(prio));
+	WARN_ON(!dl_rq->dl_nr_running);
+	dl_rq->dl_nr_running--;
+
+	dec_dl_deadline(dl_rq, dl_se->deadline);
+	dec_dl_migration(dl_se, dl_rq);
+}
+
+static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rb_node **link = &dl_rq->rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct sched_dl_entity *entry;
+	int leftmost = 1;
+
+	BUG_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct sched_dl_entity, rb_node);
+		if (dl_time_before(dl_se->deadline, entry->deadline))
+			link = &parent->rb_left;
+		else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		dl_rq->rb_leftmost = &dl_se->rb_node;
+
+	rb_link_node(&dl_se->rb_node, parent, link);
+	rb_insert_color(&dl_se->rb_node, &dl_rq->rb_root);
+
+	inc_dl_tasks(dl_se, dl_rq);
+}
+
+static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+
+	if (RB_EMPTY_NODE(&dl_se->rb_node))
+		return;
+
+	if (dl_rq->rb_leftmost == &dl_se->rb_node) {
+		struct rb_node *next_node;
+
+		next_node = rb_next(&dl_se->rb_node);
+		dl_rq->rb_leftmost = next_node;
+	}
+
+	rb_erase(&dl_se->rb_node, &dl_rq->rb_root);
+	RB_CLEAR_NODE(&dl_se->rb_node);
+
+	dec_dl_tasks(dl_se, dl_rq);
+}
+
+static void
+enqueue_dl_entity(struct sched_dl_entity *dl_se,
+		  struct sched_dl_entity *pi_se, int flags)
+{
+	BUG_ON(on_dl_rq(dl_se));
+
+	/*
+	 * If this is a wakeup or a new instance, the scheduling
+	 * parameters of the task might need updating. Otherwise,
+	 * we want a replenishment of its runtime.
+	 */
+	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
+		replenish_dl_entity(dl_se, pi_se);
+	else
+		update_dl_entity(dl_se, pi_se);
+
+	__enqueue_dl_entity(dl_se);
+}
+
+static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	__dequeue_dl_entity(dl_se);
+}
+
+static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+{
+	struct task_struct *pi_task = rt_mutex_get_top_task(p);
+	struct sched_dl_entity *pi_se = &p->dl;
+
+	/*
+	 * Use the scheduling parameters of the top pi-waiter
+	 * task if we have one and its (relative) deadline is
+	 * smaller than our one... OTW we keep our runtime and
+	 * deadline.
+	 */
+	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio))
+		pi_se = &pi_task->dl;
+
+	/*
+	 * If p is throttled, we do nothing. In fact, if it exhausted
+	 * its budget it needs a replenishment and, since it now is on
+	 * its rq, the bandwidth timer callback (which clearly has not
+	 * run yet) will take care of this.
+	 */
+	if (p->dl.dl_throttled)
+		return;
+
+	enqueue_dl_entity(&p->dl, pi_se, flags);
+
+	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
+		enqueue_pushable_dl_task(rq, p);
+
+	inc_nr_running(rq);
+}
+
+static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+{
+	dequeue_dl_entity(&p->dl);
+	dequeue_pushable_dl_task(rq, p);
+}
+
+static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+{
+	update_curr_dl(rq);
+	__dequeue_task_dl(rq, p, flags);
+
+	dec_nr_running(rq);
+}
+
+/*
+ * Yield task semantic for -deadline tasks is:
+ *
+ *   get off from the CPU until our next instance, with
+ *   a new runtime. This is of little use now, since we
+ *   don't have a bandwidth reclaiming mechanism. Anyway,
+ *   bandwidth reclaiming is planned for the future, and
+ *   yield_task_dl will indicate that some spare budget
+ *   is available for other task instances to use it.
+ */
+static void yield_task_dl(struct rq *rq)
+{
+	struct task_struct *p = rq->curr;
+
+	/*
+	 * We make the task go to sleep until its current deadline by
+	 * forcing its runtime to zero. This way, update_curr_dl() stops
+	 * it and the bandwidth timer will wake it up and will give it
+	 * new scheduling parameters (thanks to dl_new=1).
+	 */
+	if (p->dl.runtime > 0) {
+		rq->curr->dl.dl_new = 1;
+		p->dl.runtime = 0;
+	}
+	update_curr_dl(rq);
+}
+
+#ifdef CONFIG_SMP
+
+static int find_later_rq(struct task_struct *task);
+
+static int
+select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
+{
+	struct task_struct *curr;
+	struct rq *rq;
+
+	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
+		goto out;
+
+	rq = cpu_rq(cpu);
+
+	rcu_read_lock();
+	curr = ACCESS_ONCE(rq->curr); /* unlocked access */
+
+	/*
+	 * If we are dealing with a -deadline task, we must
+	 * decide where to wake it up.
+	 * If it has a later deadline and the current task
+	 * on this rq can't move (provided the waking task
+	 * can!) we prefer to send it somewhere else. On the
+	 * other hand, if it has a shorter deadline, we
+	 * try to make it stay here, it might be important.
+	 */
+	if (unlikely(dl_task(curr)) &&
+	    (curr->nr_cpus_allowed < 2 ||
+	     !dl_entity_preempt(&p->dl, &curr->dl)) &&
+	    (p->nr_cpus_allowed > 1)) {
+		int target = find_later_rq(p);
+
+		if (target != -1)
+			cpu = target;
+	}
+	rcu_read_unlock();
+
+out:
+	return cpu;
+}
+
+static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
+{
+	/*
+	 * Current can't be migrated, useless to reschedule,
+	 * let's hope p can move out.
+	 */
+	if (rq->curr->nr_cpus_allowed == 1 ||
+	    cpudl_find(&rq->rd->cpudl, rq->curr, NULL) == -1)
+		return;
+
+	/*
+	 * p is migratable, so let's not schedule it and
+	 * see if it is pushed or pulled somewhere else.
+	 */
+	if (p->nr_cpus_allowed != 1 &&
+	    cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
+		return;
+
+	resched_task(rq->curr);
+}
+
+#endif /* CONFIG_SMP */
+
+/*
+ * Only called when both the current and waking task are -deadline
+ * tasks.
+ */
+static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
+				  int flags)
+{
+	if (dl_entity_preempt(&p->dl, &rq->curr->dl)) {
+		resched_task(rq->curr);
+		return;
+	}
+
+#ifdef CONFIG_SMP
+	/*
+	 * In the unlikely case current and p have the same deadline
+	 * let us try to decide what's the best thing to do...
+	 */
+	if ((p->dl.deadline == rq->curr->dl.deadline) &&
+	    !test_tsk_need_resched(rq->curr))
+		check_preempt_equal_dl(rq, p);
+#endif /* CONFIG_SMP */
+}
+
+#ifdef CONFIG_SCHED_HRTICK
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+	s64 delta = p->dl.dl_runtime - p->dl.runtime;
+
+	if (delta > 10000)
+		hrtick_start(rq, p->dl.runtime);
+}
+#endif
+
+static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
+						   struct dl_rq *dl_rq)
+{
+	struct rb_node *left = dl_rq->rb_leftmost;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct sched_dl_entity, rb_node);
+}
+
+struct task_struct *pick_next_task_dl(struct rq *rq)
+{
+	struct sched_dl_entity *dl_se;
+	struct task_struct *p;
+	struct dl_rq *dl_rq;
+
+	dl_rq = &rq->dl;
+
+	if (unlikely(!dl_rq->dl_nr_running))
+		return NULL;
+
+	dl_se = pick_next_dl_entity(rq, dl_rq);
+	BUG_ON(!dl_se);
+
+	p = dl_task_of(dl_se);
+	p->se.exec_start = rq_clock_task(rq);
+
+	/* Running task will never be pushed. */
+       dequeue_pushable_dl_task(rq, p);
+
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq))
+		start_hrtick_dl(rq, p);
+#endif
+
+#ifdef CONFIG_SMP
+	rq->post_schedule = has_pushable_dl_tasks(rq);
+#endif /* CONFIG_SMP */
+
+	return p;
+}
+
+static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
+{
+	update_curr_dl(rq);
+
+	if (on_dl_rq(&p->dl) && p->nr_cpus_allowed > 1)
+		enqueue_pushable_dl_task(rq, p);
+}
+
+static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
+{
+	update_curr_dl(rq);
+
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
+		start_hrtick_dl(rq, p);
+#endif
+}
+
+static void task_fork_dl(struct task_struct *p)
+{
+	/*
+	 * SCHED_DEADLINE tasks cannot fork and this is achieved through
+	 * sched_fork()
+	 */
+}
+
+static void task_dead_dl(struct task_struct *p)
+{
+	struct hrtimer *timer = &p->dl.dl_timer;
+	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
+
+	/*
+	 * Since we are TASK_DEAD we won't slip out of the domain!
+	 */
+	raw_spin_lock_irq(&dl_b->lock);
+	dl_b->total_bw -= p->dl.dl_bw;
+	raw_spin_unlock_irq(&dl_b->lock);
+
+	hrtimer_cancel(timer);
+}
+
+static void set_curr_task_dl(struct rq *rq)
+{
+	struct task_struct *p = rq->curr;
+
+	p->se.exec_start = rq_clock_task(rq);
+
+	/* You can't push away the running task */
+	dequeue_pushable_dl_task(rq, p);
+}
+
+#ifdef CONFIG_SMP
+
+/* Only try algorithms three times */
+#define DL_MAX_TRIES 3
+
+static int pick_dl_task(struct rq *rq, struct task_struct *p, int cpu)
+{
+	if (!task_running(rq, p) &&
+	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
+	    (p->nr_cpus_allowed > 1))
+		return 1;
+
+	return 0;
+}
+
+/* Returns the second earliest -deadline task, NULL otherwise */
+static struct task_struct *pick_next_earliest_dl_task(struct rq *rq, int cpu)
+{
+	struct rb_node *next_node = rq->dl.rb_leftmost;
+	struct sched_dl_entity *dl_se;
+	struct task_struct *p = NULL;
+
+next_node:
+	next_node = rb_next(next_node);
+	if (next_node) {
+		dl_se = rb_entry(next_node, struct sched_dl_entity, rb_node);
+		p = dl_task_of(dl_se);
+
+		if (pick_dl_task(rq, p, cpu))
+			return p;
+
+		goto next_node;
+	}
+
+	return NULL;
+}
+
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
+
+static int find_later_rq(struct task_struct *task)
+{
+	struct sched_domain *sd;
+	struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
+	int this_cpu = smp_processor_id();
+	int best_cpu, cpu = task_cpu(task);
+
+	/* Make sure the mask is initialized first */
+	if (unlikely(!later_mask))
+		return -1;
+
+	if (task->nr_cpus_allowed == 1)
+		return -1;
+
+	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
+			task, later_mask);
+	if (best_cpu == -1)
+		return -1;
+
+	/*
+	 * If we are here, some target has been found,
+	 * the most suitable of which is cached in best_cpu.
+	 * This is, among the runqueues where the current tasks
+	 * have later deadlines than the task's one, the rq
+	 * with the latest possible one.
+	 *
+	 * Now we check how well this matches with task's
+	 * affinity and system topology.
+	 *
+	 * The last cpu where the task run is our first
+	 * guess, since it is most likely cache-hot there.
+	 */
+	if (cpumask_test_cpu(cpu, later_mask))
+		return cpu;
+	/*
+	 * Check if this_cpu is to be skipped (i.e., it is
+	 * not in the mask) or not.
+	 */
+	if (!cpumask_test_cpu(this_cpu, later_mask))
+		this_cpu = -1;
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		if (sd->flags & SD_WAKE_AFFINE) {
+
+			/*
+			 * If possible, preempting this_cpu is
+			 * cheaper than migrating.
+			 */
+			if (this_cpu != -1 &&
+			    cpumask_test_cpu(this_cpu, sched_domain_span(sd))) {
+				rcu_read_unlock();
+				return this_cpu;
+			}
+
+			/*
+			 * Last chance: if best_cpu is valid and is
+			 * in the mask, that becomes our choice.
+			 */
+			if (best_cpu < nr_cpu_ids &&
+			    cpumask_test_cpu(best_cpu, sched_domain_span(sd))) {
+				rcu_read_unlock();
+				return best_cpu;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	/*
+	 * At this point, all our guesses failed, we just return
+	 * 'something', and let the caller sort the things out.
+	 */
+	if (this_cpu != -1)
+		return this_cpu;
+
+	cpu = cpumask_any(later_mask);
+	if (cpu < nr_cpu_ids)
+		return cpu;
+
+	return -1;
+}
+
+/* Locks the rq it finds */
+static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq)
+{
+	struct rq *later_rq = NULL;
+	int tries;
+	int cpu;
+
+	for (tries = 0; tries < DL_MAX_TRIES; tries++) {
+		cpu = find_later_rq(task);
+
+		if ((cpu == -1) || (cpu == rq->cpu))
+			break;
+
+		later_rq = cpu_rq(cpu);
+
+		/* Retry if something changed. */
+		if (double_lock_balance(rq, later_rq)) {
+			if (unlikely(task_rq(task) != rq ||
+				     !cpumask_test_cpu(later_rq->cpu,
+				                       &task->cpus_allowed) ||
+				     task_running(rq, task) || !task->on_rq)) {
+				double_unlock_balance(rq, later_rq);
+				later_rq = NULL;
+				break;
+			}
+		}
+
+		/*
+		 * If the rq we found has no -deadline task, or
+		 * its earliest one has a later deadline than our
+		 * task, the rq is a good one.
+		 */
+		if (!later_rq->dl.dl_nr_running ||
+		    dl_time_before(task->dl.deadline,
+				   later_rq->dl.earliest_dl.curr))
+			break;
+
+		/* Otherwise we try again. */
+		double_unlock_balance(rq, later_rq);
+		later_rq = NULL;
+	}
+
+	return later_rq;
+}
+
+static struct task_struct *pick_next_pushable_dl_task(struct rq *rq)
+{
+	struct task_struct *p;
+
+	if (!has_pushable_dl_tasks(rq))
+		return NULL;
+
+	p = rb_entry(rq->dl.pushable_dl_tasks_leftmost,
+		     struct task_struct, pushable_dl_tasks);
+
+	BUG_ON(rq->cpu != task_cpu(p));
+	BUG_ON(task_current(rq, p));
+	BUG_ON(p->nr_cpus_allowed <= 1);
+
+	BUG_ON(!p->on_rq);
+	BUG_ON(!dl_task(p));
+
+	return p;
+}
+
+/*
+ * See if the non running -deadline tasks on this rq
+ * can be sent to some other CPU where they can preempt
+ * and start executing.
+ */
+static int push_dl_task(struct rq *rq)
+{
+	struct task_struct *next_task;
+	struct rq *later_rq;
+
+	if (!rq->dl.overloaded)
+		return 0;
+
+	next_task = pick_next_pushable_dl_task(rq);
+	if (!next_task)
+		return 0;
+
+retry:
+	if (unlikely(next_task == rq->curr)) {
+		WARN_ON(1);
+		return 0;
+	}
+
+	/*
+	 * If next_task preempts rq->curr, and rq->curr
+	 * can move away, it makes sense to just reschedule
+	 * without going further in pushing next_task.
+	 */
+	if (dl_task(rq->curr) &&
+	    dl_time_before(next_task->dl.deadline, rq->curr->dl.deadline) &&
+	    rq->curr->nr_cpus_allowed > 1) {
+		resched_task(rq->curr);
+		return 0;
+	}
+
+	/* We might release rq lock */
+	get_task_struct(next_task);
+
+	/* Will lock the rq it'll find */
+	later_rq = find_lock_later_rq(next_task, rq);
+	if (!later_rq) {
+		struct task_struct *task;
+
+		/*
+		 * We must check all this again, since
+		 * find_lock_later_rq releases rq->lock and it is
+		 * then possible that next_task has migrated.
+		 */
+		task = pick_next_pushable_dl_task(rq);
+		if (task_cpu(next_task) == rq->cpu && task == next_task) {
+			/*
+			 * The task is still there. We don't try
+			 * again, some other cpu will pull it when ready.
+			 */
+			dequeue_pushable_dl_task(rq, next_task);
+			goto out;
+		}
+
+		if (!task)
+			/* No more tasks */
+			goto out;
+
+		put_task_struct(next_task);
+		next_task = task;
+		goto retry;
+	}
+
+	deactivate_task(rq, next_task, 0);
+	set_task_cpu(next_task, later_rq->cpu);
+	activate_task(later_rq, next_task, 0);
+
+	resched_task(later_rq->curr);
+
+	double_unlock_balance(rq, later_rq);
+
+out:
+	put_task_struct(next_task);
+
+	return 1;
+}
+
+static void push_dl_tasks(struct rq *rq)
+{
+	/* Terminates as it moves a -deadline task */
+	while (push_dl_task(rq))
+		;
+}
+
+static int pull_dl_task(struct rq *this_rq)
+{
+	int this_cpu = this_rq->cpu, ret = 0, cpu;
+	struct task_struct *p;
+	struct rq *src_rq;
+	u64 dmin = LONG_MAX;
+
+	if (likely(!dl_overloaded(this_rq)))
+		return 0;
+
+	/*
+	 * Match the barrier from dl_set_overloaded; this guarantees that if we
+	 * see overloaded we must also see the dlo_mask bit.
+	 */
+	smp_rmb();
+
+	for_each_cpu(cpu, this_rq->rd->dlo_mask) {
+		if (this_cpu == cpu)
+			continue;
+
+		src_rq = cpu_rq(cpu);
+
+		/*
+		 * It looks racy, abd it is! However, as in sched_rt.c,
+		 * we are fine with this.
+		 */
+		if (this_rq->dl.dl_nr_running &&
+		    dl_time_before(this_rq->dl.earliest_dl.curr,
+				   src_rq->dl.earliest_dl.next))
+			continue;
+
+		/* Might drop this_rq->lock */
+		double_lock_balance(this_rq, src_rq);
+
+		/*
+		 * If there are no more pullable tasks on the
+		 * rq, we're done with it.
+		 */
+		if (src_rq->dl.dl_nr_running <= 1)
+			goto skip;
+
+		p = pick_next_earliest_dl_task(src_rq, this_cpu);
+
+		/*
+		 * We found a task to be pulled if:
+		 *  - it preempts our current (if there's one),
+		 *  - it will preempt the last one we pulled (if any).
+		 */
+		if (p && dl_time_before(p->dl.deadline, dmin) &&
+		    (!this_rq->dl.dl_nr_running ||
+		     dl_time_before(p->dl.deadline,
+				    this_rq->dl.earliest_dl.curr))) {
+			WARN_ON(p == src_rq->curr);
+			WARN_ON(!p->on_rq);
+
+			/*
+			 * Then we pull iff p has actually an earlier
+			 * deadline than the current task of its runqueue.
+			 */
+			if (dl_time_before(p->dl.deadline,
+					   src_rq->curr->dl.deadline))
+				goto skip;
+
+			ret = 1;
+
+			deactivate_task(src_rq, p, 0);
+			set_task_cpu(p, this_cpu);
+			activate_task(this_rq, p, 0);
+			dmin = p->dl.deadline;
+
+			/* Is there any other task even earlier? */
+		}
+skip:
+		double_unlock_balance(this_rq, src_rq);
+	}
+
+	return ret;
+}
+
+static void pre_schedule_dl(struct rq *rq, struct task_struct *prev)
+{
+	/* Try to pull other tasks here */
+	if (dl_task(prev))
+		pull_dl_task(rq);
+}
+
+static void post_schedule_dl(struct rq *rq)
+{
+	push_dl_tasks(rq);
+}
+
+/*
+ * Since the task is not running and a reschedule is not going to happen
+ * anytime soon on its runqueue, we try pushing it away now.
+ */
+static void task_woken_dl(struct rq *rq, struct task_struct *p)
+{
+	if (!task_running(rq, p) &&
+	    !test_tsk_need_resched(rq->curr) &&
+	    has_pushable_dl_tasks(rq) &&
+	    p->nr_cpus_allowed > 1 &&
+	    dl_task(rq->curr) &&
+	    (rq->curr->nr_cpus_allowed < 2 ||
+	     dl_entity_preempt(&rq->curr->dl, &p->dl))) {
+		push_dl_tasks(rq);
+	}
+}
+
+static void set_cpus_allowed_dl(struct task_struct *p,
+				const struct cpumask *new_mask)
+{
+	struct rq *rq;
+	int weight;
+
+	BUG_ON(!dl_task(p));
+
+	/*
+	 * Update only if the task is actually running (i.e.,
+	 * it is on the rq AND it is not throttled).
+	 */
+	if (!on_dl_rq(&p->dl))
+		return;
+
+	weight = cpumask_weight(new_mask);
+
+	/*
+	 * Only update if the process changes its state from whether it
+	 * can migrate or not.
+	 */
+	if ((p->nr_cpus_allowed > 1) == (weight > 1))
+		return;
+
+	rq = task_rq(p);
+
+	/*
+	 * The process used to be able to migrate OR it can now migrate
+	 */
+	if (weight <= 1) {
+		if (!task_current(rq, p))
+			dequeue_pushable_dl_task(rq, p);
+		BUG_ON(!rq->dl.dl_nr_migratory);
+		rq->dl.dl_nr_migratory--;
+	} else {
+		if (!task_current(rq, p))
+			enqueue_pushable_dl_task(rq, p);
+		rq->dl.dl_nr_migratory++;
+	}
+
+	update_dl_migration(&rq->dl);
+}
+
+/* Assumes rq->lock is held */
+static void rq_online_dl(struct rq *rq)
+{
+	if (rq->dl.overloaded)
+		dl_set_overload(rq);
+
+	if (rq->dl.dl_nr_running > 0)
+		cpudl_set(&rq->rd->cpudl, rq->cpu, rq->dl.earliest_dl.curr, 1);
+}
+
+/* Assumes rq->lock is held */
+static void rq_offline_dl(struct rq *rq)
+{
+	if (rq->dl.overloaded)
+		dl_clear_overload(rq);
+
+	cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
+}
+
+void init_sched_dl_class(void)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i)
+		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask_dl, i),
+					GFP_KERNEL, cpu_to_node(i));
+}
+
+#endif /* CONFIG_SMP */
+
+static void switched_from_dl(struct rq *rq, struct task_struct *p)
+{
+	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
+		hrtimer_try_to_cancel(&p->dl.dl_timer);
+
+#ifdef CONFIG_SMP
+	/*
+	 * Since this might be the only -deadline task on the rq,
+	 * this is the right place to try to pull some other one
+	 * from an overloaded cpu, if any.
+	 */
+	if (!rq->dl.dl_nr_running)
+		pull_dl_task(rq);
+#endif
+}
+
+/*
+ * When switching to -deadline, we may overload the rq, then
+ * we try to push someone off, if possible.
+ */
+static void switched_to_dl(struct rq *rq, struct task_struct *p)
+{
+	int check_resched = 1;
+
+	/*
+	 * If p is throttled, don't consider the possibility
+	 * of preempting rq->curr, the check will be done right
+	 * after its runtime will get replenished.
+	 */
+	if (unlikely(p->dl.dl_throttled))
+		return;
+
+	if (p->on_rq || rq->curr != p) {
+#ifdef CONFIG_SMP
+		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
+			/* Only reschedule if pushing failed */
+			check_resched = 0;
+#endif /* CONFIG_SMP */
+		if (check_resched && task_has_dl_policy(rq->curr))
+			check_preempt_curr_dl(rq, p, 0);
+	}
+}
+
+/*
+ * If the scheduling parameters of a -deadline task changed,
+ * a push or pull operation might be needed.
+ */
+static void prio_changed_dl(struct rq *rq, struct task_struct *p,
+			    int oldprio)
+{
+	if (p->on_rq || rq->curr == p) {
+#ifdef CONFIG_SMP
+		/*
+		 * This might be too much, but unfortunately
+		 * we don't have the old deadline value, and
+		 * we can't argue if the task is increasing
+		 * or lowering its prio, so...
+		 */
+		if (!rq->dl.overloaded)
+			pull_dl_task(rq);
+
+		/*
+		 * If we now have a earlier deadline task than p,
+		 * then reschedule, provided p is still on this
+		 * runqueue.
+		 */
+		if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
+		    rq->curr == p)
+			resched_task(p);
+#else
+		/*
+		 * Again, we don't know if p has a earlier
+		 * or later deadline, so let's blindly set a
+		 * (maybe not needed) rescheduling point.
+		 */
+		resched_task(p);
+#endif /* CONFIG_SMP */
+	} else
+		switched_to_dl(rq, p);
+}
+
+const struct sched_class dl_sched_class = {
+	.next			= &rt_sched_class,
+	.enqueue_task		= enqueue_task_dl,
+	.dequeue_task		= dequeue_task_dl,
+	.yield_task		= yield_task_dl,
+
+	.check_preempt_curr	= check_preempt_curr_dl,
+
+	.pick_next_task		= pick_next_task_dl,
+	.put_prev_task		= put_prev_task_dl,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_dl,
+	.set_cpus_allowed       = set_cpus_allowed_dl,
+	.rq_online              = rq_online_dl,
+	.rq_offline             = rq_offline_dl,
+	.pre_schedule		= pre_schedule_dl,
+	.post_schedule		= post_schedule_dl,
+	.task_woken		= task_woken_dl,
+#endif
+
+	.set_curr_task		= set_curr_task_dl,
+	.task_tick		= task_tick_dl,
+	.task_fork              = task_fork_dl,
+	.task_dead		= task_dead_dl,
+
+	.prio_changed           = prio_changed_dl,
+	.switched_from		= switched_from_dl,
+	.switched_to		= switched_to_dl,
+};
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 5c34d18..dd52e7f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -139,7 +139,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
 #ifdef CONFIG_NUMA_BALANCING
-	SEQ_printf(m, " %d", cpu_to_node(task_cpu(p)));
+	SEQ_printf(m, " %d", task_node(p));
 #endif
 #ifdef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, " %s", task_group_path(task_group(p)));
@@ -371,7 +371,7 @@ static void sched_debug_header(struct seq_file *m)
 	PN(cpu_clk);
 	P(jiffies);
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-	P(sched_clock_stable);
+	P(sched_clock_stable());
 #endif
 #undef PN
 #undef P
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e64b079..b24b6cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -872,15 +872,6 @@ static unsigned int task_scan_max(struct task_struct *p)
 	return max(smin, smax);
 }
 
-/*
- * Once a preferred node is selected the scheduler balancer will prefer moving
- * a task to that node for sysctl_numa_balancing_settle_count number of PTE
- * scans. This will give the process the chance to accumulate more faults on
- * the preferred node but still allow the scheduler to move the task again if
- * the nodes CPUs are overloaded.
- */
-unsigned int sysctl_numa_balancing_settle_count __read_mostly = 4;
-
 static void account_numa_enqueue(struct rq *rq, struct task_struct *p)
 {
 	rq->nr_numa_running += (p->numa_preferred_nid != -1);
@@ -930,7 +921,8 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 	if (!p->numa_group)
 		return 0;
 
-	return p->numa_group->faults[2*nid] + p->numa_group->faults[2*nid+1];
+	return p->numa_group->faults[task_faults_idx(nid, 0)] +
+		p->numa_group->faults[task_faults_idx(nid, 1)];
 }
 
 /*
@@ -1023,7 +1015,7 @@ struct task_numa_env {
 
 	struct numa_stats src_stats, dst_stats;
 
-	int imbalance_pct, idx;
+	int imbalance_pct;
 
 	struct task_struct *best_task;
 	long best_imp;
@@ -1211,7 +1203,7 @@ static int task_numa_migrate(struct task_struct *p)
 	 * elsewhere, so there is no point in (re)trying.
 	 */
 	if (unlikely(!sd)) {
-		p->numa_preferred_nid = cpu_to_node(task_cpu(p));
+		p->numa_preferred_nid = task_node(p);
 		return -EINVAL;
 	}
 
@@ -1278,7 +1270,7 @@ static void numa_migrate_preferred(struct task_struct *p)
 	p->numa_migrate_retry = jiffies + HZ;
 
 	/* Success if task is already running on preferred CPU */
-	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
+	if (task_node(p) == p->numa_preferred_nid)
 		return;
 
 	/* Otherwise, try migrate to a CPU on the preferred node */
@@ -1350,7 +1342,6 @@ static void update_task_scan_period(struct task_struct *p,
 		 * scanning faster if shared accesses dominate as it may
 		 * simply bounce migrations uselessly
 		 */
-		period_slot = DIV_ROUND_UP(diff, NUMA_PERIOD_SLOTS);
 		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
 		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
 	}
@@ -4101,12 +4092,16 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
  */
 static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
-		  int this_cpu, int load_idx)
+		  int this_cpu, int sd_flag)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
+	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
+	if (sd_flag & SD_BALANCE_WAKE)
+		load_idx = sd->wake_idx;
+
 	do {
 		unsigned long load, avg_load;
 		int local_group;
@@ -4274,7 +4269,6 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	}
 
 	while (sd) {
-		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
 		int weight;
 
@@ -4283,10 +4277,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			continue;
 		}
 
-		if (sd_flag & SD_BALANCE_WAKE)
-			load_idx = sd->wake_idx;
-
-		group = find_idlest_group(sd, p, cpu, load_idx);
+		group = find_idlest_group(sd, p, cpu, sd_flag);
 		if (!group) {
 			sd = sd->child;
 			continue;
@@ -5512,7 +5503,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
 			int local_group, struct sg_lb_stats *sgs)
 {
-	unsigned long nr_running;
 	unsigned long load;
 	int i;
 
@@ -5521,8 +5511,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		nr_running = rq->nr_running;
-
 		/* Bias balancing toward cpus of our domain */
 		if (local_group)
 			load = target_load(i, load_idx);
@@ -5530,7 +5518,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += nr_running;
+		sgs->sum_nr_running += rq->nr_running;
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
@@ -6521,7 +6509,7 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-static inline int find_new_ilb(int call_cpu)
+static inline int find_new_ilb(void)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
 
@@ -6536,13 +6524,13 @@ static inline int find_new_ilb(int call_cpu)
  * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
  * CPU (if there is one).
  */
-static void nohz_balancer_kick(int cpu)
+static void nohz_balancer_kick(void)
 {
 	int ilb_cpu;
 
 	nohz.next_balance++;
 
-	ilb_cpu = find_new_ilb(cpu);
+	ilb_cpu = find_new_ilb();
 
 	if (ilb_cpu >= nr_cpu_ids)
 		return;
@@ -6652,10 +6640,10 @@ void update_max_interval(void)
  *
  * Balancing parameters are set up in init_sched_domains.
  */
-static void rebalance_domains(int cpu, enum cpu_idle_type idle)
+static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
 {
 	int continue_balancing = 1;
-	struct rq *rq = cpu_rq(cpu);
+	int cpu = rq->cpu;
 	unsigned long interval;
 	struct sched_domain *sd;
 	/* Earliest time when we have to do rebalance again */
@@ -6752,9 +6740,9 @@ out:
  * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
-static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 {
-	struct rq *this_rq = cpu_rq(this_cpu);
+	int this_cpu = this_rq->cpu;
 	struct rq *rq;
 	int balance_cpu;
 
@@ -6781,7 +6769,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		update_idle_cpu_load(rq);
 		raw_spin_unlock_irq(&rq->lock);
 
-		rebalance_domains(balance_cpu, CPU_IDLE);
+		rebalance_domains(rq, CPU_IDLE);
 
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
@@ -6800,14 +6788,14 @@ end:
  *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
  *     domain span are idle.
  */
-static inline int nohz_kick_needed(struct rq *rq, int cpu)
+static inline int nohz_kick_needed(struct rq *rq)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
 	struct sched_group_power *sgp;
-	int nr_busy;
+	int nr_busy, cpu = rq->cpu;
 
-	if (unlikely(idle_cpu(cpu)))
+	if (unlikely(rq->idle_balance))
 		return 0;
 
        /*
@@ -6856,7 +6844,7 @@ need_kick:
 	return 1;
 }
 #else
-static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }
 #endif
 
 /*
@@ -6865,38 +6853,39 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
  */
 static void run_rebalance_domains(struct softirq_action *h)
 {
-	int this_cpu = smp_processor_id();
-	struct rq *this_rq = cpu_rq(this_cpu);
+	struct rq *this_rq = this_rq();
 	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
-	rebalance_domains(this_cpu, idle);
+	rebalance_domains(this_rq, idle);
 
 	/*
 	 * If this cpu has a pending nohz_balance_kick, then do the
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	nohz_idle_balance(this_cpu, idle);
+	nohz_idle_balance(this_rq, idle);
 }
 
-static inline int on_null_domain(int cpu)
+static inline int on_null_domain(struct rq *rq)
 {
-	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(rq->sd);
 }
 
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  */
-void trigger_load_balance(struct rq *rq, int cpu)
+void trigger_load_balance(struct rq *rq)
 {
 	/* Don't need to rebalance while attached to NULL domain */
-	if (time_after_eq(jiffies, rq->next_balance) &&
-	    likely(!on_null_domain(cpu)))
+	if (unlikely(on_null_domain(rq)))
+		return;
+
+	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ_COMMON
-	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
-		nohz_balancer_kick(cpu);
+	if (nohz_kick_needed(rq))
+		nohz_balancer_kick();
 #endif
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1c40655..a2740b7 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1738,7 +1738,7 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
 	    p->nr_cpus_allowed > 1 &&
-	    rt_task(rq->curr) &&
+	    (dl_task(rq->curr) || rt_task(rq->curr)) &&
 	    (rq->curr->nr_cpus_allowed < 2 ||
 	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b2..c2119fd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/deadline.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
@@ -9,6 +10,7 @@
 #include <linux/slab.h>
 
 #include "cpupri.h"
+#include "cpudeadline.h"
 #include "cpuacct.h"
 
 struct rq;
@@ -73,6 +75,13 @@ extern void update_cpu_load_active(struct rq *this_rq);
 #define NICE_0_SHIFT		SCHED_LOAD_SHIFT
 
 /*
+ * Single value that decides SCHED_DEADLINE internal math precision.
+ * 10 -> just above 1us
+ * 9  -> just above 0.5us
+ */
+#define DL_SCALE (10)
+
+/*
  * These are the 'tuning knobs' of the scheduler:
  */
 
@@ -81,11 +90,19 @@ extern void update_cpu_load_active(struct rq *this_rq);
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
+static inline int fair_policy(int policy)
+{
+	return policy == SCHED_NORMAL || policy == SCHED_BATCH;
+}
+
 static inline int rt_policy(int policy)
 {
-	if (policy == SCHED_FIFO || policy == SCHED_RR)
-		return 1;
-	return 0;
+	return policy == SCHED_FIFO || policy == SCHED_RR;
+}
+
+static inline int dl_policy(int policy)
+{
+	return policy == SCHED_DEADLINE;
 }
 
 static inline int task_has_rt_policy(struct task_struct *p)
@@ -93,6 +110,25 @@ static inline int task_has_rt_policy(struct task_struct *p)
 	return rt_policy(p->policy);
 }
 
+static inline int task_has_dl_policy(struct task_struct *p)
+{
+	return dl_policy(p->policy);
+}
+
+static inline bool dl_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+/*
+ * Tells if entity @a should preempt entity @b.
+ */
+static inline bool
+dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
+{
+	return dl_time_before(a->deadline, b->deadline);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -108,6 +144,47 @@ struct rt_bandwidth {
 	u64			rt_runtime;
 	struct hrtimer		rt_period_timer;
 };
+/*
+ * To keep the bandwidth of -deadline tasks and groups under control
+ * we need some place where:
+ *  - store the maximum -deadline bandwidth of the system (the group);
+ *  - cache the fraction of that bandwidth that is currently allocated.
+ *
+ * This is all done in the data structure below. It is similar to the
+ * one used for RT-throttling (rt_bandwidth), with the main difference
+ * that, since here we are only interested in admission control, we
+ * do not decrease any runtime while the group "executes", neither we
+ * need a timer to replenish it.
+ *
+ * With respect to SMP, the bandwidth is given on a per-CPU basis,
+ * meaning that:
+ *  - dl_bw (< 100%) is the bandwidth of the system (group) on each CPU;
+ *  - dl_total_bw array contains, in the i-eth element, the currently
+ *    allocated bandwidth on the i-eth CPU.
+ * Moreover, groups consume bandwidth on each CPU, while tasks only
+ * consume bandwidth on the CPU they're running on.
+ * Finally, dl_total_bw_cpu is used to cache the index of dl_total_bw
+ * that will be shown the next time the proc or cgroup controls will
+ * be red. It on its turn can be changed by writing on its own
+ * control.
+ */
+struct dl_bandwidth {
+	raw_spinlock_t dl_runtime_lock;
+	u64 dl_runtime;
+	u64 dl_period;
+};
+
+static inline int dl_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >= 0;
+}
+
+extern struct dl_bw *dl_bw_of(int i);
+
+struct dl_bw {
+	raw_spinlock_t lock;
+	u64 bw, total_bw;
+};
 
 extern struct mutex sched_domains_mutex;
 
@@ -364,6 +441,42 @@ struct rt_rq {
 #endif
 };
 
+/* Deadline class' related fields in a runqueue */
+struct dl_rq {
+	/* runqueue is an rbtree, ordered by deadline */
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+
+	unsigned long dl_nr_running;
+
+#ifdef CONFIG_SMP
+	/*
+	 * Deadline values of the currently executing and the
+	 * earliest ready task on this rq. Caching these facilitates
+	 * the decision wether or not a ready but not running task
+	 * should migrate somewhere else.
+	 */
+	struct {
+		u64 curr;
+		u64 next;
+	} earliest_dl;
+
+	unsigned long dl_nr_migratory;
+	unsigned long dl_nr_total;
+	int overloaded;
+
+	/*
+	 * Tasks on this rq that can be pushed away. They are kept in
+	 * an rb-tree, ordered by tasks' deadlines, with caching
+	 * of the leftmost (earliest deadline) element.
+	 */
+	struct rb_root pushable_dl_tasks_root;
+	struct rb_node *pushable_dl_tasks_leftmost;
+#else
+	struct dl_bw dl_bw;
+#endif
+};
+
 #ifdef CONFIG_SMP
 
 /*
@@ -382,6 +495,15 @@ struct root_domain {
 	cpumask_var_t online;
 
 	/*
+	 * The bit corresponding to a CPU gets set here if such CPU has more
+	 * than one runnable -deadline task (as it is below for RT tasks).
+	 */
+	cpumask_var_t dlo_mask;
+	atomic_t dlo_count;
+	struct dl_bw dl_bw;
+	struct cpudl cpudl;
+
+	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
@@ -432,6 +554,7 @@ struct rq {
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
+	struct dl_rq dl;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -827,8 +950,6 @@ static inline u64 global_rt_runtime(void)
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-
-
 static inline int task_current(struct rq *rq, struct task_struct *p)
 {
 	return rq->curr == p;
@@ -988,6 +1109,7 @@ static const u32 prio_to_wmult[40] = {
 #else
 #define ENQUEUE_WAKING		0
 #endif
+#define ENQUEUE_REPLENISH	8
 
 #define DEQUEUE_SLEEP		1
 
@@ -1023,6 +1145,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
+	void (*task_dead) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
@@ -1042,6 +1165,7 @@ struct sched_class {
    for (class = sched_class_highest; class; class = class->next)
 
 extern const struct sched_class stop_sched_class;
+extern const struct sched_class dl_sched_class;
 extern const struct sched_class rt_sched_class;
 extern const struct sched_class fair_sched_class;
 extern const struct sched_class idle_sched_class;
@@ -1051,7 +1175,7 @@ extern const struct sched_class idle_sched_class;
 
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
-extern void trigger_load_balance(struct rq *rq, int cpu);
+extern void trigger_load_balance(struct rq *rq);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
@@ -1068,8 +1192,11 @@ static inline void idle_balance(int cpu, struct rq *rq)
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
+
+extern void init_sched_dl_class(void);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
+extern void init_sched_dl_class(void);
 
 extern void resched_task(struct task_struct *p);
 extern void resched_cpu(int cpu);
@@ -1077,6 +1204,12 @@ extern void resched_cpu(int cpu);
 extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
+extern struct dl_bandwidth def_dl_bandwidth;
+extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
+extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
+
+unsigned long to_ratio(u64 period, u64 runtime);
+
 extern void update_idle_cpu_load(struct rq *this_rq);
 
 extern void init_task_runnable_average(struct task_struct *p);
@@ -1353,6 +1486,7 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
+extern void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq);
 
 extern void cfs_bandwidth_usage_inc(void);
 extern void cfs_bandwidth_usage_dec(void);
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 47197de..fdb6bb0 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -103,7 +103,7 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *task)
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
 const struct sched_class stop_sched_class = {
-	.next			= &rt_sched_class,
+	.next			= &dl_sched_class,
 
 	.enqueue_task		= enqueue_task_stop,
 	.dequeue_task		= dequeue_task_stop,
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 11025cc..9e368ef 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -89,7 +89,7 @@ static void wakeup_softirqd(void)
  * where hardirqs are disabled legitimately:
  */
 #ifdef CONFIG_TRACE_IRQFLAGS
-static void __local_bh_disable(unsigned long ip, unsigned int cnt)
+void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
 {
 	unsigned long flags;
 
@@ -107,33 +107,21 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 	/*
 	 * Were softirqs turned off above:
 	 */
-	if (softirq_count() == cnt)
+	if (softirq_count() == (cnt & SOFTIRQ_MASK))
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
 	if (preempt_count() == cnt)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
-#else /* !CONFIG_TRACE_IRQFLAGS */
-static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
-{
-	preempt_count_add(cnt);
-	barrier();
-}
+EXPORT_SYMBOL(__local_bh_disable_ip);
 #endif /* CONFIG_TRACE_IRQFLAGS */
 
-void local_bh_disable(void)
-{
-	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
-}
-
-EXPORT_SYMBOL(local_bh_disable);
-
 static void __local_bh_enable(unsigned int cnt)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (softirq_count() == cnt)
+	if (softirq_count() == (cnt & SOFTIRQ_MASK))
 		trace_softirqs_on(_RET_IP_);
 	preempt_count_sub(cnt);
 }
@@ -151,7 +139,7 @@ void _local_bh_enable(void)
 
 EXPORT_SYMBOL(_local_bh_enable);
 
-static inline void _local_bh_enable_ip(unsigned long ip)
+void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 {
 	WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -166,7 +154,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
-	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
+	preempt_count_sub(cnt - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending())) {
 		/*
@@ -182,18 +170,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 #endif
 	preempt_check_resched();
 }
-
-void local_bh_enable(void)
-{
-	_local_bh_enable_ip(_RET_IP_);
-}
-EXPORT_SYMBOL(local_bh_enable);
-
-void local_bh_enable_ip(unsigned long ip)
-{
-	_local_bh_enable_ip(ip);
-}
-EXPORT_SYMBOL(local_bh_enable_ip);
+EXPORT_SYMBOL(__local_bh_enable_ip);
 
 /*
  * We restart softirq processing for at most MAX_SOFTIRQ_RESTART times,
@@ -230,7 +207,7 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_irq_enter_time(current);
 
-	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a6047..c8da99f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -385,13 +385,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname       = "numa_balancing_settle_count",
-		.data           = &sysctl_numa_balancing_settle_count,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
-	{
 		.procname       = "numa_balancing_migrate_deferred",
 		.data           = &sysctl_numa_balancing_migrate_deferred,
 		.maxlen         = sizeof(unsigned int),
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ea20f7d..c833249 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -177,7 +177,7 @@ static bool can_stop_full_tick(void)
 	 * TODO: kick full dynticks CPUs when
 	 * sched_clock_stable is set.
 	 */
-	if (!sched_clock_stable) {
+	if (!sched_clock_stable()) {
 		trace_tick_stop(0, "unstable sched clock\n");
 		/*
 		 * Don't allow the user to think they can get
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cc2f66f..294b8a2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2558,7 +2558,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		if (unlikely(test_time_stamp(delta))) {
 			int local_clock_stable = 1;
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-			local_clock_stable = sched_clock_stable;
+			local_clock_stable = sched_clock_stable();
 #endif
 			WARN_ONCE(delta > (1ULL << 59),
 				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n%s",
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index fee77e1..6e32635 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -16,6 +16,7 @@
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/deadline.h>
 #include <trace/events/sched.h>
 #include "trace.h"
 
@@ -27,6 +28,8 @@ static int			wakeup_cpu;
 static int			wakeup_current_cpu;
 static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
+static int			wakeup_dl;
+static int			tracing_dl = 0;
 
 static arch_spinlock_t wakeup_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
@@ -437,6 +440,7 @@ static void __wakeup_reset(struct trace_array *tr)
 {
 	wakeup_cpu = -1;
 	wakeup_prio = -1;
+	tracing_dl = 0;
 
 	if (wakeup_task)
 		put_task_struct(wakeup_task);
@@ -472,9 +476,17 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	tracing_record_cmdline(p);
 	tracing_record_cmdline(current);
 
-	if ((wakeup_rt && !rt_task(p)) ||
-			p->prio >= wakeup_prio ||
-			p->prio >= current->prio)
+	/*
+	 * Semantic is like this:
+	 *  - wakeup tracer handles all tasks in the system, independently
+	 *    from their scheduling class;
+	 *  - wakeup_rt tracer handles tasks belonging to sched_dl and
+	 *    sched_rt class;
+	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
+	 */
+	if (tracing_dl || (wakeup_dl && !dl_task(p)) ||
+	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
+	    (!dl_task(p) && (p->prio >= wakeup_prio || p->prio >= current->prio)))
 		return;
 
 	pc = preempt_count();
@@ -486,7 +498,8 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	arch_spin_lock(&wakeup_lock);
 
 	/* check for races. */
-	if (!tracer_enabled || p->prio >= wakeup_prio)
+	if (!tracer_enabled || tracing_dl ||
+	    (!dl_task(p) && p->prio >= wakeup_prio))
 		goto out_locked;
 
 	/* reset the trace */
@@ -496,6 +509,15 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	wakeup_current_cpu = wakeup_cpu;
 	wakeup_prio = p->prio;
 
+	/*
+	 * Once you start tracing a -deadline task, don't bother tracing
+	 * another task until the first one wakes up.
+	 */
+	if (dl_task(p))
+		tracing_dl = 1;
+	else
+		tracing_dl = 0;
+
 	wakeup_task = p;
 	get_task_struct(wakeup_task);
 
@@ -597,16 +619,25 @@ static int __wakeup_tracer_init(struct trace_array *tr)
 
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl = 0;
 	wakeup_rt = 0;
 	return __wakeup_tracer_init(tr);
 }
 
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl = 0;
 	wakeup_rt = 1;
 	return __wakeup_tracer_init(tr);
 }
 
+static int wakeup_dl_tracer_init(struct trace_array *tr)
+{
+	wakeup_dl = 1;
+	wakeup_rt = 0;
+	return __wakeup_tracer_init(tr);
+}
+
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
 	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
@@ -674,6 +705,28 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.use_max_tr	= true,
 };
 
+static struct tracer wakeup_dl_tracer __read_mostly =
+{
+	.name		= "wakeup_dl",
+	.init		= wakeup_dl_tracer_init,
+	.reset		= wakeup_tracer_reset,
+	.start		= wakeup_tracer_start,
+	.stop		= wakeup_tracer_stop,
+	.wait_pipe	= poll_wait_pipe,
+	.print_max	= true,
+	.print_header	= wakeup_print_header,
+	.print_line	= wakeup_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= wakeup_set_flag,
+	.flag_changed	= wakeup_flag_changed,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest    = trace_selftest_startup_wakeup,
+#endif
+	.open		= wakeup_trace_open,
+	.close		= wakeup_trace_close,
+	.use_max_tr	= true,
+};
+
 __init static int init_wakeup_tracer(void)
 {
 	int ret;
@@ -686,6 +739,10 @@ __init static int init_wakeup_tracer(void)
 	if (ret)
 		return ret;
 
+	ret = register_tracer(&wakeup_dl_tracer);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 core_initcall(init_wakeup_tracer);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index a7329b7..e98fca6 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1022,11 +1022,16 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
 #ifdef CONFIG_SCHED_TRACER
 static int trace_wakeup_test_thread(void *data)
 {
-	/* Make this a RT thread, doesn't need to be too high */
-	static const struct sched_param param = { .sched_priority = 5 };
+	/* Make this a -deadline thread */
+	static const struct sched_attr attr = {
+		.sched_policy = SCHED_DEADLINE,
+		.sched_runtime = 100000ULL,
+		.sched_deadline = 10000000ULL,
+		.sched_period = 10000000ULL
+	};
 	struct completion *x = data;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
+	sched_setattr(current, &attr);
 
 	/* Make it know we have a new prio */
 	complete(x);
@@ -1040,8 +1045,8 @@ static int trace_wakeup_test_thread(void *data)
 	/* we are awake, now wait to disappear */
 	while (!kthread_should_stop()) {
 		/*
-		 * This is an RT task, do short sleeps to let
-		 * others run.
+		 * This will likely be the system top priority
+		 * task, do short sleeps to let others run.
 		 */
 		msleep(100);
 	}
@@ -1054,21 +1059,21 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 {
 	unsigned long save_max = tracing_max_latency;
 	struct task_struct *p;
-	struct completion isrt;
+	struct completion is_ready;
 	unsigned long count;
 	int ret;
 
-	init_completion(&isrt);
+	init_completion(&is_ready);
 
-	/* create a high prio thread */
-	p = kthread_run(trace_wakeup_test_thread, &isrt, "ftrace-test");
+	/* create a -deadline thread */
+	p = kthread_run(trace_wakeup_test_thread, &is_ready, "ftrace-test");
 	if (IS_ERR(p)) {
 		printk(KERN_CONT "Failed to create ftrace wakeup test thread ");
 		return -1;
 	}
 
-	/* make sure the thread is running at an RT prio */
-	wait_for_completion(&isrt);
+	/* make sure the thread is running at -deadline policy */
+	wait_for_completion(&is_ready);
 
 	/* start the tracing */
 	ret = tracer_init(trace, tr);
@@ -1082,19 +1087,19 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 
 	while (p->on_rq) {
 		/*
-		 * Sleep to make sure the RT thread is asleep too.
+		 * Sleep to make sure the -deadline thread is asleep too.
 		 * On virtual machines we can't rely on timings,
 		 * but we want to make sure this test still works.
 		 */
 		msleep(100);
 	}
 
-	init_completion(&isrt);
+	init_completion(&is_ready);
 
 	wake_up_process(p);
 
 	/* Wait for the task to wake up */
-	wait_for_completion(&isrt);
+	wait_for_completion(&is_ready);
 
 	/* stop the tracing. */
 	tracing_stop();
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c4638e6..82de786 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1623,11 +1623,11 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
 		    !sysctl_tcp_low_latency &&
 		    net_dma_find_channel()) {
-			preempt_enable_no_resched();
+			preempt_enable();
 			tp->ucopy.pinned_list =
 					dma_pin_iovec_pages(msg->msg_iov, len);
 		} else {
-			preempt_enable_no_resched();
+			preempt_enable();
 		}
 	}
 #endif
