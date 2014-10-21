Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaJUKBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:01:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51261 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaJUKBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:01:13 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH v3 2/2] ARM: dts: dra7-evm: Enable CPSW and MDIO for dra7xx EVM
Date: Tue, 21 Oct 2014 15:31:01 +0530
Message-ID: <1413885661-4850-3-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.1.2.484.g13da0fc
In-Reply-To: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
References: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding CPSW phy-id, CPSW and MDIO pinmux configuration for active and
sleep states and enable them in board evm dts file.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 106 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 518a6c0..3be2630 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -171,6 +171,86 @@
 			0xd0	(PIN_OUTPUT | MUX_MODE0)	/* gpmc_be0n_cle */
 		>;
 	};
+
+	cpsw_default: cpsw_default {
+		pinctrl-single,pins = <
+			/* Slave 1 */
+			0x250 (PIN_OUTPUT | MUX_MODE0)	/* rgmii0_txc.rgmii0_txc */
+			0x254 (PIN_OUTPUT | MUX_MODE0)	/* rgmii0_txctl.rgmii0_txctl */
+			0x258 (PIN_OUTPUT | MUX_MODE0)	/* rgmii0_td3.rgmii0_txd3 */
+			0x25c (PIN_OUTPUT | MUX_MODE0)	/* rgmii0_txd2.rgmii0_txd2 */
+			0x260 (PIN_OUTPUT | MUX_MODE0)	/* rgmii0_txd1.rgmii0_txd1 */
+			0x264 (PIN_OUTPUT | MUX_MODE0)	/* rgmii0_txd0.rgmii0_txd0 */
+			0x268 (PIN_INPUT | MUX_MODE0)	/* rgmii0_rxc.rgmii0_rxc */
+			0x26c (PIN_INPUT | MUX_MODE0)	/* rgmii0_rxctl.rgmii0_rxctl */
+			0x270 (PIN_INPUT | MUX_MODE0)	/* rgmii0_rxd3.rgmii0_rxd3 */
+			0x274 (PIN_INPUT | MUX_MODE0)	/* rgmii0_rxd2.rgmii0_rxd2 */
+			0x278 (PIN_INPUT | MUX_MODE0)	/* rgmii0_rxd1.rgmii0_rxd1 */
+			0x27c (PIN_INPUT | MUX_MODE0)	/* rgmii0_rxd0.rgmii0_rxd0 */
+
+			/* Slave 2 */
+			0x198 (PIN_OUTPUT | MUX_MODE3)	/* vin2a_d12.rgmii1_txc */
+			0x19c (PIN_OUTPUT | MUX_MODE3)	/* vin2a_d13.rgmii1_tctl */
+			0x1a0 (PIN_OUTPUT | MUX_MODE3)	/* vin2a_d14.rgmii1_td3 */
+			0x1a4 (PIN_OUTPUT | MUX_MODE3)	/* vin2a_d15.rgmii1_td2 */
+			0x1a8 (PIN_OUTPUT | MUX_MODE3)	/* vin2a_d16.rgmii1_td1 */
+			0x1ac (PIN_OUTPUT | MUX_MODE3)	/* vin2a_d17.rgmii1_td0 */
+			0x1b0 (PIN_INPUT | MUX_MODE3)	/* vin2a_d18.rgmii1_rclk */
+			0x1b4 (PIN_INPUT | MUX_MODE3)	/* vin2a_d19.rgmii1_rctl */
+			0x1b8 (PIN_INPUT | MUX_MODE3)	/* vin2a_d20.rgmii1_rd3 */
+			0x1bc (PIN_INPUT | MUX_MODE3)	/* vin2a_d21.rgmii1_rd2 */
+			0x1c0 (PIN_INPUT | MUX_MODE3)	/* vin2a_d22.rgmii1_rd1 */
+			0x1c4 (PIN_INPUT | MUX_MODE3)	/* vin2a_d23.rgmii1_rd0 */
+		>;
+
+	};
+
+	cpsw_sleep: cpsw_sleep {
+		pinctrl-single,pins = <
+			/* Slave 1 */
+			0x250 (MUX_MODE15)
+			0x254 (MUX_MODE15)
+			0x258 (MUX_MODE15)
+			0x25c (MUX_MODE15)
+			0x260 (MUX_MODE15)
+			0x264 (MUX_MODE15)
+			0x268 (MUX_MODE15)
+			0x26c (MUX_MODE15)
+			0x270 (MUX_MODE15)
+			0x274 (MUX_MODE15)
+			0x278 (MUX_MODE15)
+			0x27c (MUX_MODE15)
+
+			/* Slave 2 */
+			0x198 (MUX_MODE15)
+			0x19c (MUX_MODE15)
+			0x1a0 (MUX_MODE15)
+			0x1a4 (MUX_MODE15)
+			0x1a8 (MUX_MODE15)
+			0x1ac (MUX_MODE15)
+			0x1b0 (MUX_MODE15)
+			0x1b4 (MUX_MODE15)
+			0x1b8 (MUX_MODE15)
+			0x1bc (MUX_MODE15)
+			0x1c0 (MUX_MODE15)
+			0x1c4 (MUX_MODE15)
+		>;
+	};
+
+	davinci_mdio_default: davinci_mdio_default {
+		pinctrl-single,pins = <
+			0x23c (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* mdio_d.mdio_d */
+			0x240 (PIN_INPUT_PULLUP | MUX_MODE0)	/* mdio_clk.mdio_clk */
+		>;
+	};
+
+	davinci_mdio_sleep: davinci_mdio_sleep {
+		pinctrl-single,pins = <
+			0x23c (MUX_MODE15)
+			0x240 (MUX_MODE15)
+		>;
+	};
+
 };
 
 &i2c1 {
@@ -528,3 +608,29 @@
 	ti,no-reset-on-init;
 	ti,no-idle-on-init;
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
2.1.2.484.g13da0fc

