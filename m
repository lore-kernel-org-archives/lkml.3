Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3LHOPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:15:23 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:60624 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759447Ab3LHOOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:14:19 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/9] ARM: add Marvell Berlin UART0 lowlevel debug
Date: Sun,  8 Dec 2013 15:14:03 +0100
Message-Id: <1386512047-874-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds UART0 as found on Marvell 88DE3xxx SoCs, e.g. Armada 1500
to the list of possible lowlevel debug options.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
Changelog:
v2->v4:
- none
v1->v2:
- replace 88DE3xxx numbering with SoC variant name
  (Requested by Jisheng Zhang)
RFCv1->RFCv2:
- have separate DEBUG option due to separate mach- directory

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig.debug | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5765abf..2571558 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -94,6 +94,14 @@ choice
 		depends on ARCH_BCM2835
 		select DEBUG_UART_PL01X
 
+	config DEBUG_BERLIN_UART
+		bool "Marvell Berlin SoC Debug UART"
+		depends on ARCH_BERLIN
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Marvell Berlin SoC based platforms.
+
 	config DEBUG_CLPS711X_UART1
 		bool "Kernel low-level debugging messages via UART1"
 		depends on ARCH_CLPS711X
@@ -1011,6 +1019,7 @@ config DEBUG_UART_PHYS
 	default 0xf1012000 if DEBUG_MVEBU_UART_ALTERNATE
 	default 0xf1012000 if ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || \
 				ARCH_ORION5X
+	default 0xf7fc9000 if DEBUG_BERLIN_UART
 	default 0xf8b00000 if DEBUG_HI3716_UART
 	default 0xfcb00000 if DEBUG_HI3620_UART
 	default 0xfe800000 if ARCH_IOP32X
@@ -1036,6 +1045,7 @@ config DEBUG_UART_VIRT
 	default 0xf2100000 if DEBUG_PXA_UART1
 	default 0xf4090000 if ARCH_LPC32XX
 	default 0xf4200000 if ARCH_GEMINI
+	default 0xf7fc9000 if DEBUG_BERLIN_UART
 	default 0xf8009000 if DEBUG_VEXPRESS_UART0_CA9
 	default 0xf8090000 if DEBUG_VEXPRESS_UART0_RS1
 	default 0xfb009000 if DEBUG_REALVIEW_STD_PORT
-- 
1.8.4.rc3

