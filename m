Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab3D3HGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:06:31 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:64350 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab3D3HGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:06:23 -0400
Date: Tue, 30 Apr 2013 09:06:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] SMP/hotplug changes for v3.10
Message-ID: <20130430070618.GA19892@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest smp-hotplug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp-hotplug-for-linus

   HEAD: d190e8195b90bc1e65c494fe08e54e9e581bfd16 idle: Remove GENERIC_IDLE_LOOP config switch

This is a pretty large, multi-arch series unifying and generalizing the 
various disjunct pieces of idle routines that architectures have 
historically copied from each other and have grown in random, wildly 
inconsistent and sometimes buggy directions:

 101 files changed, 455 insertions(+), 1328 deletions(-)

this went through a number of review and test iterations before it was 
committed, it was tested on various architectures, was exposed to 
linux-next for quite some time - nevertheless it might cause problems on 
architectures that don't read the mailing lists and don't regularly test 
linux-next.

This cat herding excercise was motivated by the -rt kernel, and was 
brought to you by Thomas "the Whip" Gleixner.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      bfin: Fix typo in arch_cpu_idle()

Paul Bolle (1):
      idle: Remove unused ARCH_HAS_DEFAULT_IDLE

Richard Weinberger (1):
      um: Use generic idle loop

Sam Ravnborg (1):
      sparc: Use generic idle loop

Thomas Gleixner (35):
      arch: Cleanup enable/disable_hlt
      arch: Consolidate tsk_is_polling()
      idle: Implement set/clr functions for need_resched poll
      idle: Provide a generic entry point for the idle code
      idle: Implement generic idle function
      arc: Use generic idle loop
      alpha: Use generic idle loop
      arm: Use generic idle loop
      arm64: Use generic idle loop
      avr32: Use generic idle loop
      bfin: Use generic idle loop
      c6x: Use generic idle loop
      cris: Use generic idle loop
      frv: Use generic idle loop
      h8300: Use generic idle loop
      hexagon: Use generic idle loop
      ia64: Use generic idle loop
      m32r: Use generic idle loop
      m68k: Use generic idle loop
      metag: Use generic idle loop
      microblaze: Use generic idle loop
      mips: Use generic idle loop
      mn10300: Use generic idle loop
      openrisc: Use generic idle loop
      parisc: Use generic idle loop
      powerpc: Use generic idle loop
      s390: Use generic idle loop
      score: Use generic idle loop
      sh: Use generic idle loop
      tile: Enter idle with preemption disabled
      tile: Use generic idle loop
      unicore: Use generic idle loop
      x86: Use generic idle loop
      xtensa: Use generic idle loop
      idle: Remove GENERIC_IDLE_LOOP config switch

Tony Luck (1):
      ia64: Make sure interrupts enabled when we "safe_halt()"


 arch/alpha/include/asm/thread_info.h      |   2 -
 arch/alpha/kernel/process.c               |  19 ------
 arch/alpha/kernel/smp.c                   |   3 +-
 arch/arc/kernel/process.c                 |  27 +-------
 arch/arc/kernel/smp.c                     |   2 +-
 arch/arm/Kconfig                          |   1 +
 arch/arm/include/asm/system_misc.h        |   3 -
 arch/arm/kernel/process.c                 | 100 ++++++++--------------------
 arch/arm/kernel/smp.c                     |   2 +-
 arch/arm/mach-gemini/idle.c               |   4 +-
 arch/arm/mach-gemini/irq.c                |   4 +-
 arch/arm/mach-ixp4xx/common.c             |   3 +-
 arch/arm/mach-omap1/pm.c                  |   6 +-
 arch/arm/mach-omap2/omap_hwmod.c          |   7 +-
 arch/arm/mach-omap2/pm.c                  |   5 +-
 arch/arm/mach-orion5x/board-dt.c          |   3 +-
 arch/arm/mach-orion5x/common.c            |   2 +-
 arch/arm/mach-shark/core.c                |   3 +-
 arch/arm/mach-shmobile/suspend.c          |   6 +-
 arch/arm/mach-w90x900/dev.c               |   3 +-
 arch/arm64/kernel/process.c               |  43 ++----------
 arch/arm64/kernel/smp.c                   |   2 +-
 arch/avr32/kernel/process.c               |  13 +---
 arch/avr32/kernel/time.c                  |   9 ++-
 arch/avr32/mach-at32ap/include/mach/pm.h  |  24 -------
 arch/avr32/mach-at32ap/pm-at32ap700x.S    |   7 --
 arch/blackfin/kernel/process.c            |  32 ++-------
 arch/blackfin/mach-common/smp.c           |   2 +-
 arch/c6x/kernel/process.c                 |  28 +-------
 arch/cris/arch-v10/kernel/process.c       |   3 +-
 arch/cris/arch-v32/kernel/process.c       |  12 +---
 arch/cris/arch-v32/kernel/smp.c           |   4 +-
 arch/cris/include/asm/processor.h         |   7 --
 arch/cris/kernel/process.c                |  49 +-------------
 arch/frv/kernel/process.c                 |  27 ++------
 arch/h8300/kernel/process.c               |  35 ++--------
 arch/hexagon/kernel/process.c             |  23 +------
 arch/hexagon/kernel/smp.c                 |   2 +-
 arch/ia64/include/asm/irqflags.h          |   1 +
 arch/ia64/include/asm/thread_info.h       |   2 -
 arch/ia64/kernel/perfmon.c                |  14 ++--
 arch/ia64/kernel/process.c                |  78 +++++-----------------
 arch/ia64/kernel/smpboot.c                |   2 +-
 arch/m32r/kernel/process.c                |  18 -----
 arch/m32r/kernel/smpboot.c                |   2 +-
 arch/m68k/kernel/process.c                |  32 ++-------
 arch/metag/include/asm/thread_info.h      |   2 -
 arch/metag/kernel/process.c               |  35 ++--------
 arch/metag/kernel/smp.c                   |   2 +-
 arch/microblaze/Kconfig                   |   1 +
 arch/microblaze/include/asm/processor.h   |   5 --
 arch/microblaze/include/asm/thread_info.h |   1 -
 arch/microblaze/kernel/process.c          |  65 ------------------
 arch/mips/kernel/process.c                |  48 +++++---------
 arch/mips/kernel/smp.c                    |   2 +-
 arch/mn10300/include/asm/thread_info.h    |   2 -
 arch/mn10300/kernel/process.c             |  70 ++-----------------
 arch/mn10300/kernel/smp.c                 |   7 +-
 arch/openrisc/include/asm/thread_info.h   |   2 -
 arch/openrisc/kernel/Makefile             |   2 +-
 arch/openrisc/kernel/idle.c               |  73 --------------------
 arch/parisc/include/asm/thread_info.h     |   2 -
 arch/parisc/kernel/process.c              |  22 ------
 arch/parisc/kernel/smp.c                  |   2 +-
 arch/powerpc/include/asm/thread_info.h    |   2 -
 arch/powerpc/kernel/idle.c                |  89 ++++++++-----------------
 arch/powerpc/kernel/smp.c                 |   2 +-
 arch/s390/kernel/process.c                |  32 +++------
 arch/s390/kernel/smp.c                    |   3 +-
 arch/s390/kernel/vtime.c                  |   5 --
 arch/score/kernel/process.c               |  18 -----
 arch/sh/Kconfig                           |   4 +-
 arch/sh/include/asm/thread_info.h         |   2 -
 arch/sh/kernel/idle.c                     | 101 +++-------------------------
 arch/sh/kernel/smp.c                      |   2 +-
 arch/sparc/include/asm/thread_info_32.h   |   2 -
 arch/sparc/include/asm/thread_info_64.h   |   2 -
 arch/sparc/kernel/hvtramp.S               |   3 +-
 arch/sparc/kernel/process_32.c            |  21 ++----
 arch/sparc/kernel/process_64.c            |  49 ++++----------
 arch/sparc/kernel/smp_32.c                |   2 +-
 arch/sparc/kernel/smp_64.c                |   2 +
 arch/sparc/kernel/trampoline_64.S         |   3 +-
 arch/tile/include/asm/thread_info.h       |   2 -
 arch/tile/kernel/process.c                |  65 +++---------------
 arch/tile/kernel/smpboot.c                |   4 +-
 arch/um/kernel/process.c                  |  27 ++------
 arch/unicore32/kernel/process.c           |  21 +-----
 arch/x86/Kconfig                          |   3 -
 arch/x86/include/asm/thread_info.h        |   2 -
 arch/x86/kernel/process.c                 | 105 ++++++++---------------------
 arch/x86/kernel/smpboot.c                 |   2 +-
 arch/x86/xen/smp.c                        |   2 +-
 arch/xtensa/kernel/process.c              |  14 +---
 include/linux/cpu.h                       |  16 +++++
 include/linux/sched.h                     |  41 ++++++++++++
 init/main.c                               |   2 +-
 kernel/Makefile                           |   1 +
 kernel/cpu/Makefile                       |   1 +
 kernel/cpu/idle.c                         | 107 ++++++++++++++++++++++++++++++
 kernel/sched/core.c                       |   5 --
 101 files changed, 455 insertions(+), 1328 deletions(-)
 delete mode 100644 arch/openrisc/kernel/idle.c
 create mode 100644 kernel/cpu/Makefile
 create mode 100644 kernel/cpu/idle.c

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 1f8c729..52cd2a4 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -95,8 +95,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define TS_POLLING		0x0010	/* idle task polling need_resched,
 					   skip sending interrupt */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 63d27fb..a3fd8a2 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -46,25 +46,6 @@
 void (*pm_power_off)(void) = machine_power_off;
 EXPORT_SYMBOL(pm_power_off);
 
