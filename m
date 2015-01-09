Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbbAIPpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:45:19 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37567 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbbAIPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:44:24 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 6/7] ARM: zynq: DT: Add pinctrl information
Date: Fri,  9 Jan 2015 07:43:50 -0800
Message-Id: <1420818231-13451-7-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.1.1.gb42cc81
In-Reply-To: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinctrl descriptions to the zc702 and zc706 device trees.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Andreas Färber <afaerber@suse.de>
---
Changes since v1:
 - remove 'pinctrl-' prefix for pinctrl sub-nodes
 - separate config and mux nodes

Changes since RFC v2:
 - add pinconf properties to zc702 mdio node
 - remove arguments from bias-related props

Changes since RFC v1:
 - separate DT changes into their own patch
---
 arch/arm/boot/dts/zynq-7000.dtsi |   8 +-
 arch/arm/boot/dts/zynq-zc702.dts | 181 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc706.dts | 152 ++++++++++++++++++++++++++++++++
 3 files changed, 340 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index ee3e5d675b05..9a19a319b0f1 100644
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
@@ -257,6 +257,12 @@
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
index 280f02dd4ddc..4995412f116f 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -40,6 +40,8 @@
 
 &can0 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can0_default>;
 };
 
 &clkc {
@@ -50,15 +52,24 @@
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
@@ -132,10 +143,180 @@
 	};
 };
 
+&pinctrl0 {
+	pinctrl_can0_default: can0-default {
+		mux {
+			function = "can0";
+			groups = "can0_9_grp";
+		};
+
+		conf {
+			groups = "can0_9_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		conf-rx {
+			pins = "MIO46";
+			bias-high-impedance;
+		};
+
+		conf-tx {
+			pins = "MIO47";
+			bias-disable;
+		};
+	};
+
+	pinctrl_gem0_default: gem0-default {
+		mux {
+			function = "ethernet0";
+			groups = "ethernet0_0_grp";
+		};
+
+		conf {
+			groups = "ethernet0_0_grp";
+			slew-rate = <0>;
+			io-standard = <4>;
+		};
+
+		conf-rx {
+			pins = "MIO22", "MIO23", "MIO24", "MIO25", "MIO26", "MIO27";
+			bias-high-impedance;
+			low-power-disable;
+		};
+
+		conf-tx {
+			pins = "MIO16", "MIO17", "MIO18", "MIO19", "MIO20", "MIO21";
+			bias-disable;
+			low-power-enable;
+		};
+
+		mux-mdio {
+			function = "mdio0";
+			groups = "mdio0_0_grp";
+		};
+
+		conf-mdio {
+			groups = "mdio0_0_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+	};
+
+	pinctrl_gpio0_default: gpio0-default {
+		mux {
+			function = "gpio0";
+			groups = "gpio0_7_grp", "gpio0_8_grp", "gpio0_9_grp",
+				 "gpio0_10_grp", "gpio0_11_grp", "gpio0_12_grp",
+				 "gpio0_13_grp", "gpio0_14_grp";
+		};
+
+		conf {
+			groups = "gpio0_7_grp", "gpio0_8_grp", "gpio0_9_grp",
+				 "gpio0_10_grp", "gpio0_11_grp", "gpio0_12_grp",
+				 "gpio0_13_grp", "gpio0_14_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		conf-pull-up {
+			pins = "MIO9", "MIO10", "MIO11", "MIO12", "MIO13", "MIO14";
+			bias-pull-up;
+		};
+
+		conf-pull-none {
+			pins = "MIO7", "MIO8";
+			bias-disable;
+		};
+	};
+
+	pinctrl_i2c0_default: i2c0-default {
+		mux {
+			groups = "i2c0_10_grp";
+			function = "i2c0";
+		};
+
+		conf {
+			groups = "i2c0_10_grp";
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_sdhci0_default: sdhci0-default {
+		mux {
+			groups = "sdio0_2_grp";
+			function = "sdio0";
+		};
+
+		conf {
+			groups = "sdio0_2_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+
+		mux-cd {
+			groups = "gpio0_0_grp";
+			function = "sdio0_cd";
+		};
+
+		conf-cd {
+			groups = "gpio0_0_grp";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		mux-wp {
+			groups = "gpio0_15_grp";
+			function = "sdio0_wp";
+		};
+
+		conf-wp {
+			groups = "gpio0_15_grp";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_uart1_default: uart1-default {
+		mux {
+			groups = "uart1_10_grp";
+			function = "uart1";
+		};
+
+		conf {
+			groups = "uart1_10_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		conf-rx {
+			pins = "MIO49";
+			bias-high-impedance;
+		};
+
+		conf-tx {
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
index 34f7812d2ee8..af590d2bb046 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -37,15 +37,24 @@
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
@@ -111,10 +120,153 @@
 	};
 };
 
+&pinctrl0 {
+	pinctrl_gem0_default: gem0-default {
+		mux {
+			function = "ethernet0";
+			groups = "ethernet0_0_grp";
+		};
+
+		conf {
+			groups = "ethernet0_0_grp";
+			slew-rate = <0>;
+			io-standard = <4>;
+		};
+
+		conf-rx {
+			pins = "MIO22", "MIO23", "MIO24", "MIO25", "MIO26", "MIO27";
+			bias-high-impedance;
+			low-power-disable;
+		};
+
+		conf-tx {
+			pins = "MIO16", "MIO17", "MIO18", "MIO19", "MIO20", "MIO21";
+			low-power-enable;
+			bias-disable;
+		};
+
+		mux-mdio {
+			function = "mdio0";
+			groups = "mdio0_0_grp";
+		};
+
+		conf-mdio {
+			groups = "mdio0_0_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+	};
+
+	pinctrl_gpio0_default: gpio0-default {
+		mux {
+			function = "gpio0";
+			groups = "gpio0_7_grp", "gpio0_46_grp", "gpio0_47_grp";
+		};
+
+		conf {
+			groups = "gpio0_7_grp", "gpio0_46_grp", "gpio0_47_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		conf-pull-up {
+			pins = "MIO46", "MIO47";
+			bias-pull-up;
+		};
+
+		conf-pull-none {
+			pins = "MIO7";
+			bias-disable;
+		};
+	};
+
+	pinctrl_i2c0_default: i2c0-default {
+		mux {
+			groups = "i2c0_10_grp";
+			function = "i2c0";
+		};
+
+		conf {
+			groups = "i2c0_10_grp";
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_sdhci0_default: sdhci0-default {
+		mux {
+			groups = "sdio0_2_grp";
+			function = "sdio0";
+		};
+
+		conf {
+			groups = "sdio0_2_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+			bias-disable;
+		};
+
+		mux-cd {
+			groups = "gpio0_14_grp";
+			function = "sdio0_cd";
+		};
+
+		conf-cd {
+			groups = "gpio0_14_grp";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		mux-wp {
+			groups = "gpio0_15_grp";
+			function = "sdio0_wp";
+		};
+
+		conf-wp {
+			groups = "gpio0_15_grp";
+			bias-high-impedance;
+			bias-pull-up;
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+	};
+
+	pinctrl_uart1_default: uart1-default {
+		mux {
+			groups = "uart1_10_grp";
+			function = "uart1";
+		};
+
+		conf {
+			groups = "uart1_10_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		conf-rx {
+			pins = "MIO49";
+			bias-high-impedance;
+		};
+
+		conf-tx {
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
2.2.1.1.gb42cc81

