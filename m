Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3FENgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:36:37 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:44631 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab3FENgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:36:31 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: OMAP: DM81xx: multiple renames for DM81xx platform
Date: Wed,  5 Jun 2013 17:34:51 +0400
Message-Id: <1370439295-9160-2-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370439295-9160-1-git-send-email-aida.mynzhasova@skitlab.ru>
References: <1370439295-9160-1-git-send-email-aida.mynzhasova@skitlab.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames all DM81xx platform related structures, variables,
files, and functions. Previously names with "ti81" prefixes were used,
which are inconsistent, because actual name of the platform is DM81xx.
Also, for the same reason DM816x EVM was renamed from board-ti8168evm
to board-dm816x-evm.

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/Kconfig.debug                    |   12 +++---
 arch/arm/include/debug/omap2plus.S        |   20 +++++-----
 arch/arm/mach-omap2/Kconfig               |   16 ++++----
 arch/arm/mach-omap2/Makefile              |    4 +-
 arch/arm/mach-omap2/board-dm816x-evm.c    |   62 +++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-ti8168evm.c     |   62 -----------------------------
 arch/arm/mach-omap2/cclock3xxx_data.c     |    6 +--
 arch/arm/mach-omap2/clock.h               |    4 +-
 arch/arm/mach-omap2/common.h              |    8 ++--
 arch/arm/mach-omap2/control.h             |    8 ++--
 arch/arm/mach-omap2/dm81xx.h              |   36 +++++++++++++++++
 arch/arm/mach-omap2/id.c                  |   20 +++++-----
 arch/arm/mach-omap2/include/mach/serial.h |    8 ++--
 arch/arm/mach-omap2/io.c                  |   26 ++++++------
 arch/arm/mach-omap2/irq.c                 |    4 +-
 arch/arm/mach-omap2/omap_phy_internal.c   |   18 ++++-----
 arch/arm/mach-omap2/soc.h                 |   54 ++++++++++++-------------
 arch/arm/mach-omap2/ti81xx.h              |   36 -----------------
 arch/arm/mach-omap2/usb-musb.c            |    4 +-
 arch/arm/mach-omap2/usb.h                 |   12 +++---
 arch/arm/tools/mach-types                 |    4 +-
 drivers/pci/quirks.c                      |    6 +--
 drivers/usb/musb/musb_dsps.c              |   12 +++---
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c |    2 +-
 include/linux/platform_data/davinci_asp.h |    2 +-
 25 files changed, 223 insertions(+), 223 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-dm816x-evm.c
 delete mode 100644 arch/arm/mach-omap2/board-ti8168evm.c
 create mode 100644 arch/arm/mach-omap2/dm81xx.h
 delete mode 100644 arch/arm/mach-omap2/ti81xx.h

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 1d41908..55e18d6 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -571,14 +571,14 @@ choice
 	config DEBUG_OMAP4UART4
 		bool "OMAP4/5 UART4"
 
-	config DEBUG_TI81XXUART1
-		bool "TI81XX UART1 (ti8148evm)"
+	config DEBUG_DM81XXUART1
+		bool "DM81XX UART1 (DM8148evm)"
 
-	config DEBUG_TI81XXUART2
-		bool "TI81XX UART2"
+	config DEBUG_DM81XXUART2
+		bool "DM81XX UART2"
 
-	config DEBUG_TI81XXUART3
-		bool "TI81XX UART3 (ti8168evm)"
+	config DEBUG_DM81XXUART3
+		bool "DM81XX UART3 (DM8168evm)"
 
 	config DEBUG_AM33XXUART1
 		bool "AM33XX UART1"
diff --git a/arch/arm/include/debug/omap2plus.S b/arch/arm/include/debug/omap2plus.S
index 6d867ae..76d643b 100644
--- a/arch/arm/include/debug/omap2plus.S
+++ b/arch/arm/include/debug/omap2plus.S
@@ -30,10 +30,10 @@
 #define OMAP4_UART3_BASE	0x48020000
 #define OMAP4_UART4_BASE	0x4806e000
 
-/* TI81XX serial ports */
-#define TI81XX_UART1_BASE	0x48020000
-#define TI81XX_UART2_BASE	0x48022000
-#define TI81XX_UART3_BASE	0x48024000
+/* DM81XX serial ports */
+#define DM81XX_UART1_BASE	0x48020000
+#define DM81XX_UART2_BASE	0x48022000
+#define DM81XX_UART3_BASE	0x48024000
 
 /* AM3505/3517 UART4 */
 #define AM35XX_UART4_BASE	0x4809E000	/* Only on AM3505/3517 */
@@ -111,16 +111,16 @@ omap_uart_lsr:	.word	0
 		mov	\rp, #UART_OFFSET(OMAP4_UART4_BASE)
 		b	98f
 #endif
-#ifdef CONFIG_DEBUG_TI81XXUART1
-		mov	\rp, #UART_OFFSET(TI81XX_UART1_BASE)
+#ifdef CONFIG_DEBUG_DM81XXUART1
+		mov	\rp, #UART_OFFSET(DM81XX_UART1_BASE)
 		b	98f
 #endif
-#ifdef CONFIG_DEBUG_TI81XXUART2
-		mov	\rp, #UART_OFFSET(TI81XX_UART2_BASE)
+#ifdef CONFIG_DEBUG_DM81XXUART2
+		mov	\rp, #UART_OFFSET(DM81XX_UART2_BASE)
 		b	98f
 #endif
