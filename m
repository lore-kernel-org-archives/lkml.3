Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbbAZMtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:49:06 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42057 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAZMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:49:05 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <pebolle@tiscali.nl>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2] ARM: at91: fix Kconfig.debug by adding DEBUG_AT91_UART option
Date: Mon, 26 Jan 2015 13:49:12 +0100
Message-ID: <1422276552-24456-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DEBUG_AT91_UART Kconfig option was forgotten when moving the
AT91 debug-macro.S file. Add it and use it for the at91.S compilation.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Olof,

This is the second revision of my patch and it must implement your advices
described in your previous email. I'm building a pull-request with it as well
so if you agree, you can take it easily.

Thanks for your help, bye.

 arch/arm/Kconfig.debug | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index e34d24949c6a..3092052bb285 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -117,16 +117,19 @@ choice
 	config AT91_DEBUG_LL_DBGU0
 		bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10, 9rl, 9x5, 9n12"
 		select DEBUG_AT91_UART
+		depends on ARCH_AT91
 		depends on HAVE_AT91_DBGU0
 
 	config AT91_DEBUG_LL_DBGU1
 		bool "Kernel low-level debugging on 9263, 9g45 and sama5d3"
 		select DEBUG_AT91_UART
+		depends on ARCH_AT91
 		depends on HAVE_AT91_DBGU1
 
 	config AT91_DEBUG_LL_DBGU2
 		bool "Kernel low-level debugging on sama5d4"
 		select DEBUG_AT91_UART
+		depends on ARCH_AT91
 		depends on HAVE_AT91_DBGU2
 
 	config DEBUG_BCM2835
@@ -1112,6 +1115,10 @@ choice
 
 endchoice
 
+config DEBUG_AT91_UART
+	bool
+	depends on ARCH_AT91
+
 config DEBUG_EXYNOS_UART
 	bool
 
@@ -1168,8 +1175,7 @@ config DEBUG_LL_INCLUDE
 	string
 	default "debug/sa1100.S" if DEBUG_SA1100
 	default "debug/8250.S" if DEBUG_LL_UART_8250 || DEBUG_UART_8250
-	default "debug/at91.S" if AT91_DEBUG_LL_DBGU0 || AT91_DEBUG_LL_DBGU1 || \
-				AT91_DEBUG_LL_DBGU2
+	default "debug/at91.S" if DEBUG_AT91_UART
 	default "debug/asm9260.S" if DEBUG_ASM9260_UART
 	default "debug/clps711x.S" if DEBUG_CLPS711X_UART1 || DEBUG_CLPS711X_UART2
 	default "debug/meson.S" if DEBUG_MESON_UARTAO
-- 
2.1.3

