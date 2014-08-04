Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaHDJna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:43:30 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56420 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaHDJnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:43:24 -0400
Date: Mon, 4 Aug 2014 11:43:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking tree updates for v3.17
Message-ID: <20140804094318.GA23099@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-core-for-linus

   # HEAD: 3a6bfbc91df04b081a44d419e0260bad54abddf7 arch, locking: Ciao arch_mutex_cpu_relax()

The main changes in this cycle are:

 - big rtmutex and futex cleanup and robustification from Thomas Gleixner
 - mutex optimizations and refinements from Jason Low
 - arch_mutex_cpu_relax() removal and related cleanups
 - smaller lockdep tweaks

 Thanks,

	Ingo

------------------>
Andreas Gruenbacher (1):
      locking/lockdep: Only ask for /proc/lock_stat output when available

Davidlohr Bueso (1):
      arch, locking: Ciao arch_mutex_cpu_relax()

Jason Low (4):
      locking/mutexes: Correct documentation on mutex optimistic spinning
      locking/mutexes: Delete the MUTEX_SHOW_NO_WAITER macro
      locking/mutexes: Try to acquire mutex only if it is unlocked
      locking/mutexes: Optimize mutex trylock slowpath

Peter Zijlstra (1):
      x86, locking: Use no more OOSTORE nonsense

Thomas Gleixner (15):
      rtmutex: Simplify rtmutex_slowtrylock()
      rtmutex: Simplify and document try_to_take_rtmutex()
      rtmutex: No need to keep task ref for lock owner check
      rtmutex: Clarify the boost/deboost part
      rtmutex: Document pi chain walk
      rtmutex: Simplify remove_waiter()
      rtmutex: Confine deadlock logic to futex
      rtmutex: Cleanup deadlock detector debug logic
      rtmutex: Avoid pointless requeueing in the deadlock detection chain walk
      futex: Make unlock_pi more robust
      futex: Use futex_top_waiter() in lookup_pi_state()
      futex: Split out the waiter check from lookup_pi_state()
      futex: Split out the first waiter attachment from lookup_pi_state()
      futex: Simplify futex_lock_pi_atomic() and make it more robust
      rtmutex: Make the rtmutex tester depend on BROKEN

Trond Myklebust (1):
      lockdep: Revert lockdep check in raw_seqcount_begin()


 arch/alpha/include/asm/processor.h      |   1 +
 arch/arc/include/asm/processor.h        |   2 +
 arch/arm/include/asm/processor.h        |   2 +
 arch/arm64/include/asm/processor.h      |   1 +
 arch/avr32/include/asm/processor.h      |   1 +
 arch/blackfin/include/asm/processor.h   |   2 +-
 arch/c6x/include/asm/processor.h        |   1 +
 arch/cris/include/asm/processor.h       |   1 +
 arch/hexagon/include/asm/processor.h    |   1 +
 arch/ia64/include/asm/processor.h       |   1 +
 arch/m32r/include/asm/processor.h       |   1 +
 arch/m68k/include/asm/processor.h       |   1 +
 arch/metag/include/asm/processor.h      |   1 +
 arch/microblaze/include/asm/processor.h |   1 +
 arch/mips/include/asm/processor.h       |   1 +
 arch/mn10300/include/asm/processor.h    |   2 +
 arch/openrisc/include/asm/processor.h   |   1 +
 arch/parisc/include/asm/processor.h     |   1 +
 arch/powerpc/include/asm/processor.h    |   2 +
 arch/s390/include/asm/processor.h       |   2 +-
 arch/score/include/asm/processor.h      |   1 +
 arch/sh/include/asm/processor.h         |   1 +
 arch/sparc/include/asm/processor_32.h   |   2 +
 arch/sparc/include/asm/processor_64.h   |   1 +
 arch/tile/include/asm/processor.h       |   2 +
 arch/unicore32/include/asm/processor.h  |   1 +
 arch/x86/include/asm/barrier.h          |   2 +-
 arch/x86/include/asm/processor.h        |   2 +
 arch/x86/include/asm/qrwlock.h          |   2 +-
 arch/x86/um/asm/processor.h             |   3 +-
 arch/xtensa/include/asm/processor.h     |   1 +
 include/linux/mutex.h                   |   4 -
 include/linux/rtmutex.h                 |   6 +-
 include/linux/seqlock.h                 |   2 -
 kernel/futex.c                          | 402 +++++++++++------------
 kernel/locking/lockdep.c                |   2 +
 kernel/locking/mcs_spinlock.c           |   8 +-
 kernel/locking/mcs_spinlock.h           |   4 +-
 kernel/locking/mutex.c                  |  39 +--
 kernel/locking/qrwlock.c                |   9 +-
 kernel/locking/rtmutex-debug.c          |   5 +-
 kernel/locking/rtmutex-debug.h          |   7 +-
 kernel/locking/rtmutex.c                | 562 ++++++++++++++++++++++++--------
 kernel/locking/rtmutex.h                |   7 +-
 kernel/locking/rtmutex_common.h         |  22 +-
 kernel/locking/rwsem-xadd.c             |   4 +-
 lib/Kconfig.debug                       |   2 +-
 lib/lockref.c                           |   3 +-
 48 files changed, 707 insertions(+), 425 deletions(-)

diff --git a/arch/alpha/include/asm/processor.h b/arch/alpha/include/asm/processor.h
index 6cb7fe8..b4cf036 100644
--- a/arch/alpha/include/asm/processor.h
+++ b/arch/alpha/include/asm/processor.h
@@ -57,6 +57,7 @@ unsigned long get_wchan(struct task_struct *p);
   ((tsk) == current ? rdusp() : task_thread_info(tsk)->pcb.usp)
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #define ARCH_HAS_PREFETCH
 #define ARCH_HAS_PREFETCHW
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index d99f9b3..82588f3 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -62,6 +62,8 @@ unsigned long thread_saved_pc(struct task_struct *t);
 #define cpu_relax()	do { } while (0)
 #endif
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 #define copy_segments(tsk, mm)      do { } while (0)
 #define release_segments(mm)        do { } while (0)
 
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index c3d5fc1..8a1e8e9 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -82,6 +82,8 @@ unsigned long get_wchan(struct task_struct *p);
 #define cpu_relax()			barrier()
 #endif
 
+#define cpu_relax_lowlatency()                cpu_relax()
+
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 34de2a8..4610b0d 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -129,6 +129,7 @@ extern void release_thread(struct task_struct *);
 unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
