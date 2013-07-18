Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3GRIzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:55:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab3GRIxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:53:55 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <benoit.cousson@linaro.org>
CC: <p.zabel@pengutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 3/6] ARM: dts: omap4-panda: Use reset-gpio driver for hsusb1_reset
Date: Thu, 18 Jul 2013 11:53:07 +0300
Message-ID: <1374137590-17865-4-git-send-email-rogerq@ti.com>
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
 arch/arm/boot/dts/omap4-panda-common.dtsi |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index faa95b5..e9b0a91 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -60,20 +60,13 @@
 			"AFMR", "Line In";
 	};
 
-	/*
-	 * Temp hack: Need to be replaced with the proper gpio-controlled
-	 * reset driver as soon it will be merged.
-	 * http://thread.gmane.org/gmane.linux.drivers.devicetree/36830
-	 */
 	/* HS USB Port 1 RESET */
-	hsusb1_reset: hsusb1_reset_reg {
-		compatible = "regulator-fixed";
-		regulator-name = "hsusb1_reset";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpio2 30 0>;	/* gpio_62 */
-		startup-delay-us = <70000>;
-		enable-active-high;
+	hsusb1_reset: hsusb1_reset {
+		compatible = "gpio-reset";
+		reset-gpios = <&gpio2 30 GPIO_ACTIVE_LOW>; /* gpio_62 */
+		reset-delay-us = <70000>;
+		initially-in-reset;
+		#reset-cells = <0>;
 	};
 
 	/* HS USB Port 1 Power */
@@ -97,7 +90,8 @@
 	/* HS USB Host PHY on PORT 1 */
 	hsusb1_phy: hsusb1_phy {
 		compatible = "usb-nop-xceiv";
-		reset-supply = <&hsusb1_reset>;
+		resets = <&hsusb1_reset>;
+		reset-names = "reset";
 		vcc-supply = <&hsusb1_power>;
 	/**
 	 * FIXME:
-- 
1.7.4.1

