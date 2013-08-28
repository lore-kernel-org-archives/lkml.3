Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3H1Pte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:49:34 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11619 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3H1Psy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:48:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Aug 2013 08:46:22 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 5/6] ARM: tegra: Add host1x, DC and HDMI to Tegra114 device tree
Date: Wed, 28 Aug 2013 18:48:41 +0300
Message-ID: <1377704922-2824-6-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com>
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add host1x, DC (display controller) and HDMI devices to Tegra114
device tree.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 2905145..088b594 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -27,6 +27,48 @@
 			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 	};
 
+	host1x {
+		compatible = "nvidia,tegra114-host1x", "simple-bus";
+		reg = <0x50000000 0x00028000>;
+		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH
+			      GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA114_CLK_HOST1X>;
+
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		ranges = <0x54000000 0x54000000 0x04000000>;
+
+		dc@54200000 {
+			compatible = "nvidia,tegra114-dc", "nvidia,tegra30-dc";
+			reg = <0x54200000 0x00040000>;
+			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&tegra_car TEGRA114_CLK_DISP1>,
+				    <&tegra_car TEGRA114_CLK_PLL_P>;
+			clock-names = "disp1", "parent";
+		};
+
+		dc@54240000 {
+			compatible = "nvidia,tegra114-dc", "nvidia,tegra30-dc";
+			reg = <0x54240000 0x00040000>;
+			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&tegra_car TEGRA114_CLK_DISP2>,
+				    <&tegra_car TEGRA114_CLK_PLL_P>;
+			clock-names = "disp2", "parent";
+		};
+
+		hdmi {
+			compatible = "nvidia,tegra114-hdmi";
+			reg = <0x54280000 0x00040000>;
+			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&tegra_car TEGRA114_CLK_HDMI>,
+				    <&tegra_car TEGRA114_CLK_PLL_D2_OUT0>;
+			clock-names = "hdmi", "parent";
+
+			status = "disabled";
+		};
+	};
+
 	timer@60005000 {
 		compatible = "nvidia,tegra114-timer", "nvidia,tegra20-timer";
 		reg = <0x60005000 0x400>;
-- 
1.8.1.5

