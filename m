Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3HAGyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:54:33 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:52640 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751287Ab3HAGyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:54:32 -0400
X-Greylist: delayed 2182 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Aug 2013 02:54:31 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 3/8] ARM: at91/dt: use periph id macros for at91sam9260 interrupt definitions
Date: Thu,  1 Aug 2013 08:54:27 +0200
Message-Id: <1375340067-3724-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 514254784155514988
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
dt-bindings/at91/at91sam9260/peripherals.h to register peripheral
interrupts.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi |   57 +++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index c7ccbcb..75fd07b 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -12,6 +12,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/at91/at91sam9260/peripherals.h>
 
 / {
 	model = "Atmel AT91SAM9260 family SoC";
@@ -65,7 +66,9 @@
 				compatible = "atmel,at91rm9200-aic";
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
-				atmel,external-irqs = <29 30 31>;
+				atmel,external-irqs = <AT91SAM9260_ID_IRQ0
+						       AT91SAM9260_ID_IRQ1
+						       AT91SAM9260_ID_IRQ2>;
 			};
 
 			ramc0: ramc@ffffea00 {
@@ -91,23 +94,23 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 			};
 
 			tcb0: timer@fffa0000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfffa0000 0x100>;
-				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0
-					      18 IRQ_TYPE_LEVEL_HIGH 0
-					      19 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9260_ID_TC0 IRQ_TYPE_LEVEL_HIGH 0
+					      AT91SAM9260_ID_TC1 IRQ_TYPE_LEVEL_HIGH 0
+					      AT91SAM9260_ID_TC2 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			tcb1: timer@fffdc000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfffdc000 0x100>;
-				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0
-					      27 IRQ_TYPE_LEVEL_HIGH 0
-					      28 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9260_ID_TC3 IRQ_TYPE_LEVEL_HIGH 0
+					      AT91SAM9260_ID_TC4 IRQ_TYPE_LEVEL_HIGH 0
+					      AT91SAM9260_ID_TC5 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			pinctrl@fffff400 {
@@ -438,7 +441,7 @@
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
-					interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9260_ID_PIOA IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -448,7 +451,7 @@
 				pioB: gpio@fffff600 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff600 0x200>;
-					interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9260_ID_PIOB IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -458,7 +461,7 @@
 				pioC: gpio@fffff800 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff800 0x200>;
-					interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9260_ID_PIOC IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -469,7 +472,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				status = "disabled";
@@ -478,7 +481,7 @@
 			usart0: serial@fffb0000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffb0000 0x200>;
-				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9260_ID_US0 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -489,7 +492,7 @@
 			usart1: serial@fffb4000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffb4000 0x200>;
-				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9260_ID_US1 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -500,7 +503,7 @@
 			usart2: serial@fffb8000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffb8000 0x200>;
-				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9260_ID_US2 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -511,7 +514,7 @@
 			usart3: serial@fffd0000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffd0000 0x200>;
-				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9260_ID_US3 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -522,7 +525,7 @@
 			uart0: serial@fffd4000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffd4000 0x200>;
-				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9260_ID_US4 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -533,7 +536,7 @@
 			uart1: serial@fffd8000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffd8000 0x200>;
-				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9260_ID_US5 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -544,7 +547,7 @@
 			macb0: ethernet@fffc4000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xfffc4000 0x100>;
-				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9260_ID_EMAC IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
 				status = "disabled";
@@ -553,14 +556,14 @@
 			usb1: gadget@fffa4000 {
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfffa4000 0x4000>;
-				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
+				interrupts = <AT91SAM9260_ID_UDP IRQ_TYPE_LEVEL_HIGH 2>;
 				status = "disabled";
 			};
 
 			i2c0: i2c@fffac000 {
 				compatible = "atmel,at91sam9260-i2c";
 				reg = <0xfffac000 0x100>;
-				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <AT91SAM9260_ID_TWI IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -569,7 +572,7 @@
 			mmc0: mmc@fffa8000 {
 				compatible = "atmel,hsmci";
 				reg = <0xfffa8000 0x600>;
-				interrupts = <9 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9260_ID_MCI IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -578,7 +581,7 @@
 			ssc0: ssc@fffbc000 {
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfffbc000 0x4000>;
-				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9260_ID_SSC IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
@@ -589,7 +592,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffc8000 0x200>;
-				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9260_ID_SPI0 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
@@ -600,7 +603,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffcc000 0x200>;
-				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9260_ID_SPI1 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
@@ -609,7 +612,7 @@
 			adc0: adc@fffe0000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
-				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9260_ID_ADC IRQ_TYPE_LEVEL_HIGH 0>;
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xf>;
 				atmel,adc-vref = <3300>;
@@ -672,7 +675,7 @@
 		usb0: ohci@00500000 {
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00500000 0x100000>;
-			interrupts = <20 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <AT91SAM9260_ID_UHP IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

