Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbaELTgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:36:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32973 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754593AbaELTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:35:09 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 7/8] ARM: sun6i: dt: Add support for the USB controllers
Date: Mon, 12 May 2014 21:34:33 +0200
Message-Id: <1399923274-6017-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399923274-6017-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399923274-6017-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 has two ECHI/OHCI controllers, and one OHCI-only phy-less controller.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 77 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 13aa56ed5858..5e9f01af6d99 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -341,6 +341,83 @@
 			status = "disabled";
 		};
 
+		usbphy: phy@01c19400 {
+			compatible = "allwinner,sun6i-a31-usb-phy";
+			reg = <0x01c19400 0x10>,
+			      <0x01c1a800 0x4>,
+			      <0x01c1b800 0x4>;
+			reg-names = "phy_ctrl",
+				    "pmu1",
+				    "pmu2";
+			clocks = <&usb_clk 8>,
+				 <&usb_clk 9>,
+				 <&usb_clk 10>;
+			clock-names = "usb0_phy",
+				      "usb1_phy",
+				      "usb2_phy";
+			resets = <&usb_clk 0>,
+				 <&usb_clk 1>,
+				 <&usb_clk 2>;
+			reset-names = "usb0_reset",
+				      "usb1_reset",
+				      "usb2_reset";
+			status = "disabled";
+			#phy-cells = <1>;
+		};
+
+		ehci0: usb@01c1a000 {
+			compatible = "allwinner,sun6i-a31-ehci", "generic-ehci";
+			reg = <0x01c1a000 0x100>;
+			interrupts = <0 72 4>;
+			clocks = <&ahb1_gates 26>;
+			resets = <&ahb1_rst 26>;
+			phys = <&usbphy 1>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci0: usb@01c1a400 {
+			compatible = "allwinner,sun6i-a31-ohci", "generic-ohci";
+			reg = <0x01c1a400 0x100>;
+			interrupts = <0 73 4>;
+			clocks = <&ahb1_gates 29>, <&usb_clk 16>;
+			resets = <&ahb1_rst 29>;
+			phys = <&usbphy 1>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ehci1: usb@01c1b000 {
+			compatible = "allwinner,sun6i-a31-ehci", "generic-ehci";
+			reg = <0x01c1b000 0x100>;
+			interrupts = <0 74 4>;
+			clocks = <&ahb1_gates 27>;
+			resets = <&ahb1_rst 27>;
+			phys = <&usbphy 2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci1: usb@01c1b400 {
+			compatible = "allwinner,sun6i-a31-ohci", "generic-ohci";
+			reg = <0x01c1b400 0x100>;
+			interrupts = <0 75 4>;
+			clocks = <&ahb1_gates 30>, <&usb_clk 17>;
+			resets = <&ahb1_rst 30>;
+			phys = <&usbphy 2>;
+			phy-names = "usb";
+			status = "disabled";
+		};
+
+		ohci2: usb@01c1c000 {
+			compatible = "allwinner,sun6i-a31-ohci", "generic-ohci";
+			reg = <0x01c1c400 0x100>;
+			interrupts = <0 77 4>;
+			clocks = <&ahb1_gates 31>, <&usb_clk 18>;
+			resets = <&ahb1_rst 31>;
+			status = "disabled";
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun6i-a31-pinctrl";
 			reg = <0x01c20800 0x400>;
-- 
1.9.3

