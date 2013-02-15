Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935570Ab3BOIot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:44:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16363 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3BOIor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:44:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 15 Feb 2013 00:44:44 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v3 2/6] ARM: tegra20: convert device tree files to use CLK defines
Date: Fri, 15 Feb 2013 10:43:13 +0200
Message-ID: <1360917814-27236-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace magic number in tegra_car:

-               clocks = <&tegra_car 28>;
+               clocks = <&tegra_car CLK_HOST1X>;

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 .../bindings/clock/nvidia,tegra20-car.txt          |  150 +-------------------
 arch/arm/boot/dts/tegra20-paz00.dtsp               |    2 +-
 arch/arm/boot/dts/tegra20.dtsip                    |   85 +++++------
 3 files changed, 45 insertions(+), 192 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
index 0921fac..18eda44 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
@@ -14,154 +14,6 @@ Required properties :
 - #clock-cells : Should be 1.
   In clock consumers, this cell represents the clock ID exposed by the CAR.
 
-  The first 96 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
-  registers. These IDs often match those in the CAR's RST_DEVICES registers,
-  but not in all cases. Some bits in CLK_OUT_ENB affect multiple clocks. In
-  this case, those clocks are assigned IDs above 95 in order to highlight
-  this issue. Implementations that interpret these clock IDs as bit values
-  within the CLK_OUT_ENB or RST_DEVICES registers should be careful to
-  explicitly handle these special cases.
-
-  The balance of the clocks controlled by the CAR are assigned IDs of 96 and
-  above.
-
-  0	cpu
-  1	unassigned
-  2	unassigned
-  3	ac97
-  4	rtc
-  5	tmr
-  6	uart1
-  7	unassigned	(register bit affects uart2 and vfir)
-  8	gpio
-  9	sdmmc2
-  10	unassigned	(register bit affects spdif_in and spdif_out)
-  11	i2s1
-  12	i2c1
-  13	ndflash
-  14	sdmmc1
-  15	sdmmc4
-  16	twc
-  17	pwm
-  18	i2s2
-  19	epp
-  20	unassigned	(register bit affects vi and vi_sensor)
-  21	2d
-  22	usbd
-  23	isp
-  24	3d
-  25	ide
-  26	disp2
-  27	disp1
-  28	host1x
-  29	vcp
-  30	unassigned
-  31	cache2
-
-  32	mem
-  33	ahbdma
-  34	apbdma
-  35	unassigned
-  36	kbc
-  37	stat_mon
-  38	pmc
-  39	fuse
-  40	kfuse
-  41	sbc1
-  42	snor
-  43	spi1
-  44	sbc2
-  45	xio
-  46	sbc3
-  47	dvc
-  48	dsi
-  49	unassigned	(register bit affects tvo and cve)
-  50	mipi
-  51	hdmi
-  52	csi
-  53	tvdac
-  54	i2c2
-  55	uart3
-  56	unassigned
-  57	emc
-  58	usb2
-  59	usb3
-  60	mpe
-  61	vde
-  62	bsea
-  63	bsev
-
-  64	speedo
-  65	uart4
-  66	uart5
-  67	i2c3
-  68	sbc4
-  69	sdmmc3
-  70	pcie
-  71	owr
-  72	afi
-  73	csite
-  74	unassigned
-  75	avpucq
-  76	la
-  77	unassigned
-  78	unassigned
-  79	unassigned
-  80	unassigned
-  81	unassigned
-  82	unassigned
-  83	unassigned
-  84	irama
-  85	iramb
-  86	iramc
-  87	iramd
-  88	cram2
-  89	audio_2x	a/k/a audio_2x_sync_clk
-  90	clk_d
-  91	unassigned
-  92	sus
-  93	cdev1
-  94	cdev2
-  95	unassigned
-
-  96	uart2
-  97	vfir
-  98	spdif_in
-  99	spdif_out
-  100	vi
-  101	vi_sensor
-  102	tvo
-  103	cve
-  104	osc
-  105	clk_32k		a/k/a clk_s
-  106	clk_m
-  107	sclk
-  108	cclk
-  109	hclk
-  110	pclk
-  111	blink
-  112	pll_a
-  113	pll_a_out0
-  114	pll_c
-  115	pll_c_out1
-  116	pll_d
-  117	pll_d_out0
-  118	pll_e
-  119	pll_m
-  120	pll_m_out1
-  121	pll_p
-  122	pll_p_out1
-  123	pll_p_out2
-  124	pll_p_out3
-  125	pll_p_out4
-  126	pll_s
-  127	pll_u
-  128	pll_x
-  129	cop		a/k/a avp
-  130	audio		a/k/a audio_sync_clk
-  131	pll_ref
-  132	twd
-
 Example SoC include file:
 
 / {
@@ -172,7 +24,7 @@ Example SoC include file:
 	};
 
 	usb@c5004000 {
-		clocks = <&tegra_car 58>; /* usb2 */
+		clocks = <&tegra_car TEGRA20_CLK_USB2>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/tegra20-paz00.dtsp b/arch/arm/boot/dts/tegra20-paz00.dtsp
index e63473b..3aa9f7a 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dtsp
+++ b/arch/arm/boot/dts/tegra20-paz00.dtsp
@@ -277,7 +277,7 @@
 		clock-frequency = <80000>;
 		request-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
 		slave-addr = <138>;
-		clocks = <&tegra_car 67>, <&tegra_car 124>;
+		clocks = <&tegra_car TEGRA20_CLK_I2C3>, <&tegra_car TEGRA20_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 	};
 
