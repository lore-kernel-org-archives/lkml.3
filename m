Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbaGDRvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:51:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14618 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586AbaGDRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:08 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-35-53b6e90e5606
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
Date: Fri, 04 Jul 2014 19:48:18 +0200
Message-id: <1404496099-26708-19-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xy7p8L7cFGxybK23xd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVcaD/DFvB
	251MFdMe/GVrYLzXztTFyMkhIWAicXlbDyOELSZx4d56ti5GLg4hgaWMEs1XZzBDOH1MEtO/
	TmMBqWITUJP43PCIDcQWEVCV+Ny2gL2LkYODWeA2k0SrMEhYWMBR4vyuD+wgNgtQyYNz51hB
	bF4BZ4n39z8xQyyTk+jd9gbM5gSKT1x3AewgIQEniT//57NMYORdwMiwilE0tTS5oDgpPddQ
	rzgxt7g0L10vOT93EyMkJL/sYFx8zOoQowAHoxIPb+OKDcFCrIllxZW5hxglOJiVRHj/rNoW
	LMSbklhZlVqUH19UmpNafIiRiYNTqoHRZfZ/u/MvDvOxvjrzs94zdLnSc7d9ohLvLR+eyI68
	Eac8+9+pS+dKDs8zFt9vv+DNMaW6clsnyYyK/To/Lb5u8zvJL7fJWyc78Z9dr0ZX3fqGxNbe
	oEIjwcc3lmzQbnm1TnHzkt+Mpb4zbnJWHzq6OTcjUsmeu/TjeR9G3dPLFrLFnM/z/SWrxFKc
	kWioxVxUnAgAbXxIjCcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After refactoring suspend/resume, which was last part with dependencies
on legacy code, all Kconfig symbols related to Samsung ATAGS support can
be deselected and more unused code removed. This includes most of s5p-*
code as well, as s5pv210 was their last user.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-s5pv210/include/mach/dma.h        |  26 --
 arch/arm/mach-s5pv210/include/mach/gpio.h       | 140 ----------
 arch/arm/mach-s5pv210/include/mach/hardware.h   |  18 --
 arch/arm/mach-s5pv210/include/mach/irqs.h       | 137 ----------
 arch/arm/mach-s5pv210/include/mach/map.h        | 158 ------------
 arch/arm/mach-s5pv210/include/mach/memory.h     |  27 --
 arch/arm/mach-s5pv210/include/mach/pm-core.h    |  46 ----
 arch/arm/mach-s5pv210/include/mach/regs-clock.h |   2 +-
 arch/arm/mach-s5pv210/include/mach/regs-gpio.h  |  41 ---
 arch/arm/mach-s5pv210/include/mach/regs-irq.h   |  18 --
 arch/arm/mach-s5pv210/setup-i2c0.c              |  30 ---
 arch/arm/plat-samsung/Kconfig                   | 125 +--------
 arch/arm/plat-samsung/Makefile                  |   9 -
 arch/arm/plat-samsung/cpu.c                     |   1 -
 arch/arm/plat-samsung/devs.c                    | 330 ------------------------
 arch/arm/plat-samsung/include/plat/camport.h    |  28 --
 arch/arm/plat-samsung/include/plat/cpu.h        |  12 -
 arch/arm/plat-samsung/include/plat/devs.h       |  42 ---
 arch/arm/plat-samsung/include/plat/fb-core.h    |  15 --
 arch/arm/plat-samsung/include/plat/fb.h         |  22 --
 arch/arm/plat-samsung/include/plat/fimc-core.h  |  51 ----
 arch/arm/plat-samsung/include/plat/gpio-cfg.h   |  64 -----
 arch/arm/plat-samsung/include/plat/hdmi.h       |  16 --
 arch/arm/plat-samsung/include/plat/irqs.h       |  72 ------
 arch/arm/plat-samsung/include/plat/mfc.h        |  35 ---
 arch/arm/plat-samsung/include/plat/sdhci.h      |  47 ----
 arch/arm/plat-samsung/include/plat/tv-core.h    |  44 ----
 arch/arm/plat-samsung/pm-gpio.c                 |   4 +-
 arch/arm/plat-samsung/s5p-dev-mfc.c             |  81 +-----
 arch/arm/plat-samsung/s5p-dev-uart.c            |  88 -------
 arch/arm/plat-samsung/s5p-irq-eint.c            | 221 ----------------
 arch/arm/plat-samsung/s5p-irq-gpioint.c         | 218 ----------------
 arch/arm/plat-samsung/s5p-irq-pm.c              |  92 -------
 arch/arm/plat-samsung/s5p-irq.c                 |  31 ---
 arch/arm/plat-samsung/s5p-pm.c                  |  40 ---
 arch/arm/plat-samsung/s5p-sleep.S               |  45 ----
 36 files changed, 14 insertions(+), 2362 deletions(-)
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/memory.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c0.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/camport.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/fimc-core.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/hdmi.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/irqs.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/mfc.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/tv-core.h
 delete mode 100644 arch/arm/plat-samsung/s5p-dev-uart.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-eint.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-gpioint.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-pm.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq.c
 delete mode 100644 arch/arm/plat-samsung/s5p-pm.c
 delete mode 100644 arch/arm/plat-samsung/s5p-sleep.S

diff --git a/arch/arm/mach-s5pv210/include/mach/dma.h b/arch/arm/mach-s5pv210/include/mach/dma.h
deleted file mode 100644
index 201842a..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/gpio.h b/arch/arm/mach-s5pv210/include/mach/gpio.h
deleted file mode 100644
index 6c8b903..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/hardware.h b/arch/arm/mach-s5pv210/include/mach/hardware.h
deleted file mode 100644
index fada7a3..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/irqs.h b/arch/arm/mach-s5pv210/include/mach/irqs.h
deleted file mode 100644
index 5e0de3a..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/map.h b/arch/arm/mach-s5pv210/include/mach/map.h
deleted file mode 100644
index 763929a..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/memory.h b/arch/arm/mach-s5pv210/include/mach/memory.h
deleted file mode 100644
index 2d3cfa2..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/pm-core.h b/arch/arm/mach-s5pv210/include/mach/pm-core.h
deleted file mode 100644
index eba8aea..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/regs-clock.h b/arch/arm/mach-s5pv210/include/mach/regs-clock.h
index e345584..b14ffcd 100644
--- a/arch/arm/mach-s5pv210/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv210/include/mach/regs-clock.h
@@ -13,7 +13,7 @@
 #ifndef __ASM_ARCH_REGS_CLOCK_H
 #define __ASM_ARCH_REGS_CLOCK_H __FILE__
 