-void
-cpu_idle(void)
-{
-	current_thread_info()->status |= TS_POLLING;
-
-	while (1) {
-		/* FIXME -- EV6 and LCA45 know how to power down
-		   the CPU.  */
-
-		rcu_idle_enter();
-		while (!need_resched())
-			cpu_relax();
-
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
-
 struct halt_info {
 	int mode;
 	char *restart_cmd;
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 9603bc2..7b60834 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -167,8 +167,7 @@ smp_callin(void)
 	      cpuid, current, current->active_mm));
 
 	preempt_disable();
-	/* Do nothing.  */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Wait until hwrpb->txrdy is clear for cpu.  Return -1 on timeout.  */
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index 0a7531d..cad6685 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -41,37 +41,12 @@ SYSCALL_DEFINE0(arc_gettls)
 	return task_thread_info(current)->thr_ptr;
 }
 
-static inline void arch_idle(void)
+void arch_cpu_idle(void)
 {
 	/* sleep, but enable all interrupts before committing */
 	__asm__("sleep 0x3");
 }
 
-void cpu_idle(void)
-{
-	/* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-doze:
-		local_irq_disable();
-		if (!need_resched()) {
-			arch_idle();
-			goto doze;
-		} else {
-			local_irq_enable();
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		schedule_preempt_disabled();
-	}
-}
-
 asmlinkage void ret_from_fork(void);
 
 /* Layout of Child kernel mode stack as setup at the end of this function is
diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index 3af3e06..5c7fd60 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -141,7 +141,7 @@ void __cpuinit start_kernel_secondary(void)
 
 	local_irq_enable();
 	preempt_disable();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /*
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1cacda4..fcedd61 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -15,6 +15,7 @@ config ARM
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HARDIRQS_SW_RESEND
diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
index 5a85f14..21a23e3 100644
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -21,9 +21,6 @@ extern void (*arm_pm_idle)(void);
 
 extern unsigned int user_debug;
 
-extern void disable_hlt(void);
-extern void enable_hlt(void);
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_ARM_SYSTEM_MISC_H */
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..c9a5e2c 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -57,38 +57,6 @@ static const char *isa_modes[] = {
   "ARM" , "Thumb" , "Jazelle", "ThumbEE"
 };
 
-static volatile int hlt_counter;
-
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-	BUG_ON(hlt_counter < 0);
-}
-
-EXPORT_SYMBOL(enable_hlt);
-
-static int __init nohlt_setup(char *__unused)
-{
-	hlt_counter = 1;
-	return 1;
-}
-
-static int __init hlt_setup(char *__unused)
-{
-	hlt_counter = 0;
-	return 1;
-}
-
-__setup("nohlt", nohlt_setup);
-__setup("hlt", hlt_setup);
-
 extern void call_with_stack(void (*fn)(void *), void *arg, void *sp);
 typedef void (*phys_reset_t)(unsigned long);
 
@@ -172,54 +140,38 @@ static void default_idle(void)
 	local_irq_enable();
 }
 
-/*
- * The idle thread.
- * We always respect 'hlt_counter' to prevent low power idle.
- */
-void cpu_idle(void)
+void arch_cpu_idle_prepare(void)
 {
 	local_fiq_enable();
+}
 
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		ledtrig_cpu(CPU_LED_IDLE_START);
-		while (!need_resched()) {
-#ifdef CONFIG_HOTPLUG_CPU
-			if (cpu_is_offline(smp_processor_id()))
-				cpu_die();
+void arch_cpu_idle_enter(void)
+{
+	ledtrig_cpu(CPU_LED_IDLE_START);
+#ifdef CONFIG_PL310_ERRATA_769419
+	wmb();
 #endif
+}
 
-			/*
-			 * We need to disable interrupts here
-			 * to ensure we don't miss a wakeup call.
-			 */
-			local_irq_disable();
-#ifdef CONFIG_PL310_ERRATA_769419
-			wmb();
+void arch_cpu_idle_exit(void)
+{
+	ledtrig_cpu(CPU_LED_IDLE_END);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
+}
 #endif
-			if (hlt_counter) {
-				local_irq_enable();
-				cpu_relax();
-			} else if (!need_resched()) {
-				stop_critical_timings();
-				if (cpuidle_idle_call())
-					default_idle();
-				start_critical_timings();
-				/*
-				 * default_idle functions must always
-				 * return with IRQs enabled.
-				 */
-				WARN_ON(irqs_disabled());
-			} else
-				local_irq_enable();
-		}
-		ledtrig_cpu(CPU_LED_IDLE_END);
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+
+/*
+ * Called from the core idle loop.
+ */
+void arch_cpu_idle(void)
+{
+	if (cpuidle_idle_call())
+		default_idle();
 }
 
 static char reboot_mode = 'h';
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 1f2cccc..4619177 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -336,7 +336,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/arm/mach-gemini/idle.c b/arch/arm/mach-gemini/idle.c
index 92bbd6b..87dff4f 100644
--- a/arch/arm/mach-gemini/idle.c
+++ b/arch/arm/mach-gemini/idle.c
@@ -13,9 +13,11 @@ static void gemini_idle(void)
 	 * will never wakeup... Acctualy it is not very good to enable
 	 * interrupts first since scheduler can miss a tick, but there is
 	 * no other way around this. Platforms that needs it for power saving
-	 * should call enable_hlt() in init code, since by default it is
+	 * should enable it in init code, since by default it is
 	 * disabled.
 	 */
+
+	/* FIXME: Enabling interrupts here is racy! */
 	local_irq_enable();
 	cpu_do_idle();
 }
diff --git a/arch/arm/mach-gemini/irq.c b/arch/arm/mach-gemini/irq.c
index 020852d..6d8f6d1 100644
--- a/arch/arm/mach-gemini/irq.c
+++ b/arch/arm/mach-gemini/irq.c
@@ -15,6 +15,8 @@
 #include <linux/stddef.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
+
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
 #include <asm/system_misc.h>
@@ -77,7 +79,7 @@ void __init gemini_init_irq(void)
 	 * Disable the idle handler by default since it is buggy
 	 * For more info see arch/arm/mach-gemini/idle.c
 	 */
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 
 	request_resource(&iomem_resource, &irq_resource);
 
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 1dbeb7c..6600cff 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <linux/gpio.h>
+#include <linux/cpu.h>
 
 #include <mach/udc.h>
 #include <mach/hardware.h>
@@ -239,7 +240,7 @@ void __init ixp4xx_init_irq(void)
 	 * ixp4xx does not implement the XScale PWRMODE register
 	 * so it must not call cpu_do_idle().
 	 */
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 
 	/* Route all sources to IRQ instead of FIQ */
 	*IXP4XX_ICLR = 0x0;
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 7a7690a..db37f49 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -43,6 +43,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/atomic.h>
+#include <linux/cpu.h>
 
 #include <asm/fncpy.h>
 #include <asm/system_misc.h>
@@ -584,8 +585,7 @@ static void omap_pm_init_proc(void)
 static int omap_pm_prepare(void)
 {
 	/* We cannot sleep in idle until we have resumed */
-	disable_hlt();
-
+	cpu_idle_poll_ctrl(true);
 	return 0;
 }
 
@@ -621,7 +621,7 @@ static int omap_pm_enter(suspend_state_t state)
 
 static void omap_pm_finish(void)
 {
-	enable_hlt();
+	cpu_idle_poll_ctrl(false);
 }
 
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index a202a47..e512253 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -138,6 +138,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
+#include <linux/cpu.h>
 
 #include <asm/system_misc.h>
 
@@ -2157,7 +2158,7 @@ static int _enable(struct omap_hwmod *oh)
 	if (soc_ops.enable_module)
 		soc_ops.enable_module(oh);
 	if (oh->flags & HWMOD_BLOCK_WFI)
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 
 	if (soc_ops.update_context_lost)
 		soc_ops.update_context_lost(oh);
@@ -2221,7 +2222,7 @@ static int _idle(struct omap_hwmod *oh)
 	_del_initiator_dep(oh, mpu_oh);
 
 	if (oh->flags & HWMOD_BLOCK_WFI)
-		enable_hlt();
+		cpu_idle_poll_ctrl(false);
 	if (soc_ops.disable_module)
 		soc_ops.disable_module(oh);
 
@@ -2331,7 +2332,7 @@ static int _shutdown(struct omap_hwmod *oh)
 		_del_initiator_dep(oh, mpu_oh);
 		/* XXX what about the other system initiators here? dma, dsp */
 		if (oh->flags & HWMOD_BLOCK_WFI)
-			enable_hlt();
+			cpu_idle_poll_ctrl(false);
 		if (soc_ops.disable_module)
 			soc_ops.disable_module(oh);
 		_disable_clocks(oh);
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 673a4c1..dec5533 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -218,7 +218,7 @@ static int omap_pm_enter(suspend_state_t suspend_state)
 
 static int omap_pm_begin(suspend_state_t state)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	if (cpu_is_omap34xx())
 		omap_prcm_irq_prepare();
 	return 0;
@@ -226,8 +226,7 @@ static int omap_pm_begin(suspend_state_t state)
 
 static void omap_pm_end(void)
 {
-	enable_hlt();
-	return;
+	cpu_idle_poll_ctrl(false);
 }
 
 static void omap_pm_finish(void)
diff --git a/arch/arm/mach-orion5x/board-dt.c b/arch/arm/mach-orion5x/board-dt.c
index 35a8014..94fbb81 100644
--- a/arch/arm/mach-orion5x/board-dt.c
+++ b/arch/arm/mach-orion5x/board-dt.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/cpu.h>
 #include <asm/system_misc.h>
 #include <asm/mach/arch.h>
 #include <mach/orion5x.h>
