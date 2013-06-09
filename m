Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3FIQgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:36:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56956 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3FIQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:36:28 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/6] ARM: sunxi: dt: Add Allwinner A10s DTSI
Date: Sun,  9 Jun 2013 18:36:05 +0200
Message-Id: <1370795767-9769-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a10s.dtsi | 286 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 286 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun5i-a10s.dtsi

diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
new file mode 100644
index 0000000..2307ce8
--- /dev/null
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -0,0 +1,286 @@
+/*
+ * Copyright 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&intc>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a8";
+		};
+	};
+
+	memory {
+		reg = <0x40000000 0x20000000>;
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/*
+		 * This is a dummy clock, to be used as placeholder on
+		 * other mux clocks when a specific parent clock is not
+		 * yet implemented. It should be dropped when the driver
+		 * is complete.
+		 */
+		dummy: dummy {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		osc24M: osc24M@01c20050 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-osc-clk";
+			reg = <0x01c20050 0x4>;
+			clock-frequency = <24000000>;
+		};
+
+		osc32k: osc32k {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+		};
+
+		pll1: pll1@01c20000 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-pll1-clk";
+			reg = <0x01c20000 0x4>;
+			clocks = <&osc24M>;
+		};
+
+		/* dummy is 200M */
+		cpu: cpu@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-cpu-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&osc32k>, <&osc24M>, <&pll1>, <&dummy>;
+		};
+
+		axi: axi@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-axi-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&cpu>;
+		};
+
+		axi_gates: axi_gates@01c2005c {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun4i-axi-gates-clk";
+			reg = <0x01c2005c 0x4>;
+			clocks = <&axi>;
+			clock-output-names = "axi_dram";
+		};
+
+		ahb: ahb@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-ahb-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&axi>;
+		};
+
+		ahb_gates: ahb_gates@01c20060 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun4i-ahb-gates-clk";
+			reg = <0x01c20060 0x8>;
+			clocks = <&ahb>;
+			clock-output-names = "ahb_usb0", "ahb_ehci0",
+				"ahb_ohci0", "ahb_ehci1", "ahb_ohci1", "ahb_ss",
+				"ahb_dma", "ahb_bist", "ahb_mmc0", "ahb_mmc1",
+				"ahb_mmc2", "ahb_mmc3", "ahb_ms", "ahb_nand",
+				"ahb_sdram", "ahb_ace",	"ahb_emac", "ahb_ts",
+				"ahb_spi0", "ahb_spi1", "ahb_spi2", "ahb_spi3",
+				"ahb_pata", "ahb_sata", "ahb_gps", "ahb_ve",
+				"ahb_tvd", "ahb_tve0", "ahb_tve1", "ahb_lcd0",
+				"ahb_lcd1", "ahb_csi0", "ahb_csi1", "ahb_hdmi",
+				"ahb_de_be0", "ahb_de_be1", "ahb_de_fe0",
+				"ahb_de_fe1", "ahb_mp", "ahb_mali400";
+		};
+
+		apb0: apb0@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-apb0-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&ahb>;
+		};
+
+		apb0_gates: apb0_gates@01c20068 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun4i-apb0-gates-clk";
+			reg = <0x01c20068 0x4>;
+			clocks = <&apb0>;
+			clock-output-names = "apb0_codec", "apb0_spdif",
+				"apb0_ac97", "apb0_iis", "apb0_pio", "apb0_ir0",
+				"apb0_ir1", "apb0_keypad";
+		};
+
+		/* dummy is pll62 */
+		apb1_mux: apb1_mux@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-apb1-mux-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&osc24M>, <&dummy>, <&osc32k>;
+		};
+
+		apb1: apb1@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-apb1-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&apb1_mux>;
+		};
+
+		apb1_gates: apb1_gates@01c2006c {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun4i-apb1-gates-clk";
+			reg = <0x01c2006c 0x4>;
+			clocks = <&apb1>;
+			clock-output-names = "apb1_i2c0", "apb1_i2c1",
+				"apb1_i2c2", "apb1_can", "apb1_scr",
+				"apb1_ps20", "apb1_ps21", "apb1_uart0",
+				"apb1_uart1", "apb1_uart2", "apb1_uart3",
+				"apb1_uart4", "apb1_uart5", "apb1_uart6",
+				"apb1_uart7";
+		};
+	};
+
+	soc@01c20000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x01c20000 0x300000>;
+		ranges;
+
+		emac: ethernet@01c0b000 {
+			compatible = "allwinner,sun4i-emac";
+			reg = <0x01c0b000 0x1000>;
+			interrupts = <55>;
+			clocks = <&ahb_gates 17>;
+			status = "disabled";
+		};
+
+		mdio@01c0b080 {
+			compatible = "allwinner,sun4i-mdio";
+			reg = <0x01c0b080 0x14>;
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		intc: interrupt-controller@01c20400 {
+			compatible = "allwinner,sun4i-ic";
+			reg = <0x01c20400 0x400>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+		};
+
+		pio: pinctrl@01c20800 {
+			compatible = "allwinner,sun5i-a10s-pinctrl";
+			reg = <0x01c20800 0x400>;
+			interrupts = <28>;
+			clocks = <&apb0_gates 5>;
+			gpio-controller;
+			interrupt-controller;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#gpio-cells = <3>;
+
+			uart0_pins_a: uart0@0 {
+				allwinner,pins = "PB19", "PB20";
+				allwinner,function = "uart0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			uart2_pins_a: uart2@0 {
+				allwinner,pins = "PC18", "PC19";
+				allwinner,function = "uart2";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			uart3_pins_a: uart3@0 {
+				allwinner,pins = "PG9", "PG10";
+				allwinner,function = "uart3";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			emac_pins_a: emac0@0 {
+				allwinner,pins = "PA0", "PA1", "PA2",
+						"PA3", "PA4", "PA5", "PA6",
+						"PA7", "PA8", "PA9", "PA10",
+						"PA11", "PA12", "PA13", "PA14",
+						"PA15", "PA16";
+				allwinner,function = "emac";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+		};
+
+		timer@01c20c00 {
+			compatible = "allwinner,sun4i-timer";
+			reg = <0x01c20c00 0x90>;
+			interrupts = <22>;
+			clocks = <&osc24M>;
+		};
+
+		wdt: watchdog@01c20c90 {
+			compatible = "allwinner,sun4i-wdt";
+			reg = <0x01c20c90 0x10>;
+		};
+
+		uart0: serial@01c28000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28000 0x400>;
+			interrupts = <1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&apb1_gates 16>;
+			status = "disabled";
+		};
+
+		uart1: serial@01c28400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28400 0x400>;
+			interrupts = <2>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&apb1_gates 17>;
+			status = "disabled";
+		};
+
+		uart2: serial@01c28800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28800 0x400>;
+			interrupts = <3>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&apb1_gates 18>;
+			status = "disabled";
+		};
+
+		uart3: serial@01c28c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28c00 0x400>;
+			interrupts = <4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&apb1_gates 19>;
+			status = "disabled";
+		};
+	};
+};
-- 
1.8.3