-#include <mach/map.h>
+#include <plat/map-base.h>
 
 #define S5P_CLKREG(x)		(S3C_VA_SYS + (x))
 
diff --git a/arch/arm/mach-s5pv210/include/mach/regs-gpio.h b/arch/arm/mach-s5pv210/include/mach/regs-gpio.h
deleted file mode 100644
index de0c899..0000000
diff --git a/arch/arm/mach-s5pv210/include/mach/regs-irq.h b/arch/arm/mach-s5pv210/include/mach/regs-irq.h
deleted file mode 100644
index d8bc1e6..0000000
diff --git a/arch/arm/mach-s5pv210/setup-i2c0.c b/arch/arm/mach-s5pv210/setup-i2c0.c
deleted file mode 100644
index 3658416..0000000
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index f8185b5..1091b0a 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -6,29 +6,16 @@
 
 config PLAT_SAMSUNG
 	bool
-	depends on PLAT_S3C24XX || ARCH_S3C64XX || PLAT_S5P || ARCH_EXYNOS
+	depends on PLAT_S3C24XX || ARCH_S3C64XX || ARCH_EXYNOS || ARCH_S5PV210
 	default y
 	select GENERIC_IRQ_CHIP
 	select NO_IOPORT_MAP
 	help
 	  Base platform code for all Samsung SoC based systems
 
-config PLAT_S5P
-	bool
-	depends on ARCH_S5PV210
-	default y
-	select ARCH_REQUIRE_GPIOLIB
-	select ARM_VIC
-	select NO_IOPORT_MAP
-	select PLAT_SAMSUNG
-	select S3C_GPIO_TRACK
-	select S5P_GPIO_DRVSTR
-	help
-	  Base platform code for Samsung's S5P series SoC.
-
 config SAMSUNG_PM
 	bool
-	depends on PM && (PLAT_S3C24XX || ARCH_S3C64XX || S5P_PM)
+	depends on PM && (PLAT_S3C24XX || ARCH_S3C64XX)
 	default y
 	help
 	  Base platform power management code for samsung code
@@ -64,31 +51,6 @@ config SAMSUNG_ATAGS
 
 if SAMSUNG_ATAGS
 
-# options for IRQ support
-
-config S5P_IRQ
-	def_bool ARCH_S5PV210
-	help
-	  Support common interrupt part for ARCH_S5P SoCs
-
-config S5P_EXT_INT
-	bool
-	help
-	  Use the external interrupts (other than GPIO interrupts.)
-
-config S5P_GPIO_INT
-	bool
-	help
-	  Common code for the GPIO interrupts (other than external interrupts.)
-
-# options for gpio configuration support
-
-config S5P_GPIO_DRVSTR
-	bool
-	help
-	  Internal configuration to get and set correct GPIO driver strength
-	  helper
-
 config SAMSUNG_GPIO_EXTRA
 	int "Number of additional GPIO pins"
 	default 128 if SAMSUNG_GPIO_EXTRA128
@@ -120,12 +82,6 @@ config S3C_GPIO_TRACK
 	  Internal configuration option to enable the s3c specific gpio
 	  chip tracking if the platform requires it.
 
-# uart options
-
-config S5P_DEV_UART
-	def_bool y
-	depends on ARCH_S5PV210
-
 # ADC driver
 
 config S3C_ADC
@@ -283,66 +239,6 @@ config SAMSUNG_DEV_BACKLIGHT
 	help
 	  Compile in platform device definition LCD backlight with PWM Timer
 
-config S5P_DEV_CSIS0
-	bool
-	help
-	  Compile in platform device definitions for MIPI-CSIS channel 0
-
-config S5P_DEV_CSIS1
-	bool
-	help
-	  Compile in platform device definitions for MIPI-CSIS channel 1
-
-config S5P_DEV_FIMC0
-	bool
-	help
-	  Compile in platform device definitions for FIMC controller 0
-
-config S5P_DEV_FIMC1
-	bool
-	help
-	  Compile in platform device definitions for FIMC controller 1
-
-config S5P_DEV_FIMC2
-	bool
-	help
-	  Compile in platform device definitions for FIMC controller 2
-
-config S5P_DEV_FIMC3
-	bool
-	help
-	  Compile in platform device definitions for FIMC controller 3
-
-config S5P_DEV_FIMD0
-	bool
-	help
-	  Compile in platform device definitions for FIMD controller 0
-
-config S5P_DEV_G2D
-	bool
-	help
-	  Compile in platform device definitions for G2D device
-
-config S5P_DEV_I2C_HDMIPHY
-	bool
-	help
-	  Compile in platform device definitions for I2C HDMIPHY controller
-
-config S5P_DEV_JPEG
-	bool
-	help
-	  Compile in platform device definitions for JPEG codec
-
-config S5P_DEV_ONENAND
-	bool
-	help
-	  Compile in platform device definition for OneNAND controller
-
-config S5P_DEV_TV
-	bool
-	help
-	  Compile in platform device definition for TV interface
-
 config S3C24XX_PWM
 	bool "PWM device support"
 	select PWM
@@ -363,12 +259,6 @@ config S3C_DMA
 	help
 	  Internal configuration for S3C DMA core
 
-config S5P_IRQ_PM
-	bool
-	default y if S5P_PM
-	help
-	  Legacy IRQ power management for S5P platforms
-
 config SAMSUNG_PM_GPIO
 	bool
 	default y if GPIO_SAMSUNG && PM
@@ -451,17 +341,6 @@ config SAMSUNG_WDT_RESET
 	  Compile support for system restart by triggering watchdog reset.
 	  Used on SoCs that do not provide dedicated reset control.
 