@@ -52,7 +53,7 @@ static void __init orion5x_dt_init(void)
 	 */
 	if (dev == MV88F5281_DEV_ID && rev == MV88F5281_REV_D0) {
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 	}
 
 	if (of_machine_is_compatible("lacie,ethernet-disk-mini-v2"))
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index d068f14..ad71c8a 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -293,7 +293,7 @@ void __init orion5x_init(void)
 	 */
 	if (dev == MV88F5281_DEV_ID && rev == MV88F5281_REV_D0) {
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 	}
 
 	/*
diff --git a/arch/arm/mach-shark/core.c b/arch/arm/mach-shark/core.c
index b63dec8..1535557 100644
--- a/arch/arm/mach-shark/core.c
+++ b/arch/arm/mach-shark/core.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/serial_8250.h>
 #include <linux/io.h>
+#include <linux/cpu.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -130,7 +131,7 @@ static void __init shark_timer_init(void)
 
 static void shark_init_early(void)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 }
 
 MACHINE_START(SHARK, "Shark")
diff --git a/arch/arm/mach-shmobile/suspend.c b/arch/arm/mach-shmobile/suspend.c
index 47d83f7..5d92b5d 100644
--- a/arch/arm/mach-shmobile/suspend.c
+++ b/arch/arm/mach-shmobile/suspend.c
@@ -12,6 +12,8 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/cpu.h>
+
 #include <asm/io.h>
 #include <asm/system_misc.h>
 
@@ -23,13 +25,13 @@ static int shmobile_suspend_default_enter(suspend_state_t suspend_state)
 
 static int shmobile_suspend_begin(suspend_state_t state)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	return 0;
 }
 
 static void shmobile_suspend_end(void)
 {
-	enable_hlt();
+	cpu_idle_poll_ctrl(false);
 }
 
 struct platform_suspend_ops shmobile_suspend_ops = {
diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 7abdb96..e65a80a 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/mtd.h>
@@ -531,7 +532,7 @@ static struct platform_device *nuc900_public_dev[] __initdata = {
 
 void __init nuc900_board_init(struct platform_device **device, int size)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	platform_add_devices(device, size);
 	platform_add_devices(nuc900_public_dev, ARRAY_SIZE(nuc900_public_dev));
 	spi_register_board_info(nuc900_spi_board_info,
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0337cdb..83a0ad5 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -84,11 +84,15 @@ EXPORT_SYMBOL_GPL(pm_power_off);
 void (*pm_restart)(const char *cmd);
 EXPORT_SYMBOL_GPL(pm_restart);
 
+void arch_cpu_idle_prepare(void)
+{
+	local_fiq_enable();
+}
 
 /*
  * This is our default idle handler.
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
 	/*
 	 * This should do all the clock switching and wait for interrupt
@@ -98,43 +102,6 @@ static void default_idle(void)
 	local_irq_enable();
 }
 
-/*
- * The idle thread.
- * We always respect 'hlt_counter' to prevent low power idle.
- */
-void cpu_idle(void)
-{
-	local_fiq_enable();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-			/*
-			 * We need to disable interrupts here to ensure
-			 * we don't miss a wakeup call.
-			 */
-			local_irq_disable();
-			if (!need_resched()) {
-				stop_critical_timings();
-				default_idle();
-				start_critical_timings();
-				/*
-				 * default_idle functions should always return
-				 * with IRQs enabled.
-				 */
-				WARN_ON(irqs_disabled());
-			} else {
-				local_irq_enable();
-			}
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void machine_shutdown(void)
 {
 #ifdef CONFIG_SMP
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index bdd3459..261445c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -216,7 +216,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index fd78f58..073c3c2 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -30,18 +30,9 @@ EXPORT_SYMBOL(pm_power_off);
  * This file handles the architecture-dependent parts of process handling..
  */
 
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			cpu_idle_sleep();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	cpu_enter_idle();
 }
 
 void machine_halt(void)
diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 05ad291..869a1c6 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -12,6 +12,7 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/time.h>
+#include <linux/cpu.h>
 
 #include <asm/sysreg.h>
 
@@ -87,13 +88,17 @@ static void comparator_mode(enum clock_event_mode mode,
 		pr_debug("%s: start\n", evdev->name);
 		/* FALLTHROUGH */
 	case CLOCK_EVT_MODE_RESUME:
-		cpu_disable_idle_sleep();
+		/*
+		 * If we're using the COUNT and COMPARE registers we
+		 * need to force idle poll.
+		 */
+		cpu_idle_poll_ctrl(true);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		sysreg_write(COMPARE, 0);
 		pr_debug("%s: stop\n", evdev->name);
-		cpu_enable_idle_sleep();
+		cpu_idle_poll_ctrl(false);
 		break;
 	default:
 		BUG();
diff --git a/arch/avr32/mach-at32ap/include/mach/pm.h b/arch/avr32/mach-at32ap/include/mach/pm.h
index 979b355..f29ff2c 100644
--- a/arch/avr32/mach-at32ap/include/mach/pm.h
+++ b/arch/avr32/mach-at32ap/include/mach/pm.h
@@ -21,30 +21,6 @@
 extern void cpu_enter_idle(void);
 extern void cpu_enter_standby(unsigned long sdramc_base);
 
-extern bool disable_idle_sleep;
-
-static inline void cpu_disable_idle_sleep(void)
-{
-	disable_idle_sleep = true;
-}
-
-static inline void cpu_enable_idle_sleep(void)
-{
-	disable_idle_sleep = false;
-}
-
-static inline void cpu_idle_sleep(void)
-{
-	/*
-	 * If we're using the COUNT and COMPARE registers for
-	 * timekeeping, we can't use the IDLE state.
-	 */
-	if (disable_idle_sleep)
-		cpu_relax();
-	else
-		cpu_enter_idle();
-}
-
 void intc_set_suspend_handler(unsigned long offset);
 #endif
 
diff --git a/arch/avr32/mach-at32ap/pm-at32ap700x.S b/arch/avr32/mach-at32ap/pm-at32ap700x.S
index f868f4c..1c8e4e6 100644
--- a/arch/avr32/mach-at32ap/pm-at32ap700x.S
+++ b/arch/avr32/mach-at32ap/pm-at32ap700x.S
@@ -18,13 +18,6 @@
 /* Same as 0xfff00000 but fits in a 21 bit signed immediate */
 #define PM_BASE	-0x100000
 
-	.section .bss, "wa", @nobits
-	.global	disable_idle_sleep
-	.type	disable_idle_sleep, @object
-disable_idle_sleep:
-	.int	4
-	.size	disable_idle_sleep, . - disable_idle_sleep
-
 	/* Keep this close to the irq handlers */
 	.section .irq.text, "ax", @progbits
 
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 9782c03..4aa5545 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -46,15 +46,14 @@ EXPORT_SYMBOL(pm_power_off);
  * The idle loop on BFIN
  */
 #ifdef CONFIG_IDLE_L1
-static void default_idle(void)__attribute__((l1_text));
-void cpu_idle(void)__attribute__((l1_text));
+void arch_cpu_idle(void)__attribute__((l1_text));
 #endif
 
 /*
  * This is our default idle handler.  We need to disable
  * interrupts here to ensure we don't miss a wakeup call.
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
 #ifdef CONFIG_IPIPE
 	ipipe_suspend_domain();
@@ -66,31 +65,12 @@ static void default_idle(void)
 	hard_local_irq_enable();
 }
 
-/*
- * The idle thread.  We try to conserve power, while trying to keep
- * overall latency low.  The architecture specific idle is passed
- * a value to indicate the level of "idleness" of the system.
- */
-void cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-
 #ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(smp_processor_id()))
-			cpu_die();
-#endif
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
 }
+#endif
 
 /*
  * Do necessary setup to start up a newly executed thread.
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index bb61ae4..1bc2ce6 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -335,7 +335,7 @@ void __cpuinit secondary_start_kernel(void)
 	 */
 	calibrate_delay();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_prepare_boot_cpu(void)
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 6434df4..57d2ea8 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -33,7 +33,7 @@ extern asmlinkage void ret_from_kernel_thread(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-static void c6x_idle(void)
+void arch_cpu_idle(void)
 {
 	unsigned long tmp;
 
@@ -49,32 +49,6 @@ static void c6x_idle(void)
 		      : "=b"(tmp));
 }
 
-/*
- * The idle loop for C64x
- */
-void cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (1) {
-			local_irq_disable();
-			if (need_resched()) {
-				local_irq_enable();
-				break;
-			}
-			c6x_idle(); /* enables local irqs */
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
-
 static void halt_loop(void)
 {
 	printk(KERN_EMERG "System Halted, OK to turn off power\n");
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index b101875..2ba23c1 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -30,8 +30,9 @@ void etrax_gpio_wake_up_check(void); /* drivers/gpio.c */
 void default_idle(void)
 {
 #ifdef CONFIG_ETRAX_GPIO
-  etrax_gpio_wake_up_check();
+	etrax_gpio_wake_up_check();
 #endif
+	local_irq_enable();
 }
 
 /*
diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index 2b23ef0..57451fa 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
@@ -20,18 +20,12 @@
 
 extern void stop_watchdog(void);
 
-extern int cris_hlt_counter;
-
 /* We use this if we don't have any better idle routine. */
 void default_idle(void)
 {
-	local_irq_disable();
-	if (!need_resched() && !cris_hlt_counter) {
-	        /* Halt until exception. */
-		__asm__ volatile("ei    \n\t"
-                                 "halt      ");
-	}
-	local_irq_enable();
+	/* Halt until exception. */
+	__asm__ volatile("ei    \n\t"
+			 "halt      ");
 }
 
 /*
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 04a16ed..cdd1202 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -145,8 +145,6 @@ smp_boot_one_cpu(int cpuid, struct task_struct idle)
  * specific stuff such as the local timer and the MMU. */
 void __init smp_callin(void)
 {
-	extern void cpu_idle(void);
-
 	int cpu = cpu_now_booting;
 	reg_intr_vect_rw_mask vect_mask = {0};
 
@@ -170,7 +168,7 @@ void __init smp_callin(void)
 	local_irq_enable();
 
 	set_cpu_online(cpu, true);
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Stop execution on this CPU.*/
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index 675823f..c0a29b9 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -65,13 +65,6 @@ static inline void release_thread(struct task_struct *dead_task)
 
 #define cpu_relax()     barrier()
 
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
-void disable_hlt(void);
-void enable_hlt(void);
-
 void default_idle(void);
 
 #endif /* __ASM_CRIS_PROCESSOR_H */
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index 104ff4d..b78498e 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -29,59 +29,14 @@
 
 //#define DEBUG
 
-/*
- * The hlt_counter, disable_hlt and enable_hlt is just here as a hook if
- * there would ever be a halt sequence (for power save when idle) with
- * some largish delay when halting or resuming *and* a driver that can't
- * afford that delay.  The hlt_counter would then be checked before
- * executing the halt sequence, and the driver marks the unhaltable
- * region by enable_hlt/disable_hlt.
- */
-
-int cris_hlt_counter=0;
-
-void disable_hlt(void)
-{
-	cris_hlt_counter++;
-}
-
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	cris_hlt_counter--;
-}
-
-EXPORT_SYMBOL(enable_hlt);
- 
 extern void default_idle(void);
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-
-void cpu_idle (void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched()) {
-			/*
-			 * Mark this as an RCU critical section so that
-			 * synchronize_kernel() in the unload path waits
-			 * for our completion.
-			 */
-			default_idle();
-		}
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
+	default_idle();
 }
 
 void hard_reset_now (void);
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 23916b2..5d40aeb77 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -59,29 +59,12 @@ static void core_sleep_idle(void)
 	mb();
 }
 
-void (*idle)(void) = core_sleep_idle;
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched()) {
-			check_pgt_cache();
-
-			if (!frv_dma_inprogress && idle)
-				idle();
-		}
-		rcu_idle_exit();
-
-		schedule_preempt_disabled();
-	}
+	if (!frv_dma_inprogress)
+		core_sleep_idle();
+	else
+		local_irq_enable();
 }
 
 void machine_restart(char * __unused)
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index b609f63..a17d2cd 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -53,40 +53,13 @@ asmlinkage void ret_from_kernel_thread(void);
  * The idle loop on an H8/300..
  */
 #if !defined(CONFIG_H8300H_SIM) && !defined(CONFIG_H8S_SIM)
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	local_irq_disable();
-	if (!need_resched()) {
-		local_irq_enable();
-		/* XXX: race here! What if need_resched() gets set now? */
-		__asm__("sleep");
-	} else
-		local_irq_enable();
-}
-#else
-static void default_idle(void)
-{
-	cpu_relax();
+	local_irq_enable();
+	/* XXX: race here! What if need_resched() gets set now? */
+	__asm__("sleep");
 }
 #endif
