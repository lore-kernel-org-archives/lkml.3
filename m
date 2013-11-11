Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3KKPst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:48:49 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39787 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab3KKPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:48:38 -0500
Date: Mon, 11 Nov 2013 16:48:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.13
Message-ID: <20131111154833.GA11500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

   # HEAD: ee5872befc9324fa4c2583c24d7ee7120314a2b7 x86/time: Honor ACPI FADT flag indicating absence of a CMOS RTC

Main changes in this cycle were:

  * Updated full dynticks support.

  * Event stream support for architected (ARM) timers.

  * ARM clocksource driver updates.

  * Move arm64 to using the generic sched_clock framework & resulting
    cleanup in the generic sched_clock code.

  * Misc fixes and cleanups

 Thanks,

	Ingo

------------------>
Boris BREZILLON (3):
      clocksource: tcb_clksrc: Replace clk_enable/disable with clk_prepare_enable/disable_unprepare
      clocksource: tcb_clksrc: Improve driver robustness
      clocksource: tcb_clksrc: Remove IRQF_DISABLED

Dong Zhu (1):
      timer stats: Add a 'Collection: active/inactive' line to timer usage statistics

Elad Wexler (1):
      clocksource: Fix 'ret' data type of sysfs_override_clocksource() and sysfs_unbind_clocksource()

Jan Beulich (1):
      x86/time: Honor ACPI FADT flag indicating absence of a CMOS RTC

John Stultz (1):
      rtc: rtc-pl031: Set wakeup flag prior to registering rtcdev

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

Kevin Hilman (3):
      vtime: Add HAVE_VIRT_CPU_ACCOUNTING_GEN Kconfig
      nohz: Drop generic vtime obsolete dependency on CONFIG_64BIT
      ARM: Kconfig: allow full nohz CPU accounting

Maxime Ripard (3):
      clocksource: sun4i: Select CLKSRC_MMIO
      clocksource: sun4i: Report the minimum tick that we can program
      clocksource: sun4i: remove IRQF_DISABLED

Miroslav Lichvar (1):
      ntp: Make periodic RTC update more reliable

Patrick Palka (1):
      time: Fix signedness bug in sysfs_get_uname() and its callers

Prarit Bhargava (1):
      clocksource: Fix !CONFIG_CLOCKSOURCE_WATCHDOG compile

Shinya Kuribayashi (1):
      clocksource: em_sti: convert to clk_prepare/unprepare

Soren Brinkmann (4):
      clockchips: Add FEAT_PERCPU clockevent flag
      clocksource/arm_global_timer: Set FEAT_PERCPU flag
      tick: broadcast: Deny per-cpu clockevents from being broadcast sources
      arm: zynq: Enable arm_global_timer

Stephen Boyd (17):
      clocksource: Extract max nsec calculation into separate function
      sched_clock: Use seqcount instead of rolling our own
      sched_clock: Use an hrtimer instead of timer
      sched_clock: Add support for >32 bit sched_clock
      clocksource: bcm2835: Switch to sched_clock_register()
      clocksource: dbx500-prcmu: Switch to sched_clock_register()
      clocksource: dw_apb_timer_of: Switch to sched_clock_register()
      clocksource: mxs_timer: Switch to sched_clock_register()
      clocksource: nomadik: Switch to sched_clock_register()
      clocksource: samsung_pwm_timer: Switch to sched_clock_register()
      clocksource: tegra: Switch to sched_clock_register()
      clocksource: time-armada-370-xp: Switch to sched_clock_register()
      clocksource: sirf: Switch to sched_clock_register() and use 64 bits
      clocksource: vf_pit_timer: Switch to sched_clock_register()
      clocksource: arm_arch_timer: Use clocksource for suspend timekeeping
      arch_timer: Move to generic sched_clock framework
      sched_clock: Remove sched_clock_func() hook

Sudeep KarkadaNagesha (4):
      ARM/ARM64: arch_timer: add macros for bits in control register
      ARM: arch_timer: add support to configure and enable event stream
      ARM64: arch_timer: add support to configure and enable event stream
      drivers: clocksource: add CPU PM notifier for ARM architected timer

Thierry Reding (1):
      clocksource: arch_timer: Do not register arch_sys_counter twice

Uwe Kleine-König (3):
      clocksource: Put nodes passed to CLOCKSOURCE_OF_DECLARE callbacks centrally
      clocksource: dw_apb_timer_of: Mark a few more functions as __init
      clocksource: Provide timekeeping for efm32 SoCs

Will Deacon (1):
      drivers: clocksource: add support for ARM architected timer event stream

Xie XiuQi (1):
      timekeeping: Fix some trivial typos in comments

Zoran Markovic (1):
      rtc: Keep system awake until all expired RTC timers are handled


 .../devicetree/bindings/timer/efm32,timer.txt      |  23 ++
 arch/Kconfig                                       |  12 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/zynq-7000.dtsi                   |   8 +
 arch/arm/include/asm/arch_timer.h                  |  36 ++-
 arch/arm/include/uapi/asm/hwcap.h                  |   1 +
 arch/arm/kernel/arch_timer.c                       |  14 --
 arch/arm/kernel/setup.c                            |   1 +
 arch/arm/mach-msm/timer.c                          |   1 -
 arch/arm/mach-zynq/Kconfig                         |   1 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/arch_timer.h                |  42 +++-
 arch/arm64/include/asm/hwcap.h                     |  11 +-
 arch/arm64/include/uapi/asm/hwcap.h                |   1 +
 arch/arm64/kernel/setup.c                          |  11 +
 arch/arm64/kernel/time.c                           |  10 -
 arch/x86/kernel/rtc.c                              |   8 +
 drivers/clocksource/Kconfig                        |  24 ++
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/arm_arch_timer.c               |  55 ++++-
 drivers/clocksource/arm_global_timer.c             |   3 +-
 drivers/clocksource/bcm2835_timer.c                |   4 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c          |   5 +-
 drivers/clocksource/clksrc-of.c                    |   1 +
 drivers/clocksource/dw_apb_timer_of.c              |  16 +-
 drivers/clocksource/em_sti.c                       |   4 +-
 drivers/clocksource/mxs_timer.c                    |   4 +-
 drivers/clocksource/nomadik-mtu.c                  |   4 +-
 drivers/clocksource/samsung_pwm_timer.c            |   4 +-
 drivers/clocksource/sun4i_timer.c                  |  12 +-
 drivers/clocksource/tcb_clksrc.c                   |  61 ++++-
 drivers/clocksource/tegra20_timer.c                |   8 +-
 drivers/clocksource/time-armada-370-xp.c           |   4 +-
 drivers/clocksource/time-efm32.c                   | 275 +++++++++++++++++++++
 drivers/clocksource/timer-prima2.c                 |   6 +-
 drivers/clocksource/vf_pit_timer.c                 |   4 +-
 drivers/clocksource/vt8500_timer.c                 |   2 -
 drivers/rtc/interface.c                            |  13 +-
 drivers/rtc/rtc-pl031.c                            |   3 +-
 include/clocksource/arm_arch_timer.h               |  10 +
 include/linux/clockchips.h                         |   1 +
 include/linux/clocksource.h                        |   2 +
 include/linux/sched_clock.h                        |   4 +-
 init/Kconfig                                       |   3 +-
 kernel/time/Kconfig                                |   2 +-
 kernel/time/alarmtimer.c                           |   4 +-
 kernel/time/clockevents.c                          |   2 +-
 kernel/time/clocksource.c                          |  52 ++--
 kernel/time/ntp.c                                  |   3 +-
 kernel/time/sched_clock.c                          | 114 ++++-----
 kernel/time/tick-broadcast.c                       |   1 +
 kernel/time/tick-internal.h                        |   2 +-
 kernel/time/timekeeping.c                          |   3 +-
 kernel/time/timer_stats.c                          |   8 +-
 54 files changed, 717 insertions(+), 189 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/efm32,timer.txt
 create mode 100644 drivers/clocksource/time-efm32.c

diff --git a/Documentation/devicetree/bindings/timer/efm32,timer.txt b/Documentation/devicetree/bindings/timer/efm32,timer.txt
new file mode 100644
index 0000000..97a568f
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/efm32,timer.txt
@@ -0,0 +1,23 @@
+* EFM32 timer hardware
+
+The efm32 Giant Gecko SoCs come with four 16 bit timers. Two counters can be
+connected to form a 32 bit counter. Each timer has three Compare/Capture
+channels and can be used as PWM or Quadrature Decoder. Available clock sources
+are the cpu's HFPERCLK (with a 10-bit prescaler) or an external pin.
+
+Required properties:
+- compatible : Should be efm32,timer
+- reg : Address and length of the register set
+- clocks : Should contain a reference to the HFPERCLK
+
+Optional properties:
+- interrupts : Reference to the timer interrupt
+
+Example:
+
+timer@40010c00 {
+	compatible = "efm32,timer";
+	reg = <0x40010c00 0x400>;
+	interrupts = <14>;
+	clocks = <&cmu clk_HFPERCLKTIMER3>;
+};
diff --git a/arch/Kconfig b/arch/Kconfig
index af2cc6e..185f8b0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -353,6 +353,18 @@ config HAVE_CONTEXT_TRACKING
 config HAVE_VIRT_CPU_ACCOUNTING
 	bool
 