-#ifdef CONFIG_DEBUG_TI81XXUART3
-		mov	\rp, #UART_OFFSET(TI81XX_UART3_BASE)
+#ifdef CONFIG_DEBUG_DM81XXUART3
+		mov	\rp, #UART_OFFSET(DM81XX_UART3_BASE)
 		b	98f
 #endif
 #ifdef CONFIG_DEBUG_AM33XXUART1
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index f49cd51..376600b 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -135,8 +135,8 @@ config SOC_OMAP3430
 	default y
 	select SOC_HAS_OMAP2_SDRC
 
-config SOC_TI81XX
-	bool "TI81XX support"
+config SOC_DM81XX
+	bool "DM81xx support"
 	depends on ARCH_OMAP3
 	default y
 
@@ -368,14 +368,14 @@ config MACH_OMAP_3630SDP
 	default y
 	select OMAP_PACKAGE_CBP
 
-config MACH_TI8168EVM
-	bool "TI8168 Evaluation Module"
-	depends on SOC_TI81XX
+config MACH_DM816X_EVM
+	bool "DM816x Evaluation Module"
+	depends on SOC_DM81XX
 	default y
 
-config MACH_TI8148EVM
-	bool "TI8148 Evaluation Module"
-	depends on SOC_TI81XX
+config MACH_DM814X_EVM
+	bool "DM814x Evaluation Module"
+	depends on SOC_DM81XX
 	default y
 
 config MACH_OMAP_4430SDP
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 55a9d67..abbd043 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -259,8 +259,8 @@ obj-$(CONFIG_MACH_OMAP3517EVM)		+= board-am3517evm.o
 obj-$(CONFIG_MACH_CRANEBOARD)		+= board-am3517crane.o
 
 obj-$(CONFIG_MACH_SBC3530)		+= board-omap3stalker.o
-obj-$(CONFIG_MACH_TI8168EVM)		+= board-ti8168evm.o
-obj-$(CONFIG_MACH_TI8148EVM)		+= board-ti8168evm.o
+obj-$(CONFIG_MACH_DM816X_EVM)		+= board-dm816x-evm.o
+obj-$(CONFIG_MACH_DM814X_EVM)		+= board-dm816x-evm.o
 
 # Platform specific device init code
 
