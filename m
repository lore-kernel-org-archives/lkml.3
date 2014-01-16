Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaAPRQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:16:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51887 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753089AbaAPRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:15:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/4] ARM: sun6i: dt: Add PLL6 and SPI module clocks
Date: Thu, 16 Jan 2014 18:11:23 +0100
Message-Id: <1389892285-11745-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module clocks in the A31 are still compatible with the A10 one. Add the SPI
module clocks and the PLL6 in the device tree to allow their use by the SPI
controllers.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 48 +++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 5256ad9..ae058eb 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -73,16 +73,12 @@
 			clocks = <&osc24M>;
 		};
 
-		/*
-		 * This is a dummy clock, to be used as placeholder on
-		 * other mux clocks when a specific parent clock is not
-		 * yet implemented. It should be dropped when the driver
-		 * is complete.
-		 */
-		pll6: pll6 {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <0>;
+		pll6: clk@01c20028 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun6i-a31-pll6-clk";
+			reg = <0x01c20028 0x4>;
+			clocks = <&osc24M>;
+			clock-output-names = "pll6";
 		};
 
 		cpu: cpu@01c20050 {
@@ -182,6 +178,38 @@
 					"apb2_uart1", "apb2_uart2", "apb2_uart3",
 					"apb2_uart4", "apb2_uart5";
 		};
+
+		spi0_clk: clk@01c200a0 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-mod0-clk";
+			reg = <0x01c200a0 0x4>;
+			clocks = <&osc24M>, <&pll6>;
+			clock-output-names = "spi0";
+		};
+
+		spi1_clk: clk@01c200a4 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-mod0-clk";
+			reg = <0x01c200a4 0x4>;
+			clocks = <&osc24M>, <&pll6>;
+			clock-output-names = "spi1";
+		};
+
+		spi2_clk: clk@01c200a8 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-mod0-clk";
+			reg = <0x01c200a8 0x4>;
+			clocks = <&osc24M>, <&pll6>;
+			clock-output-names = "spi2";
+		};
+
+		spi3_clk: clk@01c200ac {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-mod0-clk";
+			reg = <0x01c200ac 0x4>;
+			clocks = <&osc24M>, <&pll6>;
+			clock-output-names = "spi3";
+		};
 	};
 
 	soc@01c00000 {
-- 
1.8.4.2