+config HAVE_VIRT_CPU_ACCOUNTING_GEN
+	bool
+	default y if 64BIT
+	help
+	  With VIRT_CPU_ACCOUNTING_GEN, cputime_t becomes 64-bit.
+	  Before enabling this option, arch code must be audited
+	  to ensure there are no races in concurrent read/write of
+	  cputime_t. For example, reading/writing 64-bit cputime_t on
+	  some 32-bit arches may require multiple accesses, so proper
+	  locking is needed to protect against concurrent accesses.
+
+
 config HAVE_IRQ_TIME_ACCOUNTING
 	bool
 	help
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..323baf0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -54,6 +54,7 @@ config ARM
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
+	select HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select IRQ_FORCED_THREADING
 	select KTIME_SCALAR
 	select MODULES_USE_ELF_REL
diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e32b92b..e7f73b2 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -92,6 +92,14 @@
 			};
 		};
 
+		global_timer: timer@f8f00200 {
+			compatible = "arm,cortex-a9-global-timer";
+			reg = <0xf8f00200 0x20>;
+			interrupts = <1 11 0x301>;
+			interrupt-parent = <&intc>;
+			clocks = <&clkc 4>;
+		};
+
 		ttc0: ttc0@f8001000 {
 			interrupt-parent = <&intc>;
 			interrupts = < 0 10 4 0 11 4 0 12 4 >;
diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 5665134..0704e0c 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -87,17 +87,43 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
 }
 
-static inline void arch_counter_set_user_access(void)
+static inline u32 arch_timer_get_cntkctl(void)
 {
 	u32 cntkctl;
-
 	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
+	return cntkctl;
+}
 
-	/* disable user access to everything */
-	cntkctl &= ~((3 << 8) | (7 << 0));
-
+static inline void arch_timer_set_cntkctl(u32 cntkctl)
+{
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
+
+static inline void arch_counter_set_user_access(void)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+
+	/* Disable user access to both physical/virtual counters/timers */
+	/* Also disable virtual event stream */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_VCT_ACCESS_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+	arch_timer_set_cntkctl(cntkctl);
+}
+
+static inline void arch_timer_evtstrm_enable(int divider)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
+	/* Set the divider and enable virtual event stream */
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN;
+	arch_timer_set_cntkctl(cntkctl);
+	elf_hwcap |= HWCAP_EVTSTRM;
+}
+
 #endif
 
 #endif
diff --git a/arch/arm/include/uapi/asm/hwcap.h b/arch/arm/include/uapi/asm/hwcap.h
index 6d34d08..7dcc10d 100644
--- a/arch/arm/include/uapi/asm/hwcap.h
+++ b/arch/arm/include/uapi/asm/hwcap.h
@@ -26,5 +26,6 @@
 #define HWCAP_VFPD32	(1 << 19)	/* set if VFP has 32 regs (not 16) */
 #define HWCAP_IDIV	(HWCAP_IDIVA | HWCAP_IDIVT)
 #define HWCAP_LPAE	(1 << 20)
+#define HWCAP_EVTSTRM	(1 << 21)
 
 #endif /* _UAPI__ASMARM_HWCAP_H */
diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index 221f07b..1791f12 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/sched_clock.h>
 
 #include <asm/delay.h>
 
@@ -22,13 +21,6 @@ static unsigned long arch_timer_read_counter_long(void)
 	return arch_timer_read_counter();
 }
 
-static u32 sched_clock_mult __read_mostly;
-
-static unsigned long long notrace arch_timer_sched_clock(void)
-{
-	return arch_timer_read_counter() * sched_clock_mult;
-}
-
 static struct delay_timer arch_delay_timer;
 
 static void __init arch_timer_delay_timer_register(void)
@@ -48,11 +40,5 @@ int __init arch_timer_arch_init(void)
 
 	arch_timer_delay_timer_register();
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
-	sched_clock_func = arch_timer_sched_clock;
-	pr_info("sched_clock: ARM arch timer >56 bits at %ukHz, resolution %uns\n",
-		arch_timer_rate / 1000, sched_clock_mult);
-
 	return 0;
 }
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0e1e2b3..5d65438 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -975,6 +975,7 @@ static const char *hwcap_str[] = {
 	"idivt",
 	"vfpd32",
 	"lpae",
+	"evtstrm",
 	NULL
 };
 
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 696fb73..1e9c338 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -274,7 +274,6 @@ static void __init msm_dt_timer_init(struct device_node *np)
 		pr_err("Unknown frequency\n");
 		return;
 	}
-	of_node_put(np);
 
 	event_base = base + 0x4;
 	sts_base = base + 0x88;
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 04f8a4a..6b04260 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -13,5 +13,6 @@ config ARCH_ZYNQ
 	select HAVE_SMP
 	select SPARSE_IRQ
 	select CADENCE_TTC_TIMER
+	select ARM_GLOBAL_TIMER
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..35fd0eb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -14,6 +14,7 @@ config ARM64
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index c9f1d28..9400596 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -92,19 +92,49 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
-static inline void arch_counter_set_user_access(void)
+static inline u32 arch_timer_get_cntkctl(void)
 {
 	u32 cntkctl;
-
-	/* Disable user access to the timers and the physical counter. */
 	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
-	cntkctl &= ~((3 << 8) | (1 << 0));
+	return cntkctl;
+}
 
-	/* Enable user access to the virtual counter and frequency. */
-	cntkctl |= (1 << 1);
+static inline void arch_timer_set_cntkctl(u32 cntkctl)
+{
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
+static inline void arch_counter_set_user_access(void)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+
+	/* Disable user access to the timers and the physical counter */
+	/* Also disable virtual event stream */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+
+	/* Enable user access to the virtual counter */
+	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+
+	arch_timer_set_cntkctl(cntkctl);
+}
+
+static inline void arch_timer_evtstrm_enable(int divider)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
+	/* Set the divider and enable virtual event stream */
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN;
+	arch_timer_set_cntkctl(cntkctl);
+	elf_hwcap |= HWCAP_EVTSTRM;
+#ifdef CONFIG_COMPAT
+	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
+#endif
+}
+
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index e2950b0..6cddbb0 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -30,6 +30,7 @@
 #define COMPAT_HWCAP_IDIVA	(1 << 17)
 #define COMPAT_HWCAP_IDIVT	(1 << 18)
 #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
+#define COMPAT_HWCAP_EVTSTRM	(1 << 21)
 
 #ifndef __ASSEMBLY__
 /*
@@ -37,11 +38,11 @@
  * instruction set this cpu supports.
  */
 #define ELF_HWCAP		(elf_hwcap)
-#define COMPAT_ELF_HWCAP	(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
-				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
-				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
-				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
-				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
+
+#ifdef CONFIG_COMPAT
+#define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
+extern unsigned int compat_elf_hwcap;
+#endif
 
 extern unsigned long elf_hwcap;
 #endif
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index eea4975..9b12476 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -21,6 +21,7 @@
  */
 #define HWCAP_FP		(1 << 0)
 #define HWCAP_ASIMD		(1 << 1)
+#define HWCAP_EVTSTRM		(1 << 2)
 
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 055cfb8..d355b7b 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -60,6 +60,16 @@ EXPORT_SYMBOL(processor_id);
 unsigned long elf_hwcap __read_mostly;
 EXPORT_SYMBOL_GPL(elf_hwcap);
 
+#ifdef CONFIG_COMPAT
+#define COMPAT_ELF_HWCAP_DEFAULT	\
+				(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
+				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
+				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
+				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
+				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
+unsigned int compat_elf_hwcap __read_mostly = COMPAT_ELF_HWCAP_DEFAULT;
+#endif
+
 static const char *cpu_name;
 static const char *machine_name;
 phys_addr_t __fdt_pointer __initdata;
@@ -304,6 +314,7 @@ subsys_initcall(topology_init);
 static const char *hwcap_str[] = {
 	"fp",
 	"asimd",
+	"evtstrm",
 	NULL
 };
 
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 03dc371..29c39d5 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -61,13 +61,6 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-static u64 sched_clock_mult __read_mostly;
-
-unsigned long long notrace sched_clock(void)
-{
-	return arch_timer_read_counter() * sched_clock_mult;
-}
-
 void __init time_init(void)
 {
 	u32 arch_timer_rate;
@@ -78,9 +71,6 @@ void __init time_init(void)
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
 
-	/* Cache the sched_clock multiplier to save a divide in the hot path. */
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
-
 	/* Calibrate the delay loop directly */
 	lpj_fine = arch_timer_rate / HZ;
 }
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 0aa2939..5b9dd44 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -192,6 +192,14 @@ static __init int add_rtc_cmos(void)
 	if (mrst_identify_cpu())
 		return -ENODEV;
 
+#ifdef CONFIG_ACPI
+	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC) {
+		/* This warning can likely go away again in a year or two. */
+		pr_info("ACPI: not registering RTC platform device\n");
+		return -ENODEV;
+	}
+#endif
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 971d796..bdb953e 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -34,6 +34,7 @@ config ORION_TIMER
 	bool
 
 config SUN4I_TIMER
