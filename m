Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaEURgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:36:41 -0400
Received: from ring0.de ([5.45.105.125]:57856 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaEURgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:36:38 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv4 4/4] DTS: ARM: OMAP3-N900: Add tsc2005 support
Date: Wed, 21 May 2014 19:36:14 +0200
Message-Id: <1400693774-21306-5-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400693774-21306-1-git-send-email-sre@kernel.org>
References: <1400693774-21306-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the tsc2005 touchscreen
to the Nokia N900 DTS file.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 1a57b61..cb8ed2d5 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -580,9 +580,24 @@
 	 * Also... order in the device tree actually matters here.
 	 */
 	tsc2005@0 {
-		compatible = "tsc2005";
+		compatible = "ti,tsc2005";
 		spi-max-frequency = <6000000>;
 		reg = <0>;
+
+		vio-supply = <&vio>;
+
+		reset-gpios = <&gpio4 8 GPIO_ACTIVE_HIGH>; /* 104 */
+		interrupts-extended = <&gpio4 4 IRQ_TYPE_EDGE_RISING>; /* 100 */
+
+		touchscreen-fuzz-x = <4>;
+		touchscreen-fuzz-y = <7>;
+		touchscreen-fuzz-pressure = <2>;
+		touchscreen-max-x = <4096>;
+		touchscreen-max-y = <4096>;
+		touchscreen-max-pressure = <2048>;
+
+		ti,x-plate-ohms = <280>;
+		ti,esd-recovery-timeout-ms = <8000>;
 	};
 
 	acx565akm@2 {
-- 
2.0.0.rc2

