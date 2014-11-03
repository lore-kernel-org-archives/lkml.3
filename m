Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaKCTHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:07:02 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:45171 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbaKCTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:06:16 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org
Subject: [PATCH 7/7] ARM: zynq: DT: Add pinctrl information
Date: Mon,  3 Nov 2014 11:05:31 -0800
Message-Id: <1415041531-15520-8-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinctrl descriptions to the zc702 and zc706 device trees.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Changes since RFC v2:
 - add pinconf properties to zc702 mdio node
 - remove arguments from bias-related props

Changes since RFC v1:
 - separate DT changes into their own patch
---
 arch/arm/boot/dts/zynq-7000.dtsi |   8 ++-
 arch/arm/boot/dts/zynq-zc702.dts | 143 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc706.dts | 120 ++++++++++++++++++++++++++++++++
 3 files changed, 270 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index ce2ef5bec4f2..fc5246a4f69f 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -237,7 +237,7 @@
 		slcr: slcr@f8000000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
-			compatible = "xlnx,zynq-slcr", "syscon";
+			compatible = "xlnx,zynq-slcr", "syscon", "simple-bus";
 			reg = <0xF8000000 0x1000>;
 			ranges;
 			clkc: clkc@100 {
@@ -258,6 +258,12 @@
 						"dbg_trc", "dbg_apb";
 				reg = <0x100 0x100>;
 			};
+
+			pinctrl0: pinctrl@700 {
+				compatible = "xlnx,pinctrl-zynq";
+				reg = <0x700 0x200>;
+				syscon = <&slcr>;
+			};
 		};
 
 		dmac_s: dmac@f8003000 {
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 94e2cda6f9b6..f64e7ad53c65 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -40,21 +40,32 @@
 
 &can0 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can0_default>;
 };
 
 &gem0 {
 	status = "okay";
 	phy-mode = "rgmii-id";
 	phy-handle = <&ethernet_phy>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gem0_default>;
 
 	ethernet_phy: ethernet-phy@7 {
 		reg = <7>;
 	};
 };
 
+&gpio0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gpio0_default>;
+};
+
 &i2c0 {
 	status = "okay";
 	clock-frequency = <400000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c0_default>;
 
 	i2cswitch@74 {
 		compatible = "nxp,pca9548";
@@ -128,10 +139,142 @@
 	};
 };
 
+&pinctrl0 {
+	pinctrl_can0_default: pinctrl-can0-default {
+		common {
+			function = "can0";
+			groups = "can0_9_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		rx {
+			pins = "MIO46";
+			bias-high-impedance;
+		};
+
+		tx {
+			pins = "MIO47";
+			bias-disable;
+		};
+	};
+
+	pinctrl_gem0_default: pinctrl-gem0-default {
+		common {
+			function = "ethernet0";
+			groups = "ethernet0_0_grp";
+			slew-rate = <0>;
+			io-standard = <4>;
+		};
+
+		rx {
+			pins = "MIO22", "MIO23", "MIO24", "MIO25", "MIO26", "MIO27";
+			bias-high-impedance;
+			low-power-disable;
+		};
+
+		tx {
+			pins = "MIO16", "MIO17", "MIO18", "MIO19", "MIO20", "MIO21";
+			bias-disable;
+			low-power-enable;
+		};
+
+		mdio {
+			function = "mdio0";
+			groups = "mdio0_0_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+	};
+
+	pinctrl_gpio0_default: pinctrl-gpio0-default {
+		common {
+			function = "gpio0";
+			groups = "gpio0_7_grp", "gpio0_8_grp", "gpio0_9_grp",
+				 "gpio0_10_grp", "gpio0_11_grp", "gpio0_12_grp",
+				 "gpio0_13_grp", "gpio0_14_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		pull-up {
+			pins = "MIO9", "MIO10", "MIO11", "MIO12", "MIO13", "MIO14";
+			bias-pull-up;
+		};
+
+		pull-none {
+			pins = "MIO7", "MIO8";
+			bias-disable;
+		};
+	};
+
+	pinctrl_i2c0_default: pinctrl-i2c0-default {
+		common {
+			groups = "i2c0_10_grp";
+			function = "i2c0";
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_sdhci0_default: pinctrl-sdhci0-default {
+		common {
+			groups = "sdio0_2_grp";
+			function = "sdio0";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+
+		cd {
+			groups = "gpio0_0_grp";
+			function = "sdio0_cd";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		wp {
+			groups = "gpio0_15_grp";
+			function = "sdio0_wp";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_uart1_default: pinctrl-uart1-default {
+		common {
+			groups = "uart1_10_grp";
+			function = "uart1";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		rx {
+			pins = "MIO49";
+			bias-high-impedance;
+		};
+
+		tx {
+			pins = "MIO48";
+			bias-disable = <0>;
+		};
+	};
+};
+
 &sdhci0 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_sdhci0_default>;
 };
 
 &uart1 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart1_default>;
 };
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index a8bbdfbc7093..5575a175f867 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -33,15 +33,24 @@
 	status = "okay";
 	phy-mode = "rgmii-id";
 	phy-handle = <&ethernet_phy>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gem0_default>;
 
 	ethernet_phy: ethernet-phy@7 {
 		reg = <7>;
 	};
 };
 
+&gpio0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gpio0_default>;
+};
+
 &i2c0 {
 	status = "okay";
 	clock-frequency = <400000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c0_default>;
 
 	i2cswitch@74 {
 		compatible = "nxp,pca9548";
@@ -107,10 +116,121 @@
 	};
 };
 
+&pinctrl0 {
+	pinctrl_gem0_default: pinctrl-gem0-default {
+		common {
+			function = "ethernet0";
+			groups = "ethernet0_0_grp";
+			slew-rate = <0>;
+			io-standard = <4>;
+		};
+
+		rx {
+			pins = "MIO22", "MIO23", "MIO24", "MIO25", "MIO26", "MIO27";
+			bias-high-impedance;
+			low-power-disable;
+		};
+
+		tx {
+			pins = "MIO16", "MIO17", "MIO18", "MIO19", "MIO20", "MIO21";
+			low-power-enable;
+			bias-disable;
+		};
+
+		mdio {
+			function = "mdio0";
+			groups = "mdio0_0_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+	};
+
+	pinctrl_gpio0_default: pinctrl-gpio0-default {
+		common {
+			function = "gpio0";
+			groups = "gpio0_7_grp", "gpio0_46_grp", "gpio0_47_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		pull-up {
+			pins = "MIO46", "MIO47";
+			bias-pull-up;
+		};
+
+		pull-none {
+			pins = "MIO7";
+			bias-disable;
+		};
+	};
+
+	pinctrl_i2c0_default: pinctrl-i2c0-default {
+		common {
+			groups = "i2c0_10_grp";
+			function = "i2c0";
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_sdhci0_default: pinctrl-sdhci0-default {
+		common {
+			groups = "sdio0_2_grp";
+			function = "sdio0";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+
+		cd {
+			groups = "gpio0_14_grp";
+			function = "sdio0_cd";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		wp {
+			groups = "gpio0_15_grp";
+			function = "sdio0_wp";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_uart1_default: pinctrl-uart1-default {
+		common {
+			groups = "uart1_10_grp";
+			function = "uart1";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		rx {
+			pins = "MIO49";
+			bias-high-impedance;
+		};
+
+		tx {
+			pins = "MIO48";
+			bias-disable;
+		};
+	};
+};
+
 &sdhci0 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_sdhci0_default>;
 };
 
 &uart1 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart1_default>;
 };
-- 
1.9.1