+	select CLKSRC_MMIO
 	bool
 
 config VT8500_TIMER
@@ -71,10 +72,33 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
 	help
 	  Use the always on PRCMU Timer as sched_clock
 
+config CLKSRC_EFM32
+	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
+	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
+	default ARCH_EFM32
+	help
+	  Support to use the timers of EFM32 SoCs as clock source and clock
+	  event device.
+
 config ARM_ARCH_TIMER
 	bool
 	select CLKSRC_OF if OF
 
+config ARM_ARCH_TIMER_EVTSTREAM
+	bool "Support for ARM architected timer event stream generation"
+	default y if ARM_ARCH_TIMER
+	help
+	  This option enables support for event stream generation based on
+	  the ARM architected timer. It is used for waking up CPUs executing
+	  the wfe instruction at a frequency represented as a power-of-2
+	  divisor of the clock rate.
+	  The main use of the event stream is wfe-based timeouts of userspace
+	  locking implementations. It might also be useful for imposing timeout
+	  on wfe to safeguard against any programming errors in case an expected
+	  event is not generated.
+	  This must be disabled for hardware validation purposes to detect any
+	  hardware anomalies of missing events.
+
 config ARM_GLOBAL_TIMER
 	bool
 	select CLKSRC_OF if OF
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 704d6d3..33621ef 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
 obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
 obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
+obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fbd9ccd..95fb944 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -13,12 +13,14 @@
 #include <linux/device.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/sched_clock.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
@@ -294,6 +296,19 @@ static void __arch_timer_setup(unsigned type,
 	clockevents_config_and_register(clk, arch_timer_rate, 0xf, 0x7fffffff);
 }
 
+static void arch_timer_configure_evtstream(void)
+{
+	int evt_stream_div, pos;
+
+	/* Find the closest power of two to the divisor */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
+	pos = fls(evt_stream_div);
+	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
+		pos--;
+	/* enable event stream */
+	arch_timer_evtstrm_enable(min(pos, 15));
+}
+
 static int arch_timer_setup(struct clock_event_device *clk)
 {
 	__arch_timer_setup(ARCH_CP15_TIMER, clk);
@@ -307,6 +322,8 @@ static int arch_timer_setup(struct clock_event_device *clk)
 	}
 
 	arch_counter_set_user_access();
+	if (IS_ENABLED(CONFIG_ARM_ARCH_TIMER_EVTSTREAM))
+		arch_timer_configure_evtstream();
 
 	return 0;
 }
@@ -389,7 +406,7 @@ static struct clocksource clocksource_counter = {
 	.rating	= 400,
 	.read	= arch_counter_read,
 	.mask	= CLOCKSOURCE_MASK(56),
-	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS | CLOCK_SOURCE_SUSPEND_NONSTOP,
 };
 
 static struct cyclecounter cyclecounter = {
@@ -419,6 +436,9 @@ static void __init arch_counter_register(unsigned type)
 	cyclecounter.mult = clocksource_counter.mult;
 	cyclecounter.shift = clocksource_counter.shift;
 	timecounter_init(&timecounter, &cyclecounter, start_count);
+
+	/* 56 bits minimum, so we assume worst case rollover */
+	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
 }
 
 static void arch_timer_stop(struct clock_event_device *clk)
@@ -460,6 +480,33 @@ static struct notifier_block arch_timer_cpu_nb = {
 	.notifier_call = arch_timer_cpu_notify,
 };
 
+#ifdef CONFIG_CPU_PM
+static unsigned int saved_cntkctl;
+static int arch_timer_cpu_pm_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	if (action == CPU_PM_ENTER)
+		saved_cntkctl = arch_timer_get_cntkctl();
+	else if (action == CPU_PM_ENTER_FAILED || action == CPU_PM_EXIT)
+		arch_timer_set_cntkctl(saved_cntkctl);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block arch_timer_cpu_pm_notifier = {
+	.notifier_call = arch_timer_cpu_pm_notify,
+};
+
+static int __init arch_timer_cpu_pm_init(void)
+{
+	return cpu_pm_register_notifier(&arch_timer_cpu_pm_notifier);
+}
+#else
+static int __init arch_timer_cpu_pm_init(void)
+{
+	return 0;
+}
+#endif
+
 static int __init arch_timer_register(void)
 {
 	int err;
@@ -499,11 +546,17 @@ static int __init arch_timer_register(void)
 	if (err)
 		goto out_free_irq;
 
+	err = arch_timer_cpu_pm_init();
+	if (err)
+		goto out_unreg_notify;
+
 	/* Immediately configure the timer on the boot CPU */
 	arch_timer_setup(this_cpu_ptr(arch_timer_evt));
 
 	return 0;
 
+out_unreg_notify:
+	unregister_cpu_notifier(&arch_timer_cpu_nb);
 out_free_irq:
 	if (arch_timer_use_virtual)
 		free_percpu_irq(arch_timer_ppi[VIRT_PPI], arch_timer_evt);
diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index b66c1f3..c639b1a 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -169,7 +169,8 @@ static int gt_clockevents_init(struct clock_event_device *clk)
 	int cpu = smp_processor_id();
 
 	clk->name = "arm_global_timer";
-	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
+		CLOCK_EVT_FEAT_PERCPU;
 	clk->set_mode = gt_clockevent_set_mode;
 	clk->set_next_event = gt_clockevent_set_next_event;
 	clk->cpumask = cpumask_of(cpu);
diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index 07ea7ce..26ed331 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -49,7 +49,7 @@ struct bcm2835_timer {
 
 static void __iomem *system_clock __read_mostly;
 
-static u32 notrace bcm2835_sched_read(void)
+static u64 notrace bcm2835_sched_read(void)
 {
 	return readl_relaxed(system_clock);
 }
@@ -110,7 +110,7 @@ static void __init bcm2835_timer_init(struct device_node *node)
 		panic("Can't read clock-frequency");
 
 	system_clock = base + REG_COUNTER_LO;
-	setup_sched_clock(bcm2835_sched_read, 32, freq);
+	sched_clock_register(bcm2835_sched_read, 32, freq);
 
 	clocksource_mmio_init(base + REG_COUNTER_LO, node->name,
 		freq, 300, 32, clocksource_mmio_readl_up);
diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index a9fd4ad..b375106 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -53,7 +53,7 @@ static struct clocksource clocksource_dbx500_prcmu = {
 
 #ifdef CONFIG_CLKSRC_DBX500_PRCMU_SCHED_CLOCK
 
-static u32 notrace dbx500_prcmu_sched_clock_read(void)
+static u64 notrace dbx500_prcmu_sched_clock_read(void)
 {
 	if (unlikely(!clksrc_dbx500_timer_base))
 		return 0;
@@ -81,8 +81,7 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
 		       clksrc_dbx500_timer_base + PRCMU_TIMER_REF);
 	}
 #ifdef CONFIG_CLKSRC_DBX500_PRCMU_SCHED_CLOCK
-	setup_sched_clock(dbx500_prcmu_sched_clock_read,
-			 32, RATE_32K);
+	sched_clock_register(dbx500_prcmu_sched_clock_read, 32, RATE_32K);
 #endif
 	clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
 }
diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index b9ddd9e..35639cf4 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -35,5 +35,6 @@ void __init clocksource_of_init(void)
 
 		init_func = match->data;
 		init_func(np);
+		of_node_put(np);
 	}
 }
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 4cbae4f..45ba8ae 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -23,7 +23,7 @@
 #include <linux/clk.h>
 #include <linux/sched_clock.h>
 
