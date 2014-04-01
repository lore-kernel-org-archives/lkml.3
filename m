Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaDAJca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:32:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:42438 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAJcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:32:19 -0400
Date: Tue, 1 Apr 2014 11:32:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer changes for 3.15
Message-ID: <alpine.DEB.2.02.1404011121090.14882@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

This assorted collection provides you:

     * A new timer based timer broadcast feature for systems which do
       not provide a global accessible timer device. That allows those
       systems to put CPUs into deep idle states where the per cpu
       timer device stops.

     * A few NOHZ_FULL related improvements to the timer wheel  

     * The usual updates to timer devices found in ARM SoCs

     * Small improvements and updates all over the place

Thanks,

	tglx

------------------>
Dan Carpenter (1):
      clocksource: exynos_mct: silence a static checker warning

Ezequiel Garcia (2):
      clocksource: orion: Use atomic access for shared registers
      clocksource: armada-370-xp: Use atomic access for shared registers

Geert Uytterhoeven (1):
      clocksource: CMT, MTU2, TMU and STI should depend on GENERIC_CLOCKEVENTS

Greg Hackmann (1):
      timerfd: support CLOCK_BOOTTIME clock

Ivan Khoronzhuk (2):
      clocksource: keystone: add bindings for keystone timer
      clocksource: timer-keystone: introduce clocksource driver for Keystone

Linus Walleij (1):
      ARM: u300: move timer driver to clocksource

Magnus Damm (3):
      ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
      sh: Remove Kconfig entries for TMU, CMT and MTU2
      clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI

Matthias Brugger (1):
      clocksource: timer-keystone: Delete unnecessary variable

Maxime Ripard (2):
      clocksource: sunxi: Add new compatibles
      ARM: sunxi: dt: Convert to the new clocksource compatible

Oleg Nesterov (1):
      timers: Make internal_add_timer() update ->next_timer if ->active_timers == 0

Paul E. McKenney (4):
      timers: Track total number of timers in list
      timers: Reduce __run_timers() latency for empty list
      timers: Reduce future __run_timers() latency for newly emptied list
      timers: Reduce future __run_timers() latency for first add to empty list

Paul Gortmaker (1):
      nohz: ensure users are aware boot CPU is not NO_HZ_FULL

Preeti U Murthy (4):
      time: Change the return type of clockevents_notify() to integer
      cpuidle: Handle clockevents_notify(BROADCAST_ENTER) failure
      tick: Introduce hrtimer based broadcast
      tick: Fixup more fallout from hrtimer broadcast mode

Rashika Kheria (1):
      kernel: Include appropriate header file in time/timekeeping_debug.c

Shaibal Dutta (1):
      timekeeping: Move clock sync work to power efficient workqueue

Soren Brinkmann (5):
      clockevents: Adjust timer interval when frequency changes
      clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs enabled
      clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
      arm: zynq: Don't use arm_global_timer with cpufreq
      arm: zynq: Add support for cpufreq

Stephen Boyd (1):
      clocksource: arch_timer: Set dynamic irq affinity on mmio clockevent

Thomas Gleixner (4):
      clockevents: Serialize calls to clockevents_update_freq() in the core
      time: Fixup fallout from recent clockevent/tick changes
      workqueue: Provide destroy_delayed_work_on_stack()
      x86: hpet: Use proper destructor for delayed work

Viresh Kumar (8):
      timer: Spare IPI when deferrable timer is queued on idle remote targets
      timer: Check failure of timer_cpu_notify() before calling init_timer_stats()
      timer: Make sure TIMER_FLAG_MASK bits are free in allocated base
      timer: Use variable head instead of &work_list in __run_timers()
      hrtimer: Rearrange comments in the order struct members are declared
      timer: Remove code redundancy while calling get_nohz_timer_target()
      tick: Fix spelling mistake in tick_handle_periodic()
      tick: Remove code duplication in tick_handle_periodic()


 .../bindings/timer/allwinner,sun4i-timer.txt       |    4 +-
 .../bindings/timer/ti,keystone-timer.txt           |   29 +++
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/sun4i-a10.dtsi                   |    2 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                   |    2 +-
 arch/arm/boot/dts/sun6i-a31.dtsi                   |    2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |    2 +-
 arch/arm/boot/dts/zynq-7000.dtsi                   |    6 +
 arch/arm/mach-shmobile/Kconfig                     |   36 +--
 arch/arm/mach-u300/Makefile                        |    2 +-
 arch/arm/mach-zynq/Kconfig                         |    4 +-
 arch/arm/mach-zynq/common.c                        |    3 +
 arch/sh/Kconfig                                    |   76 ++----
 arch/x86/kernel/hpet.c                             |    2 +-
 drivers/clocksource/Kconfig                        |   48 ++++
 drivers/clocksource/Makefile                       |    2 +
 drivers/clocksource/arm_arch_timer.c               |    1 +
 drivers/clocksource/cadence_ttc_timer.c            |  121 +++++++---
 drivers/clocksource/exynos_mct.c                   |    2 +-
 drivers/clocksource/sun4i_timer.c                  |    2 +-
 drivers/clocksource/time-armada-370-xp.c           |   12 +-
 drivers/clocksource/time-orion.c                   |   28 +--
 drivers/clocksource/timer-keystone.c               |  241 ++++++++++++++++++++
 .../timer.c => drivers/clocksource/timer-u300.c    |    4 -
 drivers/cpuidle/cpuidle.c                          |   14 +-
 fs/timerfd.c                                       |    1 +
 include/linux/clockchips.h                         |   16 +-
 include/linux/hrtimer.h                            |    4 +-
 include/linux/sched.h                              |    6 +-
 include/linux/workqueue.h                          |    2 +
 kernel/hrtimer.c                                   |   15 +-
 kernel/sched/core.c                                |    5 +-
 kernel/time/Kconfig                                |    2 +-
 kernel/time/Makefile                               |    5 +-
 kernel/time/clockevents.c                          |   40 +++-
 kernel/time/ntp.c                                  |    5 +-
 kernel/time/tick-broadcast-hrtimer.c               |  106 +++++++++
 kernel/time/tick-broadcast.c                       |   85 ++++++-
 kernel/time/tick-common.c                          |   16 +-
 kernel/time/tick-internal.h                        |   11 +-
 kernel/time/timekeeping_debug.c                    |    2 +
 kernel/timer.c                                     |   57 +++--
 kernel/workqueue.c                                 |    7 +
 44 files changed, 807 insertions(+), 226 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/ti,keystone-timer.txt
 create mode 100644 drivers/clocksource/timer-keystone.c
 rename arch/arm/mach-u300/timer.c => drivers/clocksource/timer-u300.c (99%)
 create mode 100644 kernel/time/tick-broadcast-hrtimer.c

diff --git a/Documentation/devicetree/bindings/timer/allwinner,sun4i-timer.txt b/Documentation/devicetree/bindings/timer/allwinner,sun4i-timer.txt
index 48aeb78..5c2e235 100644
--- a/Documentation/devicetree/bindings/timer/allwinner,sun4i-timer.txt
+++ b/Documentation/devicetree/bindings/timer/allwinner,sun4i-timer.txt
@@ -2,7 +2,7 @@ Allwinner A1X SoCs Timer Controller
 
 Required properties:
 
-- compatible : should be "allwinner,sun4i-timer"
+- compatible : should be "allwinner,sun4i-a10-timer"
 - reg : Specifies base physical address and size of the registers.
 - interrupts : The interrupt of the first timer
 - clocks: phandle to the source clock (usually a 24 MHz fixed clock)
