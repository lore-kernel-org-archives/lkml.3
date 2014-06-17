Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532AbaFQQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:42:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48077 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965497AbaFQQmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:42:00 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 6/6] ARM: at91/dt: sama5d3 crystals under the clocks node
Date: Tue, 17 Jun 2014 18:41:48 +0200
Message-Id: <1403023308-20533-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having clocks grouped in a subnode is common practice, so move the crystals
under a clocks node for the sama5d3 SoC and sama5d3 based boards.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 12 +++++++-----
 arch/arm/boot/dts/sama5d3.dtsi              | 22 +++++++++++-----------
 arch/arm/boot/dts/sama5d3xcm.dtsi           | 12 +++++++-----
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index 5b8e40400bec..fec1fca2ad66 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -21,12 +21,14 @@
 		reg = <0x20000000 0x10000000>;
 	};
 
-	slow_xtal {
-		clock-frequency = <32768>;
-	};
+	clocks {
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
 
-	main_xtal {
-		clock-frequency = <12000000>;
+		main_xtal {
+			clock-frequency = <12000000>;
+		};
 	};
 
 	ahb {
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index e0b15a6e8897..45013b867c8d 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -58,19 +58,19 @@
 		reg = <0x20000000 0x8000000>;
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
diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index b0b1331c1974..f7d8583eef82 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -18,12 +18,14 @@
 		reg = <0x20000000 0x20000000>;
 	};
 
-	slow_xtal {
-		clock-frequency = <32768>;
-	};
+	clocks {
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
 
-	main_xtal {
-		clock-frequency = <12000000>;
+		main_xtal {
+			clock-frequency = <12000000>;
+		};
 	};
 
 	ahb {
-- 
1.9.1

