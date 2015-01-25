Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbbAYMXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 07:23:02 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35357 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbAYMW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 07:22:29 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v2 5/9] ARM: dts: sun9i: Add USB host controller nodes to a80 dtsi
Date: Sun, 25 Jan 2015 20:22:06 +0800
Message-Id: <1422188530-1794-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422188530-1794-1-git-send-email-wens@csie.org>
References: <1422188530-1794-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A80 has 3 EHCI/OHCI USB controllers.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun9i-a80.dtsi | 70 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
index d7ebd9390b01..9483b15bfda7 100644
--- a/arch/arm/boot/dts/sun9i-a80.dtsi
+++ b/arch/arm/boot/dts/sun9i-a80.dtsi
@@ -355,6 +355,28 @@
 		 */
 		ranges = <0 0 0 0x20000000>;
 
+		ehci0: usb@00a00000 {
+			compatible = "allwinner,sun9i-a80-ehci", "generic-ehci";
+			reg = <0x00a00000 0x100>;
+			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&usb_mod_clk 1>;
+			resets = <&usb_mod_clk 17>;
+			phys = <&usbphy1>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci0: usb@00a00400 {
+			compatible = "allwinner,sun9i-a80-ohci", "generic-ohci";
+			reg = <0x00a00400 0x100>;
+			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&usb_mod_clk 1>, <&usb_mod_clk 2>;
+			resets = <&usb_mod_clk 17>;
+			phys = <&usbphy1>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
 		usbphy1: phy@00a00800 {
 			compatible = "allwinner,sun9i-a80-usb-phy";
 			reg = <0x00a00800 0x4>;
@@ -366,6 +388,32 @@
 			#phy-cells = <0>;
 		};
 
+		ehci1: usb@00a01000 {
+			compatible = "allwinner,sun9i-a80-ehci", "generic-ehci";
+			reg = <0x00a01000 0x100>;
+			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&usb_mod_clk 3>;
+			resets = <&usb_mod_clk 18>;
+			phys = <&usbphy2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		/*
+		 * Even though ohci1 exists, it is never used as
+		 * usb1 only has HSIC pins routed externally
+		 */
+		ohci1: usb@00a01400 {
+			compatible = "allwinner,sun9i-a80-ohci", "generic-ohci";
+			reg = <0x00a01400 0x100>;
+			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&usb_mod_clk 3>, <&usb_mod_clk 4>;
+			resets = <&usb_mod_clk 18>;
+			phys = <&usbphy2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
 		usbphy2: phy@00a01800 {
 			compatible = "allwinner,sun9i-a80-usb-phy";
 			reg = <0x00a01800 0x4>;
@@ -380,6 +428,28 @@
 			phy_type = "hsic";
 		};
 
+		ehci2: usb@00a02000 {
+			compatible = "allwinner,sun9i-a80-ehci", "generic-ehci";
+			reg = <0x00a02000 0x100>;
+			interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&usb_mod_clk 5>;
+			resets = <&usb_mod_clk 19>;
+			phys = <&usbphy3>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci2: usb@00a02400 {
+			compatible = "allwinner,sun9i-a80-ohci", "generic-ohci";
+			reg = <0x00a02400 0x100>;
+			interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&usb_mod_clk 5>, <&usb_mod_clk 6>;
+			resets = <&usb_mod_clk 19>;
+			phys = <&usbphy3>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
 		usbphy3: phy@00a02800 {
 			compatible = "allwinner,sun9i-a80-usb-phy";
 			reg = <0x00a02800 0x4>;
-- 
2.1.4

