Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab3D3J4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:56:35 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52848 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848Ab3D3J4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:56:32 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: sun5i: Update the clock compatible strings
Date: Tue, 30 Apr 2013 11:56:23 +0200
Message-Id: <1367315783-21345-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367315783-21345-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367315783-21345-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A13 has a smaller clock set than the one found in the A10.
Fix the A13 device tree and documentation to reflect this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13.dtsi | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 31fa38f..8ba65c1 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -95,20 +95,15 @@
 
 		ahb_gates: ahb_gates@01c20060 {
 			#clock-cells = <1>;
-			compatible = "allwinner,sun4i-ahb-gates-clk";
+			compatible = "allwinner,sun5i-a13-ahb-gates-clk";
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
+				"ahb_spi0", "ahb_spi1", "ahb_spi2", "ahb_stimer",
+				"ahb_ve", "ahb_lcd", "ahb_csi", "ahb_de_be",
+				"ahb_de_fe", "ahb_iep", "ahb_mali400";
 		};
 
 		apb0: apb0@01c20054 {
@@ -120,15 +115,13 @@
 
 		apb0_gates: apb0_gates@01c20068 {
 			#clock-cells = <1>;
-			compatible = "allwinner,sun4i-apb0-gates-clk";
+			compatible = "allwinner,sun5i-a13-apb0-gates-clk";
 			reg = <0x01c20068 0x4>;
 			clocks = <&apb0>;
-			clock-output-names = "apb0_codec", "apb0_spdif",
-				"apb0_ac97", "apb0_iis", "apb0_pio", "apb0_ir0",
-				"apb0_ir1", "apb0_keypad";
+			clock-output-names = "apb0_codec", "apb0_pio", "apb0_ir";
 		};
 
-		/* dummy is pll62 */
+		/* dummy is pll6 */
 		apb1_mux: apb1_mux@01c20058 {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun4i-apb1-mux-clk";
@@ -145,15 +138,11 @@
 
 		apb1_gates: apb1_gates@01c2006c {
 			#clock-cells = <1>;
-			compatible = "allwinner,sun4i-apb1-gates-clk";
+			compatible = "allwinner,sun5i-a13-apb1-gates-clk";
 			reg = <0x01c2006c 0x4>;
 			clocks = <&apb1>;
 			clock-output-names = "apb1_i2c0", "apb1_i2c1",
-				"apb1_i2c2", "apb1_can", "apb1_scr",
-				"apb1_ps20", "apb1_ps21", "apb1_uart0",
-				"apb1_uart1", "apb1_uart2", "apb1_uart3",
-				"apb1_uart4", "apb1_uart5", "apb1_uart6",
-				"apb1_uart7";
+				"apb1_i2c2", "apb1_uart1", "apb1_uart3";
 		};
 	};
 
-- 
1.8.1.2

