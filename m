Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3JVLF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:05:26 -0400
Received: from ring0.de ([91.143.88.219]:35606 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3JVLFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:05:25 -0400
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
Subject: [PATCH] DTS: ARM: OMAP3-N900: Add UART support
Date: Tue, 22 Oct 2013 13:05:13 +0200
Message-Id: <1382439913-16534-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UART support to Nokia N900.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 2374b9a..99d0668 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -31,6 +31,20 @@
 &omap3_pmx_core {
 	pinctrl-names = "default";
 
+	uart2_pins: pinmux_uart2_pins {
+		pinctrl-single,pins = <
+			0x14a (PIN_INPUT | MUX_MODE0)		/* uart2_rx */
+			0x148 (PIN_OUTPUT | MUX_MODE0)		/* uart2_tx */
+		>;
+	};
+
+	uart3_pins: pinmux_uart3_pins {
+		pinctrl-single,pins = <
+			0x16e (PIN_INPUT | MUX_MODE0)		/* uart3_rx */
+			0x170 (PIN_OUTPUT | MUX_MODE0)		/* uart3_tx */
+		>;
+	};
+
 	i2c1_pins: pinmux_i2c1_pins {
 		pinctrl-single,pins = <
 			0x18a (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c1_scl */
@@ -125,3 +139,17 @@
 	mode = <2>;
 	power = <50>;
 };
+
+&uart1 {
+	status = "disabled";
+};
+
+&uart2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart2_pins>;
+};
+
+&uart3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart3_pins>;
+};
-- 
1.8.4.rc3

