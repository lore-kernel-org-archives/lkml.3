Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206Ab3BNTBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:01:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19259 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab3BNTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:01:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Feb 2013 11:01:14 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v2 4/4] ARM: tegra30: convert device tree files to use CLK defines
Date: Thu, 14 Feb 2013 20:59:18 +0200
Message-ID: <1360868369-20093-5-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com>
References: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com>
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
 .../bindings/clock/nvidia,tegra30-car.txt          |    2 +-
 arch/arm/boot/dts/tegra30.dtsip                    |   87 ++++++++++----------
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
index f3da3be..bc9660b 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
@@ -229,7 +229,7 @@ Example SoC include file:
 	};
 
 	usb@c5004000 {
-		clocks = <&tegra_car 58>; /* usb2 */
+		clocks = <&tegra_car CLK_USB2>; /* usb2 */
 	};
 };
 
diff --git a/arch/arm/boot/dts/tegra30.dtsip b/arch/arm/boot/dts/tegra30.dtsip
index 0148459..0483697 100644
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
+		clocks = <&tegra_car CLK_HOST1X>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -30,35 +31,35 @@
 			compatible = "nvidia,tegra30-mpe";
 			reg = <0x54040000 0x00040000>;
 			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 60>;
+			clocks = <&tegra_car CLK_MPE>;
 		};
 
 		vi {
 			compatible = "nvidia,tegra30-vi";
 			reg = <0x54080000 0x00040000>;
 			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 164>;
+			clocks = <&tegra_car CLK_VI>;
 		};
 
 		epp {
 			compatible = "nvidia,tegra30-epp";
 			reg = <0x540c0000 0x00040000>;
 			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 19>;
+			clocks = <&tegra_car CLK_EPP>;
 		};
 
 		isp {
 			compatible = "nvidia,tegra30-isp";
 			reg = <0x54100000 0x00040000>;
 			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 23>;
+			clocks = <&tegra_car CLK_ISP>;
 		};
 
 		gr2d {
 			compatible = "nvidia,tegra30-gr2d";
 			reg = <0x54140000 0x00040000>;
 			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 21>;
+			clocks = <&tegra_car CLK_GR2D>;
 		};
 
 		gr3d {
@@ -72,7 +73,7 @@
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54200000 0x00040000>;
 			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 27>, <&tegra_car 179>;
+			clocks = <&tegra_car CLK_DISP1>, <&tegra_car CLK_PLL_P>;
 			clock-names = "disp1", "parent";
 
 			rgb {
@@ -84,7 +85,7 @@
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54240000 0x00040000>;
 			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 26>, <&tegra_car 179>;
+			clocks = <&tegra_car CLK_DISP2>, <&tegra_car CLK_PLL_P>;
 			clock-names = "disp2", "parent";
 
 			rgb {
@@ -96,7 +97,7 @@
 			compatible = "nvidia,tegra30-hdmi";
 			reg = <0x54280000 0x00040000>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 51>, <&tegra_car 189>;
+			clocks = <&tegra_car CLK_HDMI>, <&tegra_car CLK_PLL_D2_OUT0>;
 			clock-names = "hdmi", "parent";
 			status = "disabled";
 		};
@@ -105,14 +106,14 @@
 			compatible = "nvidia,tegra30-tvo";
 			reg = <0x542c0000 0x00040000>;
 			interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&tegra_car 169>;
+			clocks = <&tegra_car CLK_TVO>;
 			status = "disabled";
 		};
 
 		dsi {
 			compatible = "nvidia,tegra30-dsi";
 			reg = <0x54300000 0x00040000>;
-			clocks = <&tegra_car 48>;
+			clocks = <&tegra_car CLK_DSIA>;
 			status = "disabled";
 		};
 	};
@@ -193,7 +194,7 @@
 			     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 34>;
+		clocks = <&tegra_car CLK_APBDMA>;
 	};
 
 	ahb: ahb {
@@ -239,7 +240,7 @@
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		clock-frequency = <408000000>;
 		nvidia,dma-request-selector = <&apbdma 8>;
-		clocks = <&tegra_car 6>;
+		clocks = <&tegra_car CLK_UARTA>;
 		status = "disabled";
 	};
 
@@ -250,7 +251,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
-		clocks = <&tegra_car 160>;
+		clocks = <&tegra_car CLK_UARTB>;
 		status = "disabled";
 	};
 
@@ -261,7 +262,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
-		clocks = <&tegra_car 55>;
+		clocks = <&tegra_car CLK_UARTC>;
 		status = "disabled";
 	};
 
@@ -272,7 +273,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
-		clocks = <&tegra_car 65>;
+		clocks = <&tegra_car CLK_UARTD>;
 		status = "disabled";
 	};
 
@@ -283,7 +284,7 @@
 		clock-frequency = <408000000>;
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 20>;
-		clocks = <&tegra_car 66>;
+		clocks = <&tegra_car CLK_UARTE>;
 		status = "disabled";
 	};
 
@@ -291,7 +292,7 @@
 		compatible = "nvidia,tegra30-pwm", "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
