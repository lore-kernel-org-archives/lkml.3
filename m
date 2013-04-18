Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3DRNBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:01:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:4420 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab3DRNBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:01:37 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <dgilbert@interlog.com>, <robertcnelson@gmail.com>,
        <tanzilli@acmesystems.it>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/5] ARM: at91/at91-ariag25.dts: UART0/1 nodes are disabled
Date: Thu, 18 Apr 2013 15:01:12 +0200
Message-ID: <280be558b85a251913a51c7c24824c2a8b3d7eba.1366289869.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1366289869.git.nicolas.ferre@atmel.com>
References: <cover.1366289869.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UART0 is moved to generic at91sam9x5.dtsi file.
Both uarts are "disabled" as the corresponding pins on
Aria documentation are shown as GPIOs.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91-ariag25.dts | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/at91-ariag25.dts b/arch/arm/boot/dts/at91-ariag25.dts
index 1de619c..5b07380 100644
--- a/arch/arm/boot/dts/at91-ariag25.dts
+++ b/arch/arm/boot/dts/at91-ariag25.dts
@@ -21,6 +21,7 @@
 		serial3 = &usart2;
 		serial4 = &usart3;
 		serial5 = &uart0;
+		serial6 = &uart1;
 	};
 
 	chosen {
@@ -112,13 +113,17 @@
 				status = "okay";
 			};
 
+			/*
+			 * UART0/1 pins are marked as GPIO on
+			 * Aria documentation.
+			 * Change to "okay" if you need additional serial ports
+			 */
 			uart0: serial@f8040000 {
-				compatible = "atmel,at91sam9260-usart";
-				reg = <0xf8040000 0x200>;
-				interrupts = <15 4 5>;
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_uart0>;
-				status = "okay";
+				status = "disabled";
+			};
+
+			uart1: serial@f8044000 {
+				status = "disabled";
 			};
 
 			adc0: adc@f804c000 {
-- 
1.8.0

