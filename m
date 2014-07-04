Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965086AbaGDRwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:52:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48632 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448AbaGDRtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:05 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-26-53b6e907e0fa
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 02/19] ARM: s5pv210: Migrate clock handling to Common Clock
 Framework
Date: Fri, 04 Jul 2014 19:48:02 +0200
Message-id: <1404496099-26708-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7rsL7cFG9zayGnxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVse7KXsaC
	1doVpxbMYGtg7FPpYuTkkBAwkdi25S07hC0mceHeerYuRi4OIYGljBL3fr1khHD6mCQ+/LnB
	BlLFJqAm8bnhEZgtIqAq8bltAVA3BwezwG0miVZhkLCwQLjElyUrmEFsFqCSI4/mM4LYvAJO
	EnfbvzFBLJOT6N32BqyGU8BZYuK6C2BxIaCaP//ns0xg5F3AyLCKUTS1NLmgOCk911CvODG3
	uDQvXS85P3cTIyQcv+xgXHzM6hCjAAejEg9v44oNwUKsiWXFlbmHGCU4mJVEeP+s2hYsxJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgXHGzhOxFleYN0w5oJB4OfRddPwSFv7uGy9y+cQ/aa6538ly
	Nu2zUuc0b9YoxVOTa5W3fAk8XLr7T7jt3Y1XGZbfedQ399Ur3WjuokV68kfm5GndmNawWPyD
	D8OxzkWTtW0kXz4tZNSIXFZ7QPN91XaxVz/z201ltylc1FDu+9xo0Rm7Z/6TkI1KLMUZiYZa
	zEXFiQCHeilIJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>

This patch migrates the s5pv210 platform to use new clock driver
using Common Clock Framework.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[t.figa: Rebased and fixed merge conflicts.]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig         |  9 +++++++++
 arch/arm/mach-s5pv210/Makefile        |  4 ++--
 arch/arm/mach-s5pv210/common.c        | 16 ++++++++++++++++
 arch/arm/mach-s5pv210/common.h        |  9 +++++++++
 arch/arm/mach-s5pv210/mach-goni.c     |  2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c |  2 +-
 arch/arm/plat-samsung/Kconfig         |  2 +-
 7 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index f60f286..60785ce 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -13,6 +13,7 @@ config CPU_S5PV210
 	bool
 	select ARM_AMBA
 	select PL330_DMA if DMADEVICES
+	select S5P_CLOCK if !COMMON_CLK
 	select S5P_EXT_INT
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
@@ -70,6 +71,14 @@ config S5PV210_SETUP_USB_PHY
 	help
 	  Common setup code for USB PHY controller
 
+config COMMON_CLK_S5PV210
+	bool "Common Clock Framework support"
+	default y
+	select COMMON_CLK_SAMSUNG
+	help
+	  Enable this option to use new clock driver
+	  based on Common Clock Framework.
+
 menu "S5PC110 Machines"
 
 config MACH_AQUILA
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 1c4e419..d1a493a 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -12,8 +12,8 @@ obj-				:=
 
 # Core
 
-obj-y				+= common.o clock.o
-
+obj-y				+= common.o
+obj-$(CONFIG_S5P_CLOCK)		+= clock.o
 obj-$(CONFIG_PM)		+= pm.o
 
 obj-y				+= dma.o
diff --git a/arch/arm/mach-s5pv210/common.c b/arch/arm/mach-s5pv210/common.c
index 7024dcd..2e2202a 100644
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@ -25,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/serial_core.h>
 #include <linux/serial_s3c.h>
+#include <linux/of.h>
 
 #include <asm/proc-fns.h>
 #include <asm/mach/arch.h>
@@ -35,7 +36,13 @@
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
@@ -229,18 +239,24 @@ void __init s5pv210_map_io(void)
 
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
 {
 	u32 vic[4];	/* S5PV210 supports 4 VIC */
 
+	s5pv210_clk_init(0, xusbxti_f, S3C_VA_SYS);
+
 	/* All the VICs are fully populated. */
 	vic[0] = ~0;
 	vic[1] = ~0;
diff --git a/arch/arm/mach-s5pv210/common.h b/arch/arm/mach-s5pv210/common.h
index fe1beb5..a2e85cb 100644
--- a/arch/arm/mach-s5pv210/common.h
+++ b/arch/arm/mach-s5pv210/common.h
@@ -14,6 +14,15 @@
 
 #include <linux/reboot.h>
 
+#ifdef CONFIG_COMMON_CLK_S5PV210
+void s5pv210_clk_init(unsigned long xxti_f, unsigned long xusbxti_f,
+		      void __iomem *reg_base);
+#else
+static inline void s5pv210_clk_init(unsigned long xxti_f,
+				    unsigned long xusbxti_f,
+				    void __iomem *reg_base) {}
+#endif
+
 void s5pv210_init_io(struct map_desc *mach_desc, int size);
 void s5pv210_init_irq(void);
 
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index c1ce921..0fc71be 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -849,7 +849,7 @@ static void __init goni_sound_init(void)
 static void __init goni_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
-	s3c24xx_init_clocks(clk_xusbxti.rate);
+	s3c24xx_init_clocks(24000000);
 	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM3, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
index 2a6655f..1bde3a3 100644
--- a/arch/arm/mach-s5pv210/mach-smdkv210.c
+++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
@@ -285,7 +285,7 @@ static struct platform_pwm_backlight_data smdkv210_bl_data = {
 static void __init smdkv210_map_io(void)
 {
 	s5pv210_init_io(NULL, 0);
-	s3c24xx_init_clocks(clk_xusbxti.rate);
+	s3c24xx_init_clocks(24000000);
 	s3c24xx_init_uarts(smdkv210_uartcfgs, ARRAY_SIZE(smdkv210_uartcfgs));
 	samsung_set_timer_source(SAMSUNG_PWM2, SAMSUNG_PWM4);
 }
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 1c629c2..42f5d5b 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -78,7 +78,7 @@ config SAMSUNG_CLKSRC
 	  used by newer systems such as the S3C64XX.
 
 config S5P_CLOCK
-	def_bool ARCH_S5PV210
+	bool
 	help
 	  Support common clock part for ARCH_S5P and ARCH_EXYNOS SoCs
 
-- 
1.9.3

