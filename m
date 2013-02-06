Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3BFO6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:58:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50169 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab3BFO5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:57:20 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH 6/8] ARM: dts: omap5: Add omap-usb3 and omap-usb2 dt data
Date: Wed, 6 Feb 2013 20:26:42 +0530
Message-ID: <1360162604-14320-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360162604-14320-1-git-send-email-kishon@ti.com>
References: <1360162604-14320-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omap-usb3 and omap-usb2 data node in omap5 device tree file.
The information for the node added here is available @
Documentation/devicetree/bindings/usb/usb-phy.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 230b779..bd73257 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -511,6 +511,20 @@
 			#size-cells = <1>;
 			ranges;
 			ti,hwmods = "ocp2scp1";
+			usb2_phy: usb2phy@4a084000 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a084000 0x7c>;
+				ctrl-module = <&omap_control_usb>;
+			};
+
+			usb3_phy: usb3phy@4a084400 {
+				compatible = "ti,omap-usb3";
+				reg = <0x4a084400 0x80>,
+				      <0x4a084800 0x64>,
+				      <0x4a084c00 0x40>;
+				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
+				ctrl-module = <&omap_control_usb>;
+			};
 		};
 	};
 };
-- 
1.7.10.4

