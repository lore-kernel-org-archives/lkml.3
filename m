Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3KYKDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:03:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48383 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3KYKDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:03:33 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v3 10/10] arm/dts: added dt properties to adapt to the new phy framwork
Date: Mon, 25 Nov 2013 15:31:30 +0530
Message-ID: <1385373690-12170-11-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385373690-12170-1-git-send-email-kishon@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added device tree bindings for dwc3, usb2 and usb3 PHYs. The documentation
of these can be found at Documentation/devicetree/bindings/phy/phy-bindings.txt
and Documentation/devicetree/bindings/phy/ti-phy.txt.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 29a6354..c135677 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -678,6 +678,8 @@
 				reg = <0x4a030000 0x10000>;
 				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 				usb-phy = <&usb2_phy>, <&usb3_phy>;
+				phys = <&usb2_phy>, <&usb3_phy>;
+				phy-names = "usb2-phy", "usb3-phy";
 				dr_mode = "peripheral";
 				tx-fifo-resize;
 			};
@@ -694,6 +696,7 @@
 				compatible = "ti,omap-usb2";
 				reg = <0x4a084000 0x7c>;
 				ctrl-module = <&omap_control_usb2phy>;
+				#phy-cells = <0>;
 			};
 
 			usb3_phy: usb3phy@4a084400 {
@@ -703,6 +706,7 @@
 				      <0x4a084c00 0x40>;
 				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
 				ctrl-module = <&omap_control_usb3phy>;
+				#phy-cells = <0>;
 			};
 		};
 
-- 
1.7.10.4

