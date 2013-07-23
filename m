Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047Ab3GWW33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:29:29 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51828 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934920Ab3GWW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:29:25 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] ARM: sun5i: dt: Use the A10s gates in the DTSI
Date: Wed, 24 Jul 2013 00:28:24 +0200
Message-Id: <1374618504-19391-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A10s has only a subset of the A10 gates. Now that the clock driver
has support for this gates set, switch to it in the DTSI.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a10s.dtsi | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 0f0881a..b8fc1c2 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -95,20 +95,16 @@
 
 		ahb_gates: ahb_gates@01c20060 {
 			#clock-cells = <1>;
-			compatible = "allwinner,sun4i-ahb-gates-clk";
+			compatible = "allwinner,sun5i-a10s-ahb-gates-clk";
 			reg = <0x01c20060 0x8>;
 			clocks = <&ahb>;
-			clock-output-names = "ahb_usb0", "ahb_ehci0",
-				"ahb_ohci0", "ahb_ehci1", "ahb_ohci1", "ahb_ss",
-				"ahb_dma", "ahb_bist", "ahb_mmc0", "ahb_mmc1",
-				"ahb_mmc2", "ahb_mmc3", "ahb_ms", "ahb_nand",
-				"ahb_sdram", "ahb_ace",	"ahb_emac", "ahb_ts",
-				"ahb_spi0", "ahb_spi1", "ahb_spi2", "ahb_spi3",
-				"ahb_pata", "ahb_sata", "ahb_gps", "ahb_ve",
-				"ahb_tvd", "ahb_tve0", "ahb_tve1", "ahb_lcd0",
-				"ahb_lcd1", "ahb_csi0", "ahb_csi1", "ahb_hdmi",
-				"ahb_de_be0", "ahb_de_be1", "ahb_de_fe0",
-				"ahb_de_fe1", "ahb_mp", "ahb_mali400";
+			clock-output-names = "ahb_usbotg", "ahb_ehci", "ahb_ohci",
+				"ahb_ss", "ahb_dma", "ahb_bist", "ahb_mmc0",
+				"ahb_mmc1", "ahb_mmc2", "ahb_nand", "ahb_sdram",
+				"ahb_emac", "ahb_ts", "ahb_spi0", "ahb_spi1",
+				"ahb_spi2", "ahb_gps", "ahb_stimer", "ahb_ve",
+				"ahb_tve", "ahb_lcd", "ahb_csi", "ahb_hdmi",
+				"ahb_de_be", "ahb_de_fe", "ahb_iep", "ahb_mali400";
 		};
 
 		apb0: apb0@01c20054 {
@@ -120,12 +116,11 @@
 
 		apb0_gates: apb0_gates@01c20068 {
 			#clock-cells = <1>;
-			compatible = "allwinner,sun4i-apb0-gates-clk";
+			compatible = "allwinner,sun5i-a10s-apb0-gates-clk";
 			reg = <0x01c20068 0x4>;
 			clocks = <&apb0>;
-			clock-output-names = "apb0_codec", "apb0_spdif",
-				"apb0_ac97", "apb0_iis", "apb0_pio", "apb0_ir0",
-				"apb0_ir1", "apb0_keypad";
+			clock-output-names = "apb0_codec", "apb0_iis", "apb0_pio",
+				"apb0_ir", "apb0_keypad";
 		};
 
 		/* dummy is pll62 */
@@ -145,15 +140,12 @@
 
 		apb1_gates: apb1_gates@01c2006c {
 			#clock-cells = <1>;
-			compatible = "allwinner,sun4i-apb1-gates-clk";
+			compatible = "allwinner,sun5i-a10s-apb1-gates-clk";
 			reg = <0x01c2006c 0x4>;
 			clocks = <&apb1>;
 			clock-output-names = "apb1_i2c0", "apb1_i2c1",
-				"apb1_i2c2", "apb1_can", "apb1_scr",
-				"apb1_ps20", "apb1_ps21", "apb1_uart0",
-				"apb1_uart1", "apb1_uart2", "apb1_uart3",
-				"apb1_uart4", "apb1_uart5", "apb1_uart6",
-				"apb1_uart7";
+				"apb1_i2c2", "apb1_uart0", "apb1_uart1",
+				"apb1_uart2", "apb1_uart3";
 		};
 	};
 
-- 
1.8.3.2

