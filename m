Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaDWIxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:53:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55316 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751706AbaDWIxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:53:48 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/3] ARM: at91/dt: sam9261: Fix PLL output ranges and other clocks divisors
Date: Wed, 23 Apr 2014 10:53:38 +0200
Message-Id: <1398243220-20874-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argument 3 (OUT) and 4 (ICPLL) of the atmel,pll-clk-output-ranges were missing.
Also, the at91sam9261 doesn't really have a by 3 divisor.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index 561addceb81e..3ff239b26d72 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -564,7 +564,8 @@
 					reg = <0>;
 					atmel,clk-input-range = <1000000 32000000>;
 					#atmel,pll-clk-output-range-cells = <4>;
-					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
+					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
+								<190000000 240000000 2 1>;
 				};
 
 				pllb: pllbck {
@@ -575,7 +576,8 @@
 					reg = <1>;
 					atmel,clk-input-range = <1000000 32000000>;
 					#atmel,pll-clk-output-range-cells = <4>;
-					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
+					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
+								<190000000 240000000 2 1>;
 				};
 
 				mck: masterck {
@@ -584,13 +586,13 @@
 					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
 					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
 					atmel,clk-output-range = <0 94000000>;
-					atmel,clk-divisors = <1 2 4 3>;
+					atmel,clk-divisors = <1 2 4 0>;
 				};
 
 				usb: usbck {
 					compatible = "atmel,at91rm9200-clk-usb";
 					#clock-cells = <0>;
-					atmel,clk-divisors = <1 2 4 3>;
+					atmel,clk-divisors = <1 2 4 0>;
 					clocks = <&pllb>;
 				};
 
-- 
1.9.1

