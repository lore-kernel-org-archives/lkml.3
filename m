Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaJNIRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:17:30 -0400
Received: from 16.mo3.mail-out.ovh.net ([188.165.56.217]:52784 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754161AbaJNIR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:17:26 -0400
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
Subject: [PATCH v2] ARM: dts: rockchip: add I2S controllers for rk3066 and rk3188
Date: Tue, 14 Oct 2014 10:16:37 +0200
Message-Id: <1413274597-15788-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 1.9.1
X-Ovh-Tracer-Id: 15852389215126225121
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrleegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrleegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the I2S/PCM controller nodes and pin controls for rk3066 and rk3188.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 arch/arm/boot/dts/rk3066a.dtsi | 81 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/rk3188.dtsi  | 26 ++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index ad9c2db..d75b01a 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -53,6 +53,51 @@
 		};
 	};
 
+	i2s0: i2s@10118000 {
+		compatible = "rockchip,rk3066-i2s";
+		reg = <0x10118000 0x2000>;
+		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2s0_bus>;
+		dmas = <&dmac1_s 4>, <&dmac1_s 5>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+		status = "disabled";
+	};
+
+	i2s1: i2s@1011a000 {
+		compatible = "rockchip,rk3066-i2s";
+		reg = <0x1011a000 0x2000>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2s1_bus>;
+		dmas = <&dmac1_s 6>, <&dmac1_s 7>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S1>, <&cru SCLK_I2S1>;
+		status = "disabled";
+	};
+
+	i2s2: i2s@1011c000 {
+		compatible = "rockchip,rk3066-i2s";
+		reg = <0x1011c000 0x2000>;
+		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2s2_bus>;
+		dmas = <&dmac1_s 9>, <&dmac1_s 10>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S2>, <&cru SCLK_I2S2>;
+		status = "disabled";
+	};
+
 	cru: clock-controller@20000000 {
 		compatible = "rockchip,rk3066a-cru";
 		reg = <0x20000000 0x1000>;
@@ -405,6 +450,42 @@
 						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_default>;
 			};
 		};
+
+		i2s0 {
+			i2s0_bus: i2s0-bus {
+				rockchip,pins = <RK_GPIO0 7 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 8 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 9 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 10 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 11 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 12 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 13 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 14 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 15 RK_FUNC_1 &pcfg_pull_default>;
+			};
+		};
+
+		i2s1 {
+			i2s1_bus: i2s1-bus {
+				rockchip,pins = <RK_GPIO0 16 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 17 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 18 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 19 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 20 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 21 RK_FUNC_1 &pcfg_pull_default>;
+			};
+		};
+
+		i2s2 {
+			i2s2_bus: i2s2-bus {
+				rockchip,pins = <RK_GPIO0 24 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 25 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 26 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 27 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 28 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 29 RK_FUNC_1 &pcfg_pull_default>;
+			};
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index ddaada7..fa3665a 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -65,6 +65,21 @@
 		};
 	};
 
+	i2s0: i2s@1011a000 {
+		compatible = "rockchip,rk3188-i2s", "rockchip,rk3066-i2s";
+		reg = <0x1011a000 0x2000>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2s0_bus>;
+		dmas = <&dmac1_s 6>, <&dmac1_s 7>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+		status = "disabled";
+	};
+
 	cru: clock-controller@20000000 {
 		compatible = "rockchip,rk3188-cru";
 		reg = <0x20000000 0x1000>;
@@ -395,6 +410,17 @@
 						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_none>;
 			};
 		};
+
+		i2s0 {
+			i2s0_bus: i2s0-bus {
+				rockchip,pins = <RK_GPIO1 16 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 17 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 18 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 19 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 20 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 21 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
 	};
 };
 
-- 
1.9.1

