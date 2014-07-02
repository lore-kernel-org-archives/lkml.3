Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaGBMWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:22:34 -0400
Received: from gnurou.org ([207.192.72.5]:55662 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbaGBMWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:22:32 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 4/4] ARM: tegra: roth: add display DT node
Date: Wed,  2 Jul 2014 21:19:20 +0900
Message-Id: <1404303560-32209-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DSI support has been fixed to support continuous clock behavior that the
panel used on SHIELD requires, so finally add its device tree node since
it is functional.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra114-roth.dts | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts
index ba210c6..c03c853 100644
--- a/arch/arm/boot/dts/tegra114-roth.dts
+++ b/arch/arm/boot/dts/tegra114-roth.dts
@@ -28,6 +28,22 @@
 		reg = <0x80000000 0x79600000>;
 	};
 
+	host1x@50000000 {
+		dsi@54300000 {
+			status = "okay";
+
+			vdd-supply = <&vdd_1v2_ap>;
+
+			panel@0 {
+				compatible = "lg,lh500wx1-sd03";
+				reg = <0>;
+
+				power-supply = <&vdd_lcd>;
+				backlight = <&backlight>;
+			};
+		};
+	};
+
 	pinmux@70000868 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&state_default>;
@@ -811,7 +827,6 @@
 						regulator-name = "vdd-1v8";
 						regulator-min-microvolt = <1800000>;
 						regulator-max-microvolt = <1800000>;
-						regulator-always-on;
 						regulator-boot-on;
 					};
 
@@ -858,10 +873,11 @@
 						regulator-name = "vdd-2v8-display";
 						regulator-min-microvolt = <2800000>;
 						regulator-max-microvolt = <2800000>;
+						regulator-always-on;
 						regulator-boot-on;
 					};
 
-					ldo3 {
+					vdd_1v2_ap: ldo3 {
 						regulator-name = "avdd-1v2";
 						regulator-min-microvolt = <1200000>;
 						regulator-max-microvolt = <1200000>;
@@ -1048,7 +1064,7 @@
 			regulator-boot-on;
 		};
 
-		regulator@1 {
+		vdd_lcd: regulator@1 {
 			compatible = "regulator-fixed";
 			reg = <1>;
 			regulator-name = "vdd_lcd_1v8";
@@ -1057,6 +1073,7 @@
 			vin-supply = <&vdd_1v8>;
 			enable-active-high;
 			gpio = <&gpio TEGRA_GPIO(U, 4) GPIO_ACTIVE_HIGH>;
+			regulator-always-on;
 			regulator-boot-on;
 		};
 
-- 
2.0.0

