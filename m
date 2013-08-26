Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3HZLjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:39:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26777 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3HZLje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:39:34 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-b8-521b3e748408
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, t.figa@samsung.com, tomasz.figa@gmail.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH RFC 5/5] ARM: s5pv210: Migrate clock handling to Common Clock
 Framework
Date: Mon, 26 Aug 2013 13:38:34 +0200
Message-id: <1377517114-20222-6-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoG6pnXSQwdGfHBbzj5xjtXjT28Fi
	0bvgKpvF2aY37BabHl9jtVjYtoTF4vKuOWwWM87vY7K4fZnX4uI6eYvTa04xW7zuO8xisfT6
	RSaLpxMusllMmL6WxeLwigNMFuteTgey3rSzWrw62MZisX7GaxaLee0vWS2OzVjCaLFq1x9G
	B3GPNfPWMHq0NPeweSz4fIXd4/XkCYweO2fdZfd4tXomq8eda3vYPDYvqfc4+G4Pk0ffllWM
	Ht2fbrF6fN4k57FxbmgAbxSXTUpqTmZZapG+XQJXxvKfa1kKVtpWXDh/grWB8aVxFyMnh4SA
	icSnVZdZIGwxiQv31rOB2EIC0xklWm9lQNjtTBKLVkaD2GwC5hITn20CqxcRkJRoavjD3MXI
	xcEscINFYsHRv4wgCWGBSInD/9eC2SwCqhLb565lB7F5Bfwkmg50Qy1TkPh5+QTYMk4Bf4k9
	LX3sEMv8JM4t/8YygZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg6HkmtYNxZYPF
	IUYBDkYlHt7AAqkgIdbEsuLK3EOMEhzMSiK85qLSQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	D7RaBwoJpCeWpGanphakFsFkmTg4pRoYRVkt7f69qD+7aGPbt+KYpneGNfXcU2J9Nmvv6LXK
	n2Urq5vFmJJ01nB7z62Da/5uXtfTu6jFRYXx58zDLNY5S+TDDLZ2s7A2cW2Oe9p4/YX02vWT
	W07UbVHM+vfnl6n9xd4Pdlctd7/JFT8npyb+OF3wxMOf2UddHDZ/qvx/sPL4W9fSg7PrlFiK
	MxINtZiLihMBfn06rZoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates the s5pv210 platform to use new clock driver
using Common Clock Framework.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig         |  9 +++++++++
 arch/arm/mach-s5pv210/Makefile        |  4 ++--
 arch/arm/mach-s5pv210/common.c        | 22 ++++++++++++++++++++++
 arch/arm/mach-s5pv210/common.h        | 13 +++++++++++++
 arch/arm/mach-s5pv210/mach-aquila.c   |  1 +
 arch/arm/mach-s5pv210/mach-goni.c     |  3 ++-
 arch/arm/mach-s5pv210/mach-smdkc110.c |  1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c |  1 +
 arch/arm/mach-s5pv210/mach-torbreck.c |  1 +
 arch/arm/plat-samsung/Kconfig         |  2 +-
 arch/arm/plat-samsung/init.c          |  2 --
 11 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index caaedaf..ad4546e 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -15,6 +15,7 @@ config CPU_S5PV210
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select SAMSUNG_DMADEV
+	select S5P_CLOCK if !COMMON_CLK
 	help
 	  Enable S5PV210 CPU support
 
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
index 26027a2..3c3dd05 100644
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@ -34,7 +34,13 @@
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
@@ -50,6 +56,19 @@
 
 #include "common.h"
 
+/* External clock frequency */
+static unsigned long xxti_f, xusbxti_f;
+
+void __init s5pv210_set_xxti_freq(unsigned long freq)
+{
+	xxti_f = freq;
+}
+
+void __init s5pv210_set_xusbxti_freq(unsigned long freq)
+{
+	xusbxti_f = freq;
+}
+
 static const char name_s5pv210[] = "S5PV210/S5PC110";
 
 static struct cpu_table cpu_ids[] __initdata = {
@@ -229,12 +248,14 @@ void __init s5pv210_map_io(void)
 
 void __init s5pv210_init_clocks(int xtal)
 {
+#ifdef CONFIG_S5P_CLOCK
 	printk(KERN_DEBUG "%s: initializing clocks\n", __func__);
 
 	s3c24xx_register_baseclocks(xtal);
 	s5p_register_clocks(xtal);
 	s5pv210_register_clocks();
 	s5pv210_setup_clocks();
+#endif
 }
 
 void __init s5pv210_init_irq(void)
@@ -248,6 +269,7 @@ void __init s5pv210_init_irq(void)
 	vic[3] = ~0;
 
 	s5p_init_irq(vic, ARRAY_SIZE(vic));
+	s5pv210_clk_init(NULL, xxti_f, xusbxti_f, S3C_VA_SYS);
 }
 
 struct bus_type s5pv210_subsys = {
diff --git a/arch/arm/mach-s5pv210/common.h b/arch/arm/mach-s5pv210/common.h
index fe1beb5..2db2a15 100644
--- a/arch/arm/mach-s5pv210/common.h
+++ b/arch/arm/mach-s5pv210/common.h
@@ -14,6 +14,19 @@
 
 #include <linux/reboot.h>
 
+void s5pv210_set_xxti_freq(unsigned long freq);
+void s5pv210_set_xusbxti_freq(unsigned long freq);
+
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
 
diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index ad40ab0..e37a311 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -646,6 +646,7 @@ static void __init aquila_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
 	s3c24xx_init_clocks(24000000);
+	s5pv210_set_xusbxti_freq(24000000);
 	s3c24xx_init_uarts(aquila_uartcfgs, ARRAY_SIZE(aquila_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 309b5ad..a306c3b 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -946,7 +946,8 @@ static void __init goni_sound_init(void)
 static void __init goni_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
-	s3c24xx_init_clocks(clk_xusbxti.rate);
+	s3c24xx_init_clocks(24000000);
+	s5pv210_set_xusbxti_freq(24000000);
 	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/mach-s5pv210/mach-smdkc110.c b/arch/arm/mach-s5pv210/mach-smdkc110.c
index 7c0ed07..89563ed 100644
--- a/arch/arm/mach-s5pv210/mach-smdkc110.c
+++ b/arch/arm/mach-s5pv210/mach-smdkc110.c
@@ -119,6 +119,7 @@ static void __init smdkc110_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
 	s3c24xx_init_clocks(24000000);
+	s5pv210_set_xusbxti_freq(24000000);
 	s3c24xx_init_uarts(smdkv210_uartcfgs, ARRAY_SIZE(smdkv210_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
index 6d72bb99..ff4a470 100644
--- a/arch/arm/mach-s5pv210/mach-smdkv210.c
+++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
@@ -285,6 +285,7 @@ static void __init smdkv210_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
 	s3c24xx_init_clocks(clk_xusbxti.rate);
+	s5pv210_set_xusbxti_freq(24000000);
 	s3c24xx_init_uarts(smdkv210_uartcfgs, ARRAY_SIZE(smdkv210_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM2, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/mach-s5pv210/mach-torbreck.c b/arch/arm/mach-s5pv210/mach-torbreck.c
index 579afe8..c131cd2 100644
--- a/arch/arm/mach-s5pv210/mach-torbreck.c
+++ b/arch/arm/mach-s5pv210/mach-torbreck.c
@@ -105,6 +105,7 @@ static void __init torbreck_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
 	s3c24xx_init_clocks(24000000);
+	s5pv210_set_xusbxti_freq(24000000);
 	s3c24xx_init_uarts(torbreck_uartcfgs, ARRAY_SIZE(torbreck_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
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
 
diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
index 50a3ea0..915e87f 100644
--- a/arch/arm/plat-samsung/init.c
+++ b/arch/arm/plat-samsung/init.c
@@ -63,7 +63,6 @@ void __init s3c_init_cpu(unsigned long idcode,
 	if (cpu->map_io)
 		cpu->map_io();
 }
-
 /* s3c24xx_init_clocks
  *
  * Initialise the clock subsystem and associated information from the
@@ -86,7 +85,6 @@ void __init s3c24xx_init_clocks(int xtal)
 	else
 		(cpu->init_clocks)(xtal);
 }
-
 /* uart management */
 #if IS_ENABLED(CONFIG_SAMSUNG_ATAGS)
 static int nr_uarts __initdata = 0;
-- 
1.8.1.2

