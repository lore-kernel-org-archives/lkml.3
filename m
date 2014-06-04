Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaFDSqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:46:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:40710 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFDSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:46:40 -0400
Date: Wed, 4 Jun 2014 20:46:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer changes for 3.16
Message-ID: <alpine.DEB.2.10.1406042039490.18296@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1631510505-1401907596=:18296"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1631510505-1401907596=:18296
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

This time you get nothing really exciting:
   - A huge update to the sh* clocksource drivers
   - Support for two more ARM SoCs
   - Removal of the deprecated setup_sched_clock() API
   - The usual pile of fixlets all over the place


Thanks,

	tglx

------------------>
Fabian Frederick (1):
      ntp: Convert simple_strtol to kstrtol

George Spelvin (1):
      ntp: Make is_error_status() use its argument

Jingoo Han (4):
      clocksource: em_sti: Remove unnecessary OOM messages
      clocksource: sh_cmt: Remove unnecessary OOM messages
      clocksource: sh_mtu2: Remove unnecessary OOM messages
      clocksource: sh_tmu: Remove unnecessary OOM messages

Laurent Pinchart (53):
      clocksource: sh_cmt: Use request_irq() instead of setup_irq()
      clocksource: sh_cmt: Split channel fields from sh_cmt_priv
      clocksource: sh_cmt: Rename struct sh_cmt_priv to sh_cmt_device
      clocksource: sh_cmt: Split channel setup to separate function
      clocksource: sh_cmt: Constify name argument to sh_cmt_register()
      clocksource: sh_cmt: Rename mapbase/mapbase_str to mapbase_ch/mapbase
      clocksource: sh_cmt: Add memory base to sh_cmt_channel structure
      clocksource: sh_cmt: Add index to struct sh_cmt_channel
      clocksource: sh_cmt: Replace kmalloc + memset with kzalloc
      clocksource: sh_cmt: Allocate channels dynamically
      clocksource: sh_cmt: Split static information from sh_cmt_device
      clocksource: sh_cmt: Replace hardcoded register values with macros
      clocksource: sh_cmt: Set cpumask to cpu_possible_mask
      clocksource: sh_cmt: Hardcode CMT clock event rating to 125
      clocksource: sh_cmt: Hardcode CMT clock source rating to 125
      clocksource: sh_cmt: Add support for multiple channels per device
      clocksource: sh_cmt: Rename clock to "fck" in the non-legacy case
      clocksource: sh_cmt: Remove FSF mail address from GPL notice
      clocksource: sh_cmt: Sort headers alphabetically
      clocksource: sh_cmt: Request IRQ for clock event device only
      clocksource: sh_tmu: Use request_irq() instead of setup_irq()
      clocksource: sh_tmu: Split channel fields from sh_tmu_priv
      clocksource: sh_tmu: Rename struct sh_tmu_priv to sh_tmu_device
      clocksource: sh_tmu: Split channel setup to separate function
      clocksource: sh_tmu: Constify name argument to sh_tmu_register()
      clocksource: sh_tmu: Add memory base to sh_tmu_channel structure
      clocksource: sh_tmu: Add index to struct sh_tmu_channel
      clocksource: sh_tmu: Replace kmalloc + memset with kzalloc
      clocksource: sh_tmu: Allocate channels dynamically
      clocksource: sh_tmu: Replace hardcoded register values with macros
      clocksource: sh_tmu: Hardcode TMU clock event and source ratings to 200
      clocksource: sh_tmu: Add support for multiple channels per device
      clocksource: sh_tmu: Rename clock to "fck" in the non-legacy case
      clocksource: sh_tmu: Remove FSF mail address from GPL notice
      clocksource: sh_tmu: Sort headers alphabetically
      clocksource: sh_mtu2: Use request_irq() instead of setup_irq()
      clocksource: sh_mtu2: Turn sh_mtu2_priv fields into local variables
      clocksource: sh_mtu2: Split channel fields from sh_mtu2_priv
      clocksource: sh_mtu2: Rename struct sh_mtu2_priv to sh_mtu2_device
      clocksource: sh_mtu2: Split channel setup to separate function
      clocksource: sh_mtu2: Constify name argument to sh_mtu2_register()
      clocksource: sh_mtu2: Add memory base to sh_mtu2_channel structure
      clocksource: sh_mtu2: Add index to struct sh_mtu2_channel
      clocksource: sh_mtu2: Replace kmalloc + memset with kzalloc
      clocksource: sh_mtu2: Allocate channels dynamically
      clocksource: sh_mtu2: Replace hardcoded register values with macros
      clocksource: sh_mtu2: Set cpumask to cpu_possible_mask
      clocksource: sh_mtu2: Hardcode MTU2 clock event rating to 200
      clocksource: sh_mtu2: Add support for multiple channels per device
      clocksource: sh_mtu2: Rename clock to "fck" in the non-legacy case
      clocksource: sh_mtu2: Remove FSF mail address from GPL notice
      clocksource: sh_mtu2: Sort headers alphabetically
      clocksource: sh_tmu: Fix channel IRQ retrieval in legacy case

Matthew Leach (4):
      clocksource: arm_global_timer: Only check for unusable timer on A9
      documentaion: DT: allow a A5 compatible string in global timer
      dts: ca5: add the global timer for the A5
      KConfig: Vexpress: build the ARM_GLOBAL_TIMER with vexpress platform

Maxime Ripard (2):
      clocksource: sun5i: Add support for reset controller
      ARM: sun6i: a31: Add support for the High Speed Timers

Michael Kerrisk (1):
      timer_stats/doc: Fix /proc/timer_stats documentation

Stephen Boyd (2):
      sched_clock: Remove deprecated setup_sched_clock() API
      clocksource: qcom: Implement read_current_timer for udelay

Uwe Kleine-König (1):
      clocksource: efm32: use $vendor,$device scheme for compatible string

Xiubo Li (5):
      clocksource: Fix type confusion for clocksource_mmio_readX_Y
      clocksource: Fix clocksource_mmio_readX_down
      clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree Documentation
      ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
      clocksource: Add Freescale FlexTimer Module (FTM) timer support

Yang Wei (1):
      clocksource: dw_apb_timer_of: Do not trace read_sched_clock


 .../devicetree/bindings/arm/global_timer.txt       |   7 +-
 .../bindings/timer/allwinner,sun5i-a13-hstimer.txt |   4 +
 ...efm32,timer.txt => energymicro,efm32-timer.txt} |   4 +-
 .../devicetree/bindings/timer/fsl,ftm-timer.txt    |  31 +
 Documentation/timers/timer_stats.txt               |   6 +-
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  11 +
 arch/arm/boot/dts/vexpress-v2p-ca5s.dts            |  10 +-
 arch/arm/boot/dts/vf610.dtsi                       |  13 +
 arch/arm/mach-vexpress/Kconfig                     |   1 +
 drivers/clocksource/Kconfig                        |   5 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/arm_global_timer.c             |   5 +-
 drivers/clocksource/dw_apb_timer_of.c              |   2 +-
 drivers/clocksource/em_sti.c                       |   4 +-
 drivers/clocksource/fsl_ftm_timer.c                | 367 ++++++++
 drivers/clocksource/mmio.c                         |   8 +-
 drivers/clocksource/qcom-timer.c                   |  13 +
 drivers/clocksource/sh_cmt.c                       | 958 ++++++++++++++-------
 drivers/clocksource/sh_mtu2.c                      | 490 +++++++----
 drivers/clocksource/sh_tmu.c                       | 543 +++++++-----
 drivers/clocksource/time-efm32.c                   |   3 +-
 drivers/clocksource/timer-sun5i.c                  |   6 +
 include/linux/sched_clock.h                        |   1 -
 include/linux/sh_timer.h                           |   1 +
 kernel/time/ntp.c                                  |  17 +-
 kernel/time/sched_clock.c                          |  13 -
 26 files changed, 1798 insertions(+), 726 deletions(-)
 rename Documentation/devicetree/bindings/timer/{efm32,timer.txt => energymicro,efm32-timer.txt} (87%)
 create mode 100644 Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
 create mode 100644 drivers/clocksource/fsl_ftm_timer.c

diff --git a/Documentation/devicetree/bindings/arm/global_timer.txt b/Documentation/devicetree/bindings/arm/global_timer.txt
index 1e54898..bdae3a8 100644
--- a/Documentation/devicetree/bindings/arm/global_timer.txt
+++ b/Documentation/devicetree/bindings/arm/global_timer.txt
@@ -4,8 +4,11 @@
 
 ** Timer node required properties:
 
-- compatible : Should be "arm,cortex-a9-global-timer"
-		Driver supports versions r2p0 and above.
+- compatible : should contain
+	     * "arm,cortex-a5-global-timer" for Cortex-A5 global timers.
+	     * "arm,cortex-a9-global-timer" for Cortex-A9 global
+	         timers or any compatible implementation. Note: driver
+	         supports versions r2p0 and above.
 
 - interrupts : One interrupt to each core
 
diff --git a/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
index 7c26154..27cfc7d 100644
--- a/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
+++ b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
@@ -9,6 +9,9 @@ Required properties:
 		one)
 - clocks: phandle to the source clock (usually the AHB clock)
 
