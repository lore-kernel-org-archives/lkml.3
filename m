Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3IXQx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:53:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13110 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3IXQx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:53:56 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a8-5241c39e197c
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: mturquette@linaro.org, t.figa@samsung.com, s.nawrocki@samsung.com,
        yadi.brar@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH 3/3] ARM: s5pc100: Migrate clock handling to Common Clock
 Framework
Date: Tue, 24 Sep 2013 18:53:25 +0200
Message-id: <1380041605-15736-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1380041605-15736-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380041605-15736-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jAd15hx2DDJbd0LaYtO4Ak8X8I+dY
	Lc69WslocbbpDbvFpsfXWC0u75rDZjHj/D4mi9NrTjFbLL1+kcni6YSLbBYTpq9lsTi8Aqht
	3cvpQNabdlaLVwfbWCzWz3jNYjFn+jsmB0GPNfPWMHos+HyF3ePvqhfMHiuXf2HzeLV6JqvH
	nWt72Dw2L6n3OPhuD5NH35ZVjB6fN8l5bJwbGsAdxWWTkpqTWZZapG+XwJWx//dX9oKT6hWt
	M9azNjD+UOhi5OSQEDCR+DjtIxOELSZx4d56ti5GLg4hgUWMEl+fv2eCcNqZJM63TWEBqWIT
	MJeY+GwTmC0iICsxcfIXZpAiZoG9zBJTzq5mBUkIC4RKzJ+znx3EZhFQlWhfOY0NxOYV8JOY
	3NDGArFOQeLn5RNgcU4Bf4kTX8+D9QoB1XSs+M8+gZF3ASPDKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgoH8mvYNxVYPFIUYBDkYlHt4LCQ5BQqyJZcWVuYcYJTiYlUR4zTc4BgnxpiRW
	VqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgZHadkFX3KGX3FkGP
	x4f4Cotape8em7o3rKDhc5rFleuamlpdvzm2HTyfK1p8jN9UPorxuozD0ckuke5LdAXPvZx6
	kU9a0Vp3G9uqu2ci1mj+m272/ojftkLbdKfpJTMSzIQei/RqTnV4VxjAG32txD07P0bh+9V3
	fXF5WtICKVs+nJlsoiKpxFKckWioxVxUnAgAZ+VYmHYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates the s5pc100 platform to use new clock driver
using Common Clock Framework.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pc100/Kconfig         |  8 ++++++++
 arch/arm/mach-s5pc100/Makefile        |  4 ++--
 arch/arm/mach-s5pc100/common.c        | 23 ++++++++++++++++++++++-
 arch/arm/mach-s5pc100/common.h        | 13 +++++++++++++
 arch/arm/mach-s5pc100/mach-smdkc100.c |  3 ++-
 arch/arm/plat-samsung/Kconfig         |  2 +-
 6 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-s5pc100/Kconfig b/arch/arm/mach-s5pc100/Kconfig
index 15170be..2f27923 100644
--- a/arch/arm/mach-s5pc100/Kconfig
+++ b/arch/arm/mach-s5pc100/Kconfig
@@ -11,6 +11,7 @@ config CPU_S5PC100
 	bool
 	select S5P_EXT_INT
 	select SAMSUNG_DMADEV
+	select S5P_CLOCK if !COMMON_CLK
 	help
 	  Enable S5PC100 CPU support
 
@@ -50,6 +51,13 @@ config S5PC100_SETUP_SPI
 	help
 	  Common setup code for SPI GPIO configurations.
 
+config COMMON_CLK_S5PC100
+	bool "Common Clock Framework support"
+	default y
+	select COMMON_CLK
+	help
+	  Common setup code for common clock framework.
+
 config MACH_SMDKC100
 	bool "SMDKC100"
 	select CPU_S5PC100
diff --git a/arch/arm/mach-s5pc100/Makefile b/arch/arm/mach-s5pc100/Makefile
index 118c711..74b90ec 100644
--- a/arch/arm/mach-s5pc100/Makefile
+++ b/arch/arm/mach-s5pc100/Makefile
@@ -11,8 +11,8 @@ obj-				:=
 
 # Core
 
-obj-y				+= common.o clock.o
-
+obj-y				+= common.o
+obj-$(CONFIG_S5P_CLOCK)	+= clock.o
 obj-y				+= dma.o
 
 # machine support
