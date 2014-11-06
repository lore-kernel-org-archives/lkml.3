Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKFDiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:38:22 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:41541 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKFDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:38:12 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ARM: dts: sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2 clocks.
Date: Thu,  6 Nov 2014 11:38:02 +0800
Message-Id: <1415245083-20452-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415245083-20452-1-git-send-email-wens@csie.org>
References: <1415245083-20452-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The apb2 clocks are actually the same as apb1 clocks on the other sunxi
platforms, hence compatible with "allwinner,sun4i-a10-apb1-clk".

Update the dtsi to use the new unified apb1 clk.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 12 ++----------
 arch/arm/boot/dts/sun8i-a23.dtsi | 12 ++----------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index e80288e..3a51151 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -217,19 +217,11 @@
 					"apb1_daudio1";
 		};
 
-		apb2_mux: apb2_mux@01c20058 {
+		apb2: clk@01c20058 {
 			#clock-cells = <0>;
-			compatible = "allwinner,sun4i-a10-apb1-mux-clk";
+			compatible = "allwinner,sun4i-a10-apb1-clk";
 			reg = <0x01c20058 0x4>;
 			clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
-			clock-output-names = "apb2_mux";
-		};
-
-		apb2: apb2@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sun6i-a31-apb2-div-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&apb2_mux>;
 			clock-output-names = "apb2";
 		};
 
diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
index 6086adb..0746cd1 100644
--- a/arch/arm/boot/dts/sun8i-a23.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23.dtsi
@@ -189,19 +189,11 @@
 					"apb1_daudio0",	"apb1_daudio1";
 		};
 
-		apb2_mux: apb2_mux_clk@01c20058 {
+		apb2: clk@01c20058 {
 			#clock-cells = <0>;
-			compatible = "allwinner,sun4i-a10-apb1-mux-clk";
+			compatible = "allwinner,sun4i-a10-apb1-clk";
 			reg = <0x01c20058 0x4>;
 			clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
-			clock-output-names = "apb2_mux";
-		};
-
-		apb2: apb2_clk@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sun6i-a31-apb2-div-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&apb2_mux>;
 			clock-output-names = "apb2";
 		};
 
-- 
2.1.1

