Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaKDEHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:07:32 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:48808 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaKDEHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:07:25 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 4/6] ARM: dts: sun9i: Add usb phy nodes to a80 dtsi
Date: Tue,  4 Nov 2014 12:07:17 +0800
Message-Id: <1415074039-16590-5-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415074039-16590-1-git-send-email-wens@csie.org>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sun9i, there are 3 independent usb phys. Add device nodes for them.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun9i-a80.dtsi | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
index 3c25030..1a80e09 100644
--- a/arch/arm/boot/dts/sun9i-a80.dtsi
+++ b/arch/arm/boot/dts/sun9i-a80.dtsi
@@ -305,6 +305,43 @@
 		 */
 		ranges = <0 0 0 0x20000000>;
 
+		usbphy0: phy@00a00800 {
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
+		usbphy1: phy@00a01800 {
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
+		usbphy2: phy@00a02800 {
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
 		gic: interrupt-controller@01c41000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c41000 0x1000>,
-- 
2.1.1

