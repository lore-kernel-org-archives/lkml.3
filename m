Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaIEQxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:53:20 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60022 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIEQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:53:18 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: hl@rock-chips.com, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Alexandru Stan <amstan@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Add SPI nodes to rk3288
Date: Fri,  5 Sep 2014 09:53:11 -0700
Message-Id: <1409935991-15067-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: huang lin <hl@rock-chips.com>

This adds basic SPI nodes to the base rk3288 device tree file.

A few notes:
* It's assumed that most users of the SPI ports are using chip select
  0.  Thus the default pinctrl for the ports enables chip select 0
  (but not chip select 1 on ports that have it).  If a board wants to
  use chip select 1 or wants a GPIO chip select the board should
  override the pinctrl (just like boards can override UART pinctrl if
  they have hardware flow control).
* Since SPI DMA support appears broken and the SPI works fine without
  DMA we don't include the DMA references.  That can come in a later
  change.

Signed-off-by: huang lin <hl@rock-chips.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---

 arch/arm/boot/dts/rk3288.dtsi | 92 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 5f866e0..75d1f4c 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -34,6 +34,9 @@
 		serial2 = &uart2;
 		serial3 = &uart3;
 		serial4 = &uart4;
+		spi0 = &spi0;
+		spi1 = &spi1;
+		spi2 = &spi2;
 	};
 
 	cpus {
@@ -128,6 +131,45 @@
 		status = "disabled";
 	};
 
+	spi0: spi@ff110000 {
+		compatible = "rockchip,rk3066-spi";
+		clocks = <&cru SCLK_SPI0>, <&cru PCLK_SPI0>;
+		clock-names = "spiclk", "apb_pclk";
+		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_clk &spi0_tx &spi0_rx &spi0_cs0>;
+		reg = <0xff110000 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi1: spi@ff120000 {
+		compatible = "rockchip,rk3066-spi";
+		clocks = <&cru SCLK_SPI1>, <&cru PCLK_SPI1>;
+		clock-names = "spiclk", "apb_pclk";
+		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi1_clk &spi1_tx &spi1_rx &spi1_cs0>;
+		reg = <0xff120000 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi2: spi@ff130000 {
+		compatible = "rockchip,rk3066-spi";
+		clocks = <&cru SCLK_SPI2>, <&cru PCLK_SPI2>;
+		clock-names = "spiclk", "apb_pclk";
+		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi2_clk &spi2_tx &spi2_rx &spi2_cs0>;
+		reg = <0xff130000 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
 	i2c1: i2c@ff140000 {
 		compatible = "rockchip,rk3288-i2c";
 		reg = <0xff140000 0x1000>;
@@ -700,6 +742,56 @@
 			};
 		};
 
+		spi0 {
+			spi0_clk: spi0-clk {
+				rockchip,pins = <5 12 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi0_cs0: spi0-cs0 {
+				rockchip,pins = <5 13 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi0_tx: spi0-tx {
+				rockchip,pins = <5 14 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi0_rx: spi0-rx {
+				rockchip,pins = <5 15 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi0_cs1: spi0-cs1 {
+				rockchip,pins = <5 16 RK_FUNC_1 &pcfg_pull_up>;
+			};
+		};
+		spi1 {
+			spi1_clk: spi1-clk {
+				rockchip,pins = <7 12 RK_FUNC_2 &pcfg_pull_up>;
+			};
+			spi1_cs0: spi1-cs0 {
+				rockchip,pins = <7 13 RK_FUNC_2 &pcfg_pull_up>;
+			};
+			spi1_rx: spi1-rx {
+				rockchip,pins = <7 14 RK_FUNC_2 &pcfg_pull_up>;
+			};
+			spi1_tx: spi1-tx {
+				rockchip,pins = <7 15 RK_FUNC_2 &pcfg_pull_up>;
+			};
+		};
+
+		spi2 {
+			spi2_cs1: spi2-cs1 {
+				rockchip,pins = <8 3 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi2_clk: spi2-clk {
+				rockchip,pins = <8 6 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi2_cs0: spi2-cs0 {
+				rockchip,pins = <8 7 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi2_rx: spi2-rx {
+				rockchip,pins = <8 8 RK_FUNC_1 &pcfg_pull_up>;
+			};
+			spi2_tx: spi2-tx {
+				rockchip,pins = <8 9 RK_FUNC_1 &pcfg_pull_up>;
+			};
+		};
+
 		uart0 {
 			uart0_xfer: uart0-xfer {
 				rockchip,pins = <4 16 RK_FUNC_1 &pcfg_pull_up>,
-- 
2.1.0.rc2.206.gedb03e5

