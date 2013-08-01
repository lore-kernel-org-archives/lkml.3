Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3HAHCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:02:00 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:36875 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750742Ab3HAHB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:01:59 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, Bo Shen <voice.shen@atmel.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 4/8] ARM: at91/dt: use periph id macros for at91sam9263 interrupt definitions
Date: Thu,  1 Aug 2013 08:55:38 +0200
Message-Id: <1375340139-3763-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 534802457556318316
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
dt-bindings/at91/at91sam9263/peripherals.h to register peripheral
interrupts.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9263.dtsi |   46 +++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index d5bd65f..590fd7b 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/at91/at91sam9263/peripherals.h>
 
 / {
 	model = "Atmel AT91SAM9263 family SoC";
@@ -62,7 +63,8 @@
 				compatible = "atmel,at91rm9200-aic";
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
-				atmel,external-irqs = <30 31>;
+				atmel,external-irqs = <AT91SAM9263_ID_IRQ0
+						       AT91SAM9263_ID_IRQ1>;
 			};
 
 			pmc: pmc@fffffc00 {
@@ -79,13 +81,13 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 			};
 
 			tcb0: timer@fff7c000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfff7c000 0x100>;
-				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9263_ID_TCB IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			rstc@fffffd00 {
@@ -369,7 +371,7 @@
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
-					interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9263_ID_PIOA IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -379,7 +381,7 @@
 				pioB: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
-					interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9263_ID_PIOB IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -389,7 +391,7 @@
 				pioC: gpio@fffff600 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff600 0x200>;
-					interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9263_ID_PIOCDE IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -399,7 +401,7 @@
 				pioD: gpio@fffff800 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff800 0x200>;
-					interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9263_ID_PIOCDE IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -409,7 +411,7 @@
 				pioE: gpio@fffffa00 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffffa00 0x200>;
-					interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
+					interrupts = <AT91SAM9263_ID_PIOCDE IRQ_TYPE_LEVEL_HIGH 1>;
 					#gpio-cells = <2>;
 					gpio-controller;
 					interrupt-controller;
@@ -420,7 +422,7 @@
 			dbgu: serial@ffffee00 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xffffee00 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				status = "disabled";
@@ -429,7 +431,7 @@
 			usart0: serial@fff8c000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff8c000 0x200>;
-				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9263_ID_US0 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -440,7 +442,7 @@
 			usart1: serial@fff90000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff90000 0x200>;
-				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9263_ID_US1 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -451,7 +453,7 @@
 			usart2: serial@fff94000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfff94000 0x200>;
-				interrupts = <9 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9263_ID_US2 IRQ_TYPE_LEVEL_HIGH 5>;
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
@@ -462,7 +464,7 @@
 			ssc0: ssc@fff98000 {
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfff98000 0x4000>;
-				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9263_ID_SSC0 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
@@ -471,7 +473,7 @@
 			ssc1: ssc@fff9c000 {
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfff9c000 0x4000>;
-				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
+				interrupts = <AT91SAM9263_ID_SSC1 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
 				status = "disabled";
@@ -480,7 +482,7 @@
 			macb0: ethernet@fffbc000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xfffbc000 0x100>;
-				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9263_ID_EMAC IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
 				status = "disabled";
@@ -489,14 +491,14 @@
 			usb1: gadget@fff78000 {
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfff78000 0x4000>;
-				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 2>;
+				interrupts = <AT91SAM9263_ID_UDP IRQ_TYPE_LEVEL_HIGH 2>;
 				status = "disabled";
 			};
 
 			i2c0: i2c@fff88000 {
 				compatible = "atmel,at91sam9263-i2c";
 				reg = <0xfff88000 0x100>;
-				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 6>;
+				interrupts = <AT91SAM9263_ID_TWI IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -505,7 +507,7 @@
 			mmc0: mmc@fff80000 {
 				compatible = "atmel,hsmci";
 				reg = <0xfff80000 0x600>;
-				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9263_ID_MCI0 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -514,7 +516,7 @@
 			mmc1: mmc@fff84000 {
 				compatible = "atmel,hsmci";
 				reg = <0xfff84000 0x600>;
-				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 0>;
+				interrupts = <AT91SAM9263_ID_MCI1 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -531,7 +533,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa4000 0x200>;
-				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9263_ID_SPI0 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
@@ -542,7 +544,7 @@
 				#size-cells = <0>;
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa8000 0x200>;
-				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 3>;
+				interrupts = <AT91SAM9263_ID_SPI1 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
@@ -570,7 +572,7 @@
 		usb0: ohci@00a00000 {
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00a00000 0x100000>;
-			interrupts = <29 IRQ_TYPE_LEVEL_HIGH 2>;
+			interrupts = <AT91SAM9263_ID_UHP IRQ_TYPE_LEVEL_HIGH 2>;
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

