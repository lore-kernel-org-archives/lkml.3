Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaKGMDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:03:34 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36460 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaKGMDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:03:31 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 03/13] ARM: STi: DT: STiH416: Add DT nodes for the ehci and ohci usb controllers.
Date: Fri,  7 Nov 2014 11:57:45 +0000
Message-Id: <1415361475-6218-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DT nodes for the 4 usb ehci and ohci usb controllers
on the stih416 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020.dts  |   4 +
 arch/arm/boot/dts/stih416-b2020e.dts |   4 +
 arch/arm/boot/dts/stih416.dtsi       | 144 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih41x-b2020.dtsi |  12 +++
 4 files changed, 164 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index 5d1543b..c75b632 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -33,5 +33,9 @@
 		sata0: sata@fe380000{
 			status = "okay";
 		};
+
+		usb3: usb@fe340000 {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416-b2020e.dts b/arch/arm/boot/dts/stih416-b2020e.dts
index 956fab8..9768503 100644
--- a/arch/arm/boot/dts/stih416-b2020e.dts
+++ b/arch/arm/boot/dts/stih416-b2020e.dts
@@ -51,5 +51,9 @@
 		sata0: sata@fe380000{
 			status = "okay";
 		};
+
+		usb3: usb@fe340000 {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 0f3019a..6238d9e 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -325,5 +325,149 @@
 			clock-names = "osc_phy";
 
 		};
+
+		ehci0: usb@0xfe1ffe00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe1ffe00 0x100>;
+			interrupts = <GIC_SPI 148 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb0>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB0_POWERDOWN>,
+				 <&softreset STIH416_USB0_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci0: usb@0xfe1ffc00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe1ffc00 0x100>;
+			interrupts = <GIC_SPI 149 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB0_POWERDOWN>,
+				 <&softreset STIH416_USB0_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ehci1: usb@0xfe203e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe203e00 0x100>;
+			interrupts = <GIC_SPI 150 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb1>;
+
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB1_POWERDOWN>,
+				 <&softreset STIH416_USB1_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci1: usb@0xfe203c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe203c00 0x100>;
+			interrupts = <GIC_SPI 151 IRQ_TYPE_NONE>;
+
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB1_POWERDOWN>,
+				 <&softreset STIH416_USB1_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ehci2: usb@0xfe303e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe303e00 0x100>;
+			interrupts = <GIC_SPI 152 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb2>;
+
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB2_POWERDOWN>,
+				 <&softreset STIH416_USB2_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci2: usb@0xfe303c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe303c00 0x100>;
+			interrupts = <GIC_SPI 153 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB2_POWERDOWN>,
+				 <&softreset STIH416_USB2_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ehci3: usb@0xfe343e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe343e00 0x100>;
+			interrupts = <GIC_SPI 154 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb3>;
+
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB3_POWERDOWN>,
+				 <&softreset STIH416_USB3_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci3: usb@0xfe343c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe343c00 0x100>;
+			interrupts = <GIC_SPI 155 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+
+			resets = <&powerdown STIH416_USB3_POWERDOWN>,
+				 <&softreset STIH416_USB3_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
index 487d7d8..005ab38 100644
--- a/arch/arm/boot/dts/stih41x-b2020.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -78,5 +78,17 @@
 		mmc0: sdhci@fe81e000 {
 			bus-width = <8>;
 		};
+
+		usb0: usb@fe100000 {
+			status = "okay";
+		};
+
+		usb1: usb@fe200000 {
+			status = "okay";
+		};
+
+		usb2: usb@fe300000 {
+			status = "okay";
+		};
 	};
 };
-- 
1.9.1