-config S5P_PM
-	bool
-	help
-	  Common code for power management support on S5P and newer SoCs
-
-config S5P_SLEEP
-	bool
-	help
-	  Internal config node to apply common S5P sleep management code.
-	  Can be selected by S5P and newer SoCs with similar sleep procedure.
-
 config DEBUG_S3C_UART
 	depends on PLAT_SAMSUNG
 	int
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index 97fc15e..5fe1750 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -15,10 +15,6 @@ obj-				:=
 
 obj-y				+= init.o cpu.o
 
-obj-$(CONFIG_S5P_IRQ)		+= s5p-irq.o
-obj-$(CONFIG_S5P_EXT_INT)	+= s5p-irq-eint.o
-obj-$(CONFIG_S5P_GPIO_INT)	+= s5p-irq-gpioint.o
-
 # ADC
 
 obj-$(CONFIG_S3C_ADC)	+= adc.o
@@ -30,7 +26,6 @@ obj-$(CONFIG_SAMSUNG_ATAGS)	+= platformdata.o
 obj-$(CONFIG_SAMSUNG_ATAGS)	+= devs.o
 obj-$(CONFIG_SAMSUNG_ATAGS)	+= dev-uart.o
 obj-$(CONFIG_S5P_DEV_MFC)	+= s5p-dev-mfc.o
-obj-$(CONFIG_S5P_DEV_UART)	+= s5p-dev-uart.o
 
 obj-$(CONFIG_SAMSUNG_DEV_BACKLIGHT)	+= dev-backlight.o
 
@@ -52,7 +47,3 @@ obj-$(CONFIG_SAMSUNG_PM_DEBUG)	+= pm-debug.o
 
 obj-$(CONFIG_SAMSUNG_WAKEMASK)	+= wakeup-mask.o
 obj-$(CONFIG_SAMSUNG_WDT_RESET)	+= watchdog-reset.o
-
-obj-$(CONFIG_S5P_PM)		+= s5p-pm.o
-obj-$(CONFIG_S5P_IRQ_PM)	+= s5p-irq-pm.o
-obj-$(CONFIG_S5P_SLEEP)		+= s5p-sleep.o
diff --git a/arch/arm/plat-samsung/cpu.c b/arch/arm/plat-samsung/cpu.c
index 945fc3f..360618e 100644
--- a/arch/arm/plat-samsung/cpu.c
+++ b/arch/arm/plat-samsung/cpu.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
-
 #include <plat/map-base.h>
 #include <plat/cpu.h>
 
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index ead4f1c..83c7d15 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -53,7 +53,6 @@
 #include <linux/platform_data/ata-samsung_cf.h>
 #include <plat/fb.h>
 #include <plat/fb-s3c2410.h>
-#include <plat/hdmi.h>
 #include <linux/platform_data/hwmon-s3c.h>
 #include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/keypad.h>
@@ -145,23 +144,6 @@ struct platform_device s3c_device_camif = {
 };
 #endif /* CONFIG_CPU_S3C2440 */
 
-/* ASOC DMA */
-
-#ifdef CONFIG_PLAT_S5P 
-static struct resource samsung_asoc_idma_resource = DEFINE_RES_IRQ(IRQ_I2S0);
-
-struct platform_device samsung_asoc_idma = {
-	.name		= "samsung-idma",
-	.id		= -1,
-	.num_resources	= 1,
-	.resource	= &samsung_asoc_idma_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	}
-};
-#endif
-
 /* FB */
 
 #ifdef CONFIG_S3C_DEV_FB
@@ -190,151 +172,6 @@ void __init s3c_fb_set_platdata(struct s3c_fb_platdata *pd)
 }
 #endif /* CONFIG_S3C_DEV_FB */
 
-/* FIMC */
-
-#ifdef CONFIG_S5P_DEV_FIMC0
-static struct resource s5p_fimc0_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_FIMC0, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_FIMC0),
-};
-
-struct platform_device s5p_device_fimc0 = {
-	.name		= "s5p-fimc",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(s5p_fimc0_resource),
-	.resource	= s5p_fimc0_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
-struct platform_device s5p_device_fimc_md = {
-	.name	= "s5p-fimc-md",
-	.id	= -1,
-};
-#endif /* CONFIG_S5P_DEV_FIMC0 */
-
-#ifdef CONFIG_S5P_DEV_FIMC1
-static struct resource s5p_fimc1_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_FIMC1, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_FIMC1),
-};
-
-struct platform_device s5p_device_fimc1 = {
-	.name		= "s5p-fimc",
-	.id		= 1,
-	.num_resources	= ARRAY_SIZE(s5p_fimc1_resource),
-	.resource	= s5p_fimc1_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-#endif /* CONFIG_S5P_DEV_FIMC1 */
-
-#ifdef CONFIG_S5P_DEV_FIMC2
-static struct resource s5p_fimc2_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_FIMC2, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_FIMC2),
-};
-
-struct platform_device s5p_device_fimc2 = {
-	.name		= "s5p-fimc",
-	.id		= 2,
-	.num_resources	= ARRAY_SIZE(s5p_fimc2_resource),
-	.resource	= s5p_fimc2_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-#endif /* CONFIG_S5P_DEV_FIMC2 */
-
-#ifdef CONFIG_S5P_DEV_FIMC3
-static struct resource s5p_fimc3_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_FIMC3, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_FIMC3),
-};
-
-struct platform_device s5p_device_fimc3 = {
-	.name		= "s5p-fimc",
-	.id		= 3,
-	.num_resources	= ARRAY_SIZE(s5p_fimc3_resource),
-	.resource	= s5p_fimc3_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-#endif /* CONFIG_S5P_DEV_FIMC3 */
-
-/* G2D */
-
-#ifdef CONFIG_S5P_DEV_G2D
-static struct resource s5p_g2d_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_G2D, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_2D),
-};
-
-struct platform_device s5p_device_g2d = {
-	.name		= "s5p-g2d",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(s5p_g2d_resource),
-	.resource	= s5p_g2d_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-#endif /* CONFIG_S5P_DEV_G2D */
-
-#ifdef CONFIG_S5P_DEV_JPEG
-static struct resource s5p_jpeg_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_JPEG, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_JPEG),
-};
-
-struct platform_device s5p_device_jpeg = {
-	.name		= "s5p-jpeg",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(s5p_jpeg_resource),
-	.resource	= s5p_jpeg_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-#endif /*  CONFIG_S5P_DEV_JPEG */
-
-/* FIMD0 */
-
-#ifdef CONFIG_S5P_DEV_FIMD0
-static struct resource s5p_fimd0_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_FIMD0, SZ_32K),
-	[1] = DEFINE_RES_IRQ_NAMED(IRQ_FIMD0_VSYNC, "vsync"),
-	[2] = DEFINE_RES_IRQ_NAMED(IRQ_FIMD0_FIFO, "fifo"),
-	[3] = DEFINE_RES_IRQ_NAMED(IRQ_FIMD0_SYSTEM, "lcd_sys"),
-};
-
-struct platform_device s5p_device_fimd0 = {
-	.name		= "s5p-fb",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(s5p_fimd0_resource),
-	.resource	= s5p_fimd0_resource,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
-void __init s5p_fimd0_set_platdata(struct s3c_fb_platdata *pd)
-{
-	s3c_set_platdata(pd, sizeof(struct s3c_fb_platdata),
-			 &s5p_device_fimd0);
-}
-#endif /* CONFIG_S5P_DEV_FIMD0 */
-
 /* HWMON */
 
 #ifdef CONFIG_S3C_DEV_HWMON
@@ -722,60 +559,6 @@ void __init s3c_i2c7_set_platdata(struct s3c2410_platform_i2c *pd)
 }
 #endif /* CONFIG_S3C_DEV_I2C7 */
 
