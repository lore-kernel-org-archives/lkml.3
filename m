Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab3JOT4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:56:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34793 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759818Ab3JOTz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:55:58 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 7/7] arm/dts: added dt properties to adapt to the new phy framwork
Date: Wed, 16 Oct 2013 01:24:17 +0530
Message-ID: <1381866857-3861-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1381866857-3861-1-git-send-email-kishon@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
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
 arch/arm/boot/dts/omap5.dtsi |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index edc801f..998f198 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -661,7 +661,8 @@
 				compatible = "snps,dwc3";
 				reg = <0x4a030000 0x10000>;
 				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
-				usb-phy = <&usb2_phy>, <&usb3_phy>;
+				phys = <&usb2_phy>, <&usb3_phy>;
+				phy-names = "usb2-phy", "usb3-phy";
 				tx-fifo-resize;
 			};
 		};
@@ -677,6 +678,7 @@
 				compatible = "ti,omap-usb2";
 				reg = <0x4a084000 0x7c>;
 				ctrl-module = <&omap_control_usb2phy>;
+				#phy-cells = <0>;
 			};
 
 			usb3_phy: usb3phy@4a084400 {
@@ -686,6 +688,7 @@
 				      <0x4a084c00 0x40>;
 				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
 				ctrl-module = <&omap_control_usb3phy>;
+				#phy-cells = <0>;
 			};
 		};
 
-- 
1.7.10.4