diff --git a/arch/arm/mach-omap2/board-dm816x-evm.c b/arch/arm/mach-omap2/board-dm816x-evm.c
new file mode 100644
index 0000000..05a958b
--- /dev/null
+++ b/arch/arm/mach-omap2/board-dm816x-evm.c
@@ -0,0 +1,62 @@
+/*
+ * Code for DM816x/DM814x EVM.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/usb/musb.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include "common.h"
+
+static struct omap_musb_board_data musb_board_data = {
+	.set_phy_power	= dm81xx_musb_phy_power,
+	.interface_type	= MUSB_INTERFACE_ULPI,
+	.mode           = MUSB_OTG,
+	.power		= 500,
+};
+
+static void __init dm81xx_evm_init(void)
+{
+	omap_serial_init();
+	omap_sdrc_init(NULL, NULL);
+	usb_musb_init(&musb_board_data);
+}
+
+MACHINE_START(DM816X_EVM, "dm816x_evm")
+	/* Maintainer: Texas Instruments */
+	.atag_offset	= 0x100,
+	.map_io		= dm81xx_map_io,
+	.init_early	= dm81xx_init_early,
+	.init_irq	= dm81xx_init_irq,
+	.init_time	= omap3_sync32k_timer_init,
+	.init_machine	= dm81xx_evm_init,
+	.init_late	= dm81xx_init_late,
+	.restart	= omap44xx_restart,
+MACHINE_END
+
+MACHINE_START(DM814X_EVM, "dm814x_evm")
+	/* Maintainer: Texas Instruments */
+	.atag_offset	= 0x100,
+	.map_io		= dm81xx_map_io,
+	.init_early	= dm81xx_init_early,
+	.init_irq	= dm81xx_init_irq,
+	.init_time	= omap3_sync32k_timer_init,
+	.init_machine	= dm81xx_evm_init,
+	.init_late	= dm81xx_init_late,
+	.restart	= omap44xx_restart,
+MACHINE_END
diff --git a/arch/arm/mach-omap2/board-ti8168evm.c b/arch/arm/mach-omap2/board-ti8168evm.c
deleted file mode 100644
index 6273c28..0000000
--- a/arch/arm/mach-omap2/board-ti8168evm.c
+++ /dev/null
@@ -1,62 +0,0 @@
-/*
- * Code for TI8168/TI8148 EVM.
- *
- * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/usb/musb.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-
-#include "common.h"
-
-static struct omap_musb_board_data musb_board_data = {
-	.set_phy_power	= ti81xx_musb_phy_power,
-	.interface_type	= MUSB_INTERFACE_ULPI,
-	.mode           = MUSB_OTG,
-	.power		= 500,
-};
-
-static void __init ti81xx_evm_init(void)
-{
-	omap_serial_init();
-	omap_sdrc_init(NULL, NULL);
-	usb_musb_init(&musb_board_data);
-}
-
-MACHINE_START(TI8168EVM, "ti8168evm")
-	/* Maintainer: Texas Instruments */
-	.atag_offset	= 0x100,
-	.map_io		= ti81xx_map_io,
-	.init_early	= ti81xx_init_early,
-	.init_irq	= ti81xx_init_irq,
-	.init_time	= omap3_sync32k_timer_init,
-	.init_machine	= ti81xx_evm_init,
-	.init_late	= ti81xx_init_late,
-	.restart	= omap44xx_restart,
-MACHINE_END
-
-MACHINE_START(TI8148EVM, "ti8148evm")
-	/* Maintainer: Texas Instruments */
-	.atag_offset	= 0x100,
-	.map_io		= ti81xx_map_io,
-	.init_early	= ti81xx_init_early,
-	.init_irq	= ti81xx_init_irq,
-	.init_time	= omap3_sync32k_timer_init,
-	.init_machine	= ti81xx_evm_init,
-	.init_late	= ti81xx_init_late,
-	.restart	= omap44xx_restart,
-MACHINE_END
diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 45cd264..8df75b3 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -3596,8 +3596,8 @@ int __init omap3xxx_clk_init(void)
 		omap_clocks_register(omap3xxx_clks, ARRAY_SIZE(omap3xxx_clks));
 	} else if (soc_is_am33xx()) {
 		cpu_mask = RATE_IN_AM33XX;
-	} else if (cpu_is_ti814x()) {
-		cpu_mask = RATE_IN_TI814X;
+	} else if (cpu_is_dm814x()) {
+		cpu_mask = RATE_IN_DM814X;
 	} else if (cpu_is_omap34xx()) {
 		if (omap_rev() == OMAP3430_REV_ES1_0) {
 			cpu_mask = RATE_IN_3430ES1;
@@ -3641,7 +3641,7 @@ int __init omap3xxx_clk_init(void)
 	 * Lock DPLL5 -- here only until other device init code can
 	 * handle this
 	 */
-	if (!cpu_is_ti81xx() && (omap_rev() >= OMAP3430_REV_ES2_0))
+	if (!cpu_is_dm81xx() && (omap_rev() >= OMAP3430_REV_ES2_0))
 		omap3_clk_lock_dpll5();
 
 	/* Avoid sleeping during omap3_core_dpll_m2_set_rate() */
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 7aa32cd..6187196 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -133,10 +133,10 @@ struct clockdomain;
 #define RATE_IN_3430ES2PLUS	(1 << 3)	/* 3430 ES >= 2 rates only */
 #define RATE_IN_36XX		(1 << 4)
 #define RATE_IN_4430		(1 << 5)
-#define RATE_IN_TI816X		(1 << 6)
+#define RATE_IN_DM816X		(1 << 6)
 #define RATE_IN_4460		(1 << 7)
 #define RATE_IN_AM33XX		(1 << 8)
-#define RATE_IN_TI814X		(1 << 9)
+#define RATE_IN_DM814X		(1 << 9)
 
 #define RATE_IN_24XX		(RATE_IN_242X | RATE_IN_243X)
 #define RATE_IN_34XX		(RATE_IN_3430ES1 | RATE_IN_3430ES2PLUS)
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index d555cf2..5cc3132 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -94,7 +94,7 @@ void omap3630_init_early(void);
 void omap3_init_early(void);	/* Do not use this one */
 void am33xx_init_early(void);
 void am35xx_init_early(void);
-void ti81xx_init_early(void);
+void dm81xx_init_early(void);
 void am33xx_init_early(void);
 void omap4430_init_early(void);
 void omap5_init_early(void);
@@ -106,7 +106,7 @@ void omap3430_init_late(void);
 void omap35xx_init_late(void);
 void omap3630_init_late(void);
 void am35xx_init_late(void);
-void ti81xx_init_late(void);
+void dm81xx_init_late(void);
 int omap2_common_pm_late_init(void);
 
 #ifdef CONFIG_SOC_BUS
@@ -158,7 +158,7 @@ void __init omap3_map_io(void);
 void __init am33xx_map_io(void);
 void __init omap4_map_io(void);
 void __init omap5_map_io(void);
-void __init ti81xx_map_io(void);
+void __init dm81xx_map_io(void);
 
 /* omap_barriers_init() is OMAP4 only */
 void omap_barriers_init(void);
@@ -190,7 +190,7 @@ extern struct device *omap4_get_dsp_device(void);
 
 void omap2_init_irq(void);
 void omap3_init_irq(void);
-void ti81xx_init_irq(void);
+void dm81xx_init_irq(void);
 extern int omap_irq_pending(void);
 void omap_intc_save_context(void);
 void omap_intc_restore_context(void);
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index e6c3281..03d4166 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -57,8 +57,8 @@
 #define OMAP343X_CONTROL_PADCONFS_WKUP	0xa00
 #define OMAP343X_CONTROL_GENERAL_WKUP	0xa60
 
-/* TI81XX spefic control submodules */
-#define TI81XX_CONTROL_DEVCONF		0x600
+/* DM81XX spefic control submodules */
+#define DM81XX_CONTROL_DEVCONF		0x600
 
 /* Control register offsets - read/write with omap_ctrl_{read,write}{bwl}() */
 
@@ -251,8 +251,8 @@
 #define OMAP3_PADCONF_SAD2D_MSTANDBY   0x250
 #define OMAP3_PADCONF_SAD2D_IDLEACK    0x254
 
-/* TI81XX CONTROL_DEVCONF register offsets */
-#define TI81XX_CONTROL_DEVICE_ID	(TI81XX_CONTROL_DEVCONF + 0x000)
+/* DM81XX CONTROL_DEVCONF register offsets */
+#define DM81XX_CONTROL_DEVICE_ID	(DM81XX_CONTROL_DEVCONF + 0x000)
 
 /* OMAP54XX CONTROL STATUS register */
 #define OMAP5XXX_CONTROL_STATUS                0x134
diff --git a/arch/arm/mach-omap2/dm81xx.h b/arch/arm/mach-omap2/dm81xx.h
new file mode 100644
index 0000000..a0b18a6
--- /dev/null
+++ b/arch/arm/mach-omap2/dm81xx.h
@@ -0,0 +1,36 @@
+/*
+ * This file contains the address data for various DM81xx modules.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ASM_ARCH_DM81XX_H
+#define __ASM_ARCH_DM81XX_H
+
+#define L4_SLOW_DM81XX_BASE	0x48000000
+
+#define DM81XX_SCM_BASE		0x48140000
+#define DM81XX_CTRL_BASE	DM81XX_SCM_BASE
+#define DM81XX_PRCM_BASE	0x48180000
+
+/*
+ * Adjust TAP register base such that omap3_check_revision accesses the correct
+ * DM81XX register for checking device ID (it adds 0x204 to tap base while
+ * DM81XX DEVICE ID register is at offset 0x600 from control base).
+ */
+#define DM81XX_TAP_BASE		(DM81XX_CTRL_BASE + \
+				 DM81XX_CONTROL_DEVICE_ID - 0x204)
+
+
+#define DM81XX_ARM_INTC_BASE	0x48200000
+
+#endif /* __ASM_ARCH_DM81XX_H */
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 1272c41..91f1f2f 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -205,12 +205,12 @@ static void __init omap3_cpuinfo(void)
 		cpu_name = "OMAP3630";
 	} else if (soc_is_am35xx()) {
 		cpu_name = (omap3_has_sgx()) ? "AM3517" : "AM3505";
-	} else if (cpu_is_ti816x()) {
-		cpu_name = "TI816X";
+	} else if (cpu_is_dm816x()) {
+		cpu_name = "DM816X";
 	} else if (soc_is_am335x()) {
 		cpu_name =  "AM335X";
-	} else if (cpu_is_ti814x()) {
-		cpu_name = "TI814X";
+	} else if (cpu_is_dm814x()) {
+		cpu_name = "DM814X";
 	} else if (omap3_has_iva() && omap3_has_sgx()) {
 		/* OMAP3430, OMAP3525, OMAP3515, OMAP3503 devices */
 		cpu_name = "OMAP3430/3530";
@@ -296,7 +296,7 @@ void __init omap4xxx_check_features(void)
 		omap_features = OMAP4_HAS_PERF_SILICON;
 }
 
