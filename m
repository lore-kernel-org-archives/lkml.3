Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3IRAF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:05:26 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3332 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab3IRAFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:05:25 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Christian Daudt" <csd@broadcom.com>
To: "Russell King" <linux@arm.linux.org.uk>, "Olof Johansson" <olof@lixom.net>,
        "Stephen Warren" <swarren@nvidia.com>
cc: "Christian Daudt" <csd@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        "Chris Ball" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        bcm@fixthebug.org
Subject: [PATCH v2] ARM: bcm: Add DEBUG_LL console support
Date: Tue, 17 Sep 2013 17:05:11 -0700
Message-ID: <1379462711-6957-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E2632C70UO8289610-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds low level debug uart support to Broadcom
 mobile based SOCs.

Signed-off-by: Christian Daudt <csd@broadcom.com>

Changes from V1:
 - Switched to use the common 8250 debug introduced in 3.12-rc1

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9762c84..0523e71 100644
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
@@ -980,6 +991,7 @@ config DEBUG_UART_PHYS
 	default 0xffd82340 if ARCH_IOP13XX
 	default 0xfff36000 if DEBUG_HIGHBANK_UART
 	default 0xfffff700 if ARCH_IOP33X
+	default 0x3e000000 if DEBUG_BCM_KONA_UART
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X
 
@@ -1035,6 +1047,7 @@ config DEBUG_UART_VIRT
 	default 0xfef00003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
 	default 0xfefff700 if ARCH_IOP33X
 	default 0xff003000 if DEBUG_U300_UART
+	default 0xfe300000 if DEBUG_BCM_KONA_UART
 	default DEBUG_UART_PHYS if !MMU
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X
@@ -1052,7 +1065,8 @@ config DEBUG_UART_8250_WORD
 	default y if DEBUG_PICOXCELL_UART || DEBUG_SOCFPGA_UART || \
 		ARCH_KEYSTONE || \
 		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
-		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1
+		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1 || \
+		DEBUG_BCM_KONA_UART
 
 config DEBUG_UART_8250_FLOW_CONTROL
 	bool "Enable flow control for 8250 UART"
diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 6e49310..5c12c4c 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -30,6 +30,8 @@ CONFIG_ARCH_BCM=y
 CONFIG_ARM_THUMBEE=y
 CONFIG_ARM_ERRATA_743622=y
 CONFIG_PREEMPT=y
+CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_BCM_KONA_UART=y
 CONFIG_AEABI=y
 # CONFIG_OABI_COMPAT is not set
 # CONFIG_COMPACTION is not set
-- 
1.7.10.4