@@ -10,7 +10,7 @@ Required properties:
 Example:
 
 timer {
-	compatible = "allwinner,sun4i-timer";
+	compatible = "allwinner,sun4i-a10-timer";
 	reg = <0x01c20c00 0x400>;
 	interrupts = <22>;
 	clocks = <&osc>;
diff --git a/Documentation/devicetree/bindings/timer/ti,keystone-timer.txt b/Documentation/devicetree/bindings/timer/ti,keystone-timer.txt
new file mode 100644
index 0000000..5fbe361
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/ti,keystone-timer.txt
@@ -0,0 +1,29 @@
+* Device tree bindings for Texas instruments Keystone timer
+
+This document provides bindings for the 64-bit timer in the KeyStone
+architecture devices. The timer can be configured as a general-purpose 64-bit
+timer, dual general-purpose 32-bit timers. When configured as dual 32-bit
+timers, each half can operate in conjunction (chain mode) or independently
+(unchained mode) of each other.
+
+It is global timer is a free running up-counter and can generate interrupt
+when the counter reaches preset counter values.
+
+Documentation:
+http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf
+
+Required properties:
+
+- compatible : should be "ti,keystone-timer".
+- reg : specifies base physical address and count of the registers.
+- interrupts : interrupt generated by the timer.
+- clocks : the clock feeding the timer clock.
+
+Example:
+
+timer@22f0000 {
+	compatible = "ti,keystone-timer";
+	reg = <0x022f0000 0x80>;
+	interrupts = <GIC_SPI 110 IRQ_TYPE_EDGE_RISING>;
+	clocks = <&clktimer15>;
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..edd6139 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1319,6 +1319,7 @@ M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/arm/mach-u300/
+F:	drivers/clocksource/timer-u300.c
 F:	drivers/i2c/busses/i2c-stu300.c
 F:	drivers/rtc/rtc-coh901331.c
 F:	drivers/watchdog/coh901327_wdt.c
diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 040bb0e..dd64cc0 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -403,7 +403,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <22>;
 			clocks = <&osc24M>;
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index ea16054..9cee110 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -366,7 +366,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <22>;
 			clocks = <&osc24M>;
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 320335a..f5cba63 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -329,7 +329,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <22>;
 			clocks = <&osc24M>;
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 5256ad9..996fff5 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -231,7 +231,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0xa0>;
 			interrupts = <0 18 4>,
 				     <0 19 4>,
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 119f066..4bc5c6f 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -435,7 +435,7 @@
 		};
 
 		timer@01c20c00 {
-			compatible = "allwinner,sun4i-timer";
+			compatible = "allwinner,sun4i-a10-timer";
 			reg = <0x01c20c00 0x90>;
 			interrupts = <0 22 4>,
 				     <0 23 4>,
diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b67b19..789d0ba 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -24,6 +24,12 @@
 			device_type = "cpu";
 			reg = <0>;
 			clocks = <&clkc 3>;
+			operating-points = <
+				/* kHz    uV */
+				666667  1000000
+				333334  1000000
+				222223  1000000
+			>;
 		};
 
 		cpu@1 {
diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 3386406..c1a9538 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -24,17 +24,21 @@ comment "Renesas ARM SoCs System Type"
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
+	select SYS_SUPPORTS_EM_STI
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
+	select SYS_SUPPORTS_SH_MTU2
 
 config ARCH_R8A7790
 	bool "R-Car H2 (R8A77900)"
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 comment "Renesas ARM SoCs Board Type"
 
@@ -68,6 +72,8 @@ config ARCH_SH7372
 	select ARM_CPU_SUSPEND if PM || CPU_IDLE
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_SH73A0
 	bool "SH-Mobile AG5 (R8A73A00)"
@@ -77,6 +83,8 @@ config ARCH_SH73A0
 	select I2C
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A73A4
 	bool "R-Mobile APE6 (R8A73A40)"
@@ -87,6 +95,8 @@ config ARCH_R8A73A4
 	select RENESAS_IRQC
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7740
 	bool "R-Mobile A1 (R8A77400)"
@@ -95,6 +105,8 @@ config ARCH_R8A7740
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7778
 	bool "R-Car M1A (R8A77781)"
@@ -104,6 +116,7 @@ config ARCH_R8A7778
 	select ARM_GIC
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
@@ -114,6 +127,7 @@ config ARCH_R8A7779
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7790
 	bool "R-Car H2 (R8A77900)"
@@ -123,6 +137,7 @@ config ARCH_R8A7790
 	select MIGHT_HAVE_PCI
 	select SH_CLK_CPG
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
@@ -132,6 +147,7 @@ config ARCH_R8A7791
 	select MIGHT_HAVE_PCI
 	select SH_CLK_CPG
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
@@ -141,6 +157,7 @@ config ARCH_EMEV2
 	select MIGHT_HAVE_PCI
 	select USE_OF
 	select AUTO_ZRELADDR
+	select SYS_SUPPORTS_EM_STI
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
@@ -148,6 +165,7 @@ config ARCH_R7S72100
 	select ARM_GIC
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_SH_MTU2
 
 comment "Renesas ARM SoCs Board Type"
 
@@ -321,24 +339,6 @@ config SHMOBILE_TIMER_HZ
 	  want to select a HZ value such as 128 that can evenly divide RCLK.
 	  A HZ value that does not divide evenly may cause timer drift.
 
-config SH_TIMER_CMT
-	bool "CMT timer driver"
-	default y
-	help
-	  This enables build of the CMT timer driver.
-
-config SH_TIMER_TMU
-	bool "TMU timer driver"
-	default y
-	help
-	  This enables build of the TMU timer driver.
-
-config EM_TIMER_STI
-	bool "STI timer driver"
-	default y
-	help
-	  This enables build of the STI timer driver.
-
 endmenu
 
 endif
diff --git a/arch/arm/mach-u300/Makefile b/arch/arm/mach-u300/Makefile
index 0f362b6..3ec74ac 100644
--- a/arch/arm/mach-u300/Makefile
+++ b/arch/arm/mach-u300/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel, U300 machine.
 #
 
-obj-y		:= core.o timer.o
+obj-y		:= core.o
 obj-m		:=
 obj-n		:=
 obj-		:=
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 6b04260..f03e75b 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -2,6 +2,8 @@ config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
 	select ARM_AMBA
 	select ARM_GIC
+	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_OPP
 	select COMMON_CLK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
@@ -13,6 +15,6 @@ config ARCH_ZYNQ
 	select HAVE_SMP
 	select SPARSE_IRQ
 	select CADENCE_TTC_TIMER
-	select ARM_GLOBAL_TIMER
+	select ARM_GLOBAL_TIMER if !CPU_FREQ
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 1db2a5ca..6444681 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -51,6 +51,8 @@ static struct platform_device zynq_cpuidle_device = {
  */
 static void __init zynq_init_machine(void)
 {
+	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", };
+
 	/*
 	 * 64KB way size, 8-way associativity, parity disabled
 	 */
@@ -59,6 +61,7 @@ static void __init zynq_init_machine(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	platform_device_register(&zynq_cpuidle_device);
+	platform_device_register_full(&devinfo);
 }
 
 static void __init zynq_timer_init(void)
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 6357710..364d204 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -123,15 +123,6 @@ config SYS_SUPPORTS_NUMA
 config SYS_SUPPORTS_PCI
 	bool
 
-config SYS_SUPPORTS_CMT
-	bool
-
-config SYS_SUPPORTS_MTU2
-	bool
-
-config SYS_SUPPORTS_TMU
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -191,14 +182,14 @@ config CPU_SH3
 	bool
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 
 config CPU_SH4
 	bool
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
 	select CPU_HAS_FPU if !CPU_SH4AL_DSP
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SH4A
@@ -213,7 +204,7 @@ config CPU_SH4AL_DSP
 config CPU_SH5
 	bool
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SHX2
@@ -250,7 +241,7 @@ choice
 config CPU_SUBTYPE_SH7619
 	bool "Support SH7619 processor"
 	select CPU_SH2
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 # SH-2A Processor Support
 
@@ -258,50 +249,50 @@ config CPU_SUBTYPE_SH7201
 	bool "Support SH7201 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_MTU2
  
 config CPU_SUBTYPE_SH7203
 	bool "Support SH7203 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7206
 	bool "Support SH7206 processor"
 	select CPU_SH2A
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 
 config CPU_SUBTYPE_SH7263
 	bool "Support SH7263 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 
 config CPU_SUBTYPE_SH7264
 	bool "Support SH7264 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7269
 	bool "Support SH7269 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select PINCTRL
 
 config CPU_SUBTYPE_MXG
 	bool "Support MX-G processor"
 	select CPU_SH2A
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_MTU2
 	help
 	  Select MX-G if running on an R8A03022BG part.
 
@@ -354,7 +345,7 @@ config CPU_SUBTYPE_SH7720
 	bool "Support SH7720 processor"
 	select CPU_SH3
 	select CPU_HAS_DSP
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
@@ -366,7 +357,7 @@ config CPU_SUBTYPE_SH7721
 	bool "Support SH7721 processor"
 	select CPU_SH3
 	select CPU_HAS_DSP
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	help
@@ -422,7 +413,7 @@ config CPU_SUBTYPE_SH7723
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 	help
@@ -434,7 +425,7 @@ config CPU_SUBTYPE_SH7724
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 	help
@@ -514,7 +505,7 @@ config CPU_SUBTYPE_SH7343
 	bool "Support SH7343 processor"
 	select CPU_SH4AL_DSP
 	select ARCH_SHMOBILE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 config CPU_SUBTYPE_SH7722
 	bool "Support SH7722 processor"
@@ -523,7 +514,7 @@ config CPU_SUBTYPE_SH7722
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 
@@ -534,7 +525,7 @@ config CPU_SUBTYPE_SH7366
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 endchoice
 
@@ -567,27 +558,6 @@ source "arch/sh/boards/Kconfig"
 
 menu "Timer and clock configuration"
 
-config SH_TIMER_TMU
-	bool "TMU timer driver"
-	depends on SYS_SUPPORTS_TMU
-	default y
-	help
-	  This enables the build of the TMU timer driver.
-
-config SH_TIMER_CMT
-	bool "CMT timer driver"
-	depends on SYS_SUPPORTS_CMT
-	default y
-	help
-	  This enables build of the CMT timer driver.
-
-config SH_TIMER_MTU2
-	bool "MTU2 timer driver"
-	depends on SYS_SUPPORTS_MTU2
-	default y
-	help
-	  This enables build of the MTU2 timer driver.
-
 config SH_PCLK_FREQ
 	int "Peripheral clock frequency (in Hz)"
 	depends on SH_CLK_CPG_LEGACY
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..b91abfd 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -699,7 +699,7 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 		/* FIXME: add schedule_work_on() */
 		schedule_delayed_work_on(cpu, &work.work, 0);
 		wait_for_completion(&work.complete);
-		destroy_timer_on_stack(&work.work.timer);
+		destroy_delayed_work_on_stack(&work.work);
 		break;
 	case CPU_DEAD:
 		if (hdev) {
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index cd6950f..52e9329 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -140,3 +140,51 @@ config VF_PIT_TIMER
 	bool
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
+
+config SYS_SUPPORTS_SH_CMT
+        bool
+
+config SYS_SUPPORTS_SH_MTU2
+        bool
+
+config SYS_SUPPORTS_SH_TMU
+        bool
+
+config SYS_SUPPORTS_EM_STI
+        bool
+
+config SH_TIMER_CMT
+	bool "Renesas CMT timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
+	default SYS_SUPPORTS_SH_CMT
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the Compare Match Timer (CMT) hardware available in 16/32/48-bit
+	  variants on a wide range of Mobile and Automotive SoCs from Renesas.
+
+config SH_TIMER_MTU2
+	bool "Renesas MTU2 timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
+	default SYS_SUPPORTS_SH_MTU2
+	help
+	  This enables build of a clockevent driver for the Multi-Function
+	  Timer Pulse Unit 2 (TMU2) hardware available on SoCs from Renesas.
+	  This hardware comes with 16 bit-timer registers.
+
+config SH_TIMER_TMU
+	bool "Renesas TMU timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
+	default SYS_SUPPORTS_SH_TMU
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the 32-bit Timer Unit (TMU) hardware available on a wide range
+	  SoCs from Renesas.
+
+config EM_TIMER_STI
+	bool "Renesas STI timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
+	default SYS_SUPPORTS_EM_STI
+	help
+	  This enables build of a clocksource and clockevent driver for
+	  the 48-bit System Timer (STI) hardware available on a SoCs
+	  such as EMEV2 from former NEC Electronics.
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index c7ca50a..aed3488 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
+obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_SUN5I_HSTIMER)	+= timer-sun5i.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
@@ -37,3 +38,4 @@ obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
+obj-$(CONFIG_ARCH_KEYSTONE)		+= timer-keystone.o
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 95fb944..57e823c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -277,6 +277,7 @@ static void __arch_timer_setup(unsigned type,
 			clk->set_next_event = arch_timer_set_next_event_phys;
 		}
 	} else {
+		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;
 		clk->name = "arch_mem_timer";
 		clk->rating = 400;
 		clk->cpumask = cpu_all_mask;
diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 63f176d..49fbe28 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
 #include <linux/of_address.h>
@@ -52,6 +53,8 @@
 #define TTC_CNT_CNTRL_DISABLE_MASK	0x1
 
 #define TTC_CLK_CNTRL_CSRC_MASK		(1 << 5)	/* clock source */
+#define TTC_CLK_CNTRL_PSV_MASK		0x1e
+#define TTC_CLK_CNTRL_PSV_SHIFT		1
 
 /*
  * Setup the timers to use pre-scaling, using a fixed value for now that will
@@ -63,6 +66,8 @@
 #define CLK_CNTRL_PRESCALE_EN	1
 #define CNT_CNTRL_RESET		(1 << 4)
 
+#define MAX_F_ERR 50
+
 /**
  * struct ttc_timer - This definition defines local timer structure
  *
@@ -82,6 +87,8 @@ struct ttc_timer {
 		container_of(x, struct ttc_timer, clk_rate_change_nb)
 
 struct ttc_timer_clocksource {
+	u32			scale_clk_ctrl_reg_old;
+	u32			scale_clk_ctrl_reg_new;
 	struct ttc_timer	ttc;
 	struct clocksource	cs;
 };
@@ -229,32 +236,89 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 			struct ttc_timer_clocksource, ttc);
 
 	switch (event) {
-	case POST_RATE_CHANGE:
+	case PRE_RATE_CHANGE:
+	{
+		u32 psv;
+		unsigned long factor, rate_low, rate_high;
+
+		if (ndata->new_rate > ndata->old_rate) {
+			factor = DIV_ROUND_CLOSEST(ndata->new_rate,
+					ndata->old_rate);
+			rate_low = ndata->old_rate;
+			rate_high = ndata->new_rate;
+		} else {
+			factor = DIV_ROUND_CLOSEST(ndata->old_rate,
+					ndata->new_rate);
+			rate_low = ndata->new_rate;
+			rate_high = ndata->old_rate;
+		}
+
+		if (!is_power_of_2(factor))
+				return NOTIFY_BAD;
+
+		if (abs(rate_high - (factor * rate_low)) > MAX_F_ERR)
+			return NOTIFY_BAD;
+
+		factor = __ilog2_u32(factor);
+
 		/*
-		 * Do whatever is necessary to maintain a proper time base
-		 *
-		 * I cannot find a way to adjust the currently used clocksource
-		 * to the new frequency. __clocksource_updatefreq_hz() sounds
-		 * good, but does not work. Not sure what's that missing.
-		 *
-		 * This approach works, but triggers two clocksource switches.
-		 * The first after unregister to clocksource jiffies. And
-		 * another one after the register to the newly registered timer.
-		 *
-		 * Alternatively we could 'waste' another HW timer to ping pong
-		 * between clock sources. That would also use one register and
-		 * one unregister call, but only trigger one clocksource switch
-		 * for the cost of another HW timer used by the OS.
+		 * store timer clock ctrl register so we can restore it in case
+		 * of an abort.
 		 */
-		clocksource_unregister(&ttccs->cs);
-		clocksource_register_hz(&ttccs->cs,
-				ndata->new_rate / PRESCALE);
-		/* fall through */
-	case PRE_RATE_CHANGE:
+		ttccs->scale_clk_ctrl_reg_old =
+			__raw_readl(ttccs->ttc.base_addr +
+					TTC_CLK_CNTRL_OFFSET);
+
+		psv = (ttccs->scale_clk_ctrl_reg_old &
+				TTC_CLK_CNTRL_PSV_MASK) >>
+				TTC_CLK_CNTRL_PSV_SHIFT;
+		if (ndata->new_rate < ndata->old_rate)
+			psv -= factor;
+		else
+			psv += factor;
+
+		/* prescaler within legal range? */
+		if (psv & ~(TTC_CLK_CNTRL_PSV_MASK >> TTC_CLK_CNTRL_PSV_SHIFT))
+			return NOTIFY_BAD;
+
+		ttccs->scale_clk_ctrl_reg_new = ttccs->scale_clk_ctrl_reg_old &
+			~TTC_CLK_CNTRL_PSV_MASK;
+		ttccs->scale_clk_ctrl_reg_new |= psv << TTC_CLK_CNTRL_PSV_SHIFT;
+
+
+		/* scale down: adjust divider in post-change notification */
+		if (ndata->new_rate < ndata->old_rate)
+			return NOTIFY_DONE;
+
+		/* scale up: adjust divider now - before frequency change */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		break;
+	}
+	case POST_RATE_CHANGE:
+		/* scale up: pre-change notification did the adjustment */
+		if (ndata->new_rate > ndata->old_rate)
+			return NOTIFY_OK;
+
+		/* scale down: adjust divider now - after frequency change */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		break;
+
 	case ABORT_RATE_CHANGE:
+		/* we have to undo the adjustment in case we scale up */
+		if (ndata->new_rate < ndata->old_rate)
+			return NOTIFY_OK;
+
+		/* restore original register value */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_old,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		/* fall through */
 	default:
 		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_DONE;
 }
 
 static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
@@ -321,25 +385,12 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
 
 	switch (event) {
 	case POST_RATE_CHANGE:
-	{
-		unsigned long flags;
-
-		/*
-		 * clockevents_update_freq should be called with IRQ disabled on
-		 * the CPU the timer provides events for. The timer we use is
-		 * common to both CPUs, not sure if we need to run on both
-		 * cores.
-		 */
-		local_irq_save(flags);
-		clockevents_update_freq(&ttcce->ce,
-				ndata->new_rate / PRESCALE);
-		local_irq_restore(flags);
-
 		/* update cached frequency */
 		ttc->freq = ndata->new_rate;
 
+		clockevents_update_freq(&ttcce->ce, ndata->new_rate / PRESCALE);
+
 		/* fall through */
-	}
 	case PRE_RATE_CHANGE:
 	case ABORT_RATE_CHANGE:
 	default:
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 48f76bc..c2e390e 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -410,7 +410,7 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	mevt = container_of(evt, struct mct_clock_event_device, evt);
 
 	mevt->base = EXYNOS4_MCT_L_BASE(cpu);
-	sprintf(mevt->name, "mct_tick%d", cpu);
+	snprintf(mevt->name, sizeof(mevt->name), "mct_tick%d", cpu);
 
 	evt->name = mevt->name;
 	evt->cpumask = cpumask_of(cpu);
diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index bf497af..efb17c3 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -196,5 +196,5 @@ static void __init sun4i_timer_init(struct device_node *node)
 	clockevents_config_and_register(&sun4i_clockevent, rate,
 					TIMER_SYNC_TICKS, 0xffffffff);
 }
-CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
+CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-a10-timer",
 		       sun4i_timer_init);
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index ee8691b..0451e62 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -85,12 +85,6 @@ static u32 ticks_per_jiffy;
 
 static struct clock_event_device __percpu *armada_370_xp_evt;
 
-static void timer_ctrl_clrset(u32 clr, u32 set)
-{
-	writel((readl(timer_base + TIMER_CTRL_OFF) & ~clr) | set,
-		timer_base + TIMER_CTRL_OFF);
-}
-
 static void local_timer_ctrl_clrset(u32 clr, u32 set)
 {
 	writel((readl(local_base + TIMER_CTRL_OFF) & ~clr) | set,
@@ -245,7 +239,7 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 		clr = TIMER0_25MHZ;
 		enable_mask = TIMER0_EN | TIMER0_DIV(TIMER_DIVIDER_SHIFT);
 	}
-	timer_ctrl_clrset(clr, set);
+	atomic_io_modify(timer_base + TIMER_CTRL_OFF, clr | set, set);
 	local_timer_ctrl_clrset(clr, set);
 
 	/*
@@ -263,7 +257,9 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	writel(0xffffffff, timer_base + TIMER0_VAL_OFF);
 	writel(0xffffffff, timer_base + TIMER0_RELOAD_OFF);
 
-	timer_ctrl_clrset(0, TIMER0_RELOAD_EN | enable_mask);
+	atomic_io_modify(timer_base + TIMER_CTRL_OFF,
+		TIMER0_RELOAD_EN | enable_mask,
+		TIMER0_RELOAD_EN | enable_mask);
 
 	/*
 	 * Set scale and timer for sched_clock.
diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index 2006622..0b3ce03 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -35,20 +35,6 @@
 #define ORION_ONESHOT_MAX	0xfffffffe
 
 static void __iomem *timer_base;
-static DEFINE_SPINLOCK(timer_ctrl_lock);
-
-/*
- * Thread-safe access to TIMER_CTRL register
- * (shared with watchdog timer)
- */
-void orion_timer_ctrl_clrset(u32 clr, u32 set)
-{
-	spin_lock(&timer_ctrl_lock);
-	writel((readl(timer_base + TIMER_CTRL) & ~clr) | set,
-		timer_base + TIMER_CTRL);
-	spin_unlock(&timer_ctrl_lock);
-}
-EXPORT_SYMBOL(orion_timer_ctrl_clrset);
 
 /*
  * Free-running clocksource handling.
@@ -68,7 +54,8 @@ static int orion_clkevt_next_event(unsigned long delta,
 {
 	/* setup and enable one-shot timer */
 	writel(delta, timer_base + TIMER1_VAL);
-	orion_timer_ctrl_clrset(TIMER1_RELOAD_EN, TIMER1_EN);
+	atomic_io_modify(timer_base + TIMER_CTRL,
+		TIMER1_RELOAD_EN | TIMER1_EN, TIMER1_EN);
 
 	return 0;
 }
@@ -80,10 +67,13 @@ static void orion_clkevt_mode(enum clock_event_mode mode,
 		/* setup and enable periodic timer at 1/HZ intervals */
 		writel(ticks_per_jiffy - 1, timer_base + TIMER1_RELOAD);
 		writel(ticks_per_jiffy - 1, timer_base + TIMER1_VAL);
-		orion_timer_ctrl_clrset(0, TIMER1_RELOAD_EN | TIMER1_EN);
+		atomic_io_modify(timer_base + TIMER_CTRL,
+			TIMER1_RELOAD_EN | TIMER1_EN,
+			TIMER1_RELOAD_EN | TIMER1_EN);
 	} else {
 		/* disable timer */
-		orion_timer_ctrl_clrset(TIMER1_RELOAD_EN | TIMER1_EN, 0);
+		atomic_io_modify(timer_base + TIMER_CTRL,
+			TIMER1_RELOAD_EN | TIMER1_EN, 0);
 	}
 }
 
