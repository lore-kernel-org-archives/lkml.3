Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935622Ab3BOIpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:45:49 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10313 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935577Ab3BOIpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:45:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Feb 2013 00:41:33 -0800
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
Subject: [v3 4/6] ARM: tegra30: convert device tree files to use CLK defines
Date: Fri, 15 Feb 2013 10:43:15 +0200
Message-ID: <1360917814-27236-5-git-send-email-hdoyu@nvidia.com>
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
 .../bindings/clock/nvidia,tegra30-car.txt          |  207 +-------------------
 arch/arm/boot/dts/tegra30.dtsip                    |   87 ++++----
 2 files changed, 45 insertions(+), 249 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
index f3da3be..ac5797b 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
@@ -14,211 +14,6 @@ Required properties :
 - #clock-cells : Should be 1.
   In clock consumers, this cell represents the clock ID exposed by the CAR.
 
-  The first 130 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
-  registers. These IDs often match those in the CAR's RST_DEVICES registers,
-  but not in all cases. Some bits in CLK_OUT_ENB affect multiple clocks. In
-  this case, those clocks are assigned IDs above 160 in order to highlight
-  this issue. Implementations that interpret these clock IDs as bit values
-  within the CLK_OUT_ENB or RST_DEVICES registers should be careful to
-  explicitly handle these special cases.
-
-  The balance of the clocks controlled by the CAR are assigned IDs of 160 and
-  above.
-
-  0	cpu
-  1	unassigned
-  2	unassigned
-  3	unassigned
-  4	rtc
-  5	timer
-  6	uarta
-  7	unassigned	(register bit affects uartb and vfir)
-  8	gpio
-  9	sdmmc2
-  10	unassigned	(register bit affects spdif_in and spdif_out)
-  11	i2s1
-  12	i2c1
-  13	ndflash
-  14	sdmmc1
-  15	sdmmc4
-  16	unassigned
-  17	pwm
-  18	i2s2
-  19	epp
-  20	unassigned	(register bit affects vi and vi_sensor)
-  21	2d
-  22	usbd
-  23	isp
-  24	3d
-  25	unassigned
-  26	disp2
-  27	disp1
-  28	host1x
-  29	vcp
-  30	i2s0
-  31	cop_cache
-
-  32	mc
-  33	ahbdma
-  34	apbdma
-  35	unassigned
-  36	kbc
-  37	statmon
-  38	pmc
-  39	unassigned	(register bit affects fuse and fuse_burn)
-  40	kfuse
-  41	sbc1
-  42	nor
-  43	unassigned
-  44	sbc2
-  45	unassigned
-  46	sbc3
-  47	i2c5
-  48	dsia
-  49	unassigned	(register bit affects cve and tvo)
-  50	mipi
-  51	hdmi
-  52	csi
-  53	tvdac
-  54	i2c2
-  55	uartc
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
-  65	uartd
-  66	uarte
-  67	i2c3
-  68	sbc4
-  69	sdmmc3
-  70	pcie
-  71	owr
-  72	afi
-  73	csite
-  74	pciex
-  75	avpucq
-  76	la
-  77	unassigned
-  78	unassigned
-  79	dtv
-  80	ndspeed
-  81	i2cslow
-  82	dsib
-  83	unassigned
-  84	irama
-  85	iramb
-  86	iramc
-  87	iramd
-  88	cram2
-  89	unassigned
-  90	audio_2x	a/k/a audio_2x_sync_clk
-  91	unassigned
-  92	csus
-  93	cdev2
-  94	cdev1
-  95	unassigned
-
-  96	cpu_g
-  97	cpu_lp
-  98	3d2
-  99	mselect
-  100	tsensor
-  101	i2s3
-  102	i2s4
-  103	i2c4
-  104	sbc5
-  105	sbc6
-  106	d_audio
-  107	apbif
-  108	dam0
-  109	dam1
-  110	dam2
-  111	hda2codec_2x
-  112	atomics
-  113	audio0_2x
-  114	audio1_2x
-  115	audio2_2x
-  116	audio3_2x
-  117	audio4_2x
-  118	audio5_2x
-  119	actmon
-  120	extern1
-  121	extern2
-  122	extern3
-  123	sata_oob
-  124	sata
-  125	hda
-  127	se
-  128	hda2hdmi
-  129	sata_cold
-
-  160	uartb
-  161	vfir
-  162	spdif_in
-  163	spdif_out
-  164	vi
-  165	vi_sensor
-  166	fuse
-  167	fuse_burn
-  168	cve
-  169	tvo
-
-  170	clk_32k
-  171	clk_m
-  172	clk_m_div2
-  173	clk_m_div4
-  174	pll_ref
-  175	pll_c
-  176	pll_c_out1
-  177	pll_m
-  178	pll_m_out1
-  179	pll_p
-  180	pll_p_out1
-  181	pll_p_out2
-  182	pll_p_out3
-  183	pll_p_out4
-  184	pll_a
-  185	pll_a_out0
-  186	pll_d
-  187	pll_d_out0
-  188	pll_d2
-  189	pll_d2_out0
-  190	pll_u
-  191	pll_x
-  192	pll_x_out0
-  193	pll_e
-  194	spdif_in_sync
-  195	i2s0_sync
-  196	i2s1_sync
-  197	i2s2_sync
-  198	i2s3_sync
-  199	i2s4_sync
-  200	vimclk
-  201	audio0
-  202	audio1
-  203	audio2
-  204	audio3
-  205	audio4
-  206	audio5
-  207	clk_out_1 (extern1)
-  208	clk_out_2 (extern2)
-  209	clk_out_3 (extern3)
-  210	sclk
-  211	blink
-  212	cclk_g
-  213	cclk_lp
-  214	twd
-  215	cml0
-  216	cml1
-  217	hclk
-  218	pclk
-
 Example SoC include file:
 
 / {
@@ -229,7 +24,7 @@ Example SoC include file:
 	};
 
 	usb@c5004000 {
-		clocks = <&tegra_car 58>; /* usb2 */
+		clocks = <&tegra_car TEGRA30_CLK_USB2>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/tegra30.dtsip b/arch/arm/boot/dts/tegra30.dtsip
index 0148459..3c87b71 100644
--- a/arch/arm/boot/dts/tegra30.dtsip
+++ b/arch/arm/boot/dts/tegra30.dtsip
@@ -1,6 +1,7 @@
 #include "skeleton.dtsi"
 #include "tegra-gpio.h"
 #include "arm-gic.h"
+#include "tegra30-car.h"
 
 / {
 	compatible = "nvidia,tegra30";
@@ -19,7 +20,7 @@
 		reg = <0x50000000 0x00024000>;
 		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>, /* syncpt */
 			     <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>; /* general */
-		clocks = <&tegra_car 28>;
+		clocks = <&tegra_car TEGRA30_CLK_HOST1X>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -30,35 +31,35 @@
 			compatible = "nvidia,tegra30-mpe";
 			reg = <0x54040000 0x00040000>;
 			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 60>;
+			clocks = <&tegra_car TEGRA30_CLK_MPE>;
 		};
 
 		vi {
 			compatible = "nvidia,tegra30-vi";
 			reg = <0x54080000 0x00040000>;
 			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 164>;
+			clocks = <&tegra_car TEGRA30_CLK_VI>;
 		};
 
 		epp {
 			compatible = "nvidia,tegra30-epp";
 			reg = <0x540c0000 0x00040000>;
 			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 19>;
+			clocks = <&tegra_car TEGRA30_CLK_EPP>;
 		};
 
 		isp {
 			compatible = "nvidia,tegra30-isp";
 			reg = <0x54100000 0x00040000>;
 			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 23>;
+			clocks = <&tegra_car TEGRA30_CLK_ISP>;
 		};
 
 		gr2d {
 			compatible = "nvidia,tegra30-gr2d";
 			reg = <0x54140000 0x00040000>;
 			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 21>;
+			clocks = <&tegra_car TEGRA30_CLK_GR2D>;
 		};
 
 		gr3d {
@@ -72,7 +73,7 @@
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54200000 0x00040000>;
 			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 27>, <&tegra_car 179>;
+			clocks = <&tegra_car TEGRA30_CLK_DISP1>, <&tegra_car TEGRA30_CLK_PLL_P>;
 			clock-names = "disp1", "parent";
 
 			rgb {
@@ -84,7 +85,7 @@
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54240000 0x00040000>;
 			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 26>, <&tegra_car 179>;
+			clocks = <&tegra_car TEGRA30_CLK_DISP2>, <&tegra_car TEGRA30_CLK_PLL_P>;
 			clock-names = "disp2", "parent";
 
 			rgb {
@@ -96,7 +97,7 @@
 			compatible = "nvidia,tegra30-hdmi";
 			reg = <0x54280000 0x00040000>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 51>, <&tegra_car 189>;
+			clocks = <&tegra_car TEGRA30_CLK_HDMI>, <&tegra_car TEGRA30_CLK_PLL_D2_OUT0>;
 			clock-names = "hdmi", "parent";
 			status = "disabled";
 		};
@@ -105,14 +106,14 @@
 			compatible = "nvidia,tegra30-tvo";
 			reg = <0x542c0000 0x00040000>;
 			interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 169>;
+			clocks = <&tegra_car TEGRA30_CLK_TVO>;
 			status = "disabled";
 		};
 
 		dsi {
 			compatible = "nvidia,tegra30-dsi";
 			reg = <0x54300000 0x00040000>;
-			clocks = <&tegra_car 48>;
+			clocks = <&tegra_car TEGRA30_CLK_DSIA>;
 			status = "disabled";
 		};
 	};
@@ -193,7 +194,7 @@
 			     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 34>;
+		clocks = <&tegra_car TEGRA30_CLK_APBDMA>;
 	};
 
 	ahb: ahb {
@@ -239,7 +240,7 @@
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <408000000>;
 		nvidia,dma-request-selector = <&apbdma 8>;
-		clocks = <&tegra_car 6>;
+		clocks = <&tegra_car TEGRA30_CLK_UARTA>;
 		status = "disabled";
 	};
 
