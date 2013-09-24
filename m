Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3IXI5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:57:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46223 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab3IXIyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:54:44 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <p.zabel@pengutronix.de>, <broonie@kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 07/10] ARM: dts: omap5-uevm: Use reset-gpios for hsusb2/3_reset
Date: Tue, 24 Sep 2013 11:53:53 +0300
Message-ID: <1380012836-29900-8-git-send-email-rogerq@ti.com>
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
 arch/arm/boot/dts/omap5-uevm.dts |   26 ++------------------------
 1 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 65d7b60..506bdc2 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -27,21 +27,10 @@
 		regulator-max-microvolt = <3000000>;
 	};
 
-	/* HS USB Port 2 RESET */
-	hsusb2_reset: hsusb2_reset_reg {
-		compatible = "regulator-fixed";
-		regulator-name = "hsusb2_reset";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpio3 16 GPIO_ACTIVE_HIGH>; /* gpio3_80 HUB_NRESET */
-		startup-delay-us = <70000>;
-		enable-active-high;
-	};
-
 	/* HS USB Host PHY on PORT 2 */
 	hsusb2_phy: hsusb2_phy {
 		compatible = "usb-nop-xceiv";
-		reset-supply = <&hsusb2_reset>;
+		reset-gpios = <&gpio3 16 GPIO_ACTIVE_LOW>; /* gpio3_80 HUB_NRESET */
 	/**
 	  * FIXME
 	  * Put the right clock phandle here when available
@@ -51,21 +40,10 @@
 		clock-frequency = <19200000>;
 	};
 
-	/* HS USB Port 3 RESET */
-	hsusb3_reset: hsusb3_reset_reg {
-		compatible = "regulator-fixed";
-		regulator-name = "hsusb3_reset";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		gpio = <&gpio3 15 GPIO_ACTIVE_HIGH>; /* gpio3_79 ETH_NRESET */
-		startup-delay-us = <70000>;
-		enable-active-high;
-	};
-
 	/* HS USB Host PHY on PORT 3 */
 	hsusb3_phy: hsusb3_phy {
 		compatible = "usb-nop-xceiv";
-		reset-supply = <&hsusb3_reset>;
+		reset-gpios = <&gpio3 15 GPIO_ACTIVE_LOW>; /* gpio3_79 ETH_NRESET */
 	};
 
 	leds {
-- 
1.7.4.1

