Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaDWIxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:53:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55320 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbaDWIxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:53:49 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] ARM: at91/dt: sam9261: Add ssc2, SSC clocks and pcks
Date: Wed, 23 Apr 2014 10:53:39 +0200
Message-Id: <1398243220-20874-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398243220-20874-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398243220-20874-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ssc2 support, ssc2 pinctrl and clocks for the three SSCs.
Also add support for the programmable clocks.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi | 103 +++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index 3ff239b26d72..698063addca9 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -29,6 +29,7 @@
 		i2c0 = &i2c0;
 		ssc0 = &ssc0;
 		ssc1 = &ssc1;
+		ssc2 = &ssc2;
 	};
 
 	cpus {
@@ -194,6 +195,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&ssc0_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -203,6 +206,19 @@
 				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&ssc1_clk>;
+				clock-names = "pclk";
+				status = "disabled";
+			};
+
+			ssc2: ssc@fffc4000 {
+				compatible = "atmel,at91rm9200-ssc";
+				reg = <0xfffc4000 0x4000>;
+				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc2_tx &pinctrl_ssc2_rx>;
+				clocks = <&ssc2_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -397,6 +413,22 @@
 					};
 				};
 
+				ssc2 {
+					pinctrl_ssc2_tx: ssc2_tx-0 {
+						atmel,pins =
+							<AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_ssc2_rx: ssc2_rx-0 {
+						atmel,pins =
+							<AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 29 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 30 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
 				spi0 {
 					pinctrl_spi0: spi0-0 {
 						atmel,pins =
@@ -596,6 +628,38 @@
 					clocks = <&pllb>;
 				};
 
+				prog: progck {
+					compatible = "atmel,at91rm9200-clk-programmable";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					interrupt-parent = <&pmc>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
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
+
+					prog2: prog2 {
+						#clock-cells = <0>;
+						reg = <2>;
+						interrupts = <AT91_PMC_PCKRDY(2)>;
+					};
+
+					prog3: prog3 {
+						#clock-cells = <0>;
+						reg = <3>;
+						interrupts = <AT91_PMC_PCKRDY(3)>;
+					};
+				};
+
 				systemck {
 					compatible = "atmel,at91rm9200-clk-system";
 					#address-cells = <1>;
@@ -613,6 +677,30 @@
 						clocks = <&usb>;
 					};
 
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
+					pck2: pck2 {
+						#clock-cells = <0>;
+						reg = <10>;
+						clocks = <&prog2>;
+					};
+
+					pck3: pck3 {
+						#clock-cells = <0>;
+						reg = <11>;
+						clocks = <&prog3>;
+					};
+
 					hclk0: hclk0 {
 						#clock-cells = <0>;
 						reg = <16>;
@@ -687,6 +775,21 @@
 						reg = <13>;
 					};
 
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
+					ssc2_clk: ssc2_clk {
+						#clock-cells = <0>;
+						reg = <16>;
+					};
+
 					tc0_clk: tc0_clk {
 						#clock-cells = <0>;
 						reg = <17>;
-- 
1.9.1