@@ -250,7 +251,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
-		clocks = <&tegra_car 160>;
+		clocks = <&tegra_car TEGRA30_CLK_UARTB>;
 		status = "disabled";
 	};
 
@@ -261,7 +262,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
-		clocks = <&tegra_car 55>;
+		clocks = <&tegra_car TEGRA30_CLK_UARTC>;
 		status = "disabled";
 	};
 
@@ -272,7 +273,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
-		clocks = <&tegra_car 65>;
+		clocks = <&tegra_car TEGRA30_CLK_UARTD>;
 		status = "disabled";
 	};
 
@@ -283,7 +284,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 20>;
-		clocks = <&tegra_car 66>;
+		clocks = <&tegra_car TEGRA30_CLK_UARTE>;
 		status = "disabled";
 	};
 
@@ -291,7 +292,7 @@
 		compatible = "nvidia,tegra30-pwm", "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
-		clocks = <&tegra_car 17>;
+		clocks = <&tegra_car TEGRA30_CLK_PWM>;
 	};
 
 	rtc {
@@ -306,7 +307,7 @@
 		interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 12>, <&tegra_car 182>;
+		clocks = <&tegra_car TEGRA30_CLK_I2C1>, <&tegra_car TEGRA30_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -317,7 +318,7 @@
 		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 54>, <&tegra_car 182>;
+		clocks = <&tegra_car TEGRA30_CLK_I2C2>, <&tegra_car TEGRA30_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -328,7 +329,7 @@
 		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 67>, <&tegra_car 182>;
+		clocks = <&tegra_car TEGRA30_CLK_I2C3>, <&tegra_car TEGRA30_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -339,7 +340,7 @@
 		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 103>, <&tegra_car 182>;
+		clocks = <&tegra_car TEGRA30_CLK_I2C4>, <&tegra_car TEGRA30_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -350,7 +351,7 @@
 		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 47>, <&tegra_car 182>;
+		clocks = <&tegra_car TEGRA30_CLK_I2C5>, <&tegra_car TEGRA30_CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -362,7 +363,7 @@
 		nvidia,dma-request-selector = <&apbdma 15>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 41>;
+		clocks = <&tegra_car TEGRA30_CLK_SBC1>;
 		status = "disabled";
 	};
 
