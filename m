Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3HAPAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:00:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12081 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3HAPA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:00:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Aug 2013 08:00:27 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 2/2] ARM: dts: USB for Tegra114 Dalmore
Date: Thu, 1 Aug 2013 18:00:18 +0300
Message-ID: <1375369218-11288-3-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375369218-11288-1-git-send-email-ttynkkynen@nvidia.com>
References: <1375369218-11288-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

Device tree entries for the three EHCI controllers on Tegra114.
Enables the the third controller (USB host) on Dalmore.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |  9 +++++
 arch/arm/boot/dts/tegra114.dtsi        | 62 ++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index cb640eb..f3fc2b0 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -870,6 +870,15 @@
 		non-removable;
 	};
 
+	usb@7d008000 {
+		status = "okay";
+	};
+
+	usb-phy@7d008000 {
+		status = "okay";
+		vbus-supply = <&usb3_vbus_reg>;
+	};
+
 	clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index abf6c40..2905145 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -430,6 +430,68 @@
 		status = "disable";
 	};
 
+	usb@7d000000 {
+		compatible = "nvidia,tegra30-ehci", "usb-ehci";
+		reg = <0x7d000000 0x4000>;
+		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA114_CLK_USBD>;
+		nvidia,phy = <&phy1>;
+		status = "disabled";
+	};
+
+	phy1: usb-phy@7d000000 {
+		compatible = "nvidia,tegra30-usb-phy";
+		reg = <0x7d000000 0x4000 0x7d000000 0x4000>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA114_CLK_USBD>,
+			 <&tegra_car TEGRA114_CLK_PLL_U>,
+			 <&tegra_car TEGRA114_CLK_USBD>;
+		clock-names = "reg", "pll_u", "utmi-pads";
+		nvidia,hssync-start-delay = <0>;
+		nvidia,idle-wait-delay = <17>;
+		nvidia,elastic-limit = <16>;
+		nvidia,term-range-adj = <6>;
+		nvidia,xcvr-setup = <9>;
+		nvidia,xcvr-lsfslew = <0>;
+		nvidia,xcvr-lsrslew = <3>;
+		nvidia,hssquelch-level = <2>;
+		nvidia,hsdiscon-level = <5>;
+		nvidia,xcvr-hsslew = <12>;
+		status = "disabled";
+	};
+
+	usb@7d008000 {
+		compatible = "nvidia,tegra30-ehci", "usb-ehci";
+		reg = <0x7d008000 0x4000>;
+		interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA114_CLK_USB3>;
+		nvidia,phy = <&phy3>;
+		status = "disabled";
+	};
+
+	phy3: usb-phy@7d008000 {
+		compatible = "nvidia,tegra30-usb-phy";
+		reg = <0x7d008000 0x4000 0x7d000000 0x4000>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA114_CLK_USB3>,
+			 <&tegra_car TEGRA114_CLK_PLL_U>,
+			 <&tegra_car TEGRA114_CLK_USBD>;
+		clock-names = "reg", "pll_u", "utmi-pads";
+		nvidia,hssync-start-delay = <0>;
+		nvidia,idle-wait-delay = <17>;
+		nvidia,elastic-limit = <16>;
+		nvidia,term-range-adj = <6>;
+		nvidia,xcvr-setup = <9>;
+		nvidia,xcvr-lsfslew = <0>;
+		nvidia,xcvr-lsrslew = <3>;
+		nvidia,hssquelch-level = <2>;
+		nvidia,hsdiscon-level = <5>;
+		nvidia,xcvr-hsslew = <12>;
+		status = "disabled";
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
1.8.1.5

