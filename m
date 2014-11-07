Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaKGUKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:10:20 -0500
Received: from 18.mo4.mail-out.ovh.net ([188.165.54.143]:60338 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbaKGUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:10:18 -0500
X-Greylist: delayed 14997 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 15:10:17 EST
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] ARM: dts: rockchip: add pinctrl nodes for SPDIF, LCDC, CIF, HDMI, USB and GPS
Date: Fri,  7 Nov 2014 16:19:49 +0100
Message-Id: <1415373589-11650-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 16369740221320790241
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On RK3066, add pinctrl nodes for SPDIF, LCDC1, CIF0/1, HDMI and USB.
On RK3188, add pinctrl nodes for SPDIF, LCDC1, CIF and GPS.
At the same time, add some missing pinctrl for SDMMC0 and SDMMC1
and fix the unit addresses of GPIO0 and GPIO1 banks in rk3188.dtsi.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 arch/arm/boot/dts/rk3066a.dtsi | 198 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/rk3188.dtsi  | 148 +++++++++++++++++++++++++++++-
 2 files changed, 344 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index 0e99470..899b5ef 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -430,6 +430,14 @@
 						<RK_GPIO3 12 RK_FUNC_1 &pcfg_pull_default>,
 						<RK_GPIO3 13 RK_FUNC_1 &pcfg_pull_default>;
 			};
+
+			sd0_rst: sd0-rst {
+				rockchip,pins = <RK_GPIO3 6 RK_FUNC_1 &pcfg_pull_default>;
+			};
+
+			sd0_pwr: sd0-pwr {
+				rockchip,pins = <RK_GPIO3 7 RK_FUNC_1 &pcfg_pull_default>;
+			};
 		};
 
 		sd1 {
@@ -459,6 +467,18 @@
 						<RK_GPIO3 19 RK_FUNC_1 &pcfg_pull_default>,
 						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_default>;
 			};
+
+			sd1_pwr: sd1-pwr {
+				rockchip,pins = <RK_GPIO3 24 RK_FUNC_1 &pcfg_pull_default>;
+			};
+
+			sd1_bckpwr: sd1-bckpwr {
+				rockchip,pins = <RK_GPIO3 25 RK_FUNC_1 &pcfg_pull_default>;
+			};
+
+			sd1_int: sd1-int {
+				rockchip,pins = <RK_GPIO3 26 RK_FUNC_1 &pcfg_pull_default>;
+			};
 		};
 
 		i2s0 {
@@ -496,6 +516,184 @@
 						<RK_GPIO0 29 RK_FUNC_1 &pcfg_pull_default>;
 			};
 		};
