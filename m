Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBVVkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:40:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44123 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbaBVVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:40:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/7] ARM: dt: sun5i: Add A13 SPI controller nodes
Date: Sat, 22 Feb 2014 22:35:57 +0100
Message-Id: <1393104959-12831-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A13 has 3 SPI controllers compatible with the one found in the A10. Add
them in the DT.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13.dtsi | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 24cd86cb..7102d12 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -298,6 +298,39 @@
 		#size-cells = <1>;
 		ranges;
 
+		spi0: spi@01c05000 {
+			compatible = "allwinner,sun4i-a10-spi";
+			reg = <0x01c05000 0x1000>;
+			interrupts = <10>;
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
+			interrupts = <11>;
+			clocks = <&ahb_gates 21>, <&spi1_clk>;
+			clock-names = "ahb", "mod";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		spi2: spi@01c17000 {
+			compatible = "allwinner,sun4i-a10-spi";
+			reg = <0x01c17000 0x1000>;
+			interrupts = <12>;
+			clocks = <&ahb_gates 22>, <&spi2_clk>;
+			clock-names = "ahb", "mod";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		intc: interrupt-controller@01c20400 {
 			compatible = "allwinner,sun4i-ic";
 			reg = <0x01c20400 0x400>;
-- 
1.9.0