-static void timer_get_base_and_rate(struct device_node *np,
+static void __init timer_get_base_and_rate(struct device_node *np,
 				    void __iomem **base, u32 *rate)
 {
 	struct clk *timer_clk;
@@ -55,11 +55,11 @@ static void timer_get_base_and_rate(struct device_node *np,
 
 try_clock_freq:
 	if (of_property_read_u32(np, "clock-freq", rate) &&
-		of_property_read_u32(np, "clock-frequency", rate))
+	    of_property_read_u32(np, "clock-frequency", rate))
 		panic("No clock nor clock-frequency property for %s", np->name);
 }
 
-static void add_clockevent(struct device_node *event_timer)
+static void __init add_clockevent(struct device_node *event_timer)
 {
 	void __iomem *iobase;
 	struct dw_apb_clock_event_device *ced;
@@ -82,7 +82,7 @@ static void add_clockevent(struct device_node *event_timer)
 static void __iomem *sched_io_base;
 static u32 sched_rate;
 
-static void add_clocksource(struct device_node *source_timer)
+static void __init add_clocksource(struct device_node *source_timer)
 {
 	void __iomem *iobase;
 	struct dw_apb_clocksource *cs;
@@ -106,7 +106,7 @@ static void add_clocksource(struct device_node *source_timer)
 	sched_rate = rate;
 }
 
-static u32 read_sched_clock(void)
+static u64 read_sched_clock(void)
 {
 	return __raw_readl(sched_io_base);
 }
@@ -117,7 +117,7 @@ static const struct of_device_id sptimer_ids[] __initconst = {
 	{ /* Sentinel */ },
 };
 
-static void init_sched_clock(void)
+static void __init init_sched_clock(void)
 {
 	struct device_node *sched_timer;
 
@@ -128,7 +128,7 @@ static void init_sched_clock(void)
 		of_node_put(sched_timer);
 	}
 
-	setup_sched_clock(read_sched_clock, 32, sched_rate);
+	sched_clock_register(read_sched_clock, 32, sched_rate);
 }
 
 static int num_called;
@@ -138,12 +138,10 @@ static void __init dw_apb_timer_init(struct device_node *timer)
 	case 0:
 		pr_debug("%s: found clockevent timer\n", __func__);
 		add_clockevent(timer);
-		of_node_put(timer);
 		break;
 	case 1:
 		pr_debug("%s: found clocksource timer\n", __func__);
 		add_clocksource(timer);
-		of_node_put(timer);
 		init_sched_clock();
 		break;
 	default:
diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 3a5909c..9d17083 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -78,7 +78,7 @@ static int em_sti_enable(struct em_sti_priv *p)
 	int ret;
 
 	/* enable clock */
-	ret = clk_enable(p->clk);
+	ret = clk_prepare_enable(p->clk);
 	if (ret) {
 		dev_err(&p->pdev->dev, "cannot enable clock\n");
 		return ret;
@@ -107,7 +107,7 @@ static void em_sti_disable(struct em_sti_priv *p)
 	em_sti_write(p, STI_INTENCLR, 3);
 
 	/* stop clock */
-	clk_disable(p->clk);
+	clk_disable_unprepare(p->clk);
 }
 
 static cycle_t em_sti_count(struct em_sti_priv *p)
diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
index 0f5e65f..445b68a 100644
--- a/drivers/clocksource/mxs_timer.c
+++ b/drivers/clocksource/mxs_timer.c
@@ -222,7 +222,7 @@ static struct clocksource clocksource_mxs = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-static u32 notrace mxs_read_sched_clock_v2(void)
+static u64 notrace mxs_read_sched_clock_v2(void)
 {
 	return ~readl_relaxed(mxs_timrot_base + HW_TIMROT_RUNNING_COUNTn(1));
 }
@@ -236,7 +236,7 @@ static int __init mxs_clocksource_init(struct clk *timer_clk)
 	else {
 		clocksource_mmio_init(mxs_timrot_base + HW_TIMROT_RUNNING_COUNTn(1),
 			"mxs_timer", c, 200, 32, clocksource_mmio_readl_down);
-		setup_sched_clock(mxs_read_sched_clock_v2, 32, c);
+		sched_clock_register(mxs_read_sched_clock_v2, 32, c);
 	}
 
 	return 0;
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 1b74bea..ed7b73b 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -76,7 +76,7 @@ static struct delay_timer mtu_delay_timer;
  * local implementation which uses the clocksource to get some
  * better resolution when scheduling the kernel.
  */
-static u32 notrace nomadik_read_sched_clock(void)
+static u64 notrace nomadik_read_sched_clock(void)
 {
 	if (unlikely(!mtu_base))
 		return 0;
@@ -231,7 +231,7 @@ static void __init __nmdk_timer_init(void __iomem *base, int irq,
 		       "mtu_0");
 
 #ifdef CONFIG_CLKSRC_NOMADIK_MTU_SCHED_CLOCK
-	setup_sched_clock(nomadik_read_sched_clock, 32, rate);
+	sched_clock_register(nomadik_read_sched_clock, 32, rate);
 #endif
 
 	/* Timer 1 is used for events, register irq and clockevents */
diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index ab29476..85082e8 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -331,7 +331,7 @@ static struct clocksource samsung_clocksource = {
  * this wraps around for now, since it is just a relative time
  * stamp. (Inspired by U300 implementation.)
  */
-static u32 notrace samsung_read_sched_clock(void)
+static u64 notrace samsung_read_sched_clock(void)
 {
 	return samsung_clocksource_read(NULL);
 }
@@ -357,7 +357,7 @@ static void __init samsung_clocksource_init(void)
 	else
 		pwm.source_reg = pwm.base + pwm.source_id * 0x0c + 0x14;
 
-	setup_sched_clock(samsung_read_sched_clock,
+	sched_clock_register(samsung_read_sched_clock,
 						pwm.variant.bits, clock_rate);
 
 	samsung_clocksource.mask = CLOCKSOURCE_MASK(pwm.variant.bits);
diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 8ead025..2fb4695 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -37,6 +37,8 @@
 #define TIMER_INTVAL_REG(val)	(0x10 * (val) + 0x14)
 #define TIMER_CNTVAL_REG(val)	(0x10 * (val) + 0x18)
 
+#define TIMER_SYNC_TICKS	3
+
 static void __iomem *timer_base;
 static u32 ticks_per_jiffy;
 
@@ -50,7 +52,7 @@ static void sun4i_clkevt_sync(void)
 {
 	u32 old = readl(timer_base + TIMER_CNTVAL_REG(1));
 
-	while ((old - readl(timer_base + TIMER_CNTVAL_REG(1))) < 3)
+	while ((old - readl(timer_base + TIMER_CNTVAL_REG(1))) < TIMER_SYNC_TICKS)
 		cpu_relax();
 }
 
@@ -104,7 +106,7 @@ static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
 	sun4i_clkevt_time_stop(0);
-	sun4i_clkevt_time_setup(0, evt);
+	sun4i_clkevt_time_setup(0, evt - TIMER_SYNC_TICKS);
 	sun4i_clkevt_time_start(0, false);
 
 	return 0;
@@ -131,7 +133,7 @@ static irqreturn_t sun4i_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction sun4i_timer_irq = {
 	.name = "sun4i_timer0",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags = IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = sun4i_timer_interrupt,
 	.dev_id = &sun4i_clockevent,
 };
@@ -187,8 +189,8 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	sun4i_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&sun4i_clockevent, rate, 0x1,
-					0xffffffff);
+	clockevents_config_and_register(&sun4i_clockevent, rate,
+					TIMER_SYNC_TICKS, 0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
 		       sun4i_timer_init);
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 8a61872..00fdd11 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -100,7 +100,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 			|| tcd->clkevt.mode == CLOCK_EVT_MODE_ONESHOT) {
 		__raw_writel(0xff, regs + ATMEL_TC_REG(2, IDR));
 		__raw_writel(ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(2, CCR));
-		clk_disable(tcd->clk);
+		clk_disable_unprepare(tcd->clk);
 	}
 
 	switch (m) {
@@ -109,7 +109,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 	 * of oneshot, we get lower overhead and improved accuracy.
 	 */
 	case CLOCK_EVT_MODE_PERIODIC:
-		clk_enable(tcd->clk);
+		clk_prepare_enable(tcd->clk);
 
 		/* slow clock, count up to RC, then irq and restart */
 		__raw_writel(timer_clock
@@ -126,7 +126,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-		clk_enable(tcd->clk);
+		clk_prepare_enable(tcd->clk);
 
 		/* slow clock, count up to RC, then irq and stop */
 		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
@@ -180,15 +180,22 @@ static irqreturn_t ch2_irq(int irq, void *handle)
 
 static struct irqaction tc_irqaction = {
 	.name		= "tc_clkevt",
-	.flags		= IRQF_TIMER | IRQF_DISABLED,
+	.flags		= IRQF_TIMER,
 	.handler	= ch2_irq,
 };
 
-static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
+static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 {
+	int ret;
 	struct clk *t2_clk = tc->clk[2];
 	int irq = tc->irq[2];
 
+	/* try to enable t2 clk to avoid future errors in mode change */
+	ret = clk_prepare_enable(t2_clk);
+	if (ret)
+		return ret;
+	clk_disable_unprepare(t2_clk);
+
 	clkevt.regs = tc->regs;
 	clkevt.clk = t2_clk;
 	tc_irqaction.dev_id = &clkevt;
@@ -197,16 +204,21 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
+	ret = setup_irq(irq, &tc_irqaction);
+	if (ret)
+		return ret;
+
 	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
 
-	setup_irq(irq, &tc_irqaction);
+	return ret;
 }
 
 #else /* !CONFIG_GENERIC_CLOCKEVENTS */
 
-static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
+static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 {
 	/* NOTHING */
+	return 0;
 }
 
 #endif
@@ -265,6 +277,7 @@ static int __init tcb_clksrc_init(void)
 	int best_divisor_idx = -1;
 	int clk32k_divisor_idx = -1;
 	int i;
+	int ret;
 
 	tc = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, clksrc.name);
 	if (!tc) {
@@ -275,7 +288,11 @@ static int __init tcb_clksrc_init(void)
 	pdev = tc->pdev;
 
 	t0_clk = tc->clk[0];
-	clk_enable(t0_clk);
+	ret = clk_prepare_enable(t0_clk);
+	if (ret) {
+		pr_debug("can't enable T0 clk\n");
+		goto err_free_tc;
+	}
 
 	/* How fast will we be counting?  Pick something over 5 MHz.  */
 	rate = (u32) clk_get_rate(t0_clk);
@@ -313,17 +330,39 @@ static int __init tcb_clksrc_init(void)
 		/* tclib will give us three clocks no matter what the
 		 * underlying platform supports.
 		 */
-		clk_enable(tc->clk[1]);
+		ret = clk_prepare_enable(tc->clk[1]);
+		if (ret) {
+			pr_debug("can't enable T1 clk\n");
+			goto err_disable_t0;
+		}
 		/* setup both channel 0 & 1 */
 		tcb_setup_dual_chan(tc, best_divisor_idx);
 	}
 
 	/* and away we go! */
-	clocksource_register_hz(&clksrc, divided_rate);
+	ret = clocksource_register_hz(&clksrc, divided_rate);
+	if (ret)
+		goto err_disable_t1;
 
 	/* channel 2:  periodic and oneshot timer support */
-	setup_clkevents(tc, clk32k_divisor_idx);
+	ret = setup_clkevents(tc, clk32k_divisor_idx);
+	if (ret)
+		goto err_unregister_clksrc;
 
 	return 0;
+
+err_unregister_clksrc:
+	clocksource_unregister(&clksrc);
+
+err_disable_t1:
+	if (!tc->tcb_config || tc->tcb_config->counter_width != 32)
+		clk_disable_unprepare(tc->clk[1]);
+
+err_disable_t0:
+	clk_disable_unprepare(t0_clk);
+
+err_free_tc:
+	atmel_tc_free(tc);
+	return ret;
 }
 arch_initcall(tcb_clksrc_init);
diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index 9396170..6428492 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -98,7 +98,7 @@ static struct clock_event_device tegra_clockevent = {
 	.set_mode	= tegra_timer_set_mode,
 };
 
-static u32 notrace tegra_read_sched_clock(void)
+static u64 notrace tegra_read_sched_clock(void)
 {
 	return timer_readl(TIMERUS_CNTR_1US);
 }
@@ -181,8 +181,6 @@ static void __init tegra20_init_timer(struct device_node *np)
 		rate = clk_get_rate(clk);
 	}
 
-	of_node_put(np);
-
 	switch (rate) {
 	case 12000000:
 		timer_writel(0x000b, TIMERUS_USEC_CFG);
@@ -200,7 +198,7 @@ static void __init tegra20_init_timer(struct device_node *np)
 		WARN(1, "Unknown clock rate");
 	}
 
-	setup_sched_clock(tegra_read_sched_clock, 32, 1000000);
+	sched_clock_register(tegra_read_sched_clock, 32, 1000000);
 
 	if (clocksource_mmio_init(timer_reg_base + TIMERUS_CNTR_1US,
 		"timer_us", 1000000, 300, 32, clocksource_mmio_readl_up)) {
@@ -241,8 +239,6 @@ static void __init tegra20_init_rtc(struct device_node *np)
 	else
 		clk_prepare_enable(clk);
 
-	of_node_put(np);
-
 	register_persistent_clock(NULL, tegra_read_persistent_clock);
 }
 CLOCKSOURCE_OF_DECLARE(tegra20_rtc, "nvidia,tegra20-rtc", tegra20_init_rtc);
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 0198504..d8e47e5 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -96,7 +96,7 @@ static void local_timer_ctrl_clrset(u32 clr, u32 set)
 		local_base + TIMER_CTRL_OFF);
 }
 