diff --git a/arch/arm/boot/dts/tegra20.dtsip b/arch/arm/boot/dts/tegra20.dtsip
index 7b05f53..db118ec 100644
--- a/arch/arm/boot/dts/tegra20.dtsip
+++ b/arch/arm/boot/dts/tegra20.dtsip
@@ -1,6 +1,7 @@
 #include "skeleton.dtsi"
 #include "tegra-gpio.h"
 #include "arm-gic.h"
+#include "tegra20-car.h"
 
 / {
 	compatible = "nvidia,tegra20";
@@ -19,7 +20,7 @@
 		reg = <0x50000000 0x00024000>;
 		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>, /* syncpt */
 			     <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>; /* general */
-		clocks = <&tegra_car 28>;
+		clocks = <&tegra_car TEGRA20_CLK_HOST1X>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -30,48 +31,48 @@
 			compatible = "nvidia,tegra20-mpe";
 			reg = <0x54040000 0x00040000>;
 			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 60>;
+			clocks = <&tegra_car TEGRA20_CLK_MPE>;
 		};
 
 		vi {
 			compatible = "nvidia,tegra20-vi";
 			reg = <0x54080000 0x00040000>;
 			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 100>;
+			clocks = <&tegra_car TEGRA20_CLK_VI>;
 		};
 
 		epp {
 			compatible = "nvidia,tegra20-epp";
 			reg = <0x540c0000 0x00040000>;
 			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 19>;
+			clocks = <&tegra_car TEGRA20_CLK_EPP>;
 		};
 
 		isp {
 			compatible = "nvidia,tegra20-isp";
 			reg = <0x54100000 0x00040000>;
 			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 23>;
+			clocks = <&tegra_car TEGRA20_CLK_ISP>;
 		};
 
 		gr2d {
 			compatible = "nvidia,tegra20-gr2d";
 			reg = <0x54140000 0x00040000>;
 			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 21>;
+			clocks = <&tegra_car TEGRA20_CLK_GR2D>;
 		};
 
 		gr3d {
 			compatible = "nvidia,tegra20-gr3d";
 			reg = <0x54180000 0x00040000>;
-			clocks = <&tegra_car 24>;
+			clocks = <&tegra_car TEGRA20_CLK_GR3D>;
 		};
 
 		dc@54200000 {
 			compatible = "nvidia,tegra20-dc";
 			reg = <0x54200000 0x00040000>;
 			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 27>, <&tegra_car 121>;
+			clocks = <&tegra_car TEGRA20_CLK_DISP1>, <&tegra_car TEGRA20_CLK_PLL_P>;
 			clock-names = "disp1", "parent";
 
 			rgb {
@@ -83,7 +84,7 @@
 			compatible = "nvidia,tegra20-dc";
 			reg = <0x54240000 0x00040000>;
 			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 26>, <&tegra_car 121>;
+			clocks = <&tegra_car TEGRA20_CLK_DISP2>, <&tegra_car TEGRA20_CLK_PLL_P>;
 			clock-names = "disp2", "parent";
 
 			rgb {
@@ -95,7 +96,7 @@
 			compatible = "nvidia,tegra20-hdmi";
 			reg = <0x54280000 0x00040000>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 51>, <&tegra_car 117>;
+			clocks = <&tegra_car TEGRA20_CLK_HDMI>, <&tegra_car TEGRA20_CLK_PLL_D_OUT0>;
 			clock-names = "hdmi", "parent";
 			status = "disabled";
 		};
@@ -104,14 +105,14 @@
 			compatible = "nvidia,tegra20-tvo";
 			reg = <0x542c0000 0x00040000>;
 			interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 102>;
+			clocks = <&tegra_car TEGRA20_CLK_TVO>;
 			status = "disabled";
 		};
 
 		dsi {
 			compatible = "nvidia,tegra20-dsi";
 			reg = <0x54300000 0x00040000>;
-			clocks = <&tegra_car 48>;
+			clocks = <&tegra_car TEGRA20_CLK_DSI>;
 			status = "disabled";
 		};
 	};
