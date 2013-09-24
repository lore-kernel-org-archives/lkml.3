Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3IXMvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:51:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54121 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3IXMuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:50:55 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-24-52418aaef1e6
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: rjw@sisk.pl, kgene.kim@samsung.com
Cc: viresh.kumar@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        s.nawrocki@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, t.stanislaws@samsung.com,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v5 3/3] ARM: s5pv210: Migrate clock handling to Common Clock
 Framework
Date: Tue, 24 Sep 2013 14:50:09 +0200
Message-id: <1380027009-2239-4-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAd11XY5BBs3/hC02zljPajFp3QEm
	i6dNP9gt5h85x2px7tVKRoveBVfZLM42vWG32PT4GqvFwrYlLBaXd81hs/jce4TRYsb5fUwW
	ty/zWpxec4rZYu2Ru+wWS69fBBoy4SKbxYTpa1ks+hf2MlkcXgE0eN3L6SwWh9+0s1q8OtjG
	YjGv/SWrxbEZSxgtVu36w2ix8auHg7THmnlrGD1amnvYPBZ8vsLu8XfVC2aPnbPusnusXP6F
	zePV6pmsHneu7WHz2Lyk3uPguz1MHn1bVjF6PFrcwujxeZOcx8a5oQF8UVw2Kak5mWWpRfp2
	CVwZq65sYi1Yq12xp/caewPjFJUuRg4OCQETiQMzlbsYOYFMMYkL99azdTFycQgJLGKUWHH5
	DwuE084ksbl5DytIFZuAucTEZ5tYQJpFBNQkpm5yBqlhFtjEKvH/Yz87SI2wQITE/o6dYPUs
	AqoSx84uZAaxeQV8JbZ9mMMEsU1B4uflE2wgNqeAn8SMd9/AaoSAavb938o0gZF3ASPDKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgeHsmvYNxVYPFIUYBDkYlHt4LCQ5BQqyJZcWVuYcY
	JTiYlUR4NWsdg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFw
	SjUwdjVJyvFc0q9Vz4i/JCwnsaZ6lpBSJkOO8XcDlwwp37eflR8/s9/xPprtRG7bjqSfO6I2
	PW327FsjaLfiYGXuapkzbxOvM5/ccs7qVFmruviJmsCUp4tO3c4ViLhX1LfO7rEHv5KWkOXj
	zDcdFf8vzbt89dPaozKsF7aanp9yYGvDd9mKyb7tSizFGYmGWsxFxYkAZfUEArMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates the s5pv210 platform to use new clock driver
using Common Clock Framework.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig         |  9 +++++++++
 arch/arm/mach-s5pv210/Makefile        |  4 ++--
 arch/arm/mach-s5pv210/common.c        | 17 +++++++++++++++++
 arch/arm/mach-s5pv210/common.h        | 10 ++++++++++
 arch/arm/mach-s5pv210/mach-goni.c     |  2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c |  2 +-
 arch/arm/plat-samsung/Kconfig         |  2 +-
 7 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index caaedaf..abad41f 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -11,6 +11,7 @@ if ARCH_S5PV210
 
 config CPU_S5PV210
 	bool
+	select S5P_CLOCK if !COMMON_CLK
 	select S5P_EXT_INT
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
@@ -69,6 +70,14 @@ config S5PV210_SETUP_USB_PHY
 	help
 	  Common setup code for USB PHY controller
 
+config COMMON_CLK_S5PV210
+	bool "Common Clock Framework support"
+	default y
+	select COMMON_CLK
+	help
+	  Enable this option to use new clock driver
+	  based on Common Clock Framework.
+
 menu "S5PC110 Machines"
 
 config MACH_AQUILA
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 1c4e419..0c67fe2 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -12,8 +12,8 @@ obj-				:=
 
 # Core
 
-obj-y				+= common.o clock.o
-
+obj-y					+= common.o
+obj-$(CONFIG_S5P_CLOCK)			+= clock.o
 obj-$(CONFIG_PM)		+= pm.o
 
 obj-y				+= dma.o
