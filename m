Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3GDOpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:45:43 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53239 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab3GDOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:45:39 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org, arnd@arndb.de,
        olof@lixom.net, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v3 3/4] ARM: mach-moxart: add MOXA ART UART debug files
Date: Thu,  4 Jul 2013 16:45:31 +0200
Message-Id: <1372949131-8225-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371040448-28742-4-git-send-email-jonas.jensen@gmail.com>
References: <1371040448-28742-4-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MOXA ART kernel low-level debugging port support.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130703
    
    Changes since v2:
    
    1. use alphabetic ordering in Kconfig

 arch/arm/Kconfig.debug          |  8 ++++++++
 arch/arm/include/debug/moxart.S | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 arch/arm/include/debug/moxart.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5b7be8d..781018c 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -286,6 +286,13 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on MMP UART3.
 
+	config DEBUG_MOXART_UART0
+		bool "Kernel low-level debugging messages via MOXART UART0"
+		depends on ARCH_MOXART
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on MOXART based platforms on the UART0.
+
 	config DEBUG_MSM_UART1
 		bool "Kernel low-level debugging messages via MSM UART1"
 		depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
@@ -777,6 +784,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX6SL_UART
 	default "debug/keystone.S" if DEBUG_KEYSTONE_UART0 || \
 				      DEBUG_KEYSTONE_UART1
+	default "debug/moxart.S" if DEBUG_MOXART_UART0
 	default "debug/mvebu.S" if DEBUG_MVEBU_UART || \
 				   DEBUG_MVEBU_UART_ALTERNATE
 	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
diff --git a/arch/arm/include/debug/moxart.S b/arch/arm/include/debug/moxart.S
new file mode 100644
index 0000000..a228451
--- /dev/null
+++ b/arch/arm/include/debug/moxart.S
@@ -0,0 +1,20 @@
+/*
+ * Debugging macro include header
+ *
+ *  Copyright (C) 2013 Jonas Jensen
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define MOXART_UART_DEBUG_PHYS_BASE		0x98200000
+#define MOXART_UART_DEBUG_VIRT_BASE		0xf9820000
+
+	.macro	addruart, rp, rv, tmp
+	ldr	\rp, =MOXART_UART_DEBUG_PHYS_BASE
+	ldr	\rv, =MOXART_UART_DEBUG_VIRT_BASE
+	.endm
+
+#define UART_SHIFT	2
+#include <asm/hardware/debug-8250.S>
-- 
1.8.2.1