@@ -373,7 +374,7 @@
 		nvidia,dma-request-selector = <&apbdma 16>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 44>;
+		clocks = <&tegra_car TEGRA30_CLK_SBC2>;
 		status = "disabled";
 	};
 
@@ -384,7 +385,7 @@
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 46>;
+		clocks = <&tegra_car TEGRA30_CLK_SBC3>;
 		status = "disabled";
 	};
 
@@ -395,7 +396,7 @@
 		nvidia,dma-request-selector = <&apbdma 18>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 68>;
+		clocks = <&tegra_car TEGRA30_CLK_SBC4>;
 		status = "disabled";
 	};
 
@@ -406,7 +407,7 @@
 		nvidia,dma-request-selector = <&apbdma 27>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 104>;
+		clocks = <&tegra_car TEGRA30_CLK_SBC5>;
 		status = "disabled";
 	};
 
@@ -417,7 +418,7 @@
 		nvidia,dma-request-selector = <&apbdma 28>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 105>;
+		clocks = <&tegra_car TEGRA30_CLK_SBC6>;
 		status = "disabled";
 	};
 
@@ -425,7 +426,7 @@
 		compatible = "nvidia,tegra30-kbc", "nvidia,tegra20-kbc";
 		reg = <0x7000e200 0x100>;
 		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 36>;