-void (*idle)(void) = default_idle;
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
 
 void machine_restart(char * __unused)
 {
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 06ae9ff..9b948c6 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -51,28 +51,11 @@ void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long sp)
  *  If hardware or VM offer wait termination even though interrupts
  *  are disabled.
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
 	__vmwait();
-}
-
-void (*idle_sleep)(void) = default_idle;
-
-void cpu_idle(void)
-{
-	while (1) {
-		tick_nohz_idle_enter();
-		local_irq_disable();
-		while (!need_resched()) {
-			idle_sleep();
-			/*  interrupts wake us up, but aren't serviced  */
-			local_irq_enable();	/* service interrupt   */
-			local_irq_disable();
-		}
-		local_irq_enable();
-		tick_nohz_idle_exit();
-		schedule();
-	}
+	/*  interrupts wake us up, but irqs are still disabled */
+	local_irq_enable();
 }
 
 /*
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 8e095df..0e364ca 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -184,7 +184,7 @@ void __cpuinit start_secondary(void)
 
 	local_irq_enable();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 
diff --git a/arch/ia64/include/asm/irqflags.h b/arch/ia64/include/asm/irqflags.h
index 2b68d85..1bf2cf2 100644
--- a/arch/ia64/include/asm/irqflags.h
+++ b/arch/ia64/include/asm/irqflags.h
@@ -89,6 +89,7 @@ static inline bool arch_irqs_disabled(void)
 
 static inline void arch_safe_halt(void)
 {
+	arch_local_irq_enable();
 	ia64_pal_halt_light();	/* PAL_HALT_LIGHT */
 }
 
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index 020d655..cade13d 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -131,8 +131,6 @@ struct thread_info {
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 #define TS_RESTORE_SIGMASK	2	/* restore signal mask in do_signal() */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 2eda284..9ea25fc 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -42,6 +42,7 @@
 #include <linux/completion.h>
 #include <linux/tracehook.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 
 #include <asm/errno.h>
 #include <asm/intrinsics.h>
@@ -1322,8 +1323,6 @@ out:
 }
 EXPORT_SYMBOL(pfm_unregister_buffer_fmt);
 
-extern void update_pal_halt_status(int);
-
 static int
 pfm_reserve_session(struct task_struct *task, int is_syswide, unsigned int cpu)
 {
@@ -1371,9 +1370,9 @@ pfm_reserve_session(struct task_struct *task, int is_syswide, unsigned int cpu)
 		cpu));
 
 	/*
-	 * disable default_idle() to go to PAL_HALT
+	 * Force idle() into poll mode
 	 */
-	update_pal_halt_status(0);
+	cpu_idle_poll_ctrl(true);
 
 	UNLOCK_PFS(flags);
 
@@ -1430,11 +1429,8 @@ pfm_unreserve_session(pfm_context_t *ctx, int is_syswide, unsigned int cpu)
 		is_syswide,
 		cpu));
 
-	/*
-	 * if possible, enable default_idle() to go into PAL_HALT
-	 */
-	if (pfm_sessions.pfs_task_sessions == 0 && pfm_sessions.pfs_sys_sessions == 0)
-		update_pal_halt_status(1);
+	/* Undo forced polling. Last session reenables pal_halt */
+	cpu_idle_poll_ctrl(false);
 
 	UNLOCK_PFS(flags);
 
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 6f7dc8b..a26fc64 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -209,41 +209,13 @@ do_notify_resume_user(sigset_t *unused, struct sigscratch *scr, long in_syscall)
 	local_irq_disable();	/* force interrupt disable */
 }
 
-static int pal_halt        = 1;
-static int can_do_pal_halt = 1;
-
 static int __init nohalt_setup(char * str)
 {
-	pal_halt = can_do_pal_halt = 0;
+	cpu_idle_poll_ctrl(true);
 	return 1;
 }
 __setup("nohalt", nohalt_setup);
 
-void
-update_pal_halt_status(int status)
-{
-	can_do_pal_halt = pal_halt && status;
-}
-
-/*
- * We use this if we don't have any better idle routine..
- */
-void
-default_idle (void)
-{
-	local_irq_enable();
-	while (!need_resched()) {
-		if (can_do_pal_halt) {
-			local_irq_disable();
-			if (!need_resched()) {
-				safe_halt();
-			}
-			local_irq_enable();
-		} else
-			cpu_relax();
-	}
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 /* We don't actually take CPU down, just spin without interrupts. */
 static inline void play_dead(void)
@@ -270,47 +242,29 @@ static inline void play_dead(void)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-void __attribute__((noreturn))
-cpu_idle (void)
+void arch_cpu_idle_dead(void)
+{
+	play_dead();
+}
+
+void arch_cpu_idle(void)
 {
 	void (*mark_idle)(int) = ia64_mark_idle;
-  	int cpu = smp_processor_id();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		if (can_do_pal_halt) {
-			current_thread_info()->status &= ~TS_POLLING;
-			/*
-			 * TS_POLLING-cleared state must be visible before we
-			 * test NEED_RESCHED:
-			 */
-			smp_mb();
-		} else {
-			current_thread_info()->status |= TS_POLLING;
-		}
 
-		if (!need_resched()) {
 #ifdef CONFIG_SMP
-			min_xtp();
+	min_xtp();
 #endif
-			rmb();
-			if (mark_idle)
-				(*mark_idle)(1);
+	rmb();
+	if (mark_idle)
+		(*mark_idle)(1);
+
+	safe_halt();
 
-			default_idle();
-			if (mark_idle)
-				(*mark_idle)(0);
+	if (mark_idle)
+		(*mark_idle)(0);
 #ifdef CONFIG_SMP
-			normal_xtp();
+	normal_xtp();
 #endif
-		}
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-		check_pgt_cache();
-		if (cpu_is_offline(cpu))
-			play_dead();
-	}
 }
 
 void
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 500f1e4..8d87168 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -455,7 +455,7 @@ start_secondary (void *unused)
 	preempt_disable();
 	smp_callin();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index bde899e..e2d0490 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -47,24 +47,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle (void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			cpu_relax();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void machine_restart(char *__unused)
 {
 #if defined(CONFIG_PLAT_MAPPI3)
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 13168a7..0ac558a 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -432,7 +432,7 @@ int __init start_secondary(void *unused)
 	 */
 	local_flush_tlb_all();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index d538694..c55ff71 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -51,40 +51,16 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 		return sw->retpc;
 }
 
-/*
- * The idle loop on an m68k..
- */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	if (!need_resched())
 #if defined(MACH_ATARI_ONLY)
-		/* block out HSYNC on the atari (falcon) */
-		__asm__("stop #0x2200" : : : "cc");
+	/* block out HSYNC on the atari (falcon) */
+	__asm__("stop #0x2200" : : : "cc");
 #else
-		__asm__("stop #0x2000" : : : "cc");
+	__asm__("stop #0x2000" : : : "cc");
 #endif
 }
 