-void __init ti81xx_check_features(void)
+void __init dm81xx_check_features(void)
 {
 	omap_features = OMAP3_HAS_NEON;
 	omap3_cpuinfo();
@@ -401,13 +401,13 @@ void __init omap3xxx_check_revision(void)
 	case 0xb81e:
 		switch (rev) {
 		case 0:
-			omap_revision = TI8168_REV_ES1_0;
+			omap_revision = DM8168_REV_ES1_0;
 			cpu_rev = "1.0";
 			break;
 		case 1:
 		/* FALLTHROUGH */
 		default:
-			omap_revision = TI8168_REV_ES1_1;
+			omap_revision = DM8168_REV_ES1_1;
 			cpu_rev = "1.1";
 			break;
 		}
@@ -435,17 +435,17 @@ void __init omap3xxx_check_revision(void)
 		case 0:
 		/* FALLTHROUGH */
 		case 1:
-			omap_revision = TI8148_REV_ES1_0;
+			omap_revision = DM8148_REV_ES1_0;
 			cpu_rev = "1.0";
 			break;
 		case 2:
-			omap_revision = TI8148_REV_ES2_0;
+			omap_revision = DM8148_REV_ES2_0;
 			cpu_rev = "2.0";
 			break;
 		case 3:
 		/* FALLTHROUGH */
 		default:
-			omap_revision = TI8148_REV_ES2_1;
+			omap_revision = DM8148_REV_ES2_1;
 			cpu_rev = "2.1";
 			break;
 		}
diff --git a/arch/arm/mach-omap2/include/mach/serial.h b/arch/arm/mach-omap2/include/mach/serial.h
index 7ca1fcf..c648773 100644
--- a/arch/arm/mach-omap2/include/mach/serial.h
+++ b/arch/arm/mach-omap2/include/mach/serial.h
@@ -26,10 +26,10 @@
 #define OMAP4_UART3_BASE	0x48020000
 #define OMAP4_UART4_BASE	0x4806e000
 
-/* TI81XX serial ports */
-#define TI81XX_UART1_BASE	0x48020000
-#define TI81XX_UART2_BASE	0x48022000
-#define TI81XX_UART3_BASE	0x48024000
+/* DM81XX serial ports */
+#define DM81XX_UART1_BASE	0x48020000
+#define DM81XX_UART2_BASE	0x48022000
+#define DM81XX_UART3_BASE	0x48024000
 
 /* AM3505/3517 UART4 */
 #define AM35XX_UART4_BASE	0x4809E000	/* Only on AM3505/3517 */
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 09abf99..3deba6e 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -191,8 +191,8 @@ static struct map_desc omap34xx_io_desc[] __initdata = {
 };
 #endif
 
