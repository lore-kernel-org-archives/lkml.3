Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaDWOCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:02:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57909 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756029AbaDWOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:01:40 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/5] ARM: berlin/dt: add sdio clocks to BG2CD
Date: Wed, 23 Apr 2014 16:01:06 +0200
Message-Id: <1398261667-12621-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sdio clocks to the berlin2cd.dtsi
Also reorder the PLLs nodes by address

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2cd.dtsi | 42 ++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index bd4e9dd4867e..9b3faeee0728 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -79,20 +79,6 @@
 			clocks = <&twdclk>;
 		};
 
-		syspll: syspll@ea0014 {
-			compatible = "marvell,berlin2-pll";
-			clocks = <&smclk>;
-			#clock-cells = <0>;
-			reg = <0xf7ea0014 8>;
-		};
-
-		cpupll: cpupll@ea003c {
-			compatible = "marvell,berlin2-pll";
-			clocks = <&smclk>;
-			#clock-cells = <0>;
-			reg = <0xf7ea003c 8>;
-		};
-
 		apb@e80000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -183,6 +169,34 @@
 			};
 		};
 
+		syspll: syspll@ea0014 {
+			compatible = "marvell,berlin2-pll";
+			clocks = <&smclk>;
+			#clock-cells = <0>;
+			reg = <0xf7ea0014 8>;
+		};
+
+		cpupll: cpupll@ea003c {
+			compatible = "marvell,berlin2-pll";
+			clocks = <&smclk>;
+			#clock-cells = <0>;
+			reg = <0xf7ea003c 8>;
+		};
+
+		sdio0xinclk: sdio0xinclk@ea023c {
+			compatible = "marvell,berlin-clk";
+			clocks = <&syspll>;
+			#clock-cells = <0>;
+			reg = <0xea023c 4>;
+		};
+
+		sdio1xinclk: sdio1xinclk@ea0240 {
+			compatible = "marvell,berlin-clk";
+			clocks = <&syspll>;
+			#clock-cells = <0>;
+			reg = <0xea0240 4>;
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.9.1