+#define cpu_relax_lowlatency()                cpu_relax()
 
 /* Thread switching */
 extern struct task_struct *cpu_switch_to(struct task_struct *prev,
diff --git a/arch/avr32/include/asm/processor.h b/arch/avr32/include/asm/processor.h
index 972adcc..941593c 100644
--- a/arch/avr32/include/asm/processor.h
+++ b/arch/avr32/include/asm/processor.h
@@ -92,6 +92,7 @@ extern struct avr32_cpuinfo boot_cpu_data;
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
 
 #define cpu_relax()		barrier()
+#define cpu_relax_lowlatency()        cpu_relax()
 #define cpu_sync_pipeline()	asm volatile("sub pc, -2" : : : "memory")
 
 struct cpu_context {
diff --git a/arch/blackfin/include/asm/processor.h b/arch/blackfin/include/asm/processor.h
index d0e72e9..7acd466 100644
--- a/arch/blackfin/include/asm/processor.h
+++ b/arch/blackfin/include/asm/processor.h
@@ -99,7 +99,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define	KSTK_ESP(tsk)	((tsk) == current ? rdusp() : (tsk)->thread.usp)
 
 #define cpu_relax()    	smp_mb()
-
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Get the Silicon Revision of the chip */
 static inline uint32_t __pure bfin_revid(void)
diff --git a/arch/c6x/include/asm/processor.h b/arch/c6x/include/asm/processor.h
index b9eb3da..f2ef31b 100644
--- a/arch/c6x/include/asm/processor.h
+++ b/arch/c6x/include/asm/processor.h
@@ -121,6 +121,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(task)	(task_pt_regs(task)->sp)
 
 #define cpu_relax()		do { } while (0)
+#define cpu_relax_lowlatency()        cpu_relax()
 
 extern const struct seq_operations cpuinfo_op;
 
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index 15b815d..862126b 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -63,6 +63,7 @@ static inline void release_thread(struct task_struct *dead_task)
 #define init_stack      (init_thread_union.stack)
 
 #define cpu_relax()     barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 void default_idle(void);
 
diff --git a/arch/hexagon/include/asm/processor.h b/arch/hexagon/include/asm/processor.h
index 45a8254..d850113 100644
--- a/arch/hexagon/include/asm/processor.h
+++ b/arch/hexagon/include/asm/processor.h
@@ -56,6 +56,7 @@ struct thread_struct {
 }
 
 #define cpu_relax() __vmyield()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /*
  * Decides where the kernel will search for a free chunk of vm space during
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index efd1b92..c736713 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -548,6 +548,7 @@ ia64_eoi (void)
 }
 
 #define cpu_relax()	ia64_hint(ia64_hint_pause)
+#define cpu_relax_lowlatency() cpu_relax()
 
 static inline int
 ia64_get_irr(unsigned int vector)
diff --git a/arch/m32r/include/asm/processor.h b/arch/m32r/include/asm/processor.h
index 5767367..9f8fd9b 100644
--- a/arch/m32r/include/asm/processor.h
+++ b/arch/m32r/include/asm/processor.h
@@ -133,5 +133,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(tsk)  ((tsk)->thread.sp)
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #endif /* _ASM_M32R_PROCESSOR_H */
diff --git a/arch/m68k/include/asm/processor.h b/arch/m68k/include/asm/processor.h
index b0768a6..20dda1d 100644
--- a/arch/m68k/include/asm/processor.h
+++ b/arch/m68k/include/asm/processor.h
@@ -176,5 +176,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define task_pt_regs(tsk)	((struct pt_regs *) ((tsk)->thread.esp0))
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #endif
diff --git a/arch/metag/include/asm/processor.h b/arch/metag/include/asm/processor.h
index a8a3747..881071c 100644
--- a/arch/metag/include/asm/processor.h
+++ b/arch/metag/include/asm/processor.h
@@ -155,6 +155,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define user_stack_pointer(regs)        ((regs)->ctx.AX[0].U0)
 
 #define cpu_relax()     barrier()
+#define cpu_relax_lowlatency()  cpu_relax()
 
 extern void setup_priv(void);
 
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 9d31b05..497a988 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -22,6 +22,7 @@
 extern const struct seq_operations cpuinfo_op;
 
 # define cpu_relax()		barrier()
+# define cpu_relax_lowlatency()	cpu_relax()
 
 #define task_pt_regs(tsk) \
 		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index ad70cba..d5098bc 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -367,6 +367,7 @@ unsigned long get_wchan(struct task_struct *p);
 #define KSTK_STATUS(tsk) (task_pt_regs(tsk)->cp0_status)
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /*
  * Return_address is a replacement for __builtin_return_address(count)
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index 8b80b19..769d5ed 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -68,7 +68,9 @@ extern struct mn10300_cpuinfo cpu_data[];
 extern void identify_cpu(struct mn10300_cpuinfo *);
 extern void print_cpu_info(struct mn10300_cpuinfo *);
 extern void dodgy_tsc(void);
+
 #define cpu_relax() barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /*
  * User space process size: 1.75GB (default).
diff --git a/arch/openrisc/include/asm/processor.h b/arch/openrisc/include/asm/processor.h
index cab746f..4d235e3 100644
--- a/arch/openrisc/include/asm/processor.h
+++ b/arch/openrisc/include/asm/processor.h
@@ -101,6 +101,7 @@ extern unsigned long thread_saved_pc(struct task_struct *t);
 #define init_stack      (init_thread_union.stack)
 
 #define cpu_relax()     barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_OPENRISC_PROCESSOR_H */
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index d951c96..689a8ad 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -338,6 +338,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(tsk)	((tsk)->thread.regs.gr[30])
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Used as a macro to identify the combined VIPT/PIPT cached
  * CPUs which require a guarantee of coherency (no inequivalent
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 6d59072..dda7ac4 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -400,6 +400,8 @@ static inline unsigned long __pack_fe01(unsigned int fpmode)
 #define cpu_relax()	barrier()
 #endif
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 /* Check that a certain kernel stack pointer is valid in task_struct p */
 int validate_sp(unsigned long sp, struct task_struct *p,
                        unsigned long nbytes);
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 6f02d45..e568fc8 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -217,7 +217,7 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
-#define arch_mutex_cpu_relax()  barrier()
+#define cpu_relax_lowlatency()  barrier()
 
 static inline void psw_set_key(unsigned int key)
 {
diff --git a/arch/score/include/asm/processor.h b/arch/score/include/asm/processor.h
index d9a922d..851f441 100644
--- a/arch/score/include/asm/processor.h
+++ b/arch/score/include/asm/processor.h
@@ -24,6 +24,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define current_text_addr() ({ __label__ _l; _l: &&_l; })
 
 #define cpu_relax()		barrier()
+#define cpu_relax_lowlatency()        cpu_relax()
 #define release_thread(thread)	do {} while (0)
 
 /*
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index 5448f9b..1506897 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -97,6 +97,7 @@ extern struct sh_cpuinfo cpu_data[];
 
 #define cpu_sleep()	__asm__ __volatile__ ("sleep" : : : "memory")
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 void default_idle(void);
 void stop_this_cpu(void *);
diff --git a/arch/sparc/include/asm/processor_32.h b/arch/sparc/include/asm/processor_32.h
index a564817..812fd08 100644
--- a/arch/sparc/include/asm/processor_32.h
+++ b/arch/sparc/include/asm/processor_32.h
@@ -119,6 +119,8 @@ extern struct task_struct *last_task_used_math;
 int do_mathemu(struct pt_regs *regs, struct task_struct *fpt);
 
 #define cpu_relax()	barrier()
+#define cpu_relax_lowlatency() cpu_relax()
+
 extern void (*sparc_idle)(void);
 
 #endif
diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index 7028fe1..6924bde 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -216,6 +216,7 @@ unsigned long get_wchan(struct task_struct *task);
 				     "nop\n\t"				\
 				     ".previous"			\
 				     ::: "memory")
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Prefetch support.  This is tuned for UltraSPARC-III and later.
  * UltraSPARC-I will treat these as nops, and UltraSPARC-II has
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 4232363..dd4f9f1 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -266,6 +266,8 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 /* Info on this processor (see fs/proc/cpuinfo.c) */
 struct seq_operations;
 extern const struct seq_operations cpuinfo_op;
diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
index 4eaa421..8d21b7a 100644
--- a/arch/unicore32/include/asm/processor.h
+++ b/arch/unicore32/include/asm/processor.h
@@ -71,6 +71,7 @@ extern void release_thread(struct task_struct *);
 unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()			barrier()
+#define cpu_relax_lowlatency()                cpu_relax()
 
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 5c7198c..0f4460b 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -99,7 +99,7 @@
 #if defined(CONFIG_X86_PPRO_FENCE)
 
 /*
- * For either of these options x86 doesn't have a strong TSO memory
+ * For this option x86 doesn't have a strong TSO memory
  * model and we should fall back to full barriers.
  */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a4ea023..32cc237 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -696,6 +696,8 @@ static inline void cpu_relax(void)
 	rep_nop();
 }
 
+#define cpu_relax_lowlatency() cpu_relax()
+
 /* Stop speculative execution and prefetching of modified code. */
 static inline void sync_core(void)
 {
diff --git a/arch/x86/include/asm/qrwlock.h b/arch/x86/include/asm/qrwlock.h
index 70f46f0..ae0e241 100644
--- a/arch/x86/include/asm/qrwlock.h
+++ b/arch/x86/include/asm/qrwlock.h
@@ -3,7 +3,7 @@
 
 #include <asm-generic/qrwlock_types.h>
 
-#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#ifndef CONFIG_X86_PPRO_FENCE
 #define queue_write_unlock queue_write_unlock
 static inline void queue_write_unlock(struct qrwlock *lock)
 {
diff --git a/arch/x86/um/asm/processor.h b/arch/x86/um/asm/processor.h
index 04f82e0..2a206d2 100644
--- a/arch/x86/um/asm/processor.h
+++ b/arch/x86/um/asm/processor.h
@@ -25,7 +25,8 @@ static inline void rep_nop(void)
 	__asm__ __volatile__("rep;nop": : :"memory");
 }
 
-#define cpu_relax()	rep_nop()
+#define cpu_relax()		rep_nop()
+#define cpu_relax_lowlatency()	cpu_relax()
 
 #include <asm/processor-generic.h>
 
diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index abb5970..b61bdf0 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -182,6 +182,7 @@ extern unsigned long get_wchan(struct task_struct *p);
 #define KSTK_ESP(tsk)		(task_pt_regs(tsk)->areg[1])
 
 #define cpu_relax()  barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* Special register access. */
 
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 42aa9b9..8d5535c 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -176,8 +176,4 @@ extern void mutex_unlock(struct mutex *lock);
 
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
-#ifndef arch_mutex_cpu_relax
-# define arch_mutex_cpu_relax() cpu_relax()
-#endif
-
 #endif /* __LINUX_MUTEX_H */
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 3aed8d7..1abba5c 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -90,11 +90,9 @@ extern void __rt_mutex_init(struct rt_mutex *lock, const char *name);
 extern void rt_mutex_destroy(struct rt_mutex *lock);
 
 extern void rt_mutex_lock(struct rt_mutex *lock);
-extern int rt_mutex_lock_interruptible(struct rt_mutex *lock,
-						int detect_deadlock);
+extern int rt_mutex_lock_interruptible(struct rt_mutex *lock);
 extern int rt_mutex_timed_lock(struct rt_mutex *lock,
-					struct hrtimer_sleeper *timeout,
-					int detect_deadlock);
+			       struct hrtimer_sleeper *timeout);
 
 extern int rt_mutex_trylock(struct rt_mutex *lock);
 
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 535f158..8cf3503 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -164,8 +164,6 @@ static inline unsigned read_seqcount_begin(const seqcount_t *s)
 static inline unsigned raw_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret = ACCESS_ONCE(s->sequence);
-
-	seqcount_lockdep_reader_access(s);
 	smp_rmb();
 	return ret & ~1;
 }
diff --git a/kernel/futex.c b/kernel/futex.c
index b632b5f..d3a9d94 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -792,94 +792,91 @@ void exit_pi_state_list(struct task_struct *curr)
  * [10] There is no transient state which leaves owner and user space
  *	TID out of sync.
  */
-static int
-lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
-		union futex_key *key, struct futex_pi_state **ps)
+
+/*
+ * Validate that the existing waiter has a pi_state and sanity check
+ * the pi_state against the user space value. If correct, attach to
+ * it.
+ */
+static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
+			      struct futex_pi_state **ps)
 {
-	struct futex_pi_state *pi_state = NULL;
-	struct futex_q *this, *next;
-	struct task_struct *p;
 	pid_t pid = uval & FUTEX_TID_MASK;
 
-	plist_for_each_entry_safe(this, next, &hb->chain, list) {
-		if (match_futex(&this->key, key)) {
-			/*
-			 * Sanity check the waiter before increasing
-			 * the refcount and attaching to it.
-			 */
-			pi_state = this->pi_state;
-			/*
-			 * Userspace might have messed up non-PI and
-			 * PI futexes [3]
-			 */
-			if (unlikely(!pi_state))
-				return -EINVAL;
+	/*
+	 * Userspace might have messed up non-PI and PI futexes [3]
+	 */
+	if (unlikely(!pi_state))
+		return -EINVAL;
 
-			WARN_ON(!atomic_read(&pi_state->refcount));
+	WARN_ON(!atomic_read(&pi_state->refcount));
 
+	/*
+	 * Handle the owner died case:
+	 */
+	if (uval & FUTEX_OWNER_DIED) {
+		/*
+		 * exit_pi_state_list sets owner to NULL and wakes the
+		 * topmost waiter. The task which acquires the
+		 * pi_state->rt_mutex will fixup owner.
+		 */
+		if (!pi_state->owner) {
 			/*
-			 * Handle the owner died case:
+			 * No pi state owner, but the user space TID
+			 * is not 0. Inconsistent state. [5]
 			 */
-			if (uval & FUTEX_OWNER_DIED) {
-				/*
-				 * exit_pi_state_list sets owner to NULL and
-				 * wakes the topmost waiter. The task which
-				 * acquires the pi_state->rt_mutex will fixup
-				 * owner.
-				 */
-				if (!pi_state->owner) {
-					/*
-					 * No pi state owner, but the user
-					 * space TID is not 0. Inconsistent
-					 * state. [5]
-					 */
-					if (pid)
-						return -EINVAL;
-					/*
-					 * Take a ref on the state and
-					 * return. [4]
-					 */
-					goto out_state;
-				}
-
-				/*
-				 * If TID is 0, then either the dying owner
-				 * has not yet executed exit_pi_state_list()
-				 * or some waiter acquired the rtmutex in the
-				 * pi state, but did not yet fixup the TID in
-				 * user space.
-				 *
-				 * Take a ref on the state and return. [6]
-				 */
-				if (!pid)
-					goto out_state;
-			} else {
-				/*
-				 * If the owner died bit is not set,
-				 * then the pi_state must have an
-				 * owner. [7]
-				 */
-				if (!pi_state->owner)
-					return -EINVAL;
-			}
-
+			if (pid)
+				return -EINVAL;
 			/*
-			 * Bail out if user space manipulated the
-			 * futex value. If pi state exists then the
-			 * owner TID must be the same as the user
-			 * space TID. [9/10]
+			 * Take a ref on the state and return success. [4]
 			 */
-			if (pid != task_pid_vnr(pi_state->owner))
-				return -EINVAL;
-
-		out_state:
-			atomic_inc(&pi_state->refcount);
-			*ps = pi_state;
-			return 0;
+			goto out_state;
 		}
+
+		/*
+		 * If TID is 0, then either the dying owner has not
+		 * yet executed exit_pi_state_list() or some waiter
+		 * acquired the rtmutex in the pi state, but did not
+		 * yet fixup the TID in user space.
+		 *
+		 * Take a ref on the state and return success. [6]
+		 */
+		if (!pid)
+			goto out_state;
+	} else {
+		/*
+		 * If the owner died bit is not set, then the pi_state
+		 * must have an owner. [7]
+		 */
+		if (!pi_state->owner)
+			return -EINVAL;
 	}
 
 	/*
+	 * Bail out if user space manipulated the futex value. If pi
+	 * state exists then the owner TID must be the same as the
+	 * user space TID. [9/10]
+	 */
+	if (pid != task_pid_vnr(pi_state->owner))
+		return -EINVAL;
+out_state:
+	atomic_inc(&pi_state->refcount);
+	*ps = pi_state;
+	return 0;
+}
+
+/*
+ * Lookup the task for the TID provided from user space and attach to
+ * it after doing proper sanity checks.
+ */
+static int attach_to_pi_owner(u32 uval, union futex_key *key,
+			      struct futex_pi_state **ps)
+{
+	pid_t pid = uval & FUTEX_TID_MASK;
+	struct futex_pi_state *pi_state;
+	struct task_struct *p;
+
+	/*
 	 * We are the first waiter - try to look up the real owner and attach
 	 * the new pi_state to it, but bail out when TID = 0 [1]
 	 */
@@ -920,7 +917,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	pi_state = alloc_pi_state();
 
 	/*
-	 * Initialize the pi_mutex in locked state and make 'p'
+	 * Initialize the pi_mutex in locked state and make @p
 	 * the owner of it:
 	 */
 	rt_mutex_init_proxy_locked(&pi_state->pi_mutex, p);
@@ -940,6 +937,36 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	return 0;
 }
 
+static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
+			   union futex_key *key, struct futex_pi_state **ps)
+{
+	struct futex_q *match = futex_top_waiter(hb, key);
+
+	/*
+	 * If there is a waiter on that futex, validate it and
+	 * attach to the pi_state when the validation succeeds.
+	 */
+	if (match)
+		return attach_to_pi_state(uval, match->pi_state, ps);
+
+	/*
+	 * We are the first waiter - try to look up the owner based on
+	 * @uval and attach to it.
+	 */
+	return attach_to_pi_owner(uval, key, ps);
+}
+
+static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
+{
+	u32 uninitialized_var(curval);
+
+	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
+		return -EFAULT;
+
+	/*If user space value changed, let the caller retry */
+	return curval != uval ? -EAGAIN : 0;
+}
+
 /**
  * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
  * @uaddr:		the pi futex user address
@@ -963,113 +990,69 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 				struct futex_pi_state **ps,
 				struct task_struct *task, int set_waiters)
 {
-	int lock_taken, ret, force_take = 0;
-	u32 uval, newval, curval, vpid = task_pid_vnr(task);
-
-retry:
-	ret = lock_taken = 0;
+	u32 uval, newval, vpid = task_pid_vnr(task);
+	struct futex_q *match;
+	int ret;
 
 	/*
-	 * To avoid races, we attempt to take the lock here again
-	 * (by doing a 0 -> TID atomic cmpxchg), while holding all
-	 * the locks. It will most likely not succeed.
+	 * Read the user space value first so we can validate a few
+	 * things before proceeding further.
 	 */
-	newval = vpid;
-	if (set_waiters)
-		newval |= FUTEX_WAITERS;
-
-	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, 0, newval)))
+	if (get_futex_value_locked(&uval, uaddr))
 		return -EFAULT;
 
 	/*
 	 * Detect deadlocks.
 	 */
