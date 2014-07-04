Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbaGDRvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:51:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14618 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541AbaGDRtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:06 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-30-53b6e90ce4a2
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 13/19] ARM: s5pv210: move debug-macro.S into the common space
Date: Fri, 04 Jul 2014 19:48:13 +0200
Message-id: <1404496099-26708-14-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xy7o8L7cFGyzaymPxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVcW63aME9
	hYpTZ66yNDAelupi5OSQEDCReL7wBiuELSZx4d56ti5GLg4hgaWMEltXPWGCcPqYJGa+usUE
	UsUmoCbxueERG4gtIqAq8bltAXsXIwcHs8BtJolWYRBTWMBX4sA0d5AKFqCKbyu7WEBsXgFn
	ic4rF5ggdslJ9G57wwxicwLFJ66DiAsJOEn8+T+fZQIj7wJGhlWMoqmlyQXFSem5hnrFibnF
	pXnpesn5uZsYIaH4ZQfj4mNWhxgFOBiVeHgbV2wIFmJNLCuuzD3EKMHBrCTC+2fVtmAh3pTE
	yqrUovz4otKc1OJDjEwcnFINjBJGN7wOL5X5/Fqfc1NlZQXLogvOPWGPbx7dnst6uot/Tnzf
	agXh3UdvKMgsPb1s1xU9rR88rBvm7ez/sfDzF+X13pJsLHu9FeYaHXgasNoiRC3N+ewrle/n
	+fwZazfdVFI6IrxQqvEe+5adfYwR4a+3v/m1Z+HycpuEKJeWopmCtj9NQnpK7iqxFGckGmox
	FxUnAgDPgvwFIwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move debug-macro.S from mach/include to include/debug where
all other common debug macros are.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/Kconfig.debug                           | 12 +++++--
 arch/arm/include/debug/s5pv210.S                 | 34 ++++++++++++++++++++
 arch/arm/mach-s5pv210/include/mach/debug-macro.S | 41 ------------------------
 3 files changed, 44 insertions(+), 43 deletions(-)
 create mode 100644 arch/arm/include/debug/s5pv210.S
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/debug-macro.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8f90595..c2bcfcf 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -617,6 +617,7 @@ choice
 		depends on PLAT_SAMSUNG
 		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
 		select DEBUG_S3C24XX_UART if ARCH_S3C24XX
+		select DEBUG_S5PV210_UART if ARCH_S5PV210
 		bool "Use S3C UART 0 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -630,6 +631,7 @@ choice
 		depends on PLAT_SAMSUNG
 		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
 		select DEBUG_S3C24XX_UART if ARCH_S3C24XX
+		select DEBUG_S5PV210_UART if ARCH_S5PV210
 		bool "Use S3C UART 1 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -643,6 +645,7 @@ choice
 		depends on PLAT_SAMSUNG
 		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
 		select DEBUG_S3C24XX_UART if ARCH_S3C24XX
+		select DEBUG_S5PV210_UART if ARCH_S5PV210
 		bool "Use S3C UART 2 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -653,8 +656,9 @@ choice
 		  by CONFIG_S3C_LOWLEVEL_UART_PORT.
 
 	config DEBUG_S3C_UART3
-		depends on PLAT_SAMSUNG && ARCH_EXYNOS
-		select DEBUG_EXYNOS_UART
+		depends on PLAT_SAMSUNG && (ARCH_EXYNOS || ARCH_S5PV210)
+		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
+		select DEBUG_S5PV210_UART if ARCH_S5PV210
 		bool "Use S3C UART 3 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -949,6 +953,9 @@ config DEBUG_S3C2410_UART
 config DEBUG_S3C24XX_UART
 	bool
 
+config DEBUG_S5PV210_UART
+	bool
+
 config DEBUG_OMAP2PLUS_UART
 	bool
 	depends on ARCH_OMAP2PLUS
@@ -1009,6 +1016,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
+	default "debug/s5pv210.S" if DEBUG_S5PV210_UART
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/sti.S" if DEBUG_STI_UART
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
diff --git a/arch/arm/include/debug/s5pv210.S b/arch/arm/include/debug/s5pv210.S
new file mode 100644
index 0000000..4f1a73e
--- /dev/null
+++ b/arch/arm/include/debug/s5pv210.S
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/* pull in the relevant register and map files. */
+
+#define S3C_ADDR_BASE   0xF6000000
+#define S3C_VA_UART	S3C_ADDR_BASE + 0x01000000
+#define S5PV210_PA_UART	0xe2900000
+
+	/* note, for the boot process to work we have to keep the UART
+	 * virtual address aligned to an 1MiB boundary for the L1
+	 * mapping the head code makes. We keep the UART virtual address
+	 * aligned and add in the offset when we load the value here.
+	 */
+
+	.macro addruart, rp, rv, tmp
+		ldr	\rp, =S5PV210_PA_UART
+		ldr	\rv, =S3C_VA_UART
+#if CONFIG_DEBUG_S3C_UART != 0
+		add	\rp, \rp, #(0x400 * CONFIG_DEBUG_S3C_UART)
+		add	\rv, \rv, #(0x400 * CONFIG_DEBUG_S3C_UART)
+#endif
+	.endm
+
+#define fifo_full fifo_full_s5pv210
+#define fifo_level fifo_level_s5pv210
+
+#include <debug/samsung.S>
diff --git a/arch/arm/mach-s5pv210/include/mach/debug-macro.S b/arch/arm/mach-s5pv210/include/mach/debug-macro.S
deleted file mode 100644
index 30b511a..0000000
-- 
1.9.3

