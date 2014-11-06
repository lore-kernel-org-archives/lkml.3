Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKFDiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:38:23 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:41539 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaKFDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:38:12 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 2/4] ARM: dts: sunxi: unify APB1 clock
Date: Thu,  6 Nov 2014 11:38:01 +0800
Message-Id: <1415245083-20452-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415245083-20452-1-git-send-email-wens@csie.org>
References: <1415245083-20452-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>

With the new factors infrastructure in place, we can unify apb1 and
apb1_mux as a single clock now.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
[wens@csie.org: Change apb1 node label to "apb1"; reword commit title]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi  | 12 ++----------
 arch/arm/boot/dts/sun5i-a10s.dtsi | 12 ++----------
 arch/arm/boot/dts/sun5i-a13.dtsi  | 12 ++----------
 arch/arm/boot/dts/sun7i-a20.dtsi  | 12 ++----------
 4 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 380f914..5e2ec2d 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -174,19 +174,11 @@
 				"apb0_ir1", "apb0_keypad";
 		};
 
-		apb1_mux: apb1_mux@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sun4i-a10-apb1-mux-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
-			clock-output-names = "apb1_mux";
-		};
-
-		apb1: apb1@01c20058 {
+		apb1: clk@01c20058 {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun4i-a10-apb1-clk";
 			reg = <0x01c20058 0x4>;
-			clocks = <&apb1_mux>;
+			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
 			clock-output-names = "apb1";
 		};
 
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 531272c..d2a8514 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -162,19 +162,11 @@
 				"apb0_ir", "apb0_keypad";
 		};
 
-		apb1_mux: apb1_mux@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sun4i-a10-apb1-mux-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
-			clock-output-names = "apb1_mux";
-		};
-
-		apb1: apb1@01c20058 {
+		apb1: clk@01c20058 {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun4i-a10-apb1-clk";
 			reg = <0x01c20058 0x4>;
-			clocks = <&apb1_mux>;
+			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
 			clock-output-names = "apb1";
 		};
 
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index b131068..c35217e 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -161,19 +161,11 @@
 			clock-output-names = "apb0_codec", "apb0_pio", "apb0_ir";
 		};
 
-		apb1_mux: apb1_mux@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sun4i-a10-apb1-mux-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
-			clock-output-names = "apb1_mux";
-		};
-
-		apb1: apb1@01c20058 {
+		apb1: clk@01c20058 {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun4i-a10-apb1-clk";
 			reg = <0x01c20058 0x4>;
-			clocks = <&apb1_mux>;
+			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
 			clock-output-names = "apb1";
 		};
 
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 45bb916..8605f2b 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -222,19 +222,11 @@
 				"apb0_iis2", "apb0_keypad";
 		};
 
-		apb1_mux: apb1_mux@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sun4i-a10-apb1-mux-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
-			clock-output-names = "apb1_mux";
-		};
-
-		apb1: apb1@01c20058 {
+		apb1: clk@01c20058 {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun4i-a10-apb1-clk";
 			reg = <0x01c20058 0x4>;
-			clocks = <&apb1_mux>;
+			clocks = <&osc24M>, <&pll6 1>, <&osc32k>;
 			clock-output-names = "apb1";
 		};
 
-- 
2.1.1