+		clocks = <&tegra_car TEGRA30_CLK_KBC>;
 		status = "disabled";
 	};
 
@@ -459,10 +460,10 @@
 		       0x70080200 0x100>;
 		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 1>;
-		clocks = <&tegra_car 106>, <&tegra_car 107>, <&tegra_car 30>,
-			 <&tegra_car 11>, <&tegra_car 18>, <&tegra_car 101>,
-			 <&tegra_car 102>, <&tegra_car 108>, <&tegra_car 109>,
-			 <&tegra_car 110>, <&tegra_car 162>;
+		clocks = <&tegra_car TEGRA30_CLK_D_AUDIO>, <&tegra_car TEGRA30_CLK_APBIF>, <&tegra_car TEGRA30_CLK_I2S0>,
+			 <&tegra_car TEGRA30_CLK_I2S1>, <&tegra_car TEGRA30_CLK_I2S2>, <&tegra_car TEGRA30_CLK_I2S3>,
+			 <&tegra_car TEGRA30_CLK_I2S4>, <&tegra_car TEGRA30_CLK_DAM0>, <&tegra_car TEGRA30_CLK_DAM1>,
+			 <&tegra_car TEGRA30_CLK_DAM2>, <&tegra_car TEGRA30_CLK_SPDIF_IN>;
 		clock-names = "d_audio", "apbif", "i2s0", "i2s1", "i2s2",
 			      "i2s3", "i2s4", "dam0", "dam1", "dam2",
 			      "spdif_in";
@@ -474,7 +475,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080300 0x100>;
 			nvidia,ahub-cif-ids = <4 4>;
-			clocks = <&tegra_car 30>;
+			clocks = <&tegra_car TEGRA30_CLK_I2S0>;
 			status = "disabled";
 		};
 
@@ -482,7 +483,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080400 0x100>;
 			nvidia,ahub-cif-ids = <5 5>;
-			clocks = <&tegra_car 11>;
+			clocks = <&tegra_car TEGRA30_CLK_I2S1>;
 			status = "disabled";
 		};
 
@@ -490,7 +491,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080500 0x100>;
 			nvidia,ahub-cif-ids = <6 6>;
-			clocks = <&tegra_car 18>;
+			clocks = <&tegra_car TEGRA30_CLK_I2S2>;
 			status = "disabled";
 		};
 
@@ -498,7 +499,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080600 0x100>;
 			nvidia,ahub-cif-ids = <7 7>;
-			clocks = <&tegra_car 101>;
+			clocks = <&tegra_car TEGRA30_CLK_I2S3>;
 			status = "disabled";
 		};
 
@@ -506,7 +507,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080700 0x100>;
 			nvidia,ahub-cif-ids = <8 8>;
-			clocks = <&tegra_car 102>;
+			clocks = <&tegra_car TEGRA30_CLK_I2S4>;
 			status = "disabled";
 		};
 	};
@@ -515,7 +516,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000000 0x200>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 14>;
+		clocks = <&tegra_car TEGRA30_CLK_SDMMC1>;
 		status = "disabled";
 	};
 
@@ -523,7 +524,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000200 0x200>;
 		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 9>;
+		clocks = <&tegra_car TEGRA30_CLK_SDMMC2>;
 		status = "disabled";
 	};
 
@@ -531,7 +532,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000400 0x200>;
 		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 69>;
+		clocks = <&tegra_car TEGRA30_CLK_SDMMC3>;
 		status = "disabled";
 	};
 
@@ -539,7 +540,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000600 0x200>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 15>;
+		clocks = <&tegra_car TEGRA30_CLK_SDMMC4>;
 		status = "disabled";
 	};
 
-- 
1.7.9.5