-	if ((unlikely((curval & FUTEX_TID_MASK) == vpid)))
+	if ((unlikely((uval & FUTEX_TID_MASK) == vpid)))
 		return -EDEADLK;
 
 	/*
-	 * Surprise - we got the lock, but we do not trust user space at all.
-	 */
-	if (unlikely(!curval)) {
-		/*
-		 * We verify whether there is kernel state for this
-		 * futex. If not, we can safely assume, that the 0 ->
-		 * TID transition is correct. If state exists, we do
-		 * not bother to fixup the user space state as it was
-		 * corrupted already.
-		 */
-		return futex_top_waiter(hb, key) ? -EINVAL : 1;
-	}
-
-	uval = curval;
-
-	/*
-	 * Set the FUTEX_WAITERS flag, so the owner will know it has someone
-	 * to wake at the next unlock.
+	 * Lookup existing state first. If it exists, try to attach to
+	 * its pi_state.
 	 */
-	newval = curval | FUTEX_WAITERS;
+	match = futex_top_waiter(hb, key);
+	if (match)
+		return attach_to_pi_state(uval, match->pi_state, ps);
 
 	/*
-	 * Should we force take the futex? See below.
+	 * No waiter and user TID is 0. We are here because the
+	 * waiters or the owner died bit is set or called from
+	 * requeue_cmp_pi or for whatever reason something took the
+	 * syscall.
 	 */