-static u32 notrace armada_370_xp_read_sched_clock(void)
+static u64 notrace armada_370_xp_read_sched_clock(void)
 {
 	return ~readl(timer_base + TIMER0_VAL_OFF);
 }
@@ -258,7 +258,7 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	/*
 	 * Set scale and timer for sched_clock.
 	 */
-	setup_sched_clock(armada_370_xp_read_sched_clock, 32, timer_clk);
+	sched_clock_register(armada_370_xp_read_sched_clock, 32, timer_clk);
 
 	/*
 	 * Setup free-running clocksource timer (interrupts
diff --git a/drivers/clocksource/time-efm32.c b/drivers/clocksource/time-efm32.c
new file mode 100644
index 0000000..1a6205b
--- /dev/null
+++ b/drivers/clocksource/time-efm32.c
@@ -0,0 +1,275 @@
+/*
+ * Copyright (C) 2013 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk.h>
+
+#define TIMERn_CTRL			0x00
+#define TIMERn_CTRL_PRESC(val)			(((val) & 0xf) << 24)
+#define TIMERn_CTRL_PRESC_1024			TIMERn_CTRL_PRESC(10)
+#define TIMERn_CTRL_CLKSEL(val)			(((val) & 0x3) << 16)
+#define TIMERn_CTRL_CLKSEL_PRESCHFPERCLK	TIMERn_CTRL_CLKSEL(0)
+#define TIMERn_CTRL_OSMEN			0x00000010
+#define TIMERn_CTRL_MODE(val)			(((val) & 0x3) <<  0)
+#define TIMERn_CTRL_MODE_UP			TIMERn_CTRL_MODE(0)
+#define TIMERn_CTRL_MODE_DOWN			TIMERn_CTRL_MODE(1)
+
+#define TIMERn_CMD			0x04
+#define TIMERn_CMD_START			0x00000001
+#define TIMERn_CMD_STOP				0x00000002
+
+#define TIMERn_IEN			0x0c
+#define TIMERn_IF			0x10
+#define TIMERn_IFS			0x14
+#define TIMERn_IFC			0x18
+#define TIMERn_IRQ_UF				0x00000002
+
+#define TIMERn_TOP			0x1c
+#define TIMERn_CNT			0x24
+
+struct efm32_clock_event_ddata {
+	struct clock_event_device evtdev;
+	void __iomem *base;
+	unsigned periodic_top;
+};
+
+static void efm32_clock_event_set_mode(enum clock_event_mode mode,
+				       struct clock_event_device *evtdev)
+{
+	struct efm32_clock_event_ddata *ddata =
+		container_of(evtdev, struct efm32_clock_event_ddata, evtdev);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
+		writel_relaxed(ddata->periodic_top, ddata->base + TIMERn_TOP);
+		writel_relaxed(TIMERn_CTRL_PRESC_1024 |
+			       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
+			       TIMERn_CTRL_MODE_DOWN,
+			       ddata->base + TIMERn_CTRL);
+		writel_relaxed(TIMERn_CMD_START, ddata->base + TIMERn_CMD);
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
+		writel_relaxed(TIMERn_CTRL_PRESC_1024 |
+			       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
+			       TIMERn_CTRL_OSMEN |
+			       TIMERn_CTRL_MODE_DOWN,
+			       ddata->base + TIMERn_CTRL);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	}
+}
+
+static int efm32_clock_event_set_next_event(unsigned long evt,
+					    struct clock_event_device *evtdev)
+{
+	struct efm32_clock_event_ddata *ddata =
+		container_of(evtdev, struct efm32_clock_event_ddata, evtdev);
+
+	writel_relaxed(TIMERn_CMD_STOP, ddata->base + TIMERn_CMD);
+	writel_relaxed(evt, ddata->base + TIMERn_CNT);
+	writel_relaxed(TIMERn_CMD_START, ddata->base + TIMERn_CMD);
+
+	return 0;
+}
+
+static irqreturn_t efm32_clock_event_handler(int irq, void *dev_id)
+{
+	struct efm32_clock_event_ddata *ddata = dev_id;
+
+	writel_relaxed(TIMERn_IRQ_UF, ddata->base + TIMERn_IFC);
+
+	ddata->evtdev.event_handler(&ddata->evtdev);
+
+	return IRQ_HANDLED;
+}
+
+static struct efm32_clock_event_ddata clock_event_ddata = {
+	.evtdev = {
+		.name = "efm32 clockevent",
+		.features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_MODE_PERIODIC,
+		.set_mode = efm32_clock_event_set_mode,
+		.set_next_event = efm32_clock_event_set_next_event,
+		.rating = 200,
+	},
+};
+
+static struct irqaction efm32_clock_event_irq = {
+	.name = "efm32 clockevent",
+	.flags = IRQF_TIMER,
+	.handler = efm32_clock_event_handler,
+	.dev_id = &clock_event_ddata,
+};
+
+static int __init efm32_clocksource_init(struct device_node *np)
+{
+	struct clk *clk;
+	void __iomem *base;
+	unsigned long rate;
+	int ret;
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		pr_err("failed to get clock for clocksource (%d)\n", ret);
+		goto err_clk_get;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		pr_err("failed to enable timer clock for clocksource (%d)\n",
+		       ret);
+		goto err_clk_enable;
+	}
+	rate = clk_get_rate(clk);
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		ret = -EADDRNOTAVAIL;
+		pr_err("failed to map registers for clocksource\n");
+		goto err_iomap;
+	}
+
+	writel_relaxed(TIMERn_CTRL_PRESC_1024 |
+		       TIMERn_CTRL_CLKSEL_PRESCHFPERCLK |
+		       TIMERn_CTRL_MODE_UP, base + TIMERn_CTRL);
+	writel_relaxed(TIMERn_CMD_START, base + TIMERn_CMD);
+
+	ret = clocksource_mmio_init(base + TIMERn_CNT, "efm32 timer",
+				    DIV_ROUND_CLOSEST(rate, 1024), 200, 16,
+				    clocksource_mmio_readl_up);
+	if (ret) {
+		pr_err("failed to init clocksource (%d)\n", ret);
+		goto err_clocksource_init;
+	}
+
+	return 0;
+
+err_clocksource_init:
+
+	iounmap(base);
+err_iomap:
+
+	clk_disable_unprepare(clk);
+err_clk_enable:
+
+	clk_put(clk);
+err_clk_get:
+
+	return ret;
+}
+
+static int __init efm32_clockevent_init(struct device_node *np)
+{
+	struct clk *clk;
+	void __iomem *base;
+	unsigned long rate;
+	int irq;
+	int ret;
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		pr_err("failed to get clock for clockevent (%d)\n", ret);
+		goto err_clk_get;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		pr_err("failed to enable timer clock for clockevent (%d)\n",
+		       ret);
+		goto err_clk_enable;
+	}
+	rate = clk_get_rate(clk);
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		ret = -EADDRNOTAVAIL;
+		pr_err("failed to map registers for clockevent\n");
+		goto err_iomap;
+	}
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq) {
+		ret = -ENOENT;
+		pr_err("failed to get irq for clockevent\n");
+		goto err_get_irq;
+	}
+
+	writel_relaxed(TIMERn_IRQ_UF, base + TIMERn_IEN);
+
+	clock_event_ddata.base = base;
+	clock_event_ddata.periodic_top = DIV_ROUND_CLOSEST(rate, 1024 * HZ);
+
+	setup_irq(irq, &efm32_clock_event_irq);
+
+	clockevents_config_and_register(&clock_event_ddata.evtdev,
+					DIV_ROUND_CLOSEST(rate, 1024),
+					0xf, 0xffff);
+
+	return 0;
+
+err_get_irq:
+
+	iounmap(base);
+err_iomap:
+
+	clk_disable_unprepare(clk);
+err_clk_enable:
+
+	clk_put(clk);
+err_clk_get:
+
+	return ret;
+}
+
+/*
+ * This function asserts that we have exactly one clocksource and one
+ * clock_event_device in the end.
+ */
+static void __init efm32_timer_init(struct device_node *np)
+{
+	static int has_clocksource, has_clockevent;
+	int ret;
+
+	if (!has_clocksource) {
+		ret = efm32_clocksource_init(np);
+		if (!ret) {
+			has_clocksource = 1;
+			return;
+		}
+	}
+
+	if (!has_clockevent) {
+		ret = efm32_clockevent_init(np);
+		if (!ret) {
+			has_clockevent = 1;
+			return;
+		}
+	}
+}
+CLOCKSOURCE_OF_DECLARE(efm32, "efm32,timer", efm32_timer_init);
diff --git a/drivers/clocksource/timer-prima2.c b/drivers/clocksource/timer-prima2.c
index ef3cfb2..8a492d3 100644
--- a/drivers/clocksource/timer-prima2.c
+++ b/drivers/clocksource/timer-prima2.c
@@ -165,9 +165,9 @@ static struct irqaction sirfsoc_timer_irq = {
 };
 
 /* Overwrite weak default sched_clock with more precise one */
