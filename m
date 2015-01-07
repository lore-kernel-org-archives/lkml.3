Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbbAGPFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:05:47 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37615 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbbAGPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:04:30 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 5/7] ARM: STi: DT: STiH410: Add DT nodes for the ehci and ohci usb controllers.
Date: Wed,  7 Jan 2015 15:04:10 +0000
Message-Id: <1420643052-4506-6-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420643052-4506-1-git-send-email-peter.griffin@linaro.org>
References: <1420643052-4506-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DT nodes for the extra ehci and ohci usb controllers
on the stih410 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/stih410.dtsi | 52 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
index 2e5e9ed..37995f4 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -28,5 +28,57 @@
 				 <&picophyreset STIH407_PICOPHY1_RESET>;
 			reset-names = "global", "port";
 		};
+
+		ohci0: usb@9a03c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0x9a03c00 0x100>;
+			interrupts = <GIC_SPI 180 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy1>;
+			phy-names = "usb";
+		};
+
+		ehci0: usb@9a03e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0x9a03e00 0x100>;
+			interrupts = <GIC_SPI 151 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb0>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy1>;
+			phy-names = "usb";
+		};
+
+		ohci1: usb@9a83c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0x9a83c00 0x100>;
+			interrupts = <GIC_SPI 181 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy2>;
+			phy-names = "usb";
+		};
+
+		ehci1: usb@9a83e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0x9a83e00 0x100>;
+			interrupts = <GIC_SPI 153 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb1>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy2>;
+			phy-names = "usb";
+		};
 	};
 };
-- 
1.9.1

