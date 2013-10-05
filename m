Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3JEPnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:43:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62718 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JEPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:43:39 -0400
From: Christian Daudt <bcm@fixthebug.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Christian Daudt <bcm@fixthebug.org>
Subject: [PATCH v3] ARM: bcm: Add DEBUG_LL console support
Date: Sat,  5 Oct 2013 08:43:29 -0700
Message-Id: <1380987809-4886-1-git-send-email-bcm@fixthebug.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds low level debug uart support to Broadcom
 mobile based SOCs.

Signed-off-by: Christian Daudt <bcm@fixthebug.org>

Changes from V2:
 - Changed to follow hex ordering on entries
 - Dropped defconfig changes

Changes from V1:
 - Switched to use the common 8250 debug introduced in 3.12-rc1

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9762c84..0391691 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -94,6 +94,17 @@ choice
 		depends on ARCH_BCM2835
 		select DEBUG_UART_PL01X
 
+	config DEBUG_BCM_KONA_UART
+		bool "Kernel low-level debugging messages via BCM KONA UART"
+		depends on ARCH_BCM
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Broadcom SoC platforms.
+		  This low level debug works for Broadcom
+		  mobile SoCs in the Kona family of chips (e.g. bcm28155,
+		  bcm11351, etc...)
+
 	config DEBUG_CLPS711X_UART1
 		bool "Kernel low-level debugging messages via UART1"
 		depends on ARCH_CLPS711X
@@ -951,6 +962,7 @@ config DEBUG_UART_PHYS
 	default 0x20064000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 	default 0x20068000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
 	default 0x20201000 if DEBUG_BCM2835
+	default 0x3e000000 if DEBUG_BCM_KONA_UART
 	default 0x40090000 if ARCH_LPC32XX
 	default 0x40100000 if DEBUG_PXA_UART1
 	default 0x42000000 if ARCH_GEMINI
@@ -1010,6 +1022,7 @@ config DEBUG_UART_VIRT
 	default 0xfe018000 if DEBUG_MMP_UART3
 	default 0xfe100000 if DEBUG_IMX23_UART || DEBUG_IMX28_UART
 	default 0xfe230000 if DEBUG_PICOXCELL_UART
+	default 0xfe300000 if DEBUG_BCM_KONA_UART
 	default 0xfe800000 if ARCH_IOP32X
 	default 0xfeb00000 if DEBUG_HI3620_UART || DEBUG_HI3716_UART
 	default 0xfeb24000 if DEBUG_RK3X_UART0
@@ -1052,7 +1065,8 @@ config DEBUG_UART_8250_WORD
 	default y if DEBUG_PICOXCELL_UART || DEBUG_SOCFPGA_UART || \
 		ARCH_KEYSTONE || \
 		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
-		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1
+		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1 || \
+		DEBUG_BCM_KONA_UART
 
 config DEBUG_UART_8250_FLOW_CONTROL
 	bool "Enable flow control for 8250 UART"
-- 
1.7.10.4

