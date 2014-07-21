Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaGUVJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:09:40 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50038 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaGUVJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:09:34 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Gregory Fong <gregory.0xf0@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v8 03/11] ARM: brcmstb: add debug UART for earlyprintk support
Date: Mon, 21 Jul 2014 14:07:58 -0700
Message-Id: <1405976886-27807-4-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Carino <marc.ceeeee@gmail.com>

Add the UART definitions needed to support earlyprintk on brcmstb machines.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 arch/arm/Kconfig.debug | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8f90595069a1..89c06a8e810c 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -130,6 +130,17 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Marvell Berlin SoC based platforms.
 
+	config DEBUG_BRCMSTB_UART
+		bool "Use BRCMSTB UART for low-level debug"
+		depends on ARCH_BRCMSTB
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the first serial port on these devices.
+
+		  If you have a Broadcom STB chip and would like early print
+		  messages to appear over the UART, select this option.
+
 	config DEBUG_CLPS711X_UART1
 		bool "Kernel low-level debugging messages via UART1"
 		depends on ARCH_CLPS711X
@@ -1088,6 +1099,7 @@ config DEBUG_UART_PHYS
 	default 0xd4018000 if DEBUG_MMP_UART3
 	default 0xe0000000 if ARCH_SPEAR13XX
 	default 0xf0000be0 if ARCH_EBSA110
+	default 0xf040ab00 if DEBUG_BRCMSTB_UART
 	default 0xf1012000 if DEBUG_MVEBU_UART_ALTERNATE
 	default 0xf1012000 if ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || \
 				ARCH_ORION5X
@@ -1133,6 +1145,7 @@ config DEBUG_UART_VIRT
 	default 0xfa71e000 if DEBUG_QCOM_UARTDM
 	default 0xfb009000 if DEBUG_REALVIEW_STD_PORT
 	default 0xfb10c000 if DEBUG_REALVIEW_PB1176_PORT
+	default 0xfc40ab00 if DEBUG_BRCMSTB_UART
 	default 0xfd000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
 	default 0xfd000000 if ARCH_SPEAR13XX
 	default 0xfd012000 if ARCH_MV78XX0
@@ -1186,7 +1199,8 @@ config DEBUG_UART_8250_WORD
 		ARCH_KEYSTONE || \
 		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
 		DEBUG_DAVINCI_DA8XX_UART2 || \
-		DEBUG_BCM_KONA_UART
+		DEBUG_BCM_KONA_UART || \
+		DEBUG_BRCMSTB_UART
 
 config DEBUG_UART_8250_FLOW_CONTROL
 	bool "Enable flow control for 8250 UART"
-- 
1.9.1

