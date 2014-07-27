Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaG0Wzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 18:55:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63741 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750771AbaG0Wz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 18:55:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Zhang Rui <rui.zhang@intel.com>
Subject: [RFC][PATCH] PM / sleep: Rename symbols, functions and variables related to sleep
Date: Mon, 28 Jul 2014 01:13:56 +0200
Message-ID: <5215142.eaz1Ajyth6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The names of several symbols, data types, functions and variables
related to system sleep states are confusing and don't reflect the
real behavior of those states correctly.

First of all, there generally are two sleep states that require
platform support and one sleep state that is platform-independent.
The first two of them are currently known as MEM and STANDBY,
although these names really only match what the states do on full
hardware ACPI compliant systems.  MEM in particular is supposed
to mean "suspend-to-RAM", but in fact it means "the deepest sleep
state available with platform support".  The definition of STANDBY
is even more arbitrary.

Moreover, the remaining sleep state that doesn't need platform support
is currently called FREEZE, which leads to double confusion with the
process freezer (used during transitions to all sleep states) and
with the freeze stage of processing devices during hibernation.

For these reasons, rename the PM_SUSPEND_MEM, PM_SUSPEND_STANDBY
and PM_SUSPEND_FREEZE symbols to PM_SUSPEND_PLATFORM_DEEP,
PM_SUSPEND_PLATFORM_SHALLOW and PM_SUSPEND_IDLE_SLEEP, respectively,
everywhere and rename data types, functions and variables related to
those states to match the new names of the symbols.

This is a semi-mechanical replacement of names and it should not lead
to any functional differences.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/arm/mach-at91/pm.c                   |   10 +--
 arch/arm/mach-davinci/pm.c                |    6 +-
 arch/arm/mach-exynos/pm.c                 |    2 
 arch/arm/mach-highbank/pm.c               |    2 
 arch/arm/mach-imx/mach-mx31ads.c          |    8 +--
 arch/arm/mach-imx/pm-imx27.c              |    4 -
 arch/arm/mach-imx/pm-imx5.c               |   12 ++--
 arch/arm/mach-imx/pm-imx6.c               |    4 -
 arch/arm/mach-kirkwood/pm.c               |    4 -
 arch/arm/mach-lpc32xx/pm.c                |    2 
 arch/arm/mach-mmp/pm-mmp2.c               |    3 -
 arch/arm/mach-mmp/pm-pxa910.c             |    3 -
 arch/arm/mach-mvebu/kirkwood-pm.c         |    4 -
 arch/arm/mach-mxs/pm.c                    |    4 -
 arch/arm/mach-omap1/pm.c                  |    6 +-
 arch/arm/mach-omap2/pm.c                  |    6 +-
 arch/arm/mach-prima2/pm.c                 |    4 -
 arch/arm/mach-pxa/pm.c                    |    4 -
 arch/arm/mach-pxa/pxa25x.c                |    4 -
 arch/arm/mach-pxa/pxa27x.c                |   10 ++-
 arch/arm/mach-pxa/pxa3xx.c                |    7 +-
 arch/arm/mach-pxa/sharpsl_pm.c            |    2 
 arch/arm/mach-pxa/z2.c                    |    2 
 arch/arm/mach-s3c64xx/mach-smdk6410.c     |    2 
 arch/arm/mach-sa1100/pm.c                 |    2 
 arch/arm/mach-shmobile/suspend.c          |    2 
 arch/arm/mach-tegra/pm.c                  |    2 
 arch/arm/mach-ux500/pm.c                  |    3 -
 arch/arm/plat-samsung/pm.c                |    2 
 arch/avr32/mach-at32ap/pm-at32ap700x.S    |    2 
 arch/avr32/mach-at32ap/pm.c               |    8 +--
 arch/blackfin/mach-bf609/pm.c             |    2 
 arch/blackfin/mach-common/pm.c            |   12 ++--
 arch/mips/alchemy/devboards/pm.c          |    2 
 arch/mips/jz4740/pm.c                     |    2 
 arch/mips/loongson/common/pm.c            |    4 -
 arch/powerpc/platforms/52xx/lite5200_pm.c |   12 ++--
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    2 
 arch/powerpc/platforms/83xx/suspend.c     |   11 ++--
 arch/powerpc/platforms/pseries/suspend.c  |    6 +-
 arch/powerpc/sysdev/fsl_pmc.c             |    2 
 arch/powerpc/sysdev/ppc4xx_cpm.c          |    8 +--
 arch/sh/boards/mach-hp6xx/pm.c            |    2 
 arch/sh/kernel/cpu/shmobile/pm.c          |    2 
 arch/unicore32/kernel/pm.c                |    4 -
 arch/unicore32/kernel/puv3-core.c         |    4 -
 arch/x86/platform/olpc/olpc-xo1-pm.c      |    4 -
 drivers/acpi/sleep.c                      |   24 ++++-----
 drivers/base/power/wakeup.c               |    4 -
 drivers/char/apm-emulation.c              |    6 +-
 drivers/macintosh/via-pmu.c               |    4 -
 drivers/regulator/core.c                  |    4 -
 include/linux/pm.h                        |    4 -
 include/linux/suspend.h                   |   26 ++++-----
 kernel/power/hibernate.c                  |    2 
 kernel/power/suspend.c                    |   79 +++++++++++++++---------------
 kernel/power/suspend_test.c               |    6 +-
 kernel/power/user.c                       |    2 
 58 files changed, 193 insertions(+), 183 deletions(-)