diff --git a/arch/arm/mach-s5pc100/common.c b/arch/arm/mach-s5pc100/common.c
index c5a8eea..d8db7b2 100644
--- a/arch/arm/mach-s5pc100/common.c
+++ b/arch/arm/mach-s5pc100/common.c
@@ -40,7 +40,13 @@
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
+
+#ifdef CONFIG_S5P_CLOCK
 #include <plat/clock.h>
+#else
+#include <linux/clk-provider.h>
+#endif
+
 #include <plat/sdhci.h>
 #include <plat/adc-core.h>
 #include <plat/ata-core.h>
@@ -54,6 +60,18 @@
 
 #include "common.h"
 
+static unsigned long xxti_f, xusbxti_f;
+
+void __init s5pc100_set_xxti_freq(unsigned long freq)
+{
+	xxti_f = freq;
+}
+
+void __init s5pc100_set_xusbxti_freq(unsigned long freq)
+{
+	xusbxti_f = freq;
+}
+
 static const char name_s5pc100[] = "S5PC100";
 
 static struct cpu_table cpu_ids[] __initdata = {
@@ -201,13 +219,14 @@ void __init s5pc100_map_io(void)
 
 void __init s5pc100_init_clocks(int xtal)
 {
+#ifdef CONFIG_S5P_CLOCK
 	printk(KERN_DEBUG "%s: initializing clocks\n", __func__);
 
 	s3c24xx_register_baseclocks(xtal);
 	s5p_register_clocks(xtal);
 	s5pc100_register_clocks();
 	s5pc100_setup_clocks();
-	samsung_wdt_reset_init(S3C_VA_WATCHDOG);
+#endif
 }
 
 void __init s5pc100_init_irq(void)
@@ -216,6 +235,8 @@ void __init s5pc100_init_irq(void)
 
 	/* VIC0, VIC1, and VIC2 are fully populated. */
 	s5p_init_irq(vic, ARRAY_SIZE(vic));
+	s5pc100_clk_init(NULL, xxti_f, xusbxti_f, S3C_VA_SYS);
+	samsung_wdt_reset_init(S3C_VA_WATCHDOG);
 }
 
 static struct bus_type s5pc100_subsys = {
diff --git a/arch/arm/mach-s5pc100/common.h b/arch/arm/mach-s5pc100/common.h
index 08d782d..d7d80b8 100644
--- a/arch/arm/mach-s5pc100/common.h
+++ b/arch/arm/mach-s5pc100/common.h
@@ -14,6 +14,19 @@
 
 #include <linux/reboot.h>
 
+void s5pc100_set_xxti_freq(unsigned long freq);
+void s5pc100_set_xusbxti_freq(unsigned long freq);
+
+#ifdef CONFIG_COMMON_CLK_S5PC100
+void s5pc100_clk_init(struct device_node *np,
+			    unsigned long xxti_f, unsigned long xusbxti_f,
+			    void __iomem *reg_base);
+#else
+static inline void s5pc100_clk_init(struct device_node *np,
+			    unsigned long xxti_f, unsigned long xusbxti_f,
+			    void __iomem *reg_base) {}
+#endif
+
 void s5pc100_init_io(struct map_desc *mach_desc, int size);
 void s5pc100_init_irq(void);
 
diff --git a/arch/arm/mach-s5pc100/mach-smdkc100.c b/arch/arm/mach-s5pc100/mach-smdkc100.c
index 7c57a22..1087dcb 100644
--- a/arch/arm/mach-s5pc100/mach-smdkc100.c
+++ b/arch/arm/mach-s5pc100/mach-smdkc100.c
@@ -221,7 +221,8 @@ static struct platform_pwm_backlight_data smdkc100_bl_data = {
 static void __init smdkc100_map_io(void)
 {
 	s5pc100_init_io(NULL, 0);
-	s3c24xx_init_clocks(12000000);
+	s5pc100_set_xxti_freq(12000000);
+	s5pc100_set_xusbxti_freq(24000000);
 	s3c24xx_init_uarts(smdkc100_uartcfgs, ARRAY_SIZE(smdkc100_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 2a98613..645f21c 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -91,7 +91,7 @@ config SAMSUNG_CLKSRC
 	  used by newer systems such as the S3C64XX.
 
 config S5P_CLOCK
-	def_bool (ARCH_S5P64X0 || ARCH_S5PC100)
+	def_bool ARCH_S5P64X0
 	help
 	  Support common clock part for ARCH_S5P and ARCH_EXYNOS SoCs
 
-- 
1.8.1.2

