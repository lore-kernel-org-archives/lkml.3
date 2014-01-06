Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaAFMJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:09:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39655 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaAFMI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:08:26 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <rob@landley.net>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>
Subject: [RFC PATCH v1 5/5] ARM: dts: AM43xx-epos-evm: DT entries  for ti-usim
Date: Mon, 6 Jan 2014 17:37:42 +0530
Message-ID: <1389010062-17185-6-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1389010062-17185-1-git-send-email-satish.patel@ti.com>
References: <1389010062-17185-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Board specific DT entries for TI's USIM - smart card controller of AM43xx
platfrom.These entries are used by USIM driver for various configurations.

Shutdown line of NXP phy is maped to GPIO5. So enabling same to have support
for NXP phy.

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index f20559b..4ca3460 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -202,6 +202,17 @@
 		>;
 	};
 
+	usim0_default: usim0_default {
+		pinctrl-single,pins = <
+			/* USIM 0 */
+			0x1B4 (SLEWCTRL_FAST | PULL_DISABLE | MUX_MODE8)		/* CLK0  */
+			0x1B0 (SLEWCTRL_FAST | PULL_DISABLE | MUX_MODE8)		/* CLK1  */
+			0x1B8 (SLEWCTRL_FAST | INPUT_EN | PULL_DISABLE | MUX_MODE8)	/* DATA0 */
+			0x1BC (SLEWCTRL_FAST | INPUT_EN | PULL_DISABLE | MUX_MODE8)	/* DATA1 */
+			0x1C8 (SLEWCTRL_FAST | INPUT_EN | PULL_UP | MUX_MODE8)		/* IRQn  */
+			>;
+		};
+
 	spi0_pins: pinmux_spi0_pins {
 		pinctrl-single,pins = <
 			0x150 (PIN_INPUT | MUX_MODE0)           /* spi0_clk.spi0_clk */
@@ -328,6 +339,11 @@
 	status = "okay";
 };
 
+&gpio5 {
+	status = "okay";
+};
+
+
 &dpi {
 	pinctrl-names = "default";
 	pinctrl-0 = <&dss_pinctrl>;
@@ -478,6 +494,14 @@
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
@@ -490,6 +514,12 @@
 		video-source = <&dpi>;
 		data-lines = <24>;
 	};
+	tda8026: tda8026@48 {
+		compatible = "nxp,tda8026";
+		reg = <0x48>;
+		shutdown-gpio = <&gpio5 19 GPIO_ACTIVE_HIGH>;   /* Bank5, pin19 */
+		interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
+	};
 };
 
 &spi0 {
-- 
1.7.1

