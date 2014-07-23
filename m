Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaGWNY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:24:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51978 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaGWNYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:24:55 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 3/3] arm/dts: dra7xx: Enable CPSW and MDIO for dra7xx EVM
Date: Wed, 23 Jul 2014 18:54:42 +0530
Message-ID: <1406121882-32658-4-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.2.673.g9ab0882
In-Reply-To: <1406121882-32658-1-git-send-email-mugunthanvnm@ti.com>
References: <1406121882-32658-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding CPSW phy-id, CPSW and MDIO pinmux configuration for active and
sleep states and enable them in board evm dts file.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 105 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 50f8022..743feef 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -149,6 +149,85 @@
 			0xc4	(PIN_OUTPUT | MUX_MODE0)	/* gpmc_advn_ale */
 			0xc8	(PIN_OUTPUT | MUX_MODE0)	/* gpmc_oen_ren	 */
 			0xd0	(PIN_OUTPUT | MUX_MODE0)	/* gpmc_be0n_cle */
+                >;
+	};
+
+	cpsw_default: cpsw_default {
+		pinctrl-single,pins = <
+			/* Slave 1 */
+			0x250 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_tclk */
+			0x254 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_tctl */
+			0x258 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td3 */
+			0x25c (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td2 */
+			0x260 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td1 */
+			0x264 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td0 */
+			0x268 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rclk */
+			0x26c (PIN_INPUT | MUX_MODE0)	/* rgmii1_rctl */
+			0x270 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd3 */
+			0x274 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd2 */
+			0x278 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd1 */
+			0x27c (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd0 */
+
+			/* Slave 2 */
+			0x198 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_tclk */
+			0x19c (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_tctl */
+			0x1a0 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td3 */
+			0x1a4 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td2 */
+			0x1a8 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td1 */
+			0x1ac (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td0 */
+			0x1b0 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rclk */
+			0x1b4 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rctl */
+			0x1b8 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd3 */
+			0x1bc (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd2 */
+			0x1c0 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd1 */
+			0x1c4 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd0 */
+		>;
+	};
+
+	cpsw_sleep: cpsw_sleep {
+		pinctrl-single,pins = <
+			/* Slave 1 */
+			0x250 (PIN_OFF_NONE)
+			0x254 (PIN_OFF_NONE)
+			0x258 (PIN_OFF_NONE)
+			0x25c (PIN_OFF_NONE)
+			0x260 (PIN_OFF_NONE)
+			0x264 (PIN_OFF_NONE)
+			0x268 (PIN_OFF_NONE)
+			0x26c (PIN_OFF_NONE)
+			0x270 (PIN_OFF_NONE)
+			0x274 (PIN_OFF_NONE)
+			0x278 (PIN_OFF_NONE)
+			0x27c (PIN_OFF_NONE)
+
+			/* Slave 1 */
+			0x198 (PIN_OFF_NONE)
+			0x19c (PIN_OFF_NONE)
+			0x1a0 (PIN_OFF_NONE)
+			0x1a4 (PIN_OFF_NONE)
+			0x1a8 (PIN_OFF_NONE)
+			0x1ac (PIN_OFF_NONE)
+			0x1b0 (PIN_OFF_NONE)
+			0x1b4 (PIN_OFF_NONE)
+			0x1b8 (PIN_OFF_NONE)
+			0x1bc (PIN_OFF_NONE)
+			0x1c0 (PIN_OFF_NONE)
+			0x1c4 (PIN_OFF_NONE)
+		>;
+	};
+
+	davinci_mdio_default: davinci_mdio_default {
+		pinctrl-single,pins = <
+			/* MDIO */
+			0x23c (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* mdio_data */
+			0x240 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mdio_clk */
+		>;
+	};
+
+	davinci_mdio_sleep: davinci_mdio_sleep {
+		pinctrl-single,pins = <
+			0x23c (PIN_OFF_NONE)
+			0x240 (PIN_OFF_NONE)
 		>;
 	};
 };
@@ -504,3 +583,29 @@
 &usb2_phy2 {
 	phy-supply = <&ldousb_reg>;
 };
+
+&mac {
+	status = "okay";
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&cpsw_default>;
+	pinctrl-1 = <&cpsw_sleep>;
+	dual_emac;
+};
+
+&cpsw_emac0 {
+	phy_id = <&davinci_mdio>, <2>;
+	phy-mode = "rgmii";
+	dual_emac_res_vlan = <1>;
+};
+
+&cpsw_emac1 {
+	phy_id = <&davinci_mdio>, <3>;
+	phy-mode = "rgmii";
+	dual_emac_res_vlan = <2>;
+};
+
+&davinci_mdio {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&davinci_mdio_default>;
+	pinctrl-1 = <&davinci_mdio_sleep>;
+};
-- 
2.0.2.673.g9ab0882