-void (*idle)(void) = default_idle;
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void machine_restart(char * __unused)
 {
 	if (mach_reset)
diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index 0ecd34d..7c4a330 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -150,6 +150,4 @@ static inline int kstack_end(void *addr)
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
 				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP))
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/metag/kernel/process.c b/arch/metag/kernel/process.c
index c6efe62..dc59235 100644
--- a/arch/metag/kernel/process.c
+++ b/arch/metag/kernel/process.c
@@ -22,6 +22,7 @@
 #include <linux/pm.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/smp.h>
 #include <asm/core_reg.h>
 #include <asm/user_gateway.h>
 #include <asm/tcm.h>
@@ -31,7 +32,7 @@
 /*
  * Wait for the next interrupt and enable local interrupts
  */
-static inline void arch_idle(void)
+void arch_cpu_idle(void)
 {
 	int tmp;
 
@@ -59,36 +60,12 @@ static inline void arch_idle(void)
 		      : "r" (get_trigger_mask()));
 }
 
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched()) {
-			/*
-			 * We need to disable interrupts here to ensure we don't
-			 * miss a wakeup call.
-			 */
-			local_irq_disable();
-			if (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
-				if (cpu_is_offline(smp_processor_id()))
-					cpu_die();
-#endif
-				arch_idle();
-			} else {
-				local_irq_enable();
-			}
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	 }
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
 }
+#endif
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 4b6d1f14..4de8fc8 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -297,7 +297,7 @@ asmlinkage void secondary_start_kernel(void)
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 1323fa2..a827057 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -26,6 +26,7 @@ config MICROBLAZE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_POLL_SETUP
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
 
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 0759153..d6e0ffe 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -22,7 +22,6 @@
 extern const struct seq_operations cpuinfo_op;
 
 # define cpu_relax()		barrier()
-# define cpu_sleep()		do {} while (0)
 
 #define task_pt_regs(tsk) \
 		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
@@ -160,10 +159,6 @@ unsigned long get_wchan(struct task_struct *p);
 #  define STACK_TOP	TASK_SIZE
 #  define STACK_TOP_MAX	STACK_TOP
 
-void disable_hlt(void);
-void enable_hlt(void);
-void default_idle(void);
-
 #ifdef CONFIG_DEBUG_FS
 extern struct dentry *of_debugfs_root;
 #endif
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index 008f304..de26ea6 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -182,7 +182,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 	ti->status &= ~TS_RESTORE_SIGMASK;
 	return true;
 }
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index fa0ea60..7cce2e9 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -44,71 +44,6 @@ void show_regs(struct pt_regs *regs)
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
-static int hlt_counter = 1;
-
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-EXPORT_SYMBOL(enable_hlt);
-
-static int __init nohlt_setup(char *__unused)
-{
-	hlt_counter = 1;
-	return 1;
-}
-__setup("nohlt", nohlt_setup);
-
-static int __init hlt_setup(char *__unused)
-{
-	hlt_counter = 0;
-	return 1;
-}
-__setup("hlt", hlt_setup);
-
-void default_idle(void)
-{
-	if (likely(hlt_counter)) {
-		local_irq_disable();
-		stop_critical_timings();
-		cpu_relax();
-		start_critical_timings();
-		local_irq_enable();
-	} else {
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-		smp_mb__after_clear_bit();
-		local_irq_disable();
-		while (!need_resched())
-			cpu_sleep();
-		local_irq_enable();
-		set_thread_flag(TIF_POLLING_NRFLAG);
-	}
-}
-
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		schedule_preempt_disabled();
-		check_pgt_cache();
-	}
-}
-
 void flush_thread(void)
 {
 }
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 3be4405..cfc742d 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -41,44 +41,26 @@
 #include <asm/inst.h>
 #include <asm/stacktrace.h>
 
-/*
- * The idle thread. There's no useful work to be done, so just try to conserve
- * power and have a low exit latency (ie sit in a loop waiting for somebody to
- * say that they'd like to reschedule)
- */
-void __noreturn cpu_idle(void)
+#ifdef CONFIG_HOTPLUG_CPU
+void arch_cpu_idle_dead(void)
 {
-	int cpu;
-
-	/* CPU is going idle. */
-	cpu = smp_processor_id();
+	/* What the heck is this check doing ? */
+	if (!cpu_isset(smp_processor_id(), cpu_callin_map))
+		play_dead();
+}
+#endif
 
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched() && cpu_online(cpu)) {
+void arch_cpu_idle(void)
+{
 #ifdef CONFIG_MIPS_MT_SMTC
-			extern void smtc_idle_loop_hook(void);
+	extern void smtc_idle_loop_hook(void);
 
-			smtc_idle_loop_hook();
+	smtc_idle_loop_hook();
 #endif
-
-			if (cpu_wait) {
-				/* Don't trace irqs off for idle */
-				stop_critical_timings();
-				(*cpu_wait)();
-				start_critical_timings();
-			}
-		}
-#ifdef CONFIG_HOTPLUG_CPU
-		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
-			play_dead();
-#endif
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	if (cpu_wait)
+		(*cpu_wait)();
+	else
+		local_irq_enable();
 }
 
 asmlinkage void ret_from_fork(void);
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 66bf4e2..aee04af 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -139,7 +139,7 @@ asmlinkage __cpuinit void start_secondary(void)
 	WARN_ON_ONCE(!irqs_disabled());
 	mp_ops->smp_finish();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /*
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index f90062b..224b426 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -165,8 +165,6 @@ void arch_release_thread_info(struct thread_info *ti);
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 84f4e97..2da39fb 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -50,77 +50,19 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-#if !defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
-/*
- * we use this if we don't have any better idle routine
- */
-static void default_idle(void)
-{
-	local_irq_disable();
-	if (!need_resched())
-		safe_halt();
-	else
-		local_irq_enable();
-}
-
-#else /* !CONFIG_SMP || CONFIG_HOTPLUG_CPU  */
 /*
  * On SMP it's slightly faster (but much more power-consuming!)
  * to poll the ->work.need_resched flag instead of waiting for the
  * cross-CPU IPI to arrive. Use this option with caution.
+ *
+ * tglx: No idea why this depends on HOTPLUG_CPU !?!
  */
-static inline void poll_idle(void)
-{
-	int oldval;
-
-	local_irq_enable();
-
-	/*
-	 * Deal with another CPU just having chosen a thread to
-	 * run here:
-	 */
-	oldval = test_and_clear_thread_flag(TIF_NEED_RESCHED);
-
-	if (!oldval) {
-		set_thread_flag(TIF_POLLING_NRFLAG);
-		while (!need_resched())
-			cpu_relax();
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-	} else {
-		set_need_resched();
-	}
-}
-#endif /* !CONFIG_SMP || CONFIG_HOTPLUG_CPU */
-
-/*
- * the idle thread
- * - there's no useful work to be done, so just try to conserve power and have
- *   a low exit latency (ie sit in a loop waiting for somebody to say that
- *   they'd like to reschedule)
- */
-void cpu_idle(void)
+#if !defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	for (;;) {
-		rcu_idle_enter();
-		while (!need_resched()) {
-			void (*idle)(void);
-
-			smp_rmb();
-			if (!idle) {
-#if defined(CONFIG_SMP) && !defined(CONFIG_HOTPLUG_CPU)
-				idle = poll_idle;
-#else  /* CONFIG_SMP && !CONFIG_HOTPLUG_CPU */
-				idle = default_idle;
-#endif /* CONFIG_SMP && !CONFIG_HOTPLUG_CPU */
-			}
-			idle();
-		}
-		rcu_idle_exit();
-
-		schedule_preempt_disabled();
-	}
+	safe_halt();
 }
