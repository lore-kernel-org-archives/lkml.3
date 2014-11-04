Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaKDEH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:07:28 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:48811 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKDEHZ (ORCPT
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
Subject: [PATCH 2/6] ARM: dts: sun9i: Add usb clock nodes to a80 dtsi
Date: Tue,  4 Nov 2014 12:07:15 +0800
Message-Id: <1415074039-16590-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415074039-16590-1-git-send-email-wens@csie.org>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB controller and phy clocks and resets have a separate address
block and driver. Add the nodes to represent them.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun9i-a80.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
index 494714f..3c25030 100644
--- a/arch/arm/boot/dts/sun9i-a80.dtsi
+++ b/arch/arm/boot/dts/sun9i-a80.dtsi
@@ -143,6 +143,28 @@
 			clock-output-names = "osc32k";
 		};
 
+		usb_mod_clk: clk@00a08000 {
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			compatible = "allwinner,sun9i-a80-usb-mod-clk";
+			reg = <0x00a08000 0x4>;
+			clocks = <&ahb1_gates 1>, <&pll4>;
+			clock-output-names = "usb0_ahb", "usb_ohci0",
+					     "usb1_ahb", "usb_ohci1",
+					     "usb2_ahb", "usb_ohci2";
+		};
+
+		usb_phy_clk: clk@00a08004 {
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			compatible = "allwinner,sun9i-a80-usb-phy-clk";
+			reg = <0x00a08004 0x4>;
+			clocks = <&ahb1_gates 1>, <&pll4>;
+			clock-output-names = "usb_phy0", "usb_hsic1_480M",
+					     "usb_phy1", "usb_hsic2_480M",
+					     "usb_phy2", "usb_hsic_12M";
+		};
+
 		pll4: clk@0600000c {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun9i-a80-pll4-clk";
-- 
2.1.1