-	if (unlikely(force_take)) {
+	if (!(uval & FUTEX_TID_MASK)) {
 		/*
-		 * Keep the OWNER_DIED and the WAITERS bit and set the
-		 * new TID value.
+		 * We take over the futex. No other waiters and the user space
+		 * TID is 0. We preserve the owner died bit.
 		 */
-		newval = (curval & ~FUTEX_TID_MASK) | vpid;
-		force_take = 0;
-		lock_taken = 1;
-	}
+		newval = uval & FUTEX_OWNER_DIED;
+		newval |= vpid;
 
-	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
-		return -EFAULT;
-	if (unlikely(curval != uval))
-		goto retry;
+		/* The futex requeue_pi code can enforce the waiters bit */
+		if (set_waiters)
+			newval |= FUTEX_WAITERS;
+
+		ret = lock_pi_update_atomic(uaddr, uval, newval);
+		/* If the take over worked, return 1 */
+		return ret < 0 ? ret : 1;
+	}
 
 	/*
-	 * We took the lock due to forced take over.
+	 * First waiter. Set the waiters bit before attaching ourself to
+	 * the owner. If owner tries to unlock, it will be forced into
+	 * the kernel and blocked on hb->lock.
 	 */
-	if (unlikely(lock_taken))
-		return 1;
-
+	newval = uval | FUTEX_WAITERS;
+	ret = lock_pi_update_atomic(uaddr, uval, newval);
+	if (ret)
+		return ret;
 	/*
-	 * We dont have the lock. Look up the PI state (or create it if
-	 * we are the first waiter):
+	 * If the update of the user space value succeeded, we try to
+	 * attach to the owner. If that fails, no harm done, we only
+	 * set the FUTEX_WAITERS bit in the user space variable.
 	 */
-	ret = lookup_pi_state(uval, hb, key, ps);
-
-	if (unlikely(ret)) {
-		switch (ret) {
-		case -ESRCH:
-			/*
-			 * We failed to find an owner for this
-			 * futex. So we have no pi_state to block
-			 * on. This can happen in two cases:
-			 *
-			 * 1) The owner died
-			 * 2) A stale FUTEX_WAITERS bit
-			 *
-			 * Re-read the futex value.
-			 */
-			if (get_futex_value_locked(&curval, uaddr))
-				return -EFAULT;
-
-			/*
-			 * If the owner died or we have a stale
-			 * WAITERS bit the owner TID in the user space
-			 * futex is 0.
-			 */
-			if (!(curval & FUTEX_TID_MASK)) {
-				force_take = 1;
-				goto retry;
-			}
-		default:
-			break;
-		}
-	}
-
-	return ret;
+	return attach_to_pi_owner(uval, key, ps);
 }
 
 /**
@@ -1186,22 +1169,6 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	return 0;
 }
 
-static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
-{
-	u32 uninitialized_var(oldval);
-
-	/*
-	 * There is no waiter, so we unlock the futex. The owner died
-	 * bit has not to be preserved here. We are the owner:
-	 */
-	if (cmpxchg_futex_value_locked(&oldval, uaddr, uval, 0))
-		return -EFAULT;
-	if (oldval != uval)
-		return -EAGAIN;
-
-	return 0;
-}
-
 /*
  * Express the locking dependencies for lockdep:
  */
@@ -1659,7 +1626,12 @@ retry_private:
 				goto retry;
 			goto out;
 		case -EAGAIN:
-			/* The owner was exiting, try again. */
+			/*
+			 * Two reasons for this:
+			 * - Owner is exiting and we just wait for the
+			 *   exit to complete.
+			 * - The user space value changed.
+			 */
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
@@ -1718,7 +1690,7 @@ retry_private:
 			this->pi_state = pi_state;
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
-							this->task, 1);
+							this->task);
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
@@ -2316,8 +2288,10 @@ retry_private:
 			goto uaddr_faulted;
 		case -EAGAIN:
 			/*
-			 * Task is exiting and we just wait for the
-			 * exit to complete.
+			 * Two reasons for this:
+			 * - Task is exiting and we just wait for the
+			 *   exit to complete.
+			 * - The user space value changed.
 			 */
 			queue_unlock(hb);
 			put_futex_key(&q.key);
@@ -2337,9 +2311,9 @@ retry_private:
 	/*
 	 * Block on the PI mutex:
 	 */
-	if (!trylock)
-		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);
-	else {
+	if (!trylock) {
+		ret = rt_mutex_timed_futex_lock(&q.pi_state->pi_mutex, to);
+	} else {
 		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
 		ret = ret ? 0 : -EWOULDBLOCK;
@@ -2401,10 +2375,10 @@ uaddr_faulted:
  */
 static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
-	struct futex_hash_bucket *hb;
-	struct futex_q *this, *next;
+	u32 uninitialized_var(curval), uval, vpid = task_pid_vnr(current);
 	union futex_key key = FUTEX_KEY_INIT;
-	u32 uval, vpid = task_pid_vnr(current);
+	struct futex_hash_bucket *hb;
+	struct futex_q *match;
 	int ret;
 
 retry:
@@ -2417,57 +2391,47 @@ retry:
 		return -EPERM;
 
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
-	if (unlikely(ret != 0))
-		goto out;
+	if (ret)
+		return ret;
 
 	hb = hash_futex(&key);
 	spin_lock(&hb->lock);
 
 	/*
-	 * To avoid races, try to do the TID -> 0 atomic transition
-	 * again. If it succeeds then we can return without waking
-	 * anyone else up. We only try this if neither the waiters nor
-	 * the owner died bit are set.
-	 */
-	if (!(uval & ~FUTEX_TID_MASK) &&
-	    cmpxchg_futex_value_locked(&uval, uaddr, vpid, 0))
-		goto pi_faulted;
-	/*
-	 * Rare case: we managed to release the lock atomically,
-	 * no need to wake anyone else up:
-	 */
-	if (unlikely(uval == vpid))
-		goto out_unlock;
-
-	/*
-	 * Ok, other tasks may need to be woken up - check waiters
-	 * and do the wakeup if necessary:
+	 * Check waiters first. We do not trust user space values at
+	 * all and we at least want to know if user space fiddled
+	 * with the futex value instead of blindly unlocking.
 	 */
-	plist_for_each_entry_safe(this, next, &hb->chain, list) {
-		if (!match_futex (&this->key, &key))
-			continue;
-		ret = wake_futex_pi(uaddr, uval, this);
+	match = futex_top_waiter(hb, &key);
+	if (match) {
+		ret = wake_futex_pi(uaddr, uval, match);
 		/*
-		 * The atomic access to the futex value
-		 * generated a pagefault, so retry the
-		 * user-access and the wakeup:
+		 * The atomic access to the futex value generated a
+		 * pagefault, so retry the user-access and the wakeup:
 		 */
 		if (ret == -EFAULT)
 			goto pi_faulted;
 		goto out_unlock;
 	}
+
 	/*
-	 * No waiters - kernel unlocks the futex:
+	 * We have no kernel internal state, i.e. no waiters in the
+	 * kernel. Waiters which are about to queue themselves are stuck
+	 * on hb->lock. So we can safely ignore them. We do neither
+	 * preserve the WAITERS bit not the OWNER_DIED one. We are the
+	 * owner.
 	 */
-	ret = unlock_futex_pi(uaddr, uval);
-	if (ret == -EFAULT)
+	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))
 		goto pi_faulted;
 
+	/*
+	 * If uval has changed, let user space handle it.
+	 */
+	ret = (curval == uval) ? 0 : -EAGAIN;
+
 out_unlock:
 	spin_unlock(&hb->lock);
 	put_futex_key(&key);
-
-out:
 	return ret;
 
 pi_faulted:
@@ -2669,7 +2633,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		 */
 		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
-		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
+		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
 		spin_lock(q.lock_ptr);
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e433..88d0d44 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -384,7 +384,9 @@ static void print_lockdep_off(const char *bug_msg)
 {
 	printk(KERN_DEBUG "%s\n", bug_msg);
 	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
+#ifdef CONFIG_LOCK_STAT
 	printk(KERN_DEBUG "Please attach the output of /proc/lock_stat to the bug report\n");
+#endif
 }
 
 static int save_trace(struct stack_trace *trace)
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index be9ee15..9887a90 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -1,6 +1,4 @@
-
 #include <linux/percpu.h>
-#include <linux/mutex.h>
 #include <linux/sched.h>
 #include "mcs_spinlock.h"
 
@@ -79,7 +77,7 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 				break;
 		}
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 
 	return next;
@@ -120,7 +118,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 		if (need_resched())
 			goto unqueue;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	return true;
 
@@ -146,7 +144,7 @@ unqueue:
 		if (smp_load_acquire(&node->locked))
 			return true;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 
 		/*
 		 * Or we race against a concurrent unqueue()'s step-B, in which
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index 74356dc..23e89c5 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -27,7 +27,7 @@ struct mcs_spinlock {
 #define arch_mcs_spin_lock_contended(l)					\
 do {									\
 	while (!(smp_load_acquire(l)))					\
-		arch_mutex_cpu_relax();					\
+		cpu_relax_lowlatency();					\
 } while (0)
 #endif
 
@@ -104,7 +104,7 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 			return;
 		/* Wait until the next pointer is set */
 		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
+			cpu_relax_lowlatency();
 	}
 
 	/* Pass lock to next waiter. */
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index acca2c1..ae712b2 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -46,12 +46,6 @@
 # include <asm/mutex.h>
 #endif
 
-/*
- * A negative mutex count indicates that waiters are sleeping waiting for the
- * mutex.
- */
-#define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
-
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -152,7 +146,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 		if (need_resched())
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	rcu_read_unlock();
 
