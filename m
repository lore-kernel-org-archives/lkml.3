Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaIIKOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:14:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55856 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbaIIKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:14:24 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] ARM: at91/dt: declare sckc node on at91sam9g45
Date: Tue,  9 Sep 2014 12:14:20 +0200
Message-Id: <1410257660-8590-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare the SCKC (Slow Clock Configuration) block and its clks.
Make use of the clk32k clk instead of slow_osc where appropriate.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 9d4d0a1..68a457b 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -159,7 +159,7 @@
 					compatible = "atmel,at91rm9200-clk-master";
 					#clock-cells = <0>;
 					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
-					clocks = <&slow_xtal>, <&main>, <&plladiv>, <&utmi>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
 					atmel,clk-output-range = <0 133333333>;
 					atmel,clk-divisors = <1 2 4 3>;
 				};
@@ -175,7 +175,7 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 					interrupt-parent = <&pmc>;
-					clocks = <&slow_xtal>, <&main>, <&plladiv>, <&utmi>, <&mck>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
 
 					prog0: prog0 {
 						#clock-cells = <0>;
@@ -1160,6 +1160,32 @@
 				};
 			};
 
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
+
 			rtc@fffffdb0 {
 				compatible = "atmel,at91rm9200-rtc";
 				reg = <0xfffffdb0 0x10>;
-- 
1.9.1