@@ -131,7 +121,9 @@ static void __init orion_timer_init(struct device_node *np)
 	/* setup timer0 as free-running clocksource */
 	writel(~0, timer_base + TIMER0_VAL);
 	writel(~0, timer_base + TIMER0_RELOAD);
-	orion_timer_ctrl_clrset(0, TIMER0_RELOAD_EN | TIMER0_EN);
+	atomic_io_modify(timer_base + TIMER_CTRL,
+		TIMER0_RELOAD_EN | TIMER0_EN,
+		TIMER0_RELOAD_EN | TIMER0_EN);
 	clocksource_mmio_init(timer_base + TIMER0_VAL, "orion_clocksource",
 			      clk_get_rate(clk), 300, 32,
 			      clocksource_mmio_readl_down);
diff --git a/drivers/clocksource/timer-keystone.c b/drivers/clocksource/timer-keystone.c
new file mode 100644
index 0000000..0250354
--- /dev/null
+++ b/drivers/clocksource/timer-keystone.c
@@ -0,0 +1,241 @@
+/*
+ * Keystone broadcast clock-event
+ *
+ * Copyright 2013 Texas Instruments, Inc.
+ *
+ * Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/interrupt.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#define TIMER_NAME			"timer-keystone"
+
+/* Timer register offsets */
+#define TIM12				0x10
+#define TIM34				0x14
+#define PRD12				0x18
+#define PRD34				0x1c
+#define TCR				0x20
+#define TGCR				0x24
+#define INTCTLSTAT			0x44
+
+/* Timer register bitfields */
+#define TCR_ENAMODE_MASK		0xC0
+#define TCR_ENAMODE_ONESHOT_MASK	0x40
+#define TCR_ENAMODE_PERIODIC_MASK	0x80
+
+#define TGCR_TIM_UNRESET_MASK		0x03
+#define INTCTLSTAT_ENINT_MASK		0x01
+
+/**
+ * struct keystone_timer: holds timer's data
+ * @base: timer memory base address
+ * @hz_period: cycles per HZ period
+ * @event_dev: event device based on timer
+ */
+static struct keystone_timer {
+	void __iomem *base;
+	unsigned long hz_period;
+	struct clock_event_device event_dev;
+} timer;
+
+static inline u32 keystone_timer_readl(unsigned long rg)
+{
+	return readl_relaxed(timer.base + rg);
+}
+
+static inline void keystone_timer_writel(u32 val, unsigned long rg)
+{
+	writel_relaxed(val, timer.base + rg);
+}
+
+/**
+ * keystone_timer_barrier: write memory barrier
+ * use explicit barrier to avoid using readl/writel non relaxed function
+ * variants, because in our case non relaxed variants hide the true places
+ * where barrier is needed.
+ */
+static inline void keystone_timer_barrier(void)
+{
+	__iowmb();
+}
+
+/**
+ * keystone_timer_config: configures timer to work in oneshot/periodic modes.
+ * @ mode: mode to configure
+ * @ period: cycles number to configure for
+ */
+static int keystone_timer_config(u64 period, enum clock_event_mode mode)
+{
+	u32 tcr;
+	u32 off;
+
+	tcr = keystone_timer_readl(TCR);
+	off = tcr & ~(TCR_ENAMODE_MASK);
+
+	/* set enable mode */
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		tcr |= TCR_ENAMODE_ONESHOT_MASK;
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		tcr |= TCR_ENAMODE_PERIODIC_MASK;
+		break;
+	default:
+		return -1;
+	}
+
+	/* disable timer */
+	keystone_timer_writel(off, TCR);
+	/* here we have to be sure the timer has been disabled */
+	keystone_timer_barrier();
+
+	/* reset counter to zero, set new period */
+	keystone_timer_writel(0, TIM12);
+	keystone_timer_writel(0, TIM34);
+	keystone_timer_writel(period & 0xffffffff, PRD12);
+	keystone_timer_writel(period >> 32, PRD34);
+
+	/*
+	 * enable timer
+	 * here we have to be sure that CNTLO, CNTHI, PRDLO, PRDHI registers
+	 * have been written.
+	 */
+	keystone_timer_barrier();
+	keystone_timer_writel(tcr, TCR);
+	return 0;
+}
+
+static void keystone_timer_disable(void)
+{
+	u32 tcr;
+
+	tcr = keystone_timer_readl(TCR);
+
+	/* disable timer */
+	tcr &= ~(TCR_ENAMODE_MASK);
+	keystone_timer_writel(tcr, TCR);
+}
+
+static irqreturn_t keystone_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static int keystone_set_next_event(unsigned long cycles,
+				  struct clock_event_device *evt)
+{
+	return keystone_timer_config(cycles, evt->mode);
+}
+
+static void keystone_set_mode(enum clock_event_mode mode,
+			     struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		keystone_timer_config(timer.hz_period, CLOCK_EVT_MODE_PERIODIC);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_ONESHOT:
+		keystone_timer_disable();
+		break;
+	default:
+		break;
+	}
+}
+
+static void __init keystone_timer_init(struct device_node *np)
+{
+	struct clock_event_device *event_dev = &timer.event_dev;
+	unsigned long rate;
+	struct clk *clk;
+	int irq, error;
+
+	irq  = irq_of_parse_and_map(np, 0);
+	if (irq == NO_IRQ) {
+		pr_err("%s: failed to map interrupts\n", __func__);
+		return;
+	}
+
+	timer.base = of_iomap(np, 0);
+	if (!timer.base) {
+		pr_err("%s: failed to map registers\n", __func__);
+		return;
+	}
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		pr_err("%s: failed to get clock\n", __func__);
+		iounmap(timer.base);
+		return;
+	}
+
+	error = clk_prepare_enable(clk);
+	if (error) {
+		pr_err("%s: failed to enable clock\n", __func__);
+		goto err;
+	}
+
+	rate = clk_get_rate(clk);
+
+	/* disable, use internal clock source */
+	keystone_timer_writel(0, TCR);
+	/* here we have to be sure the timer has been disabled */
+	keystone_timer_barrier();
+
+	/* reset timer as 64-bit, no pre-scaler, plus features are disabled */
+	keystone_timer_writel(0, TGCR);
+
+	/* unreset timer */
+	keystone_timer_writel(TGCR_TIM_UNRESET_MASK, TGCR);
+
+	/* init counter to zero */
+	keystone_timer_writel(0, TIM12);
+	keystone_timer_writel(0, TIM34);
+
+	timer.hz_period = DIV_ROUND_UP(rate, HZ);
+
+	/* enable timer interrupts */
+	keystone_timer_writel(INTCTLSTAT_ENINT_MASK, INTCTLSTAT);
+
+	error = request_irq(irq, keystone_timer_interrupt, IRQF_TIMER,
+			    TIMER_NAME, event_dev);
+	if (error) {
+		pr_err("%s: failed to setup irq\n", __func__);
+		goto err;
+	}
+
+	/* setup clockevent */
+	event_dev->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	event_dev->set_next_event = keystone_set_next_event;
+	event_dev->set_mode = keystone_set_mode;
+	event_dev->cpumask = cpu_all_mask;
+	event_dev->owner = THIS_MODULE;
+	event_dev->name = TIMER_NAME;
+	event_dev->irq = irq;
+
+	clockevents_config_and_register(event_dev, rate, 1, ULONG_MAX);
+
+	pr_info("keystone timer clock @%lu Hz\n", rate);
+	return;
+err:
+	clk_put(clk);
+	iounmap(timer.base);
+}
+
+CLOCKSOURCE_OF_DECLARE(keystone_timer, "ti,keystone-timer",
+					keystone_timer_init);
diff --git a/arch/arm/mach-u300/timer.c b/drivers/clocksource/timer-u300.c
similarity index 99%
rename from arch/arm/mach-u300/timer.c
rename to drivers/clocksource/timer-u300.c
index fe08fd3..e63d469 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/drivers/clocksource/timer-u300.c
@@ -1,8 +1,4 @@
 /*
- *
- * arch/arm/mach-u300/timer.c
- *
- *
  * Copyright (C) 2007-2009 ST-Ericsson AB
  * License terms: GNU General Public License (GPL) version 2
  * Timer COH 901 328, runs the OS timer interrupt.
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..09d05ab 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -140,12 +140,14 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
 	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	if (broadcast &&
+	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
+		return -EBUSY;
+
+
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	if (cpuidle_state_is_coupled(dev, drv, next_state))
 		entered_state = cpuidle_enter_state_coupled(dev, drv,
@@ -153,11 +155,11 @@ int cpuidle_idle_call(void)
 	else
 		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
-
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev, entered_state);
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 9293121..0013142 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -317,6 +317,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	    (clockid != CLOCK_MONOTONIC &&
 	     clockid != CLOCK_REALTIME &&
 	     clockid != CLOCK_REALTIME_ALARM &&
+	     clockid != CLOCK_BOOTTIME &&
 	     clockid != CLOCK_BOOTTIME_ALARM))
 		return -EINVAL;
 
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 493aa02..2e4cb67 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -62,6 +62,11 @@ enum clock_event_mode {
 #define CLOCK_EVT_FEAT_DYNIRQ		0x000020
 #define CLOCK_EVT_FEAT_PERCPU		0x000040
 
+/*
+ * Clockevent device is based on a hrtimer for broadcast
+ */
+#define CLOCK_EVT_FEAT_HRTIMER		0x000080
+
 /**
  * struct clock_event_device - clock event device descriptor
  * @event_handler:	Assigned by the framework to be called by the low
@@ -83,6 +88,7 @@ enum clock_event_mode {
  * @name:		ptr to clock event name
  * @rating:		variable to rate clock event devices
  * @irq:		IRQ number (only for non CPU local devices)
+ * @bound_on:		Bound on CPU
  * @cpumask:		cpumask to indicate for which CPUs this device works
  * @list:		list head for the management code
  * @owner:		module reference
@@ -113,6 +119,7 @@ struct clock_event_device {
 	const char		*name;
 	int			rating;
 	int			irq;
+	int			bound_on;
 	const struct cpumask	*cpumask;
 	struct list_head	list;
 	struct module		*owner;
@@ -180,15 +187,17 @@ extern int tick_receive_broadcast(void);
 #endif
 
 #if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
+extern void tick_setup_hrtimer_broadcast(void);
 extern int tick_check_broadcast_expired(void);
 #else
 static inline int tick_check_broadcast_expired(void) { return 0; }
+static inline void tick_setup_hrtimer_broadcast(void) {};
 #endif
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-extern void clockevents_notify(unsigned long reason, void *arg);
+extern int clockevents_notify(unsigned long reason, void *arg);
 #else
-static inline void clockevents_notify(unsigned long reason, void *arg) {}
+static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
 #endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
@@ -196,8 +205,9 @@ static inline void clockevents_notify(unsigned long reason, void *arg) {}
 static inline void clockevents_suspend(void) {}
 static inline void clockevents_resume(void) {}
 
-static inline void clockevents_notify(unsigned long reason, void *arg) {}
+static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
 static inline int tick_check_broadcast_expired(void) { return 0; }
+static inline void tick_setup_hrtimer_broadcast(void) {};
 
 #endif
 
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d19a5c2..e7a8d3f 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -96,12 +96,12 @@ enum hrtimer_restart {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
+ * @start_pid: timer statistics field to store the pid of the task which
+ *		started the timer
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
  * @start_comm: timer statistics field to store the name of the process which
  *		started the timer
- * @start_pid: timer statistics field to store the pid of the task which
- *		started the timer
  *
  * The hrtimer structure must be initialized by hrtimer_init()
  */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68a0e84..6f6c56f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -291,10 +291,14 @@ extern int runqueue_is_locked(int cpu);
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
 extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
