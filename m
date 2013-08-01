Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3HAG5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:57:23 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:44349 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751490Ab3HAG5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:57:21 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>, Bo Shen <voice.shen@atmel.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 5/8] ARM: at91/dt: use periph id macros for at91sam9g45 interrupt definitions
Date: Thu,  1 Aug 2013 08:57:03 +0200
Message-Id: <1375340223-3804-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 559290780683303020
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
dt-bindings/at91/at91sam9g45/peripherals.h to register peripheral
interrupts.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi            |   57 +++++++++++++------------
 arch/arm/mach-at91/include/mach/at91sam9g45.h |    2 +-
 2 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index c3e5148..c709780 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -14,6 +14,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/at91/at91sam9g45/peripherals.h>
 
 / {
 	model = "Atmel AT91SAM9G45 family SoC";
@@ -69,7 +70,7 @@
 				compatible = "atmel,at91rm9200-aic";
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
-				atmel,external-irqs = <31>;
+				atmel,external-irqs = <AT91SAM9G45_ID_IRQ0>;
 			};
 
 			ramc0: ramc@ffffe400 {
@@ -91,7 +92,7 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 			};
 
 
@@ -103,19 +104,19 @@
 			tcb0: timer@fff7c000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfff7c000 0x100>;
-				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9G45_ID_TCB IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			tcb1: timer@fffd4000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfffd4000 0x100>;
-				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9G45_ID_TCB IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			dma: dma-controller@ffffec00 {
 				compatible = "atmel,at91sam9g45-dma";
 				reg = <0xffffec00 0x200>;
-				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9G45_ID_DMA IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
 			};
 
@@ -428,7 +429,7 @@
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
-					interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9G45_ID_PIOA IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -438,7 +439,7 @@
 				pioB: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
-					interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9G45_ID_PIOB IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -448,7 +449,7 @@
 				pioC: gpio@fffff600 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff600 0x200>;
-					interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9G45_ID_PIOC IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -458,7 +459,7 @@
 				pioD: gpio@fffff800 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff800 0x200>;
-					interrupts = <5 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9G45_ID_PIODE IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -468,7 +469,7 @@
 				pioE: gpio@fffffa00 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffffa00 0x200>;
-					interrupts = <5 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9G45_ID_PIODE IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -479,7 +480,7 @@
 			dbgu: serial@ffffee00 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xffffee00 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				status = "disabled";
@@ -488,7 +489,7 @@
 			usart0: serial@fff8c000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff8c000 0x200>;
-				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9G45_ID_US0 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -499,7 +500,7 @@
 			usart1: serial@fff90000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff90000 0x200>;
-				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9G45_ID_US1 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -510,7 +511,7 @@
 			usart2: serial@fff94000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff94000 0x200>;
-				interrupts = <9 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9G45_ID_US2 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -521,7 +522,7 @@
 			usart3: serial@fff98000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff98000 0x200>;
-				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9G45_ID_US3 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -532,7 +533,7 @@
 			macb0: ethernet@fffbc000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xfffbc000 0x100>;
-				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9G45_ID_EMAC IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
 				status = "disabled";
@@ -541,7 +542,7 @@
 			i2c0: i2c@fff84000 {
 				compatible = "atmel,at91sam9g10-i2c";
 				reg = <0xfff84000 0x100>;
-				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <AT91SAM9G45_ID_TWI0 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -550,7 +551,7 @@
 			i2c1: i2c@fff88000 {
 				compatible = "atmel,at91sam9g10-i2c";
 				reg = <0xfff88000 0x100>;
-				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <AT91SAM9G45_ID_TWI1 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -559,7 +560,7 @@
 			ssc0: ssc@fff9c000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xfff9c000 0x4000>;
-				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9G45_ID_SSC0 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
@@ -568,7 +569,7 @@
 			ssc1: ssc@fffa0000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xfffa0000 0x4000>;
-				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9G45_ID_SSC1 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
 				status = "disabled";
@@ -577,7 +578,7 @@
 			adc0: adc@fffb0000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffb0000 0x100>;
-				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9G45_ID_TSC IRQ_TYPE_LEVEL_HIGH 0>;
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xff>;
 				atmel,adc-vref = <3300>;
@@ -617,7 +618,7 @@
 			mmc0: mmc@fff80000 {
 				compatible = "atmel,hsmci";
 				reg = <0xfff80000 0x600>;
-				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9G45_ID_MCI0 IRQ_TYPE_LEVEL_HIGH 0>;
 				dmas = <&dma 1 AT91_DMA_CFG_PER_ID(0)>;
 				dma-names = "rxtx";
 				#address-cells = <1>;
@@ -628,7 +629,7 @@
 			mmc1: mmc@fffd0000 {
 				compatible = "atmel,hsmci";
 				reg = <0xfffd0000 0x600>;
-				interrupts = <29 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9G45_ID_MCI1 IRQ_TYPE_LEVEL_HIGH 0>;
 				dmas = <&dma 1 AT91_DMA_CFG_PER_ID(13)>;
 				dma-names = "rxtx";
 				#address-cells = <1>;
@@ -647,7 +648,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa4000 0x200>;
-				interrupts = <14 4 3>;
+				interrupts = <AT91SAM9G45_ID_SPI0 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
@@ -658,7 +659,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa8000 0x200>;
-				interrupts = <15 4 3>;
+				interrupts = <AT91SAM9G45_ID_SPI1 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
@@ -670,7 +671,7 @@
 				compatible = "atmel,at91sam9rl-udc";
 				reg = <0x00600000 0x80000
 				       0xfff78000 0x400>;
-				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9G45_ID_UDPHS IRQ_TYPE_LEVEL_HIGH 0>;
 				status = "disabled";
 
 				ep0 {
@@ -748,14 +749,14 @@
 		usb0: ohci@00700000 {
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00700000 0x100000>;
-			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <AT91SAM9G45_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 
 		usb1: ehci@00800000 {
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00800000 0x100000>;
-			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <AT91SAM9G45_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 	};
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
index 3f1a509..361fbc3 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
@@ -18,7 +18,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
-#include <dt-bindings/at91/at91sam9263/peripherals.h>
+#include <dt-bindings/at91/at91sam9g45/peripherals.h>
 
 /*
  * User Peripheral physical base addresses.
-- 
1.7.9.5

