Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3IURnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:43:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58286 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3IURnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:43:08 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-f4-523ddaabbe36
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: mturquette@linaro.org
Cc: rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, ben-linux@fluff.org, kyungmin.park@samsung.com,
        linux@arm.linux.org.uk, tomasz.figa@gmail.com, t.figa@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com, rjw@sisk.pl,
        viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v4 3/3] ARM: s5pv210: Migrate clock handling to Common Clock
 Framework
Date: Sat, 21 Sep 2013 19:42:22 +0200
Message-id: <1379785342-25107-4-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jQd3Vt2yDDE5+4rOYtO4Ak8XTph/s
	FvOPnGO1OPdqJaNF74KrbBZnm96wW2x6fI3VYmHbEhaLy7vmsFl87j3CaHH7Mq/F6TWnmC2W
	Xr8I1DrhIpvFhOlrWSz6F/YyWRxeATRu3cvpLBaH37SzWrw62MZisX7GaxaLYzOWMFqs2vWH
	0WLjVw8HCY8189YwerQ097B5LPh8hd3j76oXzB47Z91l91i5/Aubx6vVM1k97lzbw+axeUm9
	x8F3e5g8+rasYvR4tLiF0ePzJjmPjXNDA/iiuGxSUnMyy1KL9O0SuDJWXdnEWrBWu2JP7zX2
	BsYpKl2MnBwSAiYS815NYoOwxSQu3FsPZHNxCAlMZ5TYsecoI4TTziSx7PR2sCo2AXOJic82
	sYDYIgKSEg8+T2cBKWIWeMAiMfPRdUaQhLBAhMSHd1vAilgEVCVOfNnHBGLzCvhJzL3whBVi
	nYLEz8snwIZyCvhLNC5YANYrBFQz+0EX2wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLz
	czcxgqPqmfQOxlUNFocYBTgYlXh4BRJsg4RYE8uKK3MPMUpwMCuJ8IrsAgrxpiRWVqUW5ccX
	leakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgDF7ifm7h4wvGe7pXXLtzqHG9
	uU/t3YiF80SlbyVn+P+wPHxd40b9jq1HGFLuSi455bmmaraAVvETsQTZoESbeV/Ym8OvLD/m
	tGPPxF1qy9UmOV7O/cdb8Uchwor7zv2WL9uyvX2fWbyQVuyoZbg9ff/HO9PZeFbYz+tQPec9
	cwtn98KkQJ30eUosxRmJhlrMRcWJAMlC+w6mAgAA
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