-extern int get_nohz_timer_target(void);
+extern int get_nohz_timer_target(int pinned);
 #else
 static inline void nohz_balance_enter_idle(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
+static inline int get_nohz_timer_target(int pinned)
+{
+	return smp_processor_id();
+}
 #endif
 
 /*
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..abdbe5a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -191,6 +191,7 @@ struct execute_work {
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
+extern void destroy_delayed_work_on_stack(struct delayed_work *work);
 static inline unsigned int work_static(struct work_struct *work)
 {
 	return *work_data_bits(work) & WORK_STRUCT_STATIC;
@@ -198,6 +199,7 @@ static inline unsigned int work_static(struct work_struct *work)
 #else
 static inline void __init_work(struct work_struct *work, int onstack) { }
 static inline void destroy_work_on_stack(struct work_struct *work) { }
+static inline void destroy_delayed_work_on_stack(struct delayed_work *work) { }
 static inline unsigned int work_static(struct work_struct *work) { return 0; }
 #endif
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0909436..d55092c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -168,19 +168,6 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 	}
 }
 
-
-/*
- * Get the preferred target CPU for NOHZ
- */
-static int hrtimer_get_target(int this_cpu, int pinned)
-{
-#ifdef CONFIG_NO_HZ_COMMON
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
-		return get_nohz_timer_target();
-#endif
-	return this_cpu;
-}
-
 /*
  * With HIGHRES=y we do not migrate the timer when it is expiring
  * before the next event on the target cpu because we cannot reprogram
@@ -214,7 +201,7 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
 	int this_cpu = smp_processor_id();
-	int cpu = hrtimer_get_target(this_cpu, pinned);
+	int cpu = get_nohz_timer_target(pinned);
 	int basenum = base->index;
 
 again:
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..c0339e2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -555,12 +555,15 @@ void resched_cpu(int cpu)
  * selecting an idle cpu will add more delays to the timers than intended
  * (as that cpu's timer base may not be uptodate wrt jiffies etc).
  */
-int get_nohz_timer_target(void)
+int get_nohz_timer_target(int pinned)
 {
 	int cpu = smp_processor_id();
 	int i;
 	struct sched_domain *sd;
 
+	if (pinned || !get_sysctl_timer_migration() || !idle_cpu(cpu))
+		return cpu;
+
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		for_each_cpu(i, sched_domain_span(sd)) {
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 3ce6e8c..f448513 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -124,7 +124,7 @@ config NO_HZ_FULL
 endchoice
 
 config NO_HZ_FULL_ALL
-       bool "Full dynticks system on all CPUs by default"
+       bool "Full dynticks system on all CPUs by default (except CPU 0)"
        depends on NO_HZ_FULL
        help
          If the user doesn't pass the nohz_full boot option to
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 9250130..57a413f 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -3,7 +3,10 @@ obj-y += timeconv.o posix-clock.o alarmtimer.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
-obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
+ifeq ($(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST),y)
+ obj-y						+= tick-broadcast.o
+ obj-$(CONFIG_TICK_ONESHOT)			+= tick-broadcast-hrtimer.o
+endif
 obj-$(CONFIG_GENERIC_SCHED_CLOCK)		+= sched_clock.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 086ad60..ad362c2 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -439,6 +439,19 @@ void clockevents_config_and_register(struct clock_event_device *dev,
 }
 EXPORT_SYMBOL_GPL(clockevents_config_and_register);
 
+int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
+{
+	clockevents_config(dev, freq);
+
+	if (dev->mode == CLOCK_EVT_MODE_ONESHOT)
+		return clockevents_program_event(dev, dev->next_event, false);
+
+	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
+		dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
+
+	return 0;
+}
+
 /**
  * clockevents_update_freq - Update frequency and reprogram a clock event device.
  * @dev:	device to modify
@@ -446,17 +459,22 @@ EXPORT_SYMBOL_GPL(clockevents_config_and_register);
  *
  * Reconfigure and reprogram a clock event device in oneshot
  * mode. Must be called on the cpu for which the device delivers per
- * cpu timer events with interrupts disabled!  Returns 0 on success,
- * -ETIME when the event is in the past.
+ * cpu timer events. If called for the broadcast device the core takes
+ * care of serialization.
+ *
+ * Returns 0 on success, -ETIME when the event is in the past.
  */
 int clockevents_update_freq(struct clock_event_device *dev, u32 freq)
 {
-	clockevents_config(dev, freq);
-
-	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
-		return 0;
+	unsigned long flags;
+	int ret;
 
-	return clockevents_program_event(dev, dev->next_event, false);
+	local_irq_save(flags);
+	ret = tick_broadcast_update_freq(dev, freq);
+	if (ret == -ENODEV)
+		ret = __clockevents_update_freq(dev, freq);
+	local_irq_restore(flags);
+	return ret;
 }
 
 /*
@@ -524,12 +542,13 @@ void clockevents_resume(void)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 /**
  * clockevents_notify - notification about relevant events
+ * Returns 0 on success, any other value on error
  */
-void clockevents_notify(unsigned long reason, void *arg)
+int clockevents_notify(unsigned long reason, void *arg)
 {
 	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
-	int cpu;
+	int cpu, ret = 0;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 
@@ -542,7 +561,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 
 	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
 	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
-		tick_broadcast_oneshot_control(reason);
+		ret = tick_broadcast_oneshot_control(reason);
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DYING:
@@ -585,6 +604,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 		break;
 	}
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index af8d1d4..419a52c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -514,12 +514,13 @@ static void sync_cmos_clock(struct work_struct *work)
 		next.tv_sec++;
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
-	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
+	queue_delayed_work(system_power_efficient_wq,
+			   &sync_cmos_work, timespec_to_jiffies(&next));
 }
 
 void ntp_notify_cmos_timer(void)
 {
-	schedule_delayed_work(&sync_cmos_work, 0);
+	queue_delayed_work(system_power_efficient_wq, &sync_cmos_work, 0);
 }
 
 #else
diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
new file mode 100644
index 0000000..eb682d5
--- /dev/null
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -0,0 +1,106 @@
+/*
+ * linux/kernel/time/tick-broadcast-hrtimer.c
+ * This file emulates a local clock event device
+ * via a pseudo clock device.
+ */
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/hrtimer.h>
+#include <linux/interrupt.h>
+#include <linux/percpu.h>
+#include <linux/profile.h>
+#include <linux/clockchips.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+
+#include "tick-internal.h"
+
+static struct hrtimer bctimer;
+
+static void bc_set_mode(enum clock_event_mode mode,
+			struct clock_event_device *bc)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/*
+		 * Note, we cannot cancel the timer here as we might
+		 * run into the following live lock scenario:
+		 *
+		 * cpu 0		cpu1
+		 * lock(broadcast_lock);
+		 *			hrtimer_interrupt()
+		 *			bc_handler()
+		 *			   tick_handle_oneshot_broadcast();
+		 *			    lock(broadcast_lock);
+		 * hrtimer_cancel()
+		 *  wait_for_callback()
+		 */
+		hrtimer_try_to_cancel(&bctimer);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
+ * This is called from the guts of the broadcast code when the cpu
+ * which is about to enter idle has the earliest broadcast timer event.
+ */
+static int bc_set_next(ktime_t expires, struct clock_event_device *bc)
+{
+	/*
+	 * We try to cancel the timer first. If the callback is on
+	 * flight on some other cpu then we let it handle it. If we
+	 * were able to cancel the timer nothing can rearm it as we
+	 * own broadcast_lock.
+	 *
+	 * However we can also be called from the event handler of
+	 * ce_broadcast_hrtimer itself when it expires. We cannot
+	 * restart the timer because we are in the callback, but we
+	 * can set the expiry time and let the callback return
+	 * HRTIMER_RESTART.
+	 */
+	if (hrtimer_try_to_cancel(&bctimer) >= 0) {
+		hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED);
+		/* Bind the "device" to the cpu */
+		bc->bound_on = smp_processor_id();
+	} else if (bc->bound_on == smp_processor_id()) {
+		hrtimer_set_expires(&bctimer, expires);
+	}
+	return 0;
+}
+
+static struct clock_event_device ce_broadcast_hrtimer = {
+	.set_mode		= bc_set_mode,
+	.set_next_ktime		= bc_set_next,
+	.features		= CLOCK_EVT_FEAT_ONESHOT |
+				  CLOCK_EVT_FEAT_KTIME |
+				  CLOCK_EVT_FEAT_HRTIMER,
+	.rating			= 0,
+	.bound_on		= -1,
+	.min_delta_ns		= 1,
+	.max_delta_ns		= KTIME_MAX,
+	.min_delta_ticks	= 1,
+	.max_delta_ticks	= ULONG_MAX,
+	.mult			= 1,
+	.shift			= 0,
+	.cpumask		= cpu_all_mask,
+};
+
+static enum hrtimer_restart bc_handler(struct hrtimer *t)
+{
+	ce_broadcast_hrtimer.event_handler(&ce_broadcast_hrtimer);
+
+	if (ce_broadcast_hrtimer.next_event.tv64 == KTIME_MAX)
+		return HRTIMER_NORESTART;
+
+	return HRTIMER_RESTART;
+}
+
+void tick_setup_hrtimer_broadcast(void)
+{
+	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	bctimer.function = bc_handler;
+	clockevents_register_device(&ce_broadcast_hrtimer);
+}
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 43780ab..63c7b2d 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -120,6 +120,19 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
 	return (dev && tick_broadcast_device.evtdev == dev);
 }
 