@@ -174,7 +175,7 @@
 			     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 34>;
+		clocks = <&tegra_car TEGRA20_CLK_APBDMA>;
 	};
 
 	ahb {
@@ -216,7 +217,7 @@
 		reg = <0x70002000 0x200>;
 		interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 12>;
-		clocks = <&tegra_car 3>;
+		clocks = <&tegra_car TEGRA20_CLK_AC97>;
 		status = "disabled";
 	};
 
@@ -225,7 +226,7 @@
 		reg = <0x70002800 0x200>;
 		interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 2>;
-		clocks = <&tegra_car 11>;
+		clocks = <&tegra_car TEGRA20_CLK_I2S1>;
 		status = "disabled";
 	};
 
@@ -234,7 +235,7 @@
 		reg = <0x70002a00 0x200>;
 		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 1>;
-		clocks = <&tegra_car 18>;
+		clocks = <&tegra_car TEGRA20_CLK_I2S2>;
 		status = "disabled";
 	};
 
@@ -252,7 +253,7 @@
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <216000000>;
 		nvidia,dma-request-selector = <&apbdma 8>;
-		clocks = <&tegra_car 6>;
+		clocks = <&tegra_car TEGRA20_CLK_UARTA>;
 		status = "disabled";
 	};
 
@@ -263,7 +264,7 @@
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <216000000>;
 		nvidia,dma-request-selector = <&apbdma 9>;
-		clocks = <&tegra_car 96>;
+		clocks = <&tegra_car TEGRA20_CLK_UARTB>;
 		status = "disabled";
 	};
 
@@ -274,7 +275,7 @@
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <216000000>;
 		nvidia,dma-request-selector = <&apbdma 10>;
-		clocks = <&tegra_car 55>;
+		clocks = <&tegra_car TEGRA20_CLK_UARTC>;
 		status = "disabled";
 	};
 
@@ -285,7 +286,7 @@
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <216000000>;
 		nvidia,dma-request-selector = <&apbdma 19>;
-		clocks = <&tegra_car 65>;
+		clocks = <&tegra_car TEGRA20_CLK_UARTD>;
 		status = "disabled";
 	};
 
@@ -296,7 +297,7 @@
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <216000000>;
 		nvidia,dma-request-selector = <&apbdma 20>;
-		clocks = <&tegra_car 66>;
+		clocks = <&tegra_car TEGRA20_CLK_UARTE>;
 		status = "disabled";
 	};
 
@@ -304,7 +305,7 @@
 		compatible = "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
-		clocks = <&tegra_car 17>;
+		clocks = <&tegra_car TEGRA20_CLK_PWM>;
 	};
 
 	rtc {
@@ -319,7 +320,7 @@
 		interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 12>, <&tegra_car 124>;
+		clocks = <&tegra_car TEGRA20_CLK_I2C1>, <&tegra_car TEGRA20_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -331,7 +332,7 @@
 		nvidia,dma-request-selector = <&apbdma 11>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 43>;
+		clocks = <&tegra_car TEGRA20_CLK_SPI>;
 		status = "disabled";
 	};
 
@@ -341,7 +342,7 @@
 		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 54>, <&tegra_car 124>;
+		clocks = <&tegra_car TEGRA20_CLK_I2C2>, <&tegra_car TEGRA20_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -352,7 +353,7 @@
 		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 67>, <&tegra_car 124>;
+		clocks = <&tegra_car TEGRA20_CLK_I2C3>, <&tegra_car TEGRA20_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -363,7 +364,7 @@
 		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 47>, <&tegra_car 124>;
