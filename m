Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbaEMIo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:44:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57329 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbaEMIok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:44:40 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 2/2] ARM: dts: am437x-gp-evm: Add ethernet support for GP EVM
Date: Tue, 13 May 2014 14:14:31 +0530
Message-ID: <1399970671-29203-3-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
In-Reply-To: <1399970671-29203-1-git-send-email-mugunthanvnm@ti.com>
References: <1399970671-29203-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CPSW ethernet support for AM437x GP EVM which has one slave pinned out

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/am437x-gp-evm.dts | 72 +++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index 4e92d9e..8dc1c6e 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -98,6 +98,58 @@
 			0x264 (PIN_INPUT_PULLUP | MUX_MODE7)  /* spi2_d0.gpio3_22 */
 		>;
 	};
+
+	cpsw_default: cpsw_default {
+		pinctrl-single,pins = <
+			/* Slave 1 */
+			0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txen.rgmii1_txen */
+			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxdv.rgmii1_rxctl */
+			0x11c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_txd3 */
+			0x120 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_txd2 */
+			0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_txd1 */
+			0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_txd0 */
+			0x12c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txclk.rmii1_tclk */
+			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxclk.rmii1_rclk */
+			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rxd3 */
+			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rxd2 */
+			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rxd1 */
+			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rxd0 */
+		>;
+	};
+
+	cpsw_sleep: cpsw_sleep {
+		pinctrl-single,pins = <
+			/* Slave 1 reset value */
+			0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x11c (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x120 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x12c (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+		>;
+	};
+
+	davinci_mdio_default: davinci_mdio_default {
+		pinctrl-single,pins = <
+			/* MDIO */
+			0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.mdio_data */
+			0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
+		>;
+	};
+
+	davinci_mdio_sleep: davinci_mdio_sleep {
+		pinctrl-single,pins = <
+			/* MDIO reset value */
+			0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
+			0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
+		>;
+	};
 };
 
 &i2c0 {
@@ -179,3 +231,23 @@
 	dr_mode = "host";
 	status = "okay";
 };
+
+&mac {
+	slaves = <1>;
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&cpsw_default>;
+	pinctrl-1 = <&cpsw_sleep>;
+	status = "okay";
+};
+
+&davinci_mdio {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&davinci_mdio_default>;
+	pinctrl-1 = <&davinci_mdio_sleep>;
+	status = "okay";
+};
+
+&cpsw_emac0 {
+	phy_id = <&davinci_mdio>, <0>;
+	phy-mode = "rgmii";
+};
-- 
1.9.2.459.g68773ac

