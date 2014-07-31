Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaGaQNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:13:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaGaQKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:10:17 -0400
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
Subject: [PATCH v4 2/4] ARM: dts: Fold exynos5250-cros-common into exynos5250-snow
Date: Thu, 31 Jul 2014 18:08:27 +0200
Message-Id: <1406822910-6255-3-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406822910-6255-1-git-send-email-afaerber@suse.de>
References: <1406822910-6255-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remaining common ChromeOS pieces are fairly minor.

Suggested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v3 -> v4: Unchanged
 
 v2 -> v3:
 * Renamed subject to match Kukjin's style
 * Rebased onto MMC pinctrl bug fix (Doug Anderson)
 
 v2: New (Doug Anderson)

 arch/arm/boot/dts/exynos5250-cros-common.dtsi | 164 --------------------------
 arch/arm/boot/dts/exynos5250-snow.dts         | 164 +++++++++++++++++++++++---
 2 files changed, 145 insertions(+), 183 deletions(-)
 delete mode 100644 arch/arm/boot/dts/exynos5250-cros-common.dtsi

diff --git a/arch/arm/boot/dts/exynos5250-cros-common.dtsi b/arch/arm/boot/dts/exynos5250-cros-common.dtsi
deleted file mode 100644
index e603e9c70142..000000000000
--- a/arch/arm/boot/dts/exynos5250-cros-common.dtsi
+++ /dev/null
@@ -1,164 +0,0 @@
-/*
- * Common device tree include for all Exynos 5250 boards based off of Daisy.
- *
- * Copyright (c) 2012 Google, Inc
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-/ {
-	aliases {
-	};
-
-	memory {
-		reg = <0x40000000 0x80000000>;
-	};
-
-	chosen {
-	};
-
-	pinctrl@11400000 {
-		/*
-		 * Disabled pullups since external part has its own pullups and
-		 * double-pulling gets us out of spec in some cases.
-		 */
-		i2c2_bus: i2c2-bus {
-			samsung,pin-pud = <0>;
-		};
-	};
-
-	i2c@12C60000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <378000>;
-	};
-
-	i2c@12C70000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <378000>;
-	};
-
-	i2c@12C80000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-
-		hdmiddc@50 {
-			compatible = "samsung,exynos4210-hdmiddc";
-			reg = <0x50>;
-		};
-	};
-
-	i2c@12C90000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-	};
-
-	i2c@12CA0000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-	};
-
-	i2c@12CB0000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-	};
-
-	i2c@12CD0000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <66000>;
-	};
-
-	i2c@12CE0000 {
-		status = "okay";
-		samsung,i2c-sda-delay = <100>;
-		samsung,i2c-max-bus-freq = <378000>;
-
-		hdmiphy: hdmiphy@38 {
-			compatible = "samsung,exynos4212-hdmiphy";
-			reg = <0x38>;
-		};
-	};
-
-	mmc@12200000 {
-		num-slots = <1>;
-		supports-highspeed;
-		broken-cd;
-		card-detect-delay = <200>;
-		samsung,dw-mshc-ciu-div = <3>;
-		samsung,dw-mshc-sdr-timing = <2 3>;
-		samsung,dw-mshc-ddr-timing = <1 2>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_cd &sd0_bus4 &sd0_bus8>;
-
-		slot@0 {
-			reg = <0>;
-			bus-width = <8>;
-		};
-	};
-
-	mmc@12220000 {
-		num-slots = <1>;
-		supports-highspeed;
-		card-detect-delay = <200>;
-		samsung,dw-mshc-ciu-div = <3>;
-		samsung,dw-mshc-sdr-timing = <2 3>;
-		samsung,dw-mshc-ddr-timing = <1 2>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
-
-		slot@0 {
-			reg = <0>;
-			bus-width = <4>;
-			wp-gpios = <&gpc2 1 0>;
-		};
-	};
-
-	mmc@12230000 {
-		num-slots = <1>;
-		supports-highspeed;
-		broken-cd;
-		card-detect-delay = <200>;
-		samsung,dw-mshc-ciu-div = <3>;
-		samsung,dw-mshc-sdr-timing = <2 3>;
-		samsung,dw-mshc-ddr-timing = <1 2>;
-		/* See board-specific dts files for pin setup */
-
-		slot@0 {
-			reg = <0>;
-			bus-width = <4>;
-		};
-	};
-
-	spi_1: spi@12d30000 {
-		status = "okay";
-		samsung,spi-src-clk = <0>;
-		num-cs = <1>;
-	};
-
-	hdmi {
-		hpd-gpio = <&gpx3 7 0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&hdmi_hpd_irq>;
-		phy = <&hdmiphy>;
-		ddc = <&i2c_2>;
-	};
-
-	gpio-keys {
-		compatible = "gpio-keys";
-
-		power {
-			label = "Power";
-			gpios = <&gpx1 3 1>;
-			linux,code = <116>; /* KEY_POWER */
-			gpio-key,wakeup;
-		};
-	};
-};
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index eb437f6afec1..1c36cd72905f 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -10,7 +10,6 @@
 
 /dts-v1/;
 #include "exynos5250.dtsi"