-		clocks = <&tegra_car 17>;
+		clocks = <&tegra_car CLK_PWM>;
 	};
 
 	rtc {
@@ -306,7 +307,7 @@
 		interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 12>, <&tegra_car 182>;
+		clocks = <&tegra_car CLK_I2C1>, <&tegra_car CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -317,7 +318,7 @@
 		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 54>, <&tegra_car 182>;
+		clocks = <&tegra_car CLK_I2C2>, <&tegra_car CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -328,7 +329,7 @@
 		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 67>, <&tegra_car 182>;
+		clocks = <&tegra_car CLK_I2C3>, <&tegra_car CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -339,7 +340,7 @@
 		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 103>, <&tegra_car 182>;
+		clocks = <&tegra_car CLK_I2C4>, <&tegra_car CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -350,7 +351,7 @@
 		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 47>, <&tegra_car 182>;
+		clocks = <&tegra_car CLK_I2C5>, <&tegra_car CLK_PLL_P_OUT3>;
 		clock-names = "div-clk", "fast-clk";
 		status = "disabled";
 	};
@@ -362,7 +363,7 @@
 		nvidia,dma-request-selector = <&apbdma 15>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 41>;
+		clocks = <&tegra_car CLK_SBC1>;
 		status = "disabled";
 	};
 
@@ -373,7 +374,7 @@
 		nvidia,dma-request-selector = <&apbdma 16>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 44>;
+		clocks = <&tegra_car CLK_SBC2>;
 		status = "disabled";
 	};
 
@@ -384,7 +385,7 @@
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 46>;
+		clocks = <&tegra_car CLK_SBC3>;
 		status = "disabled";
 	};
 
@@ -395,7 +396,7 @@
 		nvidia,dma-request-selector = <&apbdma 18>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 68>;
+		clocks = <&tegra_car CLK_SBC4>;
 		status = "disabled";
 	};
 
@@ -406,7 +407,7 @@
 		nvidia,dma-request-selector = <&apbdma 27>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 104>;
+		clocks = <&tegra_car CLK_SBC5>;
 		status = "disabled";
 	};
 
@@ -417,7 +418,7 @@
 		nvidia,dma-request-selector = <&apbdma 28>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&tegra_car 105>;
+		clocks = <&tegra_car CLK_SBC6>;
 		status = "disabled";
 	};
 
@@ -425,7 +426,7 @@
 		compatible = "nvidia,tegra30-kbc", "nvidia,tegra20-kbc";
 		reg = <0x7000e200 0x100>;
 		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 36>;
+		clocks = <&tegra_car CLK_KBC>;
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
+		clocks = <&tegra_car CLK_D_AUDIO>, <&tegra_car CLK_APBIF>, <&tegra_car CLK_I2S0>,
+			 <&tegra_car CLK_I2S1>, <&tegra_car CLK_I2S2>, <&tegra_car CLK_I2S3>,
+			 <&tegra_car CLK_I2S4>, <&tegra_car CLK_DAM0>, <&tegra_car CLK_DAM1>,
+			 <&tegra_car CLK_DAM2>, <&tegra_car CLK_SPDIF_OUT>;
 		clock-names = "d_audio", "apbif", "i2s0", "i2s1", "i2s2",
 			      "i2s3", "i2s4", "dam0", "dam1", "dam2",
 			      "spdif_in";
@@ -474,7 +475,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080300 0x100>;
 			nvidia,ahub-cif-ids = <4 4>;
-			clocks = <&tegra_car 30>;
+			clocks = <&tegra_car CLK_I2S0>;
 			status = "disabled";
 		};
 
@@ -482,7 +483,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080400 0x100>;
 			nvidia,ahub-cif-ids = <5 5>;
-			clocks = <&tegra_car 11>;
+			clocks = <&tegra_car CLK_I2S1>;
 			status = "disabled";
 		};
 
@@ -490,7 +491,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080500 0x100>;
 			nvidia,ahub-cif-ids = <6 6>;
-			clocks = <&tegra_car 18>;
+			clocks = <&tegra_car CLK_I2S2>;
 			status = "disabled";
 		};
 
@@ -498,7 +499,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080600 0x100>;
 			nvidia,ahub-cif-ids = <7 7>;
-			clocks = <&tegra_car 101>;
+			clocks = <&tegra_car CLK_I2S3>;
 			status = "disabled";
 		};
 
@@ -506,7 +507,7 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080700 0x100>;
 			nvidia,ahub-cif-ids = <8 8>;
-			clocks = <&tegra_car 102>;
+			clocks = <&tegra_car CLK_I2S4>;
 			status = "disabled";
 		};
 	};
@@ -515,7 +516,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000000 0x200>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 14>;
+		clocks = <&tegra_car CLK_SDMMC1>;
 		status = "disabled";
 	};
 
@@ -523,7 +524,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000200 0x200>;
 		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 9>;
+		clocks = <&tegra_car CLK_SDMMC2>;
 		status = "disabled";
 	};
 
@@ -531,7 +532,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000400 0x200>;
 		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 69>;
+		clocks = <&tegra_car CLK_SDMMC3>;
 		status = "disabled";
 	};
 
@@ -539,7 +540,7 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000600 0x200>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 15>;
+		clocks = <&tegra_car CLK_SDMMC4>;
 		status = "disabled";
 	};
 
-- 
1.7.9.5

