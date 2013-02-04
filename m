Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3BDIwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:52:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51410 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3BDIwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:52:36 -0500
From: Sourav Poddar <sourav.poddar@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <santosh.shilimkar@ti.com>
CC: Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCHv2 2/2] arm: dts: omap5-evm: Add mcspi data
Date: Mon, 4 Feb 2013 14:22:18 +0530
Message-ID: <1359967938-26718-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mcspi node and pinmux data for omap5 mcspi controller.

Tested on omap5430 evm with 3.8-rc4 custom kernel.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
v1->v2
Pinctrl nodes were pointing to a different parent.
Fixing the same.
 arch/arm/boot/dts/omap5-evm.dts |   46 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
index 8722c15..3625c5c 100644
--- a/arch/arm/boot/dts/omap5-evm.dts
+++ b/arch/arm/boot/dts/omap5-evm.dts
@@ -80,6 +80,33 @@
 			0x15a 0x100	/* abemcbsp2_clkx.abemcbsp2_clkx INPUT | MODE0 */
 		>;
 	};
+
+	mcspi2_pins: pinmux_mcspi2_pins {
+		pinctrl-single,pins = <
+			0xbc 0x100
+			0xbe 0x100
+			0xc0 0x118
+			0xc2 0x0
+		>;
+	};
+
+	mcspi3_pins: pinmux_mcspi3_pins {
+		pinctrl-single,pins = <
+			0x78 0x101
+			0x7a 0x101
+			0x7c 0x101
+			0x7e 0x101
+		>;
+	};
+
+	mcspi4_pins: pinmux_mcspi4_pins {
+		pinctrl-single,pins = <
+			0x164 0x101
+			0x168 0x101
+			0x16a 0x101
+			0x16c 0x101
+		>;
+	};
 };
 
 &mmc1 {
@@ -151,3 +178,22 @@
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

