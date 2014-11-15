Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaKOBri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:47:38 -0500
Received: from ring0.de ([5.45.105.125]:56448 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbaKOBrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:47:37 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCH] ARM: DTS: OMAP3-N900: add si4713 support
Date: Sat, 15 Nov 2014 02:47:30 +0100
Message-Id: <1416016050-4252-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add si4713 node to the N900 device tree file.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 9b0494a..81c99f3 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -540,6 +540,16 @@
 		power-gpio = <&gpio4 2 GPIO_ACTIVE_HIGH>; /* 98 */
 	};
 
+	si4713: si4713@63 {
+		compatible = "silabs,si4713";
+                reg = <0x63>;
+
+                interrupts-extended = <&gpio2 21 IRQ_TYPE_EDGE_FALLING>; /* 53 */
+                reset-gpios = <&gpio6 3 GPIO_ACTIVE_HIGH>; /* 163 */
+                vio-supply = <&vio>;
+                vdd-supply = <&vaux1>;
+	};
+
 	bq24150a: bq24150a@6b {
 		compatible = "ti,bq24150a";
 		reg = <0x6b>;
-- 
2.1.1

