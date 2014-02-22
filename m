Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaBVVkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:40:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44098 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752225AbaBVVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:40:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/7] ARM: dt: sun7i: Add A20 SPI controller nodes
Date: Sat, 22 Feb 2014 22:35:54 +0100
Message-Id: <1393104959-12831-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A20 has 4 SPI controllers compatible with the one found in the A10. Add
them in the DT.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 44 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index d00fbf8..0f0ee58 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -401,6 +401,28 @@
 		#size-cells = <1>;
 		ranges;
 
+		spi0: spi@01c05000 {
+			compatible = "allwinner,sun4i-a10-spi";
+			reg = <0x01c05000 0x1000>;
+			interrupts = <0 10 4>;
+			clocks = <&ahb_gates 20>, <&spi0_clk>;
+			clock-names = "ahb", "mod";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		spi1: spi@01c06000 {
+			compatible = "allwinner,sun4i-a10-spi";
+			reg = <0x01c06000 0x1000>;
+			interrupts = <0 11 4>;
+			clocks = <&ahb_gates 21>, <&spi1_clk>;
+			clock-names = "ahb", "mod";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		emac: ethernet@01c0b000 {
 			compatible = "allwinner,sun4i-a10-emac";
 			reg = <0x01c0b000 0x1000>;
@@ -417,6 +439,28 @@
 			#size-cells = <0>;
 		};
 
+		spi2: spi@01c17000 {
+			compatible = "allwinner,sun4i-a10-spi";
+			reg = <0x01c17000 0x1000>;
+			interrupts = <0 12 4>;
+			clocks = <&ahb_gates 22>, <&spi2_clk>;
+			clock-names = "ahb", "mod";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		spi3: spi@01c1f000 {
+			compatible = "allwinner,sun4i-a10-spi";
+			reg = <0x01c1f000 0x1000>;
+			interrupts = <0 50 4>;
+			clocks = <&ahb_gates 23>, <&spi3_clk>;
+			clock-names = "ahb", "mod";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun7i-a20-pinctrl";
 			reg = <0x01c20800 0x400>;
-- 
1.9.0