diff --git a/arch/arm/mach-s5pv210/common.c b/arch/arm/mach-s5pv210/common.c
index 26027a2..48ce5f8 100644
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/dma-mapping.h>
 #include <linux/serial_core.h>
+#include <linux/of.h>
 
 #include <asm/proc-fns.h>
 #include <asm/mach/arch.h>
@@ -34,7 +35,13 @@
 #include <mach/regs-clock.h>
 
 #include <plat/cpu.h>
+
+#ifdef CONFIG_S5P_CLOCK
 #include <plat/clock.h>
+#else
+#include <linux/clk-provider.h>
+#endif
+
 #include <plat/devs.h>
 #include <plat/sdhci.h>
 #include <plat/adc-core.h>
@@ -50,6 +57,9 @@
 
 #include "common.h"
 
+/* External clock frequency */
+static unsigned long xusbxti_f;
+
 static const char name_s5pv210[] = "S5PV210/S5PC110";
 
 static struct cpu_table cpu_ids[] __initdata = {
@@ -229,12 +239,16 @@ void __init s5pv210_map_io(void)
 
 void __init s5pv210_init_clocks(int xtal)
 {
+#ifdef CONFIG_S5P_CLOCK
 	printk(KERN_DEBUG "%s: initializing clocks\n", __func__);
 
 	s3c24xx_register_baseclocks(xtal);
 	s5p_register_clocks(xtal);
 	s5pv210_register_clocks();
 	s5pv210_setup_clocks();
+#else
+	xusbxti_f = xtal;
+#endif
 }
 
 void __init s5pv210_init_irq(void)
@@ -248,6 +262,9 @@ void __init s5pv210_init_irq(void)
 	vic[3] = ~0;
 
 	s5p_init_irq(vic, ARRAY_SIZE(vic));
+
+	if (!of_have_populated_dt())
+		s5pv210_clk_init(NULL, 0, xusbxti_f, S3C_VA_SYS);
 }
 
 struct bus_type s5pv210_subsys = {
diff --git a/arch/arm/mach-s5pv210/common.h b/arch/arm/mach-s5pv210/common.h
index fe1beb5..cf3136a 100644
--- a/arch/arm/mach-s5pv210/common.h
+++ b/arch/arm/mach-s5pv210/common.h
@@ -14,6 +14,16 @@
 
 #include <linux/reboot.h>
 
+#ifdef CONFIG_COMMON_CLK_S5PV210
+void s5pv210_clk_init(struct device_node *np,
+			    unsigned long xxti_f, unsigned long xusbxti_f,
+			    void __iomem *reg_base);
+#else
+static inline void s5pv210_clk_init(struct device_node *np,
+			    unsigned long xxti_f, unsigned long xusbxti_f,
+			    void __iomem *reg_base) {}
+#endif
+
 void s5pv210_init_io(struct map_desc *mach_desc, int size);
 void s5pv210_init_irq(void);
 
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 282d714..4c9681b 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -966,7 +966,7 @@ static void __init goni_sound_init(void)
 static void __init goni_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
-	s3c24xx_init_clocks(clk_xusbxti.rate);
+	s3c24xx_init_clocks(24000000);
 	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
index 6d72bb99..f13aa99 100644
--- a/arch/arm/mach-s5pv210/mach-smdkv210.c
+++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
@@ -284,7 +284,7 @@ static struct platform_pwm_backlight_data smdkv210_bl_data = {
 static void __init smdkv210_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
-	s3c24xx_init_clocks(clk_xusbxti.rate);
+	s3c24xx_init_clocks(24000000);
 	s3c24xx_init_uarts(smdkv210_uartcfgs, ARRAY_SIZE(smdkv210_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM2, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 7dfba93..2a98613 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -91,7 +91,7 @@ config SAMSUNG_CLKSRC
 	  used by newer systems such as the S3C64XX.
 
 config S5P_CLOCK
-	def_bool (ARCH_S5P64X0 || ARCH_S5PC100 || ARCH_S5PV210)
+	def_bool (ARCH_S5P64X0 || ARCH_S5PC100)
 	help
 	  Support common clock part for ARCH_S5P and ARCH_EXYNOS SoCs
 
-- 
1.8.1.2