+#endif
 
 void release_segments(struct mm_struct *mm)
 {
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 5d7e152..a17f9c9 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -675,7 +675,7 @@ int __init start_secondary(void *unused)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 	init_clockevents();
 #endif
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 
@@ -935,8 +935,6 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 	int timeout;
 
 #ifdef CONFIG_HOTPLUG_CPU
-	if (num_online_cpus() == 1)
-		disable_hlt();
 	if (sleep_mode[cpu])
 		run_wakeup_cpu(cpu);
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -1003,9 +1001,6 @@ int __cpu_disable(void)
 void __cpu_die(unsigned int cpu)
 {
 	run_sleep_cpu(cpu);
-
-	if (num_online_cpus() == 1)
-		enable_hlt();
 }
 
 #ifdef CONFIG_MN10300_CACHE_ENABLED
diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
index 07f3212..d797acc 100644
--- a/arch/openrisc/include/asm/thread_info.h
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -128,8 +128,6 @@ register struct thread_info *current_thread_info_reg asm("r10");
 /* For OpenRISC, this is anything in the LSW other than syscall trace */
 #define _TIF_WORK_MASK (0xff & ~(_TIF_SYSCALL_TRACE|_TIF_SINGLESTEP))
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/openrisc/kernel/Makefile b/arch/openrisc/kernel/Makefile
index 35f92ce..ec6d9d3 100644
--- a/arch/openrisc/kernel/Makefile
+++ b/arch/openrisc/kernel/Makefile
@@ -4,7 +4,7 @@
 
 extra-y	:= head.o vmlinux.lds
 
-obj-y	:= setup.o idle.o or32_ksyms.o process.o dma.o \
+obj-y	:= setup.o or32_ksyms.o process.o dma.o \
 	   traps.o time.o irq.o entry.o ptrace.o signal.o \
 	   sys_call_table.o
 
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
deleted file mode 100644
index 5e8a3b6..0000000
--- a/arch/openrisc/kernel/idle.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * OpenRISC idle.c
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * Modifications for the OpenRISC architecture:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- *
- *      This program is free software; you can redistribute it and/or
- *      modify it under the terms of the GNU General Public License
- *      as published by the Free Software Foundation; either version
- *      2 of the License, or (at your option) any later version.
- *
- * Idle daemon for or32.  Idle daemon will handle any action
- * that needs to be taken when the system becomes idle.
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/stddef.h>
-#include <linux/unistd.h>
-#include <linux/ptrace.h>
-#include <linux/slab.h>
-#include <linux/tick.h>
-
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
-#include <asm/processor.h>
-#include <asm/mmu.h>
-#include <asm/cache.h>
-#include <asm/pgalloc.h>
-
-void (*powersave) (void) = NULL;
-
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched()) {
-			check_pgt_cache();
-			rmb();
-
-			clear_thread_flag(TIF_POLLING_NRFLAG);
-
-			local_irq_disable();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-			if (!need_resched() && powersave != NULL)
-				powersave();
-			start_critical_timings();
-			local_irq_enable();
-			set_thread_flag(TIF_POLLING_NRFLAG);
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index d1fb79a..6182832 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -77,8 +77,6 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACE_MASK (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP |	\
 				 _TIF_BLOCKSTEP)
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_PARISC_THREAD_INFO_H */
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d135072..55f92b6 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -59,28 +59,6 @@
 #include <asm/unwind.h>
 #include <asm/sections.h>
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			barrier();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-		check_pgt_cache();
-	}
-}
-
-
 #define COMMAND_GLOBAL  F_EXTEND(0xfffe0030)
 #define CMD_RESET       5       /* reset any module */
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 6266730..fd1bb15 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -329,7 +329,7 @@ void __init smp_callin(void)
 
 	local_irq_enable();  /* Interrupts have been off until now */
 
-	cpu_idle();      /* Wait for timer to schedule some work */
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	/* NOTREACHED */
 	panic("smp_callin() AAAAaaaaahhhh....\n");
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 406b7b9..8ceea14 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -182,8 +182,6 @@ static inline bool test_thread_local_flags(unsigned int flags)
 #define is_32bit_task()	(1)
 #endif
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index ea78761..939ea7e 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -33,11 +33,6 @@
 #include <asm/runlatch.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_HOTPLUG_CPU
-#define cpu_should_die()	cpu_is_offline(smp_processor_id())
-#else
-#define cpu_should_die()	0
-#endif
 
 unsigned long cpuidle_disable = IDLE_NO_OVERRIDE;
 EXPORT_SYMBOL(cpuidle_disable);
@@ -50,64 +45,38 @@ static int __init powersave_off(char *arg)
 }
 __setup("powersave=off", powersave_off);
 
-/*
- * The body of the idle task.
- */
-void cpu_idle(void)
+#ifdef CONFIG_HOTPLUG_CPU
+void arch_cpu_idle_dead(void)
 {
-	set_thread_flag(TIF_POLLING_NRFLAG);
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched() && !cpu_should_die()) {
-			ppc64_runlatch_off();
-
-			if (ppc_md.power_save) {
-				clear_thread_flag(TIF_POLLING_NRFLAG);
-				/*
-				 * smp_mb is so clearing of TIF_POLLING_NRFLAG
-				 * is ordered w.r.t. need_resched() test.
-				 */
-				smp_mb();
-				local_irq_disable();
-
-				/* Don't trace irqs off for idle */
-				stop_critical_timings();
-
-				/* check again after disabling irqs */
-				if (!need_resched() && !cpu_should_die())
-					ppc_md.power_save();
-
-				start_critical_timings();
-
-				/* Some power_save functions return with
-				 * interrupts enabled, some don't.
-				 */
-				if (irqs_disabled())
-					local_irq_enable();
-				set_thread_flag(TIF_POLLING_NRFLAG);
-
-			} else {
-				/*
-				 * Go into low thread priority and possibly
-				 * low power mode.
-				 */
-				HMT_low();
-				HMT_very_low();
-			}
-		}
+	sched_preempt_enable_no_resched();
+	cpu_die();
+}
+#endif
 
-		HMT_medium();
-		ppc64_runlatch_on();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		if (cpu_should_die()) {
-			sched_preempt_enable_no_resched();
-			cpu_die();
-		}
-		schedule_preempt_disabled();
+void arch_cpu_idle(void)
+{
+	ppc64_runlatch_off();
+
+	if (ppc_md.power_save) {
+		ppc_md.power_save();
+		/*
+		 * Some power_save functions return with
+		 * interrupts enabled, some don't.
+		 */
+		if (irqs_disabled())
+			local_irq_enable();
+	} else {
+		local_irq_enable();
+		/*
+		 * Go into low thread priority and possibly
+		 * low power mode.
+		 */
+		HMT_low();
+		HMT_very_low();
 	}
+
+	HMT_medium();
+	ppc64_runlatch_on();
 }
 
 int powersave_nap;
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 76bd9da..ee7ac5e 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -669,7 +669,7 @@ __cpuinit void start_secondary(void *unused)
 
 	local_irq_enable();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	BUG();
 }
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 536d645..2bc3edd 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -61,18 +61,8 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return sf->gprs[8];
 }
 
-/*
- * The idle loop on a S390...
- */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	if (cpu_is_offline(smp_processor_id()))
-		cpu_die();
-	local_irq_disable();
-	if (need_resched()) {
-		local_irq_enable();
-		return;
-	}
 	local_mcck_disable();
 	if (test_thread_flag(TIF_MCCK_PENDING)) {
 		local_mcck_enable();
@@ -83,19 +73,15 @@ static void default_idle(void)
 	vtime_stop_cpu();
 }
 
-void cpu_idle(void)
+void arch_cpu_idle_exit(void)
 {
-	for (;;) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched() && !test_thread_flag(TIF_MCCK_PENDING))
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		if (test_thread_flag(TIF_MCCK_PENDING))
-			s390_handle_mcck();
-		schedule_preempt_disabled();
-	}
+	if (test_thread_flag(TIF_MCCK_PENDING))
+		s390_handle_mcck();
+}
+
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
 }
 
 extern void __kprobes kernel_thread_starter(void);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 549c9d1..6ff5845 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -711,8 +711,7 @@ static void __cpuinit smp_start_secondary(void *cpuvoid)
 	set_cpu_online(smp_processor_id(), true);
 	inc_irq_stat(CPU_RST);
 	local_irq_enable();
-	/* cpu_idle will call schedule for us */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Upping and downing of CPUs */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index a0042ac..3fb0935 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -158,8 +158,6 @@ void __kprobes vtime_stop_cpu(void)
 	unsigned long psw_mask;
 
 	trace_hardirqs_on();
-	/* Don't trace preempt off for idle. */
-	stop_critical_timings();
 
 	/* Wait for external, I/O or machine check interrupt. */
 	psw_mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_DAT |
@@ -169,9 +167,6 @@ void __kprobes vtime_stop_cpu(void)
 	/* Call the assembler magic in entry.S */
 	psw_idle(idle, psw_mask);
 
-	/* Reenable preemption tracer. */
-	start_critical_timings();
-
 	/* Account time spent with enabled wait psw loaded as idle time. */
 	idle->sequence++;
 	smp_wmb();
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index 7956846..f4c6d02 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -41,24 +41,6 @@ void machine_halt(void) {}
 /* If or when software machine-power-off is implemented, add code here. */
 void machine_power_off(void) {}
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void __noreturn cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			barrier();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void ret_from_fork(void);
 void ret_from_kernel_thread(void);
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5e85963..1ea597c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -33,6 +33,7 @@ config SUPERH
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	select GENERIC_STRNCPY_FROM_USER
@@ -148,9 +149,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config ARCH_HAS_DEFAULT_IDLE
-	def_bool y
-
 config NO_IOPORT
 	def_bool !PCI
 	depends on !SH_CAYMAN && !SH_SH4202_MICRODEV && !SH_SHMIN && \
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 7d5ac4e..45a9366 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -207,8 +207,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 	return true;
 }
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 3d5a1b3..2ea4483 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -24,98 +24,24 @@
 
 static void (*sh_idle)(void);
 
-static int hlt_counter;
-
-static int __init nohlt_setup(char *__unused)
-{
-	hlt_counter = 1;
-	return 1;
-}
-__setup("nohlt", nohlt_setup);
-
-static int __init hlt_setup(char *__unused)
-{
-	hlt_counter = 0;
-	return 1;
-}
-__setup("hlt", hlt_setup);
-
-static inline int hlt_works(void)
-{
-	return !hlt_counter;
-}
-
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
+void default_idle(void)
 {
+	set_bl_bit();
 	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
+	/* Isn't this racy ? */
+	cpu_sleep();
+	clear_bl_bit();
 }
 
-void default_idle(void)
+void arch_cpu_idle_dead(void)
 {
-	if (hlt_works()) {
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-		smp_mb__after_clear_bit();
-
-		set_bl_bit();
-		if (!need_resched()) {
-			local_irq_enable();
-			cpu_sleep();
-		} else
-			local_irq_enable();
-
-		set_thread_flag(TIF_POLLING_NRFLAG);
-		clear_bl_bit();
-	} else
-		poll_idle();
+	play_dead();
 }
 