+int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq)
+{
+	int ret = -ENODEV;
+
+	if (tick_is_broadcast_device(dev)) {
+		raw_spin_lock(&tick_broadcast_lock);
+		ret = __clockevents_update_freq(dev, freq);
+		raw_spin_unlock(&tick_broadcast_lock);
+	}
+	return ret;
+}
+
+
 static void err_broadcast(const struct cpumask *mask)
 {
 	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
@@ -272,12 +285,8 @@ static void tick_do_broadcast(struct cpumask *mask)
  */
 static void tick_do_periodic_broadcast(void)
 {
-	raw_spin_lock(&tick_broadcast_lock);
-
 	cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
 	tick_do_broadcast(tmpmask);
-
-	raw_spin_unlock(&tick_broadcast_lock);
 }
 
 /*
@@ -287,13 +296,15 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
 	ktime_t next;
 
+	raw_spin_lock(&tick_broadcast_lock);
+
 	tick_do_periodic_broadcast();
 
 	/*
 	 * The device is in periodic mode. No reprogramming necessary:
 	 */
 	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
-		return;
+		goto unlock;
 
 	/*
 	 * Setup the next period for devices, which do not have
@@ -306,9 +317,11 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 		next = ktime_add(next, tick_period);
 
 		if (!clockevents_program_event(dev, next, false))
-			return;
+			goto unlock;
 		tick_do_periodic_broadcast();
 	}
+unlock:
+	raw_spin_unlock(&tick_broadcast_lock);
 }
 
 /*
@@ -630,24 +643,61 @@ again:
 	raw_spin_unlock(&tick_broadcast_lock);
 }
 
+static int broadcast_needs_cpu(struct clock_event_device *bc, int cpu)
+{
+	if (!(bc->features & CLOCK_EVT_FEAT_HRTIMER))
+		return 0;
+	if (bc->next_event.tv64 == KTIME_MAX)
+		return 0;
+	return bc->bound_on == cpu ? -EBUSY : 0;
+}
+
+static void broadcast_shutdown_local(struct clock_event_device *bc,
+				     struct clock_event_device *dev)
+{
+	/*
+	 * For hrtimer based broadcasting we cannot shutdown the cpu
+	 * local device if our own event is the first one to expire or
+	 * if we own the broadcast timer.
+	 */
+	if (bc->features & CLOCK_EVT_FEAT_HRTIMER) {
+		if (broadcast_needs_cpu(bc, smp_processor_id()))
+			return;
+		if (dev->next_event.tv64 < bc->next_event.tv64)
+			return;
+	}
+	clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
+}
+
+static void broadcast_move_bc(int deadcpu)
+{
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+
+	if (!bc || !broadcast_needs_cpu(bc, deadcpu))
+		return;
+	/* This moves the broadcast assignment to this cpu */
+	clockevents_program_event(bc, bc->next_event, 1);
+}
+
 /*
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
+ * Returns 0 on success, -EBUSY if the cpu is used to broadcast wakeups.
  */
