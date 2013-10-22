Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3JVLoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:44:11 -0400
Received: from ring0.de ([91.143.88.219]:35786 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab3JVLoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:44:10 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH] DTS: ARM: OMAP3-N900: Add support for SD cards
Date: Tue, 22 Oct 2013 13:43:58 +0200
Message-Id: <1382442238-24637-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for external SD card slot.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 99d0668..ab62afa 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -65,6 +65,17 @@
 			0x194 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c3_sda */
 		>;
 	};
+
+	mmc1_pins: pinmux_mmc1_pins {
+		pinctrl-single,pins = <
+			0x114 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_clk */
+			0x116 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_cmd */
+			0x118 (PIN_INPUT_PULLUP | MUX_MODE0) 	/* sdmmc1_dat0 */
+			0x11a (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat1 */
+			0x11c (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat2 */
+			0x11e (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat3 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -103,7 +114,11 @@
 };
 
 &mmc1 {
-	status = "disabled";
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	vmmc-supply = <&vmmc1>;
+	bus-width = <4>;
+	cd-gpios = <&gpio6 0 GPIO_ACTIVE_HIGH>; /* 160 */
 };
 
 &mmc2 {
-- 
1.8.4.rc3

