Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3GXEK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:10:58 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8500 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3GXEKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:10:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Jul 2013 21:09:01 -0700
From: Richard Zhao <rizhao@nvidia.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <broonie@kernel.org>, <gregkh@linuxfoundation.org>,
        <lgirdwood@gmail.com>, <rizhao@nvidia.com>, <linuxzsc@gmail.com>,
        <ldewangan@nvidia.com>, <dev@lynxeye.de>
Subject: [PATCH 1/9] ARM: dts: add generic DMA DT binding for tegra apbdma
Date: Wed, 24 Jul 2013 12:09:54 +0800
Message-ID: <1374639002-16753-2-git-send-email-rizhao@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
References: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Tegra device drivers will soon move to generic DMA device tree bindings.
Add the required properties to the Tegra DT files to support that. The legacy
property nvidia,dma-request-selector will be removed after all drivers have
been converted, in order to maintain bisectability.

Changes:
 - Add '#dma-cells' for apbdma nodes
 - And properties 'dmas' and 'dma-names' for apbdma client nodes
 - update apbdma DT binding doc

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
---
 .../devicetree/bindings/dma/tegra20-apbdma.txt     |  1 +
 arch/arm/boot/dts/tegra114.dtsi                    | 27 ++++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi                     | 27 ++++++++++++++++++++++
 arch/arm/boot/dts/tegra30.dtsi                     | 25 ++++++++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/tegra20-apbdma.txt b/Documentation/devicetree/bindings/dma/tegra20-apbdma.txt
index 90fa7da..e4fc695 100644
--- a/Documentation/devicetree/bindings/dma/tegra20-apbdma.txt
+++ b/Documentation/devicetree/bindings/dma/tegra20-apbdma.txt
@@ -5,6 +5,7 @@ Required properties:
 - reg: Should contain DMA registers location and length. This shuld include
   all of the per-channel registers.
 - interrupts: Should contain all of the per-channel DMA interrupts.
+- #dma-cells: Must be <1>, which specifies the dma request.
 
 Examples:
 
diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index abf6c40..b133c62 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -81,6 +81,7 @@
 			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car TEGRA114_CLK_APBDMA>;
+		#dma-cells = <1>;
 	};
 
 	ahb: ahb {
@@ -125,6 +126,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 8>;
+		dmas = <&apbdma 8>;
+		dma-names = "rx-tx";
 		status = "disabled";
 		clocks = <&tegra_car TEGRA114_CLK_UARTA>;
 	};
@@ -135,6 +138,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
+		dmas = <&apbdma 9>;
+		dma-names = "rx-tx";
 		status = "disabled";
 		clocks = <&tegra_car TEGRA114_CLK_UARTB>;
 	};
@@ -145,6 +150,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
+		dmas = <&apbdma 10>;
+		dma-names = "rx-tx";
 		status = "disabled";
 		clocks = <&tegra_car TEGRA114_CLK_UARTC>;
 	};
@@ -155,6 +162,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
+		dmas = <&apbdma 19>;
+		dma-names = "rx-tx";
 		status = "disabled";
 		clocks = <&tegra_car TEGRA114_CLK_UARTD>;
 	};
@@ -227,6 +236,8 @@
 		reg = <0x7000d400 0x200>;
 		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 15>;
+		dmas = <&apbdma 15>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA114_CLK_SBC1>;
@@ -239,6 +250,8 @@
 		reg = <0x7000d600 0x200>;
 		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 16>;
+		dmas = <&apbdma 16>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA114_CLK_SBC2>;
@@ -251,6 +264,8 @@
 		reg = <0x7000d800 0x200>;
 		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 17>;
+		dmas = <&apbdma 17>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA114_CLK_SBC3>;
@@ -263,6 +278,8 @@
 		reg = <0x7000da00 0x200>;
 		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 18>;
+		dmas = <&apbdma 18>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA114_CLK_SBC4>;
@@ -275,6 +292,8 @@
 		reg = <0x7000dc00 0x200>;
 		interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 27>;
+		dmas = <&apbdma 27>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA114_CLK_SBC5>;
@@ -287,6 +306,8 @@
 		reg = <0x7000de00 0x200>;
 		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 28>;
+		dmas = <&apbdma 28>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA114_CLK_SBC6>;
@@ -337,6 +358,12 @@
 			<&apbdma 3>, <&apbdma 4>, <&apbdma 6>, <&apbdma 7>,
 			<&apbdma 12>, <&apbdma 13>, <&apbdma 14>,
 			<&apbdma 29>;
+		dmas = <&apbdma 1>, <&apbdma 2>, <&apbdma 3>, <&apbdma 4>,
+			<&apbdma 6>, <&apbdma 7>, <&apbdma 12>, <&apbdma 13>,
+			<&apbdma 14>, <&apbdma 29>;
+		dma-names = "channel0", "channel1", "channel2", "channel3",
+			"channel4", "channel5", "channel6", "channel7",
+			"channel8", "channel9";
 		clocks = <&tegra_car TEGRA114_CLK_D_AUDIO>,
 			 <&tegra_car TEGRA114_CLK_APBIF>,
 			 <&tegra_car TEGRA114_CLK_I2S0>,
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 9653fd8..0fe7f37 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -182,6 +182,7 @@
 			     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car TEGRA20_CLK_APBDMA>;