-void tick_broadcast_oneshot_control(unsigned long reason)
+int tick_broadcast_oneshot_control(unsigned long reason)
 {
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags;
 	ktime_t now;
-	int cpu;
+	int cpu, ret = 0;
 
 	/*
 	 * Periodic mode does not care about the enter/exit of power
 	 * states
 	 */
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
-		return;
+		return 0;
 
 	/*
 	 * We are called with preemtion disabled from the depth of the
@@ -658,7 +708,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		return;
+		return 0;
 
 	bc = tick_broadcast_device.evtdev;
 
@@ -666,7 +716,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
-			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
+			broadcast_shutdown_local(bc, dev);
 			/*
 			 * We only reprogram the broadcast timer if we
 			 * did not mark ourself in the force mask and
@@ -679,6 +729,16 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 			    dev->next_event.tv64 < bc->next_event.tv64)
 				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
 		}
+		/*
+		 * If the current CPU owns the hrtimer broadcast
+		 * mechanism, it cannot go deep idle and we remove the
+		 * CPU from the broadcast mask. We don't have to go
+		 * through the EXIT path as the local timer is not
+		 * shutdown.
+		 */
+		ret = broadcast_needs_cpu(bc, cpu);
+		if (ret)
+			cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
@@ -746,6 +806,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	}
 out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	return ret;
 }
 
 /*
@@ -851,6 +912,8 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
 	cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
 
+	broadcast_move_bc(cpu);
+
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 20b2fe3..0156612 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -98,18 +98,19 @@ static void tick_periodic(int cpu)
 void tick_handle_periodic(struct clock_event_device *dev)
 {
 	int cpu = smp_processor_id();
-	ktime_t next;
+	ktime_t next = dev->next_event;
 
 	tick_periodic(cpu);
 
 	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
 		return;
-	/*
-	 * Setup the next period for devices, which do not have
-	 * periodic mode:
-	 */
-	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
+		/*
+		 * Setup the next period for devices, which do not have
+		 * periodic mode:
+		 */
+		next = ktime_add(next, tick_period);
+
 		if (!clockevents_program_event(dev, next, false))
 			return;
 		/*
@@ -118,12 +119,11 @@ void tick_handle_periodic(struct clock_event_device *dev)
 		 * to be sure we're using a real hardware clocksource.
 		 * Otherwise we could get trapped in an infinite
 		 * loop, as the tick_periodic() increments jiffies,
-		 * when then will increment time, posibly causing
+		 * which then will increment time, possibly causing
 		 * the loop to trigger again and again.
 		 */
 		if (timekeeping_valid_for_hres())
 			tick_periodic(cpu);
