Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaE1I6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:58:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbaE1I6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:58:03 -0400
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>, <tony@atomide.com>
CC: <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        Satish Patel <satish.patel@ti.com>
Subject: [PATCH v3 5/5] ARM: dts: AM43xx-epos-evm: DT entries  for ti-usim and phy
Date: Wed, 28 May 2014 14:27:17 +0530
Message-ID: <1401267437-22489-6-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Board specific DT entries for TI's USIM - smart card controller of AM43xx
platfrom.These entries are used by USIM driver for various configurations.

- Shutdown line of NXP phy is maped to GPIO5. So enabling same to have support
for NXP phy.

- i2c2 pinmux configuration -  NxP tda8026 phy is connected to i2c2 lines

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 167dbc8..ecc8b1a 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -115,6 +115,18 @@
 			>;
 		};
 
+		usim0_default: usim0_default {
+		       pinctrl-single,pins = <
+			       /* USIM 0 */
+			       0x1B4 (SLEWCTRL_FAST | PULL_DISABLE | MUX_MODE8)		/* CLK0  */
+			       0x1B0 (SLEWCTRL_FAST | PULL_DISABLE | MUX_MODE8)		/* CLK1  */
+			       0x1B8 (SLEWCTRL_FAST | INPUT_EN | PULL_DISABLE | MUX_MODE8)	/* DATA0 */
+			       0x1BC (SLEWCTRL_FAST | INPUT_EN | PULL_DISABLE | MUX_MODE8)	/* DATA1 */
+			       0x1C8 (SLEWCTRL_FAST | INPUT_EN | PULL_UP | MUX_MODE8)		/* IRQn  */
+			       >;
+	       };
+
+
 		spi0_pins: pinmux_spi0_pins {
 			pinctrl-single,pins = <
 				0x150 (PIN_INPUT | MUX_MODE0)           /* spi0_clk.spi0_clk */
@@ -238,10 +250,24 @@
 	};
 };
 
+&usim0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&usim0_default>;
+	phy = <&tda8026>;
+	phy-slots = <1>;
+	status = "okay";
+};
+
 &i2c2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins>;
 	status = "okay";
+	tda8026: tda8026@48 {
+		compatible = "nxp,tda8026";
+		reg = <0x48>;
+		shutdown-gpio = <&gpio5 19 GPIO_ACTIVE_HIGH>;   /* Bank5, pin19 */
+		interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
+	};
 };
 
 &gpio0 {
@@ -260,6 +286,11 @@
 	status = "okay";
 };
 
+&gpio5 {
+	status = "okay";
+};
+
+
 &elm {
 	status = "okay";
 };
-- 
1.7.9.5

