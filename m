Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKDEHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:07:34 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:48850 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaKDEH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:07:28 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 5/6] ARM: dts: sun9i: Add USB host controller nodes to a80 dtsi
Date: Tue,  4 Nov 2014 12:07:18 +0800
Message-Id: <1415074039-16590-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415074039-16590-1-git-send-email-wens@csie.org>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A80 has 3 EHCI/OHCI USB controllers.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun9i-a80.dtsi | 70 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
index 1a80e09..b6f344f 100644
--- a/arch/arm/boot/dts/sun9i-a80.dtsi
+++ b/arch/arm/boot/dts/sun9i-a80.dtsi
@@ -305,6 +305,28 @@
 		 */
 		ranges = <0 0 0 0x20000000>;
 
+		ehci0: usb@00a00000 {
+			compatible = "allwinner,sun9i-a80-ehci", "generic-ehci";
+			reg = <0x00a00000 0x100>;
+			interrupts = <0 72 4>;
+			clocks = <&usb_mod_clk 1>;
+			resets = <&usb_mod_clk 17>;
+			phys = <&usbphy0>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci0: usb@00a00400 {
+			compatible = "allwinner,sun9i-a80-ohci", "generic-ohci";
+			reg = <0x00a00400 0x100>;
+			interrupts = <0 73 4>;
+			clocks = <&usb_mod_clk 1>, <&usb_mod_clk 2>;
+			resets = <&usb_mod_clk 17>;
+			phys = <&usbphy0>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
 		usbphy0: phy@00a00800 {
 			compatible = "allwinner,sun9i-a80-usb-phy";
 			reg = <0x00a00800 0x4>;
@@ -316,6 +338,32 @@
 			#phy-cells = <0>;
 		};
 
+		ehci1: usb@00a01000 {
+			compatible = "allwinner,sun9i-a80-ehci", "generic-ehci";
+			reg = <0x00a01000 0x100>;
+			interrupts = <0 74 4>;
+			clocks = <&usb_mod_clk 3>;
+			resets = <&usb_mod_clk 18>;
+			phys = <&usbphy1>;
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
+			interrupts = <0 75 4>;
+			clocks = <&usb_mod_clk 3>, <&usb_mod_clk 4>;
+			resets = <&usb_mod_clk 18>;
+			phys = <&usbphy1>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
 		usbphy1: phy@00a01800 {
 			compatible = "allwinner,sun9i-a80-usb-phy";
 			reg = <0x00a01800 0x4>;
@@ -330,6 +378,28 @@
 			phy_type = "hsic";
 		};
 
+		ehci2: usb@00a02000 {
+			compatible = "allwinner,sun9i-a80-ehci", "generic-ehci";
+			reg = <0x00a02000 0x100>;
+			interrupts = <0 76 4>;
+			clocks = <&usb_mod_clk 5>;
+			resets = <&usb_mod_clk 19>;
+			phys = <&usbphy2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci2: usb@00a02400 {
+			compatible = "allwinner,sun9i-a80-ohci", "generic-ohci";
+			reg = <0x00a02400 0x100>;
+			interrupts = <0 77 4>;
+			clocks = <&usb_mod_clk 5>, <&usb_mod_clk 6>;
+			resets = <&usb_mod_clk 19>;
+			phys = <&usbphy2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
 		usbphy2: phy@00a02800 {
 			compatible = "allwinner,sun9i-a80-usb-phy";
 			reg = <0x00a02800 0x4>;
-- 
2.1.1

