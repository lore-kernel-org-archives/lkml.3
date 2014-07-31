Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaGaQKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:10:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbaGaQKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:10:19 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 3/4] ARM: dts: Clean up exynos5250-snow
Date: Thu, 31 Jul 2014 18:08:28 +0200
Message-Id: <1406822910-6255-4-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406822910-6255-1-git-send-email-afaerber@suse.de>
References: <1406822910-6255-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new style of referencing inherited nodes and use symbolic names.

Suggested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v3 -> v4: Unchanged
 
 v3: New (Doug Anderson)

 arch/arm/boot/dts/exynos5250-snow.dts | 182 +++++++++++++++++-----------------
 1 file changed, 90 insertions(+), 92 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 1c36cd72905f..2ed6cb04a2db 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -9,6 +9,8 @@
 */
 
 /dts-v1/;
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/input/input.h>
 #include "exynos5250.dtsi"
 
 / {
@@ -30,85 +32,19 @@
 		status = "okay";
 	};
 
-	pinctrl@11400000 {
-		ec_irq: ec-irq {
-			samsung,pins = "gpx1-6";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-
-		sd3_clk: sd3-clk {
-			samsung,pin-drv = <0>;
-		};
-
-		sd3_cmd: sd3-cmd {
-			samsung,pin-pud = <3>;
-			samsung,pin-drv = <0>;
-		};
-
-		sd3_bus4: sd3-bus-width4 {
-			samsung,pin-drv = <0>;
-		};
-
-		max98095_en: max98095-en {
-			samsung,pins = "gpx1-7";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <3>;
-			samsung,pin-drv = <0>;
-		};
-
-		tps65090_irq: tps65090-irq {
-			samsung,pins = "gpx2-6";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-
-		usb3_vbus_en: usb3-vbus-en {
-			samsung,pins = "gpx2-7";
-			samsung,pin-function = <1>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-
-		hdmi_hpd_irq: hdmi-hpd-irq {
-			samsung,pins = "gpx3-7";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <1>;
-			samsung,pin-drv = <0>;
-		};
-	};
-
-	pinctrl@13400000 {
-		arb_their_claim: arb-their-claim {
-			samsung,pins = "gpe0-4";
-			samsung,pin-function = <0>;
-			samsung,pin-pud = <3>;
-			samsung,pin-drv = <0>;
-		};
-
-		arb_our_claim: arb-our-claim {
-			samsung,pins = "gpf0-3";
-			samsung,pin-function = <1>;
-			samsung,pin-pud = <0>;
-			samsung,pin-drv = <0>;
-		};
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
 		power {
 			label = "Power";
-			gpios = <&gpx1 3 1>;
-			linux,code = <116>; /* KEY_POWER */
+			gpios = <&gpx1 3 GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_POWER>;
 			gpio-key,wakeup;
 		};
 
 		lid-switch {
 			label = "Lid";
-			gpios = <&gpx3 5 1>;
+			gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
 			linux,input-type = <5>; /* EV_SW */
 			linux,code = <0>; /* SW_LID */
 			debounce-interval = <1>;
@@ -129,8 +65,8 @@
 
 		i2c-parent = <&{/i2c@12CA0000}>;
 
-		our-claim-gpio = <&gpf0 3 1>;
-		their-claim-gpios = <&gpe0 4 1>;
+		our-claim-gpio = <&gpf0 3 GPIO_ACTIVE_LOW>;
+		their-claim-gpios = <&gpe0 4 GPIO_ACTIVE_LOW>;
 		slew-delay-us = <10>;
 		wait-retry-us = <3000>;
 		wait-free-us = <50000>;
@@ -239,19 +175,6 @@
 		};
 	};
 
-	i2c@12CD0000 {
-		max98095: codec@11 {
-			compatible = "maxim,max98095";
-			reg = <0x11>;
-			pinctrl-0 = <&max98095_en>;
-			pinctrl-names = "default";
-		};
-	};
-
-	i2s0: i2s@03830000 {
-		status = "okay";
-	};
-
 	sound {
 		compatible = "google,snow-audio-max98095";
 
@@ -265,18 +188,14 @@
 		regulator-name = "P5.0V_USB3CON";
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
-		gpio = <&gpx2 7 0>;
+		gpio = <&gpx2 7 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&usb3_vbus_en>;
 		enable-active-high;
 	};
 
-	phy@12100000 {
-		vbus-supply = <&usb3_vbus_reg>;
-	};
-
 	usb@12110000 {
-		samsung,vbus-gpio = <&gpx1 1 0>;
+		samsung,vbus-gpio = <&gpx1 1 GPIO_ACTIVE_HIGH>;
 	};
 
 	fixed-rate-clocks {
@@ -287,7 +206,7 @@
 	};
 
 	hdmi {
-		hpd-gpio = <&gpx3 7 0>;
+		hpd-gpio = <&gpx3 7 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmi_hpd_irq>;
 		phy = <&hdmiphy>;
@@ -322,7 +241,7 @@
 		samsung,color-depth = <1>;
 		samsung,link-rate = <0x0a>;
 		samsung,lane-count = <2>;
-		samsung,hpd-gpio = <&gpx0 7 0>;
+		samsung,hpd-gpio = <&gpx0 7 GPIO_ACTIVE_HIGH>;
 
 		display-timings {
 			native-mode = <&timing1>;
@@ -547,6 +466,13 @@
 	status = "okay";
 	samsung,i2c-sda-delay = <100>;
 	samsung,i2c-max-bus-freq = <66000>;
+
+	max98095: codec@11 {
+		compatible = "maxim,max98095";
+		reg = <0x11>;
+		pinctrl-0 = <&max98095_en>;
+		pinctrl-names = "default";
+	};
 };
 
 &i2c_8 {
@@ -560,6 +486,10 @@
 	};
 };
 
+&i2s0 {
+	status = "okay";
+};
+
 &mmc_0 {
 	status = "okay";
 	num-slots = <1>;
@@ -625,6 +555,70 @@
 		samsung,pin-pud = <0>;
 		samsung,pin-drv = <0>;
 	};
+
+	ec_irq: ec-irq {
+		samsung,pins = "gpx1-6";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	max98095_en: max98095-en {
+		samsung,pins = "gpx1-7";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	tps65090_irq: tps65090-irq {
+		samsung,pins = "gpx2-6";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	usb3_vbus_en: usb3-vbus-en {
+		samsung,pins = "gpx2-7";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	hdmi_hpd_irq: hdmi-hpd-irq {
+		samsung,pins = "gpx3-7";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_1 {
+	arb_their_claim: arb-their-claim {
+		samsung,pins = "gpe0-4";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <3>;
+		samsung,pin-drv = <0>;
+	};
+
+	arb_our_claim: arb-our-claim {
+		samsung,pins = "gpf0-3";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&sd3_clk {
+	samsung,pin-drv = <0>;
+};
+
+&sd3_cmd {
+	samsung,pin-pud = <3>;
+	samsung,pin-drv = <0>;
+};
+
+&sd3_bus4 {
+	samsung,pin-drv = <0>;
 };
 
 &spi_1 {
@@ -633,4 +627,8 @@
 	num-cs = <1>;
 };
 
+&usbdrd_phy {
+	vbus-supply = <&usb3_vbus_reg>;
+};
+
 #include "cros-ec-keyboard.dtsi"
-- 
1.9.3