+
+		spdif {
+			spdif_tx: spdif-tx {
+				rockchip,pins = <RK_GPIO1 10 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
+
+		usb {
+			otg_drv_vbus: otg-drv-vbus {
+				rockchip,pins = <RK_GPIO0 5 RK_FUNC_1 &pcfg_pull_none>;
+			};
+
+			host_drv_vbus: host-drv-vbus {
+				rockchip,pins = <RK_GPIO0 6 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
+
+		/* No IOMUX for LCDC0 */
+
+		lcdc1 {
+			lcdc1_clk: lcdc1-clk {
+				rockchip,pins = <RK_GPIO2 24 RK_FUNC_1 &pcfg_pull_none>, /* lcd1_dclk  */
+						<RK_GPIO2 25 RK_FUNC_1 &pcfg_pull_none>, /* lcd1_den   */
+						<RK_GPIO2 26 RK_FUNC_1 &pcfg_pull_none>, /* lcd1_hsync */
+						<RK_GPIO2 27 RK_FUNC_1 &pcfg_pull_none>; /* lcd1_vsync */
+			};
+
+			lcdc1_rgb565: lcdc1-rgb565 {
+				rockchip,pins = <RK_GPIO2 0 RK_FUNC_1 &pcfg_pull_none>,  /*  D0 = B0 */
+						<RK_GPIO2 1 RK_FUNC_1 &pcfg_pull_none>,  /*  D1 = B1 */
+						<RK_GPIO2 2 RK_FUNC_1 &pcfg_pull_none>,  /*  D2 = B2 */
+						<RK_GPIO2 3 RK_FUNC_1 &pcfg_pull_none>,  /*  D3 = B3 */
+						<RK_GPIO2 4 RK_FUNC_1 &pcfg_pull_none>,  /*  D4 = B4 */
+						<RK_GPIO2 5 RK_FUNC_1 &pcfg_pull_none>,  /*  D5 = G0 */
+						<RK_GPIO2 6 RK_FUNC_1 &pcfg_pull_none>,  /*  D6 = G1 */
+						<RK_GPIO2 7 RK_FUNC_1 &pcfg_pull_none>,  /*  D7 = G2 */
+						<RK_GPIO2 8 RK_FUNC_1 &pcfg_pull_none>,  /*  D8 = G3 */
+						<RK_GPIO2 9 RK_FUNC_1 &pcfg_pull_none>,  /*  D9 = G4 */
+						<RK_GPIO2 10 RK_FUNC_1 &pcfg_pull_none>, /* D10 = G5 */
+						<RK_GPIO2 11 RK_FUNC_1 &pcfg_pull_none>, /* D11 = R0 */
+						<RK_GPIO2 12 RK_FUNC_1 &pcfg_pull_none>, /* D12 = R1 */
+						<RK_GPIO2 13 RK_FUNC_1 &pcfg_pull_none>, /* D13 = R2 */
+						<RK_GPIO2 14 RK_FUNC_1 &pcfg_pull_none>, /* D14 = R3 */
+						<RK_GPIO2 15 RK_FUNC_1 &pcfg_pull_none>; /* D15 = R4 */
+			};
+
+			lcdc1_rgb666: lcdc1-rgb666 {
+				rockchip,pins = <RK_GPIO2 0 RK_FUNC_1 &pcfg_pull_none>,  /*  D0 = B0 */
+						<RK_GPIO2 1 RK_FUNC_1 &pcfg_pull_none>,  /*  D1 = B1 */
+						<RK_GPIO2 2 RK_FUNC_1 &pcfg_pull_none>,  /*  D2 = B2 */
+						<RK_GPIO2 3 RK_FUNC_1 &pcfg_pull_none>,  /*  D3 = B3 */
+						<RK_GPIO2 4 RK_FUNC_1 &pcfg_pull_none>,  /*  D4 = B4 */
+						<RK_GPIO2 5 RK_FUNC_1 &pcfg_pull_none>,  /*  D5 = B5 */
+						<RK_GPIO2 6 RK_FUNC_1 &pcfg_pull_none>,  /*  D6 = G0 */
+						<RK_GPIO2 7 RK_FUNC_1 &pcfg_pull_none>,  /*  D7 = G1 */
+						<RK_GPIO2 8 RK_FUNC_1 &pcfg_pull_none>,  /*  D8 = G2 */
+						<RK_GPIO2 9 RK_FUNC_1 &pcfg_pull_none>,  /*  D9 = G3 */
+						<RK_GPIO2 10 RK_FUNC_1 &pcfg_pull_none>, /* D10 = G4 */
+						<RK_GPIO2 11 RK_FUNC_1 &pcfg_pull_none>, /* D11 = G5 */
+						<RK_GPIO2 12 RK_FUNC_1 &pcfg_pull_none>, /* D12 = R0 */
+						<RK_GPIO2 13 RK_FUNC_1 &pcfg_pull_none>, /* D13 = R1 */
+						<RK_GPIO2 14 RK_FUNC_1 &pcfg_pull_none>, /* D14 = R2 */
+						<RK_GPIO2 15 RK_FUNC_1 &pcfg_pull_none>, /* D15 = R3 */
+						<RK_GPIO2 16 RK_FUNC_1 &pcfg_pull_none>, /* D16 = R4 */
+						<RK_GPIO2 17 RK_FUNC_1 &pcfg_pull_none>; /* D17 = R5 */
+			};
+
+			lcdc1_rgb888: lcdc1-rgb888 {
+				rockchip,pins = <RK_GPIO2 0 RK_FUNC_1 &pcfg_pull_none>,  /*  D0 = B0 */
+						<RK_GPIO2 1 RK_FUNC_1 &pcfg_pull_none>,  /*  D1 = B1 */
+						<RK_GPIO2 2 RK_FUNC_1 &pcfg_pull_none>,  /*  D2 = B2 */
+						<RK_GPIO2 3 RK_FUNC_1 &pcfg_pull_none>,  /*  D3 = B3 */
+						<RK_GPIO2 4 RK_FUNC_1 &pcfg_pull_none>,  /*  D4 = B4 */
+						<RK_GPIO2 5 RK_FUNC_1 &pcfg_pull_none>,  /*  D5 = B5 */
+						<RK_GPIO2 6 RK_FUNC_1 &pcfg_pull_none>,  /*  D6 = B6 */
+						<RK_GPIO2 7 RK_FUNC_1 &pcfg_pull_none>,  /*  D7 = B7 */
+						<RK_GPIO2 8 RK_FUNC_1 &pcfg_pull_none>,  /*  D8 = G0 */
+						<RK_GPIO2 9 RK_FUNC_1 &pcfg_pull_none>,  /*  D9 = G1 */
+						<RK_GPIO2 10 RK_FUNC_1 &pcfg_pull_none>, /* D10 = G2 */
+						<RK_GPIO2 11 RK_FUNC_1 &pcfg_pull_none>, /* D11 = G3 */
+						<RK_GPIO2 12 RK_FUNC_1 &pcfg_pull_none>, /* D12 = G4 */
+						<RK_GPIO2 13 RK_FUNC_1 &pcfg_pull_none>, /* D13 = G5 */
+						<RK_GPIO2 14 RK_FUNC_1 &pcfg_pull_none>, /* D14 = G6 */
+						<RK_GPIO2 15 RK_FUNC_1 &pcfg_pull_none>, /* D15 = G7 */
+						<RK_GPIO2 16 RK_FUNC_1 &pcfg_pull_none>, /* D16 = R0 */
+						<RK_GPIO2 17 RK_FUNC_1 &pcfg_pull_none>, /* D17 = R1 */
+						<RK_GPIO2 18 RK_FUNC_1 &pcfg_pull_none>, /* D18 = R2 */
+						<RK_GPIO2 19 RK_FUNC_1 &pcfg_pull_none>, /* D19 = R3 */
+						<RK_GPIO2 20 RK_FUNC_1 &pcfg_pull_none>, /* D20 = R4 */
+						<RK_GPIO2 21 RK_FUNC_1 &pcfg_pull_none>, /* D21 = R5 */
+						<RK_GPIO2 22 RK_FUNC_1 &pcfg_pull_none>, /* D22 = R6 */
+						<RK_GPIO2 23 RK_FUNC_1 &pcfg_pull_none>; /* D23 = R7 */
+			};
+		};
+
+		cif0 {
+			/* No IOMUX for CIF0 clock in, vsync and href */
+
+			cif0_clk_out: cif0-clk-out {
+				rockchip,pins = <RK_GPIO1 11 RK_FUNC_1 &pcfg_pull_none>; /* cif0_clkout */
+			};
+
+			/* No IOMUX for CIF0 data pins 2-9 (width 8) */
+
+			cif0_bus10: cif0-bus-width10 {
+				rockchip,pins = <RK_GPIO1 12 RK_FUNC_1 &pcfg_pull_none>, /* cif0_d0 */
+						<RK_GPIO1 13 RK_FUNC_1 &pcfg_pull_none>; /* cif0_d1 */
+			};
+
+			cif0_bus12: cif0-bus-width12 {
+				rockchip,pins = <RK_GPIO1 12 RK_FUNC_1 &pcfg_pull_none>, /* cif0_d0 */
+						<RK_GPIO1 13 RK_FUNC_1 &pcfg_pull_none>, /* cif0_d1 */
+						<RK_GPIO1 14 RK_FUNC_1 &pcfg_pull_none>, /* cif0_d10 */
+						<RK_GPIO1 15 RK_FUNC_1 &pcfg_pull_none>; /* cif0_d11 */
+			};
+		};
+
+		cif1 {
+			cif1_clk_in: cif1-clk-in {
+				rockchip,pins = <RK_GPIO1 24 RK_FUNC_1 &pcfg_pull_none>, /* cif1_vsync */
+						<RK_GPIO1 25 RK_FUNC_1 &pcfg_pull_none>, /* cif1_href */
+						<RK_GPIO1 26 RK_FUNC_1 &pcfg_pull_none>; /* cif1_clkin */
+			};
+
+			cif1_clk_out: cif1-clk-out {
+				rockchip,pins = <RK_GPIO1 31 RK_FUNC_1 &pcfg_pull_none>; /* cif1_clkout */
+			};
+
+			cif1_bus8: cif1-bus-width8 {
+				rockchip,pins = <RK_GPIO1 16 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d2 */
+						<RK_GPIO1 17 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d3 */
+						<RK_GPIO1 18 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d4 */
+						<RK_GPIO1 19 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d5 */
+						<RK_GPIO1 20 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d6 */
+						<RK_GPIO1 21 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d7 */
+						<RK_GPIO1 22 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d8 */
+						<RK_GPIO1 23 RK_FUNC_1 &pcfg_pull_none>; /* cif1_d9 */
+			};
+
+			cif1_bus10: cif1-bus-width10 {
+				rockchip,pins = <RK_GPIO1 27 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d0 */
+						<RK_GPIO1 28 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d1 */
+						<RK_GPIO1 16 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d2 */
+						<RK_GPIO1 17 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d3 */
+						<RK_GPIO1 18 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d4 */
+						<RK_GPIO1 19 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d5 */
+						<RK_GPIO1 20 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d6 */
+						<RK_GPIO1 21 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d7 */
+						<RK_GPIO1 22 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d8 */
+						<RK_GPIO1 23 RK_FUNC_1 &pcfg_pull_none>; /* cif1_d9 */
+			};
+
+			cif1_bus12: cif1-bus-width12 {
+				rockchip,pins = <RK_GPIO1 27 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d0 */
+						<RK_GPIO1 28 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d1 */
+						<RK_GPIO1 16 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d2 */
+						<RK_GPIO1 17 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d3 */
+						<RK_GPIO1 18 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d4 */
+						<RK_GPIO1 19 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d5 */
+						<RK_GPIO1 20 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d6 */
+						<RK_GPIO1 21 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d7 */
+						<RK_GPIO1 22 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d8 */
+						<RK_GPIO1 23 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d9 */
+						<RK_GPIO1 29 RK_FUNC_1 &pcfg_pull_none>, /* cif1_d10 */
+						<RK_GPIO1 30 RK_FUNC_1 &pcfg_pull_none>; /* cif1_d11 */
+			};
+		};
+
+		hdmi {
+			hdmi_hpd {
+				rockchip,pins = <RK_GPIO0 0 RK_FUNC_1 &pcfg_pull_none>; /* hot plug in */
+			};
+
+			hdmi_i2c {
+				rockchip,pins = <RK_GPIO0 1 RK_FUNC_1 &pcfg_pull_none>, /* DDC SCL */
+						<RK_GPIO0 2 RK_FUNC_1 &pcfg_pull_none>; /* DDC SDA */
+			};
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index b24e04f..fb05d76 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -111,7 +111,7 @@
 		#size-cells = <1>;
 		ranges;
 
-		gpio0: gpio0@0x2000a000 {
+		gpio0: gpio0@2000a000 {
 			compatible = "rockchip,rk3188-gpio-bank0";
 			reg = <0x2000a000 0x100>;
 			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
@@ -124,7 +124,7 @@
 			#interrupt-cells = <2>;
 		};
 
-		gpio1: gpio1@0x2003c000 {
+		gpio1: gpio1@2003c000 {
 			compatible = "rockchip,gpio-bank";
 			reg = <0x2003c000 0x100>;
 			interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
@@ -379,6 +379,10 @@
 				rockchip,pins = <RK_GPIO3 9 RK_FUNC_1 &pcfg_pull_none>;
 			};
 
+			sd0_rst: sd0-rst {
+				rockchip,pins = <RK_GPIO3 0 RK_FUNC_1 &pcfg_pull_none>;
+			};
+
 			sd0_pwr: sd0-pwr {
 				rockchip,pins = <RK_GPIO3 1 RK_FUNC_1 &pcfg_pull_none>;
 			};
@@ -412,6 +416,18 @@
 				rockchip,pins = <RK_GPIO3 23 RK_FUNC_1 &pcfg_pull_none>;
 			};
 
+			sd1_pwr: sd1-pwr {
+				rockchip,pins = <RK_GPIO3 24 RK_FUNC_1 &pcfg_pull_none>;
+			};
+
+			sd1_bckpwr: sd1-bckpwr {
+				rockchip,pins = <RK_GPIO3 25 RK_FUNC_1 &pcfg_pull_none>;
+			};
+
+			sd1_int: sd1-int {
+				rockchip,pins = <RK_GPIO3 26 RK_FUNC_1 &pcfg_pull_none>;
+			};
+
 			sd1_bus1: sd1-bus-width1 {
 				rockchip,pins = <RK_GPIO3 17 RK_FUNC_1 &pcfg_pull_none>;
 			};
@@ -434,6 +450,134 @@
 						<RK_GPIO1 21 RK_FUNC_1 &pcfg_pull_none>;
 			};
 		};
+
+		spdif {
+			spdif_tx: spdif-tx {
+				rockchip,pins = <RK_GPIO1 14 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
+
+		/* No IOMUX for LCDC0 */
+
+		lcdc1 {
+			lcdc1_clk: lcdc1-clk {
+				rockchip,pins = <RK_GPIO2 24 RK_FUNC_1 &pcfg_pull_none>, /* lcd1_dclk  */
+						<RK_GPIO2 25 RK_FUNC_1 &pcfg_pull_none>, /* lcd1_den   */
+						<RK_GPIO2 26 RK_FUNC_1 &pcfg_pull_none>, /* lcd1_hsync */
+						<RK_GPIO2 27 RK_FUNC_1 &pcfg_pull_none>; /* lcd1_vsync */
+			};
+
+			lcdc1_rgb565: lcdc1-rgb565 {
+				rockchip,pins = <RK_GPIO2 0 RK_FUNC_1 &pcfg_pull_none>,  /*  D0 = B0 */
+						<RK_GPIO2 1 RK_FUNC_1 &pcfg_pull_none>,  /*  D1 = B1 */
+						<RK_GPIO2 2 RK_FUNC_1 &pcfg_pull_none>,  /*  D2 = B2 */
+						<RK_GPIO2 3 RK_FUNC_1 &pcfg_pull_none>,  /*  D3 = B3 */
+						<RK_GPIO2 4 RK_FUNC_1 &pcfg_pull_none>,  /*  D4 = B4 */
+						<RK_GPIO2 5 RK_FUNC_1 &pcfg_pull_none>,  /*  D5 = G0 */
+						<RK_GPIO2 6 RK_FUNC_1 &pcfg_pull_none>,  /*  D6 = G1 */
+						<RK_GPIO2 7 RK_FUNC_1 &pcfg_pull_none>,  /*  D7 = G2 */
+						<RK_GPIO2 8 RK_FUNC_1 &pcfg_pull_none>,  /*  D8 = G3 */
+						<RK_GPIO2 9 RK_FUNC_1 &pcfg_pull_none>,  /*  D9 = G4 */
+						<RK_GPIO2 10 RK_FUNC_1 &pcfg_pull_none>, /* D10 = G5 */
+						<RK_GPIO2 11 RK_FUNC_1 &pcfg_pull_none>, /* D11 = R0 */
+						<RK_GPIO2 12 RK_FUNC_1 &pcfg_pull_none>, /* D12 = R1 */
+						<RK_GPIO2 13 RK_FUNC_1 &pcfg_pull_none>, /* D13 = R2 */
+						<RK_GPIO2 14 RK_FUNC_1 &pcfg_pull_none>, /* D14 = R3 */
+						<RK_GPIO2 15 RK_FUNC_1 &pcfg_pull_none>; /* D15 = R4 */
+			};
+
+			lcdc1_rgb666: lcdc1-rgb666 {
+				rockchip,pins = <RK_GPIO2 0 RK_FUNC_1 &pcfg_pull_none>,  /*  D0 = B0 */
+						<RK_GPIO2 1 RK_FUNC_1 &pcfg_pull_none>,  /*  D1 = B1 */
+						<RK_GPIO2 2 RK_FUNC_1 &pcfg_pull_none>,  /*  D2 = B2 */
+						<RK_GPIO2 3 RK_FUNC_1 &pcfg_pull_none>,  /*  D3 = B3 */
+						<RK_GPIO2 4 RK_FUNC_1 &pcfg_pull_none>,  /*  D4 = B4 */
+						<RK_GPIO2 5 RK_FUNC_1 &pcfg_pull_none>,  /*  D5 = B5 */
+						<RK_GPIO2 6 RK_FUNC_1 &pcfg_pull_none>,  /*  D6 = G0 */
+						<RK_GPIO2 7 RK_FUNC_1 &pcfg_pull_none>,  /*  D7 = G1 */
+						<RK_GPIO2 8 RK_FUNC_1 &pcfg_pull_none>,  /*  D8 = G2 */
+						<RK_GPIO2 9 RK_FUNC_1 &pcfg_pull_none>,  /*  D9 = G3 */
+						<RK_GPIO2 10 RK_FUNC_1 &pcfg_pull_none>, /* D10 = G4 */
+						<RK_GPIO2 11 RK_FUNC_1 &pcfg_pull_none>, /* D11 = G5 */
+						<RK_GPIO2 12 RK_FUNC_1 &pcfg_pull_none>, /* D12 = R0 */
+						<RK_GPIO2 13 RK_FUNC_1 &pcfg_pull_none>, /* D13 = R1 */
+						<RK_GPIO2 14 RK_FUNC_1 &pcfg_pull_none>, /* D14 = R2 */
+						<RK_GPIO2 15 RK_FUNC_1 &pcfg_pull_none>, /* D15 = R3 */
+						<RK_GPIO2 16 RK_FUNC_1 &pcfg_pull_none>, /* D16 = R4 */
+						<RK_GPIO2 17 RK_FUNC_1 &pcfg_pull_none>; /* D17 = R5 */
+			};
+
+			lcdc1_rgb888: lcdc1-rgb888 {
+				rockchip,pins = <RK_GPIO2 0 RK_FUNC_1 &pcfg_pull_none>,  /*  D0 = B0 */
+						<RK_GPIO2 1 RK_FUNC_1 &pcfg_pull_none>,  /*  D1 = B1 */
+						<RK_GPIO2 2 RK_FUNC_1 &pcfg_pull_none>,  /*  D2 = B2 */
+						<RK_GPIO2 3 RK_FUNC_1 &pcfg_pull_none>,  /*  D3 = B3 */
+						<RK_GPIO2 4 RK_FUNC_1 &pcfg_pull_none>,  /*  D4 = B4 */
+						<RK_GPIO2 5 RK_FUNC_1 &pcfg_pull_none>,  /*  D5 = B5 */
+						<RK_GPIO2 6 RK_FUNC_1 &pcfg_pull_none>,  /*  D6 = B6 */
+						<RK_GPIO2 7 RK_FUNC_1 &pcfg_pull_none>,  /*  D7 = B7 */
+						<RK_GPIO2 8 RK_FUNC_1 &pcfg_pull_none>,  /*  D8 = G0 */
+						<RK_GPIO2 9 RK_FUNC_1 &pcfg_pull_none>,  /*  D9 = G1 */
+						<RK_GPIO2 10 RK_FUNC_1 &pcfg_pull_none>, /* D10 = G2 */
+						<RK_GPIO2 11 RK_FUNC_1 &pcfg_pull_none>, /* D11 = G3 */
+						<RK_GPIO2 12 RK_FUNC_1 &pcfg_pull_none>, /* D12 = G4 */
+						<RK_GPIO2 13 RK_FUNC_1 &pcfg_pull_none>, /* D13 = G5 */
+						<RK_GPIO2 14 RK_FUNC_1 &pcfg_pull_none>, /* D14 = G6 */
+						<RK_GPIO2 15 RK_FUNC_1 &pcfg_pull_none>, /* D15 = G7 */
+						<RK_GPIO2 16 RK_FUNC_1 &pcfg_pull_none>, /* D16 = R0 */
+						<RK_GPIO2 17 RK_FUNC_1 &pcfg_pull_none>, /* D17 = R1 */
+						<RK_GPIO2 18 RK_FUNC_1 &pcfg_pull_none>, /* D18 = R2 */
+						<RK_GPIO2 19 RK_FUNC_1 &pcfg_pull_none>, /* D19 = R3 */
+						<RK_GPIO2 20 RK_FUNC_1 &pcfg_pull_none>, /* D20 = R4 */
+						<RK_GPIO2 21 RK_FUNC_1 &pcfg_pull_none>, /* D21 = R5 */
+						<RK_GPIO2 22 RK_FUNC_1 &pcfg_pull_none>, /* D22 = R6 */
+						<RK_GPIO2 23 RK_FUNC_1 &pcfg_pull_none>; /* D23 = R7 */
+			};
+		};
+
+		cif {
+			/* CIF clock in, vsync and href are not accessible through pinctrl */
+
+			cif_clk_out: cif-clk-out {
+				rockchip,pins = <RK_GPIO3 11 RK_FUNC_1 &pcfg_pull_none>;
+			};
+
+			/* CIF data pins 2-9 (width 8) are not accessible through pinctrl */
+
+			cif_bus10: cif-bus-width10 {
+				rockchip,pins = <RK_GPIO3 12 RK_FUNC_1 &pcfg_pull_none>, /* cif_d0 */
+						<RK_GPIO3 13 RK_FUNC_1 &pcfg_pull_none>; /* cif_d1 */
+			};
+
+			cif_bus12: cif-bus-width12 {
+				rockchip,pins = <RK_GPIO3 12 RK_FUNC_1 &pcfg_pull_none>, /* cif_d0 */
+						<RK_GPIO3 13 RK_FUNC_1 &pcfg_pull_none>, /* cif_d1 */
+						<RK_GPIO3 14 RK_FUNC_1 &pcfg_pull_none>, /* cif_d10 */
+						<RK_GPIO3 15 RK_FUNC_1 &pcfg_pull_none>; /* cif_d11 */
+			};
+
+			cif_bus16: cif-bus-width16 {
+				rockchip,pins = <RK_GPIO3 12 RK_FUNC_1 &pcfg_pull_none>, /* cif_d0 */
+						<RK_GPIO3 13 RK_FUNC_1 &pcfg_pull_none>, /* cif_d1 */
+						<RK_GPIO3 14 RK_FUNC_1 &pcfg_pull_none>, /* cif_d10 */
+						<RK_GPIO3 15 RK_FUNC_1 &pcfg_pull_none>; /* cif_d11 */
+						/* No IOMUX for CIF data pins 12-15 */
+			};
+		};
+
+		gps {
+			gps_mag: gps-mag {
+				rockchip,pins = <RK_GPIO1 10 RK_FUNC_2 &pcfg_pull_none>;
+			};
+
+			gps_sig: gps-sig {
+				rockchip,pins = <RK_GPIO1 11 RK_FUNC_2 &pcfg_pull_none>;
+			};
+
+			gps_rfclk: gps-rfclk {
+				rockchip,pins = <RK_GPIO1 12 RK_FUNC_2 &pcfg_pull_none>;
+			};
+		};
 	};
 };
 
-- 
2.1.0

