Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaBUTu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:50:58 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39747 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754409AbaBUTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:49:58 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 7/9] ARM: at91/dt: define at91sam9rl clocks
Date: Fri, 21 Feb 2014 20:48:56 +0100
Message-Id: <1393012138-17255-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393012138-17255-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393012138-17255-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9rl clocks in at91sam9rl dtsi file.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 231 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 229 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index cb62be60985a..3673f9f3a2ab 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -8,6 +8,7 @@
 
 #include "skeleton.dtsi"
 #include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/clk/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
 
@@ -65,6 +66,8 @@
 				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 0>,
 					     <17 IRQ_TYPE_LEVEL_HIGH 0>,
 					     <18 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tc0_clk>, <&tc1_clk>, <&tc2_clk>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			mmc0: mmc@fffa4000 {
@@ -74,6 +77,8 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 				pinctrl-names = "default";
+				clocks = <&mci0_clk>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -83,6 +88,7 @@
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi0_clk>;
 				status = "disabled";
 			};
 
@@ -103,6 +109,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&usart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -114,6 +122,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&usart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -125,6 +135,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&usart2_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -136,6 +148,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&usart3_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -165,6 +179,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&spi0_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -207,9 +223,11 @@
 			};
 
 			usb0: gadget@fffd4000 {
-				compatible = "atmel,at91rm9200-udc";
+				compatible = "atmel,at91sam9rl-udc";
 				reg = <0xfffd4000 0x4000>;
 				interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&udphs_clk>, <&utmi>;
+				clock-names = "pclk", "hclk";
 				status = "disabled";
 			};
 
@@ -232,6 +250,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -513,6 +533,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioA_clk>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -523,6 +544,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioB_clk>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -533,6 +555,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioC_clk>;
 				};
 
 				pioD: gpio@fffffa00 {
@@ -543,12 +566,215 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioD_clk>;
 				};
 			};
 
 			pmc: pmc@fffffc00 {
-				compatible = "atmel,at91rm9200-pmc";
+				compatible = "atmel,at91sam9g45-pmc";
 				reg = <0xfffffc00 0x100>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupt-controller;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				#interrupt-cells = <1>;
+
+				clk32k: slck {
+					compatible = "fixed-clock";
+					#clock-cells = <0>;
+					clock-frequency = <32768>;
+				};
+
+				main: mainck {
+					compatible = "atmel,at91rm9200-clk-main";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_MOSCS>;
+					clocks = <&clk32k>;
+				};
+
+				plla: pllack {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_LOCKA>;
+					clocks = <&main>;
+					reg = <0>;
+					atmel,clk-input-range = <1000000 32000000>;
+					#atmel,pll-clk-output-range-cells = <4>;
+					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
+				};
+
+				utmi: utmick {
+					compatible = "atmel,at91sam9x5-clk-utmi";
+					#clock-cells = <0>;
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_LOCKU>;
+					clocks = <&main>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91rm9200-clk-master";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&utmi>;
+					atmel,clk-output-range = <0 94000000>;
+					atmel,clk-divisors = <1 2 4 3>;
+				};
+
+				prog: progck {
+					compatible = "atmel,at91rm9200-clk-programmable";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					interrupt-parent = <&pmc>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&utmi>, <&mck>;
+
+					prog0: prog0 {
+						#clock-cells = <0>;
+						reg = <0>;
+						interrupts = <AT91_PMC_PCKRDY(0)>;
+					};
+
+					prog1: prog1 {
+						#clock-cells = <0>;
+						reg = <1>;
+						interrupts = <AT91_PMC_PCKRDY(1)>;
+					};
+				};
+
+				systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					pck0: pck0 {
+						#clock-cells = <0>;
+						reg = <8>;
+						clocks = <&prog0>;
+					};
+
+					pck1: pck1 {
+						#clock-cells = <0>;
+						reg = <9>;
+						clocks = <&prog1>;
+					};
+
+				};
+
+				periphck {
+					compatible = "atmel,at91rm9200-clk-peripheral";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					clocks = <&mck>;
+
+					pioA_clk: pioA_clk {
+						#clock-cells = <0>;
+						reg = <2>;
+					};
+
+					pioB_clk: pioB_clk {
+						#clock-cells = <0>;
+						reg = <3>;
+					};
+
+					pioC_clk: pioC_clk {
+						#clock-cells = <0>;
+						reg = <4>;
+					};
+
+					pioD_clk: pioD_clk {
+						#clock-cells = <0>;
+						reg = <5>;
+					};
+
+					usart0_clk: usart0_clk {
+						#clock-cells = <0>;
+						reg = <6>;
+					};
+
+					usart1_clk: usart1_clk {
+						#clock-cells = <0>;
+						reg = <7>;
+					};
+
+					usart2_clk: usart2_clk {
+						#clock-cells = <0>;
+						reg = <8>;
+					};
+
+					usart3_clk: usart3_clk {
+						#clock-cells = <0>;
+						reg = <9>;
+					};
+
+					mci0_clk: mci0_clk {
+						#clock-cells = <0>;
+						reg = <10>;
+					};
+
+					twi0_clk: twi0_clk {
+						#clock-cells = <0>;
+						reg = <11>;
+					};
+
+					twi1_clk: twi1_clk {
+						#clock-cells = <0>;
+						reg = <12>;
+					};
+
+					spi0_clk: spi0_clk {
+						#clock-cells = <0>;
+						reg = <13>;
+					};
+
+					ssc0_clk: ssc0_clk {
+						#clock-cells = <0>;
+						reg = <14>;
+					};
+
+					ssc1_clk: ssc1_clk {
+						#clock-cells = <0>;
+						reg = <15>;
+					};
+
+					tc0_clk: tc0_clk {
+						#clock-cells = <0>;
+						reg = <16>;
+					};
+
+					tc1_clk: tc1_clk {
+						#clock-cells = <0>;
+						reg = <17>;
+					};
+
+					tc2_clk: tc2_clk {
+						#clock-cells = <0>;
+						reg = <18>;
+					};
+
+					pmw_clk: pwm_clk {
+						#clock-cells = <0>;
+						reg = <19>;
+					};
+
+					adc_clk: adc_clk {
+						#clock-cells = <0>;
+						reg = <20>;
+	 				};
+
+					dma0_clk: dma0_clk {
+						#clock-cells = <0>;
+						reg = <21>;
+					};
+
+					udphs_clk: udphs_clk {
+						#clock-cells = <0>;
+						reg = <22>;
+					};
+
+					lcd_clk: lcd_clk {
+						#clock-cells = <0>;
+						reg = <23>;
+					};
+				};
 			};
 
 			rstc@fffffd00 {
@@ -565,6 +791,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			watchdog@fffffd40 {
-- 
1.8.3.2