-static u32 notrace sirfsoc_read_sched_clock(void)
+static u64 notrace sirfsoc_read_sched_clock(void)
 {
-	return (u32)(sirfsoc_timer_read(NULL) & 0xffffffff);
+	return sirfsoc_timer_read(NULL);
 }
 
 static void __init sirfsoc_clockevent_init(void)
@@ -206,7 +206,7 @@ static void __init sirfsoc_prima2_timer_init(struct device_node *np)
 
 	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, CLOCK_TICK_RATE));
 
-	setup_sched_clock(sirfsoc_read_sched_clock, 32, CLOCK_TICK_RATE);
+	sched_clock_register(sirfsoc_read_sched_clock, 64, CLOCK_TICK_RATE);
 
 	BUG_ON(setup_irq(sirfsoc_timer_irq.irq, &sirfsoc_timer_irq));
 
diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index 587e020..02821b0 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -52,7 +52,7 @@ static inline void pit_irq_acknowledge(void)
 	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
 }
 
-static unsigned int pit_read_sched_clock(void)
+static u64 pit_read_sched_clock(void)
 {
 	return __raw_readl(clksrc_base + PITCVAL);
 }
@@ -64,7 +64,7 @@ static int __init pit_clocksource_init(unsigned long rate)
 	__raw_writel(~0UL, clksrc_base + PITLDVAL);
 	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
 
-	setup_sched_clock(pit_read_sched_clock, 32, rate);
+	sched_clock_register(pit_read_sched_clock, 32, rate);
 	return clocksource_mmio_init(clksrc_base + PITCVAL, "vf-pit", rate,
 			300, 32, clocksource_mmio_readl_down);
 }
diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
index 64f553f..ad3c0e8 100644
--- a/drivers/clocksource/vt8500_timer.c
+++ b/drivers/clocksource/vt8500_timer.c
@@ -137,14 +137,12 @@ static void __init vt8500_timer_init(struct device_node *np)
 	if (!regbase) {
 		pr_err("%s: Missing iobase description in Device Tree\n",
 								__func__);
-		of_node_put(np);
 		return;
 	}
 	timer_irq = irq_of_parse_and_map(np, 0);
 	if (!timer_irq) {
 		pr_err("%s: Missing irq description in Device Tree\n",
 								__func__);
-		of_node_put(np);
 		return;
 	}
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 72c5cdb..544be72 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -72,6 +72,7 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 	} else
 		err = -EINVAL;
 
+	pm_stay_awake(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 	/* A timer might have just expired */
 	schedule_work(&rtc->irqwork);
@@ -113,6 +114,7 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 		err = -EINVAL;
 	}
 
+	pm_stay_awake(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 	/* A timer might have just expired */
 	schedule_work(&rtc->irqwork);
@@ -771,9 +773,10 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 		alarm.time = rtc_ktime_to_tm(timer->node.expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
-		if (err == -ETIME)
+		if (err == -ETIME) {
+			pm_stay_awake(rtc->dev.parent);
 			schedule_work(&rtc->irqwork);
-		else if (err) {
+		} else if (err) {
 			timerqueue_del(&rtc->timerqueue, &timer->node);
 			timer->enabled = 0;
 			return err;
@@ -818,8 +821,10 @@ static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
-		if (err == -ETIME)
+		if (err == -ETIME) {
+			pm_stay_awake(rtc->dev.parent);
 			schedule_work(&rtc->irqwork);
+		}
 	}
 }
 
@@ -845,7 +850,6 @@ void rtc_timer_do_work(struct work_struct *work)
 
 	mutex_lock(&rtc->ops_lock);
 again:
-	pm_relax(rtc->dev.parent);
 	__rtc_read_time(rtc, &tm);
 	now = rtc_tm_to_ktime(tm);
 	while ((next = timerqueue_getnext(&rtc->timerqueue))) {
@@ -880,6 +884,7 @@ again:
 	} else
 		rtc_alarm_disable(rtc);
 
+	pm_relax(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 }
 
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 0f0609b..e3b2571 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -371,6 +371,7 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 		}
 	}
 