+		clocks = <&tegra_car TEGRA20_CLK_DVC>, <&tegra_car TEGRA20_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -375,7 +376,7 @@
 		nvidia,dma-request-selector = <&apbdma 15>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 41>;
+		clocks = <&tegra_car TEGRA20_CLK_SBC1>;
 		status = "disabled";
 	};
 
@@ -386,7 +387,7 @@
 		nvidia,dma-request-selector = <&apbdma 16>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 44>;
+		clocks = <&tegra_car TEGRA20_CLK_SBC2>;
 		status = "disabled";
 	};
 
@@ -397,7 +398,7 @@
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 46>;
+		clocks = <&tegra_car TEGRA20_CLK_SBC3>;
 		status = "disabled";
 	};
 
@@ -408,7 +409,7 @@
 		nvidia,dma-request-selector = <&apbdma 18>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 68>;
+		clocks = <&tegra_car TEGRA20_CLK_SBC4>;
 		status = "disabled";
 	};
 
@@ -416,7 +417,7 @@
 		compatible = "nvidia,tegra20-kbc";
 		reg = <0x7000e200 0x100>;
 		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 36>;
+		clocks = <&tegra_car TEGRA20_CLK_KBC>;
 		status = "disabled";
 	};
 
@@ -451,7 +452,7 @@
 		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
 		phy_type = "utmi";
 		nvidia,has-legacy-mode;
-		clocks = <&tegra_car 22>;
+		clocks = <&tegra_car TEGRA20_CLK_USBD>;
 		nvidia,needs-double-reset;
 		nvidia,phy = <&phy1>;
 		status = "disabled";
@@ -462,7 +463,7 @@
 		reg = <0xc5000400 0x3c00>;
 		phy_type = "utmi";
 		nvidia,has-legacy-mode;
-		clocks = <&tegra_car 22>, <&tegra_car 127>;
+		clocks = <&tegra_car TEGRA20_CLK_USBD>, <&tegra_car TEGRA20_CLK_PLL_U>;
 		clock-names = "phy", "pll_u";
 	};
 
@@ -471,7 +472,7 @@
 		reg = <0xc5004000 0x4000>;
 		interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
 		phy_type = "ulpi";
-		clocks = <&tegra_car 58>;
+		clocks = <&tegra_car TEGRA20_CLK_USB2>;
 		nvidia,phy = <&phy2>;
 		status = "disabled";
 	};
@@ -480,7 +481,7 @@
 		compatible = "nvidia,tegra20-usb-phy";
 		reg = <0xc5004400 0x3c00>;
 		phy_type = "ulpi";
-		clocks = <&tegra_car 94>, <&tegra_car 127>;
+		clocks = <&tegra_car TEGRA20_CLK_CDEV2>, <&tegra_car TEGRA20_CLK_PLL_U>;
 		clock-names = "phy", "pll_u";
 	};
 
@@ -489,7 +490,7 @@
 		reg = <0xc5008000 0x4000>;
 		interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 		phy_type = "utmi";
-		clocks = <&tegra_car 59>;
+		clocks = <&tegra_car TEGRA20_CLK_USB3>;
 		nvidia,phy = <&phy3>;
 		status = "disabled";
 	};
@@ -498,7 +499,7 @@
 		compatible = "nvidia,tegra20-usb-phy";
 		reg = <0xc5008400 0x3c00>;
 		phy_type = "utmi";
-		clocks = <&tegra_car 22>, <&tegra_car 127>;
+		clocks = <&tegra_car TEGRA20_CLK_USBD>, <&tegra_car TEGRA20_CLK_PLL_U>;
 		clock-names = "phy", "pll_u";
 	};
 
@@ -506,7 +507,7 @@
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000000 0x200>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 14>;
+		clocks = <&tegra_car TEGRA20_CLK_SDMMC1>;
 		status = "disabled";
 	};
 
@@ -514,7 +515,7 @@
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000200 0x200>;
 		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 9>;
+		clocks = <&tegra_car TEGRA20_CLK_SDMMC2>;
 		status = "disabled";
 	};
 
@@ -522,7 +523,7 @@
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000400 0x200>;
 		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 69>;
+		clocks = <&tegra_car TEGRA20_CLK_SDMMC3>;
 		status = "disabled";
 	};
 
@@ -530,7 +531,7 @@
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000600 0x200>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 15>;
+		clocks = <&tegra_car TEGRA20_CLK_SDMMC4>;
 		status = "disabled";
 	};
 
-- 
1.7.9.5