-/* I2C HDMIPHY */
-
-#ifdef CONFIG_S5P_DEV_I2C_HDMIPHY
-static struct resource s5p_i2c_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_IIC_HDMIPHY, SZ_4K),
-	[1] = DEFINE_RES_IRQ(IRQ_IIC_HDMIPHY),
-};
-
-struct platform_device s5p_device_i2c_hdmiphy = {
-	.name		= "s3c2440-hdmiphy-i2c",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_i2c_resource),
-	.resource	= s5p_i2c_resource,
-};
-
-void __init s5p_i2c_hdmiphy_set_platdata(struct s3c2410_platform_i2c *pd)
-{
-	struct s3c2410_platform_i2c *npd;
-
-	if (!pd) {
-		pd = &default_i2c_data;
-
-		if (soc_is_s5pv210())
-			pd->bus_num = 3;
-		else
-			pd->bus_num = 0;
-	}
-
-	npd = s3c_set_platdata(pd, sizeof(struct s3c2410_platform_i2c),
-			       &s5p_device_i2c_hdmiphy);
-}
-
-static struct s5p_hdmi_platform_data s5p_hdmi_def_platdata;
-
-void __init s5p_hdmi_set_platdata(struct i2c_board_info *hdmiphy_info,
-				  struct i2c_board_info *mhl_info, int mhl_bus)
-{
-	struct s5p_hdmi_platform_data *pd = &s5p_hdmi_def_platdata;
-
-	if (soc_is_s5pv210())
-		pd->hdmiphy_bus = 3;
-	else
-		pd->hdmiphy_bus = 0;
-
-	pd->hdmiphy_info = hdmiphy_info;
-	pd->mhl_info = mhl_info;
-	pd->mhl_bus = mhl_bus;
-
-	s3c_set_platdata(pd, sizeof(struct s5p_hdmi_platform_data),
-			 &s5p_device_hdmi);
-}
-
-#endif /* CONFIG_S5P_DEV_I2C_HDMIPHY */
-
 /* I2S */
 
 #ifdef CONFIG_PLAT_S3C24XX
@@ -879,36 +662,6 @@ void __init s3c24xx_fb_set_platdata(struct s3c2410fb_mach_info *pd)
 }
 #endif /* CONFIG_PLAT_S3C24XX */
 
-/* MIPI CSIS */
-
-#ifdef CONFIG_S5P_DEV_CSIS0
-static struct resource s5p_mipi_csis0_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_MIPI_CSIS0, SZ_16K),
-	[1] = DEFINE_RES_IRQ(IRQ_MIPI_CSIS0),
-};
-
-struct platform_device s5p_device_mipi_csis0 = {
-	.name		= "s5p-mipi-csis",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(s5p_mipi_csis0_resource),
-	.resource	= s5p_mipi_csis0_resource,
-};
-#endif /* CONFIG_S5P_DEV_CSIS0 */
-
-#ifdef CONFIG_S5P_DEV_CSIS1
-static struct resource s5p_mipi_csis1_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_MIPI_CSIS1, SZ_16K),
-	[1] = DEFINE_RES_IRQ(IRQ_MIPI_CSIS1),
-};
-
-struct platform_device s5p_device_mipi_csis1 = {
-	.name		= "s5p-mipi-csis",
-	.id		= 1,
-	.num_resources	= ARRAY_SIZE(s5p_mipi_csis1_resource),
-	.resource	= s5p_mipi_csis1_resource,
-};
-#endif
-
 /* NAND */
 
 #ifdef CONFIG_S3C_DEV_NAND
@@ -1052,43 +805,6 @@ void __init s3c64xx_onenand1_set_platdata(struct onenand_platform_data *pdata)
 }
 #endif /* CONFIG_S3C64XX_DEV_ONENAND1 */
 
-#ifdef CONFIG_S5P_DEV_ONENAND
-static struct resource s5p_onenand_resources[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_ONENAND, SZ_128K),
-	[1] = DEFINE_RES_MEM(S5P_PA_ONENAND_DMA, SZ_8K),
-	[2] = DEFINE_RES_IRQ(IRQ_ONENAND_AUDI),
-};
-
-struct platform_device s5p_device_onenand = {
-	.name		= "s5pc110-onenand",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_onenand_resources),
-	.resource	= s5p_onenand_resources,
-};
-#endif /* CONFIG_S5P_DEV_ONENAND */
-
-/* PMU */
-
-#if defined(CONFIG_PLAT_S5P) && !defined(CONFIG_ARCH_EXYNOS)
-static struct resource s5p_pmu_resource[] = {
-	DEFINE_RES_IRQ(IRQ_PMU)
-};
-
-static struct platform_device s5p_device_pmu = {
-	.name		= "arm-pmu",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_pmu_resource),
-	.resource	= s5p_pmu_resource,
-};
-
-static int __init s5p_pmu_init(void)
-{
-	platform_device_register(&s5p_device_pmu);
-	return 0;
-}
-arch_initcall(s5p_pmu_init);
-#endif /* CONFIG_PLAT_S5P */
-
 /* PWM Timer */
 
 #ifdef CONFIG_SAMSUNG_DEV_PWM
