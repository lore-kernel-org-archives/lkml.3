Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbaKMLAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:00:52 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61347 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738AbaKMLAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:00:49 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 03/14] ARM: STi: DT: STiH416: Add DT nodes for the ehci and ohci usb controllers.
Date: Thu, 13 Nov 2014 11:00:06 +0000
Message-Id: <1415876417-28728-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DT nodes for the 4 usb ehci and ohci usb controllers
on the stih416 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 121 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 321763b..76dc97e 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -324,5 +324,126 @@
 			clocks = <&clk_sysin>;
 			clock-names = "osc_phy";
 		};
+
+		ehci0: usb@fe1ffe00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe1ffe00 0x100>;
+			interrupts = <GIC_SPI 148 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb0>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			resets = <&powerdown STIH416_USB0_POWERDOWN>,
+				 <&softreset STIH416_USB0_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci0: usb@fe1ffc00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe1ffc00 0x100>;
+			interrupts = <GIC_SPI 149 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			status = "okay";
+			resets = <&powerdown STIH416_USB0_POWERDOWN>,
+				 <&softreset STIH416_USB0_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ehci1: usb@fe203e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe203e00 0x100>;
+			interrupts = <GIC_SPI 150 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb1>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			resets = <&powerdown STIH416_USB1_POWERDOWN>,
+				 <&softreset STIH416_USB1_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci1: usb@fe203c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe203c00 0x100>;
+			interrupts = <GIC_SPI 151 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			resets = <&powerdown STIH416_USB1_POWERDOWN>,
+				 <&softreset STIH416_USB1_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ehci2: usb@fe303e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe303e00 0x100>;
+			interrupts = <GIC_SPI 152 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb2>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			resets = <&powerdown STIH416_USB2_POWERDOWN>,
+				 <&softreset STIH416_USB2_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci2: usb@fe303c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe303c00 0x100>;
+			interrupts = <GIC_SPI 153 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			resets = <&powerdown STIH416_USB2_POWERDOWN>,
+				 <&softreset STIH416_USB2_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ehci3: usb@fe343e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0xfe343e00 0x100>;
+			interrupts = <GIC_SPI 154 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb3>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			resets = <&powerdown STIH416_USB3_POWERDOWN>,
+				 <&softreset STIH416_USB3_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
+
+		ohci3: usb@fe343c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0xfe343c00 0x100>;
+			interrupts = <GIC_SPI 155 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_a1_ls 0>,
+				 <&clockgen_b0 0>;
+			clock-names = "ic", "clk48";
+			phys = <&usb2_phy>;
+			phy-names = "usb";
+			resets = <&powerdown STIH416_USB3_POWERDOWN>,
+				 <&softreset STIH416_USB3_SOFTRESET>;
+			reset-names = "power", "softreset";
+		};
 	};
 };
-- 
1.9.1

