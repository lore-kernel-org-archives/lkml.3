Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab3FTMqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:46:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44768 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3FTMqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:46:44 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v5 2/2] ARM: dts: omap3-beagle: Make USB host pin naming consistent
Date: Thu, 20 Jun 2013 15:46:14 +0300
Message-ID: <1371732374-27191-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371732374-27191-1-git-send-email-rogerq@ti.com>
References: <1371732374-27191-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a common naming scheme "mode0name.modename flags" for the
USB host pins to be consistent.

Also add a disclaimer stating that use of regulator framework
for GPIO RESET line is temporary.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index dfd8310..587781a 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -44,6 +44,11 @@
 		};
 	};
 
+	/*
+	 * Temp hack: Need to be replaced with the proper gpio-controlled
+	 * reset driver as soon it will be merged.
+	 * http://thread.gmane.org/gmane.linux.drivers.devicetree/36830
+	 */
 	/* HS USB Port 2 RESET */
 	hsusb2_reset: hsusb2_reset_reg {
 		compatible = "regulator-fixed";
@@ -101,18 +106,18 @@
 
 	hsusbb2_pins: pinmux_hsusbb2_pins {
 		pinctrl-single,pins = <
-			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* usbb2_ulpitll_clk.usbb1_ulpiphy_clk */
-			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* usbb2_ulpitll_clk.usbb1_ulpiphy_stp */
-			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dir */
-			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_nxt */
-			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat0 */
-			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat1 */
-			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat2 */
-			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat3 */
-			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat4 */
-			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat5 */
-			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat6 */
-			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat7 */
+			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
+			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
+			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
+			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
+			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
+			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
+			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
 		>;
 	};
 
-- 
1.7.4.1