+	device_init_wakeup(&adev->dev, 1);
 	ldata->rtc = rtc_device_register("pl031", &adev->dev, ops,
 					THIS_MODULE);
 	if (IS_ERR(ldata->rtc)) {
@@ -384,8 +385,6 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 		goto out_no_irq;
 	}
 
-	device_init_wakeup(&adev->dev, 1);
-
 	return 0;
 
 out_no_irq:
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 93b7f96..6d26b40 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -33,6 +33,16 @@ enum arch_timer_reg {
 #define ARCH_TIMER_MEM_PHYS_ACCESS	2
 #define ARCH_TIMER_MEM_VIRT_ACCESS	3
 
+#define ARCH_TIMER_USR_PCT_ACCESS_EN	(1 << 0) /* physical counter */
+#define ARCH_TIMER_USR_VCT_ACCESS_EN	(1 << 1) /* virtual counter */
+#define ARCH_TIMER_VIRT_EVT_EN		(1 << 2)
+#define ARCH_TIMER_EVT_TRIGGER_SHIFT	(4)
+#define ARCH_TIMER_EVT_TRIGGER_MASK	(0xF << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+#define ARCH_TIMER_USR_VT_ACCESS_EN	(1 << 8) /* virtual timer registers */
+#define ARCH_TIMER_USR_PT_ACCESS_EN	(1 << 9) /* physical timer registers */
+
+#define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
+
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 0857922..493aa02 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -60,6 +60,7 @@ enum clock_event_mode {
  * Core shall set the interrupt affinity dynamically in broadcast mode
  */
 #define CLOCK_EVT_FEAT_DYNIRQ		0x000020
+#define CLOCK_EVT_FEAT_PERCPU		0x000040
 
 /**
  * struct clock_event_device - clock event device descriptor
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index dbbf8aa..67301a4 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -292,6 +292,8 @@ extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
+extern u64
+clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask);
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
 
diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index fa7922c..cddf0c2 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -15,7 +15,7 @@ static inline void sched_clock_postinit(void) { }
 #endif
 
 extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
-
-extern unsigned long long (*sched_clock_func)(void);
+extern void sched_clock_register(u64 (*read)(void), int bits,
+				 unsigned long rate);
 
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..841e79c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -354,7 +354,8 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 
 config VIRT_CPU_ACCOUNTING_GEN
 	bool "Full dynticks CPU time accounting"
-	depends on HAVE_CONTEXT_TRACKING && 64BIT
+	depends on HAVE_CONTEXT_TRACKING
+	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select VIRT_CPU_ACCOUNTING
 	select CONTEXT_TRACKING
 	help
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 2b62fe8..3ce6e8c 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -100,7 +100,7 @@ config NO_HZ_FULL
 	# RCU_USER_QS dependency
 	depends on HAVE_CONTEXT_TRACKING
 	# VIRT_CPU_ACCOUNTING_GEN dependency
-	depends on 64BIT
+	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select NO_HZ_COMMON
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index eec50fc..88c9c65 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -490,7 +490,7 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	return hrtimer_get_res(baseid, tp);
 }
@@ -507,7 +507,7 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..30554b9 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -584,7 +584,7 @@ static ssize_t sysfs_unbind_tick_dev(struct device *dev,
 				     const char *buf, size_t count)
 {
 	char name[CS_NAME_LEN];
-	size_t ret = sysfs_get_uname(buf, name, count);
+	ssize_t ret = sysfs_get_uname(buf, name, count);
 	struct clock_event_device *ce;
 
 	if (ret < 0)
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 50a8736..ba3e502 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -479,6 +479,7 @@ static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
 static inline int __clocksource_watchdog_kthread(void) { return 0; }
 static bool clocksource_is_watchdog(struct clocksource *cs) { return false; }
+void clocksource_mark_unstable(struct clocksource *cs) { }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
@@ -537,40 +538,55 @@ static u32 clocksource_max_adjustment(struct clocksource *cs)
 }
 
 /**
- * clocksource_max_deferment - Returns max time the clocksource can be deferred
- * @cs:         Pointer to clocksource
- *
+ * clocks_calc_max_nsecs - Returns maximum nanoseconds that can be converted
+ * @mult:	cycle to nanosecond multiplier
+ * @shift:	cycle to nanosecond divisor (power of two)
+ * @maxadj:	maximum adjustment value to mult (~11%)
+ * @mask:	bitmask for two's complement subtraction of non 64 bit counters
  */
-static u64 clocksource_max_deferment(struct clocksource *cs)
+u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
 {
 	u64 max_nsecs, max_cycles;
 
 	/*
 	 * Calculate the maximum number of cycles that we can pass to the
 	 * cyc2ns function without overflowing a 64-bit signed result. The
-	 * maximum number of cycles is equal to ULLONG_MAX/(cs->mult+cs->maxadj)
+	 * maximum number of cycles is equal to ULLONG_MAX/(mult+maxadj)
 	 * which is equivalent to the below.
-	 * max_cycles < (2^63)/(cs->mult + cs->maxadj)
-	 * max_cycles < 2^(log2((2^63)/(cs->mult + cs->maxadj)))
-	 * max_cycles < 2^(log2(2^63) - log2(cs->mult + cs->maxadj))
-	 * max_cycles < 2^(63 - log2(cs->mult + cs->maxadj))
-	 * max_cycles < 1 << (63 - log2(cs->mult + cs->maxadj))
+	 * max_cycles < (2^63)/(mult + maxadj)
+	 * max_cycles < 2^(log2((2^63)/(mult + maxadj)))
+	 * max_cycles < 2^(log2(2^63) - log2(mult + maxadj))
+	 * max_cycles < 2^(63 - log2(mult + maxadj))
+	 * max_cycles < 1 << (63 - log2(mult + maxadj))
 	 * Please note that we add 1 to the result of the log2 to account for
 	 * any rounding errors, ensure the above inequality is satisfied and
 	 * no overflow will occur.
 	 */
-	max_cycles = 1ULL << (63 - (ilog2(cs->mult + cs->maxadj) + 1));
+	max_cycles = 1ULL << (63 - (ilog2(mult + maxadj) + 1));
 
 	/*
 	 * The actual maximum number of cycles we can defer the clocksource is
-	 * determined by the minimum of max_cycles and cs->mask.
+	 * determined by the minimum of max_cycles and mask.
 	 * Note: Here we subtract the maxadj to make sure we don't sleep for
 	 * too long if there's a large negative adjustment.
 	 */
-	max_cycles = min_t(u64, max_cycles, (u64) cs->mask);
-	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult - cs->maxadj,
-					cs->shift);
+	max_cycles = min(max_cycles, mask);
+	max_nsecs = clocksource_cyc2ns(max_cycles, mult - maxadj, shift);
+
+	return max_nsecs;
+}
+
+/**
+ * clocksource_max_deferment - Returns max time the clocksource can be deferred
+ * @cs:         Pointer to clocksource
+ *
+ */
+static u64 clocksource_max_deferment(struct clocksource *cs)
+{
+	u64 max_nsecs;
 
+	max_nsecs = clocks_calc_max_nsecs(cs->mult, cs->shift, cs->maxadj,
+					  cs->mask);
 	/*
 	 * To ensure that the clocksource does not wrap whilst we are idle,
 	 * limit the time the clocksource can be deferred by 12.5%. Please
@@ -893,7 +909,7 @@ sysfs_show_current_clocksources(struct device *dev,
 	return count;
 }
 
-size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt)
+ssize_t sysfs_get_uname(const char *buf, char *dst, size_t cnt)
 {
 	size_t ret = cnt;
 
@@ -924,7 +940,7 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	size_t ret;
+	ssize_t ret;
 
 	mutex_lock(&clocksource_mutex);
 
@@ -952,7 +968,7 @@ static ssize_t sysfs_unbind_clocksource(struct device *dev,
 {
 	struct clocksource *cs;
 	char name[CS_NAME_LEN];
-	size_t ret;
+	ssize_t ret;
 
 	ret = sysfs_get_uname(buf, name, count);
 	if (ret < 0)
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index bb22151..af8d1d4 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -475,6 +475,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	 * called as close as possible to 500 ms before the new second starts.
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
+	 * We want the clock to be within a couple of ticks from the target.
 	 */
 	if (!ntp_synced()) {
 		/*
@@ -485,7 +486,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec * 5) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 0b479a6..68b7993 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -8,25 +8,28 @@
 #include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
 #include <linux/syscore_ops.h>
-#include <linux/timer.h>
+#include <linux/hrtimer.h>
 #include <linux/sched_clock.h>
+#include <linux/seqlock.h>
+#include <linux/bitops.h>
 
 struct clock_data {
+	ktime_t wrap_kt;
 	u64 epoch_ns;
-	u32 epoch_cyc;
-	u32 epoch_cyc_copy;
+	u64 epoch_cyc;
+	seqcount_t seq;
 	unsigned long rate;
 	u32 mult;
 	u32 shift;
 	bool suspended;
 };
 
-static void sched_clock_poll(unsigned long wrap_ticks);
-static DEFINE_TIMER(sched_clock_timer, sched_clock_poll, 0, 0);
+static struct hrtimer sched_clock_timer;
 static int irqtime = -1;
 
 core_param(irqtime, irqtime, int, 0400);
@@ -35,42 +38,46 @@ static struct clock_data cd = {
 	.mult	= NSEC_PER_SEC / HZ,
 };
 
-static u32 __read_mostly sched_clock_mask = 0xffffffff;
+static u64 __read_mostly sched_clock_mask;
 
-static u32 notrace jiffy_sched_clock_read(void)
+static u64 notrace jiffy_sched_clock_read(void)
 {
-	return (u32)(jiffies - INITIAL_JIFFIES);
+	/*
+	 * We don't need to use get_jiffies_64 on 32-bit arches here
+	 * because we register with BITS_PER_LONG
+	 */
+	return (u64)(jiffies - INITIAL_JIFFIES);
 }
 
-static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
+static u32 __read_mostly (*read_sched_clock_32)(void);
+
+static u64 notrace read_sched_clock_32_wrapper(void)
+{
+	return read_sched_clock_32();
+}
+
+static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
 
 static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long notrace sched_clock_32(void)
+unsigned long long notrace sched_clock(void)
 {
 	u64 epoch_ns;
-	u32 epoch_cyc;
-	u32 cyc;
+	u64 epoch_cyc;
+	u64 cyc;
+	unsigned long seq;
 
 	if (cd.suspended)
 		return cd.epoch_ns;
 
-	/*
-	 * Load the epoch_cyc and epoch_ns atomically.  We do this by
-	 * ensuring that we always write epoch_cyc, epoch_ns and
-	 * epoch_cyc_copy in strict order, and read them in strict order.
-	 * If epoch_cyc and epoch_cyc_copy are not equal, then we're in
-	 * the middle of an update, and we should repeat the load.
-	 */
 	do {
+		seq = read_seqcount_begin(&cd.seq);
 		epoch_cyc = cd.epoch_cyc;
-		smp_rmb();
 		epoch_ns = cd.epoch_ns;
-		smp_rmb();
-	} while (epoch_cyc != cd.epoch_cyc_copy);
+	} while (read_seqcount_retry(&cd.seq, seq));
 
 	cyc = read_sched_clock();
 	cyc = (cyc - epoch_cyc) & sched_clock_mask;
@@ -83,49 +90,46 @@ static unsigned long long notrace sched_clock_32(void)
 static void notrace update_sched_clock(void)
 {
 	unsigned long flags;
-	u32 cyc;
+	u64 cyc;
 	u64 ns;
 
 	cyc = read_sched_clock();
 	ns = cd.epoch_ns +
 		cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
 			  cd.mult, cd.shift);
-	/*
-	 * Write epoch_cyc and epoch_ns in a way that the update is
-	 * detectable in cyc_to_fixed_sched_clock().
-	 */
+
 	raw_local_irq_save(flags);
-	cd.epoch_cyc_copy = cyc;
-	smp_wmb();
+	write_seqcount_begin(&cd.seq);
 	cd.epoch_ns = ns;
-	smp_wmb();
 	cd.epoch_cyc = cyc;
+	write_seqcount_end(&cd.seq);
 	raw_local_irq_restore(flags);
 }
 
-static void sched_clock_poll(unsigned long wrap_ticks)
+static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
 {
-	mod_timer(&sched_clock_timer, round_jiffies(jiffies + wrap_ticks));
 	update_sched_clock();
+	hrtimer_forward_now(hrt, cd.wrap_kt);
+	return HRTIMER_RESTART;
 }
 
-void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
+void __init sched_clock_register(u64 (*read)(void), int bits,
+				 unsigned long rate)
 {
-	unsigned long r, w;
+	unsigned long r;
 	u64 res, wrap;
 	char r_unit;
 
 	if (cd.rate > rate)
 		return;
 
-	BUG_ON(bits > 32);
 	WARN_ON(!irqs_disabled());
 	read_sched_clock = read;
-	sched_clock_mask = (1ULL << bits) - 1;
+	sched_clock_mask = CLOCKSOURCE_MASK(bits);
 	cd.rate = rate;
 
 	/* calculate the mult/shift to convert counter ticks to ns. */
-	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 0);
+	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 3600);
 
 	r = rate;
 	if (r >= 4000000) {
@@ -138,20 +142,14 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 		r_unit = ' ';
 
 	/* calculate how many ns until we wrap */
-	wrap = cyc_to_ns((1ULL << bits) - 1, cd.mult, cd.shift);
-	do_div(wrap, NSEC_PER_MSEC);
-	w = wrap;
+	wrap = clocks_calc_max_nsecs(cd.mult, cd.shift, 0, sched_clock_mask);
+	cd.wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
 
 	/* calculate the ns resolution of this counter */
 	res = cyc_to_ns(1ULL, cd.mult, cd.shift);
-	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lums\n",
-		bits, r, r_unit, res, w);
+	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lluns\n",
+		bits, r, r_unit, res, wrap);
 