-/*
- * The idle thread. There's no useful work to be done, so just try to conserve
- * power and have a low exit latency (ie sit in a loop waiting for somebody to
- * say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	unsigned int cpu = smp_processor_id();
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched()) {
-			check_pgt_cache();
-			rmb();
-
-			if (cpu_is_offline(cpu))
-				play_dead();
-
-			local_irq_disable();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-			if (cpuidle_idle_call())
-				sh_idle();
-			/*
-			 * Sanity check to ensure that sh_idle() returns
-			 * with IRQs enabled
-			 */
-			WARN_ON(irqs_disabled());
-			start_critical_timings();
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	if (cpuidle_idle_call())
+		sh_idle();
 }
 
 void __init select_idle_routine(void)
@@ -123,13 +49,8 @@ void __init select_idle_routine(void)
 	/*
 	 * If a platform has set its own idle routine, leave it alone.
 	 */
-	if (sh_idle)
-		return;
-
-	if (hlt_works())
+	if (!sh_idle)
 		sh_idle = default_idle;
-	else
-		sh_idle = poll_idle;
 }
 
 void stop_this_cpu(void *unused)
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 2062aa8..4569645 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -203,7 +203,7 @@ asmlinkage void __cpuinit start_secondary(void)
 	set_cpu_online(cpu, true);
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 extern struct {
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index 25849ae..dd38075 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -132,8 +132,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
 					 _TIF_SIGPENDING)
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 269bd92..d5e5042 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -256,8 +256,6 @@ static inline bool test_and_clear_restore_sigmask(void)
 	return true;
 }
 
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-
 #define thread32_stack_is_64bit(__SP) (((__SP) & 0x1) != 0)
 #define test_thread_64bit_stack(__SP) \
 	((test_thread_flag(TIF_32BIT) && !thread32_stack_is_64bit(__SP)) ? \
diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index 9365432..605c960 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -128,8 +128,7 @@ hv_cpu_startup:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
+
 	call		cpu_panic
 	 nop
 
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 62eede1..c852410 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -64,23 +64,12 @@ extern void fpsave(unsigned long *, unsigned long *, void *, unsigned long *);
 struct task_struct *last_task_used_math = NULL;
 struct thread_info *current_set[NR_CPUS];
 
-/*
- * the idle loop on a Sparc... ;)
- */
-void cpu_idle(void)
+/* Idle loop support. */
+void arch_cpu_idle(void)
 {
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	for (;;) {
-		while (!need_resched()) {
-			if (sparc_idle)
-				(*sparc_idle)();
-			else
-				cpu_relax();
-		}
-		schedule_preempt_disabled();
-	}
+	if (sparc_idle)
+		(*sparc_idle)();
+	local_irq_enable();
 }
 
 /* XXX cli/sti -> local_irq_xxx here, check this works once SMP is fixed. */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index cdb80b2..9fbf0d1 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -52,20 +52,17 @@
 
 #include "kstack.h"
 
-static void sparc64_yield(int cpu)
+/* Idle loop support on sparc64. */
+void arch_cpu_idle(void)
 {
 	if (tlb_type != hypervisor) {
 		touch_nmi_watchdog();
-		return;
-	}
-
-	clear_thread_flag(TIF_POLLING_NRFLAG);
-	smp_mb__after_clear_bit();
-
-	while (!need_resched() && !cpu_is_offline(cpu)) {
+	} else {
 		unsigned long pstate;
 
-		/* Disable interrupts. */
+                /* The sun4v sleeping code requires that we have PSTATE.IE cleared over
+                 * the cpu sleep hypervisor call.
+                 */
 		__asm__ __volatile__(
 			"rdpr %%pstate, %0\n\t"
 			"andn %0, %1, %0\n\t"
@@ -73,7 +70,7 @@ static void sparc64_yield(int cpu)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 
-		if (!need_resched() && !cpu_is_offline(cpu))
+		if (!need_resched() && !cpu_is_offline(smp_processor_id()))
 			sun4v_cpu_yield();
 
 		/* Re-enable interrupts. */
@@ -84,36 +81,16 @@ static void sparc64_yield(int cpu)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 	}
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
+	local_irq_enable();
 }
 
-/* The idle loop on sparc64. */
-void cpu_idle(void)
-{
-	int cpu = smp_processor_id();
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	while(1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched() && !cpu_is_offline(cpu))
-			sparc64_yield(cpu);
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
 #ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(cpu)) {
-			sched_preempt_enable_no_resched();
-			cpu_play_dead();
-		}
-#endif
-		schedule_preempt_disabled();
-	}
+void arch_cpu_idle_dead()
+{
+	sched_preempt_enable_no_resched();
+	cpu_play_dead();
 }
+#endif
 
 #ifdef CONFIG_COMPAT
 static void show_regwindow32(struct pt_regs *regs)
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 9e7e6d7..e3f2b81 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -369,7 +369,7 @@ void __cpuinit sparc_start_secondary(void *arg)
 	local_irq_enable();
 
 	wmb();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	/* We should never reach here! */
 	BUG();
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 537eb66..c025ffc 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -127,6 +127,8 @@ void __cpuinit smp_callin(void)
 
 	/* idle thread is expected to have preempt disabled */
 	preempt_disable();
+
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void cpu_panic(void)
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index da1b781..2e973a2 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -407,8 +407,7 @@ after_lock_tlb:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
+
 	call		cpu_panic
 	 nop
 1:	b,a,pt		%xcc, 1b
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index e9c670d..ccc8ef3 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -153,8 +153,6 @@ extern void _cpu_idle(void);
 #define TS_POLLING		0x0004	/* in idle loop but not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index caf93ae..80b2a18 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -40,13 +40,11 @@
 #include <arch/abi.h>
 #include <arch/sim_def.h>
 
-
 /*
  * Use the (x86) "idle=poll" option to prefer low latency when leaving the
  * idle loop over low power while in the idle loop, e.g. if we have
  * one thread per core and we want to get threads out of futex waits fast.
  */
-static int no_idle_nap;
 static int __init idle_setup(char *str)
 {
 	if (!str)
@@ -54,64 +52,19 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		pr_info("using polling idle threads.\n");
-		no_idle_nap = 1;
-	} else if (!strcmp(str, "halt"))
-		no_idle_nap = 0;
-	else
-		return -1;
-
-	return 0;
+		cpu_idle_poll_ctrl(true);
+		return 0;
+	} else if (!strcmp(str, "halt")) {
+		return 0;
+	}
+	return -1;
 }
 early_param("idle", idle_setup);
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	int cpu = smp_processor_id();
-
-
-	current_thread_info()->status |= TS_POLLING;
-
-	if (no_idle_nap) {
-		while (1) {
-			while (!need_resched())
-				cpu_relax();
-			schedule();
-		}
-	}
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-			if (cpu_is_offline(cpu))
-				BUG();  /* no HOTPLUG_CPU */
-
-			local_irq_disable();
-			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
-			current_thread_info()->status &= ~TS_POLLING;
-			/*
-			 * TS_POLLING-cleared state must be visible before we
-			 * test NEED_RESCHED:
-			 */
-			smp_mb();
-
-			if (!need_resched())
-				_cpu_idle();
-			else
-				local_irq_enable();
-			current_thread_info()->status |= TS_POLLING;
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+	_cpu_idle();
 }
 
 /*
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index e686c5a..44bab29 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -207,9 +207,7 @@ void __cpuinit online_secondary(void)
 	/* Set up tile-timer clock-event device on this cpu */
 	setup_tile_timer();
 
-	preempt_enable();
-
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index b462b13..bbcef52 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -210,33 +210,14 @@ void initial_thread_cb(void (*proc)(void *), void *arg)
 	kmalloc_ok = save_kmalloc_ok;
 }
 
