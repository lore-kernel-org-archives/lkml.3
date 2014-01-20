Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaATEe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:34:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54398 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbaATEek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:34:40 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>
CC: Satish Patel <satish.patel@ti.com>
Subject: [PATCH v2 5/5] ARM: dts: AM43xx-epos-evm: DT entries  for ti-usim and phy
Date: Mon, 20 Jan 2014 10:03:54 +0530
Message-ID: <1390192434-19386-6-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
References: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
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
 arch/arm/boot/dts/am43x-epos-evm.dts |   43 ++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index fbf9c4c..38ef2b8 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -79,6 +79,24 @@
 				0x18c (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* i2c0_scl.i2c0_scl */
 			>;
 		};
+
+		i2c2_pins: pinmux_i2c2_pins {
+		   pinctrl-single,pins = <
+			   0x1c0 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE8)    /* i2c2_sda.i2c2_sda */
+			   0x1c4 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE8)    /* i2c2_scl.i2c2_scl */
+			   >;
+		};
+
+		usim0_default: usim0_default {
+		       pinctrl-single,pins = <
+			       /* USIM 0 */
+			       0x1B4 (SLEWCTRL_FAST | PULL_DISABLE | MUX_MODE8)		/* CLK0  */
+			       0x1B0 (SLEWCTRL_FAST | PULL_DISABLE | MUX_MODE8)		/* CLK1  */
+			       0x1B8 (SLEWCTRL_FAST | INPUT_EN | PULL_DISABLE | MUX_MODE8)	/* DATA0 */
+			       0x1BC (SLEWCTRL_FAST | INPUT_EN | PULL_DISABLE | MUX_MODE8)	/* DATA1 */
+			       0x1C8 (SLEWCTRL_FAST | INPUT_EN | PULL_UP | MUX_MODE8)		/* IRQn  */
+			       >;
+		};
 	};
 
 	matrix_keypad: matrix_keypad@0 {
@@ -169,6 +187,27 @@
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
+&i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
+	status = "okay";
+
+	tda8026: tda8026@48 {
+		compatible = "nxp,tda8026";
+		reg = <0x48>;
+		shutdown-gpio = <&gpio5 19 GPIO_ACTIVE_HIGH>;   /* Bank5, pin19 */
+		interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
+	};
+};
+
 &gpio0 {
 	status = "okay";
 };
@@ -184,3 +223,7 @@
 &gpio3 {
 	status = "okay";
 };
+
+&gpio5 {
+	status = "okay";
+};
-- 
1.7.1

