Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab3BZX6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab3BZX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 103/150] ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes
Date: Tue, 26 Feb 2013 15:56:00 -0800
Message-Id: <20130226235534.803830632@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit c3f0f282d950a1e87496a2633ed9e924e275ff8c upstream.

Fix the use of USART on both at91sam9x5 and at91sam9n12. In DTS, the
atmel,use-dma-[rx|tx] property is present but a DMA channel cannot be used.
Indeed the connexion between the DMA engine and the slave is not implemented
yet in Device Tree.
Note however that this property is also used for PDC (private DMA) on older
SoCs. This is why the driver alone cannot determine the validity of this
property.

Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9n12.dtsi |    8 --------
 arch/arm/boot/dts/at91sam9x5.dtsi  |    6 ------
 2 files changed, 14 deletions(-)

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