+Optionnal properties:
+- resets: phandle to a reset controller asserting the timer
+
 Example:
 
 timer@01c60000 {
@@ -19,4 +22,5 @@ timer@01c60000 {
 		     <0 53 1>,
 		     <0 54 1>;
 	clocks = <&ahb1_gates 19>;
+	resets = <&ahb1rst 19>;
 };
diff --git a/Documentation/devicetree/bindings/timer/efm32,timer.txt b/Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
similarity index 87%
rename from Documentation/devicetree/bindings/timer/efm32,timer.txt
rename to Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
index 97a568f..e502c11 100644
--- a/Documentation/devicetree/bindings/timer/efm32,timer.txt
+++ b/Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
@@ -6,7 +6,7 @@ channels and can be used as PWM or Quadrature Decoder. Available clock sources
 are the cpu's HFPERCLK (with a 10-bit prescaler) or an external pin.
 
 Required properties:
-- compatible : Should be efm32,timer
+- compatible : Should be "energymicro,efm32-timer"
 - reg : Address and length of the register set
 - clocks : Should contain a reference to the HFPERCLK
 
@@ -16,7 +16,7 @@ Optional properties:
 Example:
 
 timer@40010c00 {
-	compatible = "efm32,timer";
+	compatible = "energymicro,efm32-timer";
 	reg = <0x40010c00 0x400>;
 	interrupts = <14>;
 	clocks = <&cmu clk_HFPERCLKTIMER3>;
diff --git a/Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt b/Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
new file mode 100644
index 0000000..aa8c402
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
@@ -0,0 +1,31 @@
+Freescale FlexTimer Module (FTM) Timer
+
+Required properties:
+
+- compatible : should be "fsl,ftm-timer"
+- reg : Specifies base physical address and size of the register sets for the
+  clock event device and clock source device.
+- interrupts : Should be the clock event device interrupt.
+- clocks : The clocks provided by the SoC to drive the timer, must contain an
+  entry for each entry in clock-names.
+- clock-names : Must include the following entries:
+  o "ftm-evt"
+  o "ftm-src"
+  o "ftm-evt-counter-en"
+  o "ftm-src-counter-en"
+- big-endian: One boolean property, the big endian mode will be in use if it is
+  present, or the little endian mode will be in use for all the device registers.
+
+Example:
+ftm: ftm@400b8000 {
+	compatible = "fsl,ftm-timer";
+	reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+	interrupts = <0 44 IRQ_TYPE_LEVEL_HIGH>;
+	clock-names = "ftm-evt", "ftm-src",
+		"ftm-evt-counter-en", "ftm-src-counter-en";
+	clocks = <&clks VF610_CLK_FTM2>,
+		<&clks VF610_CLK_FTM3>,
+		<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
+		<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
+	big-endian;
+};
diff --git a/Documentation/timers/timer_stats.txt b/Documentation/timers/timer_stats.txt
index 8abd40b..de835ee 100644
--- a/Documentation/timers/timer_stats.txt
+++ b/Documentation/timers/timer_stats.txt
@@ -39,9 +39,9 @@ To stop a sample period issue:
 The statistics can be retrieved by:
 # cat /proc/timer_stats
 
-The readout of /proc/timer_stats automatically disables sampling. The sampled
-information is kept until a new sample period is started. This allows multiple
-readouts.
+While sampling is enabled, each readout from /proc/timer_stats will see
+newly updated statistics. Once sampling is disabled, the sampled information
+is kept until a new sample period is started. This allows multiple readouts.
 
 Sample output of /proc/timer_stats:
 
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index d45efa7..8cee8a1 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -428,6 +428,17 @@
 			status = "disabled";
 		};
 
+		timer@01c60000 {
+			compatible = "allwinner,sun6i-a31-hstimer", "allwinner,sun7i-a20-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <0 51 4>,
+				     <0 52 4>,
+				     <0 53 4>,
+				     <0 54 4>;
+			clocks = <&ahb1_gates 19>;
+			resets = <&ahb1_rst 19>;
+		};
+
 		spi0: spi@01c68000 {
 			compatible = "allwinner,sun6i-a31-spi";
 			reg = <0x01c68000 0x1000>;
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca5s.dts b/arch/arm/boot/dts/vexpress-v2p-ca5s.dts
index c544a55..d2709b7 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca5s.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca5s.dts
@@ -88,6 +88,14 @@
 		interrupts = <1 13 0x304>;
 	};
 
+	timer@2c000200 {
+		compatible = "arm,cortex-a5-global-timer",
+		             "arm,cortex-a9-global-timer";
+		reg = <0x2c000200 0x20>;
+		interrupts = <1 11 0x304>;
+		clocks = <&oscclk0>;
+	};
+
 	watchdog@2c000620 {
 		compatible = "arm,cortex-a5-twd-wdt";
 		reg = <0x2c000620 0x20>;
@@ -120,7 +128,7 @@
 		compatible = "arm,vexpress,config-bus";
 		arm,vexpress,config-bridge = <&v2m_sysreg>;
 
-		osc@0 {
+		oscclk0: osc@0 {
 			/* CPU and internal AXI reference clock */
 			compatible = "arm,vexpress-osc";
 			arm,vexpress-sysreg,func = <1 0>;
diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index b8ce0aa7..3c91b84 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -347,6 +347,19 @@
 				status = "disabled";
 			};
 
+			ftm: ftm@400b8000 {
+				compatible = "fsl,ftm-timer";
+				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				interrupts = <0 44 IRQ_TYPE_LEVEL_HIGH>;
+				clock-names = "ftm-evt", "ftm-src",
+					"ftm-evt-counter-en", "ftm-src-counter-en";
+				clocks = <&clks VF610_CLK_FTM2>,
+					<&clks VF610_CLK_FTM3>,
+					<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
+					<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
+				status = "disabled";
+			};
+
 			fec0: ethernet@400d0000 {
 				compatible = "fsl,mvf600-fec";
 				reg = <0x400d0000 0x1000>;
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 657d52d..e9811a0 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -4,6 +4,7 @@ config ARCH_VEXPRESS
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
+	select ARM_GLOBAL_TIMER
 	select ARM_TIMER_SP804
 	select COMMON_CLK_VERSATILE
 	select HAVE_ARM_SCU if SMP
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 96918e1..0437767 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -136,6 +136,11 @@ config CLKSRC_SAMSUNG_PWM
 	  for all devicetree enabled platforms. This driver will be
 	  needed only on systems that do not have the Exynos MCT available.
 
+config FSL_FTM_TIMER
+	bool
+	help
+	  Support for Freescale FlexTimer Module (FTM) timer.
+
 config VF_PIT_TIMER
 	bool
 	help
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 98cb6c5..0770916 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
 obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
+obj-$(CONFIG_FSL_FTM_TIMER)	+= fsl_ftm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
 obj-$(CONFIG_CLKSRC_QCOM)	+= qcom-timer.o
 
diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index 0fc31d0..60e5a170 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -246,11 +246,12 @@ static void __init global_timer_of_register(struct device_node *np)
 	int err = 0;
 
 	/*
-	 * In r2p0 the comparators for each processor with the global timer
+	 * In A9 r2p0 the comparators for each processor with the global timer
 	 * fire when the timer value is greater than or equal to. In previous
 	 * revisions the comparators fired when the timer value was equal to.
 	 */
-	if ((read_cpuid_id() & 0xf0000f) < 0x200000) {
+	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9
+	    && (read_cpuid_id() & 0xf0000f) < 0x200000) {
 		pr_warn("global-timer: non support for this cpu version.\n");
 		return;
 	}
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 2a2ea27..d305fb0 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -106,7 +106,7 @@ static void __init add_clocksource(struct device_node *source_timer)
 	sched_rate = rate;
 }
 
-static u64 read_sched_clock(void)
+static u64 notrace read_sched_clock(void)
 {
 	return ~__raw_readl(sched_io_base);
 }
diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 9d17083..d0a7bd6 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -318,10 +318,8 @@ static int em_sti_probe(struct platform_device *pdev)
 	int irq;
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (p == NULL)
 		return -ENOMEM;
-	}
 
 	p->pdev = pdev;
 	platform_set_drvdata(pdev, p);
diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
new file mode 100644
index 0000000..454227d
--- /dev/null
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -0,0 +1,367 @@
+/*
+ * Freescale FlexTimer Module (FTM) timer driver.
+ *
+ * Copyright 2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/sched_clock.h>
+#include <linux/slab.h>
+
+#define FTM_SC		0x00
+#define FTM_SC_CLK_SHIFT	3
+#define FTM_SC_CLK_MASK	(0x3 << FTM_SC_CLK_SHIFT)
+#define FTM_SC_CLK(c)	((c) << FTM_SC_CLK_SHIFT)
+#define FTM_SC_PS_MASK	0x7
+#define FTM_SC_TOIE	BIT(6)
+#define FTM_SC_TOF	BIT(7)
+
+#define FTM_CNT		0x04
+#define FTM_MOD		0x08
+#define FTM_CNTIN	0x4C
+
+#define FTM_PS_MAX	7
+
+struct ftm_clock_device {
+	void __iomem *clksrc_base;
+	void __iomem *clkevt_base;
+	unsigned long periodic_cyc;
+	unsigned long ps;
+	bool big_endian;
+};
+
+static struct ftm_clock_device *priv;
+
+static inline u32 ftm_readl(void __iomem *addr)
+{
+	if (priv->big_endian)
+		return ioread32be(addr);
+	else
+		return ioread32(addr);
+}
+
+static inline void ftm_writel(u32 val, void __iomem *addr)
+{
+	if (priv->big_endian)
+		iowrite32be(val, addr);
+	else
+		iowrite32(val, addr);
+}
+
+static inline void ftm_counter_enable(void __iomem *base)
+{
+	u32 val;
+
+	/* select and enable counter clock source */
+	val = ftm_readl(base + FTM_SC);
+	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
+	val |= priv->ps | FTM_SC_CLK(1);
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_counter_disable(void __iomem *base)
+{
+	u32 val;
+
+	/* disable counter clock source */
+	val = ftm_readl(base + FTM_SC);
+	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_irq_acknowledge(void __iomem *base)
+{
+	u32 val;
+
+	val = ftm_readl(base + FTM_SC);
+	val &= ~FTM_SC_TOF;
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_irq_enable(void __iomem *base)
+{
+	u32 val;
+
+	val = ftm_readl(base + FTM_SC);
+	val |= FTM_SC_TOIE;
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_irq_disable(void __iomem *base)
+{
+	u32 val;
+
+	val = ftm_readl(base + FTM_SC);
+	val &= ~FTM_SC_TOIE;
+	ftm_writel(val, base + FTM_SC);
+}
+
+static inline void ftm_reset_counter(void __iomem *base)
+{
+	/*
+	 * The CNT register contains the FTM counter value.
+	 * Reset clears the CNT register. Writing any value to COUNT
+	 * updates the counter with its initial value, CNTIN.
+	 */
+	ftm_writel(0x00, base + FTM_CNT);
+}
+
+static u64 ftm_read_sched_clock(void)
+{
+	return ftm_readl(priv->clksrc_base + FTM_CNT);
+}
+
+static int ftm_set_next_event(unsigned long delta,
+				struct clock_event_device *unused)
+{
+	/*
+	 * The CNNIN and MOD are all double buffer registers, writing
+	 * to the MOD register latches the value into a buffer. The MOD
+	 * register is updated with the value of its write buffer with
+	 * the following scenario:
+	 * a, the counter source clock is diabled.
+	 */
+	ftm_counter_disable(priv->clkevt_base);
+
+	/* Force the value of CNTIN to be loaded into the FTM counter */
+	ftm_reset_counter(priv->clkevt_base);
+
+	/*
+	 * The counter increments until the value of MOD is reached,
+	 * at which point the counter is reloaded with the value of CNTIN.
+	 * The TOF (the overflow flag) bit is set when the FTM counter
+	 * changes from MOD to CNTIN. So we should using the delta - 1.
+	 */
+	ftm_writel(delta - 1, priv->clkevt_base + FTM_MOD);
+
+	ftm_counter_enable(priv->clkevt_base);
+
+	ftm_irq_enable(priv->clkevt_base);
+
+	return 0;
+}
+
+static void ftm_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		ftm_set_next_event(priv->periodic_cyc, evt);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		ftm_counter_disable(priv->clkevt_base);
+		break;
+	default:
+		return;
+	}
+}
+
+static irqreturn_t ftm_evt_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	ftm_irq_acknowledge(priv->clkevt_base);
+
+	if (likely(evt->mode == CLOCK_EVT_MODE_ONESHOT)) {
+		ftm_irq_disable(priv->clkevt_base);
+		ftm_counter_disable(priv->clkevt_base);
+	}
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct clock_event_device ftm_clockevent = {
+	.name		= "Freescale ftm timer",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= ftm_set_mode,
+	.set_next_event	= ftm_set_next_event,
+	.rating		= 300,
+};
+
+static struct irqaction ftm_timer_irq = {
+	.name		= "Freescale ftm timer",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= ftm_evt_interrupt,
+	.dev_id		= &ftm_clockevent,
+};
+
+static int __init ftm_clockevent_init(unsigned long freq, int irq)
+{
+	int err;
+
+	ftm_writel(0x00, priv->clkevt_base + FTM_CNTIN);
+	ftm_writel(~0UL, priv->clkevt_base + FTM_MOD);
+
+	ftm_reset_counter(priv->clkevt_base);
+
+	err = setup_irq(irq, &ftm_timer_irq);
+	if (err) {
+		pr_err("ftm: setup irq failed: %d\n", err);
+		return err;
+	}
+
+	ftm_clockevent.cpumask = cpumask_of(0);
+	ftm_clockevent.irq = irq;
+
+	clockevents_config_and_register(&ftm_clockevent,
+					freq / (1 << priv->ps),
+					1, 0xffff);
+
+	ftm_counter_enable(priv->clkevt_base);
+
+	return 0;
+}
+
+static int __init ftm_clocksource_init(unsigned long freq)
+{
+	int err;
+
+	ftm_writel(0x00, priv->clksrc_base + FTM_CNTIN);
+	ftm_writel(~0UL, priv->clksrc_base + FTM_MOD);
+
+	ftm_reset_counter(priv->clksrc_base);
+
+	sched_clock_register(ftm_read_sched_clock, 16, freq / (1 << priv->ps));
+	err = clocksource_mmio_init(priv->clksrc_base + FTM_CNT, "fsl-ftm",
+				    freq / (1 << priv->ps), 300, 16,
+				    clocksource_mmio_readl_up);
+	if (err) {
+		pr_err("ftm: init clock source mmio failed: %d\n", err);
+		return err;
+	}
+
+	ftm_counter_enable(priv->clksrc_base);
+
+	return 0;
+}
+
+static int __init __ftm_clk_init(struct device_node *np, char *cnt_name,
+				 char *ftm_name)
+{
+	struct clk *clk;
+	int err;
+
+	clk = of_clk_get_by_name(np, cnt_name);
+	if (IS_ERR(clk)) {
+		pr_err("ftm: Cannot get \"%s\": %ld\n", cnt_name, PTR_ERR(clk));
+		return PTR_ERR(clk);
+	}
+	err = clk_prepare_enable(clk);
+	if (err) {
+		pr_err("ftm: clock failed to prepare+enable \"%s\": %d\n",
+			cnt_name, err);
+		return err;
+	}
+
+	clk = of_clk_get_by_name(np, ftm_name);
+	if (IS_ERR(clk)) {
+		pr_err("ftm: Cannot get \"%s\": %ld\n", ftm_name, PTR_ERR(clk));
+		return PTR_ERR(clk);
+	}
+	err = clk_prepare_enable(clk);
+	if (err)
+		pr_err("ftm: clock failed to prepare+enable \"%s\": %d\n",
+			ftm_name, err);
+
+	return clk_get_rate(clk);
+}
+
+static unsigned long __init ftm_clk_init(struct device_node *np)
+{
+	unsigned long freq;
+
+	freq = __ftm_clk_init(np, "ftm-evt-counter-en", "ftm-evt");
+	if (freq <= 0)
+		return 0;
+
+	freq = __ftm_clk_init(np, "ftm-src-counter-en", "ftm-src");
+	if (freq <= 0)
+		return 0;
+
+	return freq;
+}
+
+static int __init ftm_calc_closest_round_cyc(unsigned long freq)
+{
+	priv->ps = 0;
+
+	/* The counter register is only using the lower 16 bits, and
+	 * if the 'freq' value is to big here, then the periodic_cyc
+	 * may exceed 0xFFFF.
+	 */
+	do {
+		priv->periodic_cyc = DIV_ROUND_CLOSEST(freq,
+						HZ * (1 << priv->ps++));
+	} while (priv->periodic_cyc > 0xFFFF);
+
+	if (priv->ps > FTM_PS_MAX) {
+		pr_err("ftm: the prescaler is %lu > %d\n",
+				priv->ps, FTM_PS_MAX);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void __init ftm_timer_init(struct device_node *np)
+{
+	unsigned long freq;
+	int irq;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return;
+
+	priv->clkevt_base = of_iomap(np, 0);
+	if (!priv->clkevt_base) {
+		pr_err("ftm: unable to map event timer registers\n");
+		goto err;
+	}
+
+	priv->clksrc_base = of_iomap(np, 1);
+	if (!priv->clksrc_base) {
+		pr_err("ftm: unable to map source timer registers\n");
+		goto err;
+	}
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("ftm: unable to get IRQ from DT, %d\n", irq);
+		goto err;
+	}
+
+	priv->big_endian = of_property_read_bool(np, "big-endian");
+
+	freq = ftm_clk_init(np);
+	if (!freq)
+		goto err;
+
+	if (ftm_calc_closest_round_cyc(freq))
+		goto err;
+
+	if (ftm_clocksource_init(freq))
+		goto err;
+
+	if (ftm_clockevent_init(freq, irq))
+		goto err;
+
+	return;
+
+err:
+	kfree(priv);
+}
+CLOCKSOURCE_OF_DECLARE(flextimer, "fsl,ftm-timer", ftm_timer_init);
diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index c0e2512..1593ade 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -22,22 +22,22 @@ static inline struct clocksource_mmio *to_mmio_clksrc(struct clocksource *c)
 
 cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 {
-	return readl_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
-	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 {
-	return readw_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
-	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 /**
diff --git a/drivers/clocksource/qcom-timer.c b/drivers/clocksource/qcom-timer.c
index e807acf..8d115db 100644
--- a/drivers/clocksource/qcom-timer.c
+++ b/drivers/clocksource/qcom-timer.c
@@ -26,6 +26,8 @@
 #include <linux/of_irq.h>
 #include <linux/sched_clock.h>
 
+#include <asm/delay.h>
+
 #define TIMER_MATCH_VAL			0x0000
 #define TIMER_COUNT_VAL			0x0004
 #define TIMER_ENABLE			0x0008
@@ -179,6 +181,15 @@ static u64 notrace msm_sched_clock_read(void)
 	return msm_clocksource.read(&msm_clocksource);
 }
 
+static unsigned long msm_read_current_timer(void)
+{
+	return msm_clocksource.read(&msm_clocksource);
+}
+
+static struct delay_timer msm_delay_timer = {
+	.read_current_timer = msm_read_current_timer,
+};
+
 static void __init msm_timer_init(u32 dgt_hz, int sched_bits, int irq,
 				  bool percpu)
 {
@@ -217,6 +228,8 @@ err:
 	if (res)
 		pr_err("clocksource_register failed\n");
 	sched_clock_register(msm_sched_clock_read, sched_bits, dgt_hz);
+	msm_delay_timer.freq = dgt_hz;
+	register_current_timer_delay(&msm_delay_timer);
 }
 
 #ifdef CONFIG_ARCH_QCOM
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 0b1836a..dfa7803 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -11,40 +11,93 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/ioport.h>
 #include <linux/io.h>
-#include <linux/clk.h>
+#include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/err.h>
-#include <linux/delay.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-#include <linux/sh_timer.h>
-#include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
+#include <linux/sh_timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+struct sh_cmt_device;
+
+/*
+ * The CMT comes in 5 different identified flavours, depending not only on the
+ * SoC but also on the particular instance. The following table lists the main
+ * characteristics of those flavours.
+ *
+ *			16B	32B	32B-F	48B	48B-2
+ * -----------------------------------------------------------------------------
+ * Channels		2	1/4	1	6	2/8
+ * Control Width	16	16	16	16	32
+ * Counter Width	16	32	32	32/48	32/48
+ * Shared Start/Stop	Y	Y	Y	Y	N
+ *
+ * The 48-bit gen2 version has a per-channel start/stop register located in the
+ * channel registers block. All other versions have a shared start/stop register
+ * located in the global space.
+ *
+ * Channels are indexed from 0 to N-1 in the documentation. The channel index
+ * infers the start/stop bit position in the control register and the channel
+ * registers block address. Some CMT instances have a subset of channels
+ * available, in which case the index in the documentation doesn't match the
+ * "real" index as implemented in hardware. This is for instance the case with
+ * CMT0 on r8a7740, which is a 32-bit variant with a single channel numbered 0
+ * in the documentation but using start/stop bit 5 and having its registers
+ * block at 0x60.
+ *
+ * Similarly CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing 32-bit
+ * channels only, is a 48-bit gen2 CMT with the 48-bit channels unavailable.
+ */
+
+enum sh_cmt_model {
+	SH_CMT_16BIT,
+	SH_CMT_32BIT,
+	SH_CMT_32BIT_FAST,
+	SH_CMT_48BIT,
+	SH_CMT_48BIT_GEN2,
+};
+
+struct sh_cmt_info {
+	enum sh_cmt_model model;
 
-struct sh_cmt_priv {
-	void __iomem *mapbase;
-	void __iomem *mapbase_str;
-	struct clk *clk;
 	unsigned long width; /* 16 or 32 bit version of hardware block */
 	unsigned long overflow_bit;
 	unsigned long clear_bits;
-	struct irqaction irqaction;
-	struct platform_device *pdev;
 
+	/* callbacks for CMSTR and CMCSR access */
+	unsigned long (*read_control)(void __iomem *base, unsigned long offs);
+	void (*write_control)(void __iomem *base, unsigned long offs,
+			      unsigned long value);
+
+	/* callbacks for CMCNT and CMCOR access */
+	unsigned long (*read_count)(void __iomem *base, unsigned long offs);
+	void (*write_count)(void __iomem *base, unsigned long offs,
+			    unsigned long value);
+};
+
+struct sh_cmt_channel {
+	struct sh_cmt_device *cmt;
+
+	unsigned int index;	/* Index in the documentation */
+	unsigned int hwidx;	/* Real hardware index */
+
+	void __iomem *iostart;
+	void __iomem *ioctrl;
+
+	unsigned int timer_bit;
 	unsigned long flags;
 	unsigned long match_value;
 	unsigned long next_match_value;
@@ -55,38 +108,52 @@ struct sh_cmt_priv {
 	struct clocksource cs;
 	unsigned long total_cycles;
 	bool cs_enabled;
+};
 
-	/* callbacks for CMSTR and CMCSR access */
-	unsigned long (*read_control)(void __iomem *base, unsigned long offs);
-	void (*write_control)(void __iomem *base, unsigned long offs,
-			      unsigned long value);
+struct sh_cmt_device {
+	struct platform_device *pdev;
 
-	/* callbacks for CMCNT and CMCOR access */
-	unsigned long (*read_count)(void __iomem *base, unsigned long offs);
-	void (*write_count)(void __iomem *base, unsigned long offs,
-			    unsigned long value);
+	const struct sh_cmt_info *info;
+	bool legacy;
+
+	void __iomem *mapbase_ch;
+	void __iomem *mapbase;
+	struct clk *clk;
+
+	struct sh_cmt_channel *channels;
+	unsigned int num_channels;
+
+	bool has_clockevent;
+	bool has_clocksource;
 };
 
-/* Examples of supported CMT timer register layouts and I/O access widths:
- *
- * "16-bit counter and 16-bit control" as found on sh7263:
- * CMSTR 0xfffec000 16-bit
- * CMCSR 0xfffec002 16-bit
- * CMCNT 0xfffec004 16-bit
- * CMCOR 0xfffec006 16-bit
- *
- * "32-bit counter and 16-bit control" as found on sh7372, sh73a0, r8a7740:
- * CMSTR 0xffca0000 16-bit
- * CMCSR 0xffca0060 16-bit
- * CMCNT 0xffca0064 32-bit
- * CMCOR 0xffca0068 32-bit
- *
- * "32-bit counter and 32-bit control" as found on r8a73a4 and r8a7790:
- * CMSTR 0xffca0500 32-bit
- * CMCSR 0xffca0510 32-bit
- * CMCNT 0xffca0514 32-bit
- * CMCOR 0xffca0518 32-bit
- */
+#define SH_CMT16_CMCSR_CMF		(1 << 7)
+#define SH_CMT16_CMCSR_CMIE		(1 << 6)
+#define SH_CMT16_CMCSR_CKS8		(0 << 0)
+#define SH_CMT16_CMCSR_CKS32		(1 << 0)
+#define SH_CMT16_CMCSR_CKS128		(2 << 0)
+#define SH_CMT16_CMCSR_CKS512		(3 << 0)
+#define SH_CMT16_CMCSR_CKS_MASK		(3 << 0)
+
+#define SH_CMT32_CMCSR_CMF		(1 << 15)
+#define SH_CMT32_CMCSR_OVF		(1 << 14)
+#define SH_CMT32_CMCSR_WRFLG		(1 << 13)
+#define SH_CMT32_CMCSR_STTF		(1 << 12)
+#define SH_CMT32_CMCSR_STPF		(1 << 11)
+#define SH_CMT32_CMCSR_SSIE		(1 << 10)
+#define SH_CMT32_CMCSR_CMS		(1 << 9)
+#define SH_CMT32_CMCSR_CMM		(1 << 8)
+#define SH_CMT32_CMCSR_CMTOUT_IE	(1 << 7)
+#define SH_CMT32_CMCSR_CMR_NONE		(0 << 4)
+#define SH_CMT32_CMCSR_CMR_DMA		(1 << 4)
+#define SH_CMT32_CMCSR_CMR_IRQ		(2 << 4)
+#define SH_CMT32_CMCSR_CMR_MASK		(3 << 4)
+#define SH_CMT32_CMCSR_DBGIVD		(1 << 3)
+#define SH_CMT32_CMCSR_CKS_RCLK8	(4 << 0)
+#define SH_CMT32_CMCSR_CKS_RCLK32	(5 << 0)
+#define SH_CMT32_CMCSR_CKS_RCLK128	(6 << 0)
+#define SH_CMT32_CMCSR_CKS_RCLK1	(7 << 0)
+#define SH_CMT32_CMCSR_CKS_MASK		(7 << 0)
 
 static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
 {
@@ -110,64 +177,123 @@ static void sh_cmt_write32(void __iomem *base, unsigned long offs,
 	iowrite32(value, base + (offs << 2));
 }
 
+static const struct sh_cmt_info sh_cmt_info[] = {
+	[SH_CMT_16BIT] = {
+		.model = SH_CMT_16BIT,
+		.width = 16,
+		.overflow_bit = SH_CMT16_CMCSR_CMF,
+		.clear_bits = ~SH_CMT16_CMCSR_CMF,
+		.read_control = sh_cmt_read16,
+		.write_control = sh_cmt_write16,
+		.read_count = sh_cmt_read16,
+		.write_count = sh_cmt_write16,
+	},
+	[SH_CMT_32BIT] = {
+		.model = SH_CMT_32BIT,
+		.width = 32,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
+		.read_control = sh_cmt_read16,
+		.write_control = sh_cmt_write16,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+	[SH_CMT_32BIT_FAST] = {
+		.model = SH_CMT_32BIT_FAST,
+		.width = 32,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
+		.read_control = sh_cmt_read16,
+		.write_control = sh_cmt_write16,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+	[SH_CMT_48BIT] = {
+		.model = SH_CMT_48BIT,
+		.width = 32,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
+		.read_control = sh_cmt_read32,
+		.write_control = sh_cmt_write32,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+	[SH_CMT_48BIT_GEN2] = {
+		.model = SH_CMT_48BIT_GEN2,
+		.width = 32,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
+		.read_control = sh_cmt_read32,
+		.write_control = sh_cmt_write32,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+};
+
 #define CMCSR 0 /* channel register */
 #define CMCNT 1 /* channel register */
 #define CMCOR 2 /* channel register */
 
-static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_priv *p)
+static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 {
-	return p->read_control(p->mapbase_str, 0);
+	if (ch->iostart)
+		return ch->cmt->info->read_control(ch->iostart, 0);
+	else
+		return ch->cmt->info->read_control(ch->cmt->mapbase, 0);
 }
 
-static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_priv *p)
+static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
+				      unsigned long value)
 {
-	return p->read_control(p->mapbase, CMCSR);
+	if (ch->iostart)
+		ch->cmt->info->write_control(ch->iostart, 0, value);
+	else
+		ch->cmt->info->write_control(ch->cmt->mapbase, 0, value);
 }
 
-static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_priv *p)
+static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
 {
-	return p->read_count(p->mapbase, CMCNT);
+	return ch->cmt->info->read_control(ch->ioctrl, CMCSR);
 }
 
-static inline void sh_cmt_write_cmstr(struct sh_cmt_priv *p,
+static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	p->write_control(p->mapbase_str, 0, value);
+	ch->cmt->info->write_control(ch->ioctrl, CMCSR, value);
 }
 
-static inline void sh_cmt_write_cmcsr(struct sh_cmt_priv *p,
-				      unsigned long value)
+static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
 {
-	p->write_control(p->mapbase, CMCSR, value);
+	return ch->cmt->info->read_count(ch->ioctrl, CMCNT);
 }
 
-static inline void sh_cmt_write_cmcnt(struct sh_cmt_priv *p,
+static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	p->write_count(p->mapbase, CMCNT, value);
+	ch->cmt->info->write_count(ch->ioctrl, CMCNT, value);
 }
 
-static inline void sh_cmt_write_cmcor(struct sh_cmt_priv *p,
+static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	p->write_count(p->mapbase, CMCOR, value);
+	ch->cmt->info->write_count(ch->ioctrl, CMCOR, value);
 }
 
-static unsigned long sh_cmt_get_counter(struct sh_cmt_priv *p,
+static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
 					int *has_wrapped)
 {
 	unsigned long v1, v2, v3;
 	int o1, o2;
 
-	o1 = sh_cmt_read_cmcsr(p) & p->overflow_bit;
+	o1 = sh_cmt_read_cmcsr(ch) & ch->cmt->info->overflow_bit;
 
 	/* Make sure the timer value is stable. Stolen from acpi_pm.c */
 	do {
 		o2 = o1;
-		v1 = sh_cmt_read_cmcnt(p);
-		v2 = sh_cmt_read_cmcnt(p);
-		v3 = sh_cmt_read_cmcnt(p);
-		o1 = sh_cmt_read_cmcsr(p) & p->overflow_bit;
+		v1 = sh_cmt_read_cmcnt(ch);
+		v2 = sh_cmt_read_cmcnt(ch);
+		v3 = sh_cmt_read_cmcnt(ch);
+		o1 = sh_cmt_read_cmcsr(ch) & ch->cmt->info->overflow_bit;
 	} while (unlikely((o1 != o2) || (v1 > v2 && v1 < v3)
 			  || (v2 > v3 && v2 < v1) || (v3 > v1 && v3 < v2)));
 
@@ -177,52 +303,56 @@ static unsigned long sh_cmt_get_counter(struct sh_cmt_priv *p,
 
 static DEFINE_RAW_SPINLOCK(sh_cmt_lock);
 
-static void sh_cmt_start_stop_ch(struct sh_cmt_priv *p, int start)
+static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
 	raw_spin_lock_irqsave(&sh_cmt_lock, flags);
-	value = sh_cmt_read_cmstr(p);
+	value = sh_cmt_read_cmstr(ch);
 
 	if (start)
-		value |= 1 << cfg->timer_bit;
+		value |= 1 << ch->timer_bit;
 	else
-		value &= ~(1 << cfg->timer_bit);
+		value &= ~(1 << ch->timer_bit);
 
-	sh_cmt_write_cmstr(p, value);
+	sh_cmt_write_cmstr(ch, value);
 	raw_spin_unlock_irqrestore(&sh_cmt_lock, flags);
 }
 
-static int sh_cmt_enable(struct sh_cmt_priv *p, unsigned long *rate)
+static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
 {
 	int k, ret;
 
-	pm_runtime_get_sync(&p->pdev->dev);
-	dev_pm_syscore_device(&p->pdev->dev, true);
+	pm_runtime_get_sync(&ch->cmt->pdev->dev);
+	dev_pm_syscore_device(&ch->cmt->pdev->dev, true);
 
 	/* enable clock */
-	ret = clk_enable(p->clk);
+	ret = clk_enable(ch->cmt->clk);
 	if (ret) {
-		dev_err(&p->pdev->dev, "cannot enable clock\n");
+		dev_err(&ch->cmt->pdev->dev, "ch%u: cannot enable clock\n",
+			ch->index);
 		goto err0;
 	}
 
 	/* make sure channel is disabled */
-	sh_cmt_start_stop_ch(p, 0);
+	sh_cmt_start_stop_ch(ch, 0);
 
 	/* configure channel, periodic mode and maximum timeout */
-	if (p->width == 16) {
-		*rate = clk_get_rate(p->clk) / 512;
-		sh_cmt_write_cmcsr(p, 0x43);
+	if (ch->cmt->info->width == 16) {
+		*rate = clk_get_rate(ch->cmt->clk) / 512;
+		sh_cmt_write_cmcsr(ch, SH_CMT16_CMCSR_CMIE |
+				   SH_CMT16_CMCSR_CKS512);
 	} else {
-		*rate = clk_get_rate(p->clk) / 8;
-		sh_cmt_write_cmcsr(p, 0x01a4);
+		*rate = clk_get_rate(ch->cmt->clk) / 8;
+		sh_cmt_write_cmcsr(ch, SH_CMT32_CMCSR_CMM |
+				   SH_CMT32_CMCSR_CMTOUT_IE |
+				   SH_CMT32_CMCSR_CMR_IRQ |
+				   SH_CMT32_CMCSR_CKS_RCLK8);
 	}
 
-	sh_cmt_write_cmcor(p, 0xffffffff);
-	sh_cmt_write_cmcnt(p, 0);
+	sh_cmt_write_cmcor(ch, 0xffffffff);
+	sh_cmt_write_cmcnt(ch, 0);
 
 	/*
 	 * According to the sh73a0 user's manual, as CMCNT can be operated
@@ -236,41 +366,42 @@ static int sh_cmt_enable(struct sh_cmt_priv *p, unsigned long *rate)
 	 * take RCLKx2 at maximum.
 	 */
 	for (k = 0; k < 100; k++) {
-		if (!sh_cmt_read_cmcnt(p))
+		if (!sh_cmt_read_cmcnt(ch))
 			break;
 		udelay(1);
 	}
 
-	if (sh_cmt_read_cmcnt(p)) {
-		dev_err(&p->pdev->dev, "cannot clear CMCNT\n");
+	if (sh_cmt_read_cmcnt(ch)) {
+		dev_err(&ch->cmt->pdev->dev, "ch%u: cannot clear CMCNT\n",
+			ch->index);
 		ret = -ETIMEDOUT;
 		goto err1;
 	}
 
 	/* enable channel */
-	sh_cmt_start_stop_ch(p, 1);
+	sh_cmt_start_stop_ch(ch, 1);
 	return 0;
  err1:
 	/* stop clock */
-	clk_disable(p->clk);
+	clk_disable(ch->cmt->clk);
 
  err0:
 	return ret;
 }
 
-static void sh_cmt_disable(struct sh_cmt_priv *p)
+static void sh_cmt_disable(struct sh_cmt_channel *ch)
 {
 	/* disable channel */
-	sh_cmt_start_stop_ch(p, 0);
+	sh_cmt_start_stop_ch(ch, 0);
 
 	/* disable interrupts in CMT block */
-	sh_cmt_write_cmcsr(p, 0);
+	sh_cmt_write_cmcsr(ch, 0);
 
 	/* stop clock */
-	clk_disable(p->clk);
+	clk_disable(ch->cmt->clk);
 
-	dev_pm_syscore_device(&p->pdev->dev, false);
-	pm_runtime_put(&p->pdev->dev);
+	dev_pm_syscore_device(&ch->cmt->pdev->dev, false);
+	pm_runtime_put(&ch->cmt->pdev->dev);
 }
 
 /* private flags */
@@ -280,24 +411,24 @@ static void sh_cmt_disable(struct sh_cmt_priv *p)
 #define FLAG_SKIPEVENT (1 << 3)
 #define FLAG_IRQCONTEXT (1 << 4)
 
-static void sh_cmt_clock_event_program_verify(struct sh_cmt_priv *p,
+static void sh_cmt_clock_event_program_verify(struct sh_cmt_channel *ch,
 					      int absolute)
 {
 	unsigned long new_match;
-	unsigned long value = p->next_match_value;
+	unsigned long value = ch->next_match_value;
 	unsigned long delay = 0;
 	unsigned long now = 0;
 	int has_wrapped;
 
-	now = sh_cmt_get_counter(p, &has_wrapped);
-	p->flags |= FLAG_REPROGRAM; /* force reprogram */
+	now = sh_cmt_get_counter(ch, &has_wrapped);
+	ch->flags |= FLAG_REPROGRAM; /* force reprogram */
 
 	if (has_wrapped) {
 		/* we're competing with the interrupt handler.
 		 *  -> let the interrupt handler reprogram the timer.
 		 *  -> interrupt number two handles the event.
 		 */
-		p->flags |= FLAG_SKIPEVENT;
+		ch->flags |= FLAG_SKIPEVENT;
 		return;
 	}
 
@@ -309,20 +440,20 @@ static void sh_cmt_clock_event_program_verify(struct sh_cmt_priv *p,
 		 * but don't save the new match value yet.
 		 */
 		new_match = now + value + delay;
-		if (new_match > p->max_match_value)
-			new_match = p->max_match_value;
+		if (new_match > ch->max_match_value)
+			new_match = ch->max_match_value;
 
-		sh_cmt_write_cmcor(p, new_match);
+		sh_cmt_write_cmcor(ch, new_match);
 
-		now = sh_cmt_get_counter(p, &has_wrapped);
-		if (has_wrapped && (new_match > p->match_value)) {
+		now = sh_cmt_get_counter(ch, &has_wrapped);
+		if (has_wrapped && (new_match > ch->match_value)) {
 			/* we are changing to a greater match value,
 			 * so this wrap must be caused by the counter
 			 * matching the old value.
 			 * -> first interrupt reprograms the timer.
 			 * -> interrupt number two handles the event.
 			 */
-			p->flags |= FLAG_SKIPEVENT;
+			ch->flags |= FLAG_SKIPEVENT;
 			break;
 		}
 
@@ -333,7 +464,7 @@ static void sh_cmt_clock_event_program_verify(struct sh_cmt_priv *p,
 			 * -> save programmed match value.
 			 * -> let isr handle the event.
 			 */
-			p->match_value = new_match;
+			ch->match_value = new_match;
 			break;
 		}
 
@@ -344,7 +475,7 @@ static void sh_cmt_clock_event_program_verify(struct sh_cmt_priv *p,
 			 * -> save programmed match value.
 			 * -> let isr handle the event.
 			 */
-			p->match_value = new_match;
+			ch->match_value = new_match;
 			break;
 		}
 
@@ -360,138 +491,141 @@ static void sh_cmt_clock_event_program_verify(struct sh_cmt_priv *p,
 			delay = 1;
 
 		if (!delay)
-			dev_warn(&p->pdev->dev, "too long delay\n");
+			dev_warn(&ch->cmt->pdev->dev, "ch%u: too long delay\n",
+				 ch->index);
 
 	} while (delay);
 }
 
-static void __sh_cmt_set_next(struct sh_cmt_priv *p, unsigned long delta)
+static void __sh_cmt_set_next(struct sh_cmt_channel *ch, unsigned long delta)
 {
-	if (delta > p->max_match_value)
-		dev_warn(&p->pdev->dev, "delta out of range\n");
+	if (delta > ch->max_match_value)
+		dev_warn(&ch->cmt->pdev->dev, "ch%u: delta out of range\n",
+			 ch->index);
 
-	p->next_match_value = delta;
-	sh_cmt_clock_event_program_verify(p, 0);
+	ch->next_match_value = delta;
+	sh_cmt_clock_event_program_verify(ch, 0);
 }
 
-static void sh_cmt_set_next(struct sh_cmt_priv *p, unsigned long delta)
+static void sh_cmt_set_next(struct sh_cmt_channel *ch, unsigned long delta)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&p->lock, flags);
-	__sh_cmt_set_next(p, delta);
-	raw_spin_unlock_irqrestore(&p->lock, flags);
+	raw_spin_lock_irqsave(&ch->lock, flags);
+	__sh_cmt_set_next(ch, delta);
+	raw_spin_unlock_irqrestore(&ch->lock, flags);
 }
 
 static irqreturn_t sh_cmt_interrupt(int irq, void *dev_id)
 {
-	struct sh_cmt_priv *p = dev_id;
+	struct sh_cmt_channel *ch = dev_id;
 
 	/* clear flags */
-	sh_cmt_write_cmcsr(p, sh_cmt_read_cmcsr(p) & p->clear_bits);
+	sh_cmt_write_cmcsr(ch, sh_cmt_read_cmcsr(ch) &
+			   ch->cmt->info->clear_bits);
 
 	/* update clock source counter to begin with if enabled
 	 * the wrap flag should be cleared by the timer specific
 	 * isr before we end up here.
 	 */
-	if (p->flags & FLAG_CLOCKSOURCE)
-		p->total_cycles += p->match_value + 1;
+	if (ch->flags & FLAG_CLOCKSOURCE)
+		ch->total_cycles += ch->match_value + 1;
 
-	if (!(p->flags & FLAG_REPROGRAM))
-		p->next_match_value = p->max_match_value;
+	if (!(ch->flags & FLAG_REPROGRAM))
+		ch->next_match_value = ch->max_match_value;
 
-	p->flags |= FLAG_IRQCONTEXT;
+	ch->flags |= FLAG_IRQCONTEXT;
 
-	if (p->flags & FLAG_CLOCKEVENT) {
-		if (!(p->flags & FLAG_SKIPEVENT)) {
-			if (p->ced.mode == CLOCK_EVT_MODE_ONESHOT) {
-				p->next_match_value = p->max_match_value;
-				p->flags |= FLAG_REPROGRAM;
+	if (ch->flags & FLAG_CLOCKEVENT) {
+		if (!(ch->flags & FLAG_SKIPEVENT)) {
+			if (ch->ced.mode == CLOCK_EVT_MODE_ONESHOT) {
+				ch->next_match_value = ch->max_match_value;
+				ch->flags |= FLAG_REPROGRAM;
 			}
 
-			p->ced.event_handler(&p->ced);
+			ch->ced.event_handler(&ch->ced);
 		}
 	}
 
-	p->flags &= ~FLAG_SKIPEVENT;
+	ch->flags &= ~FLAG_SKIPEVENT;
 
-	if (p->flags & FLAG_REPROGRAM) {
-		p->flags &= ~FLAG_REPROGRAM;
-		sh_cmt_clock_event_program_verify(p, 1);
+	if (ch->flags & FLAG_REPROGRAM) {
+		ch->flags &= ~FLAG_REPROGRAM;
+		sh_cmt_clock_event_program_verify(ch, 1);
 
-		if (p->flags & FLAG_CLOCKEVENT)
-			if ((p->ced.mode == CLOCK_EVT_MODE_SHUTDOWN)
-			    || (p->match_value == p->next_match_value))
-				p->flags &= ~FLAG_REPROGRAM;
+		if (ch->flags & FLAG_CLOCKEVENT)
+			if ((ch->ced.mode == CLOCK_EVT_MODE_SHUTDOWN)
+			    || (ch->match_value == ch->next_match_value))
+				ch->flags &= ~FLAG_REPROGRAM;
 	}
 
-	p->flags &= ~FLAG_IRQCONTEXT;
+	ch->flags &= ~FLAG_IRQCONTEXT;
 
 	return IRQ_HANDLED;
 }
 
-static int sh_cmt_start(struct sh_cmt_priv *p, unsigned long flag)
+static int sh_cmt_start(struct sh_cmt_channel *ch, unsigned long flag)
 {
 	int ret = 0;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&p->lock, flags);
+	raw_spin_lock_irqsave(&ch->lock, flags);
 
-	if (!(p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
-		ret = sh_cmt_enable(p, &p->rate);
+	if (!(ch->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
+		ret = sh_cmt_enable(ch, &ch->rate);
 
 	if (ret)
 		goto out;
-	p->flags |= flag;
+	ch->flags |= flag;
 
 	/* setup timeout if no clockevent */
-	if ((flag == FLAG_CLOCKSOURCE) && (!(p->flags & FLAG_CLOCKEVENT)))
-		__sh_cmt_set_next(p, p->max_match_value);
+	if ((flag == FLAG_CLOCKSOURCE) && (!(ch->flags & FLAG_CLOCKEVENT)))
+		__sh_cmt_set_next(ch, ch->max_match_value);
  out:
-	raw_spin_unlock_irqrestore(&p->lock, flags);
+	raw_spin_unlock_irqrestore(&ch->lock, flags);
 
 	return ret;
 }
 
-static void sh_cmt_stop(struct sh_cmt_priv *p, unsigned long flag)
+static void sh_cmt_stop(struct sh_cmt_channel *ch, unsigned long flag)
 {
 	unsigned long flags;
 	unsigned long f;
 
-	raw_spin_lock_irqsave(&p->lock, flags);
+	raw_spin_lock_irqsave(&ch->lock, flags);
 
-	f = p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE);
-	p->flags &= ~flag;
+	f = ch->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE);
+	ch->flags &= ~flag;
 
-	if (f && !(p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
-		sh_cmt_disable(p);
+	if (f && !(ch->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
+		sh_cmt_disable(ch);
 
 	/* adjust the timeout to maximum if only clocksource left */
-	if ((flag == FLAG_CLOCKEVENT) && (p->flags & FLAG_CLOCKSOURCE))
-		__sh_cmt_set_next(p, p->max_match_value);
+	if ((flag == FLAG_CLOCKEVENT) && (ch->flags & FLAG_CLOCKSOURCE))
+		__sh_cmt_set_next(ch, ch->max_match_value);
 
-	raw_spin_unlock_irqrestore(&p->lock, flags);
+	raw_spin_unlock_irqrestore(&ch->lock, flags);
 }
 
-static struct sh_cmt_priv *cs_to_sh_cmt(struct clocksource *cs)
+static struct sh_cmt_channel *cs_to_sh_cmt(struct clocksource *cs)
 {
-	return container_of(cs, struct sh_cmt_priv, cs);
+	return container_of(cs, struct sh_cmt_channel, cs);
 }
 
 static cycle_t sh_cmt_clocksource_read(struct clocksource *cs)
 {
-	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
 	unsigned long flags, raw;
 	unsigned long value;
 	int has_wrapped;
 
-	raw_spin_lock_irqsave(&p->lock, flags);
-	value = p->total_cycles;
-	raw = sh_cmt_get_counter(p, &has_wrapped);
+	raw_spin_lock_irqsave(&ch->lock, flags);
+	value = ch->total_cycles;
+	raw = sh_cmt_get_counter(ch, &has_wrapped);
 
 	if (unlikely(has_wrapped))
-		raw += p->match_value + 1;
-	raw_spin_unlock_irqrestore(&p->lock, flags);
+		raw += ch->match_value + 1;
+	raw_spin_unlock_irqrestore(&ch->lock, flags);
 
 	return value + raw;
 }
@@ -499,53 +633,53 @@ static cycle_t sh_cmt_clocksource_read(struct clocksource *cs)
 static int sh_cmt_clocksource_enable(struct clocksource *cs)
 {
 	int ret;
-	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
 
-	WARN_ON(p->cs_enabled);
+	WARN_ON(ch->cs_enabled);
 
-	p->total_cycles = 0;
+	ch->total_cycles = 0;
 
-	ret = sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	ret = sh_cmt_start(ch, FLAG_CLOCKSOURCE);
 	if (!ret) {
-		__clocksource_updatefreq_hz(cs, p->rate);
-		p->cs_enabled = true;
+		__clocksource_updatefreq_hz(cs, ch->rate);
+		ch->cs_enabled = true;
 	}
 	return ret;
 }
 
 static void sh_cmt_clocksource_disable(struct clocksource *cs)
 {
-	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
 
-	WARN_ON(!p->cs_enabled);
+	WARN_ON(!ch->cs_enabled);
 
-	sh_cmt_stop(p, FLAG_CLOCKSOURCE);
-	p->cs_enabled = false;
+	sh_cmt_stop(ch, FLAG_CLOCKSOURCE);
+	ch->cs_enabled = false;
 }
 
 static void sh_cmt_clocksource_suspend(struct clocksource *cs)
 {
-	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
 
-	sh_cmt_stop(p, FLAG_CLOCKSOURCE);
-	pm_genpd_syscore_poweroff(&p->pdev->dev);
+	sh_cmt_stop(ch, FLAG_CLOCKSOURCE);
+	pm_genpd_syscore_poweroff(&ch->cmt->pdev->dev);
 }
 
 static void sh_cmt_clocksource_resume(struct clocksource *cs)
 {
-	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
 
-	pm_genpd_syscore_poweron(&p->pdev->dev);
-	sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	pm_genpd_syscore_poweron(&ch->cmt->pdev->dev);
+	sh_cmt_start(ch, FLAG_CLOCKSOURCE);
 }
 
-static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
-				       char *name, unsigned long rating)
+static int sh_cmt_register_clocksource(struct sh_cmt_channel *ch,
+				       const char *name)
 {
-	struct clocksource *cs = &p->cs;
+	struct clocksource *cs = &ch->cs;
 
 	cs->name = name;
-	cs->rating = rating;
+	cs->rating = 125;
 	cs->read = sh_cmt_clocksource_read;
 	cs->enable = sh_cmt_clocksource_enable;
 	cs->disable = sh_cmt_clocksource_disable;
@@ -554,47 +688,48 @@ static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	dev_info(&p->pdev->dev, "used as clock source\n");
+	dev_info(&ch->cmt->pdev->dev, "ch%u: used as clock source\n",
+		 ch->index);
 
 	/* Register with dummy 1 Hz value, gets updated in ->enable() */
 	clocksource_register_hz(cs, 1);
 	return 0;
 }
 
-static struct sh_cmt_priv *ced_to_sh_cmt(struct clock_event_device *ced)
+static struct sh_cmt_channel *ced_to_sh_cmt(struct clock_event_device *ced)
 {
-	return container_of(ced, struct sh_cmt_priv, ced);
+	return container_of(ced, struct sh_cmt_channel, ced);
 }
 
-static void sh_cmt_clock_event_start(struct sh_cmt_priv *p, int periodic)
+static void sh_cmt_clock_event_start(struct sh_cmt_channel *ch, int periodic)
 {
-	struct clock_event_device *ced = &p->ced;
+	struct clock_event_device *ced = &ch->ced;
 
-	sh_cmt_start(p, FLAG_CLOCKEVENT);
+	sh_cmt_start(ch, FLAG_CLOCKEVENT);
 
 	/* TODO: calculate good shift from rate and counter bit width */
 
 	ced->shift = 32;
-	ced->mult = div_sc(p->rate, NSEC_PER_SEC, ced->shift);
-	ced->max_delta_ns = clockevent_delta2ns(p->max_match_value, ced);
+	ced->mult = div_sc(ch->rate, NSEC_PER_SEC, ced->shift);
+	ced->max_delta_ns = clockevent_delta2ns(ch->max_match_value, ced);
 	ced->min_delta_ns = clockevent_delta2ns(0x1f, ced);
 
 	if (periodic)
-		sh_cmt_set_next(p, ((p->rate + HZ/2) / HZ) - 1);
+		sh_cmt_set_next(ch, ((ch->rate + HZ/2) / HZ) - 1);
 	else
-		sh_cmt_set_next(p, p->max_match_value);
+		sh_cmt_set_next(ch, ch->max_match_value);
 }
 
 static void sh_cmt_clock_event_mode(enum clock_event_mode mode,
 				    struct clock_event_device *ced)
 {
-	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+	struct sh_cmt_channel *ch = ced_to_sh_cmt(ced);
 
 	/* deal with old setting first */
 	switch (ced->mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 	case CLOCK_EVT_MODE_ONESHOT:
-		sh_cmt_stop(p, FLAG_CLOCKEVENT);
+		sh_cmt_stop(ch, FLAG_CLOCKEVENT);
 		break;
 	default:
 		break;
@@ -602,16 +737,18 @@ static void sh_cmt_clock_event_mode(enum clock_event_mode mode,
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		dev_info(&p->pdev->dev, "used for periodic clock events\n");
-		sh_cmt_clock_event_start(p, 1);
+		dev_info(&ch->cmt->pdev->dev,
+			 "ch%u: used for periodic clock events\n", ch->index);
+		sh_cmt_clock_event_start(ch, 1);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
-		dev_info(&p->pdev->dev, "used for oneshot clock events\n");
-		sh_cmt_clock_event_start(p, 0);
+		dev_info(&ch->cmt->pdev->dev,
+			 "ch%u: used for oneshot clock events\n", ch->index);
+		sh_cmt_clock_event_start(ch, 0);
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-		sh_cmt_stop(p, FLAG_CLOCKEVENT);
+		sh_cmt_stop(ch, FLAG_CLOCKEVENT);
 		break;
 	default:
 		break;
@@ -621,196 +758,341 @@ static void sh_cmt_clock_event_mode(enum clock_event_mode mode,
 static int sh_cmt_clock_event_next(unsigned long delta,
 				   struct clock_event_device *ced)
 {
-	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+	struct sh_cmt_channel *ch = ced_to_sh_cmt(ced);
 
 	BUG_ON(ced->mode != CLOCK_EVT_MODE_ONESHOT);
-	if (likely(p->flags & FLAG_IRQCONTEXT))
-		p->next_match_value = delta - 1;
+	if (likely(ch->flags & FLAG_IRQCONTEXT))
+		ch->next_match_value = delta - 1;
 	else
-		sh_cmt_set_next(p, delta - 1);
+		sh_cmt_set_next(ch, delta - 1);
 
 	return 0;
 }
 
 static void sh_cmt_clock_event_suspend(struct clock_event_device *ced)
 {
-	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+	struct sh_cmt_channel *ch = ced_to_sh_cmt(ced);
 
-	pm_genpd_syscore_poweroff(&p->pdev->dev);
-	clk_unprepare(p->clk);
+	pm_genpd_syscore_poweroff(&ch->cmt->pdev->dev);
+	clk_unprepare(ch->cmt->clk);
 }
 
 static void sh_cmt_clock_event_resume(struct clock_event_device *ced)
 {
-	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+	struct sh_cmt_channel *ch = ced_to_sh_cmt(ced);
 
-	clk_prepare(p->clk);
-	pm_genpd_syscore_poweron(&p->pdev->dev);
+	clk_prepare(ch->cmt->clk);
+	pm_genpd_syscore_poweron(&ch->cmt->pdev->dev);
 }
 
-static void sh_cmt_register_clockevent(struct sh_cmt_priv *p,
-				       char *name, unsigned long rating)
+static int sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
+				      const char *name)
 {
-	struct clock_event_device *ced = &p->ced;
+	struct clock_event_device *ced = &ch->ced;
+	int irq;
+	int ret;
 
-	memset(ced, 0, sizeof(*ced));
+	irq = platform_get_irq(ch->cmt->pdev, ch->cmt->legacy ? 0 : ch->index);
+	if (irq < 0) {
+		dev_err(&ch->cmt->pdev->dev, "ch%u: failed to get irq\n",
+			ch->index);
+		return irq;
+	}
+
+	ret = request_irq(irq, sh_cmt_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			  dev_name(&ch->cmt->pdev->dev), ch);
+	if (ret) {
+		dev_err(&ch->cmt->pdev->dev, "ch%u: failed to request irq %d\n",
+			ch->index, irq);
+		return ret;
+	}
 
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
-	ced->rating = rating;
-	ced->cpumask = cpumask_of(0);
+	ced->rating = 125;
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = sh_cmt_clock_event_next;
 	ced->set_mode = sh_cmt_clock_event_mode;
 	ced->suspend = sh_cmt_clock_event_suspend;
 	ced->resume = sh_cmt_clock_event_resume;
 
-	dev_info(&p->pdev->dev, "used for clock events\n");
+	dev_info(&ch->cmt->pdev->dev, "ch%u: used for clock events\n",
+		 ch->index);
 	clockevents_register_device(ced);
+
+	return 0;
 }
 
-static int sh_cmt_register(struct sh_cmt_priv *p, char *name,
-			   unsigned long clockevent_rating,
-			   unsigned long clocksource_rating)
+static int sh_cmt_register(struct sh_cmt_channel *ch, const char *name,
+			   bool clockevent, bool clocksource)
 {
-	if (clockevent_rating)
-		sh_cmt_register_clockevent(p, name, clockevent_rating);
+	int ret;
 
-	if (clocksource_rating)
-		sh_cmt_register_clocksource(p, name, clocksource_rating);
+	if (clockevent) {
+		ch->cmt->has_clockevent = true;
+		ret = sh_cmt_register_clockevent(ch, name);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (clocksource) {
+		ch->cmt->has_clocksource = true;
+		sh_cmt_register_clocksource(ch, name);
+	}
 
 	return 0;
 }
 
-static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
+static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
+				unsigned int hwidx, bool clockevent,
+				bool clocksource, struct sh_cmt_device *cmt)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	struct resource *res, *res2;
-	int irq, ret;
-	ret = -ENXIO;
+	int ret;
 
-	memset(p, 0, sizeof(*p));
-	p->pdev = pdev;
+	/* Skip unused channels. */
+	if (!clockevent && !clocksource)
+		return 0;
 
-	if (!cfg) {
-		dev_err(&p->pdev->dev, "missing platform data\n");
-		goto err0;
+	ch->cmt = cmt;
+	ch->index = index;
+	ch->hwidx = hwidx;
+
+	/*
+	 * Compute the address of the channel control register block. For the
+	 * timers with a per-channel start/stop register, compute its address
+	 * as well.
+	 *
+	 * For legacy configuration the address has been mapped explicitly.
+	 */
+	if (cmt->legacy) {
+		ch->ioctrl = cmt->mapbase_ch;
+	} else {
+		switch (cmt->info->model) {
+		case SH_CMT_16BIT:
+			ch->ioctrl = cmt->mapbase + 2 + ch->hwidx * 6;
+			break;
+		case SH_CMT_32BIT:
+		case SH_CMT_48BIT:
+			ch->ioctrl = cmt->mapbase + 0x10 + ch->hwidx * 0x10;
+			break;
+		case SH_CMT_32BIT_FAST:
+			/*
+			 * The 32-bit "fast" timer has a single channel at hwidx
+			 * 5 but is located at offset 0x40 instead of 0x60 for
+			 * some reason.
+			 */
+			ch->ioctrl = cmt->mapbase + 0x40;
+			break;
+		case SH_CMT_48BIT_GEN2:
+			ch->iostart = cmt->mapbase + ch->hwidx * 0x100;
+			ch->ioctrl = ch->iostart + 0x10;
+			break;
+		}
 	}
 
-	res = platform_get_resource(p->pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&p->pdev->dev, "failed to get I/O memory\n");
-		goto err0;
+	if (cmt->info->width == (sizeof(ch->max_match_value) * 8))
+		ch->max_match_value = ~0;
+	else
+		ch->max_match_value = (1 << cmt->info->width) - 1;
+
+	ch->match_value = ch->max_match_value;
+	raw_spin_lock_init(&ch->lock);
+
+	if (cmt->legacy) {
+		ch->timer_bit = ch->hwidx;
+	} else {
+		ch->timer_bit = cmt->info->model == SH_CMT_48BIT_GEN2
+			      ? 0 : ch->hwidx;
 	}
 
-	/* optional resource for the shared timer start/stop register */
-	res2 = platform_get_resource(p->pdev, IORESOURCE_MEM, 1);
+	ret = sh_cmt_register(ch, dev_name(&cmt->pdev->dev),
+			      clockevent, clocksource);
+	if (ret) {
+		dev_err(&cmt->pdev->dev, "ch%u: registration failed\n",
+			ch->index);
+		return ret;
+	}
+	ch->cs_enabled = false;
 
-	irq = platform_get_irq(p->pdev, 0);
-	if (irq < 0) {
-		dev_err(&p->pdev->dev, "failed to get irq\n");
-		goto err0;
+	return 0;
+}
+
+static int sh_cmt_map_memory(struct sh_cmt_device *cmt)
+{
+	struct resource *mem;
+
+	mem = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&cmt->pdev->dev, "failed to get I/O memory\n");
+		return -ENXIO;
 	}
 
-	/* map memory, let mapbase point to our channel */
-	p->mapbase = ioremap_nocache(res->start, resource_size(res));
-	if (p->mapbase == NULL) {
-		dev_err(&p->pdev->dev, "failed to remap I/O memory\n");
-		goto err0;
+	cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
+	if (cmt->mapbase == NULL) {
+		dev_err(&cmt->pdev->dev, "failed to remap I/O memory\n");
+		return -ENXIO;
 	}
 
-	/* map second resource for CMSTR */
-	p->mapbase_str = ioremap_nocache(res2 ? res2->start :
-					 res->start - cfg->channel_offset,
-					 res2 ? resource_size(res2) : 2);
-	if (p->mapbase_str == NULL) {
-		dev_err(&p->pdev->dev, "failed to remap I/O second memory\n");
-		goto err1;
+	return 0;
+}
+
+static int sh_cmt_map_memory_legacy(struct sh_cmt_device *cmt)
+{
+	struct sh_timer_config *cfg = cmt->pdev->dev.platform_data;
+	struct resource *res, *res2;
+
+	/* map memory, let mapbase_ch point to our channel */
+	res = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&cmt->pdev->dev, "failed to get I/O memory\n");
+		return -ENXIO;
 	}
 
-	/* request irq using setup_irq() (too early for request_irq()) */
-	p->irqaction.name = dev_name(&p->pdev->dev);
-	p->irqaction.handler = sh_cmt_interrupt;
-	p->irqaction.dev_id = p;
-	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
-
-	/* get hold of clock */
-	p->clk = clk_get(&p->pdev->dev, "cmt_fck");
-	if (IS_ERR(p->clk)) {
-		dev_err(&p->pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(p->clk);
-		goto err2;
+	cmt->mapbase_ch = ioremap_nocache(res->start, resource_size(res));
+	if (cmt->mapbase_ch == NULL) {
+		dev_err(&cmt->pdev->dev, "failed to remap I/O memory\n");
+		return -ENXIO;
 	}
 
-	ret = clk_prepare(p->clk);
-	if (ret < 0)
-		goto err3;
+	/* optional resource for the shared timer start/stop register */
+	res2 = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 1);
 
-	if (res2 && (resource_size(res2) == 4)) {
-		/* assume both CMSTR and CMCSR to be 32-bit */
-		p->read_control = sh_cmt_read32;
-		p->write_control = sh_cmt_write32;
-	} else {
-		p->read_control = sh_cmt_read16;
-		p->write_control = sh_cmt_write16;
+	/* map second resource for CMSTR */
+	cmt->mapbase = ioremap_nocache(res2 ? res2->start :
+				       res->start - cfg->channel_offset,
+				       res2 ? resource_size(res2) : 2);
+	if (cmt->mapbase == NULL) {
+		dev_err(&cmt->pdev->dev, "failed to remap I/O second memory\n");
+		iounmap(cmt->mapbase_ch);
+		return -ENXIO;
 	}
 
-	if (resource_size(res) == 6) {
-		p->width = 16;
-		p->read_count = sh_cmt_read16;
-		p->write_count = sh_cmt_write16;
-		p->overflow_bit = 0x80;
-		p->clear_bits = ~0x80;
-	} else {
-		p->width = 32;
-		p->read_count = sh_cmt_read32;
-		p->write_count = sh_cmt_write32;
-		p->overflow_bit = 0x8000;
-		p->clear_bits = ~0xc000;
+	/* identify the model based on the resources */
+	if (resource_size(res) == 6)
+		cmt->info = &sh_cmt_info[SH_CMT_16BIT];
+	else if (res2 && (resource_size(res2) == 4))
+		cmt->info = &sh_cmt_info[SH_CMT_48BIT_GEN2];
+	else
+		cmt->info = &sh_cmt_info[SH_CMT_32BIT];
+
+	return 0;
+}
+
+static void sh_cmt_unmap_memory(struct sh_cmt_device *cmt)
+{
+	iounmap(cmt->mapbase);
+	if (cmt->mapbase_ch)
+		iounmap(cmt->mapbase_ch);
+}
+
+static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
+{
+	struct sh_timer_config *cfg = pdev->dev.platform_data;
+	const struct platform_device_id *id = pdev->id_entry;
+	unsigned int hw_channels;
+	int ret;
+
+	memset(cmt, 0, sizeof(*cmt));
+	cmt->pdev = pdev;
+
+	if (!cfg) {
+		dev_err(&cmt->pdev->dev, "missing platform data\n");
+		return -ENXIO;
 	}
 
-	if (p->width == (sizeof(p->max_match_value) * 8))
-		p->max_match_value = ~0;
+	cmt->info = (const struct sh_cmt_info *)id->driver_data;
+	cmt->legacy = cmt->info ? false : true;
+
+	/* Get hold of clock. */
+	cmt->clk = clk_get(&cmt->pdev->dev, cmt->legacy ? "cmt_fck" : "fck");
+	if (IS_ERR(cmt->clk)) {
+		dev_err(&cmt->pdev->dev, "cannot get clock\n");
+		return PTR_ERR(cmt->clk);
+	}
+
+	ret = clk_prepare(cmt->clk);
+	if (ret < 0)
+		goto err_clk_put;
+
+	/*
+	 * Map the memory resource(s). We need to support both the legacy
+	 * platform device configuration (with one device per channel) and the
+	 * new version (with multiple channels per device).
+	 */
+	if (cmt->legacy)
+		ret = sh_cmt_map_memory_legacy(cmt);
 	else
-		p->max_match_value = (1 << p->width) - 1;
+		ret = sh_cmt_map_memory(cmt);
 
-	p->match_value = p->max_match_value;
-	raw_spin_lock_init(&p->lock);
+	if (ret < 0)
+		goto err_clk_unprepare;
 
-	ret = sh_cmt_register(p, (char *)dev_name(&p->pdev->dev),
-			      cfg->clockevent_rating,
-			      cfg->clocksource_rating);
-	if (ret) {
-		dev_err(&p->pdev->dev, "registration failed\n");
-		goto err4;
+	/* Allocate and setup the channels. */
+	if (cmt->legacy) {
+		cmt->num_channels = 1;
+		hw_channels = 0;
+	} else {
+		cmt->num_channels = hweight8(cfg->channels_mask);
+		hw_channels = cfg->channels_mask;
 	}
-	p->cs_enabled = false;
 
-	ret = setup_irq(irq, &p->irqaction);
-	if (ret) {
-		dev_err(&p->pdev->dev, "failed to request irq %d\n", irq);
-		goto err4;
+	cmt->channels = kzalloc(cmt->num_channels * sizeof(*cmt->channels),
+				GFP_KERNEL);
+	if (cmt->channels == NULL) {
+		ret = -ENOMEM;
+		goto err_unmap;
 	}
 
-	platform_set_drvdata(pdev, p);
+	if (cmt->legacy) {
+		ret = sh_cmt_setup_channel(&cmt->channels[0],
+					   cfg->timer_bit, cfg->timer_bit,
+					   cfg->clockevent_rating != 0,
+					   cfg->clocksource_rating != 0, cmt);
+		if (ret < 0)
+			goto err_unmap;
+	} else {
+		unsigned int mask = hw_channels;
+		unsigned int i;
+
+		/*
+		 * Use the first channel as a clock event device and the second
+		 * channel as a clock source. If only one channel is available
+		 * use it for both.
+		 */
+		for (i = 0; i < cmt->num_channels; ++i) {
+			unsigned int hwidx = ffs(mask) - 1;
+			bool clocksource = i == 1 || cmt->num_channels == 1;
+			bool clockevent = i == 0;
+
+			ret = sh_cmt_setup_channel(&cmt->channels[i], i, hwidx,
+						   clockevent, clocksource,
+						   cmt);
+			if (ret < 0)
+				goto err_unmap;
+
+			mask &= ~(1 << hwidx);
+		}
+	}
+
+	platform_set_drvdata(pdev, cmt);
 
 	return 0;
-err4:
-	clk_unprepare(p->clk);
-err3:
-	clk_put(p->clk);
-err2:
-	iounmap(p->mapbase_str);
-err1:
-	iounmap(p->mapbase);
-err0:
+
+err_unmap:
+	kfree(cmt->channels);
+	sh_cmt_unmap_memory(cmt);
+err_clk_unprepare:
+	clk_unprepare(cmt->clk);
+err_clk_put:
+	clk_put(cmt->clk);
 	return ret;
 }
 
 static int sh_cmt_probe(struct platform_device *pdev)
 {
-	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
+	struct sh_cmt_device *cmt = platform_get_drvdata(pdev);
 	int ret;
 
 	if (!is_early_platform_device(pdev)) {
@@ -818,20 +1100,18 @@ static int sh_cmt_probe(struct platform_device *pdev)
 		pm_runtime_enable(&pdev->dev);
 	}
 
-	if (p) {
+	if (cmt) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
 		goto out;
 	}
 
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	cmt = kzalloc(sizeof(*cmt), GFP_KERNEL);
+	if (cmt == NULL)
 		return -ENOMEM;
-	}
 
-	ret = sh_cmt_setup(p, pdev);
+	ret = sh_cmt_setup(cmt, pdev);
 	if (ret) {
-		kfree(p);
+		kfree(cmt);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
@@ -839,7 +1119,7 @@ static int sh_cmt_probe(struct platform_device *pdev)
 		return 0;
 
  out:
-	if (cfg->clockevent_rating || cfg->clocksource_rating)
+	if (cmt->has_clockevent || cmt->has_clocksource)
 		pm_runtime_irq_safe(&pdev->dev);
 	else
 		pm_runtime_idle(&pdev->dev);
@@ -852,12 +1132,24 @@ static int sh_cmt_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
+static const struct platform_device_id sh_cmt_id_table[] = {
+	{ "sh_cmt", 0 },
+	{ "sh-cmt-16", (kernel_ulong_t)&sh_cmt_info[SH_CMT_16BIT] },
+	{ "sh-cmt-32", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT] },
+	{ "sh-cmt-32-fast", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT_FAST] },
+	{ "sh-cmt-48", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT] },
+	{ "sh-cmt-48-gen2", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT_GEN2] },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, sh_cmt_id_table);
+
 static struct platform_driver sh_cmt_device_driver = {
 	.probe		= sh_cmt_probe,
 	.remove		= sh_cmt_remove,
 	.driver		= {
 		.name	= "sh_cmt",
-	}
+	},
+	.id_table	= sh_cmt_id_table,
 };
 
 static int __init sh_cmt_init(void)
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index e30d76e..188d4e0 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -11,37 +11,48 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/clk.h>
+#include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/err.h>
-#include <linux/clockchips.h>
-#include <linux/sh_timer.h>
-#include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
+#include <linux/sh_timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+struct sh_mtu2_device;
+
+struct sh_mtu2_channel {
+	struct sh_mtu2_device *mtu;
+	unsigned int index;
+
+	void __iomem *base;
+	int irq;
+
+	struct clock_event_device ced;
+};
+
+struct sh_mtu2_device {
+	struct platform_device *pdev;
 
-struct sh_mtu2_priv {
 	void __iomem *mapbase;
 	struct clk *clk;
-	struct irqaction irqaction;
-	struct platform_device *pdev;
-	unsigned long rate;
-	unsigned long periodic;
-	struct clock_event_device ced;
+
+	struct sh_mtu2_channel *channels;
+	unsigned int num_channels;
+
+	bool legacy;
+	bool has_clockevent;
 };
 
 static DEFINE_RAW_SPINLOCK(sh_mtu2_lock);
@@ -55,6 +66,88 @@ static DEFINE_RAW_SPINLOCK(sh_mtu2_lock);
 #define TCNT 5 /* channel register */
 #define TGR  6 /* channel register */
 
+#define TCR_CCLR_NONE		(0 << 5)
+#define TCR_CCLR_TGRA		(1 << 5)
+#define TCR_CCLR_TGRB		(2 << 5)
+#define TCR_CCLR_SYNC		(3 << 5)
+#define TCR_CCLR_TGRC		(5 << 5)
+#define TCR_CCLR_TGRD		(6 << 5)
+#define TCR_CCLR_MASK		(7 << 5)
+#define TCR_CKEG_RISING		(0 << 3)
+#define TCR_CKEG_FALLING	(1 << 3)
+#define TCR_CKEG_BOTH		(2 << 3)
+#define TCR_CKEG_MASK		(3 << 3)
+/* Values 4 to 7 are channel-dependent */
+#define TCR_TPSC_P1		(0 << 0)
+#define TCR_TPSC_P4		(1 << 0)
+#define TCR_TPSC_P16		(2 << 0)
+#define TCR_TPSC_P64		(3 << 0)
+#define TCR_TPSC_CH0_TCLKA	(4 << 0)
+#define TCR_TPSC_CH0_TCLKB	(5 << 0)
+#define TCR_TPSC_CH0_TCLKC	(6 << 0)
+#define TCR_TPSC_CH0_TCLKD	(7 << 0)
+#define TCR_TPSC_CH1_TCLKA	(4 << 0)
+#define TCR_TPSC_CH1_TCLKB	(5 << 0)
+#define TCR_TPSC_CH1_P256	(6 << 0)
+#define TCR_TPSC_CH1_TCNT2	(7 << 0)
+#define TCR_TPSC_CH2_TCLKA	(4 << 0)
+#define TCR_TPSC_CH2_TCLKB	(5 << 0)
+#define TCR_TPSC_CH2_TCLKC	(6 << 0)
+#define TCR_TPSC_CH2_P1024	(7 << 0)
+#define TCR_TPSC_CH34_P256	(4 << 0)
+#define TCR_TPSC_CH34_P1024	(5 << 0)
+#define TCR_TPSC_CH34_TCLKA	(6 << 0)
+#define TCR_TPSC_CH34_TCLKB	(7 << 0)
+#define TCR_TPSC_MASK		(7 << 0)
+
+#define TMDR_BFE		(1 << 6)
+#define TMDR_BFB		(1 << 5)
+#define TMDR_BFA		(1 << 4)
+#define TMDR_MD_NORMAL		(0 << 0)
+#define TMDR_MD_PWM_1		(2 << 0)
+#define TMDR_MD_PWM_2		(3 << 0)
+#define TMDR_MD_PHASE_1		(4 << 0)
+#define TMDR_MD_PHASE_2		(5 << 0)
+#define TMDR_MD_PHASE_3		(6 << 0)
+#define TMDR_MD_PHASE_4		(7 << 0)
+#define TMDR_MD_PWM_SYNC	(8 << 0)
+#define TMDR_MD_PWM_COMP_CREST	(13 << 0)
+#define TMDR_MD_PWM_COMP_TROUGH	(14 << 0)
+#define TMDR_MD_PWM_COMP_BOTH	(15 << 0)
+#define TMDR_MD_MASK		(15 << 0)
+
+#define TIOC_IOCH(n)		((n) << 4)
+#define TIOC_IOCL(n)		((n) << 0)
+#define TIOR_OC_RETAIN		(0 << 0)
+#define TIOR_OC_0_CLEAR		(1 << 0)
+#define TIOR_OC_0_SET		(2 << 0)
+#define TIOR_OC_0_TOGGLE	(3 << 0)
+#define TIOR_OC_1_CLEAR		(5 << 0)
+#define TIOR_OC_1_SET		(6 << 0)
+#define TIOR_OC_1_TOGGLE	(7 << 0)
+#define TIOR_IC_RISING		(8 << 0)
+#define TIOR_IC_FALLING		(9 << 0)
+#define TIOR_IC_BOTH		(10 << 0)
+#define TIOR_IC_TCNT		(12 << 0)
+#define TIOR_MASK		(15 << 0)
+
+#define TIER_TTGE		(1 << 7)
+#define TIER_TTGE2		(1 << 6)
+#define TIER_TCIEU		(1 << 5)
+#define TIER_TCIEV		(1 << 4)
+#define TIER_TGIED		(1 << 3)
+#define TIER_TGIEC		(1 << 2)
+#define TIER_TGIEB		(1 << 1)
+#define TIER_TGIEA		(1 << 0)
+
+#define TSR_TCFD		(1 << 7)
+#define TSR_TCFU		(1 << 5)
+#define TSR_TCFV		(1 << 4)
+#define TSR_TGFD		(1 << 3)
+#define TSR_TGFC		(1 << 2)
+#define TSR_TGFB		(1 << 1)
+#define TSR_TGFA		(1 << 0)
+
 static unsigned long mtu2_reg_offs[] = {
 	[TCR] = 0,
 	[TMDR] = 1,
@@ -65,135 +158,143 @@ static unsigned long mtu2_reg_offs[] = {
 	[TGR] = 8,
 };
 
-static inline unsigned long sh_mtu2_read(struct sh_mtu2_priv *p, int reg_nr)
+static inline unsigned long sh_mtu2_read(struct sh_mtu2_channel *ch, int reg_nr)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
-	void __iomem *base = p->mapbase;
 	unsigned long offs;
 
-	if (reg_nr == TSTR)
-		return ioread8(base + cfg->channel_offset);
+	if (reg_nr == TSTR) {
+		if (ch->mtu->legacy)
+			return ioread8(ch->mtu->mapbase);
+		else
+			return ioread8(ch->mtu->mapbase + 0x280);
+	}
 
 	offs = mtu2_reg_offs[reg_nr];
 
 	if ((reg_nr == TCNT) || (reg_nr == TGR))
-		return ioread16(base + offs);
+		return ioread16(ch->base + offs);
 	else
-		return ioread8(base + offs);
+		return ioread8(ch->base + offs);
 }
 
-static inline void sh_mtu2_write(struct sh_mtu2_priv *p, int reg_nr,
+static inline void sh_mtu2_write(struct sh_mtu2_channel *ch, int reg_nr,
 				unsigned long value)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
-	void __iomem *base = p->mapbase;
 	unsigned long offs;
 
 	if (reg_nr == TSTR) {
-		iowrite8(value, base + cfg->channel_offset);
-		return;
+		if (ch->mtu->legacy)
+			return iowrite8(value, ch->mtu->mapbase);
+		else
+			return iowrite8(value, ch->mtu->mapbase + 0x280);
 	}
 
 	offs = mtu2_reg_offs[reg_nr];
 
 	if ((reg_nr == TCNT) || (reg_nr == TGR))
-		iowrite16(value, base + offs);
+		iowrite16(value, ch->base + offs);
 	else
-		iowrite8(value, base + offs);
+		iowrite8(value, ch->base + offs);
 }
 
-static void sh_mtu2_start_stop_ch(struct sh_mtu2_priv *p, int start)
+static void sh_mtu2_start_stop_ch(struct sh_mtu2_channel *ch, int start)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
 	raw_spin_lock_irqsave(&sh_mtu2_lock, flags);
-	value = sh_mtu2_read(p, TSTR);
+	value = sh_mtu2_read(ch, TSTR);
 
 	if (start)
-		value |= 1 << cfg->timer_bit;
+		value |= 1 << ch->index;
 	else
-		value &= ~(1 << cfg->timer_bit);
+		value &= ~(1 << ch->index);
 
-	sh_mtu2_write(p, TSTR, value);
+	sh_mtu2_write(ch, TSTR, value);
 	raw_spin_unlock_irqrestore(&sh_mtu2_lock, flags);
 }
 
-static int sh_mtu2_enable(struct sh_mtu2_priv *p)
+static int sh_mtu2_enable(struct sh_mtu2_channel *ch)
 {
+	unsigned long periodic;
+	unsigned long rate;
 	int ret;
 
-	pm_runtime_get_sync(&p->pdev->dev);
-	dev_pm_syscore_device(&p->pdev->dev, true);
+	pm_runtime_get_sync(&ch->mtu->pdev->dev);
+	dev_pm_syscore_device(&ch->mtu->pdev->dev, true);
 
 	/* enable clock */
-	ret = clk_enable(p->clk);
+	ret = clk_enable(ch->mtu->clk);
 	if (ret) {
-		dev_err(&p->pdev->dev, "cannot enable clock\n");
+		dev_err(&ch->mtu->pdev->dev, "ch%u: cannot enable clock\n",
+			ch->index);
 		return ret;
 	}
 
 	/* make sure channel is disabled */
-	sh_mtu2_start_stop_ch(p, 0);
-
-	p->rate = clk_get_rate(p->clk) / 64;
-	p->periodic = (p->rate + HZ/2) / HZ;
-
-	/* "Periodic Counter Operation" */
-	sh_mtu2_write(p, TCR, 0x23); /* TGRA clear, divide clock by 64 */
-	sh_mtu2_write(p, TIOR, 0);
-	sh_mtu2_write(p, TGR, p->periodic);
-	sh_mtu2_write(p, TCNT, 0);
-	sh_mtu2_write(p, TMDR, 0);
-	sh_mtu2_write(p, TIER, 0x01);
+	sh_mtu2_start_stop_ch(ch, 0);
+
+	rate = clk_get_rate(ch->mtu->clk) / 64;
+	periodic = (rate + HZ/2) / HZ;
+
+	/*
+	 * "Periodic Counter Operation"
+	 * Clear on TGRA compare match, divide clock by 64.
+	 */
+	sh_mtu2_write(ch, TCR, TCR_CCLR_TGRA | TCR_TPSC_P64);
+	sh_mtu2_write(ch, TIOR, TIOC_IOCH(TIOR_OC_0_CLEAR) |
+		      TIOC_IOCL(TIOR_OC_0_CLEAR));
+	sh_mtu2_write(ch, TGR, periodic);
+	sh_mtu2_write(ch, TCNT, 0);
+	sh_mtu2_write(ch, TMDR, TMDR_MD_NORMAL);
+	sh_mtu2_write(ch, TIER, TIER_TGIEA);
 
 	/* enable channel */
-	sh_mtu2_start_stop_ch(p, 1);
+	sh_mtu2_start_stop_ch(ch, 1);
 
 	return 0;
 }
 
-static void sh_mtu2_disable(struct sh_mtu2_priv *p)
+static void sh_mtu2_disable(struct sh_mtu2_channel *ch)
 {
 	/* disable channel */
-	sh_mtu2_start_stop_ch(p, 0);
+	sh_mtu2_start_stop_ch(ch, 0);
 
 	/* stop clock */
-	clk_disable(p->clk);
+	clk_disable(ch->mtu->clk);
 
-	dev_pm_syscore_device(&p->pdev->dev, false);
-	pm_runtime_put(&p->pdev->dev);
+	dev_pm_syscore_device(&ch->mtu->pdev->dev, false);
+	pm_runtime_put(&ch->mtu->pdev->dev);
 }
 
 static irqreturn_t sh_mtu2_interrupt(int irq, void *dev_id)
 {
-	struct sh_mtu2_priv *p = dev_id;
+	struct sh_mtu2_channel *ch = dev_id;
 
 	/* acknowledge interrupt */
-	sh_mtu2_read(p, TSR);
-	sh_mtu2_write(p, TSR, 0xfe);
+	sh_mtu2_read(ch, TSR);
+	sh_mtu2_write(ch, TSR, ~TSR_TGFA);
 
 	/* notify clockevent layer */
-	p->ced.event_handler(&p->ced);
+	ch->ced.event_handler(&ch->ced);
 	return IRQ_HANDLED;
 }
 
-static struct sh_mtu2_priv *ced_to_sh_mtu2(struct clock_event_device *ced)
+static struct sh_mtu2_channel *ced_to_sh_mtu2(struct clock_event_device *ced)
 {
-	return container_of(ced, struct sh_mtu2_priv, ced);
+	return container_of(ced, struct sh_mtu2_channel, ced);
 }
 
 static void sh_mtu2_clock_event_mode(enum clock_event_mode mode,
 				    struct clock_event_device *ced)
 {
-	struct sh_mtu2_priv *p = ced_to_sh_mtu2(ced);
+	struct sh_mtu2_channel *ch = ced_to_sh_mtu2(ced);
 	int disabled = 0;
 
 	/* deal with old setting first */
 	switch (ced->mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		sh_mtu2_disable(p);
+		sh_mtu2_disable(ch);
 		disabled = 1;
 		break;
 	default:
@@ -202,12 +303,13 @@ static void sh_mtu2_clock_event_mode(enum clock_event_mode mode,
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		dev_info(&p->pdev->dev, "used for periodic clock events\n");
-		sh_mtu2_enable(p);
+		dev_info(&ch->mtu->pdev->dev,
+			 "ch%u: used for periodic clock events\n", ch->index);
+		sh_mtu2_enable(ch);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 		if (!disabled)
-			sh_mtu2_disable(p);
+			sh_mtu2_disable(ch);
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
@@ -217,125 +319,207 @@ static void sh_mtu2_clock_event_mode(enum clock_event_mode mode,
 
 static void sh_mtu2_clock_event_suspend(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweroff(&ced_to_sh_mtu2(ced)->pdev->dev);
+	pm_genpd_syscore_poweroff(&ced_to_sh_mtu2(ced)->mtu->pdev->dev);
 }
 
 static void sh_mtu2_clock_event_resume(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweron(&ced_to_sh_mtu2(ced)->pdev->dev);
+	pm_genpd_syscore_poweron(&ced_to_sh_mtu2(ced)->mtu->pdev->dev);
 }
 
-static void sh_mtu2_register_clockevent(struct sh_mtu2_priv *p,
-				       char *name, unsigned long rating)
+static void sh_mtu2_register_clockevent(struct sh_mtu2_channel *ch,
+					const char *name)
 {
-	struct clock_event_device *ced = &p->ced;
+	struct clock_event_device *ced = &ch->ced;
 	int ret;
 
-	memset(ced, 0, sizeof(*ced));
-
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
-	ced->rating = rating;
-	ced->cpumask = cpumask_of(0);
+	ced->rating = 200;
+	ced->cpumask = cpu_possible_mask;
 	ced->set_mode = sh_mtu2_clock_event_mode;
 	ced->suspend = sh_mtu2_clock_event_suspend;
 	ced->resume = sh_mtu2_clock_event_resume;
 
-	dev_info(&p->pdev->dev, "used for clock events\n");
+	dev_info(&ch->mtu->pdev->dev, "ch%u: used for clock events\n",
+		 ch->index);
 	clockevents_register_device(ced);
 
-	ret = setup_irq(p->irqaction.irq, &p->irqaction);
+	ret = request_irq(ch->irq, sh_mtu2_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			  dev_name(&ch->mtu->pdev->dev), ch);
 	if (ret) {
-		dev_err(&p->pdev->dev, "failed to request irq %d\n",
-			p->irqaction.irq);
+		dev_err(&ch->mtu->pdev->dev, "ch%u: failed to request irq %d\n",
+			ch->index, ch->irq);
 		return;
 	}
 }
 
-static int sh_mtu2_register(struct sh_mtu2_priv *p, char *name,
-			    unsigned long clockevent_rating)
+static int sh_mtu2_register(struct sh_mtu2_channel *ch, const char *name,
+			    bool clockevent)
 {
-	if (clockevent_rating)
-		sh_mtu2_register_clockevent(p, name, clockevent_rating);
+	if (clockevent) {
+		ch->mtu->has_clockevent = true;
+		sh_mtu2_register_clockevent(ch, name);
+	}
 
 	return 0;
 }
 
-static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
+static int sh_mtu2_setup_channel(struct sh_mtu2_channel *ch, unsigned int index,
+				 struct sh_mtu2_device *mtu)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	struct resource *res;
-	int irq, ret;
-	ret = -ENXIO;
+	static const unsigned int channel_offsets[] = {
+		0x300, 0x380, 0x000,
+	};
+	bool clockevent;
+
+	ch->mtu = mtu;
+
+	if (mtu->legacy) {
+		struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
+
+		clockevent = cfg->clockevent_rating != 0;
 
-	memset(p, 0, sizeof(*p));
-	p->pdev = pdev;
+		ch->irq = platform_get_irq(mtu->pdev, 0);
+		ch->base = mtu->mapbase - cfg->channel_offset;
+		ch->index = cfg->timer_bit;
+	} else {
+		char name[6];
 
-	if (!cfg) {
-		dev_err(&p->pdev->dev, "missing platform data\n");
-		goto err0;
+		clockevent = true;
+
+		sprintf(name, "tgi%ua", index);
+		ch->irq = platform_get_irq_byname(mtu->pdev, name);
+		ch->base = mtu->mapbase + channel_offsets[index];
+		ch->index = index;
 	}
 
-	platform_set_drvdata(pdev, p);
+	if (ch->irq < 0) {
+		/* Skip channels with no declared interrupt. */
+		if (!mtu->legacy)
+			return 0;
+
+		dev_err(&mtu->pdev->dev, "ch%u: failed to get irq\n",
+			ch->index);
+		return ch->irq;
+	}
+
+	return sh_mtu2_register(ch, dev_name(&mtu->pdev->dev), clockevent);
+}
 
-	res = platform_get_resource(p->pdev, IORESOURCE_MEM, 0);
+static int sh_mtu2_map_memory(struct sh_mtu2_device *mtu)
+{
+	struct resource *res;
+
+	res = platform_get_resource(mtu->pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		dev_err(&p->pdev->dev, "failed to get I/O memory\n");
-		goto err0;
+		dev_err(&mtu->pdev->dev, "failed to get I/O memory\n");
+		return -ENXIO;
+	}
+
+	mtu->mapbase = ioremap_nocache(res->start, resource_size(res));
+	if (mtu->mapbase == NULL)
+		return -ENXIO;
+
+	/*
+	 * In legacy platform device configuration (with one device per channel)
+	 * the resource points to the channel base address.
+	 */
+	if (mtu->legacy) {
+		struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
+		mtu->mapbase += cfg->channel_offset;
 	}
 
-	irq = platform_get_irq(p->pdev, 0);
-	if (irq < 0) {
-		dev_err(&p->pdev->dev, "failed to get irq\n");
-		goto err0;
+	return 0;
+}
+
+static void sh_mtu2_unmap_memory(struct sh_mtu2_device *mtu)
+{
+	if (mtu->legacy) {
+		struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
+		mtu->mapbase -= cfg->channel_offset;
 	}
 
-	/* map memory, let mapbase point to our channel */
-	p->mapbase = ioremap_nocache(res->start, resource_size(res));
-	if (p->mapbase == NULL) {
-		dev_err(&p->pdev->dev, "failed to remap I/O memory\n");
-		goto err0;
+	iounmap(mtu->mapbase);
+}
+
+static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
+			 struct platform_device *pdev)
+{
+	struct sh_timer_config *cfg = pdev->dev.platform_data;
+	const struct platform_device_id *id = pdev->id_entry;
+	unsigned int i;
+	int ret;
+
+	mtu->pdev = pdev;
+	mtu->legacy = id->driver_data;
+
+	if (mtu->legacy && !cfg) {
+		dev_err(&mtu->pdev->dev, "missing platform data\n");
+		return -ENXIO;
 	}
 
-	/* setup data for setup_irq() (too early for request_irq()) */
-	p->irqaction.name = dev_name(&p->pdev->dev);
-	p->irqaction.handler = sh_mtu2_interrupt;
-	p->irqaction.dev_id = p;
-	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
-
-	/* get hold of clock */
-	p->clk = clk_get(&p->pdev->dev, "mtu2_fck");
-	if (IS_ERR(p->clk)) {
-		dev_err(&p->pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(p->clk);
-		goto err1;
+	/* Get hold of clock. */
+	mtu->clk = clk_get(&mtu->pdev->dev, mtu->legacy ? "mtu2_fck" : "fck");
+	if (IS_ERR(mtu->clk)) {
+		dev_err(&mtu->pdev->dev, "cannot get clock\n");
+		return PTR_ERR(mtu->clk);
 	}
 
-	ret = clk_prepare(p->clk);
+	ret = clk_prepare(mtu->clk);
 	if (ret < 0)
-		goto err2;
+		goto err_clk_put;
 
-	ret = sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
-			       cfg->clockevent_rating);
-	if (ret < 0)
-		goto err3;
+	/* Map the memory resource. */
+	ret = sh_mtu2_map_memory(mtu);
+	if (ret < 0) {
+		dev_err(&mtu->pdev->dev, "failed to remap I/O memory\n");
+		goto err_clk_unprepare;
+	}
+
+	/* Allocate and setup the channels. */
+	if (mtu->legacy)
+		mtu->num_channels = 1;
+	else
+		mtu->num_channels = 3;
+
+	mtu->channels = kzalloc(sizeof(*mtu->channels) * mtu->num_channels,
+				GFP_KERNEL);
+	if (mtu->channels == NULL) {
+		ret = -ENOMEM;
+		goto err_unmap;
+	}
+
+	if (mtu->legacy) {
+		ret = sh_mtu2_setup_channel(&mtu->channels[0], 0, mtu);
+		if (ret < 0)
+			goto err_unmap;
+	} else {
+		for (i = 0; i < mtu->num_channels; ++i) {
+			ret = sh_mtu2_setup_channel(&mtu->channels[i], i, mtu);
+			if (ret < 0)
+				goto err_unmap;
+		}
+	}
+
+	platform_set_drvdata(pdev, mtu);
 
 	return 0;
- err3:
-	clk_unprepare(p->clk);
- err2:
-	clk_put(p->clk);
- err1:
-	iounmap(p->mapbase);
- err0:
+
+err_unmap:
+	kfree(mtu->channels);
+	sh_mtu2_unmap_memory(mtu);
+err_clk_unprepare:
+	clk_unprepare(mtu->clk);
+err_clk_put:
+	clk_put(mtu->clk);
 	return ret;
 }
 
 static int sh_mtu2_probe(struct platform_device *pdev)
 {
-	struct sh_mtu2_priv *p = platform_get_drvdata(pdev);
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
+	struct sh_mtu2_device *mtu = platform_get_drvdata(pdev);
 	int ret;
 
 	if (!is_early_platform_device(pdev)) {
@@ -343,20 +527,18 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 		pm_runtime_enable(&pdev->dev);
 	}
 
-	if (p) {
+	if (mtu) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
 		goto out;
 	}
 
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	mtu = kzalloc(sizeof(*mtu), GFP_KERNEL);
+	if (mtu == NULL)
 		return -ENOMEM;
-	}
 
-	ret = sh_mtu2_setup(p, pdev);
+	ret = sh_mtu2_setup(mtu, pdev);
 	if (ret) {
-		kfree(p);
+		kfree(mtu);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
@@ -364,7 +546,7 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 		return 0;
 
  out:
-	if (cfg->clockevent_rating)
+	if (mtu->has_clockevent)
 		pm_runtime_irq_safe(&pdev->dev);
 	else
 		pm_runtime_idle(&pdev->dev);
@@ -377,12 +559,20 @@ static int sh_mtu2_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent */
 }
 
+static const struct platform_device_id sh_mtu2_id_table[] = {
+	{ "sh_mtu2", 1 },
+	{ "sh-mtu2", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, sh_mtu2_id_table);
+
 static struct platform_driver sh_mtu2_device_driver = {
 	.probe		= sh_mtu2_probe,
 	.remove		= sh_mtu2_remove,
 	.driver		= {
 		.name	= "sh_mtu2",
-	}
+	},
+	.id_table	= sh_mtu2_id_table,
 };
 
 static int __init sh_mtu2_init(void)
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index ecd7b60..6bd17a8 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -11,35 +11,41 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/clk.h>
+#include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/err.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-#include <linux/sh_timer.h>
-#include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
+#include <linux/sh_timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+enum sh_tmu_model {
+	SH_TMU_LEGACY,
+	SH_TMU,
+	SH_TMU_SH3,
+};
+
+struct sh_tmu_device;
+
+struct sh_tmu_channel {
+	struct sh_tmu_device *tmu;
+	unsigned int index;
+
+	void __iomem *base;
+	int irq;
 
-struct sh_tmu_priv {
-	void __iomem *mapbase;
-	struct clk *clk;
-	struct irqaction irqaction;
-	struct platform_device *pdev;
 	unsigned long rate;
 	unsigned long periodic;
 	struct clock_event_device ced;
@@ -48,6 +54,21 @@ struct sh_tmu_priv {
 	unsigned int enable_count;
 };
 
+struct sh_tmu_device {
+	struct platform_device *pdev;
+
+	void __iomem *mapbase;
+	struct clk *clk;
+
+	enum sh_tmu_model model;
+
+	struct sh_tmu_channel *channels;
+	unsigned int num_channels;
+
+	bool has_clockevent;
+	bool has_clocksource;
+};
+
 static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
 
 #define TSTR -1 /* shared register */
@@ -55,189 +76,208 @@ static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
 #define TCNT 1 /* channel register */
 #define TCR 2 /* channel register */
 
-static inline unsigned long sh_tmu_read(struct sh_tmu_priv *p, int reg_nr)
+#define TCR_UNF			(1 << 8)
+#define TCR_UNIE		(1 << 5)
+#define TCR_TPSC_CLK4		(0 << 0)
+#define TCR_TPSC_CLK16		(1 << 0)
+#define TCR_TPSC_CLK64		(2 << 0)
+#define TCR_TPSC_CLK256		(3 << 0)
+#define TCR_TPSC_CLK1024	(4 << 0)
+#define TCR_TPSC_MASK		(7 << 0)
+
+static inline unsigned long sh_tmu_read(struct sh_tmu_channel *ch, int reg_nr)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
-	void __iomem *base = p->mapbase;
 	unsigned long offs;
 
-	if (reg_nr == TSTR)
-		return ioread8(base - cfg->channel_offset);
+	if (reg_nr == TSTR) {
+		switch (ch->tmu->model) {
+		case SH_TMU_LEGACY:
+			return ioread8(ch->tmu->mapbase);
+		case SH_TMU_SH3:
+			return ioread8(ch->tmu->mapbase + 2);
+		case SH_TMU:
+			return ioread8(ch->tmu->mapbase + 4);
+		}
+	}
 
 	offs = reg_nr << 2;
 
 	if (reg_nr == TCR)
-		return ioread16(base + offs);
+		return ioread16(ch->base + offs);
 	else
-		return ioread32(base + offs);
+		return ioread32(ch->base + offs);
 }
 
-static inline void sh_tmu_write(struct sh_tmu_priv *p, int reg_nr,
+static inline void sh_tmu_write(struct sh_tmu_channel *ch, int reg_nr,
 				unsigned long value)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
-	void __iomem *base = p->mapbase;
 	unsigned long offs;
 
 	if (reg_nr == TSTR) {
-		iowrite8(value, base - cfg->channel_offset);
-		return;
+		switch (ch->tmu->model) {
+		case SH_TMU_LEGACY:
+			return iowrite8(value, ch->tmu->mapbase);
+		case SH_TMU_SH3:
+			return iowrite8(value, ch->tmu->mapbase + 2);
+		case SH_TMU:
+			return iowrite8(value, ch->tmu->mapbase + 4);
+		}
 	}
 
 	offs = reg_nr << 2;
 
 	if (reg_nr == TCR)
-		iowrite16(value, base + offs);
+		iowrite16(value, ch->base + offs);
 	else
-		iowrite32(value, base + offs);
+		iowrite32(value, ch->base + offs);
 }
 
-static void sh_tmu_start_stop_ch(struct sh_tmu_priv *p, int start)
+static void sh_tmu_start_stop_ch(struct sh_tmu_channel *ch, int start)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
 	raw_spin_lock_irqsave(&sh_tmu_lock, flags);
-	value = sh_tmu_read(p, TSTR);
+	value = sh_tmu_read(ch, TSTR);
 
 	if (start)
-		value |= 1 << cfg->timer_bit;
+		value |= 1 << ch->index;
 	else
-		value &= ~(1 << cfg->timer_bit);
+		value &= ~(1 << ch->index);
 
-	sh_tmu_write(p, TSTR, value);
+	sh_tmu_write(ch, TSTR, value);
 	raw_spin_unlock_irqrestore(&sh_tmu_lock, flags);
 }
 
-static int __sh_tmu_enable(struct sh_tmu_priv *p)
+static int __sh_tmu_enable(struct sh_tmu_channel *ch)
 {
 	int ret;
 
 	/* enable clock */
-	ret = clk_enable(p->clk);
+	ret = clk_enable(ch->tmu->clk);
 	if (ret) {
-		dev_err(&p->pdev->dev, "cannot enable clock\n");
+		dev_err(&ch->tmu->pdev->dev, "ch%u: cannot enable clock\n",
+			ch->index);
 		return ret;
 	}
 
 	/* make sure channel is disabled */
-	sh_tmu_start_stop_ch(p, 0);
+	sh_tmu_start_stop_ch(ch, 0);
 
 	/* maximum timeout */
-	sh_tmu_write(p, TCOR, 0xffffffff);
-	sh_tmu_write(p, TCNT, 0xffffffff);
+	sh_tmu_write(ch, TCOR, 0xffffffff);
+	sh_tmu_write(ch, TCNT, 0xffffffff);
 
 	/* configure channel to parent clock / 4, irq off */
-	p->rate = clk_get_rate(p->clk) / 4;
-	sh_tmu_write(p, TCR, 0x0000);
+	ch->rate = clk_get_rate(ch->tmu->clk) / 4;
+	sh_tmu_write(ch, TCR, TCR_TPSC_CLK4);
 
 	/* enable channel */
-	sh_tmu_start_stop_ch(p, 1);
+	sh_tmu_start_stop_ch(ch, 1);
 
 	return 0;
 }
 
-static int sh_tmu_enable(struct sh_tmu_priv *p)
+static int sh_tmu_enable(struct sh_tmu_channel *ch)
 {
-	if (p->enable_count++ > 0)
+	if (ch->enable_count++ > 0)
 		return 0;
 
-	pm_runtime_get_sync(&p->pdev->dev);
-	dev_pm_syscore_device(&p->pdev->dev, true);
+	pm_runtime_get_sync(&ch->tmu->pdev->dev);
+	dev_pm_syscore_device(&ch->tmu->pdev->dev, true);
 
-	return __sh_tmu_enable(p);
+	return __sh_tmu_enable(ch);
 }
 
-static void __sh_tmu_disable(struct sh_tmu_priv *p)
+static void __sh_tmu_disable(struct sh_tmu_channel *ch)
 {
 	/* disable channel */
-	sh_tmu_start_stop_ch(p, 0);
+	sh_tmu_start_stop_ch(ch, 0);
 
 	/* disable interrupts in TMU block */
-	sh_tmu_write(p, TCR, 0x0000);
+	sh_tmu_write(ch, TCR, TCR_TPSC_CLK4);
 
 	/* stop clock */
-	clk_disable(p->clk);
+	clk_disable(ch->tmu->clk);
 }
 
-static void sh_tmu_disable(struct sh_tmu_priv *p)
+static void sh_tmu_disable(struct sh_tmu_channel *ch)
 {
-	if (WARN_ON(p->enable_count == 0))
+	if (WARN_ON(ch->enable_count == 0))
 		return;
 
-	if (--p->enable_count > 0)
+	if (--ch->enable_count > 0)
 		return;
 
-	__sh_tmu_disable(p);
+	__sh_tmu_disable(ch);
 
-	dev_pm_syscore_device(&p->pdev->dev, false);
-	pm_runtime_put(&p->pdev->dev);
+	dev_pm_syscore_device(&ch->tmu->pdev->dev, false);
+	pm_runtime_put(&ch->tmu->pdev->dev);
 }
 
-static void sh_tmu_set_next(struct sh_tmu_priv *p, unsigned long delta,
+static void sh_tmu_set_next(struct sh_tmu_channel *ch, unsigned long delta,
 			    int periodic)
 {
 	/* stop timer */
-	sh_tmu_start_stop_ch(p, 0);
+	sh_tmu_start_stop_ch(ch, 0);
 
 	/* acknowledge interrupt */
-	sh_tmu_read(p, TCR);
+	sh_tmu_read(ch, TCR);
 
 	/* enable interrupt */
-	sh_tmu_write(p, TCR, 0x0020);
+	sh_tmu_write(ch, TCR, TCR_UNIE | TCR_TPSC_CLK4);
 
 	/* reload delta value in case of periodic timer */
 	if (periodic)
-		sh_tmu_write(p, TCOR, delta);
+		sh_tmu_write(ch, TCOR, delta);
 	else
-		sh_tmu_write(p, TCOR, 0xffffffff);
+		sh_tmu_write(ch, TCOR, 0xffffffff);
 
-	sh_tmu_write(p, TCNT, delta);
+	sh_tmu_write(ch, TCNT, delta);
 
 	/* start timer */
-	sh_tmu_start_stop_ch(p, 1);
+	sh_tmu_start_stop_ch(ch, 1);
 }
 
 static irqreturn_t sh_tmu_interrupt(int irq, void *dev_id)
 {
-	struct sh_tmu_priv *p = dev_id;
+	struct sh_tmu_channel *ch = dev_id;
 
 	/* disable or acknowledge interrupt */
-	if (p->ced.mode == CLOCK_EVT_MODE_ONESHOT)
-		sh_tmu_write(p, TCR, 0x0000);
+	if (ch->ced.mode == CLOCK_EVT_MODE_ONESHOT)
+		sh_tmu_write(ch, TCR, TCR_TPSC_CLK4);
 	else
-		sh_tmu_write(p, TCR, 0x0020);
+		sh_tmu_write(ch, TCR, TCR_UNIE | TCR_TPSC_CLK4);
 
 	/* notify clockevent layer */
-	p->ced.event_handler(&p->ced);
+	ch->ced.event_handler(&ch->ced);
 	return IRQ_HANDLED;
 }
 
-static struct sh_tmu_priv *cs_to_sh_tmu(struct clocksource *cs)
+static struct sh_tmu_channel *cs_to_sh_tmu(struct clocksource *cs)
 {
-	return container_of(cs, struct sh_tmu_priv, cs);
+	return container_of(cs, struct sh_tmu_channel, cs);
 }
 
 static cycle_t sh_tmu_clocksource_read(struct clocksource *cs)
 {
-	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+	struct sh_tmu_channel *ch = cs_to_sh_tmu(cs);
 
-	return sh_tmu_read(p, TCNT) ^ 0xffffffff;
+	return sh_tmu_read(ch, TCNT) ^ 0xffffffff;
 }
 
 static int sh_tmu_clocksource_enable(struct clocksource *cs)
 {
-	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+	struct sh_tmu_channel *ch = cs_to_sh_tmu(cs);
 	int ret;
 
-	if (WARN_ON(p->cs_enabled))
+	if (WARN_ON(ch->cs_enabled))
 		return 0;
 
-	ret = sh_tmu_enable(p);
+	ret = sh_tmu_enable(ch);
 	if (!ret) {
-		__clocksource_updatefreq_hz(cs, p->rate);
-		p->cs_enabled = true;
+		__clocksource_updatefreq_hz(cs, ch->rate);
+		ch->cs_enabled = true;
 	}
 
 	return ret;
@@ -245,48 +285,48 @@ static int sh_tmu_clocksource_enable(struct clocksource *cs)
 
 static void sh_tmu_clocksource_disable(struct clocksource *cs)
 {
-	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+	struct sh_tmu_channel *ch = cs_to_sh_tmu(cs);
 
-	if (WARN_ON(!p->cs_enabled))
+	if (WARN_ON(!ch->cs_enabled))
 		return;
 
-	sh_tmu_disable(p);
-	p->cs_enabled = false;
+	sh_tmu_disable(ch);
+	ch->cs_enabled = false;
 }
 
 static void sh_tmu_clocksource_suspend(struct clocksource *cs)
 {
-	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+	struct sh_tmu_channel *ch = cs_to_sh_tmu(cs);
 
-	if (!p->cs_enabled)
+	if (!ch->cs_enabled)
 		return;
 
-	if (--p->enable_count == 0) {
-		__sh_tmu_disable(p);
-		pm_genpd_syscore_poweroff(&p->pdev->dev);
+	if (--ch->enable_count == 0) {
+		__sh_tmu_disable(ch);
+		pm_genpd_syscore_poweroff(&ch->tmu->pdev->dev);
 	}
 }
 
 static void sh_tmu_clocksource_resume(struct clocksource *cs)
 {
-	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+	struct sh_tmu_channel *ch = cs_to_sh_tmu(cs);
 
-	if (!p->cs_enabled)
+	if (!ch->cs_enabled)
 		return;
 
-	if (p->enable_count++ == 0) {
-		pm_genpd_syscore_poweron(&p->pdev->dev);
-		__sh_tmu_enable(p);
+	if (ch->enable_count++ == 0) {
+		pm_genpd_syscore_poweron(&ch->tmu->pdev->dev);
+		__sh_tmu_enable(ch);
 	}
 }
 
-static int sh_tmu_register_clocksource(struct sh_tmu_priv *p,
-				       char *name, unsigned long rating)
+static int sh_tmu_register_clocksource(struct sh_tmu_channel *ch,
+				       const char *name)
 {
-	struct clocksource *cs = &p->cs;
+	struct clocksource *cs = &ch->cs;
 
 	cs->name = name;
-	cs->rating = rating;
+	cs->rating = 200;
 	cs->read = sh_tmu_clocksource_read;
 	cs->enable = sh_tmu_clocksource_enable;
 	cs->disable = sh_tmu_clocksource_disable;
@@ -295,43 +335,44 @@ static int sh_tmu_register_clocksource(struct sh_tmu_priv *p,
 	cs->mask = CLOCKSOURCE_MASK(32);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	dev_info(&p->pdev->dev, "used as clock source\n");
+	dev_info(&ch->tmu->pdev->dev, "ch%u: used as clock source\n",
+		 ch->index);
 
 	/* Register with dummy 1 Hz value, gets updated in ->enable() */
 	clocksource_register_hz(cs, 1);
 	return 0;
 }
 
-static struct sh_tmu_priv *ced_to_sh_tmu(struct clock_event_device *ced)
+static struct sh_tmu_channel *ced_to_sh_tmu(struct clock_event_device *ced)
 {
-	return container_of(ced, struct sh_tmu_priv, ced);
+	return container_of(ced, struct sh_tmu_channel, ced);
 }
 
-static void sh_tmu_clock_event_start(struct sh_tmu_priv *p, int periodic)
+static void sh_tmu_clock_event_start(struct sh_tmu_channel *ch, int periodic)
 {
-	struct clock_event_device *ced = &p->ced;
+	struct clock_event_device *ced = &ch->ced;
 
-	sh_tmu_enable(p);
+	sh_tmu_enable(ch);
 
-	clockevents_config(ced, p->rate);
+	clockevents_config(ced, ch->rate);
 
 	if (periodic) {
-		p->periodic = (p->rate + HZ/2) / HZ;
-		sh_tmu_set_next(p, p->periodic, 1);
+		ch->periodic = (ch->rate + HZ/2) / HZ;
+		sh_tmu_set_next(ch, ch->periodic, 1);
 	}
 }
 
 static void sh_tmu_clock_event_mode(enum clock_event_mode mode,
 				    struct clock_event_device *ced)
 {
-	struct sh_tmu_priv *p = ced_to_sh_tmu(ced);
+	struct sh_tmu_channel *ch = ced_to_sh_tmu(ced);
 	int disabled = 0;
 
 	/* deal with old setting first */
 	switch (ced->mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 	case CLOCK_EVT_MODE_ONESHOT:
-		sh_tmu_disable(p);
+		sh_tmu_disable(ch);
 		disabled = 1;
 		break;
 	default:
@@ -340,16 +381,18 @@ static void sh_tmu_clock_event_mode(enum clock_event_mode mode,
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		dev_info(&p->pdev->dev, "used for periodic clock events\n");
-		sh_tmu_clock_event_start(p, 1);
+		dev_info(&ch->tmu->pdev->dev,
+			 "ch%u: used for periodic clock events\n", ch->index);
+		sh_tmu_clock_event_start(ch, 1);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
-		dev_info(&p->pdev->dev, "used for oneshot clock events\n");
-		sh_tmu_clock_event_start(p, 0);
+		dev_info(&ch->tmu->pdev->dev,
+			 "ch%u: used for oneshot clock events\n", ch->index);
+		sh_tmu_clock_event_start(ch, 0);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 		if (!disabled)
-			sh_tmu_disable(p);
+			sh_tmu_disable(ch);
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
@@ -360,147 +403,234 @@ static void sh_tmu_clock_event_mode(enum clock_event_mode mode,
 static int sh_tmu_clock_event_next(unsigned long delta,
 				   struct clock_event_device *ced)
 {
-	struct sh_tmu_priv *p = ced_to_sh_tmu(ced);
+	struct sh_tmu_channel *ch = ced_to_sh_tmu(ced);
 
 	BUG_ON(ced->mode != CLOCK_EVT_MODE_ONESHOT);
 
 	/* program new delta value */
-	sh_tmu_set_next(p, delta, 0);
+	sh_tmu_set_next(ch, delta, 0);
 	return 0;
 }
 
 static void sh_tmu_clock_event_suspend(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweroff(&ced_to_sh_tmu(ced)->pdev->dev);
+	pm_genpd_syscore_poweroff(&ced_to_sh_tmu(ced)->tmu->pdev->dev);
 }
 
 static void sh_tmu_clock_event_resume(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweron(&ced_to_sh_tmu(ced)->pdev->dev);
+	pm_genpd_syscore_poweron(&ced_to_sh_tmu(ced)->tmu->pdev->dev);
 }
 
-static void sh_tmu_register_clockevent(struct sh_tmu_priv *p,
-				       char *name, unsigned long rating)
+static void sh_tmu_register_clockevent(struct sh_tmu_channel *ch,
+				       const char *name)
 {
-	struct clock_event_device *ced = &p->ced;
+	struct clock_event_device *ced = &ch->ced;
 	int ret;
 
-	memset(ced, 0, sizeof(*ced));
-
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
-	ced->rating = rating;
+	ced->rating = 200;
 	ced->cpumask = cpumask_of(0);
 	ced->set_next_event = sh_tmu_clock_event_next;
 	ced->set_mode = sh_tmu_clock_event_mode;
 	ced->suspend = sh_tmu_clock_event_suspend;
 	ced->resume = sh_tmu_clock_event_resume;
 
-	dev_info(&p->pdev->dev, "used for clock events\n");
+	dev_info(&ch->tmu->pdev->dev, "ch%u: used for clock events\n",
+		 ch->index);
 
 	clockevents_config_and_register(ced, 1, 0x300, 0xffffffff);
 
-	ret = setup_irq(p->irqaction.irq, &p->irqaction);
+	ret = request_irq(ch->irq, sh_tmu_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			  dev_name(&ch->tmu->pdev->dev), ch);
 	if (ret) {
-		dev_err(&p->pdev->dev, "failed to request irq %d\n",
-			p->irqaction.irq);
+		dev_err(&ch->tmu->pdev->dev, "ch%u: failed to request irq %d\n",
+			ch->index, ch->irq);
 		return;
 	}
 }
 
-static int sh_tmu_register(struct sh_tmu_priv *p, char *name,
-		    unsigned long clockevent_rating,
-		    unsigned long clocksource_rating)
+static int sh_tmu_register(struct sh_tmu_channel *ch, const char *name,
+			   bool clockevent, bool clocksource)
 {
-	if (clockevent_rating)
-		sh_tmu_register_clockevent(p, name, clockevent_rating);
-	else if (clocksource_rating)
-		sh_tmu_register_clocksource(p, name, clocksource_rating);
+	if (clockevent) {
+		ch->tmu->has_clockevent = true;
+		sh_tmu_register_clockevent(ch, name);
+	} else if (clocksource) {
+		ch->tmu->has_clocksource = true;
+		sh_tmu_register_clocksource(ch, name);
+	}
 
 	return 0;
 }
 
-static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
+static int sh_tmu_channel_setup(struct sh_tmu_channel *ch, unsigned int index,
+				bool clockevent, bool clocksource,
+				struct sh_tmu_device *tmu)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	struct resource *res;
-	int irq, ret;
-	ret = -ENXIO;
+	/* Skip unused channels. */
+	if (!clockevent && !clocksource)
+		return 0;
 
-	memset(p, 0, sizeof(*p));
-	p->pdev = pdev;
+	ch->tmu = tmu;
+
+	if (tmu->model == SH_TMU_LEGACY) {
+		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
+
+		/*
+		 * The SH3 variant (SH770x, SH7705, SH7710 and SH7720) maps
+		 * channel registers blocks at base + 2 + 12 * index, while all
+		 * other variants map them at base + 4 + 12 * index. We can
+		 * compute the index by just dividing by 12, the 2 bytes or 4
+		 * bytes offset being hidden by the integer division.
+		 */
+		ch->index = cfg->channel_offset / 12;
+		ch->base = tmu->mapbase + cfg->channel_offset;
+	} else {
+		ch->index = index;
+
+		if (tmu->model == SH_TMU_SH3)
+			ch->base = tmu->mapbase + 4 + ch->index * 12;
+		else
+			ch->base = tmu->mapbase + 8 + ch->index * 12;
+	}
 
-	if (!cfg) {
-		dev_err(&p->pdev->dev, "missing platform data\n");
-		goto err0;
+	ch->irq = platform_get_irq(tmu->pdev, index);
+	if (ch->irq < 0) {
+		dev_err(&tmu->pdev->dev, "ch%u: failed to get irq\n",
+			ch->index);
+		return ch->irq;
 	}
 
-	platform_set_drvdata(pdev, p);
+	ch->cs_enabled = false;
+	ch->enable_count = 0;
+
+	return sh_tmu_register(ch, dev_name(&tmu->pdev->dev),
+			       clockevent, clocksource);
+}
+
+static int sh_tmu_map_memory(struct sh_tmu_device *tmu)
+{
+	struct resource *res;
 
-	res = platform_get_resource(p->pdev, IORESOURCE_MEM, 0);
+	res = platform_get_resource(tmu->pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		dev_err(&p->pdev->dev, "failed to get I/O memory\n");
-		goto err0;
+		dev_err(&tmu->pdev->dev, "failed to get I/O memory\n");
+		return -ENXIO;
+	}
+
+	tmu->mapbase = ioremap_nocache(res->start, resource_size(res));
+	if (tmu->mapbase == NULL)
+		return -ENXIO;
+
+	/*
+	 * In legacy platform device configuration (with one device per channel)
+	 * the resource points to the channel base address.
+	 */
+	if (tmu->model == SH_TMU_LEGACY) {
+		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
+		tmu->mapbase -= cfg->channel_offset;
 	}
 
-	irq = platform_get_irq(p->pdev, 0);
-	if (irq < 0) {
-		dev_err(&p->pdev->dev, "failed to get irq\n");
-		goto err0;
+	return 0;
+}
+
+static void sh_tmu_unmap_memory(struct sh_tmu_device *tmu)
+{
+	if (tmu->model == SH_TMU_LEGACY) {
+		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
+		tmu->mapbase += cfg->channel_offset;
 	}
 
-	/* map memory, let mapbase point to our channel */
-	p->mapbase = ioremap_nocache(res->start, resource_size(res));
-	if (p->mapbase == NULL) {
-		dev_err(&p->pdev->dev, "failed to remap I/O memory\n");
-		goto err0;
+	iounmap(tmu->mapbase);
+}
+
+static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
+{
+	struct sh_timer_config *cfg = pdev->dev.platform_data;
+	const struct platform_device_id *id = pdev->id_entry;
+	unsigned int i;
+	int ret;
+
+	if (!cfg) {
+		dev_err(&tmu->pdev->dev, "missing platform data\n");
+		return -ENXIO;
 	}
 
-	/* setup data for setup_irq() (too early for request_irq()) */
-	p->irqaction.name = dev_name(&p->pdev->dev);
-	p->irqaction.handler = sh_tmu_interrupt;
-	p->irqaction.dev_id = p;
-	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
-
-	/* get hold of clock */
-	p->clk = clk_get(&p->pdev->dev, "tmu_fck");
-	if (IS_ERR(p->clk)) {
-		dev_err(&p->pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(p->clk);
-		goto err1;
+	tmu->pdev = pdev;
+	tmu->model = id->driver_data;
+
+	/* Get hold of clock. */
+	tmu->clk = clk_get(&tmu->pdev->dev,
+			   tmu->model == SH_TMU_LEGACY ? "tmu_fck" : "fck");
+	if (IS_ERR(tmu->clk)) {
+		dev_err(&tmu->pdev->dev, "cannot get clock\n");
+		return PTR_ERR(tmu->clk);
 	}
 
-	ret = clk_prepare(p->clk);
+	ret = clk_prepare(tmu->clk);
 	if (ret < 0)
-		goto err2;
+		goto err_clk_put;
 
-	p->cs_enabled = false;
-	p->enable_count = 0;
+	/* Map the memory resource. */
+	ret = sh_tmu_map_memory(tmu);
+	if (ret < 0) {
+		dev_err(&tmu->pdev->dev, "failed to remap I/O memory\n");
+		goto err_clk_unprepare;
+	}
 
-	ret = sh_tmu_register(p, (char *)dev_name(&p->pdev->dev),
-			      cfg->clockevent_rating,
-			      cfg->clocksource_rating);
-	if (ret < 0)
-		goto err3;
+	/* Allocate and setup the channels. */
+	if (tmu->model == SH_TMU_LEGACY)
+		tmu->num_channels = 1;
+	else
+		tmu->num_channels = hweight8(cfg->channels_mask);
+
+	tmu->channels = kzalloc(sizeof(*tmu->channels) * tmu->num_channels,
+				GFP_KERNEL);
+	if (tmu->channels == NULL) {
+		ret = -ENOMEM;
+		goto err_unmap;
+	}
+
+	if (tmu->model == SH_TMU_LEGACY) {
+		ret = sh_tmu_channel_setup(&tmu->channels[0], 0,
+					   cfg->clockevent_rating != 0,
+					   cfg->clocksource_rating != 0, tmu);
+		if (ret < 0)
+			goto err_unmap;
+	} else {
+		/*
+		 * Use the first channel as a clock event device and the second
+		 * channel as a clock source.
+		 */
+		for (i = 0; i < tmu->num_channels; ++i) {
+			ret = sh_tmu_channel_setup(&tmu->channels[i], i,
+						   i == 0, i == 1, tmu);
+			if (ret < 0)
+				goto err_unmap;
+		}
+	}
+
+	platform_set_drvdata(pdev, tmu);
 
 	return 0;
 
- err3:
-	clk_unprepare(p->clk);
- err2:
-	clk_put(p->clk);
- err1:
-	iounmap(p->mapbase);
- err0:
+err_unmap:
+	kfree(tmu->channels);
+	sh_tmu_unmap_memory(tmu);
+err_clk_unprepare:
+	clk_unprepare(tmu->clk);
+err_clk_put:
+	clk_put(tmu->clk);
 	return ret;
 }
 
 static int sh_tmu_probe(struct platform_device *pdev)
 {
-	struct sh_tmu_priv *p = platform_get_drvdata(pdev);
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
+	struct sh_tmu_device *tmu = platform_get_drvdata(pdev);
 	int ret;
 
 	if (!is_early_platform_device(pdev)) {
@@ -508,20 +638,18 @@ static int sh_tmu_probe(struct platform_device *pdev)
 		pm_runtime_enable(&pdev->dev);
 	}
 
-	if (p) {
+	if (tmu) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
 		goto out;
 	}
 
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	tmu = kzalloc(sizeof(*tmu), GFP_KERNEL);
+	if (tmu == NULL)
 		return -ENOMEM;
-	}
 
-	ret = sh_tmu_setup(p, pdev);
+	ret = sh_tmu_setup(tmu, pdev);
 	if (ret) {
-		kfree(p);
+		kfree(tmu);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
@@ -529,7 +657,7 @@ static int sh_tmu_probe(struct platform_device *pdev)
 		return 0;
 
  out:
-	if (cfg->clockevent_rating || cfg->clocksource_rating)
+	if (tmu->has_clockevent || tmu->has_clocksource)
 		pm_runtime_irq_safe(&pdev->dev);
 	else
 		pm_runtime_idle(&pdev->dev);
@@ -542,12 +670,21 @@ static int sh_tmu_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
+static const struct platform_device_id sh_tmu_id_table[] = {
+	{ "sh_tmu", SH_TMU_LEGACY },
+	{ "sh-tmu", SH_TMU },
+	{ "sh-tmu-sh3", SH_TMU_SH3 },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, sh_tmu_id_table);
+
 static struct platform_driver sh_tmu_device_driver = {
 	.probe		= sh_tmu_probe,
 	.remove		= sh_tmu_remove,
 	.driver		= {
 		.name	= "sh_tmu",
-	}
+	},
+	.id_table	= sh_tmu_id_table,
 };
 
 static int __init sh_tmu_init(void)
diff --git a/drivers/clocksource/time-efm32.c b/drivers/clocksource/time-efm32.c
index 1a6205b..bba62f9 100644
--- a/drivers/clocksource/time-efm32.c
+++ b/drivers/clocksource/time-efm32.c
@@ -272,4 +272,5 @@ static void __init efm32_timer_init(struct device_node *np)
 		}
 	}
 }
-CLOCKSOURCE_OF_DECLARE(efm32, "efm32,timer", efm32_timer_init);
+CLOCKSOURCE_OF_DECLARE(efm32compat, "efm32,timer", efm32_timer_init);
+CLOCKSOURCE_OF_DECLARE(efm32, "energymicro,efm32-timer", efm32_timer_init);
diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index deebcd6..0226844 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqreturn.h>
+#include <linux/reset.h>
 #include <linux/sched_clock.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -143,6 +144,7 @@ static u64 sun5i_timer_sched_read(void)
 
 static void __init sun5i_timer_init(struct device_node *node)
 {
+	struct reset_control *rstc;
 	unsigned long rate;
 	struct clk *clk;
 	int ret, irq;
@@ -162,6 +164,10 @@ static void __init sun5i_timer_init(struct device_node *node)
 	clk_prepare_enable(clk);
 	rate = clk_get_rate(clk);
 
+	rstc = of_reset_control_get(node, NULL);
+	if (!IS_ERR(rstc))
+		reset_control_deassert(rstc);
+
 	writel(~0, timer_base + TIMER_INTVAL_LO_REG(1));
 	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
 	       timer_base + TIMER_CTL_REG(1));
diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index cddf0c2..efa931c 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -14,7 +14,6 @@ extern void sched_clock_postinit(void);
 static inline void sched_clock_postinit(void) { }
 #endif
 
-extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
 extern void sched_clock_register(u64 (*read)(void), int bits,
 				 unsigned long rate);
 
diff --git a/include/linux/sh_timer.h b/include/linux/sh_timer.h
index 4d9dcd1..8e1e036 100644
--- a/include/linux/sh_timer.h
+++ b/include/linux/sh_timer.h
@@ -7,6 +7,7 @@ struct sh_timer_config {
 	int timer_bit;
 	unsigned long clockevent_rating;
 	unsigned long clocksource_rating;
+	unsigned int channels_mask;
 };
 
 #endif /* __SH_TIMER_H__ */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 419a52c..c8780cd 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -165,21 +165,21 @@ static inline void pps_set_freq(s64 freq)
 
 static inline int is_error_status(int status)
 {
-	return (time_status & (STA_UNSYNC|STA_CLOCKERR))
+	return (status & (STA_UNSYNC|STA_CLOCKERR))
 		/* PPS signal lost when either PPS time or
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & (STA_PPSFREQ|STA_PPSTIME))
-			&& !(time_status & STA_PPSSIGNAL))
+		|| ((status & (STA_PPSFREQ|STA_PPSTIME))
+			&& !(status & STA_PPSSIGNAL))
 		/* PPS jitter exceeded when
 		 * PPS time synchronization requested */
-		|| ((time_status & (STA_PPSTIME|STA_PPSJITTER))
+		|| ((status & (STA_PPSTIME|STA_PPSJITTER))
 			== (STA_PPSTIME|STA_PPSJITTER))
 		/* PPS wander exceeded or calibration error when
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & STA_PPSFREQ)
-			&& (time_status & (STA_PPSWANDER|STA_PPSERROR)));
+		|| ((status & STA_PPSFREQ)
+			&& (status & (STA_PPSWANDER|STA_PPSERROR)));
 }
 
 static inline void pps_fill_timex(struct timex *txc)
@@ -923,7 +923,10 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 static int __init ntp_tick_adj_setup(char *str)
 {
-	ntp_tick_adj = simple_strtol(str, NULL, 0);
+	int rc = kstrtol(str, 0, (long *)&ntp_tick_adj);
+
+	if (rc)
+		return rc;
 	ntp_tick_adj <<= NTP_SCALE_SHIFT;
 
 	return 1;
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 4d23dc4..445106d 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -49,13 +49,6 @@ static u64 notrace jiffy_sched_clock_read(void)
 	return (u64)(jiffies - INITIAL_JIFFIES);
 }
 
-static u32 __read_mostly (*read_sched_clock_32)(void);
-
-static u64 notrace read_sched_clock_32_wrapper(void)
-{
-	return read_sched_clock_32();
-}
-
 static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
 
 static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
@@ -176,12 +169,6 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
-void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
-{
-	read_sched_clock_32 = read;
-	sched_clock_register(read_sched_clock_32_wrapper, bits, rate);
-}
-
 void __init sched_clock_postinit(void)
 {
 	/*
--8323329-1631510505-1401907596=:18296--
