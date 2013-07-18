Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3GRIyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:54:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39336 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab3GRIxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:53:53 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <benoit.cousson@linaro.org>
CC: <p.zabel@pengutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/6] ARM: dts: omap3-beagle: Use reset-gpio driver for hsusb2_reset
Date: Thu, 18 Jul 2013 11:53:06 +0300
Message-ID: <1374137590-17865-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1374137590-17865-1-git-send-email-rogerq@ti.com>
References: <1374137590-17865-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer need to model a RESET line as a regulator since
we have the reset-gpio driver available.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index dfd8310..01fbad6 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -45,14 +45,12 @@
 	};
 
 	/* HS USB Port 2 RESET */
-	hsusb2_reset: hsusb2_reset_reg {
-		compatible = "regulator-fixed";
-		regulator-name = "hsusb2_reset";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpio5 19 0>;	/* gpio_147 */
-		startup-delay-us = <70000>;
-		enable-active-high;
+	hsusb2_reset: hsusb2_reset {
+		compatible = "gpio-reset";
+		reset-gpios = <&gpio5 19 GPIO_ACTIVE_LOW>; /* gpio_147 */
+		reset-delay-us = <70000>;
+		initially-in-reset;
+		#reset-cells = <0>;
 	};
 
 	/* HS USB Port 2 Power */
@@ -68,7 +66,8 @@
 	/* HS USB Host PHY on PORT 2 */
 	hsusb2_phy: hsusb2_phy {
 		compatible = "usb-nop-xceiv";
-		reset-supply = <&hsusb2_reset>;
+		resets = <&hsusb2_reset>;
+		reset-names = "reset";
 		vcc-supply = <&hsusb2_power>;
 	};
 
-- 
1.7.4.1

