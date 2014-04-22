Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaDVNNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:13:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48486 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751220AbaDVNMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:12:53 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 10/11] ARM: at91/dt: move at91sam9rl SoC to the new slow/main clock models
Date: Tue, 22 Apr 2014 15:12:39 +0200
Message-Id: <1398172360-7837-11-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move at91sam9rl SoC to the new main/slow clock model.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 46 +++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 63e1784..a19a7c2 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -48,6 +48,18 @@
 		reg = <0x20000000 0x04000000>;
 	};
 
+	slow_xtal: slow_xtal {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
+	main_xtal: main_xtal {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -548,17 +560,11 @@
 				#size-cells = <0>;
 				#interrupt-cells = <1>;
 
-				clk32k: slck {
-					compatible = "fixed-clock";
-					#clock-cells = <0>;
-					clock-frequency = <32768>;
-				};
-
 				main: mainck {
 					compatible = "atmel,at91rm9200-clk-main";
 					#clock-cells = <0>;
 					interrupts-extended = <&pmc AT91_PMC_MOSCS>;
-					clocks = <&clk32k>;
+					clocks = <&main_xtal>;
 				};
 
 				plla: pllack {
@@ -769,6 +775,32 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				status = "disabled";
 			};
+
+			sckc@fffffd50 {
+				compatible = "atmel,at91sam9x5-sckc";
+				reg = <0xfffffd50 0x4>;
+
+				slow_osc: slow_osc {
+					compatible = "atmel,at91sam9x5-clk-slow-osc";
+					#clock-cells = <0>;
+					atmel,startup-time-usec = <1200000>;
+					clocks = <&slow_xtal>;
+				};
+
+				slow_rc_osc: slow_rc_osc {
+					compatible = "atmel,at91sam9x5-clk-slow-rc-osc";
+					#clock-cells = <0>;
+					atmel,startup-time-usec = <75>;
+					clock-frequency = <32768>;
+					clock-accuracy = <50000000>;
+				};
+
+				clk32k: slck {
+					compatible = "atmel,at91sam9x5-clk-slow";
+					#clock-cells = <0>;
+					clocks = <&slow_rc_osc &slow_osc>;
+				};
+			};
 		};
 	};
 
-- 
1.8.3.2

