Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaDVNPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:15:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48462 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756051AbaDVNMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:12:51 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 08/11] ARM: at91/dt: move at91sam9261 SoC to the new main clock model
Date: Tue, 22 Apr 2014 15:12:37 +0200
Message-Id: <1398172360-7837-9-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Jean-Jacques HIBLOT <jjhiblot@traphandler.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index e21dda0..561addc 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -45,6 +45,18 @@
 		reg = <0x20000000 0x08000000>;
 	};
 
+	main_xtal: main_xtal {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
+	slow_xtal: slow_xtal {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -524,17 +536,24 @@
 				#size-cells = <0>;
 				#interrupt-cells = <1>;
 
-				clk32k: slck {
+				slow_rc_osc: slow_rc_osc {
 					compatible = "fixed-clock";
 					#clock-cells = <0>;
 					clock-frequency = <32768>;
+					clock-accuracy = <50000000>;
+				};
+
+				clk32k: slck {
+					compatible = "atmel,at91sam9260-clk-slow";
+					#clock-cells = <0>;
+					clocks = <&slow_rc_osc &slow_xtal>;
 				};
 
 				main: mainck {
 					compatible = "atmel,at91rm9200-clk-main";
 					#clock-cells = <0>;
 					interrupts-extended = <&pmc AT91_PMC_MOSCS>;
-					clocks = <&clk32k>;
+					clocks = <&main_xtal>;
 				};
 
 				plla: pllack {
-- 
1.8.3.2