@@ -388,12 +382,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	/*
 	 * Optimistic spinning.
 	 *
-	 * We try to spin for acquisition when we find that there are no
-	 * pending waiters and the lock owner is currently running on a
-	 * (different) CPU.
-	 *
-	 * The rationale is that if the lock owner is running, it is likely to
-	 * release the lock soon.
+	 * We try to spin for acquisition when we find that the lock owner
+	 * is currently running on a (different) CPU and while we don't
+	 * need to reschedule. The rationale is that if the lock owner is
+	 * running, it is likely to release the lock soon.
 	 *
 	 * Since this needs the lock owner, and this mutex implementation
 	 * doesn't track the owner atomically in the lock field, we need to
@@ -440,7 +432,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if ((atomic_read(&lock->count) == 1) &&
+		/* Try to acquire the mutex if it is unlocked. */
+		if (!mutex_is_locked(lock) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
 			if (use_ww_ctx) {
@@ -471,7 +464,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	osq_unlock(&lock->osq);
 slowpath:
@@ -485,8 +478,11 @@ slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
-	/* once more, can we acquire the lock? */
-	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
+	/*
+	 * Once more, try to acquire the lock. Only try-lock the mutex if
+	 * it is unlocked to reduce unnecessary xchg() operations.
+	 */
+	if (!mutex_is_locked(lock) && (atomic_xchg(&lock->count, 0) == 1))
 		goto skip_wait;
 
 	debug_mutex_lock_common(lock, &waiter);
@@ -506,9 +502,10 @@ slowpath:
 		 * it's unlocked. Later on, if we sleep, this is the
 		 * operation that gives us the lock. We xchg it to -1, so
 		 * that when we release the lock, we properly wake up the
-		 * other waiters:
+		 * other waiters. We only attempt the xchg if the count is
+		 * non-negative in order to avoid unnecessary xchg operations:
 		 */
-		if (MUTEX_SHOW_NO_WAITER(lock) &&
+		if (atomic_read(&lock->count) >= 0 &&
 		    (atomic_xchg(&lock->count, -1) == 1))
 			break;
 
@@ -823,6 +820,10 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 	unsigned long flags;
 	int prev;
 
+	/* No need to trylock if the mutex is locked. */
+	if (mutex_is_locked(lock))
+		return 0;
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index fb5b8ac..f956ede 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -20,7 +20,6 @@
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
-#include <linux/mutex.h>
 #include <asm/qrwlock.h>
 
 /**
@@ -35,7 +34,7 @@ static __always_inline void
 rspin_until_writer_unlock(struct qrwlock *lock, u32 cnts)
 {
 	while ((cnts & _QW_WMASK) == _QW_LOCKED) {
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 		cnts = smp_load_acquire((u32 *)&lock->cnts);
 	}
 }
@@ -75,7 +74,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	 * to make sure that the write lock isn't taken.
 	 */
 	while (atomic_read(&lock->cnts) & _QW_WMASK)
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 
 	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
 	rspin_until_writer_unlock(lock, cnts);
@@ -114,7 +113,7 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
 				    cnts | _QW_WAITING) == cnts))
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 
 	/* When no more readers, set the locked flag */
@@ -125,7 +124,7 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
 				    _QW_LOCKED) == _QW_WAITING))
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 unlock:
 	arch_spin_unlock(&lock->lock);
diff --git a/kernel/locking/rtmutex-debug.c b/kernel/locking/rtmutex-debug.c
index 49b2ed3..62b6cee 100644
--- a/kernel/locking/rtmutex-debug.c
+++ b/kernel/locking/rtmutex-debug.c
@@ -66,12 +66,13 @@ void rt_mutex_debug_task_free(struct task_struct *task)
  * the deadlock. We print when we return. act_waiter can be NULL in
  * case of a remove waiter operation.
  */
-void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *act_waiter,
+void debug_rt_mutex_deadlock(enum rtmutex_chainwalk chwalk,
+			     struct rt_mutex_waiter *act_waiter,
 			     struct rt_mutex *lock)
 {
 	struct task_struct *task;
 
-	if (!debug_locks || detect || !act_waiter)
+	if (!debug_locks || chwalk == RT_MUTEX_FULL_CHAINWALK || !act_waiter)
 		return;
 
 	task = rt_mutex_owner(act_waiter->lock);
diff --git a/kernel/locking/rtmutex-debug.h b/kernel/locking/rtmutex-debug.h
index ab29b6a..d0519c3 100644
--- a/kernel/locking/rtmutex-debug.h
+++ b/kernel/locking/rtmutex-debug.h
@@ -20,14 +20,15 @@ extern void debug_rt_mutex_unlock(struct rt_mutex *lock);
 extern void debug_rt_mutex_proxy_lock(struct rt_mutex *lock,
 				      struct task_struct *powner);
 extern void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock);
-extern void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *waiter,
+extern void debug_rt_mutex_deadlock(enum rtmutex_chainwalk chwalk,
+				    struct rt_mutex_waiter *waiter,
 				    struct rt_mutex *lock);
 extern void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter);
 # define debug_rt_mutex_reset_waiter(w)			\
 	do { (w)->deadlock_lock = NULL; } while (0)
 
-static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
-						 int detect)
+static inline bool debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
+						  enum rtmutex_chainwalk walk)
 {
 	return (waiter != NULL);
 }
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index fc60594..a0ea2a1 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -308,6 +308,32 @@ static void rt_mutex_adjust_prio(struct task_struct *task)
 }
 
 /*
+ * Deadlock detection is conditional:
+ *
+ * If CONFIG_DEBUG_RT_MUTEXES=n, deadlock detection is only conducted
+ * if the detect argument is == RT_MUTEX_FULL_CHAINWALK.
+ *
+ * If CONFIG_DEBUG_RT_MUTEXES=y, deadlock detection is always
+ * conducted independent of the detect argument.
+ *
+ * If the waiter argument is NULL this indicates the deboost path and
+ * deadlock detection is disabled independent of the detect argument
+ * and the config settings.
+ */
+static bool rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
+					  enum rtmutex_chainwalk chwalk)
+{
+	/*
+	 * This is just a wrapper function for the following call,
+	 * because debug_rt_mutex_detect_deadlock() smells like a magic
+	 * debug feature and I wanted to keep the cond function in the
+	 * main source file along with the comments instead of having
+	 * two of the same in the headers.
+	 */
+	return debug_rt_mutex_detect_deadlock(waiter, chwalk);
+}
+
+/*
  * Max number of times we'll walk the boosting chain:
  */
 int max_lock_depth = 1024;
@@ -337,21 +363,65 @@ static inline struct rt_mutex *task_blocked_on_lock(struct task_struct *p)
  * @top_task:	the current top waiter
  *
  * Returns 0 or -EDEADLK.
+ *
+ * Chain walk basics and protection scope
+ *
+ * [R] refcount on task
+ * [P] task->pi_lock held
+ * [L] rtmutex->wait_lock held
+ *
+ * Step	Description				Protected by
+ *	function arguments:
+ *	@task					[R]
+ *	@orig_lock if != NULL			@top_task is blocked on it
+ *	@next_lock				Unprotected. Cannot be
+ *						dereferenced. Only used for
+ *						comparison.
+ *	@orig_waiter if != NULL			@top_task is blocked on it
+ *	@top_task				current, or in case of proxy
+ *						locking protected by calling
+ *						code
+ *	again:
+ *	  loop_sanity_check();
+ *	retry:
+ * [1]	  lock(task->pi_lock);			[R] acquire [P]
+ * [2]	  waiter = task->pi_blocked_on;		[P]
+ * [3]	  check_exit_conditions_1();		[P]
+ * [4]	  lock = waiter->lock;			[P]
+ * [5]	  if (!try_lock(lock->wait_lock)) {	[P] try to acquire [L]
+ *	    unlock(task->pi_lock);		release [P]
+ *	    goto retry;
+ *	  }
+ * [6]	  check_exit_conditions_2();		[P] + [L]
+ * [7]	  requeue_lock_waiter(lock, waiter);	[P] + [L]
+ * [8]	  unlock(task->pi_lock);		release [P]
+ *	  put_task_struct(task);		release [R]
+ * [9]	  check_exit_conditions_3();		[L]
+ * [10]	  task = owner(lock);			[L]
+ *	  get_task_struct(task);		[L] acquire [R]
+ *	  lock(task->pi_lock);			[L] acquire [P]
+ * [11]	  requeue_pi_waiter(tsk, waiters(lock));[P] + [L]
+ * [12]	  check_exit_conditions_4();		[P] + [L]
+ * [13]	  unlock(task->pi_lock);		release [P]
+ *	  unlock(lock->wait_lock);		release [L]
+ *	  goto again;
  */
 static int rt_mutex_adjust_prio_chain(struct task_struct *task,
-				      int deadlock_detect,
+				      enum rtmutex_chainwalk chwalk,
 				      struct rt_mutex *orig_lock,
 				      struct rt_mutex *next_lock,
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
-	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
-	int detect_deadlock, ret = 0, depth = 0;
+	struct rt_mutex_waiter *prerequeue_top_waiter;
+	int ret = 0, depth = 0;
+	struct rt_mutex *lock;
+	bool detect_deadlock;
 	unsigned long flags;
+	bool requeue = true;
 
-	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
-							 deadlock_detect);
+	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter, chwalk);
 
 	/*
 	 * The (de)boosting is a step by step approach with a lot of
@@ -360,6 +430,9 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * carefully whether things change under us.
 	 */
  again:
+	/*
+	 * We limit the lock chain length for each invocation.
+	 */
 	if (++depth > max_lock_depth) {
 		static int prev_max;
 
@@ -377,13 +450,28 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 		return -EDEADLK;
 	}
+
+	/*
+	 * We are fully preemptible here and only hold the refcount on
+	 * @task. So everything can have changed under us since the
+	 * caller or our own code below (goto retry/again) dropped all
+	 * locks.
+	 */
  retry:
 	/*
-	 * Task can not go away as we did a get_task() before !
+	 * [1] Task cannot go away as we did a get_task() before !
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
+	/*
+	 * [2] Get the waiter on which @task is blocked on.
+	 */
 	waiter = task->pi_blocked_on;
+
+	/*
+	 * [3] check_exit_conditions_1() protected by task->pi_lock.
+	 */
+
 	/*
 	 * Check whether the end of the boosting chain has been
 	 * reached or the state of the chain has changed while we
@@ -421,20 +509,41 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 			goto out_unlock_pi;
 		/*
 		 * If deadlock detection is off, we stop here if we
-		 * are not the top pi waiter of the task.
+		 * are not the top pi waiter of the task. If deadlock
+		 * detection is enabled we continue, but stop the
+		 * requeueing in the chain walk.
 		 */
-		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
-			goto out_unlock_pi;
+		if (top_waiter != task_top_pi_waiter(task)) {
+			if (!detect_deadlock)
+				goto out_unlock_pi;
+			else
+				requeue = false;
+		}
 	}
 
 	/*
-	 * When deadlock detection is off then we check, if further
-	 * priority adjustment is necessary.
+	 * If the waiter priority is the same as the task priority
+	 * then there is no further priority adjustment necessary.  If
+	 * deadlock detection is off, we stop the chain walk. If its
+	 * enabled we continue, but stop the requeueing in the chain
+	 * walk.
 	 */
-	if (!detect_deadlock && waiter->prio == task->prio)
-		goto out_unlock_pi;
+	if (waiter->prio == task->prio) {
+		if (!detect_deadlock)
+			goto out_unlock_pi;
+		else
+			requeue = false;
+	}
 
+	/*
+	 * [4] Get the next lock
+	 */
 	lock = waiter->lock;
+	/*
+	 * [5] We need to trylock here as we are holding task->pi_lock,
+	 * which is the reverse lock order versus the other rtmutex
+	 * operations.
+	 */
 	if (!raw_spin_trylock(&lock->wait_lock)) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		cpu_relax();
@@ -442,79 +551,180 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	}
 
 	/*
+	 * [6] check_exit_conditions_2() protected by task->pi_lock and
+	 * lock->wait_lock.
+	 *
 	 * Deadlock detection. If the lock is the same as the original
 	 * lock which caused us to walk the lock chain or if the
 	 * current lock is owned by the task which initiated the chain
 	 * walk, we detected a deadlock.
 	 */
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
-		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
+		debug_rt_mutex_deadlock(chwalk, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
 		ret = -EDEADLK;
 		goto out_unlock_pi;
 	}
 
-	top_waiter = rt_mutex_top_waiter(lock);
+	/*
+	 * If we just follow the lock chain for deadlock detection, no
+	 * need to do all the requeue operations. To avoid a truckload
+	 * of conditionals around the various places below, just do the
+	 * minimum chain walk checks.
+	 */
+	if (!requeue) {
+		/*
+		 * No requeue[7] here. Just release @task [8]
+		 */
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		put_task_struct(task);
+
+		/*
+		 * [9] check_exit_conditions_3 protected by lock->wait_lock.
+		 * If there is no owner of the lock, end of chain.
+		 */
+		if (!rt_mutex_owner(lock)) {
+			raw_spin_unlock(&lock->wait_lock);
+			return 0;
+		}
+
+		/* [10] Grab the next task, i.e. owner of @lock */
+		task = rt_mutex_owner(lock);
+		get_task_struct(task);
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+		/*
+		 * No requeue [11] here. We just do deadlock detection.
+		 *
+		 * [12] Store whether owner is blocked
+		 * itself. Decision is made after dropping the locks
+		 */
+		next_lock = task_blocked_on_lock(task);
+		/*
+		 * Get the top waiter for the next iteration
+		 */
+		top_waiter = rt_mutex_top_waiter(lock);
+
+		/* [13] Drop locks */
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
+
+		/* If owner is not blocked, end of chain. */
+		if (!next_lock)
+			goto out_put_task;
+		goto again;
+	}
 
-	/* Requeue the waiter */
+	/*
+	 * Store the current top waiter before doing the requeue
+	 * operation on @lock. We need it for the boost/deboost
+	 * decision below.
+	 */
+	prerequeue_top_waiter = rt_mutex_top_waiter(lock);
+
+	/* [7] Requeue the waiter in the lock waiter list. */
 	rt_mutex_dequeue(lock, waiter);
 	waiter->prio = task->prio;
 	rt_mutex_enqueue(lock, waiter);
 
-	/* Release the task */
+	/* [8] Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	put_task_struct(task);
+
+	/*
+	 * [9] check_exit_conditions_3 protected by lock->wait_lock.
+	 *
+	 * We must abort the chain walk if there is no lock owner even
+	 * in the dead lock detection case, as we have nothing to
+	 * follow here. This is the end of the chain we are walking.
+	 */
 	if (!rt_mutex_owner(lock)) {
 		/*
-		 * If the requeue above changed the top waiter, then we need
-		 * to wake the new top waiter up to try to get the lock.
+		 * If the requeue [7] above changed the top waiter,
+		 * then we need to wake the new top waiter up to try
+		 * to get the lock.
 		 */
-
-		if (top_waiter != rt_mutex_top_waiter(lock))
+		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
 		raw_spin_unlock(&lock->wait_lock);
-		goto out_put_task;
+		return 0;
 	}
-	put_task_struct(task);
 
-	/* Grab the next task */
+	/* [10] Grab the next task, i.e. the owner of @lock */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
+	/* [11] requeue the pi waiters if necessary */
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		/* Boost the owner */
-		rt_mutex_dequeue_pi(task, top_waiter);
+		/*
+		 * The waiter became the new top (highest priority)
+		 * waiter on the lock. Replace the previous top waiter
+		 * in the owner tasks pi waiters list with this waiter
+		 * and adjust the priority of the owner.
+		 */
+		rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
 		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 
-	} else if (top_waiter == waiter) {
-		/* Deboost the owner */
+	} else if (prerequeue_top_waiter == waiter) {
+		/*
+		 * The waiter was the top waiter on the lock, but is
+		 * no longer the top prority waiter. Replace waiter in
+		 * the owner tasks pi waiters list with the new top
+		 * (highest priority) waiter and adjust the priority
+		 * of the owner.
+		 * The new top waiter is stored in @waiter so that
+		 * @waiter == @top_waiter evaluates to true below and
+		 * we continue to deboost the rest of the chain.
+		 */
 		rt_mutex_dequeue_pi(task, waiter);
 		waiter = rt_mutex_top_waiter(lock);
 		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
+	} else {
+		/*
+		 * Nothing changed. No need to do any priority
+		 * adjustment.
+		 */
 	}
 
 	/*
+	 * [12] check_exit_conditions_4() protected by task->pi_lock
+	 * and lock->wait_lock. The actual decisions are made after we
+	 * dropped the locks.
+	 *
 	 * Check whether the task which owns the current lock is pi
 	 * blocked itself. If yes we store a pointer to the lock for
 	 * the lock chain change detection above. After we dropped
 	 * task->pi_lock next_lock cannot be dereferenced anymore.
 	 */
 	next_lock = task_blocked_on_lock(task);
+	/*
+	 * Store the top waiter of @lock for the end of chain walk
+	 * decision below.
+	 */
+	top_waiter = rt_mutex_top_waiter(lock);
 
+	/* [13] Drop the locks */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-
-	top_waiter = rt_mutex_top_waiter(lock);
 	raw_spin_unlock(&lock->wait_lock);
 
 	/*
+	 * Make the actual exit decisions [12], based on the stored
+	 * values.
+	 *
 	 * We reached the end of the lock chain. Stop right here. No
 	 * point to go back just to figure that out.
 	 */
 	if (!next_lock)
 		goto out_put_task;
 
+	/*
+	 * If the current waiter is not the top waiter on the lock,
+	 * then we can stop the chain walk here if we are not in full
+	 * deadlock detection mode.
+	 */
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
 
@@ -533,76 +743,119 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
  *
  * Must be called with lock->wait_lock held.
  *
- * @lock:   the lock to be acquired.
- * @task:   the task which wants to acquire the lock
- * @waiter: the waiter that is queued to the lock's wait list. (could be NULL)
+ * @lock:   The lock to be acquired.
+ * @task:   The task which wants to acquire the lock
+ * @waiter: The waiter that is queued to the lock's wait list if the
+ *	    callsite called task_blocked_on_lock(), otherwise NULL
  */
 static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
