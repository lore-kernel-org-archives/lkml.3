Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3IXI4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:56:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46225 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab3IXIyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:54:47 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <p.zabel@pengutronix.de>, <broonie@kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 06/10] ARM: dts: omap4-panda: Use reset-gpios for hsusb1_reset
Date: Tue, 24 Sep 2013 11:53:52 +0300
Message-ID: <1380012836-29900-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1380012836-29900-1-git-send-email-rogerq@ti.com>
References: <1380012836-29900-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer need to model the RESET line as a regulator since
the USB phy-nop driver accepts "reset-gpios" property.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index faa95b5..c60ebd0 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -60,22 +60,6 @@
 			"AFMR", "Line In";
 	};
 
-	/*
-	 * Temp hack: Need to be replaced with the proper gpio-controlled
-	 * reset driver as soon it will be merged.
-	 * http://thread.gmane.org/gmane.linux.drivers.devicetree/36830
-	 */
-	/* HS USB Port 1 RESET */
-	hsusb1_reset: hsusb1_reset_reg {
-		compatible = "regulator-fixed";
-		regulator-name = "hsusb1_reset";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpio2 30 0>;	/* gpio_62 */
-		startup-delay-us = <70000>;
-		enable-active-high;
-	};
-
 	/* HS USB Port 1 Power */
 	hsusb1_power: hsusb1_power_reg {
 		compatible = "regulator-fixed";
@@ -97,7 +81,7 @@
 	/* HS USB Host PHY on PORT 1 */
 	hsusb1_phy: hsusb1_phy {
 		compatible = "usb-nop-xceiv";
-		reset-supply = <&hsusb1_reset>;
+		reset-gpios = <&gpio2 30 GPIO_ACTIVE_LOW>;   /* gpio_62 */
 		vcc-supply = <&hsusb1_power>;
 	/**
 	 * FIXME:
-- 
1.7.4.1