@@ -1251,52 +967,6 @@ void __init s3c24xx_ts_set_platdata(struct s3c2410_ts_mach_info *pd)
 }
 #endif /* CONFIG_SAMSUNG_DEV_TS */
 
-/* TV */
-
-#ifdef CONFIG_S5P_DEV_TV
-
-static struct resource s5p_hdmi_resources[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_HDMI, SZ_1M),
-	[1] = DEFINE_RES_IRQ(IRQ_HDMI),
-};
-
-struct platform_device s5p_device_hdmi = {
-	.name		= "s5p-hdmi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_hdmi_resources),
-	.resource	= s5p_hdmi_resources,
-};
-
-static struct resource s5p_sdo_resources[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_SDO, SZ_64K),
-	[1] = DEFINE_RES_IRQ(IRQ_SDO),
-};
-
-struct platform_device s5p_device_sdo = {
-	.name		= "s5p-sdo",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_sdo_resources),
-	.resource	= s5p_sdo_resources,
-};
-
-static struct resource s5p_mixer_resources[] = {
-	[0] = DEFINE_RES_MEM_NAMED(S5P_PA_MIXER, SZ_64K, "mxr"),
-	[1] = DEFINE_RES_MEM_NAMED(S5P_PA_VP, SZ_64K, "vp"),
-	[2] = DEFINE_RES_IRQ_NAMED(IRQ_MIXER, "irq"),
-};
-
-struct platform_device s5p_device_mixer = {
-	.name		= "s5p-mixer",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_mixer_resources),
-	.resource	= s5p_mixer_resources,
-	.dev		= {
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	}
-};
-#endif /* CONFIG_S5P_DEV_TV */
-
 /* USB */
 
 #ifdef CONFIG_S3C_DEV_USB_HOST
diff --git a/arch/arm/plat-samsung/include/plat/camport.h b/arch/arm/plat-samsung/include/plat/camport.h
deleted file mode 100644
index a5708bf..0000000
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 995e56e..61d14f3 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -47,7 +47,6 @@ IS_SAMSUNG_CPU(s3c24xx, S3C24XX_CPU_ID, S3C24XX_CPU_MASK)
 IS_SAMSUNG_CPU(s3c2412, S3C2412_CPU_ID, S3C2412_CPU_MASK)
 IS_SAMSUNG_CPU(s3c6400, S3C6400_CPU_ID, S3C64XX_CPU_MASK)
 IS_SAMSUNG_CPU(s3c6410, S3C6410_CPU_ID, S3C64XX_CPU_MASK)
-IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
 
 #if defined(CONFIG_CPU_S3C2410) || defined(CONFIG_CPU_S3C2412) || \
     defined(CONFIG_CPU_S3C2416) || defined(CONFIG_CPU_S3C2440) || \
@@ -76,12 +75,6 @@ IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
 # define soc_is_s3c64xx()	0
 #endif
 
-#if defined(CONFIG_CPU_S5PV210)
-# define soc_is_s5pv210()	is_samsung_s5pv210()
-#else
-# define soc_is_s5pv210()	0
-#endif
-
 #define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }
 
 #ifndef KHZ
