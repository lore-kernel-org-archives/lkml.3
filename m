Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaHLQpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:45:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38278 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaHLQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:45:12 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/6] ARM: dts: Use tps65090 fragment in exynos5250-snow
Date: Tue, 12 Aug 2014 18:44:24 +0200
Message-Id: <1407861868-20097-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there is a .dtsi fragment file for the tps65090 PMU,
include it in the Exynos Snow DTS file to reduce duplication.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5250-snow.dts | 108 +++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index f2b8c41..159a497 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -147,8 +147,7 @@
 				wakeup-source;
 			};
 
-			power-regulator {
-				compatible = "ti,tps65090";
+			tps: power-regulator {
 				reg = <0x48>;
 
 				/*
@@ -170,58 +169,6 @@
 				infet7-supply = <&vbat>;
 				vsys-l1-supply = <&vbat>;
 				vsys-l2-supply = <&vbat>;
-
-				regulators {
-					dcdc1 {
-						ti,enable-ext-control;
-					};
-					dcdc2 {
-						ti,enable-ext-control;
-					};
-					dcdc3 {
-						ti,enable-ext-control;
-					};
-					fet1 {
-						regulator-name = "vcd_led";
-						ti,overcurrent-wait = <3>;
-					};
-					tps65090_fet2: fet2 {
-						regulator-name = "video_mid";
-						regulator-always-on;
-						ti,overcurrent-wait = <3>;
-					};
-					fet3 {
-						regulator-name = "wwan_r";
-						regulator-always-on;
-						ti,overcurrent-wait = <3>;
-					};
-					fet4 {
-						regulator-name = "sdcard";
-						ti,overcurrent-wait = <3>;
-					};
-					fet5 {
-						regulator-name = "camout";
-						regulator-always-on;
-						ti,overcurrent-wait = <3>;
-					};
-					fet6 {
-						regulator-name = "lcd_vdd";
-						ti,overcurrent-wait = <3>;
-					};
-					tps65090_fet7: fet7 {
-						regulator-name = "video_mid_1a";
-						regulator-always-on;
-						ti,overcurrent-wait = <3>;
-					};
-					ldo1 {
-					};
-					ldo2 {
-					};
-				};
-
-				charger {
-					compatible = "ti,tps65090-charger";
-				};
 			};
 		};
 	};
@@ -344,6 +291,59 @@
 	};
 };
 
+#include "tps65090.dtsi"
+
+&tps65090_dcdc1 {
+	ti,enable-ext-control;
+};
+
+&tps65090_dcdc2 {
+	ti,enable-ext-control;
+};
+
+&tps65090_dcdc3 {
+	ti,enable-ext-control;
+};
+
+&tps65090_fet1 {
+	regulator-name = "vcd_led";
+	ti,overcurrent-wait = <3>;
+};
+
+&tps65090_fet2 {
+	regulator-name = "video_mid";
+	regulator-always-on;
+	ti,overcurrent-wait = <3>;
+};
+
+&tps65090_fet3 {
+	regulator-name = "wwan_r";
+	regulator-always-on;
+	ti,overcurrent-wait = <3>;
+};
+
+&tps65090_fet4 {
+	regulator-name = "sdcard";
+	ti,overcurrent-wait = <3>;
+};
+
+&tps65090_fet5 {
+	regulator-name = "camout";
+	regulator-always-on;
+	ti,overcurrent-wait = <3>;
+};
+
+&tps65090_fet6 {
+	regulator-name = "lcd_vdd";
+	ti,overcurrent-wait = <3>;
+};
+
+&tps65090_fet7 {
+	regulator-name = "video_mid_1a";
+	regulator-always-on;
+	ti,overcurrent-wait = <3>;
+};
+
 &i2c_0 {
 	max77686@09 {
 		compatible = "maxim,max77686";
-- 
2.0.0.rc2