-void default_idle(void)
+void arch_cpu_idle(void)
 {
 	unsigned long long nsecs;
 
-	while (1) {
-		/* endless idle loop with no priority at all */
-
-		/*
-		 * although we are an idle CPU, we do not want to
-		 * get into the scheduler unnecessarily.
-		 */
-		if (need_resched())
-			schedule();
-
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		nsecs = disable_timer();
-		idle_sleep(nsecs);
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-	}
-}
-
-void cpu_idle(void)
-{
 	cpu_tasks[current_thread_info()->cpu].pid = os_getpid();
-	default_idle();
+	nsecs = disable_timer();
+	idle_sleep(nsecs);
+	local_irq_enable();
 }
 
 int __cant_sleep(void) {
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 872d7e2..7fab86d 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -45,25 +45,10 @@ static const char * const processor_modes[] = {
 	"UK18", "UK19", "UK1A", "EXTN", "UK1C", "UK1D", "UK1E", "SUSR"
 };
 
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-			local_irq_disable();
-			stop_critical_timings();
-			cpu_do_idle();
-			local_irq_enable();
-			start_critical_timings();
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
+	cpu_do_idle();
+	local_irq_enable();
 }
 
 static char reboot_mode = 'h';
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..fcf2939 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -188,9 +188,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
-config ARCH_HAS_DEFAULT_IDLE
-	def_bool y
-
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2cd056e..a1df6e8 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -241,8 +241,6 @@ static inline struct thread_info *current_thread_info(void)
 					   skip sending interrupt */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..6833bff 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -301,13 +301,7 @@ void exit_idle(void)
 }
 #endif
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle_prepare(void)
 {
 	/*
 	 * If we're the non-boot CPU, nothing set the stack canary up
@@ -317,71 +311,40 @@ void cpu_idle(void)
 	 * canaries already on the stack wont ever trigger).
 	 */
 	boot_init_stack_canary();
-	current_thread_info()->status |= TS_POLLING;
-
-	while (1) {
-		tick_nohz_idle_enter();
-
-		while (!need_resched()) {
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				play_dead();
-
-			/*
-			 * Idle routines should keep interrupts disabled
-			 * from here on, until they go to idle.
-			 * Otherwise, idle callbacks can misfire.
-			 */
-			local_touch_nmi();
-			local_irq_disable();
-
-			enter_idle();
-
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-
-			/* enter_idle() needs rcu for notifiers */
-			rcu_idle_enter();
+}
 
-			if (cpuidle_idle_call())
-				x86_idle();
+void arch_cpu_idle_enter(void)
+{
+	local_touch_nmi();
+	enter_idle();
+}
 
-			rcu_idle_exit();
-			start_critical_timings();
+void arch_cpu_idle_exit(void)
+{
+	__exit_idle();
+}
 
-			/* In many cases the interrupt that ended idle
-			   has already called exit_idle. But some idle
-			   loops can be woken up without interrupt. */
-			__exit_idle();
-		}
+void arch_cpu_idle_dead(void)
+{
+	play_dead();
+}
 
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
+/*
+ * Called from the generic idle code.
+ */
+void arch_cpu_idle(void)
+{
+	if (cpuidle_idle_call())
+		x86_idle();
 }
 
 /*
- * We use this if we don't have any better
- * idle routine..
+ * We use this if we don't have any better idle routine..
  */
 void default_idle(void)
 {
 	trace_cpu_idle_rcuidle(1, smp_processor_id());
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
-
-	if (!need_resched())
-		safe_halt();	/* enables interrupts racelessly */
-	else
-		local_irq_enable();
-	current_thread_info()->status |= TS_POLLING;
+	safe_halt();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 #ifdef CONFIG_APM_MODULE
@@ -411,20 +374,6 @@ void stop_this_cpu(void *dummy)
 		halt();
 }
 
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-}
-
 bool amd_e400_c1e_detected;
 EXPORT_SYMBOL(amd_e400_c1e_detected);
 
@@ -489,10 +438,10 @@ static void amd_e400_idle(void)
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
-	if (x86_idle == poll_idle && smp_num_siblings > 1)
+	if (boot_option_idle_override == IDLE_POLL && smp_num_siblings > 1)
 		pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");
 #endif
-	if (x86_idle)
+	if (x86_idle || boot_option_idle_override == IDLE_POLL)
 		return;
 
 	if (cpu_has_amd_erratum(amd_erratum_400)) {
@@ -517,8 +466,8 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		pr_info("using polling idle threads\n");
-		x86_idle = poll_idle;
 		boot_option_idle_override = IDLE_POLL;
+		cpu_idle_poll_ctrl(true);
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f190a2..9c73b51 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -284,7 +284,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_store_boot_cpu_info(void)
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 09ea61d..73642e9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -95,7 +95,7 @@ static void __cpuinit cpu_bringup(void)
 static void __cpuinit cpu_bringup_and_idle(void)
 {
 	cpu_bringup();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 static int xen_smp_intr_init(unsigned int cpu)
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 5cd82e9..1c85323 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -105,19 +105,9 @@ void coprocessor_flush_all(struct thread_info *ti)
 /*
  * Powermanagement idle function, if any is provided by the platform.
  */
-
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	local_irq_enable();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			platform_idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
+	platform_idle();
 }
 
 /*
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..c6f6e08 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -212,4 +212,20 @@ static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif /* !CONFIG_PM_SLEEP_SMP */
 
+enum cpuhp_state {
+	CPUHP_OFFLINE,
+	CPUHP_ONLINE,
+};
+
+void cpu_startup_entry(enum cpuhp_state state);
+void cpu_idle(void);
+
+void cpu_idle_poll_ctrl(bool enable);
+
+void arch_cpu_idle(void);
+void arch_cpu_idle_prepare(void);
+void arch_cpu_idle_enter(void);
+void arch_cpu_idle_exit(void);
+void arch_cpu_idle_dead(void);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..21fe9a1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2622,6 +2622,47 @@ static inline int spin_needbreak(spinlock_t *lock)
 }
 
 /*
+ * Idle thread specific functions to determine the need_resched
+ * polling state. We have two versions, one based on TS_POLLING in
+ * thread_info.status and one based on TIF_POLLING_NRFLAG in
+ * thread_info.flags
+ */
+#ifdef TS_POLLING
+static inline int tsk_is_polling(struct task_struct *p)
+{
+	return task_thread_info(p)->status & TS_POLLING;
+}
+static inline void current_set_polling(void)
+{
+	current_thread_info()->status |= TS_POLLING;
+}
+
+static inline void current_clr_polling(void)
+{
+	current_thread_info()->status &= ~TS_POLLING;
+	smp_mb__after_clear_bit();
+}
+#elif defined(TIF_POLLING_NRFLAG)
+static inline int tsk_is_polling(struct task_struct *p)
+{
+	return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
+}
+static inline void current_set_polling(void)
+{
+	set_thread_flag(TIF_POLLING_NRFLAG);
+}
+
+static inline void current_clr_polling(void)
+{
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+}
+#else
+static inline int tsk_is_polling(struct task_struct *p) { return 0; }
+static inline void current_set_polling(void) { }
+static inline void current_clr_polling(void) { }
+#endif
+
+/*
  * Thread group CPU time accounting.
  */
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
diff --git a/init/main.c b/init/main.c
index 63534a1..adb179d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -384,7 +384,7 @@ static noinline void __init_refok rest_init(void)
 	init_idle_bootup_task(current);
 	schedule_preempt_disabled();
 	/* Call into cpu_idle with preempt disabled */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Check for early params. */
diff --git a/kernel/Makefile b/kernel/Makefile
index bbde5f1..d1574d4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -24,6 +24,7 @@ endif
 
 obj-y += sched/
 obj-y += power/
+obj-y += cpu/
 
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
diff --git a/kernel/cpu/Makefile b/kernel/cpu/Makefile
new file mode 100644
index 0000000..59ab052
--- /dev/null
+++ b/kernel/cpu/Makefile
@@ -0,0 +1 @@
+obj-y	= idle.o
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
new file mode 100644
index 0000000..168cf40
--- /dev/null
+++ b/kernel/cpu/idle.c
@@ -0,0 +1,107 @@
+/*
+ * Generic entry point for the idle threads
+ */
+#include <linux/sched.h>
+#include <linux/cpu.h>
+#include <linux/tick.h>
+#include <linux/mm.h>
+
+#include <asm/tlb.h>
+
+#include <trace/events/power.h>
+
+static int __read_mostly cpu_idle_force_poll;
+
+void cpu_idle_poll_ctrl(bool enable)
+{
+	if (enable) {
+		cpu_idle_force_poll++;
+	} else {
+		cpu_idle_force_poll--;
+		WARN_ON_ONCE(cpu_idle_force_poll < 0);
+	}
+}
+
+#ifdef CONFIG_GENERIC_IDLE_POLL_SETUP
+static int __init cpu_idle_poll_setup(char *__unused)
+{
+	cpu_idle_force_poll = 1;
+	return 1;
+}
+__setup("nohlt", cpu_idle_poll_setup);
+
+static int __init cpu_idle_nopoll_setup(char *__unused)
+{
+	cpu_idle_force_poll = 0;
+	return 1;
+}
+__setup("hlt", cpu_idle_nopoll_setup);
+#endif
+
+static inline int cpu_idle_poll(void)
+{
+	trace_cpu_idle_rcuidle(0, smp_processor_id());
+	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+	return 1;
+}
+
+/* Weak implementations for optional arch specific functions */
+void __weak arch_cpu_idle_prepare(void) { }
+void __weak arch_cpu_idle_enter(void) { }
+void __weak arch_cpu_idle_exit(void) { }
+void __weak arch_cpu_idle_dead(void) { }
+void __weak arch_cpu_idle(void)
+{
+	cpu_idle_force_poll = 1;
+}
+
+/*
+ * Generic idle loop implementation
+ */
+static void cpu_idle_loop(void)
+{
+	while (1) {
+		tick_nohz_idle_enter();
+
+		while (!need_resched()) {
+			check_pgt_cache();
+			rmb();
+
+			if (cpu_is_offline(smp_processor_id()))
+				arch_cpu_idle_dead();
+
+			local_irq_disable();
+			arch_cpu_idle_enter();
+
+			if (cpu_idle_force_poll) {
+				cpu_idle_poll();
+			} else {
+				current_clr_polling();
+				if (!need_resched()) {
+					stop_critical_timings();
+					rcu_idle_enter();
+					arch_cpu_idle();
+					WARN_ON_ONCE(irqs_disabled());
+					rcu_idle_exit();
+					start_critical_timings();
+				} else {
+					local_irq_enable();
+				}
+				current_set_polling();
+			}
+			arch_cpu_idle_exit();
+		}
+		tick_nohz_idle_exit();
+		schedule_preempt_disabled();
+	}
+}
+
+void cpu_startup_entry(enum cpuhp_state state)
+{
+	current_set_polling();
+	arch_cpu_idle_prepare();
+	cpu_idle_loop();
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..243a20c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -512,11 +512,6 @@ static inline void init_hrtick(void)
  * the target CPU.
  */
 #ifdef CONFIG_SMP
-
-#ifndef tsk_is_polling
-#define tsk_is_polling(t) 0
-#endif
-
 void resched_task(struct task_struct *p)
 {
 	int cpu;
