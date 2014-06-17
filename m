Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712AbaFQQmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:42:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48070 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965692AbaFQQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:41:59 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/6] ARM: at91/dt: sam9rl crystals under the clocks node
Date: Tue, 17 Jun 2014 18:41:46 +0200
Message-Id: <1403023308-20533-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having clocks grouped in a subnode is common practice, so move the crystals
under a clocks node for the at91sam9rl SoC and at91sam9rl based boards.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rl.dtsi  | 22 +++++++++++-----------
 arch/arm/boot/dts/at91sam9rlek.dts | 17 ++++++++---------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 1da183155eee..8d6751a00074 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -50,19 +50,19 @@
 		reg = <0x20000000 0x04000000>;
 	};
 
-	slow_xtal: slow_xtal {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <0>;
-	};
+	clocks {
+		slow_xtal: slow_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
 
-	main_xtal: main_xtal {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <0>;
-	};
+		main_xtal: main_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
 
-	clocks {
 		adc_op_clk: adc_op_clk{
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/at91sam9rlek.dts b/arch/arm/boot/dts/at91sam9rlek.dts
index d4a010e40fe3..9be5b540eebf 100644
--- a/arch/arm/boot/dts/at91sam9rlek.dts
+++ b/arch/arm/boot/dts/at91sam9rlek.dts
@@ -20,15 +20,6 @@
 		reg = <0x20000000 0x4000000>;
 	};
 
-
-	slow_xtal {
-		clock-frequency = <32768>;
-	};
-
-	main_xtal {
-		clock-frequency = <12000000>;
-	};
-
 	clocks {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -38,6 +29,14 @@
 			compatible = "atmel,osc", "fixed-clock";
 			clock-frequency = <12000000>;
 		};
+
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal {
+			clock-frequency = <12000000>;
+		};
 	};
 
 	ahb {
-- 
1.9.1