-	/*
-	 * Start the timer to keep sched_clock() properly updated and
-	 * sets the initial epoch.
-	 */
-	sched_clock_timer.data = msecs_to_jiffies(w - (w / 10));
 	update_sched_clock();
 
 	/*
@@ -166,11 +164,10 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
-unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
-
-unsigned long long notrace sched_clock(void)
+void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 {
-	return sched_clock_func();
+	read_sched_clock_32 = read;
+	sched_clock_register(read_sched_clock_32_wrapper, bits, rate);
 }
 
 void __init sched_clock_postinit(void)
@@ -180,14 +177,22 @@ void __init sched_clock_postinit(void)
 	 * make it the final one one.
 	 */
 	if (read_sched_clock == jiffy_sched_clock_read)
-		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
+		sched_clock_register(jiffy_sched_clock_read, BITS_PER_LONG, HZ);
 
-	sched_clock_poll(sched_clock_timer.data);
+	update_sched_clock();
+
+	/*
+	 * Start the timer to keep sched_clock() properly updated and
+	 * sets the initial epoch.
+	 */
+	hrtimer_init(&sched_clock_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	sched_clock_timer.function = sched_clock_poll;
+	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
 }
 
 static int sched_clock_suspend(void)
 {
-	sched_clock_poll(sched_clock_timer.data);
+	sched_clock_poll(&sched_clock_timer);
 	cd.suspended = true;
 	return 0;
 }
@@ -195,7 +200,6 @@ static int sched_clock_suspend(void)
 static void sched_clock_resume(void)
 {
 	cd.epoch_cyc = read_sched_clock();
-	cd.epoch_cyc_copy = cd.epoch_cyc;
 	cd.suspended = false;
 }
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 218bcb5..9532690 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -70,6 +70,7 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
 					struct clock_event_device *newdev)
 {
 	if ((newdev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (newdev->features & CLOCK_EVT_FEAT_PERCPU) ||
 	    (newdev->features & CLOCK_EVT_FEAT_C3STOP))
 		return false;
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index bc906ca..18e71f7 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -31,7 +31,7 @@ extern void tick_install_replacement(struct clock_event_device *dev);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
 
-extern size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt);
+extern ssize_t sysfs_get_uname(const char *buf, char *dst, size_t cnt);
 
 /*
  * NO_HZ / high resolution timer shared code
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 947ba25..3abf534 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1613,9 +1613,10 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
  * ktime_get_update_offsets - hrtimer helper
  * @offs_real:	pointer to storage for monotonic -> realtime offset
  * @offs_boot:	pointer to storage for monotonic -> boottime offset
+ * @offs_tai:	pointer to storage for monotonic -> clock tai offset
  *
  * Returns current monotonic time and updates the offsets
- * Called from hrtimer_interupt() or retrigger_next_event()
+ * Called from hrtimer_interrupt() or retrigger_next_event()
  */
 ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 0b537f2..1fb08f2 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -298,15 +298,15 @@ static int tstats_show(struct seq_file *m, void *v)
 	period = ktime_to_timespec(time);
 	ms = period.tv_nsec / 1000000;
 
-	seq_puts(m, "Timer Stats Version: v0.2\n");
+	seq_puts(m, "Timer Stats Version: v0.3\n");
 	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
 	if (atomic_read(&overflow_count))
-		seq_printf(m, "Overflow: %d entries\n",
-			atomic_read(&overflow_count));
+		seq_printf(m, "Overflow: %d entries\n", atomic_read(&overflow_count));
+	seq_printf(m, "Collection: %s\n", timer_stats_active ? "active" : "inactive");
 
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
- 		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
+		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
 			seq_printf(m, "%4luD, %5d %-16s ",
 				entry->count, entry->pid, entry->comm);
 		} else {