-		struct rt_mutex_waiter *waiter)
+				struct rt_mutex_waiter *waiter)
 {
+	unsigned long flags;
+
 	/*
-	 * We have to be careful here if the atomic speedups are
-	 * enabled, such that, when
-	 *  - no other waiter is on the lock
-	 *  - the lock has been released since we did the cmpxchg
-	 * the lock can be released or taken while we are doing the
-	 * checks and marking the lock with RT_MUTEX_HAS_WAITERS.
+	 * Before testing whether we can acquire @lock, we set the
+	 * RT_MUTEX_HAS_WAITERS bit in @lock->owner. This forces all
+	 * other tasks which try to modify @lock into the slow path
+	 * and they serialize on @lock->wait_lock.
+	 *
+	 * The RT_MUTEX_HAS_WAITERS bit can have a transitional state
+	 * as explained at the top of this file if and only if:
 	 *
-	 * The atomic acquire/release aware variant of
-	 * mark_rt_mutex_waiters uses a cmpxchg loop. After setting
-	 * the WAITERS bit, the atomic release / acquire can not
-	 * happen anymore and lock->wait_lock protects us from the
-	 * non-atomic case.
+	 * - There is a lock owner. The caller must fixup the
+	 *   transient state if it does a trylock or leaves the lock
+	 *   function due to a signal or timeout.
 	 *
-	 * Note, that this might set lock->owner =
-	 * RT_MUTEX_HAS_WAITERS in the case the lock is not contended
-	 * any more. This is fixed up when we take the ownership.
-	 * This is the transitional state explained at the top of this file.
+	 * - @task acquires the lock and there are no other
+	 *   waiters. This is undone in rt_mutex_set_owner(@task) at
+	 *   the end of this function.
 	 */
 	mark_rt_mutex_waiters(lock);
 
+	/*
+	 * If @lock has an owner, give up.
+	 */
 	if (rt_mutex_owner(lock))
 		return 0;
 
 	/*
-	 * It will get the lock because of one of these conditions:
-	 * 1) there is no waiter
-	 * 2) higher priority than waiters
-	 * 3) it is top waiter
+	 * If @waiter != NULL, @task has already enqueued the waiter
+	 * into @lock waiter list. If @waiter == NULL then this is a
+	 * trylock attempt.
 	 */
-	if (rt_mutex_has_waiters(lock)) {
-		if (task->prio >= rt_mutex_top_waiter(lock)->prio) {
-			if (!waiter || waiter != rt_mutex_top_waiter(lock))
-				return 0;
-		}
-	}
-
-	if (waiter || rt_mutex_has_waiters(lock)) {
-		unsigned long flags;
-		struct rt_mutex_waiter *top;
-
-		raw_spin_lock_irqsave(&task->pi_lock, flags);
+	if (waiter) {
+		/*
+		 * If waiter is not the highest priority waiter of
+		 * @lock, give up.
+		 */
+		if (waiter != rt_mutex_top_waiter(lock))
+			return 0;
 
-		/* remove the queued waiter. */
-		if (waiter) {
-			rt_mutex_dequeue(lock, waiter);
-			task->pi_blocked_on = NULL;
-		}
+		/*
+		 * We can acquire the lock. Remove the waiter from the
+		 * lock waiters list.
+		 */
+		rt_mutex_dequeue(lock, waiter);
 
+	} else {
 		/*
-		 * We have to enqueue the top waiter(if it exists) into
-		 * task->pi_waiters list.
+		 * If the lock has waiters already we check whether @task is
+		 * eligible to take over the lock.
+		 *
+		 * If there are no other waiters, @task can acquire
+		 * the lock.  @task->pi_blocked_on is NULL, so it does
+		 * not need to be dequeued.
 		 */
 		if (rt_mutex_has_waiters(lock)) {
-			top = rt_mutex_top_waiter(lock);
-			rt_mutex_enqueue_pi(task, top);
+			/*
+			 * If @task->prio is greater than or equal to
+			 * the top waiter priority (kernel view),
+			 * @task lost.
+			 */
+			if (task->prio >= rt_mutex_top_waiter(lock)->prio)
+				return 0;
+
+			/*
+			 * The current top waiter stays enqueued. We
+			 * don't have to change anything in the lock
+			 * waiters order.
+			 */
+		} else {
+			/*
+			 * No waiters. Take the lock without the
+			 * pi_lock dance.@task->pi_blocked_on is NULL
+			 * and we have no waiters to enqueue in @task
+			 * pi waiters list.
+			 */
+			goto takeit;
 		}
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
 
+	/*
+	 * Clear @task->pi_blocked_on. Requires protection by
+	 * @task->pi_lock. Redundant operation for the @waiter == NULL
+	 * case, but conditionals are more expensive than a redundant
+	 * store.
+	 */
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	task->pi_blocked_on = NULL;
+	/*
+	 * Finish the lock acquisition. @task is the new owner. If
+	 * other waiters exist we have to insert the highest priority
+	 * waiter into @task->pi_waiters list.
+	 */
+	if (rt_mutex_has_waiters(lock))
+		rt_mutex_enqueue_pi(task, rt_mutex_top_waiter(lock));
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+takeit:
 	/* We got the lock. */
 	debug_rt_mutex_lock(lock);
 
+	/*
+	 * This either preserves the RT_MUTEX_HAS_WAITERS bit if there
+	 * are still waiters or clears it.
+	 */
 	rt_mutex_set_owner(lock, task);
 
 	rt_mutex_deadlock_account_lock(lock, task);
@@ -620,7 +873,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
 				   struct task_struct *task,
-				   int detect_deadlock)
+				   enum rtmutex_chainwalk chwalk)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
@@ -666,7 +919,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 		__rt_mutex_adjust_prio(owner);
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
-	} else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock)) {
+	} else if (rt_mutex_cond_detect_deadlock(waiter, chwalk)) {
 		chain_walk = 1;
 	}
 
@@ -691,7 +944,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock,
+	res = rt_mutex_adjust_prio_chain(owner, chwalk, lock,
 					 next_lock, waiter, task);
 
 	raw_spin_lock(&lock->wait_lock);
@@ -753,9 +1006,9 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 static void remove_waiter(struct rt_mutex *lock,
 			  struct rt_mutex_waiter *waiter)
 {
-	int first = (waiter == rt_mutex_top_waiter(lock));
+	bool is_top_waiter = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
-	struct rt_mutex *next_lock = NULL;
+	struct rt_mutex *next_lock;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
@@ -763,29 +1016,31 @@ static void remove_waiter(struct rt_mutex *lock,
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	if (!owner)
+	/*
+	 * Only update priority if the waiter was the highest priority
+	 * waiter of the lock and there is an owner to update.
+	 */
+	if (!owner || !is_top_waiter)
 		return;
 
-	if (first) {
-
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+	raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
-		rt_mutex_dequeue_pi(owner, waiter);
+	rt_mutex_dequeue_pi(owner, waiter);
 
-		if (rt_mutex_has_waiters(lock)) {
-			struct rt_mutex_waiter *next;
+	if (rt_mutex_has_waiters(lock))
+		rt_mutex_enqueue_pi(owner, rt_mutex_top_waiter(lock));
 
-			next = rt_mutex_top_waiter(lock);
-			rt_mutex_enqueue_pi(owner, next);
-		}
-		__rt_mutex_adjust_prio(owner);
+	__rt_mutex_adjust_prio(owner);
 
-		/* Store the lock on which owner is blocked or NULL */
-		next_lock = task_blocked_on_lock(owner);
+	/* Store the lock on which owner is blocked or NULL */
+	next_lock = task_blocked_on_lock(owner);
 
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
-	}
+	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 
+	/*
+	 * Don't walk the chain, if the owner task is not blocked
+	 * itself.
+	 */
 	if (!next_lock)
 		return;
 
@@ -794,7 +1049,8 @@ static void remove_waiter(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	rt_mutex_adjust_prio_chain(owner, 0, lock, next_lock, NULL, current);
+	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
+				   next_lock, NULL, current);
 
 	raw_spin_lock(&lock->wait_lock);
 }
@@ -824,7 +1080,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(task);
 
-	rt_mutex_adjust_prio_chain(task, 0, NULL, next_lock, NULL, task);
+	rt_mutex_adjust_prio_chain(task, RT_MUTEX_MIN_CHAINWALK, NULL,
+				   next_lock, NULL, task);
 }
 
 /**
@@ -902,7 +1159,7 @@ static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
 static int __sched
 rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		  struct hrtimer_sleeper *timeout,
-		  int detect_deadlock)
+		  enum rtmutex_chainwalk chwalk)
 {
 	struct rt_mutex_waiter waiter;
 	int ret = 0;
@@ -928,7 +1185,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 			timeout->task = NULL;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current, chwalk);
 
 	if (likely(!ret))
 		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
@@ -937,7 +1194,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 	if (unlikely(ret)) {
 		remove_waiter(lock, &waiter);
-		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
+		rt_mutex_handle_deadlock(ret, chwalk, &waiter);
 	}
 
 	/*
@@ -960,22 +1217,31 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 /*
  * Slow path try-lock function:
  */
