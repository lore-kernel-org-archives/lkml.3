Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3A3Oz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:55:59 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:25620 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3A3Oz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:55:56 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dgilbert@interlog.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes
Date: Wed, 30 Jan 2013 15:55:52 +0100
Message-ID: <1359557752-21417-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the use of USART on both at91sam9x5 and at91sam9n12. In DTS, the
atmel,use-dma-[rx|tx] property is present but a DMA channel cannot be used.
Indeed the connexion between the DMA engine and the slave is not implemented
yet in Device Tree.
Note however that this property is also used for PDC (private DMA) on older
SoCs. This is why the driver alone cannot determine the validity of this
property.

Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9n12.dtsi | 8 --------
 arch/arm/boot/dts/at91sam9x5.dtsi  | 6 ------
 2 files changed, 14 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 80e29c6..4801717 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -324,8 +324,6 @@
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf801c000 0x4000>;
 				interrupts = <5 4 5>;
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
 				status = "disabled";
@@ -335,8 +333,6 @@
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8020000 0x4000>;
 				interrupts = <6 4 5>;
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
 				status = "disabled";
@@ -346,8 +342,6 @@
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8024000 0x4000>;
 				interrupts = <7 4 5>;
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
 				status = "disabled";
@@ -357,8 +351,6 @@
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8028000 0x4000>;
 				interrupts = <8 4 5>;
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
 				status = "disabled";
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 0c60090..d112c3a 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -402,8 +402,6 @@
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf801c000 0x200>;
 				interrupts = <5 4 5>;
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
 				status = "disabled";
@@ -413,8 +411,6 @@
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8020000 0x200>;
 				interrupts = <6 4 5>;
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
 				status = "disabled";
@@ -424,8 +420,6 @@
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8024000 0x200>;
 				interrupts = <7 4 5>;
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
 				status = "disabled";
-- 
1.8.0