-#include "exynos5250-cros-common.dtsi"
 
 / {
 	model = "Google Snow";
@@ -20,6 +19,13 @@
 		i2c104 = &i2c_104;
 	};
 
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	chosen {
+	};
+
 	rtc@101E0000 {
 		status = "okay";
 	};
@@ -93,6 +99,13 @@
 	gpio-keys {
 		compatible = "gpio-keys";
 
+		power {
+			label = "Power";
+			gpios = <&gpx1 3 1>;
+			linux,code = <116>; /* KEY_POWER */
+			gpio-key,wakeup;
+		};
+
 		lid-switch {
 			label = "Lid";
 			gpios = <&gpx3 5 1>;
@@ -226,24 +239,6 @@
 		};
 	};
 
-	mmc@12200000 {
-		status = "okay";
-	};
-
-	mmc@12220000 {
-		status = "okay";
-	};
-
-	/*
-	 * On Snow we've got SIP WiFi and so can keep drive strengths low to
-	 * reduce EMI.
-	 */
-	mmc@12230000 {
-		status = "okay";
-		pinctrl-names = "default";
-		pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_bus4>;
-	};
-
 	i2c@12CD0000 {
 		max98095: codec@11 {
 			compatible = "maxim,max98095";
@@ -292,6 +287,11 @@
 	};
 
 	hdmi {
+		hpd-gpio = <&gpx3 7 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&hdmi_hpd_irq>;
+		phy = <&hdmiphy>;
+		ddc = <&i2c_2>;
 		hdmi-en-supply = <&tps65090_fet7>;
 		vdd-supply = <&ldo8_reg>;
 		vdd_osc-supply = <&ldo10_reg>;
@@ -343,6 +343,10 @@
 };
 
 &i2c_0 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <378000>;
+
 	max77686@09 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
@@ -489,6 +493,10 @@
 };
 
 &i2c_1 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <378000>;
+
 	trackpad {
 		reg = <0x67>;
 		compatible = "cypress,cyapa";
@@ -498,6 +506,118 @@
 	};
 };
 
+/*
+ * Disabled pullups since external part has its own pullups and
+ * double-pulling gets us out of spec in some cases.
+ */
+&i2c2_bus {
+	samsung,pin-pud = <0>;
+};
+
+&i2c_2 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+
+	hdmiddc@50 {
+		compatible = "samsung,exynos4210-hdmiddc";
+		reg = <0x50>;
+	};
+};
+
+&i2c_3 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+};
+
+&i2c_4 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+};
+
+&i2c_5 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+};
+
+&i2c_7 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <66000>;
+};
+
+&i2c_8 {
+	status = "okay";
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <378000>;
+
+	hdmiphy: hdmiphy@38 {
+		compatible = "samsung,exynos4212-hdmiphy";
+		reg = <0x38>;
+	};
+};
+
+&mmc_0 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	broken-cd;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_cd &sd0_bus4 &sd0_bus8>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <8>;
+	};
+};
+
+&mmc_2 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <4>;
+		wp-gpios = <&gpc2 1 0>;
+	};
+};
+
+/*
+ * On Snow we've got SIP WiFi and so can keep drive strengths low to
+ * reduce EMI.
+ */
+&mmc_3 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	broken-cd;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_bus4>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <4>;
+	};
+};
+
 &pinctrl_0 {
 	max77686_irq: max77686-irq {
 		samsung,pins = "gpx3-2";
@@ -507,4 +627,10 @@
 	};
 };
 
+&spi_1 {
+	status = "okay";
+	samsung,spi-src-clk = <0>;
+	num-cs = <1>;
+};
+
 #include "cros-ec-keyboard.dtsi"
-- 
1.9.3

