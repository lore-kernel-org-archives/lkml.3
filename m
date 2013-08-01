Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab3HAHBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:01:06 -0400
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:51336 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750742Ab3HAHBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:01:05 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 8/8] ARM: at91/dt: use periph id macros for sama5d3 interrupt definitions
Date: Thu,  1 Aug 2013 09:01:00 +0200
Message-Id: <1375340460-3923-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 624874448715479148
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
dt-bindings/at91/sama5d3/peripherals.h to register peripheral
interrupts.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d3.dtsi |   83 ++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index a1d5e25..01c36b6 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -13,6 +13,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/at91/sama5d3/peripherals.h>
 
 / {
 	model = "Atmel SAMA5D3 family SoC";
@@ -67,7 +68,7 @@
 			mmc0: mmc@f0000000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf0000000 0x600>;
-				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_HSMCI0 IRQ_TYPE_LEVEL_HIGH 0>;
 				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(0)>;
 				dma-names = "rxtx";
 				pinctrl-names = "default";
@@ -82,7 +83,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
-				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <SAMA5D3_ID_SPI0 IRQ_TYPE_LEVEL_HIGH 3>;
 				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(1)>,
 				       <&dma0 2 AT91_DMA_CFG_PER_ID(2)>;
 				dma-names = "tx", "rx";
@@ -94,7 +95,7 @@
 			ssc0: ssc@f0008000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xf0008000 0x4000>;
-				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 4>;
+				interrupts = <SAMA5D3_ID_SSC0 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
@@ -103,7 +104,7 @@
 			can0: can@f000c000 {
 				compatible = "atmel,at91sam9x5-can";
 				reg = <0xf000c000 0x300>;
-				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <SAMA5D3_ID_CAN0 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_can0_rx_tx>;
 				status = "disabled";
@@ -112,13 +113,13 @@
 			tcb0: timer@f0010000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf0010000 0x100>;
-				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_TC0 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			i2c0: i2c@f0014000 {
 				compatible = "atmel,at91sam9x5-i2c";
 				reg = <0xf0014000 0x4000>;
-				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <SAMA5D3_ID_TWI0 IRQ_TYPE_LEVEL_HIGH 6>;
 				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(7)>,
 				       <&dma0 2 AT91_DMA_CFG_PER_ID(8)>;
 				dma-names = "tx", "rx";
@@ -132,7 +133,7 @@
 			i2c1: i2c@f0018000 {
 				compatible = "atmel,at91sam9x5-i2c";
 				reg = <0xf0018000 0x4000>;
-				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <SAMA5D3_ID_TWI1 IRQ_TYPE_LEVEL_HIGH 6>;
 				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(9)>,
 				       <&dma0 2 AT91_DMA_CFG_PER_ID(10)>;
 				dma-names = "tx", "rx";
@@ -146,7 +147,7 @@
 			usart0: serial@f001c000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf001c000 0x100>;
-				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <SAMA5D3_ID_USART0 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
 				status = "disabled";
@@ -155,7 +156,7 @@
 			usart1: serial@f0020000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf0020000 0x100>;
-				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <SAMA5D3_ID_USART1 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
 				status = "disabled";
@@ -164,7 +165,7 @@
 			macb0: ethernet@f0028000 {
 				compatible = "cdns,pc302-gem", "cdns,gem";
 				reg = <0xf0028000 0x100>;
-				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <SAMA5D3_ID_GMAC IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
 				status = "disabled";
@@ -173,14 +174,14 @@
 			isi: isi@f0034000 {
 				compatible = "atmel,at91sam9g45-isi";
 				reg = <0xf0034000 0x4000>;
-				interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <SAMA5D3_ID_ISI IRQ_TYPE_LEVEL_HIGH 5>;
 				status = "disabled";
 			};
 
 			mmc1: mmc@f8000000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf8000000 0x600>;
-				interrupts = <22 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_HSMCI1 IRQ_TYPE_LEVEL_HIGH 0>;
 				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(0)>;
 				dma-names = "rxtx";
 				pinctrl-names = "default";
@@ -193,7 +194,7 @@
 			mmc2: mmc@f8004000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf8004000 0x600>;
-				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_HSMCI2 IRQ_TYPE_LEVEL_HIGH 0>;
 				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(1)>;
 				dma-names = "rxtx";
 				pinctrl-names = "default";
@@ -208,7 +209,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf8008000 0x100>;
-				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <SAMA5D3_ID_SPI1 IRQ_TYPE_LEVEL_HIGH 3>;
 				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(15)>,
 				       <&dma1 2 AT91_DMA_CFG_PER_ID(16)>;
 				dma-names = "tx", "rx";
@@ -220,7 +221,7 @@
 			ssc1: ssc@f800c000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xf800c000 0x4000>;
-				interrupts = <39 IRQ_TYPE_LEVEL_HIGH 4>;
+				interrupts = <SAMA5D3_ID_SSC1 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
 				status = "disabled";
@@ -229,7 +230,7 @@
 			can1: can@f8010000 {
 				compatible = "atmel,at91sam9x5-can";
 				reg = <0xf8010000 0x300>;
-				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <SAMA5D3_ID_CAN1 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_can1_rx_tx>;
 			};
@@ -237,13 +238,13 @@
 			tcb1: timer@f8014000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf8014000 0x100>;
-				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_TC1 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			adc0: adc@f8018000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xf8018000 0x100>;
-				interrupts = <29 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <SAMA5D3_ID_ADC IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <
 					&pinctrl_adc0_adtrg
@@ -297,7 +298,7 @@
 			tsadcc: tsadcc@f8018000 {
 				compatible = "atmel,at91sam9x5-tsadcc";
 				reg = <0xf8018000 0x4000>;
-				interrupts = <29 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <SAMA5D3_ID_ADC IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,tsadcc_clock = <300000>;
 				atmel,filtering_average = <0x03>;
 				atmel,pendet_debounce = <0x08>;
@@ -309,7 +310,7 @@
 			i2c2: i2c@f801c000 {
 				compatible = "atmel,at91sam9x5-i2c";
 				reg = <0xf801c000 0x4000>;
-				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <SAMA5D3_ID_TWI2 IRQ_TYPE_LEVEL_HIGH 6>;
 				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(11)>,
 				       <&dma1 2 AT91_DMA_CFG_PER_ID(12)>;
 				dma-names = "tx", "rx";
@@ -321,7 +322,7 @@
 			usart2: serial@f8020000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8020000 0x100>;
-				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <SAMA5D3_ID_USART2 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
 				status = "disabled";
@@ -330,7 +331,7 @@
 			usart3: serial@f8024000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf8024000 0x100>;
-				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <SAMA5D3_ID_USART3 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
 				status = "disabled";
@@ -339,7 +340,7 @@
 			macb1: ethernet@f802c000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xf802c000 0x100>;
-				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <SAMA5D3_ID_EMAC IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb1_rmii>;
 				status = "disabled";
@@ -348,32 +349,32 @@
 			sha@f8034000 {
 				compatible = "atmel,sam9g46-sha";
 				reg = <0xf8034000 0x100>;
-				interrupts = <42 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_SHA IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			aes@f8038000 {
 				compatible = "atmel,sam9g46-aes";
 				reg = <0xf8038000 0x100>;
-				interrupts = <43 4 0>;
+				interrupts = <SAMA5D3_ID_AES 4 0>;
 			};
 
 			tdes@f803c000 {
 				compatible = "atmel,sam9g46-tdes";
 				reg = <0xf803c000 0x100>;
-				interrupts = <44 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_TDES IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			dma0: dma-controller@ffffe600 {
 				compatible = "atmel,at91sam9g45-dma";
 				reg = <0xffffe600 0x200>;
-				interrupts = <30 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_DMA0 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
 			};
 
 			dma1: dma-controller@ffffe800 {
 				compatible = "atmel,at91sam9g45-dma";
 				reg = <0xffffe800 0x200>;
-				interrupts = <31 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <SAMA5D3_ID_DMA1 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
 			};
 
@@ -385,7 +386,7 @@
 			dbgu: serial@ffffee00 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xffffee00 0x200>;
-				interrupts = <2 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <SAMA5D3_ID_DBGU IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				status = "disabled";
@@ -396,7 +397,7 @@
 				compatible = "atmel,sama5d3-aic";
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
-				atmel,external-irqs = <47>;
+				atmel,external-irqs = <SAMA5D3_ID_IRQ0>;
 			};
 
 			pinctrl@fffff200 {
@@ -819,7 +820,7 @@
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x100>;
-					interrupts = <6 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <SAMA5D3_ID_PIOA IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -829,7 +830,7 @@
 				pioB: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x100>;
-					interrupts = <7 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <SAMA5D3_ID_PIOB IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -839,7 +840,7 @@
 				pioC: gpio@fffff600 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff600 0x100>;
-					interrupts = <8 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <SAMA5D3_ID_PIOC IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -849,7 +850,7 @@
 				pioD: gpio@fffff800 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff800 0x100>;
-					interrupts = <9 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <SAMA5D3_ID_PIOD IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -859,7 +860,7 @@
 				pioE: gpio@fffffa00 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffffa00 0x100>;
-					interrupts = <10 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <SAMA5D3_ID_PIOE IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -880,7 +881,7 @@
 			pit: timer@fffffe30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
-				interrupts = <3 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91_ID_PIT IRQ_TYPE_LEVEL_HIGH 5>;
 			};
 
 			watchdog@fffffe40 {
@@ -892,7 +893,7 @@
 			rtc@fffffeb0 {
 				compatible = "atmel,at91rm9200-rtc";
 				reg = <0xfffffeb0 0x30>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 			};
 		};
 
@@ -902,7 +903,7 @@
 			compatible = "atmel,at91sam9rl-udc";
 			reg = <0x00500000 0x100000
 			       0xf8030000 0x4000>;
-			interrupts = <33 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <SAMA5D3_ID_UDPHS IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 
 			ep0 {
@@ -1014,14 +1015,14 @@
 		usb1: ohci@00600000 {
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
-			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <SAMA5D3_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 
 		usb2: ehci@00700000 {
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00700000 0x100000>;
-			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <SAMA5D3_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 
@@ -1037,7 +1038,7 @@
 				0xffffc000 0x00000070	/* NFC HSMC regs */
 				0x00200000 0x00100000	/* NFC SRAM banks */
 				>;
-			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
+			interrupts = <SAMA5D3_ID_HSMC IRQ_TYPE_LEVEL_HIGH 6>;
 			atmel,nand-addr-offset = <21>;
 			atmel,nand-cmd-offset = <22>;
 			pinctrl-names = "default";
-- 
1.7.9.5