-		next = ktime_add(next, tick_period);
 	}
 }
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 8329669..7ab92b1 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -46,7 +46,7 @@ extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
 extern void tick_resume_oneshot(void);
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
-extern void tick_broadcast_oneshot_control(unsigned long reason);
+extern int tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
@@ -58,7 +58,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
@@ -87,7 +87,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
@@ -111,6 +111,7 @@ extern int tick_resume_broadcast(void);
 extern void tick_broadcast_init(void);
 extern void
 tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
+int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq);
 
 #else /* !BROADCAST */
 
@@ -133,6 +134,8 @@ static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
 static inline void tick_suspend_broadcast(void) { }
 static inline int tick_resume_broadcast(void) { return 0; }
 static inline void tick_broadcast_init(void) { }
+static inline int tick_broadcast_update_freq(struct clock_event_device *dev,
+					     u32 freq) { return -ENODEV; }
 
 /*
  * Set the periodic handler in non broadcast mode
@@ -152,6 +155,8 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 	return !(dev->features & CLOCK_EVT_FEAT_DUMMY);
 }
 
+int __clockevents_update_freq(struct clock_event_device *dev, u32 freq);
+
 #endif
 
 extern void do_timer(unsigned long ticks);
diff --git a/kernel/time/timekeeping_debug.c b/kernel/time/timekeeping_debug.c
index 802433a..4d54f97 100644
--- a/kernel/time/timekeeping_debug.c
+++ b/kernel/time/timekeeping_debug.c
@@ -21,6 +21,8 @@
 #include <linux/seq_file.h>
 #include <linux/time.h>
 
+#include "timekeeping_internal.h"
+
 static unsigned int sleep_time_bin[32] = {0};
 
 static int tk_debug_show_sleep_time(struct seq_file *s, void *data)
diff --git a/kernel/timer.c b/kernel/timer.c
index accfd24..1d35dda 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -81,6 +81,7 @@ struct tvec_base {
 	unsigned long timer_jiffies;
 	unsigned long next_timer;
 	unsigned long active_timers;
+	unsigned long all_timers;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -337,6 +338,20 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
 }
 EXPORT_SYMBOL_GPL(set_timer_slack);
 
+/*
+ * If the list is empty, catch up ->timer_jiffies to the current time.
+ * The caller must hold the tvec_base lock.  Returns true if the list
+ * was empty and therefore ->timer_jiffies was updated.
+ */
+static bool catchup_timer_jiffies(struct tvec_base *base)
+{
+	if (!base->all_timers) {
+		base->timer_jiffies = jiffies;
+		return true;
+	}
+	return false;
+}
+
 static void
 __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
