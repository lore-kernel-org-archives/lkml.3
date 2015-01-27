Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbbA0Tyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:54:35 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35158 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbbA0Ty0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:54:26 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v3 05/10] ARM: dts: sun9i: Add usb phy nodes to a80 dtsi
Date: Wed, 28 Jan 2015 03:54:10 +0800
Message-Id: <1422388455-25923-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422388455-25923-1-git-send-email-wens@csie.org>
References: <1422388455-25923-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sun9i, there are 3 independent usb phys for EHCI/OHCI.
Add device nodes for them.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun9i-a80.dtsi | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
index 679cf2878800..d7ebd9390b01 100644
--- a/arch/arm/boot/dts/sun9i-a80.dtsi
+++ b/arch/arm/boot/dts/sun9i-a80.dtsi
@@ -355,6 +355,43 @@
 		 */
 		ranges = <0 0 0 0x20000000>;
 
+		usbphy1: phy@00a00800 {
+			compatible = "allwinner,sun9i-a80-usb-phy";
+			reg = <0x00a00800 0x4>;
+			clocks = <&usb_phy_clk 1>;
+			clock-names = "phy";
+			resets = <&usb_phy_clk 17>;
+			reset-names = "phy";
+			status = "disabled";
+			#phy-cells = <0>;
+		};
+
+		usbphy2: phy@00a01800 {
+			compatible = "allwinner,sun9i-a80-usb-phy";
+			reg = <0x00a01800 0x4>;
+			clocks = <&usb_phy_clk 2>, <&usb_phy_clk 10>,
+				 <&usb_phy_clk 3>;
+			clock-names = "hsic_480M", "hsic_12M", "phy";
+			resets = <&usb_phy_clk 18>, <&usb_phy_clk 19>;
+			reset-names = "hsic", "phy";
+			status = "disabled";
+			#phy-cells = <0>;
+			/* usb1 is always used with HSIC */
+			phy_type = "hsic";
+		};
+
+		usbphy3: phy@00a02800 {
+			compatible = "allwinner,sun9i-a80-usb-phy";
+			reg = <0x00a02800 0x4>;
+			clocks = <&usb_phy_clk 4>, <&usb_phy_clk 10>,
+				 <&usb_phy_clk 5>;
+			clock-names = "hsic_480M", "hsic_12M", "phy";
+			resets = <&usb_phy_clk 20>, <&usb_phy_clk 21>;
+			reset-names = "hsic", "phy";
+			status = "disabled";
+			#phy-cells = <0>;
+		};
+
 		mmc0: mmc@01c0f000 {
 			compatible = "allwinner,sun5i-a13-mmc";
 			reg = <0x01c0f000 0x1000>;
-- 
2.1.4