@@ -117,12 +110,9 @@ extern void s3c_init_cpu(unsigned long idcode,
 
 /* core initialisation functions */
 
-extern void s5p_init_irq(u32 *vic, u32 num_vic);
-
 extern void s3c24xx_init_io(struct map_desc *mach_desc, int size);
 
 extern void s3c64xx_init_cpu(void);
-extern void s5p_init_cpu(void __iomem *cpuid_addr);
 
 extern unsigned int samsung_rev(void);
 
@@ -150,6 +140,4 @@ extern struct bus_type s3c2442_subsys;
 extern struct bus_type s3c2443_subsys;
 extern struct bus_type s3c6410_subsys;
 
-extern void (*s5pc1xx_idle)(void);
-
 #endif
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 5f5a28d..e23fed3 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -25,9 +25,6 @@ struct s3c24xx_uart_resources {
 
 extern struct s3c24xx_uart_resources s3c2410_uart_resources[];
 extern struct s3c24xx_uart_resources s3c64xx_uart_resources[];
-extern struct s3c24xx_uart_resources s5p_uart_resources[];
-extern struct s3c24xx_uart_resources exynos4_uart_resources[];
-extern struct s3c24xx_uart_resources exynos5_uart_resources[];
 
 extern struct platform_device *s3c24xx_uart_devs[];
 extern struct platform_device *s3c24xx_uart_src[];
@@ -75,45 +72,6 @@ extern struct platform_device s3c_device_usb_hsotg;
 extern struct platform_device s3c_device_usb_hsudc;
 extern struct platform_device s3c_device_wdt;
 
-extern struct platform_device s5p_device_fimc0;
-extern struct platform_device s5p_device_fimc1;
-extern struct platform_device s5p_device_fimc2;
-extern struct platform_device s5p_device_fimc3;
-extern struct platform_device s5p_device_fimc_md;
-extern struct platform_device s5p_device_jpeg;
-extern struct platform_device s5p_device_g2d;
-extern struct platform_device s5p_device_fimd0;
-extern struct platform_device s5p_device_hdmi;
-extern struct platform_device s5p_device_i2c_hdmiphy;
-extern struct platform_device s5p_device_mfc;
-extern struct platform_device s5p_device_mfc_l;
-extern struct platform_device s5p_device_mfc_r;
-extern struct platform_device s5p_device_mipi_csis0;
-extern struct platform_device s5p_device_mipi_csis1;
-extern struct platform_device s5p_device_mixer;
-extern struct platform_device s5p_device_onenand;
-extern struct platform_device s5p_device_sdo;
-
-extern struct platform_device s5pv210_device_ac97;
-extern struct platform_device s5pv210_device_iis0;
-extern struct platform_device s5pv210_device_iis1;
-extern struct platform_device s5pv210_device_iis2;
-extern struct platform_device s5pv210_device_pcm0;
-extern struct platform_device s5pv210_device_pcm1;
-extern struct platform_device s5pv210_device_pcm2;
-extern struct platform_device s5pv210_device_spdif;
-
-extern struct platform_device exynos4_device_ac97;
-extern struct platform_device exynos4_device_ahci;
-extern struct platform_device exynos4_device_i2s0;
-extern struct platform_device exynos4_device_i2s1;
-extern struct platform_device exynos4_device_i2s2;
-extern struct platform_device exynos4_device_ohci;
-extern struct platform_device exynos4_device_pcm0;
-extern struct platform_device exynos4_device_pcm1;
-extern struct platform_device exynos4_device_pcm2;
-extern struct platform_device exynos4_device_spdif;
-
 extern struct platform_device samsung_asoc_idma;
 extern struct platform_device samsung_device_keypad;
 extern struct platform_device samsung_device_pwm;
diff --git a/arch/arm/plat-samsung/include/plat/fb-core.h b/arch/arm/plat-samsung/include/plat/fb-core.h
index 6abcbf1..bca383e 100644
--- a/arch/arm/plat-samsung/include/plat/fb-core.h
+++ b/arch/arm/plat-samsung/include/plat/fb-core.h
@@ -26,19 +26,4 @@ static inline void s3c_fb_setname(char *name)
 #endif
 }
 
-/* Re-define device name depending on support. */
-static inline void s5p_fb_setname(int id, char *name)
-{
-	switch (id) {
-#ifdef CONFIG_S5P_DEV_FIMD0
-	case 0:
-		s5p_device_fimd0.name = name;
-	break;
-#endif
-	default:
-		printk(KERN_ERR "%s: invalid device id(%d)\n", __func__, id);
-	break;
-	}
-}
-
 #endif /* __ASM_PLAT_FB_CORE_H */
diff --git a/arch/arm/plat-samsung/include/plat/fb.h b/arch/arm/plat-samsung/include/plat/fb.h
index 5a0e26a..b89f8f2 100644
--- a/arch/arm/plat-samsung/include/plat/fb.h
+++ b/arch/arm/plat-samsung/include/plat/fb.h
@@ -26,32 +26,10 @@
 extern void s3c_fb_set_platdata(struct s3c_fb_platdata *pd);
 
 /**
- * s5p_fimd0_set_platdata() - Setup the FB device with platform data.
- * @pd: The platform data to set. The data is copied from the passed structure
- *      so the machine data can mark the data __initdata so that any unused
- *      machines will end up dumping their data at runtime.
- */
-extern void s5p_fimd0_set_platdata(struct s3c_fb_platdata *pd);
-
-/**
  * s3c64xx_fb_gpio_setup_24bpp() - S3C64XX setup function for 24bpp LCD
  *
  * Initialise the GPIO for an 24bpp LCD display on the RGB interface.
  */
 extern void s3c64xx_fb_gpio_setup_24bpp(void);
 
-/**
- * s5pv210_fb_gpio_setup_24bpp() - S5PV210/S5PC110 setup function for 24bpp LCD
- *
- * Initialise the GPIO for an 24bpp LCD display on the RGB interface.
- */
-extern void s5pv210_fb_gpio_setup_24bpp(void);
-
-/**
- * exynos4_fimd0_gpio_setup_24bpp() - Exynos4 setup function for 24bpp LCD0
- *
- * Initialise the GPIO for an 24bpp LCD display on the RGB interface 0.
- */
-extern void exynos4_fimd0_gpio_setup_24bpp(void);
-
 #endif /* __PLAT_S3C_FB_H */
diff --git a/arch/arm/plat-samsung/include/plat/fimc-core.h b/arch/arm/plat-samsung/include/plat/fimc-core.h
deleted file mode 100644
index 1d6cb2b..0000000
diff --git a/arch/arm/plat-samsung/include/plat/gpio-cfg.h b/arch/arm/plat-samsung/include/plat/gpio-cfg.h
index 08740ee..b5294ef 100644
--- a/arch/arm/plat-samsung/include/plat/gpio-cfg.h
+++ b/arch/arm/plat-samsung/include/plat/gpio-cfg.h
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 
 typedef unsigned int __bitwise__ samsung_gpio_pull_t;
-typedef unsigned int __bitwise__ s5p_gpio_drvstr_t;
 
 /* forward declaration if gpio-core.h hasn't been included */
 struct samsung_gpio_chip;
@@ -180,67 +179,4 @@ static inline int s3c_gpio_cfgrange_nopull(unsigned int pin, unsigned int size,
 	return s3c_gpio_cfgall_range(pin, size, cfg, S3C_GPIO_PULL_NONE);
 }
 
-/* Define values for the drvstr available for each gpio pin.
- *
- * These values control the value of the output signal driver strength,
- * configurable on most pins on the S5P series.
- */
-#define S5P_GPIO_DRVSTR_LV1	((__force s5p_gpio_drvstr_t)0x0)
-#define S5P_GPIO_DRVSTR_LV2	((__force s5p_gpio_drvstr_t)0x2)
-#define S5P_GPIO_DRVSTR_LV3	((__force s5p_gpio_drvstr_t)0x1)
-#define S5P_GPIO_DRVSTR_LV4	((__force s5p_gpio_drvstr_t)0x3)
-
-/**
- * s5c_gpio_get_drvstr() - get the driver streght value of a gpio pin
- * @pin: The pin number to get the settings for
- *
- * Read the driver streght value for the specified pin.
-*/
-extern s5p_gpio_drvstr_t s5p_gpio_get_drvstr(unsigned int pin);
-
-/**
- * s3c_gpio_set_drvstr() - set the driver streght value of a gpio pin
- * @pin: The pin number to configure the driver streght value
- * @drvstr: The new value of the driver strength
- *
- * This function sets the driver strength value for the specified pin.
- * It will return 0 if successful, or a negative error code if the pin
- * cannot support the requested setting.
-*/
-extern int s5p_gpio_set_drvstr(unsigned int pin, s5p_gpio_drvstr_t drvstr);
-
-/**
- * s5p_register_gpio_interrupt() - register interrupt support for a gpio group
- * @pin: The pin number from the group to be registered
- *
- * This function registers gpio interrupt support for the group that the
- * specified pin belongs to.
- *
- * The total number of gpio pins is quite large ob s5p series. Registering
- * irq support for all of them would be a resource waste. Because of that the
- * interrupt support for standard gpio pins is registered dynamically.
- *
- * It will return the irq number of the interrupt that has been registered
- * or -ENOMEM if no more gpio interrupts can be registered. It is allowed
- * to call this function more than once for the same gpio group (the group
- * will be registered only once).
- */
-extern int s5p_register_gpio_interrupt(int pin);
-
-/** s5p_register_gpioint_bank() - add gpio bank for further gpio interrupt
- * registration (see s5p_register_gpio_interrupt function)
- * @chain_irq: chained irq number for the gpio int handler for this bank
- * @start: start gpio group number of this bank
- * @nr_groups: number of gpio groups handled by this bank
- *
- * This functions registers initial information about gpio banks that
- * can be later used by the s5p_register_gpio_interrupt() function to
- * enable support for gpio interrupt for particular gpio group.
- */
-#ifdef CONFIG_S5P_GPIO_INT
-extern int s5p_register_gpioint_bank(int chain_irq, int start, int nr_groups);
-#else
-#define s5p_register_gpioint_bank(chain_irq, start, nr_groups) do { } while (0)
-#endif
-
 #endif /* __PLAT_GPIO_CFG_H */
diff --git a/arch/arm/plat-samsung/include/plat/hdmi.h b/arch/arm/plat-samsung/include/plat/hdmi.h
deleted file mode 100644
index 331d046..0000000
diff --git a/arch/arm/plat-samsung/include/plat/irqs.h b/arch/arm/plat-samsung/include/plat/irqs.h
deleted file mode 100644
index 039001c..0000000
diff --git a/arch/arm/plat-samsung/include/plat/mfc.h b/arch/arm/plat-samsung/include/plat/mfc.h
deleted file mode 100644
index 033654e..0000000
diff --git a/arch/arm/plat-samsung/include/plat/sdhci.h b/arch/arm/plat-samsung/include/plat/sdhci.h
index f84b6cb..2787553 100644
--- a/arch/arm/plat-samsung/include/plat/sdhci.h
+++ b/arch/arm/plat-samsung/include/plat/sdhci.h
@@ -57,14 +57,6 @@ extern void s3c2416_setup_sdhci1_cfg_gpio(struct platform_device *, int w);
 extern void s3c64xx_setup_sdhci0_cfg_gpio(struct platform_device *, int w);
 extern void s3c64xx_setup_sdhci1_cfg_gpio(struct platform_device *, int w);
 extern void s3c64xx_setup_sdhci2_cfg_gpio(struct platform_device *, int w);
-extern void s5pv210_setup_sdhci0_cfg_gpio(struct platform_device *, int w);
-extern void s5pv210_setup_sdhci1_cfg_gpio(struct platform_device *, int w);
-extern void s5pv210_setup_sdhci2_cfg_gpio(struct platform_device *, int w);
-extern void s5pv210_setup_sdhci3_cfg_gpio(struct platform_device *, int w);
-extern void exynos4_setup_sdhci0_cfg_gpio(struct platform_device *, int w);
-extern void exynos4_setup_sdhci1_cfg_gpio(struct platform_device *, int w);
-extern void exynos4_setup_sdhci2_cfg_gpio(struct platform_device *, int w);
-extern void exynos4_setup_sdhci3_cfg_gpio(struct platform_device *, int w);
 
 /* S3C2416 SDHCI setup */
 
@@ -144,45 +136,6 @@ static inline void s3c6400_default_sdhci2(void) { }
 
 #endif /* CONFIG_S3C64XX_SETUP_SDHCI */
 
-/* S5PV210 SDHCI setup */
-
-#ifdef CONFIG_S5PV210_SETUP_SDHCI
-static inline void s5pv210_default_sdhci0(void)
-{
-#ifdef CONFIG_S3C_DEV_HSMMC
-	s3c_hsmmc0_def_platdata.cfg_gpio = s5pv210_setup_sdhci0_cfg_gpio;
-#endif
-}
-
-static inline void s5pv210_default_sdhci1(void)
-{
-#ifdef CONFIG_S3C_DEV_HSMMC1
-	s3c_hsmmc1_def_platdata.cfg_gpio = s5pv210_setup_sdhci1_cfg_gpio;
-#endif
-}
-
-static inline void s5pv210_default_sdhci2(void)
-{
-#ifdef CONFIG_S3C_DEV_HSMMC2
-	s3c_hsmmc2_def_platdata.cfg_gpio = s5pv210_setup_sdhci2_cfg_gpio;
-#endif
-}
-
-static inline void s5pv210_default_sdhci3(void)
-{
-#ifdef CONFIG_S3C_DEV_HSMMC3
-	s3c_hsmmc3_def_platdata.cfg_gpio = s5pv210_setup_sdhci3_cfg_gpio;
-#endif
-}
-
-#else
-static inline void s5pv210_default_sdhci0(void) { }
-static inline void s5pv210_default_sdhci1(void) { }
-static inline void s5pv210_default_sdhci2(void) { }
-static inline void s5pv210_default_sdhci3(void) { }
-
-#endif /* CONFIG_S5PV210_SETUP_SDHCI */
-
 static inline void s3c_sdhci_setname(int id, char *name)
 {
 	switch (id) {
diff --git a/arch/arm/plat-samsung/include/plat/tv-core.h b/arch/arm/plat-samsung/include/plat/tv-core.h
deleted file mode 100644
index 3bc34f3..0000000
diff --git a/arch/arm/plat-samsung/pm-gpio.c b/arch/arm/plat-samsung/pm-gpio.c
index da26881..f6084f6 100644
--- a/arch/arm/plat-samsung/pm-gpio.c
+++ b/arch/arm/plat-samsung/pm-gpio.c
@@ -196,7 +196,7 @@ struct samsung_gpio_pm samsung_gpio_pm_2bit = {
 	.resume = samsung_gpio_pm_2bit_resume,
 };
 
-#if defined(CONFIG_ARCH_S3C64XX) || defined(CONFIG_PLAT_S5P)
+#if defined(CONFIG_ARCH_S3C64XX)
 static void samsung_gpio_pm_4bit_save(struct samsung_gpio_chip *chip)
 {
 	chip->pm_save[1] = __raw_readl(chip->base + OFFS_CON);
@@ -306,7 +306,7 @@ struct samsung_gpio_pm samsung_gpio_pm_4bit = {
 	.save	= samsung_gpio_pm_4bit_save,
 	.resume = samsung_gpio_pm_4bit_resume,
 };
-#endif /* CONFIG_ARCH_S3C64XX || CONFIG_PLAT_S5P */
+#endif /* CONFIG_ARCH_S3C64XX */
 
 /**
  * samsung_pm_save_gpio() - save gpio chip data for suspend
diff --git a/arch/arm/plat-samsung/s5p-dev-mfc.c b/arch/arm/plat-samsung/s5p-dev-mfc.c
index 469b862..0b04b6b 100644
--- a/arch/arm/plat-samsung/s5p-dev-mfc.c
+++ b/arch/arm/plat-samsung/s5p-dev-mfc.c
@@ -17,56 +17,16 @@
 #include <linux/of_fdt.h>
 #include <linux/of.h>
 
-#include <plat/mfc.h>
-
-#ifdef CONFIG_SAMSUNG_ATAGS
-#include <mach/map.h>
-#include <mach/irqs.h>
-#include <plat/devs.h>
-
-static struct resource s5p_mfc_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_MFC, SZ_64K),
-	[1] = DEFINE_RES_IRQ(IRQ_MFC),
-};
-
-struct platform_device s5p_device_mfc = {
-	.name		= "s5p-mfc",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_mfc_resource),
-	.resource	= s5p_mfc_resource,
-};
-
-/*
- * MFC hardware has 2 memory interfaces which are modelled as two separate
- * platform devices to let dma-mapping distinguish between them.
- *
- * MFC parent device (s5p_device_mfc) must be registered before memory
- * interface specific devices (s5p_device_mfc_l and s5p_device_mfc_r).
- */
-
-struct platform_device s5p_device_mfc_l = {
-	.name		= "s5p-mfc-l",
-	.id		= -1,
-	.dev		= {
-		.parent			= &s5p_device_mfc.dev,
-		.dma_mask		= &s5p_device_mfc_l.dev.coherent_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
-struct platform_device s5p_device_mfc_r = {
-	.name		= "s5p-mfc-r",
-	.id		= -1,
-	.dev		= {
-		.parent			= &s5p_device_mfc.dev,
-		.dma_mask		= &s5p_device_mfc_r.dev.coherent_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-#else
 static struct platform_device s5p_device_mfc_l;
 static struct platform_device s5p_device_mfc_r;
-#endif
+
+struct s5p_mfc_dt_meminfo {
+	unsigned long	loff;
+	unsigned long	lsize;
+	unsigned long	roff;
+	unsigned long	rsize;
+	char		*compatible;
+};
 
 struct s5p_mfc_reserved_mem {
 	phys_addr_t	base;
@@ -77,7 +37,7 @@ struct s5p_mfc_reserved_mem {
 static struct s5p_mfc_reserved_mem s5p_mfc_mem[2] __initdata;
 
 
-void __init s5p_mfc_reserve_mem(phys_addr_t rbase, unsigned int rsize,
+static void __init s5p_mfc_reserve_mem(phys_addr_t rbase, unsigned int rsize,
 				phys_addr_t lbase, unsigned int lsize)
 {
 	int i;
@@ -100,28 +60,6 @@ void __init s5p_mfc_reserve_mem(phys_addr_t rbase, unsigned int rsize,
 	}
 }
 
-#ifdef CONFIG_SAMSUNG_ATAGS
-static int __init s5p_mfc_memory_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s5p_mfc_mem); i++) {
-		struct s5p_mfc_reserved_mem *area = &s5p_mfc_mem[i];
-		if (!area->base)
-			continue;
-
-		if (dma_declare_coherent_memory(area->dev, area->base,
-				area->base, area->size,
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0)
-			printk(KERN_ERR "Failed to declare coherent memory for MFC device (%ld bytes at 0x%08lx)\n",
-			       area->size, (unsigned long) area->base);
-	}
-	return 0;
-}
-device_initcall(s5p_mfc_memory_init);
-#endif
-
-#ifdef CONFIG_OF
 int __init s5p_fdt_alloc_mfc_mem(unsigned long node, const char *uname,
 				int depth, void *data)
 {
@@ -154,4 +92,3 @@ int __init s5p_fdt_alloc_mfc_mem(unsigned long node, const char *uname,
 
 	return 1;
 }
-#endif
diff --git a/arch/arm/plat-samsung/s5p-dev-uart.c b/arch/arm/plat-samsung/s5p-dev-uart.c
deleted file mode 100644
index 8c4487a..0000000
diff --git a/arch/arm/plat-samsung/s5p-irq-eint.c b/arch/arm/plat-samsung/s5p-irq-eint.c
deleted file mode 100644
index ebee4dc..0000000
diff --git a/arch/arm/plat-samsung/s5p-irq-gpioint.c b/arch/arm/plat-samsung/s5p-irq-gpioint.c
deleted file mode 100644
index fafdb05..0000000
diff --git a/arch/arm/plat-samsung/s5p-irq-pm.c b/arch/arm/plat-samsung/s5p-irq-pm.c
deleted file mode 100644
index 52b1694..0000000
diff --git a/arch/arm/plat-samsung/s5p-irq.c b/arch/arm/plat-samsung/s5p-irq.c
deleted file mode 100644
index ddfaca9..0000000
diff --git a/arch/arm/plat-samsung/s5p-pm.c b/arch/arm/plat-samsung/s5p-pm.c
deleted file mode 100644
index 0747468..0000000
diff --git a/arch/arm/plat-samsung/s5p-sleep.S b/arch/arm/plat-samsung/s5p-sleep.S
deleted file mode 100644
index 25c68ceb..0000000
-- 
1.9.3

