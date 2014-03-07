Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaCGKPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:15:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53181 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaCGKPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:15:48 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balajitk@ti.com>,
        <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v3 4/8] ARM: dts: omap5: Add clocks to USB3 PHY node
Date: Fri, 7 Mar 2014 12:15:04 +0200
Message-ID: <1394187308-19622-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394187308-19622-1-git-send-email-rogerq@ti.com>
References: <1394187308-19622-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB3 PHY driver now expects named clocks. Add the
relevant clocks to the USB3 PHY node.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 859a800..88bd327 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -779,6 +779,12 @@
 				      <0x4a084c00 0x40>;
 				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
 				ctrl-module = <&omap_control_usb3phy>;
+				clocks = <&usb_phy_cm_clk32k>,
+					 <&sys_clkin>,
+					 <&usb_otg_ss_refclk960m>;
+				clock-names =	"wkupclk",
+						"sysclk",
+						"refclk";
 				#phy-cells = <0>;
 			};
 		};
-- 
1.8.3.2

