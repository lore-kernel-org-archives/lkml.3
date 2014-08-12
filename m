Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaHLQpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:45:19 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38287 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaHLQpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:45:16 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 4/6] ARM: dts: Use cros-tps65090 fragment in Peach boards
Date: Tue, 12 Aug 2014 18:44:26 +0200
Message-Id: <1407861868-20097-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peach Pit and Pi machines have the same regulators connection
and regulator name so the cros-tps65090 dtsi file can be used
to remove duplicated code.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 95 +++++++-----------------------
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 94 +++++++----------------------
 2 files changed, 41 insertions(+), 148 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 228a6b1..a1a4410 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -93,13 +93,6 @@
 		pinctrl-0 = <&usb301_vbus_en>;
 		enable-active-high;
 	};
-
-	vbat: fixed-regulator {
-		compatible = "regulator-fixed";
-		regulator-name = "vbat-supply";
-		regulator-boot-on;
-		regulator-always-on;
-	};
 };
 
 &dp {
@@ -350,79 +343,33 @@
 				sbs,i2c-retry-count = <2>;
 			};
 
-			power-regulator@48 {
-				compatible = "ti,tps65090";
+			tps: power-regulator@48 {
 				reg = <0x48>;
-
-				/*
-				 * Config irq to disable internal pulls
-				 * even though we run in polling mode.
-				 */
-				pinctrl-names = "default";
-				pinctrl-0 = <&tps65090_irq>;
-
-				vsys1-supply = <&vbat>;
-				vsys2-supply = <&vbat>;
-				vsys3-supply = <&vbat>;
-				infet1-supply = <&vbat>;
-				infet2-supply = <&vbat>;
-				infet3-supply = <&vbat>;
-				infet4-supply = <&vbat>;
-				infet5-supply = <&vbat>;
-				infet6-supply = <&vbat>;
-				infet7-supply = <&vbat>;
-				vsys-l1-supply = <&vbat>;
-				vsys-l2-supply = <&vbat>;
-
-				regulators {
-					tps65090_dcdc1: dcdc1 {
-						ti,enable-ext-control;
-					};
-					tps65090_dcdc2: dcdc2 {
-						ti,enable-ext-control;
-					};
-					tps65090_dcdc3: dcdc3 {
-						ti,enable-ext-control;
-					};
-					tps65090_fet1: fet1 {
-						regulator-name = "vcd_led";
-					};
-					tps65090_fet2: fet2 {
-						regulator-name = "video_mid";
-						regulator-always-on;
-					};
-					tps65090_fet3: fet3 {
-						regulator-name = "wwan_r";
-						regulator-always-on;
-					};
-					tps65090_fet4: fet4 {
-						regulator-name = "sdcard";
-						regulator-always-on;
-					};
-					tps65090_fet5: fet5 {
-						regulator-name = "camout";
-					};
-					tps65090_fet6: fet6 {
-						regulator-name = "lcd_vdd";
-					};
-					tps65090_fet7: fet7 {
-						regulator-name = "video_mid_1a";
-						regulator-always-on;
-					};
-					tps65090_ldo1: ldo1 {
-					};
-					tps65090_ldo2: ldo2 {
-					};
-				};
-
-				charger {
-					compatible = "ti,tps65090-charger";
-				};
 			};
 		};
 	};
 };
 
+#include "tps65090.dtsi"
+#include "cros-tps65090.dtsi"
+
+
+&tps65090_fet2 {
+	regulator-always-on;
+};
+
+&tps65090_fet3 {
+	regulator-always-on;
+};
+
+&tps65090_fet4 {
+	regulator-always-on;
+};
+
+&tps65090_fet7 {
+	regulator-always-on;
+};
+
 &uart_3 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index f3ee48b..6760839 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -91,13 +91,6 @@
 		pinctrl-0 = <&usb301_vbus_en>;
 		enable-active-high;
 	};
-
-	vbat: fixed-regulator {
-		compatible = "regulator-fixed";
-		regulator-name = "vbat-supply";
-		regulator-boot-on;
-		regulator-always-on;
-	};
 };
 
 &dp {
@@ -348,79 +341,32 @@
 				sbs,i2c-retry-count = <2>;
 			};
 
-			power-regulator@48 {
-				compatible = "ti,tps65090";
+			tps: power-regulator@48 {
 				reg = <0x48>;
-
-				/*
-				 * Config irq to disable internal pulls
-				 * even though we run in polling mode.
-				 */
-				pinctrl-names = "default";
-				pinctrl-0 = <&tps65090_irq>;
-
-				vsys1-supply = <&vbat>;
-				vsys2-supply = <&vbat>;
-				vsys3-supply = <&vbat>;
-				infet1-supply = <&vbat>;
-				infet2-supply = <&vbat>;
-				infet3-supply = <&vbat>;
-				infet4-supply = <&vbat>;
-				infet5-supply = <&vbat>;
-				infet6-supply = <&vbat>;
-				infet7-supply = <&vbat>;
-				vsys-l1-supply = <&vbat>;
-				vsys-l2-supply = <&vbat>;
-
-				regulators {
-					tps65090_dcdc1: dcdc1 {
-						ti,enable-ext-control;
-					};
-					tps65090_dcdc2: dcdc2 {
-						ti,enable-ext-control;
-					};
-					tps65090_dcdc3: dcdc3 {
-						ti,enable-ext-control;
-					};
-					tps65090_fet1: fet1 {
-						regulator-name = "vcd_led";
-					};
-					tps65090_fet2: fet2 {
-						regulator-name = "video_mid";
-						regulator-always-on;
-					};
-					tps65090_fet3: fet3 {
-						regulator-name = "wwan_r";
-						regulator-always-on;
-					};
-					tps65090_fet4: fet4 {
-						regulator-name = "sdcard";
-						regulator-always-on;
-					};
-					tps65090_fet5: fet5 {
-						regulator-name = "camout";
-					};
-					tps65090_fet6: fet6 {
-						regulator-name = "lcd_vdd";
-					};
-					tps65090_fet7: fet7 {
-						regulator-name = "video_mid_1a";
-						regulator-always-on;
-					};
-					tps65090_ldo1: ldo1 {
-					};
-					tps65090_ldo2: ldo2 {
-					};
-				};
-
-				charger {
-					compatible = "ti,tps65090-charger";
-				};
 			};
 		};
 	};
 };
 
+#include "tps65090.dtsi"
+#include "cros-tps65090.dtsi"
+
+&tps65090_fet2 {
+	regulator-always-on;
+};
+
+&tps65090_fet3 {
+	regulator-always-on;
+};
+
+&tps65090_fet4 {
+	regulator-always-on;
+};
+
+&tps65090_fet7 {
+	regulator-always-on;
+};
+
 &uart_3 {
 	status = "okay";
 };
-- 
2.0.0.rc2