Index: linux-pm/arch/arm/mach-at91/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-at91/pm.c
+++ linux-pm/arch/arm/mach-at91/pm.c
@@ -111,8 +111,8 @@ static int at91_pm_valid_state(suspend_s
 {
 	switch (state) {
 		case PM_SUSPEND_ON:
-		case PM_SUSPEND_STANDBY:
-		case PM_SUSPEND_MEM:
+		case PM_SUSPEND_PLATFORM_SHALLOW:
+		case PM_SUSPEND_PLATFORM_DEEP:
 			return 1;
 
 		default:
@@ -186,7 +186,7 @@ static int at91_pm_verify_clocks(void)
  */
 int at91_suspend_entering_slow_clock(void)
 {
-	return (target_state == PM_SUSPEND_MEM);
+	return (target_state == PM_SUSPEND_PLATFORM_DEEP);
 }
 EXPORT_SYMBOL(at91_suspend_entering_slow_clock);
 
@@ -223,7 +223,7 @@ static int at91_pm_enter(suspend_state_t
 		 * drivers must suspend more deeply:  only the master clock
 		 * controller may be using the main oscillator.
 		 */
-		case PM_SUSPEND_MEM:
+		case PM_SUSPEND_PLATFORM_DEEP:
 			/*
 			 * Ensure that clocks are in a valid state.
 			 */
@@ -259,7 +259,7 @@ static int at91_pm_enter(suspend_state_t
 		 * But otherwise it's identical to PM_SUSPEND_ON:  cpu idle, and
 		 * nothing fancy done with main or cpu clocks.
 		 */
-		case PM_SUSPEND_STANDBY:
+		case PM_SUSPEND_PLATFORM_SHALLOW:
 			/*
 			 * NOTE: the Wait-for-Interrupt instruction needs to be
 			 * in icache so no SDRAM accesses are needed until the
Index: linux-pm/arch/arm/mach-davinci/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-davinci/pm.c
+++ linux-pm/arch/arm/mach-davinci/pm.c
@@ -101,8 +101,8 @@ static int davinci_pm_enter(suspend_stat
 	int ret = 0;
 
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		davinci_pm_suspend();
 		break;
 	default:
@@ -114,7 +114,7 @@ static int davinci_pm_enter(suspend_stat
 
 static const struct platform_suspend_ops davinci_pm_ops = {
 	.enter		= davinci_pm_enter,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 static int __init davinci_pm_probe(struct platform_device *pdev)
Index: linux-pm/arch/arm/mach-imx/mach-mx31ads.c
===================================================================
--- linux-pm.orig/arch/arm/mach-imx/mach-mx31ads.c
+++ linux-pm/arch/arm/mach-imx/mach-mx31ads.c
@@ -275,7 +275,7 @@ static struct regulator_init_data sw1a_d
 			 .mode = REGULATOR_MODE_NORMAL,
 			 .enabled = 1,
 		 },
-		.initial_state = PM_SUSPEND_MEM,
+		.initial_state = PM_SUSPEND_PLATFORM_DEEP,
 		.always_on = 1,
 		.boot_on = 1,
 	},
@@ -294,7 +294,7 @@ static struct regulator_init_data viohi_
 			 .mode = REGULATOR_MODE_NORMAL,
 			 .enabled = 1,
 		 },
-		.initial_state = PM_SUSPEND_MEM,
+		.initial_state = PM_SUSPEND_PLATFORM_DEEP,
 		.always_on = 1,
 		.boot_on = 1,
 	},
@@ -311,7 +311,7 @@ static struct regulator_init_data violo_
 			 .mode = REGULATOR_MODE_NORMAL,
 			 .enabled = 1,
 		 },
-		.initial_state = PM_SUSPEND_MEM,
+		.initial_state = PM_SUSPEND_PLATFORM_DEEP,
 		.always_on = 1,
 		.boot_on = 1,
 	},
@@ -335,7 +335,7 @@ static struct regulator_init_data sw2a_d
 		 },
 		.always_on = 1,
 		.boot_on = 1,
-		.initial_state = PM_SUSPEND_MEM,
+		.initial_state = PM_SUSPEND_PLATFORM_DEEP,
 	},
 };
 
Index: linux-pm/arch/arm/mach-imx/pm-imx27.c
===================================================================
--- linux-pm.orig/arch/arm/mach-imx/pm-imx27.c
+++ linux-pm/arch/arm/mach-imx/pm-imx27.c
@@ -17,7 +17,7 @@ static int mx27_suspend_enter(suspend_st
 {
 	u32 cscr;
 	switch (state) {
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		/* Clear MPEN and SPEN to disable MPLL/SPLL */
 		cscr = __raw_readl(MX27_IO_ADDRESS(MX27_CCM_BASE_ADDR));
 		cscr &= 0xFFFFFFFC;
@@ -34,7 +34,7 @@ static int mx27_suspend_enter(suspend_st
 
 static const struct platform_suspend_ops mx27_suspend_ops = {
 	.enter = mx27_suspend_enter,
-	.valid = suspend_valid_only_mem,
+	.valid = suspend_valid_only_platform_deep,
 };
 
 static int __init mx27_pm_init(void)
Index: linux-pm/arch/arm/mach-imx/pm-imx5.c
===================================================================
--- linux-pm.orig/arch/arm/mach-imx/pm-imx5.c
+++ linux-pm/arch/arm/mach-imx/pm-imx5.c
@@ -26,9 +26,9 @@
  * The WAIT_UNCLOCKED_POWER_OFF state only requires <= 500ns to exit.
  * This is also the lowest power state possible without affecting
  * non-cpu parts of the system.  For these reasons, imx5 should default
- * to always using this state for cpu idling.  The PM_SUSPEND_STANDBY also
- * uses this state and needs to take no action when registers remain confgiured
- * for this state.
+ * to always using this state for cpu idling.  The PM_SUSPEND_PLATFORM_SHALLOW
+ * also uses this state and needs to take no action when registers remain
+ * configured for this state.
  */
 #define IMX5_DEFAULT_CPU_IDLE_STATE WAIT_UNCLOCKED_POWER_OFF
 
@@ -99,17 +99,17 @@ static void mx5_cpu_lp_set(enum mxc_cpu_
 static int mx5_suspend_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		mx5_cpu_lp_set(STOP_POWER_OFF);
 		break;
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		/* DEFAULT_IDLE_STATE already configured */
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (state == PM_SUSPEND_MEM) {
+	if (state == PM_SUSPEND_PLATFORM_DEEP) {
 		local_flush_tlb_all();
 		flush_cache_all();
 
Index: linux-pm/arch/arm/mach-imx/pm-imx6.c
===================================================================
--- linux-pm.orig/arch/arm/mach-imx/pm-imx6.c
+++ linux-pm/arch/arm/mach-imx/pm-imx6.c
@@ -314,7 +314,7 @@ static int imx6q_suspend_finish(unsigned
 static int imx6q_pm_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		imx6q_set_lpm(STOP_POWER_OFF);
 		imx6q_enable_wb(true);
 		/*
@@ -345,7 +345,7 @@ static int imx6q_pm_enter(suspend_state_
 
 static const struct platform_suspend_ops imx6q_pm_ops = {
 	.enter = imx6q_pm_enter,
-	.valid = suspend_valid_only_mem,
+	.valid = suspend_valid_only_platform_deep,
 };
 
 void __init imx6q_pm_set_ccm_base(void __iomem *base)
Index: linux-pm/arch/arm/mach-mmp/pm-mmp2.c
===================================================================
--- linux-pm.orig/arch/arm/mach-mmp/pm-mmp2.c
+++ linux-pm/arch/arm/mach-mmp/pm-mmp2.c
@@ -203,7 +203,8 @@ static void mmp2_pm_finish(void)
 
 static int mmp2_pm_valid(suspend_state_t state)
 {
-	return ((state == PM_SUSPEND_STANDBY) || (state == PM_SUSPEND_MEM));
+	return state == PM_SUSPEND_PLATFORM_SHALLOW
+		|| state == PM_SUSPEND_PLATFORM_DEEP;
 }
 
 /*
Index: linux-pm/arch/arm/mach-mmp/pm-pxa910.c
===================================================================
--- linux-pm.orig/arch/arm/mach-mmp/pm-pxa910.c
+++ linux-pm/arch/arm/mach-mmp/pm-pxa910.c
@@ -240,7 +240,8 @@ static void pxa910_pm_finish(void)
 
 static int pxa910_pm_valid(suspend_state_t state)
 {
-	return ((state == PM_SUSPEND_STANDBY) || (state == PM_SUSPEND_MEM));
+	return state == PM_SUSPEND_PLATFORM_SHALLOW
+		|| (state == PM_SUSPEND_PLATFORM_DEEP;
 }
 
 static const struct platform_suspend_ops pxa910_pm_ops = {
Index: linux-pm/arch/arm/mach-mxs/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-mxs/pm.c
+++ linux-pm/arch/arm/mach-mxs/pm.c
@@ -20,7 +20,7 @@
 static int mxs_suspend_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		cpu_do_idle();
 		break;
 
@@ -32,7 +32,7 @@ static int mxs_suspend_enter(suspend_sta
 
 static struct platform_suspend_ops mxs_suspend_ops = {
 	.enter = mxs_suspend_enter,
-	.valid = suspend_valid_only_mem,
+	.valid = suspend_valid_only_platform_deep,
 };
 
 void __init mxs_pm_init(void)
Index: linux-pm/arch/arm/mach-omap1/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-omap1/pm.c
+++ linux-pm/arch/arm/mach-omap1/pm.c
@@ -589,8 +589,8 @@ static int omap_pm_enter(suspend_state_t
 {
 	switch (state)
 	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		omap1_pm_suspend();
 		break;
 	default:
@@ -630,7 +630,7 @@ static const struct platform_suspend_ops
 	.prepare	= omap_pm_prepare,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 static int __init omap_pm_init(void)
Index: linux-pm/arch/arm/mach-omap2/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-omap2/pm.c
+++ linux-pm/arch/arm/mach-omap2/pm.c
@@ -207,8 +207,8 @@ static int omap_pm_enter(suspend_state_t
 		return -ENOENT; /* XXX doublecheck */
 
 	switch (suspend_state) {
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		ret = omap_pm_suspend();
 		break;
 	default:
@@ -242,7 +242,7 @@ static const struct platform_suspend_ops
 	.end		= omap_pm_end,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 /**
Index: linux-pm/arch/arm/mach-prima2/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-prima2/pm.c
+++ linux-pm/arch/arm/mach-prima2/pm.c
@@ -68,7 +68,7 @@ static int sirfsoc_pre_suspend_power_off
 static int sirfsoc_pm_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		sirfsoc_pre_suspend_power_off();
 
 		outer_disable();
@@ -84,7 +84,7 @@ static int sirfsoc_pm_enter(suspend_stat
 
 static const struct platform_suspend_ops sirfsoc_pm_ops = {
 	.enter = sirfsoc_pm_enter,
-	.valid = suspend_valid_only_mem,
+	.valid = suspend_valid_only_platform_deep,
 };
 
 static const struct of_device_id pwrc_ids[] = {
Index: linux-pm/arch/arm/mach-pxa/pxa25x.c
===================================================================
--- linux-pm.orig/arch/arm/mach-pxa/pxa25x.c
+++ linux-pm/arch/arm/mach-pxa/pxa25x.c
@@ -251,7 +251,7 @@ static void pxa25x_cpu_pm_enter(suspend_
 	RCSR = RCSR_HWR | RCSR_WDR | RCSR_SMR | RCSR_GPR;
 
 	switch (state) {
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		cpu_suspend(PWRMODE_SLEEP, pxa25x_finish_suspend);
 		break;
 	}
@@ -272,7 +272,7 @@ static void pxa25x_cpu_pm_finish(void)
 
 static struct pxa_cpu_pm_fns pxa25x_cpu_pm_fns = {
 	.save_count	= SLEEP_SAVE_COUNT,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 	.save		= pxa25x_cpu_pm_save,
 	.restore	= pxa25x_cpu_pm_restore,
 	.enter		= pxa25x_cpu_pm_enter,
Index: linux-pm/arch/arm/mach-pxa/pxa27x.c
===================================================================
--- linux-pm.orig/arch/arm/mach-pxa/pxa27x.c
+++ linux-pm/arch/arm/mach-pxa/pxa27x.c
@@ -247,7 +247,8 @@ static struct clk_lookup pxa27x_clkregs[
 #define RESTORE(x)	x = sleep_save[SLEEP_SAVE_##x]
 
 /*
- * allow platforms to override default PWRMODE setting used for PM_SUSPEND_MEM
+ * allow platforms to override default PWRMODE setting used for
+ * PM_SUSPEND_PLATFORM_DEEP
  */
 static unsigned int pwrmode = PWRMODE_SLEEP;
 
@@ -312,10 +313,10 @@ void pxa27x_cpu_pm_enter(suspend_state_t
 	RCSR = RCSR_HWR | RCSR_WDR | RCSR_SMR | RCSR_GPR;
 
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		pxa_cpu_standby();
 		break;
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		cpu_suspend(pwrmode, pxa27x_finish_suspend);
 #ifndef CONFIG_IWMMXT
 		asm volatile("mar acc0, %Q0, %R0" : "=r" (acc0));
@@ -326,7 +327,8 @@ void pxa27x_cpu_pm_enter(suspend_state_t
 
 static int pxa27x_cpu_pm_valid(suspend_state_t state)
 {
-	return state == PM_SUSPEND_MEM || state == PM_SUSPEND_STANDBY;
+	return state == PM_SUSPEND_PLATFORM_DEEP
+		|| state == PM_SUSPEND_PLATFORM_SHALLOW;
 }
 
 static int pxa27x_cpu_pm_prepare(void)
Index: linux-pm/arch/arm/mach-pxa/pxa3xx.c
===================================================================
--- linux-pm.orig/arch/arm/mach-pxa/pxa3xx.c
+++ linux-pm/arch/arm/mach-pxa/pxa3xx.c
@@ -196,11 +196,11 @@ static void pxa3xx_cpu_pm_enter(suspend_
 	}
 
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		pxa3xx_cpu_standby(PXA3xx_PM_S0D2C2);
 		break;
 
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		pxa3xx_cpu_pm_suspend();
 		break;
 	}
@@ -208,7 +208,8 @@ static void pxa3xx_cpu_pm_enter(suspend_
 
 static int pxa3xx_cpu_pm_valid(suspend_state_t state)
 {
-	return state == PM_SUSPEND_MEM || state == PM_SUSPEND_STANDBY;
+	return state == PM_SUSPEND_PLATFORM_DEEP
+		|| state == PM_SUSPEND_PLATFORM_SHALLOW;
 }
 
 static struct pxa_cpu_pm_fns pxa3xx_cpu_pm_fns = {
Index: linux-pm/arch/arm/mach-pxa/z2.c
===================================================================
--- linux-pm.orig/arch/arm/mach-pxa/z2.c
+++ linux-pm/arch/arm/mach-pxa/z2.c
@@ -691,7 +691,7 @@ static void z2_power_off(void)
 	PSPR = 0x0;
 	local_irq_disable();
 	pxa27x_set_pwrmode(PWRMODE_DEEPSLEEP);
-	pxa27x_cpu_pm_enter(PM_SUSPEND_MEM);
+	pxa27x_cpu_pm_enter(PM_SUSPEND_PLATFORM_DEEP);
 }
 #else
 #define z2_power_off   NULL
Index: linux-pm/arch/arm/mach-s3c64xx/mach-smdk6410.c
===================================================================
--- linux-pm.orig/arch/arm/mach-s3c64xx/mach-smdk6410.c
+++ linux-pm/arch/arm/mach-s3c64xx/mach-smdk6410.c
@@ -428,7 +428,7 @@ static struct regulator_init_data wm8350
 			 .mode = REGULATOR_MODE_NORMAL,
 			 .enabled = 1,
 		},
-		.initial_state = PM_SUSPEND_MEM,
+		.initial_state = PM_SUSPEND_PLATFORM_DEEP,
 	},
 };
 
Index: linux-pm/arch/arm/mach-ux500/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-ux500/pm.c
+++ linux-pm/arch/arm/mach-ux500/pm.c
@@ -164,7 +164,8 @@ static int ux500_suspend_enter(suspend_s
 
 static int ux500_suspend_valid(suspend_state_t state)
 {
-	return state == PM_SUSPEND_MEM || state == PM_SUSPEND_STANDBY;
+	return state == PM_SUSPEND_PLATFORM_DEEP
+		|| state == PM_SUSPEND_PLATFORM_SHALLOW;
 }
 
 static const struct platform_suspend_ops ux500_suspend_ops = {
Index: linux-pm/arch/avr32/mach-at32ap/pm.c
===================================================================
--- linux-pm.orig/arch/avr32/mach-at32ap/pm.c
+++ linux-pm/arch/avr32/mach-at32ap/pm.c
@@ -100,8 +100,8 @@ static int avr32_pm_valid_state(suspend_
 {
 	switch (state) {
 	case PM_SUSPEND_ON:
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		return 1;
 
 	default:
@@ -116,7 +116,7 @@ static int avr32_pm_enter(suspend_state_
 	void		*sram;
 
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		sram = avr32_pm_map_sram();
 
 		/* Switch to in-sram exception handlers */
@@ -138,7 +138,7 @@ static int avr32_pm_enter(suspend_state_
 		avr32_pm_unmap_sram();
 		break;
 
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		sram = avr32_pm_map_sram();
 
 		/* Switch to in-sram exception handlers */
Index: linux-pm/arch/blackfin/mach-common/pm.c
===================================================================
--- linux-pm.orig/arch/blackfin/mach-common/pm.c
+++ linux-pm/arch/blackfin/mach-common/pm.c
@@ -32,7 +32,7 @@ void bfin_pm_suspend_standby_enter(void)
 #endif
 
 #ifdef CONFIG_BF60x
-	bfin_cpu_pm->enter(PM_SUSPEND_STANDBY);
+	bfin_cpu_pm->enter(PM_SUSPEND_PLATFORM_SHALLOW);
 #else
 # ifdef CONFIG_PM_BFIN_SLEEP_DEEPER
 	sleep_deeper(bfin_sic_iwr[0], bfin_sic_iwr[1], bfin_sic_iwr[2]);
@@ -188,7 +188,7 @@ int bfin_pm_suspend_mem_enter(void)
 #ifndef CONFIG_BF60x
 	do_hibernate(wakeup | vr_wakeup);	/* See you later! */
 #else
-	bfin_cpu_pm->enter(PM_SUSPEND_MEM);
+	bfin_cpu_pm->enter(PM_SUSPEND_PLATFORM_DEEP);
 #endif
 
 	bf53x_resume_l1_mem(memptr);
@@ -214,7 +214,7 @@ int bfin_pm_suspend_mem_enter(void)
  */
 static int bfin_pm_valid(suspend_state_t state)
 {
-	return (state == PM_SUSPEND_STANDBY
+	return (state == PM_SUSPEND_PLATFORM_SHALLOW
 #if !(defined(BF533_FAMILY) || defined(CONFIG_BF561))
 	/*
 	 * On BF533/2/1:
@@ -229,7 +229,7 @@ static int bfin_pm_valid(suspend_state_t
 	 * start losing its contents.
 	 * An external HW workaround is possible using logic gates.
 	 */
-	|| state == PM_SUSPEND_MEM
+	|| state == PM_SUSPEND_PLATFORM_DEEP
 #endif
 	);
 }
@@ -242,10 +242,10 @@ static int bfin_pm_valid(suspend_state_t
 static int bfin_pm_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		bfin_pm_suspend_standby_enter();
 		break;
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		bfin_pm_suspend_mem_enter();
 		break;
 	default:
Index: linux-pm/arch/mips/loongson/common/pm.c
===================================================================
--- linux-pm.orig/arch/mips/loongson/common/pm.c
+++ linux-pm/arch/mips/loongson/common/pm.c
@@ -138,8 +138,8 @@ static int loongson_pm_valid_state(suspe
 {
 	switch (state) {
 	case PM_SUSPEND_ON:
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		return 1;
 
 	default:
Index: linux-pm/arch/powerpc/platforms/52xx/lite5200_pm.c
===================================================================
--- linux-pm.orig/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ linux-pm/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -24,8 +24,8 @@ static suspend_state_t lite5200_pm_targe
 static int lite5200_pm_valid(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		return 1;
 	default:
 		return 0;
@@ -55,10 +55,10 @@ static int lite5200_pm_prepare(void)
 	const u32 *regaddr_p;
 
 	/* deep sleep? let mpc52xx code handle that */
-	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY)
+	if (lite5200_pm_target_state == PM_SUSPEND_PLATFORM_SHALLOW)
 		return mpc52xx_pm_prepare();
 
-	if (lite5200_pm_target_state != PM_SUSPEND_MEM)
+	if (lite5200_pm_target_state != PM_SUSPEND_PLATFORM_DEEP)
 		return -EINVAL;
 
 	/* map registers */
@@ -204,7 +204,7 @@ static void lite5200_restore_regs(void)
 static int lite5200_pm_enter(suspend_state_t state)
 {
 	/* deep sleep? let mpc52xx code handle that */
-	if (state == PM_SUSPEND_STANDBY) {
+	if (state == PM_SUSPEND_PLATFORM_SHALLOW) {
 		return mpc52xx_pm_enter(state);
 	}
 
@@ -224,7 +224,7 @@ static int lite5200_pm_enter(suspend_sta
 static void lite5200_pm_finish(void)
 {
 	/* deep sleep? let mpc52xx code handle that */
-	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY)
+	if (lite5200_pm_target_state == PM_SUSPEND_PLATFORM_SHALLOW)
 		mpc52xx_pm_finish();
 }
 
Index: linux-pm/arch/powerpc/platforms/83xx/suspend.c
===================================================================
--- linux-pm.orig/arch/powerpc/platforms/83xx/suspend.c
+++ linux-pm/arch/powerpc/platforms/83xx/suspend.c
@@ -241,17 +241,18 @@ static void mpc83xx_suspend_end(void)
 
 static int mpc83xx_suspend_valid(suspend_state_t state)
 {
-	return state == PM_SUSPEND_STANDBY || state == PM_SUSPEND_MEM;
+	return state == PM_SUSPEND_PLATFORM_SHALLOW
+		|| state == PM_SUSPEND_PLATFORM_DEEP;
 }
 
 static int mpc83xx_suspend_begin(suspend_state_t state)
 {
 	switch (state) {
-		case PM_SUSPEND_STANDBY:
+		case PM_SUSPEND_PLATFORM_SHALLOW:
 			deep_sleeping = 0;
 			return 0;
 
-		case PM_SUSPEND_MEM:
+		case PM_SUSPEND_PLATFORM_DEEP:
 			if (has_deep_sleep)
 				deep_sleeping = 1;
 
@@ -280,8 +281,8 @@ static int agent_thread_fn(void *data)
 
 		wake_from_pci = 1;
 
-		pm_suspend(pci_pm_state == 3 ? PM_SUSPEND_MEM :
-		                               PM_SUSPEND_STANDBY);
+		pm_suspend(pci_pm_state == 3 ? PM_SUSPEND_PLATFORM_DEEP :
+		                               PM_SUSPEND_PLATFORM_SHALLOW);
 
 		wake_from_pci = 0;
 	}
Index: linux-pm/arch/powerpc/platforms/pseries/suspend.c
===================================================================
--- linux-pm.orig/arch/powerpc/platforms/pseries/suspend.c
+++ linux-pm/arch/powerpc/platforms/pseries/suspend.c
@@ -157,7 +157,7 @@ static ssize_t store_hibernate(struct de
 	stream_id = simple_strtoul(buf, NULL, 16);
 
 	do {
-		rc = pseries_suspend_begin(PM_SUSPEND_MEM);
+		rc = pseries_suspend_begin(PM_SUSPEND_PLATFORM_DEEP);
 		if (rc == -EAGAIN)
 			ssleep(1);
 	} while (rc == -EAGAIN);
@@ -174,7 +174,7 @@ static ssize_t store_hibernate(struct de
 		}
 
 		stop_topology_update();
-		rc = pm_suspend(PM_SUSPEND_MEM);
+		rc = pm_suspend(PM_SUSPEND_PLATFORM_DEEP);
 		start_topology_update();
 
 		/* Take down CPUs not online prior to suspend */
@@ -223,7 +223,7 @@ static struct bus_type suspend_subsys =
 };
 
 static const struct platform_suspend_ops pseries_suspend_ops = {
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 	.begin		= pseries_suspend_begin,
 	.prepare_late	= pseries_prepare_late,
 	.enter		= pseries_suspend_enter,
Index: linux-pm/arch/powerpc/sysdev/ppc4xx_cpm.c
===================================================================
--- linux-pm.orig/arch/powerpc/sysdev/ppc4xx_cpm.c
+++ linux-pm/arch/powerpc/sysdev/ppc4xx_cpm.c
@@ -202,9 +202,9 @@ static void cpm_idle(void)
 static int cpm_suspend_valid(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		return !!cpm.standby;
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		return !!cpm.suspend;
 	default:
 		return 0;
@@ -229,10 +229,10 @@ static void cpm_suspend_standby(unsigned
 static int cpm_suspend_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		cpm_suspend_standby(cpm.standby);
 		break;
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		cpm_suspend_standby(cpm.suspend);
 		break;
 	}
Index: linux-pm/arch/unicore32/kernel/puv3-core.c
===================================================================
--- linux-pm.orig/arch/unicore32/kernel/puv3-core.c
+++ linux-pm/arch/unicore32/kernel/puv3-core.c
@@ -208,7 +208,7 @@ static void puv3_cpu_pm_enter(suspend_st
 /*	case PM_SUSPEND_ON:
 		puv3_cpu_idle();
 		break; */
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		puv3_cpu_pm_prepare();
 		puv3_cpu_suspend(PM_PMCR_SFB);
 		break;
@@ -217,7 +217,7 @@ static void puv3_cpu_pm_enter(suspend_st
 
 static int puv3_cpu_pm_valid(suspend_state_t state)
 {
-	return state == PM_SUSPEND_MEM;
+	return state == PM_SUSPEND_PLATFORM_DEEP;
 }
 
 static void puv3_cpu_pm_finish(void)
Index: linux-pm/arch/x86/platform/olpc/olpc-xo1-pm.c
===================================================================
--- linux-pm.orig/arch/x86/platform/olpc/olpc-xo1-pm.c
+++ linux-pm/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -54,7 +54,7 @@ static int xo1_power_state_enter(suspend
 	unsigned long saved_sci_mask;
 
 	/* Only STR is supported */
-	if (pm_state != PM_SUSPEND_MEM)
+	if (pm_state != PM_SUSPEND_PLATFORM_DEEP)
 		return -EINVAL;
 
 	/*
@@ -113,7 +113,7 @@ static void xo1_power_off(void)
 static int xo1_power_state_valid(suspend_state_t pm_state)
 {
 	/* suspend-to-RAM only */
-	return pm_state == PM_SUSPEND_MEM;
+	return pm_state == PM_SUSPEND_PLATFORM_DEEP;
 }
 
 static const struct platform_suspend_ops xo1_suspend_ops = {
Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -459,8 +459,8 @@ static inline void acpi_sleep_dmi_check(
 #ifdef CONFIG_SUSPEND
 static u32 acpi_suspend_states[] = {
 	[PM_SUSPEND_ON] = ACPI_STATE_S0,
-	[PM_SUSPEND_STANDBY] = ACPI_STATE_S1,
-	[PM_SUSPEND_MEM] = ACPI_STATE_S3,
+	[PM_SUSPEND_PLATFORM_SHALLOW] = ACPI_STATE_S1,
+	[PM_SUSPEND_PLATFORM_DEEP] = ACPI_STATE_S3,
 	[PM_SUSPEND_MAX] = ACPI_STATE_S5
 };
 
@@ -567,8 +567,8 @@ static int acpi_suspend_state_valid(susp
 
 	switch (pm_state) {
 	case PM_SUSPEND_ON:
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		acpi_state = acpi_suspend_states[pm_state];
 
 		return sleep_states[acpi_state];
@@ -615,20 +615,20 @@ static const struct platform_suspend_ops
 	.recover = acpi_pm_finish,
 };
 
-static int acpi_freeze_begin(void)
+static int acpi_idle_sleep_begin(void)
 {
 	acpi_scan_lock_acquire();
 	return 0;
 }
 
-static void acpi_freeze_end(void)
+static void acpi_idle_sleep_end(void)
 {
 	acpi_scan_lock_release();
 }
 
-static const struct platform_freeze_ops acpi_freeze_ops = {
-	.begin = acpi_freeze_begin,
-	.end = acpi_freeze_end,
+static const struct platform_idle_sleep_ops acpi_idle_sleep_ops = {
+	.begin = acpi_idle_sleep_begin,
+	.end = acpi_idle_sleep_end,
 };
 
 static void acpi_sleep_suspend_setup(void)
@@ -641,7 +641,7 @@ static void acpi_sleep_suspend_setup(voi
 
 	suspend_set_ops(old_suspend_ordering ?
 		&acpi_suspend_ops_old : &acpi_suspend_ops);
-	freeze_set_ops(&acpi_freeze_ops);
+	idle_sleep_set_ops(&acpi_idle_sleep_ops);
 }
 
 #else /* !CONFIG_SUSPEND */
@@ -787,8 +787,8 @@ static inline void acpi_sleep_hibernate_
 int acpi_suspend(u32 acpi_state)
 {
 	suspend_state_t states[] = {
-		[1] = PM_SUSPEND_STANDBY,
-		[3] = PM_SUSPEND_MEM,
+		[1] = PM_SUSPEND_PLATFORM_SHALLOW,
+		[3] = PM_SUSPEND_PLATFORM_DEEP,
 		[5] = PM_SUSPEND_MAX
 	};
 
Index: linux-pm/drivers/char/apm-emulation.c
===================================================================
--- linux-pm.orig/drivers/char/apm-emulation.c
+++ linux-pm/drivers/char/apm-emulation.c
@@ -317,7 +317,7 @@ apm_ioctl(struct file *filp, u_int cmd,
 			 * Just invoke pm_suspend(), we'll handle it from
 			 * there via the notifier.
 			 */
-			as->suspend_result = pm_suspend(PM_SUSPEND_MEM);
+			as->suspend_result = pm_suspend(PM_SUSPEND_PLATFORM_DEEP);
 		}
 
 		mutex_lock(&state_lock);
@@ -511,12 +511,12 @@ static int kapmd(void *arg)
 
 		case APM_USER_SUSPEND:
 		case APM_SYS_SUSPEND:
-			pm_suspend(PM_SUSPEND_MEM);
+			pm_suspend(PM_SUSPEND_PLATFORM_DEEP);
 			break;
 
 		case APM_CRITICAL_SUSPEND:
 			atomic_inc(&userspace_notification_inhibit);
-			pm_suspend(PM_SUSPEND_MEM);
+			pm_suspend(PM_SUSPEND_PLATFORM_DEEP);
 			atomic_dec(&userspace_notification_inhibit);
 			break;
 		}
Index: linux-pm/drivers/macintosh/via-pmu.c
===================================================================
--- linux-pm.orig/drivers/macintosh/via-pmu.c
+++ linux-pm/drivers/macintosh/via-pmu.c
@@ -2255,7 +2255,7 @@ static void pmac_suspend_enable_irqs(voi
 
 static int pmu_sleep_valid(suspend_state_t state)
 {
-	return state == PM_SUSPEND_MEM
+	return state == PM_SUSPEND_PLATFORM_DEEP
 		&& (pmac_call_feature(PMAC_FTR_SLEEP_STATE, NULL, 0, -1) >= 0);
 }
 
@@ -2288,7 +2288,7 @@ static int pmu_ioctl(struct file *filp,
 	case PMU_IOC_SLEEP:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
-		return pm_suspend(PM_SUSPEND_MEM);
+		return pm_suspend(PM_SUSPEND_PLATFORM_DEEP);
 	case PMU_IOC_CAN_SLEEP:
 		if (pmac_call_feature(PMAC_FTR_SLEEP_STATE, NULL, 0, -1) < 0)
 			return put_user(0, argp);
Index: linux-pm/drivers/regulator/core.c
===================================================================
--- linux-pm.orig/drivers/regulator/core.c
+++ linux-pm/drivers/regulator/core.c
@@ -756,10 +756,10 @@ static int suspend_prepare(struct regula
 		return -EINVAL;
 
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		return suspend_set_state(rdev,
 			&rdev->constraints->state_standby);
-	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_PLATFORM_DEEP:
 		return suspend_set_state(rdev,
 			&rdev->constraints->state_mem);
 	case PM_SUSPEND_MAX:
Index: linux-pm/include/linux/suspend.h
===================================================================
--- linux-pm.orig/include/linux/suspend.h
+++ linux-pm/include/linux/suspend.h
@@ -34,10 +34,10 @@ static inline void pm_restore_console(vo
 typedef int __bitwise suspend_state_t;
 
 #define PM_SUSPEND_ON		((__force suspend_state_t) 0)
-#define PM_SUSPEND_FREEZE	((__force suspend_state_t) 1)
-#define PM_SUSPEND_STANDBY	((__force suspend_state_t) 2)
-#define PM_SUSPEND_MEM		((__force suspend_state_t) 3)
-#define PM_SUSPEND_MIN		PM_SUSPEND_FREEZE
+#define PM_SUSPEND_IDLE_SLEEP	((__force suspend_state_t) 1)
+#define PM_SUSPEND_PLATFORM_SHALLOW	((__force suspend_state_t) 2)
+#define PM_SUSPEND_PLATFORM_DEEP	((__force suspend_state_t) 3)
+#define PM_SUSPEND_MIN		PM_SUSPEND_IDLE_SLEEP
 #define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
 
 enum suspend_stat_step {
@@ -105,8 +105,8 @@ static inline void dpm_save_failed_step(
  *	Valid (ie. supported) states are advertised in /sys/power/state.  Note
  *	that it still may be impossible to enter given system sleep state if the
  *	conditions aren't right.
- *	There is the %suspend_valid_only_mem function available that can be
- *	assigned to this if the platform only supports mem sleep.
+ *	There is the %suspend_valid_only_platform_deep function available that
+ *	can be assigned to this if the platform only supports mem sleep.
  *
  * @begin: Initialise a transition to given system sleep state.
  *	@begin() is executed right prior to suspending devices.  The information
@@ -187,7 +187,7 @@ struct platform_suspend_ops {
 	void (*recover)(void);
 };
 
-struct platform_freeze_ops {
+struct platform_idle_sleep_ops {
 	int (*begin)(void);
 	void (*end)(void);
 };
@@ -198,9 +198,9 @@ struct platform_freeze_ops {
  * @ops: The new suspend operations to set.
  */
 extern void suspend_set_ops(const struct platform_suspend_ops *ops);
-extern int suspend_valid_only_mem(suspend_state_t state);
-extern void freeze_set_ops(const struct platform_freeze_ops *ops);
-extern void freeze_wake(void);
+extern int suspend_valid_only_platform_deep(suspend_state_t state);
+extern void idle_sleep_set_ops(const struct platform_idle_sleep_ops *ops);
+extern void idle_sleep_wake(void);
 
 /**
  * arch_suspend_disable_irqs - disable IRQs for suspend
@@ -222,12 +222,12 @@ extern void arch_suspend_enable_irqs(voi
 
 extern int pm_suspend(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
-#define suspend_valid_only_mem	NULL
+#define suspend_valid_only_platform_deep	NULL
 
 static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
-static inline void freeze_set_ops(const struct platform_freeze_ops *ops) {}
-static inline void freeze_wake(void) {}
+static inline void idle_sleep_set_ops(const struct platform_idle_sleep_ops *ops) {}
+static inline void idle_sleep_wake(void) {}
 #endif /* !CONFIG_SUSPEND */
 
 /* struct pbe is used for creating lists of pages that should be restored
Index: linux-pm/kernel/power/hibernate.c
===================================================================
--- linux-pm.orig/kernel/power/hibernate.c
+++ linux-pm/kernel/power/hibernate.c
@@ -613,7 +613,7 @@ static void power_down(void)
 		break;
 #ifdef CONFIG_SUSPEND
 	case HIBERNATION_SUSPEND:
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(PM_SUSPEND_PLATFORM_DEEP);
 		if (error) {
 			if (hibernation_ops)
 				hibernation_mode = HIBERNATION_PLATFORM;
Index: linux-pm/kernel/power/suspend_test.c
===================================================================
--- linux-pm.orig/kernel/power/suspend_test.c
+++ linux-pm/kernel/power/suspend_test.c
@@ -91,13 +91,13 @@ static void __init test_wakealarm(struct
 		return;
 	}
 
-	if (state == PM_SUSPEND_MEM) {
+	if (state == PM_SUSPEND_PLATFORM_DEEP) {
 		printk(info_test, pm_states[state]);
 		status = pm_suspend(state);
 		if (status == -ENODEV)
-			state = PM_SUSPEND_STANDBY;
+			state = PM_SUSPEND_PLATFORM_SHALLOW;
 	}
-	if (state == PM_SUSPEND_STANDBY) {
+	if (state == PM_SUSPEND_PLATFORM_SHALLOW) {
 		printk(info_test, pm_states[state]);
 		status = pm_suspend(state);
 	}
Index: linux-pm/kernel/power/user.c
===================================================================
--- linux-pm.orig/kernel/power/user.c
+++ linux-pm/kernel/power/user.c
@@ -337,7 +337,7 @@ static long snapshot_ioctl(struct file *
 		 * Tasks are frozen and the notifiers have been called with
 		 * PM_HIBERNATION_PREPARE
 		 */
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(PM_SUSPEND_PLATFORM_DEEP);
 		data->ready = false;
 		break;
 
Index: linux-pm/arch/arm/mach-kirkwood/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-kirkwood/pm.c
+++ linux-pm/arch/arm/mach-kirkwood/pm.c
@@ -48,7 +48,7 @@ static void kirkwood_low_power(void)
 static int kirkwood_suspend_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		kirkwood_low_power();
 		break;
 	default:
@@ -59,7 +59,7 @@ static int kirkwood_suspend_enter(suspen
 
 static int kirkwood_pm_valid_standby(suspend_state_t state)
 {
-	return state == PM_SUSPEND_STANDBY;
+	return state == PM_SUSPEND_PLATFORM_SHALLOW;
 }
 
 static const struct platform_suspend_ops kirkwood_suspend_ops = {
Index: linux-pm/arch/arm/mach-mvebu/kirkwood-pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-mvebu/kirkwood-pm.c
+++ linux-pm/arch/arm/mach-mvebu/kirkwood-pm.c
@@ -47,7 +47,7 @@ static void kirkwood_low_power(void)
 static int kirkwood_suspend_enter(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		kirkwood_low_power();
 		break;
 	default:
@@ -58,7 +58,7 @@ static int kirkwood_suspend_enter(suspen
 
 static int kirkwood_pm_valid_standby(suspend_state_t state)
 {
-	return state == PM_SUSPEND_STANDBY;
+	return state == PM_SUSPEND_PLATFORM_SHALLOW;
 }
 
 static const struct platform_suspend_ops kirkwood_suspend_ops = {
Index: linux-pm/arch/arm/mach-pxa/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-pxa/pm.c
+++ linux-pm/arch/arm/mach-pxa/pm.c
@@ -33,7 +33,7 @@ int pxa_pm_enter(suspend_state_t state)
 #endif
 
 	/* skip registers saving for standby */
-	if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->save) {
+	if (state != PM_SUSPEND_PLATFORM_SHALLOW && pxa_cpu_pm_fns->save) {
 		pxa_cpu_pm_fns->save(sleep_save);
 		/* before sleeping, calculate and save a checksum */
 		for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
@@ -43,7 +43,7 @@ int pxa_pm_enter(suspend_state_t state)
 	/* *** go zzz *** */
 	pxa_cpu_pm_fns->enter(state);
 
-	if (state != PM_SUSPEND_STANDBY && pxa_cpu_pm_fns->restore) {
+	if (state != PM_SUSPEND_PLATFORM_SHALLOW && pxa_cpu_pm_fns->restore) {
 		/* after sleeping, validate the checksum */
 		for (i = 0; i < pxa_cpu_pm_fns->save_count - 1; i++)
 			checksum += sleep_save[i];
Index: linux-pm/arch/avr32/mach-at32ap/pm-at32ap700x.S
===================================================================
--- linux-pm.orig/arch/avr32/mach-at32ap/pm-at32ap700x.S
+++ linux-pm/arch/avr32/mach-at32ap/pm-at32ap700x.S
@@ -97,7 +97,7 @@ pm_irq0:
 	/*
 	 * void cpu_enter_standby(unsigned long sdramc_base)
 	 *
-	 * Enter PM_SUSPEND_STANDBY mode. At this point, all drivers
+	 * Enter PM_SUSPEND_PLATFORM_SHALLOW mode. At this point, all drivers
 	 * are suspended and interrupts are disabled. Interrupts
 	 * marked as 'wakeup' event sources may still come along and
 	 * get us out of here.
Index: linux-pm/arch/blackfin/mach-bf609/pm.c
===================================================================
--- linux-pm.orig/arch/blackfin/mach-bf609/pm.c
+++ linux-pm/arch/blackfin/mach-bf609/pm.c
@@ -264,7 +264,7 @@ void bf609_cpu_pm_enter(suspend_state_t
 	if (error < 0)
 		printk(KERN_DEBUG "Unable to get irq wake\n");
 
-	if (state == PM_SUSPEND_STANDBY)
+	if (state == PM_SUSPEND_PLATFORM_SHALLOW)
 		bfin_deepsleep(wakeup, wakeup_pol);
 	else {
 		bfin_hibernate(wakeup, wakeup_pol);
Index: linux-pm/arch/powerpc/platforms/52xx/mpc52xx_pm.c
===================================================================
--- linux-pm.orig/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ linux-pm/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -26,7 +26,7 @@ struct mpc52xx_suspend mpc52xx_suspend;
 static int mpc52xx_pm_valid(suspend_state_t state)
 {
 	switch (state) {
-	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_PLATFORM_SHALLOW:
 		return 1;
 	default:
 		return 0;
Index: linux-pm/arch/powerpc/sysdev/fsl_pmc.c
===================================================================
--- linux-pm.orig/arch/powerpc/sysdev/fsl_pmc.c
+++ linux-pm/arch/powerpc/sysdev/fsl_pmc.c
@@ -50,7 +50,7 @@ static int pmc_suspend_enter(suspend_sta
 
 static int pmc_suspend_valid(suspend_state_t state)
 {
-	if (state != PM_SUSPEND_STANDBY)
+	if (state != PM_SUSPEND_PLATFORM_SHALLOW)
 		return 0;
 	return 1;
 }
Index: linux-pm/arch/unicore32/kernel/pm.c
===================================================================
--- linux-pm.orig/arch/unicore32/kernel/pm.c
+++ linux-pm/arch/unicore32/kernel/pm.c
@@ -31,7 +31,7 @@ int puv3_pm_enter(suspend_state_t state)
 	int i;
 
 	/* skip registers saving for standby */
-	if (state != PM_SUSPEND_STANDBY) {
+	if (state != PM_SUSPEND_PLATFORM_SHALLOW) {
 		puv3_cpu_pm_fns->save(sleep_save);
 		/* before sleeping, calculate and save a checksum */
 		for (i = 0; i < puv3_cpu_pm_fns->save_count - 1; i++)
@@ -47,7 +47,7 @@ int puv3_pm_enter(suspend_state_t state)
 #ifdef CONFIG_PCI
 	pci_puv3_preinit();
 #endif
-	if (state != PM_SUSPEND_STANDBY) {
+	if (state != PM_SUSPEND_PLATFORM_SHALLOW) {
 		/* after sleeping, validate the checksum */
 		for (i = 0; i < puv3_cpu_pm_fns->save_count - 1; i++)
 			checksum += sleep_save[i];
Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -670,8 +670,8 @@ struct dev_pm_domain {
  * during the suspend/resume cycle -- and can't issue wakeup events.
  *
  * More power-aware drivers may also use low power states at runtime as
- * well as during system sleep states like PM_SUSPEND_STANDBY.  They may
- * be able to use wakeup events to exit from runtime low-power states,
+ * well as during system sleep states like PM_SUSPEND_PLATFORM_SHALLOW.  They
+ * may be able to use wakeup events to exit from runtime low-power states,
  * or from system low-power states such as standby or suspend-to-RAM.
  */
 
Index: linux-pm/arch/arm/mach-exynos/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-exynos/pm.c
+++ linux-pm/arch/arm/mach-exynos/pm.c
@@ -428,7 +428,7 @@ static const struct platform_suspend_ops
 	.enter		= exynos_suspend_enter,
 	.prepare	= exynos_suspend_prepare,
 	.finish		= exynos_suspend_finish,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 static int exynos_cpu_pm_notifier(struct notifier_block *self,
Index: linux-pm/arch/arm/mach-highbank/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-highbank/pm.c
+++ linux-pm/arch/arm/mach-highbank/pm.c
@@ -46,7 +46,7 @@ static int highbank_pm_enter(suspend_sta
 
 static const struct platform_suspend_ops highbank_pm_ops = {
 	.enter = highbank_pm_enter,
-	.valid = suspend_valid_only_mem,
+	.valid = suspend_valid_only_platform_deep,
 };
 
 void __init highbank_pm_init(void)
Index: linux-pm/arch/arm/mach-lpc32xx/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-lpc32xx/pm.c
+++ linux-pm/arch/arm/mach-lpc32xx/pm.c
@@ -124,7 +124,7 @@ static int lpc32xx_pm_enter(suspend_stat
 }
 
 static const struct platform_suspend_ops lpc32xx_pm_ops = {
-	.valid	= suspend_valid_only_mem,
+	.valid	= suspend_valid_only_platform_deep,
 	.enter	= lpc32xx_pm_enter,
 };
 
Index: linux-pm/arch/arm/mach-pxa/sharpsl_pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-pxa/sharpsl_pm.c
+++ linux-pm/arch/arm/mach-pxa/sharpsl_pm.c
@@ -825,7 +825,7 @@ static const struct platform_suspend_ops
 	.prepare	= pxa_pm_prepare,
 	.finish		= pxa_pm_finish,
 	.enter		= corgi_pxa_pm_enter,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 #endif
 
Index: linux-pm/arch/arm/mach-sa1100/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-sa1100/pm.c
+++ linux-pm/arch/arm/mach-sa1100/pm.c
@@ -115,7 +115,7 @@ static int sa11x0_pm_enter(suspend_state
 
 static const struct platform_suspend_ops sa11x0_pm_ops = {
 	.enter		= sa11x0_pm_enter,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 int __init sa11x0_pm_init(void)
Index: linux-pm/arch/arm/mach-shmobile/suspend.c
===================================================================
--- linux-pm.orig/arch/arm/mach-shmobile/suspend.c
+++ linux-pm/arch/arm/mach-shmobile/suspend.c
@@ -38,7 +38,7 @@ struct platform_suspend_ops shmobile_sus
 	.begin		= shmobile_suspend_begin,
 	.end		= shmobile_suspend_end,
 	.enter		= shmobile_suspend_default_enter,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 int __init shmobile_suspend_init(void)
Index: linux-pm/arch/arm/mach-tegra/pm.c
===================================================================
--- linux-pm.orig/arch/arm/mach-tegra/pm.c
+++ linux-pm/arch/arm/mach-tegra/pm.c
@@ -342,7 +342,7 @@ static int tegra_suspend_enter(suspend_s
 }
 
 static const struct platform_suspend_ops tegra_suspend_ops = {
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 	.enter		= tegra_suspend_enter,
 };
 
Index: linux-pm/arch/arm/plat-samsung/pm.c
===================================================================
--- linux-pm.orig/arch/arm/plat-samsung/pm.c
+++ linux-pm/arch/arm/plat-samsung/pm.c
@@ -209,7 +209,7 @@ static const struct platform_suspend_ops
 	.enter		= s3c_pm_enter,
 	.prepare	= s3c_pm_prepare,
 	.finish		= s3c_pm_finish,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 /* s3c_pm_init
Index: linux-pm/arch/mips/alchemy/devboards/pm.c
===================================================================
--- linux-pm.orig/arch/mips/alchemy/devboards/pm.c
+++ linux-pm/arch/mips/alchemy/devboards/pm.c
@@ -111,7 +111,7 @@ static void db1x_pm_end(void)
 }
 
 static const struct platform_suspend_ops db1x_pm_ops = {
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 	.begin		= db1x_pm_begin,
 	.enter		= db1x_pm_enter,
 	.end		= db1x_pm_end,
Index: linux-pm/arch/mips/jz4740/pm.c
===================================================================
--- linux-pm.orig/arch/mips/jz4740/pm.c
+++ linux-pm/arch/mips/jz4740/pm.c
@@ -40,7 +40,7 @@ static int jz4740_pm_enter(suspend_state
 }
 
 static const struct platform_suspend_ops jz4740_pm_ops = {
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 	.enter		= jz4740_pm_enter,
 };
 
Index: linux-pm/arch/sh/boards/mach-hp6xx/pm.c
===================================================================
--- linux-pm.orig/arch/sh/boards/mach-hp6xx/pm.c
+++ linux-pm/arch/sh/boards/mach-hp6xx/pm.c
@@ -146,7 +146,7 @@ static int hp6x0_pm_enter(suspend_state_
 
 static const struct platform_suspend_ops hp6x0_pm_ops = {
 	.enter		= hp6x0_pm_enter,
-	.valid		= suspend_valid_only_mem,
+	.valid		= suspend_valid_only_platform_deep,
 };
 
 static int __init hp6x0_pm_init(void)
Index: linux-pm/arch/sh/kernel/cpu/shmobile/pm.c
===================================================================
--- linux-pm.orig/arch/sh/kernel/cpu/shmobile/pm.c
+++ linux-pm/arch/sh/kernel/cpu/shmobile/pm.c
@@ -144,7 +144,7 @@ static int sh_pm_enter(suspend_state_t s
 
 static const struct platform_suspend_ops sh_pm_ops = {
 	.enter          = sh_pm_enter,
-	.valid          = suspend_valid_only_mem,
+	.valid          = suspend_valid_only_platform_deep,
 };
 
 static int __init sh_pm_init(void)
Index: linux-pm/drivers/base/power/wakeup.c
===================================================================
--- linux-pm.orig/drivers/base/power/wakeup.c
+++ linux-pm/drivers/base/power/wakeup.c
@@ -390,9 +390,9 @@ static void wakeup_source_activate(struc
 
 	/*
 	 * active wakeup source should bring the system
-	 * out of PM_SUSPEND_FREEZE state
+	 * out of PM_SUSPEND_IDLE_SLEEP state
 	 */
-	freeze_wake();
+	idle_sleep_wake();
 
 	ws->active = true;
 	ws->active_count++;
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -35,43 +35,43 @@ static const char *pm_labels[] = { "mem"
 const char *pm_states[PM_SUSPEND_MAX];
 
 static const struct platform_suspend_ops *suspend_ops;
-static const struct platform_freeze_ops *freeze_ops;
-static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
-static bool suspend_freeze_wake;
+static const struct platform_idle_sleep_ops *idle_sleep_ops;
+static DECLARE_WAIT_QUEUE_HEAD(idle_sleep_wait_head);
+static bool idle_sleep_terminated;
 
-void freeze_set_ops(const struct platform_freeze_ops *ops)
+void idle_sleep_set_ops(const struct platform_idle_sleep_ops *ops)
 {
 	lock_system_sleep();
-	freeze_ops = ops;
+	idle_sleep_ops = ops;
 	unlock_system_sleep();
 }
 
-static void freeze_begin(void)
+static void suspend_to_idle_begin(void)
 {
-	suspend_freeze_wake = false;
+	idle_sleep_terminated = false;
 }
 
-static void freeze_enter(void)
+static void idle_sleep_enter(void)
 {
 	cpuidle_use_deepest_state(true);
 	cpuidle_resume();
-	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
+	wait_event(idle_sleep_wait_head, idle_sleep_terminated);
 	cpuidle_pause();
 	cpuidle_use_deepest_state(false);
 }
 
-void freeze_wake(void)
+void idle_sleep_wake(void)
 {
-	suspend_freeze_wake = true;
-	wake_up(&suspend_freeze_wait_head);
+	idle_sleep_terminated = true;
+	wake_up(&idle_sleep_wait_head);
 }
-EXPORT_SYMBOL_GPL(freeze_wake);
+EXPORT_SYMBOL_GPL(idle_sleep_wake);
 
 static bool valid_state(suspend_state_t state)
 {
 	/*
-	 * PM_SUSPEND_STANDBY and PM_SUSPEND_MEM states need low level
-	 * support and need to be valid to the low level
+	 * PM_SUSPEND_PLATFORM_SHALLOW and PM_SUSPEND_PLATFORM_DEEP states need
+	 * low level support and need to be valid to the low level
 	 * implementation, no valid callback implies that none are valid.
 	 */
 	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
@@ -88,7 +88,7 @@ static bool relative_states;
 static int __init sleep_states_setup(char *str)
 {
 	relative_states = !strncmp(str, "1", 1);
-	pm_states[PM_SUSPEND_FREEZE] = pm_labels[relative_states ? 0 : 2];
+	pm_states[PM_SUSPEND_IDLE_SLEEP] = pm_labels[relative_states ? 0 : 2];
 	return 1;
 }
 
@@ -106,7 +106,7 @@ void suspend_set_ops(const struct platfo
 	lock_system_sleep();
 
 	suspend_ops = ops;
-	for (i = PM_SUSPEND_MEM; i >= PM_SUSPEND_STANDBY; i--)
+	for (i = PM_SUSPEND_PLATFORM_DEEP; i >= PM_SUSPEND_PLATFORM_SHALLOW; i--)
 		if (valid_state(i)) {
 			pm_states[i] = pm_labels[j++];
 		} else if (!relative_states) {
@@ -114,7 +114,7 @@ void suspend_set_ops(const struct platfo
 			j++;
 		}
 
-	pm_states[PM_SUSPEND_FREEZE] = pm_labels[j];
+	pm_states[PM_SUSPEND_IDLE_SLEEP] = pm_labels[j];
 
 	unlock_system_sleep();
 }
@@ -129,43 +129,45 @@ EXPORT_SYMBOL_GPL(suspend_set_ops);
  */
 int suspend_valid_only_mem(suspend_state_t state)
 {
-	return state == PM_SUSPEND_MEM;
+	return state == PM_SUSPEND_PLATFORM_DEEP;
 }
 EXPORT_SYMBOL_GPL(suspend_valid_only_mem);
 
 static bool sleep_state_supported(suspend_state_t state)
 {
-	return state == PM_SUSPEND_FREEZE || (suspend_ops && suspend_ops->enter);
+	return state == PM_SUSPEND_IDLE_SLEEP
+		|| (suspend_ops && suspend_ops->enter);
 }
 
 static int platform_suspend_prepare(suspend_state_t state)
 {
-	return state != PM_SUSPEND_FREEZE && suspend_ops->prepare ?
+	return state != PM_SUSPEND_IDLE_SLEEP && suspend_ops->prepare ?
 		suspend_ops->prepare() : 0;
 }
 
 static int platform_suspend_prepare_late(suspend_state_t state)
 {
-	return state != PM_SUSPEND_FREEZE && suspend_ops->prepare_late ?
+	return state != PM_SUSPEND_IDLE_SLEEP && suspend_ops->prepare_late ?
 		suspend_ops->prepare_late() : 0;
 }
 
 static void platform_suspend_wake(suspend_state_t state)
 {
-	if (state != PM_SUSPEND_FREEZE && suspend_ops->wake)
+	if (state != PM_SUSPEND_IDLE_SLEEP && suspend_ops->wake)
 		suspend_ops->wake();
 }
 
 static void platform_suspend_finish(suspend_state_t state)
 {
-	if (state != PM_SUSPEND_FREEZE && suspend_ops->finish)
+	if (state != PM_SUSPEND_IDLE_SLEEP && suspend_ops->finish)
 		suspend_ops->finish();
 }
 
 static int platform_suspend_begin(suspend_state_t state)
 {
-	if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->begin)
-		return freeze_ops->begin();
+	if (state == PM_SUSPEND_IDLE_SLEEP && idle_sleep_ops
+	    && idle_sleep_ops->begin)
+		return idle_sleep_ops->begin();
 	else if (suspend_ops->begin)
 		return suspend_ops->begin(state);
 	else
@@ -174,21 +176,22 @@ static int platform_suspend_begin(suspen
 
 static void platform_suspend_end(suspend_state_t state)
 {
-	if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->end)
-		freeze_ops->end();
+	if (state == PM_SUSPEND_IDLE_SLEEP && idle_sleep_ops
+	    && idle_sleep_ops->end)
+		idle_sleep_ops->end();
 	else if (suspend_ops->end)
 		suspend_ops->end();
 }
 
 static void platform_suspend_recover(suspend_state_t state)
 {
-	if (state != PM_SUSPEND_FREEZE && suspend_ops->recover)
+	if (state != PM_SUSPEND_IDLE_SLEEP && suspend_ops->recover)
 		suspend_ops->recover();
 }
 
 static bool platform_suspend_again(suspend_state_t state)
 {
-	return state != PM_SUSPEND_FREEZE && suspend_ops->suspend_again ?
+	return state != PM_SUSPEND_IDLE_SLEEP && suspend_ops->suspend_again ?
 		suspend_ops->suspend_again() : false;
 }
 
@@ -278,14 +281,14 @@ static int suspend_enter(suspend_state_t
 		goto Platform_wake;
 
 	/*
-	 * PM_SUSPEND_FREEZE equals
+	 * PM_SUSPEND_IDLE_SLEEP equals
 	 * frozen processes + suspended devices + idle processors.
-	 * Thus we should invoke freeze_enter() soon after
+	 * Thus we should invoke idle_sleep_enter() soon after
 	 * all the devices are suspended.
 	 */
-	if (state == PM_SUSPEND_FREEZE) {
+	if (state == PM_SUSPEND_IDLE_SLEEP) {
 		trace_suspend_resume(TPS("machine_suspend"), state, true);
-		freeze_enter();
+		idle_sleep_enter();
 		trace_suspend_resume(TPS("machine_suspend"), state, false);
 		goto Platform_wake;
 	}
@@ -400,10 +403,10 @@ static int enter_state(suspend_state_t s
 	int error;
 
 	trace_suspend_resume(TPS("suspend_enter"), state, true);
-	if (state == PM_SUSPEND_FREEZE) {
+	if (state == PM_SUSPEND_IDLE_SLEEP) {
 #ifdef CONFIG_PM_DEBUG
 		if (pm_test_level != TEST_NONE && pm_test_level <= TEST_CPUS) {
-			pr_warning("PM: Unsupported test mode for freeze state,"
+			pr_warning("PM: Unsupported test mode for idle sleep state,"
 				   "please choose none/freezer/devices/platform.\n");
 			return -EAGAIN;
 		}
@@ -414,8 +417,8 @@ static int enter_state(suspend_state_t s
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
-	if (state == PM_SUSPEND_FREEZE)
-		freeze_begin();
+	if (state == PM_SUSPEND_IDLE_SLEEP)
+		suspend_to_idle_begin();
 
 	trace_suspend_resume(TPS("sync_filesystems"), 0, true);
 	printk(KERN_INFO "PM: Syncing filesystems ... ");