-static inline int
-rt_mutex_slowtrylock(struct rt_mutex *lock)
+static inline int rt_mutex_slowtrylock(struct rt_mutex *lock)
 {
-	int ret = 0;
+	int ret;
+
+	/*
+	 * If the lock already has an owner we fail to get the lock.
+	 * This can be done without taking the @lock->wait_lock as
+	 * it is only being read, and this is a trylock anyway.
+	 */
+	if (rt_mutex_owner(lock))
+		return 0;
 
+	/*
+	 * The mutex has currently no owner. Lock the wait lock and
+	 * try to acquire the lock.
+	 */
 	raw_spin_lock(&lock->wait_lock);
 
-	if (likely(rt_mutex_owner(lock) != current)) {
+	ret = try_to_take_rt_mutex(lock, current, NULL);
 
-		ret = try_to_take_rt_mutex(lock, current, NULL);
-		/*
-		 * try_to_take_rt_mutex() sets the lock waiters
-		 * bit unconditionally. Clean this up.
-		 */
-		fixup_rt_mutex_waiters(lock);
-	}
+	/*
+	 * try_to_take_rt_mutex() sets the lock waiters bit
+	 * unconditionally. Clean this up.
+	 */
+	fixup_rt_mutex_waiters(lock);
 
 	raw_spin_unlock(&lock->wait_lock);
 
@@ -1053,30 +1319,31 @@ rt_mutex_slowunlock(struct rt_mutex *lock)
  */
 static inline int
 rt_mutex_fastlock(struct rt_mutex *lock, int state,
-		  int detect_deadlock,
 		  int (*slowfn)(struct rt_mutex *lock, int state,
 				struct hrtimer_sleeper *timeout,
-				int detect_deadlock))
+				enum rtmutex_chainwalk chwalk))
 {
-	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
+	if (likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
 		return 0;
 	} else
-		return slowfn(lock, state, NULL, detect_deadlock);
+		return slowfn(lock, state, NULL, RT_MUTEX_MIN_CHAINWALK);
 }
 
 static inline int
 rt_mutex_timed_fastlock(struct rt_mutex *lock, int state,
-			struct hrtimer_sleeper *timeout, int detect_deadlock,
+			struct hrtimer_sleeper *timeout,
+			enum rtmutex_chainwalk chwalk,
 			int (*slowfn)(struct rt_mutex *lock, int state,
 				      struct hrtimer_sleeper *timeout,
-				      int detect_deadlock))
+				      enum rtmutex_chainwalk chwalk))
 {
-	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
+	if (chwalk == RT_MUTEX_MIN_CHAINWALK &&
+	    likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
 		return 0;
 	} else
-		return slowfn(lock, state, timeout, detect_deadlock);
+		return slowfn(lock, state, timeout, chwalk);
 }
 
 static inline int
@@ -1109,54 +1376,61 @@ void __sched rt_mutex_lock(struct rt_mutex *lock)
 {
 	might_sleep();
 
-	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, 0, rt_mutex_slowlock);
+	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock);
 
 /**
  * rt_mutex_lock_interruptible - lock a rt_mutex interruptible
  *
- * @lock: 		the rt_mutex to be locked
- * @detect_deadlock:	deadlock detection on/off
+ * @lock:		the rt_mutex to be locked
  *
  * Returns:
- *  0 		on success
- * -EINTR 	when interrupted by a signal
- * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
+ *  0		on success
+ * -EINTR	when interrupted by a signal
  */
-int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
-						 int detect_deadlock)
+int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock)
 {
 	might_sleep();
 
-	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE,
-				 detect_deadlock, rt_mutex_slowlock);
+	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE, rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
+/*
+ * Futex variant with full deadlock detection.
+ */
+int rt_mutex_timed_futex_lock(struct rt_mutex *lock,
+			      struct hrtimer_sleeper *timeout)
+{
+	might_sleep();
+
+	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
+				       RT_MUTEX_FULL_CHAINWALK,
+				       rt_mutex_slowlock);
+}
+
 /**
  * rt_mutex_timed_lock - lock a rt_mutex interruptible
  *			the timeout structure is provided
  *			by the caller
  *
- * @lock: 		the rt_mutex to be locked
+ * @lock:		the rt_mutex to be locked
  * @timeout:		timeout structure or NULL (no timeout)
- * @detect_deadlock:	deadlock detection on/off
  *
  * Returns:
- *  0 		on success
- * -EINTR 	when interrupted by a signal
+ *  0		on success
+ * -EINTR	when interrupted by a signal
  * -ETIMEDOUT	when the timeout expired
- * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
  */
 int
-rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout,
-		    int detect_deadlock)
+rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
 {
 	might_sleep();
 
 	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
-				       detect_deadlock, rt_mutex_slowlock);
+				       RT_MUTEX_MIN_CHAINWALK,
+				       rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
 
@@ -1262,7 +1536,6 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
  * @lock:		the rt_mutex to take
  * @waiter:		the pre-initialized rt_mutex_waiter
  * @task:		the task to prepare
- * @detect_deadlock:	perform deadlock detection (1) or not (0)
  *
  * Returns:
  *  0 - task blocked on lock
@@ -1273,7 +1546,7 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
  */
 int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
-			      struct task_struct *task, int detect_deadlock)
+			      struct task_struct *task)
 {
 	int ret;
 
@@ -1285,7 +1558,8 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	}
 
 	/* We enforce deadlock detection for futexes */
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
+	ret = task_blocks_on_rt_mutex(lock, waiter, task,
+				      RT_MUTEX_FULL_CHAINWALK);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
@@ -1331,22 +1605,20 @@ struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock)
  * rt_mutex_finish_proxy_lock() - Complete lock acquisition
  * @lock:		the rt_mutex we were woken on
  * @to:			the timeout, null if none. hrtimer should already have
- * 			been started.
+ *			been started.
  * @waiter:		the pre-initialized rt_mutex_waiter
- * @detect_deadlock:	perform deadlock detection (1) or not (0)
  *
  * Complete the lock acquisition started our behalf by another thread.
  *
  * Returns:
  *  0 - success
- * <0 - error, one of -EINTR, -ETIMEDOUT, or -EDEADLK
+ * <0 - error, one of -EINTR, -ETIMEDOUT
  *
  * Special API call for PI-futex requeue support
  */
 int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 			       struct hrtimer_sleeper *to,
-			       struct rt_mutex_waiter *waiter,
-			       int detect_deadlock)
+			       struct rt_mutex_waiter *waiter)
 {
 	int ret;
 
diff --git a/kernel/locking/rtmutex.h b/kernel/locking/rtmutex.h
index f6a1f3c..c406058 100644
--- a/kernel/locking/rtmutex.h
+++ b/kernel/locking/rtmutex.h
@@ -22,10 +22,15 @@
 #define debug_rt_mutex_init(m, n)			do { } while (0)
 #define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
 #define debug_rt_mutex_print_deadlock(w)		do { } while (0)
-#define debug_rt_mutex_detect_deadlock(w,d)		(d)
 #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
 
 static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
 {
 	WARN(1, "rtmutex deadlock detected\n");
 }
+
+static inline bool debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *w,
+						  enum rtmutex_chainwalk walk)
+{
+	return walk == RT_MUTEX_FULL_CHAINWALK;
+}
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index 7431a9c..8552125 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -102,6 +102,21 @@ static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
 }
 
 /*
+ * Constants for rt mutex functions which have a selectable deadlock
+ * detection.
+ *
+ * RT_MUTEX_MIN_CHAINWALK:	Stops the lock chain walk when there are
+ *				no further PI adjustments to be made.
+ *
+ * RT_MUTEX_FULL_CHAINWALK:	Invoke deadlock detection with a full
+ *				walk of the lock chain.
+ */
+enum rtmutex_chainwalk {
+	RT_MUTEX_MIN_CHAINWALK,
+	RT_MUTEX_FULL_CHAINWALK,
+};
+
+/*
  * PI-futex support (proxy locking functions, etc.):
  */
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
@@ -111,12 +126,11 @@ extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 				  struct task_struct *proxy_owner);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
-				     struct task_struct *task,
-				     int detect_deadlock);
+				     struct task_struct *task);
 extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 				      struct hrtimer_sleeper *to,
-				      struct rt_mutex_waiter *waiter,
-				      int detect_deadlock);
+				      struct rt_mutex_waiter *waiter);
+extern int rt_mutex_timed_futex_lock(struct rt_mutex *l, struct hrtimer_sleeper *to);
 
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # include "rtmutex-debug.h"
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index a2391ac..d6203fa 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -329,7 +329,7 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
 		if (need_resched())
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	rcu_read_unlock();
 
@@ -381,7 +381,7 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		arch_mutex_cpu_relax();
+		cpu_relax_lowlatency();
 	}
 	osq_unlock(&sem->osq);
 done:
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa..f488bef 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -835,7 +835,7 @@ config DEBUG_RT_MUTEXES
 
 config RT_MUTEX_TESTER
 	bool "Built-in scriptable tester for rt-mutexes"
-	depends on DEBUG_KERNEL && RT_MUTEXES
+	depends on DEBUG_KERNEL && RT_MUTEXES && BROKEN
 	help
 	  This option enables a rt-mutex tester.
 
diff --git a/lib/lockref.c b/lib/lockref.c
index f07a40d..d2233de 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -1,6 +1,5 @@
 #include <linux/export.h>
 #include <linux/lockref.h>
-#include <linux/mutex.h>
 
 #if USE_CMPXCHG_LOCKREF
 
@@ -29,7 +28,7 @@
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
-		arch_mutex_cpu_relax();						\
+		cpu_relax_lowlatency();						\
 	}									\
 } while (0)
 