+		#dma-cells = <1>;
 	};
 
 	ahb {
@@ -223,6 +224,8 @@
 		reg = <0x70002000 0x200>;
 		interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 12>;
+		dmas = <&apbdma 12>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_AC97>;
 		status = "disabled";
 	};
@@ -232,6 +235,8 @@
 		reg = <0x70002800 0x200>;
 		interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 2>;
+		dmas = <&apbdma 2>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_I2S1>;
 		status = "disabled";
 	};
@@ -241,6 +246,8 @@
 		reg = <0x70002a00 0x200>;
 		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 1>;
+		dmas = <&apbdma 1>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_I2S2>;
 		status = "disabled";
 	};
@@ -258,6 +265,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 8>;
+		dmas = <&apbdma 8>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTA>;
 		status = "disabled";
 	};
@@ -268,6 +277,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
+		dmas = <&apbdma 9>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTB>;
 		status = "disabled";
 	};
@@ -278,6 +289,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
+		dmas = <&apbdma 10>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTC>;
 		status = "disabled";
 	};
@@ -288,6 +301,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
+		dmas = <&apbdma 19>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTD>;
 		status = "disabled";
 	};
@@ -298,6 +313,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 20>;
+		dmas = <&apbdma 20>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTE>;
 		status = "disabled";
 	};
@@ -334,6 +351,8 @@
 		reg = <0x7000c380 0x80>;
 		interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 11>;
+		dmas = <&apbdma 11>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA20_CLK_SPI>;
@@ -381,6 +400,8 @@
 		reg = <0x7000d400 0x200>;
 		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 15>;
+		dmas = <&apbdma 15>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA20_CLK_SBC1>;
@@ -392,6 +413,8 @@
 		reg = <0x7000d600 0x200>;
 		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 16>;
+		dmas = <&apbdma 16>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA20_CLK_SBC2>;
@@ -403,6 +426,8 @@
 		reg = <0x7000d800 0x200>;
 		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 17>;
+		dmas = <&apbdma 17>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA20_CLK_SBC3>;
@@ -414,6 +439,8 @@
 		reg = <0x7000da00 0x200>;
 		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 18>;
+		dmas = <&apbdma 18>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA20_CLK_SBC4>;
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index d8783f0..c266316 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -201,6 +201,7 @@
 			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car TEGRA30_CLK_APBDMA>;
+		#dma-cells = <1>;
 	};
 
 	ahb: ahb {
@@ -245,6 +246,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 8>;
+		dmas = <&apbdma 8>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTA>;
 		status = "disabled";
 	};
@@ -255,6 +258,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
+		dmas = <&apbdma 9>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTB>;
 		status = "disabled";
 	};
@@ -265,6 +270,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
+		dmas = <&apbdma 10>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTC>;
 		status = "disabled";
 	};
@@ -275,6 +282,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
+		dmas = <&apbdma 19>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTD>;
 		status = "disabled";
 	};
@@ -285,6 +294,8 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 20>;
+		dmas = <&apbdma 20>;
+		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTE>;
 		status = "disabled";
 	};
@@ -369,6 +380,8 @@
 		reg = <0x7000d400 0x200>;
 		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 15>;
+		dmas = <&apbdma 15>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA30_CLK_SBC1>;
@@ -380,6 +393,8 @@
 		reg = <0x7000d600 0x200>;
 		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 16>;
+		dmas = <&apbdma 16>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA30_CLK_SBC2>;
@@ -391,6 +406,8 @@
 		reg = <0x7000d800 0x200>;
 		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 17>;
+		dmas = <&apbdma 17>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA30_CLK_SBC3>;
@@ -402,6 +419,8 @@
 		reg = <0x7000da00 0x200>;
 		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 18>;
+		dmas = <&apbdma 18>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA30_CLK_SBC4>;
@@ -413,6 +432,8 @@
 		reg = <0x7000dc00 0x200>;
 		interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 27>;
+		dmas = <&apbdma 27>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA30_CLK_SBC5>;
@@ -424,6 +445,8 @@
 		reg = <0x7000de00 0x200>;
 		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 28>;
+		dmas = <&apbdma 28>;
+		dma-names = "rx-tx";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car TEGRA30_CLK_SBC6>;
@@ -470,6 +493,8 @@
 		       0x70080200 0x100>;
 		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 1>;
+		dmas = <&apbdma 1>, <&apbdma 2>, <&apbdma 3>, <&apbdma 4>;
+		dma-names = "channel0", "channel1", "channel2", "channel3";
 		clocks = <&tegra_car TEGRA30_CLK_D_AUDIO>,
 			 <&tegra_car TEGRA30_CLK_APBIF>,
 			 <&tegra_car TEGRA30_CLK_I2S0>,
-- 
1.8.1.5

