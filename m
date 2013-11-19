Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3KSJeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:34:37 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5140 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KSJeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:34:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Nov 2013 01:32:15 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <swarren@nvidia.com>, <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>,
        <galak@codeaurora.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lorenzo.pieralisi@arm.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv5 9/9] [FOR TEST] ARM: dt: tegra30: add "iommus" binding
Date: Tue, 19 Nov 2013 11:33:13 +0200
Message-ID: <1384853593-32202-10-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"iommus" binding implies that a device can be attached to IOMMU
devices. An iommu device needs to set #iommus-cells in it. "iommus"
can have multiple iommu device phandles as below if needed.

  iommus = <&smmu arg1 arg2>,
  	   <&gart arg1 arg2>;

Not yet ready for merge. Need to add iommus for other devices.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v5:
Use "iommus=" instead of "mmu-masters".
---
 arch/arm/boot/dts/tegra30.dtsi | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 2bd55cf..03b7887 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -1,6 +1,7 @@
 #include <dt-bindings/clock/tegra30-car.h>
 #include <dt-bindings/gpio/tegra-gpio.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/memory/tegra-swgroup.h>
 
 #include "skeleton.dtsi"
 
@@ -92,6 +93,7 @@
 		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>, /* syncpt */
 			     <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>; /* general */
 		clocks = <&tegra_car TEGRA30_CLK_HOST1X>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(HC)>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -103,6 +105,7 @@
 			reg = <0x54040000 0x00040000>;
 			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car TEGRA30_CLK_MPE>;
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(MPE)>;
 		};
 
 		vi {
@@ -110,6 +113,7 @@
 			reg = <0x54080000 0x00040000>;
 			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car TEGRA30_CLK_VI>;
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(VI)>;
 		};
 
 		epp {
@@ -117,6 +121,7 @@
 			reg = <0x540c0000 0x00040000>;
 			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car TEGRA30_CLK_EPP>;
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(EPP)>;
 		};
 
 		isp {
@@ -124,6 +129,7 @@
 			reg = <0x54100000 0x00040000>;
 			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car TEGRA30_CLK_ISP>;
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(ISP)>;
 		};
 
 		gr2d {
@@ -131,6 +137,7 @@
 			reg = <0x54140000 0x00040000>;
 			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car TEGRA30_CLK_GR2D>;
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(G2)>;
 		};
 
 		gr3d {
@@ -139,6 +146,8 @@
 			clocks = <&tegra_car TEGRA30_CLK_GR3D
 				  &tegra_car TEGRA30_CLK_GR3D2>;
 			clock-names = "3d", "3d2";
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(NV)
+						TEGRA_SWGROUP_CELLS(NV2)>;
 		};
 
 		dc@54200000 {
@@ -148,6 +157,7 @@
 			clocks = <&tegra_car TEGRA30_CLK_DISP1>,
 				 <&tegra_car TEGRA30_CLK_PLL_P>;
 			clock-names = "disp1", "parent";
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(DC)>;
 
 			rgb {
 				status = "disabled";
@@ -161,6 +171,7 @@
 			clocks = <&tegra_car TEGRA30_CLK_DISP2>,
 				 <&tegra_car TEGRA30_CLK_PLL_P>;
 			clock-names = "disp2", "parent";
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(DCB)>;
 
 			rgb {
 				status = "disabled";
@@ -317,6 +328,7 @@
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 8>;
 		clocks = <&tegra_car TEGRA30_CLK_UARTA>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -327,6 +339,7 @@
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
 		clocks = <&tegra_car TEGRA30_CLK_UARTB>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -337,6 +350,7 @@
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
 		clocks = <&tegra_car TEGRA30_CLK_UARTC>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -347,6 +361,7 @@
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
 		clocks = <&tegra_car TEGRA30_CLK_UARTD>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -357,6 +372,7 @@
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 20>;
 		clocks = <&tegra_car TEGRA30_CLK_UARTE>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -525,7 +541,7 @@
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
-	iommu {
+	smmu: iommu {
 		compatible = "nvidia,tegra30-smmu";
 		reg = <0x7000f010 0x02c
 		       0x7000f1f0 0x010
@@ -533,6 +549,7 @@
 		nvidia,#asids = <4>;		/* # of ASIDs */
 		dma-window = <0 0x40000000>;	/* IOVA start & length */
 		nvidia,ahb = <&ahb>;
+		#iommu-cells = <2>;
 	};
 
 	ahub {
@@ -605,6 +622,7 @@
 		reg = <0x78000000 0x200>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car TEGRA30_CLK_SDMMC1>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -613,6 +631,7 @@
 		reg = <0x78000200 0x200>;
 		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car TEGRA30_CLK_SDMMC2>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -621,6 +640,7 @@
 		reg = <0x78000400 0x200>;
 		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car TEGRA30_CLK_SDMMC3>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
@@ -629,6 +649,7 @@
 		reg = <0x78000600 0x200>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car TEGRA30_CLK_SDMMC4>;
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(PPCS)>;
 		status = "disabled";
 	};
 
-- 
1.8.1.5