-#ifdef CONFIG_SOC_TI81XX
-static struct map_desc omapti81xx_io_desc[] __initdata = {
+#ifdef CONFIG_SOC_DM81XX
+static struct map_desc omapdm81xx_io_desc[] __initdata = {
 	{
 		.virtual	= L4_34XX_VIRT,
 		.pfn		= __phys_to_pfn(L4_34XX_PHYS),
@@ -311,10 +311,10 @@ void __init omap3_map_io(void)
 }
 #endif
 
-#ifdef CONFIG_SOC_TI81XX
-void __init ti81xx_map_io(void)
+#ifdef CONFIG_SOC_DM81XX
+void __init dm81xx_map_io(void)
 {
-	iotable_init(omapti81xx_io_desc, ARRAY_SIZE(omapti81xx_io_desc));
+	iotable_init(omapdm81xx_io_desc, ARRAY_SIZE(omapdm81xx_io_desc));
 }
 #endif
 
@@ -505,16 +505,16 @@ void __init am35xx_init_early(void)
 	omap3_init_early();
 }
 
-void __init ti81xx_init_early(void)
+void __init dm81xx_init_early(void)
 {
 	omap2_set_globals_tap(OMAP343X_CLASS,
-			      OMAP2_L4_IO_ADDRESS(TI81XX_TAP_BASE));
-	omap2_set_globals_control(OMAP2_L4_IO_ADDRESS(TI81XX_CTRL_BASE),
+			      OMAP2_L4_IO_ADDRESS(DM81XX_TAP_BASE));
+	omap2_set_globals_control(OMAP2_L4_IO_ADDRESS(DM81XX_CTRL_BASE),
 				  NULL);
-	omap2_set_globals_prm(OMAP2_L4_IO_ADDRESS(TI81XX_PRCM_BASE));
-	omap2_set_globals_cm(OMAP2_L4_IO_ADDRESS(TI81XX_PRCM_BASE), NULL);
+	omap2_set_globals_prm(OMAP2_L4_IO_ADDRESS(DM81XX_PRCM_BASE));
+	omap2_set_globals_cm(OMAP2_L4_IO_ADDRESS(DM81XX_PRCM_BASE), NULL);
 	omap3xxx_check_revision();
-	ti81xx_check_features();
+	dm81xx_check_features();
 	omap3xxx_voltagedomains_init();
 	omap3xxx_powerdomains_init();
 	omap3xxx_clockdomains_init();
@@ -558,7 +558,7 @@ void __init am35xx_init_late(void)
 	omap2_clk_enable_autoidle_all();
 }
 
-void __init ti81xx_init_late(void)
+void __init dm81xx_init_late(void)
 {
 	omap_common_late_init();
 	omap3_pm_init();
@@ -576,7 +576,7 @@ void __init am33xx_init_early(void)
 	omap2_set_globals_prm(AM33XX_L4_WK_IO_ADDRESS(AM33XX_PRCM_BASE));
 	omap2_set_globals_cm(AM33XX_L4_WK_IO_ADDRESS(AM33XX_PRCM_BASE), NULL);
 	omap3xxx_check_revision();
-	ti81xx_check_features();
+	dm81xx_check_features();
 	am33xx_voltagedomains_init();
 	am33xx_powerdomains_init();
 	am33xx_clockdomains_init();
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 3926f37..6001cf6 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -214,7 +214,7 @@ void __init omap3_init_irq(void)
 	omap_init_irq(OMAP34XX_IC_BASE, 96, NULL);
 }
 
-void __init ti81xx_init_irq(void)
+void __init dm81xx_init_irq(void)
 {
 	omap_init_irq(OMAP34XX_IC_BASE, 128, NULL);
 }
@@ -233,7 +233,7 @@ static inline void omap_intc_handle_irq(void __iomem *base_addr, struct pt_regs
 			goto out;
 
 		irqnr = readl_relaxed(base_addr + 0xd8);
-#ifdef CONFIG_SOC_TI81XX
+#ifdef CONFIG_SOC_DM81XX
 		if (irqnr)
 			goto out;
 		irqnr = readl_relaxed(base_addr + 0xf8);
diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
index eb8a25d..400d6a0 100644
--- a/arch/arm/mach-omap2/omap_phy_internal.c
+++ b/arch/arm/mach-omap2/omap_phy_internal.c
@@ -151,12 +151,12 @@ void am35x_set_mode(u8 musb_mode)
 	omap_ctrl_writel(devconf2, AM35XX_CONTROL_DEVCONF2);
 }
 
-void ti81xx_musb_phy_power(u8 on)
+void dm81xx_musb_phy_power(u8 on)
 {
 	void __iomem *scm_base = NULL;
 	u32 usbphycfg;
 
-	scm_base = ioremap(TI81XX_SCM_BASE, SZ_2K);
+	scm_base = ioremap(DM81XX_SCM_BASE, SZ_2K);
 	if (!scm_base) {
 		pr_err("system control module ioremap failed\n");
 		return;
@@ -165,19 +165,19 @@ void ti81xx_musb_phy_power(u8 on)
 	usbphycfg = __raw_readl(scm_base + USBCTRL0);
 
 	if (on) {
-		if (cpu_is_ti816x()) {
-			usbphycfg |= TI816X_USBPHY0_NORMAL_MODE;
-			usbphycfg &= ~TI816X_USBPHY_REFCLK_OSC;
-		} else if (cpu_is_ti814x()) {
+		if (cpu_is_dm816x()) {
+			usbphycfg |= DM816X_USBPHY0_NORMAL_MODE;
+			usbphycfg &= ~DM816X_USBPHY_REFCLK_OSC;
+		} else if (cpu_is_dm814x()) {
 			usbphycfg &= ~(USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN
 				| USBPHY_DPINPUT | USBPHY_DMINPUT);
 			usbphycfg |= (USBPHY_OTGVDET_EN | USBPHY_OTGSESSEND_EN
 				| USBPHY_DPOPBUFCTL | USBPHY_DMOPBUFCTL);
 		}
 	} else {
-		if (cpu_is_ti816x())
-			usbphycfg &= ~TI816X_USBPHY0_NORMAL_MODE;
-		else if (cpu_is_ti814x())
+		if (cpu_is_dm816x())
+			usbphycfg &= ~DM816X_USBPHY0_NORMAL_MODE;
+		else if (cpu_is_dm814x())
 			usbphycfg |= USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN;
 
 	}
diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
index 197cc16..066ce57 100644
--- a/arch/arm/mach-omap2/soc.h
+++ b/arch/arm/mach-omap2/soc.h
@@ -28,7 +28,7 @@
 #include "omap24xx.h"
 #include "omap34xx.h"
 #include "omap44xx.h"
-#include "ti81xx.h"
+#include "dm81xx.h"
 #include "am33xx.h"
 #include "omap54xx.h"
 
@@ -153,12 +153,12 @@ static inline int is_am ##class (void)			\
 	return (GET_AM_CLASS == (id)) ? 1 : 0;		\
 }
 
-#define GET_TI_CLASS	((omap_rev() >> 24) & 0xff)
+#define GET_DM_CLASS	((omap_rev() >> 24) & 0xff)
 
-#define IS_TI_CLASS(class, id)			\
-static inline int is_ti ##class (void)		\
+#define IS_DM_CLASS(class, id)			\
+static inline int is_dm ##class (void)		\
 {							\
-	return (GET_TI_CLASS == (id)) ? 1 : 0;	\
+	return (GET_DM_CLASS == (id)) ? 1 : 0;	\
 }
 
 #define GET_OMAP_SUBCLASS	((omap_rev() >> 20) & 0x0fff)
@@ -169,8 +169,8 @@ static inline int is_omap ##subclass (void)		\
 	return (GET_OMAP_SUBCLASS == (id)) ? 1 : 0;	\
 }
 
-#define IS_TI_SUBCLASS(subclass, id)			\
-static inline int is_ti ##subclass (void)		\
+#define IS_DM_SUBCLASS(subclass, id)			\
+static inline int is_dm ##subclass (void)		\
 {							\
 	return (GET_OMAP_SUBCLASS == (id)) ? 1 : 0;	\
 }
@@ -188,7 +188,7 @@ IS_AM_CLASS(35xx, 0x35)
 IS_OMAP_CLASS(54xx, 0x54)
 IS_AM_CLASS(33xx, 0x33)
 
-IS_TI_CLASS(81xx, 0x81)
+IS_DM_CLASS(81xx, 0x81)
 
 IS_OMAP_SUBCLASS(242x, 0x242)
 IS_OMAP_SUBCLASS(243x, 0x243)
@@ -199,8 +199,8 @@ IS_OMAP_SUBCLASS(446x, 0x446)
 IS_OMAP_SUBCLASS(447x, 0x447)
 IS_OMAP_SUBCLASS(543x, 0x543)
 
-IS_TI_SUBCLASS(816x, 0x816)
-IS_TI_SUBCLASS(814x, 0x814)
+IS_DM_SUBCLASS(816x, 0x816)
+IS_DM_SUBCLASS(814x, 0x814)
 IS_AM_SUBCLASS(335x, 0x335)
 
 #define cpu_is_omap24xx()		0
@@ -208,9 +208,9 @@ IS_AM_SUBCLASS(335x, 0x335)
 #define cpu_is_omap243x()		0
 #define cpu_is_omap34xx()		0
 #define cpu_is_omap343x()		0
-#define cpu_is_ti81xx()			0
-#define cpu_is_ti816x()			0
-#define cpu_is_ti814x()			0
+#define cpu_is_dm81xx()			0
+#define cpu_is_dm816x()			0
+#define cpu_is_dm814x()			0
 #define soc_is_am35xx()			0
 #define soc_is_am33xx()			0
 #define soc_is_am335x()			0
@@ -321,16 +321,16 @@ IS_OMAP_TYPE(3430, 0x3430)
 
 #if defined(CONFIG_ARCH_OMAP3)
 # undef cpu_is_omap3430
-# undef cpu_is_ti81xx
-# undef cpu_is_ti816x
-# undef cpu_is_ti814x
+# undef cpu_is_dm81xx
+# undef cpu_is_dm816x
+# undef cpu_is_dm814x
 # undef soc_is_am35xx
 # define cpu_is_omap3430()		is_omap3430()
 # undef cpu_is_omap3630
 # define cpu_is_omap3630()		is_omap363x()
-# define cpu_is_ti81xx()		is_ti81xx()
-# define cpu_is_ti816x()		is_ti816x()
-# define cpu_is_ti814x()		is_ti814x()
+# define cpu_is_dm81xx()		is_dm81xx()
+# define cpu_is_dm816x()		is_dm816x()
+# define cpu_is_dm814x()		is_dm814x()
 # define soc_is_am35xx()		is_am35xx()
 #endif
 
@@ -380,14 +380,14 @@ IS_OMAP_TYPE(3430, 0x3430)
 #define OMAP3630_REV_ES1_1	(OMAP363X_CLASS | (0x1 << 8))
 #define OMAP3630_REV_ES1_2	(OMAP363X_CLASS | (0x2 << 8))
 
-#define TI816X_CLASS		0x81600034
-#define TI8168_REV_ES1_0	TI816X_CLASS
-#define TI8168_REV_ES1_1	(TI816X_CLASS | (0x1 << 8))
+#define DM816X_CLASS		0x81600034
+#define DM8168_REV_ES1_0	DM816X_CLASS
+#define DM8168_REV_ES1_1	(DM816X_CLASS | (0x1 << 8))
 
-#define TI814X_CLASS		0x81400034
-#define TI8148_REV_ES1_0	TI814X_CLASS
-#define TI8148_REV_ES2_0	(TI814X_CLASS | (0x1 << 8))
-#define TI8148_REV_ES2_1	(TI814X_CLASS | (0x2 << 8))
+#define DM814X_CLASS		0x81400034
+#define DM8148_REV_ES1_0	DM814X_CLASS
+#define DM8148_REV_ES2_0	(DM814X_CLASS | (0x1 << 8))
+#define DM8148_REV_ES2_1	(DM814X_CLASS | (0x2 << 8))
 
 #define AM35XX_CLASS		0x35170034
 #define AM35XX_REV_ES1_0	AM35XX_CLASS
@@ -423,7 +423,7 @@ void omap3xxx_check_revision(void);
 void omap4xxx_check_revision(void);
 void omap5xxx_check_revision(void);
 void omap3xxx_check_features(void);
-void ti81xx_check_features(void);
+void dm81xx_check_features(void);
 void omap4xxx_check_features(void);
 
 /*
diff --git a/arch/arm/mach-omap2/ti81xx.h b/arch/arm/mach-omap2/ti81xx.h
deleted file mode 100644
index a1e6caf..0000000
--- a/arch/arm/mach-omap2/ti81xx.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * This file contains the address data for various TI81XX modules.
- *
- * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __ASM_ARCH_TI81XX_H
-#define __ASM_ARCH_TI81XX_H
-
-#define L4_SLOW_TI81XX_BASE	0x48000000
-
-#define TI81XX_SCM_BASE		0x48140000
-#define TI81XX_CTRL_BASE	TI81XX_SCM_BASE
-#define TI81XX_PRCM_BASE	0x48180000
-
-/*
- * Adjust TAP register base such that omap3_check_revision accesses the correct
- * TI81XX register for checking device ID (it adds 0x204 to tap base while
- * TI81XX DEVICE ID register is at offset 0x600 from control base).
- */
-#define TI81XX_TAP_BASE		(TI81XX_CTRL_BASE + \
-				 TI81XX_CONTROL_DEVICE_ID - 0x204)
-
-
-#define TI81XX_ARM_INTC_BASE	0x48200000
-
-#endif /* __ASM_ARCH_TI81XX_H */
diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index 3242a55..d16ebc6 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -91,9 +91,9 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
 	if (soc_is_am35xx()) {
 		oh_name = "am35x_otg_hs";
 		name = "musb-am35x";
-	} else if (cpu_is_ti81xx()) {
+	} else if (cpu_is_dm81xx()) {
 		oh_name = "usb_otg_hs";
-		name = "musb-ti81xx";
+		name = "musb-dm81xx";
 	} else {
 		oh_name = "usb_otg_hs";
 		name = "musb-omap2430";
diff --git a/arch/arm/mach-omap2/usb.h b/arch/arm/mach-omap2/usb.h
index e7261eb..e1c0ae4 100644
--- a/arch/arm/mach-omap2/usb.h
+++ b/arch/arm/mach-omap2/usb.h
@@ -22,15 +22,15 @@
 #define CONF2_OTGPWRDN		(1 << 2)
 #define CONF2_DATPOL		(1 << 1)
 
-/* TI81XX specific definitions */
+/* DM81XX specific definitions */
 #define USBCTRL0	0x620
 #define USBSTAT0	0x624
 
-/* TI816X PHY controls bits */
-#define TI816X_USBPHY0_NORMAL_MODE	(1 << 0)
-#define TI816X_USBPHY_REFCLK_OSC	(1 << 8)
+/* DM816X PHY controls bits */
+#define DM816X_USBPHY0_NORMAL_MODE	(1 << 0)
+#define DM816X_USBPHY_REFCLK_OSC	(1 << 8)
 
-/* TI814X PHY controls bits */
+/* DM814X PHY controls bits */
 #define USBPHY_CM_PWRDN		(1 << 0)
 #define USBPHY_OTG_PWRDN	(1 << 1)
 #define USBPHY_CHGDET_DIS	(1 << 2)
@@ -69,5 +69,5 @@ extern void am35x_musb_reset(void);
 extern void am35x_musb_phy_power(u8 on);
 extern void am35x_musb_clear_irq(void);
 extern void am35x_set_mode(u8 musb_mode);
-extern void ti81xx_musb_phy_power(u8 on);
+extern void dm81xx_musb_phy_power(u8 on);
 
diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index a10297d..90619dd 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -481,7 +481,7 @@ msm8x60_sim		MACH_MSM8X60_SIM	MSM8X60_SIM		2756
 tcc8000_sdk		MACH_TCC8000_SDK	TCC8000_SDK		2758
 cns3420vb		MACH_CNS3420VB		CNS3420VB		2776
 omap4_panda		MACH_OMAP4_PANDA	OMAP4_PANDA		2791
-ti8168evm		MACH_TI8168EVM		TI8168EVM		2800
+dm816x_evm		MACH_DM816X_EVM		DM816X_EVM		2800
 teton_bga		MACH_TETON_BGA		TETON_BGA		2816
 eukrea_cpuimx25sd	MACH_EUKREA_CPUIMX25SD	EUKREA_CPUIMX25SD	2820
 eukrea_cpuimx35sd	MACH_EUKREA_CPUIMX35SD	EUKREA_CPUIMX35SD	2821
@@ -508,7 +508,7 @@ mx50_rdp		MACH_MX50_RDP		MX50_RDP		2988
 universal_c210		MACH_UNIVERSAL_C210	UNIVERSAL_C210		2989
 real6410		MACH_REAL6410		REAL6410		2990
 dockstar		MACH_DOCKSTAR		DOCKSTAR		2998
-ti8148evm		MACH_TI8148EVM		TI8148EVM		3004
+dm814x_evm		MACH_DM814X_EVM		DM814X_EVM		3004
 seaboard		MACH_SEABOARD		SEABOARD		3005
 mx53_ard		MACH_MX53_ARD		MX53_ARD		3010
 mx53_smd		MACH_MX53_SMD		MX53_SMD		3011
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7d68aee..bfaa05b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2772,14 +2772,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
 #endif
 
-static void fixup_ti816x_class(struct pci_dev *dev)
+static void fixup_dm816x_class(struct pci_dev *dev)
 {
-	/* TI 816x devices do not have class code set when in PCIe boot mode */
+	/* DM 816x devices do not have class code set when in PCIe boot mode */
 	dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
 	dev->class = PCI_CLASS_MULTIMEDIA_VIDEO;
 }
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_TI, 0xb800,
-				 PCI_CLASS_NOT_DEFINED, 0, fixup_ti816x_class);
+				 PCI_CLASS_NOT_DEFINED, 0, fixup_dm816x_class);
 
 /* Some PCIe devices do not work reliably with the claimed maximum
  * payload size supported.
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index e1b661d..e82b039 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -24,8 +24,8 @@
  * Suite 330, Boston, MA  02111-1307  USA
  *
  * musb_dsps.c will be a common file for all the TI DSPS platforms
- * such as dm64x, dm36x, dm35x, da8x, am35x and ti81x.
- * For now only ti81x is using this and in future davinci.c, am35x.c
+ * such as dm64x, dm36x, dm35x, da8x, am35x and dm81x.
+ * For now only dm81x is using this and in future davinci.c, am35x.c
  * da8xx.c would be merged to this file after testing.
  */
 
