Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaCJTSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:18:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51184 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752889AbaCJTRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:17:44 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 7/8] ARM: at91/dt: sama5d3: remove useless adc properties
Date: Mon, 10 Mar 2014 20:17:24 +0100
Message-Id: <1394479045-31852-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the properties that are not used anymore by the at91_adc driver and fix
the atmel,adc-use-external-triggers property name.

Also, add #address-cells, #size-cells and a reg for each trigger to comply to
the ePAPR.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi    | 13 +++++++------
 arch/arm/boot/dts/sama5d3xdm.dtsi |  1 -
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 26d7ed510c96..73ad828296b2 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -239,6 +239,8 @@
 			};
 
 			adc0: adc@f8018000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
 				compatible = "atmel,at91sam9x5-adc";
 				reg = <0xf8018000 0x100>;
 				interrupts = <29 IRQ_TYPE_LEVEL_HIGH 5>;
@@ -261,35 +263,34 @@
 				clocks = <&adc_clk>,
 					 <&adc_op_clk>;
 				clock-names = "adc_clk", "adc_op_clk";
-				atmel,adc-channel-base = <0x50>;
 				atmel,adc-channels-used = <0xfff>;
-				atmel,adc-drdy-mask = <0x1000000>;
-				atmel,adc-num-channels = <12>;
 				atmel,adc-startup-time = <40>;
-				atmel,adc-status-register = <0x30>;
-				atmel,adc-trigger-register = <0xc0>;
-				atmel,adc-use-external;
+				atmel,adc-use-external-triggers;
 				atmel,adc-vref = <3000>;
 				atmel,adc-res = <10 12>;
 				atmel,adc-res-names = "lowres", "highres";
 				status = "disabled";
 
 				trigger@0 {
+					reg = <0>;
 					trigger-name = "external-rising";
 					trigger-value = <0x1>;
 					trigger-external;
 				};
 				trigger@1 {
+					reg = <1>;
 					trigger-name = "external-falling";
 					trigger-value = <0x2>;
 					trigger-external;
 				};
 				trigger@2 {
+					reg = <2>;
 					trigger-name = "external-any";
 					trigger-value = <0x3>;
 					trigger-external;
 				};
 				trigger@3 {
+					reg = <3>;
 					trigger-name = "continuous";
 					trigger-value = <0x6>;
 				};
diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
index 0b8f5d106ff2..035ab72b3990 100644
--- a/arch/arm/boot/dts/sama5d3xdm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xdm.dtsi
@@ -23,7 +23,6 @@
 			};
 
 			adc0: adc@f8018000 {
-				atmel,adc-clock-rate = <1000000>;
 				atmel,adc-ts-wires = <4>;
 				atmel,adc-ts-pressure-threshold = <10000>;
 				status = "okay";
-- 
1.8.3.2

