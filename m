Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3BMJ25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:28:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57981 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab3BMJ2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:28:54 -0500
From: Sourav Poddar <sourav.poddar@ti.com>
To: <balbi@ti.com>, <santosh.shilimkar@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 5/5] arm: dts: omap5-evm: Add mcspi data
Date: Wed, 13 Feb 2013 14:58:44 +0530
Message-ID: <1360747724-1601-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mcspi node and pinmux data for omap5 mcspi controller.

Tested on omap5430 evm with 3.8-rc6 custom kernel.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/boot/dts/omap5-evm.dts |   46 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
index a4784be..64edd51 100644
--- a/arch/arm/boot/dts/omap5-evm.dts
+++ b/arch/arm/boot/dts/omap5-evm.dts
@@ -115,6 +115,33 @@
 			0x186 0x100     /* i2c5_sda INPUTENABLE | MODE0 */
 		>;
 	};
+
+	mcspi2_pins: pinmux_mcspi2_pins {
+		pinctrl-single,pins = <
+			0xbc 0x100	/*  MCSPI2_CLK INPUTENABLE | MODE0 */
+			0xbe 0x100	/*  MCSPI2_SIMO INPUTENABLE | MODE0 */
+			0xc0 0x118	/*  MCSPI2_SOMI PULLUP | INPUTENABLE | MODE0*/
+			0xc2 0x0	/*  MCSPI2_CS MODE0*/
+		>;
+	};
+
+	mcspi3_pins: pinmux_mcspi3_pins {
+		pinctrl-single,pins = <
+			0x78 0x101	/*  MCSPI2_SOMI INPUTENABLE | MODE1 */
+			0x7a 0x101	/*  MCSPI2_CS INPUTENABLE | MODE1 */
+			0x7c 0x101	/*  MCSPI2_SIMO INPUTENABLE | MODE1 */
+			0x7e 0x101	/*  MCSPI2_CLK INPUTENABLE | MODE1 */
+		>;
+	};
+
+	mcspi4_pins: pinmux_mcspi4_pins {
+		pinctrl-single,pins = <
+			0x164 0x101	/*  MCSPI2_CLK INPUTENABLE | MODE1 */
+			0x168 0x101	/*  MCSPI2_SIMO INPUTENABLE | MODE1 */
+			0x16a 0x101	/*  MCSPI2_SOMI INPUTENABLE | MODE1 */
+			0x16c 0x101	/*  MCSPI2_CS INPUTENABLE | MODE1 */
+		>;
+	};
 };
 
 &mmc1 {
@@ -213,3 +240,22 @@
 	cs1-used;
 	device-handle = <&samsung_K3PE0E000B>;
 };
+
+&mcspi1 {
+
+};
+
+&mcspi2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcspi2_pins>;
+};
+
+&mcspi3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcspi3_pins>;
+};
+
+&mcspi4 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcspi4_pins>;
+};
-- 
1.7.1

