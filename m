Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaFYKTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:19:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:25785 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbaFYKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:19:16 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/dt: sam9261: remove slow RC osc
Date: Wed, 25 Jun 2014 12:19:14 +0200
Message-ID: <1403691554-22096-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

The at91sam9261 doesn't actually have a slow RC oscillator, remove it from the
dtsi.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index c8e8b92df51b..a81aab4281a7 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -570,19 +570,6 @@
 				#size-cells = <0>;
 				#interrupt-cells = <1>;
 
-				slow_rc_osc: slow_rc_osc {
-					compatible = "fixed-clock";
-					#clock-cells = <0>;
-					clock-frequency = <32768>;
-					clock-accuracy = <50000000>;
-				};
-
-				clk32k: slck {
-					compatible = "atmel,at91sam9260-clk-slow";
-					#clock-cells = <0>;
-					clocks = <&slow_rc_osc &slow_xtal>;
-				};
-
 				main_osc: main_osc {
 					compatible = "atmel,at91rm9200-clk-main-osc";
 					#clock-cells = <0>;
@@ -623,7 +610,7 @@
 					compatible = "atmel,at91rm9200-clk-master";
 					#clock-cells = <0>;
 					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
-					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					clocks = <&slow_xtal>, <&main>, <&plla>, <&pllb>;
 					atmel,clk-output-range = <0 94000000>;
 					atmel,clk-divisors = <1 2 4 0>;
 				};
@@ -640,7 +627,7 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 					interrupt-parent = <&pmc>;
-					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					clocks = <&slow_xtal>, <&main>, <&plla>, <&pllb>;
 
 					prog0: prog0 {
 						#clock-cells = <0>;
-- 
1.8.2.2