@@ -383,15 +398,17 @@ __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 
 static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
+	(void)catchup_timer_jiffies(base);
 	__internal_add_timer(base, timer);
 	/*
 	 * Update base->active_timers and base->next_timer
 	 */
 	if (!tbase_get_deferrable(timer->base)) {
-		if (time_before(timer->expires, base->next_timer))
+		if (!base->active_timers++ ||
+		    time_before(timer->expires, base->next_timer))
 			base->next_timer = timer->expires;
-		base->active_timers++;
 	}
+	base->all_timers++;
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -671,6 +688,8 @@ detach_expired_timer(struct timer_list *timer, struct tvec_base *base)
 	detach_timer(timer, true);
 	if (!tbase_get_deferrable(timer->base))
 		base->active_timers--;
+	base->all_timers--;
+	(void)catchup_timer_jiffies(base);
 }
 
 static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
@@ -685,6 +704,8 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
 		if (timer->expires == base->next_timer)
 			base->next_timer = base->timer_jiffies;
 	}
+	base->all_timers--;
+	(void)catchup_timer_jiffies(base);
 	return 1;
 }
 
@@ -739,12 +760,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = smp_processor_id();
-
-#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
-		cpu = get_nohz_timer_target();
-#endif
+	cpu = get_nohz_timer_target(pinned);
 	new_base = per_cpu(tvec_bases, cpu);
 
 	if (base != new_base) {
@@ -939,8 +955,15 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	 * with the timer by holding the timer base lock. This also
 	 * makes sure that a CPU on the way to stop its tick can not
 	 * evaluate the timer wheel.
+	 *
+	 * Spare the IPI for deferrable timers on idle targets though.
+	 * The next busy ticks will take care of it. Except full dynticks
+	 * require special care against races with idle_cpu(), lets deal
+	 * with that later.
 	 */
-	wake_up_nohz_cpu(cpu);
+	if (!tbase_get_deferrable(timer->base) || tick_nohz_full_cpu(cpu))
+		wake_up_nohz_cpu(cpu);
+
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
@@ -1146,6 +1169,10 @@ static inline void __run_timers(struct tvec_base *base)
 	struct timer_list *timer;
 
 	spin_lock_irq(&base->lock);
+	if (catchup_timer_jiffies(base)) {
+		spin_unlock_irq(&base->lock);
+		return;
+	}
 	while (time_after_eq(jiffies, base->timer_jiffies)) {
 		struct list_head work_list;
 		struct list_head *head = &work_list;
@@ -1160,7 +1187,7 @@ static inline void __run_timers(struct tvec_base *base)
 					!cascade(base, &base->tv4, INDEX(2)))
 			cascade(base, &base->tv5, INDEX(3));
 		++base->timer_jiffies;
-		list_replace_init(base->tv1.vec + index, &work_list);
+		list_replace_init(base->tv1.vec + index, head);
 		while (!list_empty(head)) {
 			void (*fn)(unsigned long);
 			unsigned long data;
@@ -1523,9 +1550,8 @@ static int init_timers_cpu(int cpu)
 			if (!base)
 				return -ENOMEM;
 
-			/* Make sure that tvec_base is 2 byte aligned */
-			if (tbase_get_deferrable(base)) {
-				WARN_ON(1);
+			/* Make sure tvec_base has TIMER_FLAG_MASK bits free */
+			if (WARN_ON(base != tbase_get_base(base))) {
 				kfree(base);
 				return -ENOMEM;
 			}
@@ -1559,6 +1585,7 @@ static int init_timers_cpu(int cpu)
 	base->timer_jiffies = jiffies;
 	base->next_timer = base->timer_jiffies;
 	base->active_timers = 0;
+	base->all_timers = 0;
 	return 0;
 }
 
@@ -1648,9 +1675,9 @@ void __init init_timers(void)
 
 	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
 			       (void *)(long)smp_processor_id());
-	init_timer_stats();
-
 	BUG_ON(err != NOTIFY_OK);
+
+	init_timer_stats();
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..5b690b5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -516,6 +516,13 @@ void destroy_work_on_stack(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(destroy_work_on_stack);
 
+void destroy_delayed_work_on_stack(struct delayed_work *work)
+{
+	destroy_timer_on_stack(&work->timer);
+	debug_object_free(&work->work, &work_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_delayed_work_on_stack);
+
 #else
 static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }
