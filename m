Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3H1NgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:36:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61311 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3H1Nf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:35:58 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e7-521dfca6fbf6
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: t.stanislaws@samsung.com, m.chehab@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v2 5/5] ARM: s5pv210: Migrate clock handling to Common Clock
 Framework
Date: Wed, 28 Aug 2013 15:34:32 +0200
Message-id: <1377696872-32069-6-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xgO7yP7JBBpNKLCatO8BkMf/IOVaL
	N70dLBa9C66yWZxtesNusenxNVaLhW1LWCwu75rDZtGzYSurxYzz+5gsbl/mtbi4Tt7i9JpT
	zBZLr19ksng64SKbxYTpa1ksDq8Amrbu5XQg6007q8Wrg20sFvPaX7JaHJuxhNFi1a4/jA7i
	HmvmrWH0aGnuYfNY8PkKu8fryRMYPf6uesHssXPWXXaPV6tnsnrcubaHzWPzknqPg+/2MHn0
	bVnF6PF5k5zHxrmhAbxRXDYpqTmZZalF+nYJXBn//95mKjhpU7HuyA2mBsZZxl2MnBwSAiYS
	BzZ0M0HYYhIX7q1n62Lk4hASWMQo0bLyLCOE084kcfVmHyNIFZuAucTEZ5tYQGwRAVmJiZO/
	MIMUMQvcZJHYcacHLCEsECFxdv1+VhCbRUBVonHPL6BmDg5eAT+JQ3+1ILYpSPy8fIINxOYU
	8JdoO/IXbL4QUMmDJa+ZJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHD3PpHcw
	rmqwOMQowMGoxMMb8Vs2SIg1say4MvcQowQHs5IIL/92oBBvSmJlVWpRfnxRaU5q8SFGaQ4W
	JXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGtEknrh/pjBfhl7vM3jw5cb46X3M6I6flrmVP
	luR2SwuUL9ufeNnV66tnV0RB5qr9DzhmvT1a55FsWzMl7j+L5mrT2IaDrFfnskQWf714zmJi
	fZ/FFe2D51Zp2R8/6j2b50lnl9b5g5djz4T8WvnhpN13pU2m6U7Ri1vaOsRf3ygI8fr/mP+6
	EktxRqKhFnNRcSIA1ie7SJoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates the s5pv210 platform to use new clock driver
using Common Clock Framework.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig         |  9 +++++++++
 arch/arm/mach-s5pv210/Makefile        |  4 ++--
 arch/arm/mach-s5pv210/common.c        | 17 +++++++++++++++++
 arch/arm/mach-s5pv210/common.h        | 13 +++++++++++++
 arch/arm/mach-s5pv210/mach-aquila.c   |  1 +
 arch/arm/mach-s5pv210/mach-goni.c     |  3 ++-
 arch/arm/mach-s5pv210/mach-smdkc110.c |  1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c |  1 +
 arch/arm/mach-s5pv210/mach-torbreck.c |  1 +
 arch/arm/plat-samsung/Kconfig         |  2 +-
 arch/arm/plat-samsung/init.c          |  2 --
 11 files changed, 48 insertions(+), 6 deletions(-)

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
index 26027a2..19165c8 100644
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
@@ -50,6 +56,14 @@
 
 #include "common.h"
 
+/* External clock frequency */
+static unsigned long xxti_f, xusbxti_f;
+
+void __init s5pv210_set_xxti_freq(unsigned long freq)
+{
+	xxti_f = freq;
+}
+
 static const char name_s5pv210[] = "S5PV210/S5PC110";
 
 static struct cpu_table cpu_ids[] __initdata = {
@@ -229,12 +243,14 @@ void __init s5pv210_map_io(void)
 
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
@@ -248,6 +264,7 @@ void __init s5pv210_init_irq(void)
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
index 282d714..a1955e9 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -966,7 +966,8 @@ static void __init goni_sound_init(void)
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
index aa9511b..f0f818e 100644
--- a/arch/arm/plat-samsung/init.c
+++ b/arch/arm/plat-samsung/init.c
@@ -69,7 +69,6 @@ void __init s3c_init_cpu(unsigned long idcode,
 	if (cpu->map_io)
 		cpu->map_io();
 }
-
 /* s3c24xx_init_clocks
  *
  * Initialise the clock subsystem and associated information from the
@@ -92,7 +91,6 @@ void __init s3c24xx_init_clocks(int xtal)
 	else
 		(cpu->init_clocks)(xtal);
 }
-
 /* uart management */
 #if IS_ENABLED(CONFIG_SAMSUNG_ATAGS)
 static int nr_uarts __initdata = 0;
-- 
1.8.1.2

