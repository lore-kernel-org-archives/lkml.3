Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab3FQLJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:09:09 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40085 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab3FQLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:08:56 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2 3/3] ARM: mach-moxart: add MOXA ART UART debug files
Date: Mon, 17 Jun 2013 13:08:03 +0200
Message-Id: <1371467283-6981-3-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371467283-6981-1-git-send-email-jonas.jensen@gmail.com>
References: <1371467283-6981-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MOXA ART kernel low-level debugging port support.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 arch/arm/Kconfig.debug          |    8 ++++++++
 arch/arm/include/debug/moxart.S |   16 ++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/debug/moxart.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index e6a6ab1..d1ed6e5 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -447,6 +447,13 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Allwinner A1X based platforms on the UART1.
 
+    config DEBUG_MOXART_UART0
+        bool "Kernel low-level debugging messages via MOXART UART0"
+        depends on ARCH_MOXART
+        help
+          Say Y here if you want kernel low-level debugging support
+          on MOXART based platforms on the UART0.
+
 	config DEBUG_TEGRA_UART
 		depends on ARCH_TEGRA
 		bool "Use Tegra UART for low-level debug"
@@ -668,6 +675,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
 	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
+	default "debug/moxart.S" if DEBUG_MOXART_UART0
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
 	default "debug/ux500.S" if DEBUG_UX500_UART
 	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \
diff --git a/arch/arm/include/debug/moxart.S b/arch/arm/include/debug/moxart.S
new file mode 100644
index 0000000..7ac7c76
--- /dev/null
+++ b/arch/arm/include/debug/moxart.S
@@ -0,0 +1,16 @@
+/* Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version. */
+
+#define MOXART_UART_DEBUG_PHYS_BASE		0x98200000
+#define MOXART_UART_DEBUG_VIRT_BASE		0xf9820000
+
+.macro	addruart, rp, rv, tmp
+	ldr	\rp, =MOXART_UART_DEBUG_PHYS_BASE
+	ldr \rv, =MOXART_UART_DEBUG_VIRT_BASE
+.endm
+
+#define UART_SHIFT	2
+#include <asm/hardware/debug-8250.S>
-- 
1.7.2.5