@@ -719,7 +719,7 @@ static int dsps_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(dsps_pm_ops, dsps_suspend, dsps_resume);
 
-static const struct dsps_musb_wrapper ti81xx_driver_data = {
+static const struct dsps_musb_wrapper dm81xx_driver_data = {
 	.revision		= 0x00,
 	.control		= 0x14,
 	.status			= 0x18,
@@ -752,8 +752,8 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
 
 static const struct platform_device_id musb_dsps_id_table[] = {
 	{
-		.name	= "musb-ti81xx",
-		.driver_data	= (kernel_ulong_t) &ti81xx_driver_data,
+		.name	= "musb-dm81xx",
+		.driver_data	= (kernel_ulong_t) &dm81xx_driver_data,
 	},
 	{  },	/* Terminating Entry */
 };
@@ -762,7 +762,7 @@ MODULE_DEVICE_TABLE(platform, musb_dsps_id_table);
 #ifdef CONFIG_OF
 static const struct of_device_id musb_dsps_of_match[] = {
 	{ .compatible = "ti,musb-am33xx",
-		.data = (void *) &ti81xx_driver_data, },
+		.data = (void *) &dm81xx_driver_data, },
 	{  },
 };
 MODULE_DEVICE_TABLE(of, musb_dsps_of_match);
diff --git a/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c b/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
index e18b222..a61e9d1 100644
--- a/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
+++ b/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
@@ -1,7 +1,7 @@
 /*
  * ti_hdmi_4xxx_ip.c
  *
- * HDMI TI81xx, TI38xx, TI OMAP4 etc IP driver Library
+ * HDMI DM81xx, TI38xx, TI OMAP4 etc IP driver Library
  * Copyright (C) 2010-2011 Texas Instruments Incorporated - http://www.ti.com/
  * Authors: Yong Zhi
  *	Mythri pk <mythripk@ti.com>
diff --git a/include/linux/platform_data/davinci_asp.h b/include/linux/platform_data/davinci_asp.h
index 8db5ae0..693b7d6 100644
--- a/include/linux/platform_data/davinci_asp.h
+++ b/include/linux/platform_data/davinci_asp.h
@@ -89,7 +89,7 @@ struct snd_platform_data {
 enum {
 	MCASP_VERSION_1 = 0,	/* DM646x */
 	MCASP_VERSION_2,	/* DA8xx/OMAPL1x */
-	MCASP_VERSION_3,        /* TI81xx/AM33xx */
+	MCASP_VERSION_3,        /* DM81xx/AM33xx */
 };
 
 enum mcbsp_clk_input_pin {
-- 
1.7.10.4

