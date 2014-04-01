Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaDAKhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:37:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45530 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaDAKhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:37:36 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <kishon@ti.com>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/1] ARM: dts: omap5: Add clocks to USB3 PHY node
Date: Tue, 1 Apr 2014 13:37:27 +0300
Message-ID: <1396348647-11545-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396348647-11545-1-git-send-email-rogerq@ti.com>
References: <1396348647-11545-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB3 PHY driver (ti-pipe3) was updated so that the relevant
clock phandles are expected in the DT node.
Provide the necessary clocks.

Reported-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 757f0b9..4df1e7a 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -794,6 +794,12 @@
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

