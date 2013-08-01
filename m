Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3HAHAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:00:08 -0400
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:39429 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384Ab3HAHAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:00:06 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Aug 2013 03:00:06 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Richard Genoud <richard.genoud@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 7/8] ARM: at91/dt: use periph id macros for at91sam9x5 interrupt definitions
Date: Thu,  1 Aug 2013 09:00:02 +0200
Message-Id: <1375340402-3884-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 608267424903493740
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch make use of the peripheral id macros defined in
dt-bindings/at91/at91sam9x5/peripherals.h to register peripheral
interrupts.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi |   63 +++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 57d45f5..e65c780 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -14,6 +14,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/at91/at91sam9x5/peripherals.h>
 
 / {
 	model = "Atmel AT91SAM9x5 family SoC";
@@ -67,7 +68,7 @@
 				compatible = "atmel,at91rm9200-aic";
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
-				atmel,external-irqs = <31>;
+				atmel,external-irqs = <AT91SAM9X5_ID_IRQ0>;
 			};
 
 			ramc0: ramc@ffffe800 {
@@ -93,32 +94,32 @@
 			pit: timer@fffffe30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 			};
 
 			tcb0: timer@f8008000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf8008000 0x100>;
-				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_TCB IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			tcb1: timer@f800c000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf800c000 0x100>;
-				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_TCB IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			dma0: dma-controller@ffffec00 {
 				compatible = "atmel,at91sam9g45-dma";
 				reg = <0xffffec00 0x200>;
-				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_DMA0 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
 			};
 
 			dma1: dma-controller@ffffee00 {
 				compatible = "atmel,at91sam9g45-dma";
 				reg = <0xffffee00 0x200>;
-				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_DMA1 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
 			};
 
@@ -498,7 +499,7 @@
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
-					interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9X5_ID_PIOAB IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -508,7 +509,7 @@
 				pioB: gpio@fffff600 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff600 0x200>;
-					interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9X5_ID_PIOAB IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					#gpio-lines = <19>;
@@ -519,7 +520,7 @@
 				pioC: gpio@fffff800 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff800 0x200>;
-					interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9X5_ID_PIOCD IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -529,7 +530,7 @@
 				pioD: gpio@fffffa00 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffffa00 0x200>;
-					interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9X5_ID_PIOCD IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					#gpio-lines = <22>;
@@ -541,7 +542,7 @@
 			ssc0: ssc@f0010000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xf0010000 0x4000>;
-				interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9X5_ID_SSC IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
@@ -550,7 +551,7 @@
 			mmc0: mmc@f0008000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf0008000 0x600>;
-				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_MCI0 IRQ_TYPE_LEVEL_HIGH 0>;
 				dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(0)>;
 				dma-names = "rxtx";
 				#address-cells = <1>;
@@ -561,7 +562,7 @@
 			mmc1: mmc@f000c000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf000c000 0x600>;
-				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_MCI1 IRQ_TYPE_LEVEL_HIGH 0>;
 				dmas = <&dma1 1 AT91_DMA_CFG_PER_ID(0)>;
 				dma-names = "rxtx";
 				#address-cells = <1>;
@@ -572,7 +573,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				status = "disabled";
@@ -581,7 +582,7 @@
 			usart0: serial@f801c000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf801c000 0x200>;
-				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9X5_ID_USART0 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
 				status = "disabled";
@@ -590,7 +591,7 @@
 			usart1: serial@f8020000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8020000 0x200>;
-				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9X5_ID_USART1 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
 				status = "disabled";
@@ -599,7 +600,7 @@
 			usart2: serial@f8024000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8024000 0x200>;
-				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9X5_ID_USART2 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
 				status = "disabled";
@@ -608,7 +609,7 @@
 			macb0: ethernet@f802c000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xf802c000 0x100>;
-				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9X5_ID_EMAC0 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb0_rmii>;
 				status = "disabled";
@@ -617,14 +618,14 @@
 			macb1: ethernet@f8030000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xf8030000 0x100>;
-				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9X5_ID_EMAC1 IRQ_TYPE_LEVEL_HIGH 3>;
 				status = "disabled";
 			};
 
 			i2c0: i2c@f8010000 {
 				compatible = "atmel,at91sam9x5-i2c";
 				reg = <0xf8010000 0x100>;
-				interrupts = <9 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <AT91SAM9X5_ID_TWI0 IRQ_TYPE_LEVEL_HIGH 6>;
 				dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(7)>,
 				       <&dma0 1 AT91_DMA_CFG_PER_ID(8)>;
 				dma-names = "tx", "rx";
@@ -638,7 +639,7 @@
 			i2c1: i2c@f8014000 {
 				compatible = "atmel,at91sam9x5-i2c";
 				reg = <0xf8014000 0x100>;
-				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <AT91SAM9X5_ID_TWI1 IRQ_TYPE_LEVEL_HIGH 6>;
 				dmas = <&dma1 1 AT91_DMA_CFG_PER_ID(5)>,
 				       <&dma1 1 AT91_DMA_CFG_PER_ID(6)>;
 				dma-names = "tx", "rx";
@@ -652,7 +653,7 @@
 			i2c2: i2c@f8018000 {
 				compatible = "atmel,at91sam9x5-i2c";
 				reg = <0xf8018000 0x100>;
-				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <AT91SAM9X5_ID_TWI2 IRQ_TYPE_LEVEL_HIGH 6>;
 				dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(9)>,
 				       <&dma0 1 AT91_DMA_CFG_PER_ID(10)>;
 				dma-names = "tx", "rx";
@@ -666,7 +667,7 @@
 			uart0: serial@f8040000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8040000 0x200>;
-				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9X5_ID_UART0 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart0>;
 				status = "disabled";
@@ -675,7 +676,7 @@
 			uart1: serial@f8044000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8044000 0x200>;
-				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9X5_ID_UART1 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart1>;
 				status = "disabled";
@@ -684,7 +685,7 @@
 			adc0: adc@f804c000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xf804c000 0x100>;
-				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_ADC IRQ_TYPE_LEVEL_HIGH 0>;
 				atmel,adc-use-external;
 				atmel,adc-channels-used = <0xffff>;
 				atmel,adc-vref = <3300>;
@@ -727,7 +728,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0000000 0x100>;
-				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9X5_ID_SPI0 IRQ_TYPE_LEVEL_HIGH 3>;
 				dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(1)>,
 				       <&dma0 1 AT91_DMA_CFG_PER_ID(2)>;
 				dma-names = "tx", "rx";
@@ -741,7 +742,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
-				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9X5_ID_SPI1 IRQ_TYPE_LEVEL_HIGH 3>;
 				dmas = <&dma1 1 AT91_DMA_CFG_PER_ID(1)>,
 				       <&dma1 1 AT91_DMA_CFG_PER_ID(2)>;
 				dma-names = "tx", "rx";
@@ -756,7 +757,7 @@
 				compatible = "atmel,at91sam9rl-udc";
 				reg = <0x00500000 0x80000
 				       0xf803c000 0x400>;
-				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9X5_ID_UDPHS IRQ_TYPE_LEVEL_HIGH 0>;
 				status = "disabled";
 
 				ep0 {
@@ -821,7 +822,7 @@
 			rtc@fffffeb0 {
 				compatible = "atmel,at91sam9x5-rtc";
 				reg = <0xfffffeb0 0x40>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 				status = "disabled";
 			};
 		};
@@ -850,14 +851,14 @@
 		usb0: ohci@00600000 {
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
-			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <AT91SAM9X5_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 
 		usb1: ehci@00700000 {
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00700000 0x100000>;
-			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <AT91SAM9X5_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

