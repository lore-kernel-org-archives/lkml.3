Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaJHNqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:46:31 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52451 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbaJHNq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:46:28 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 5/5] ARM: dts: Add initial regulator mode on exynos Peach boards
Date: Wed,  8 Oct 2014 15:44:07 +0200
Message-Id: <1412775847-15213-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core now has support to choose a default initial
operating mode for regulators from DT. Set the initial opmode
for the max77802 PMIC regulators with the same modes that are
used in the downstream ChromeOS kernel, in order to allow the
system to lower power at suspend time.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 26 ++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 9a050e1..f7eb70d 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -13,6 +13,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/clock/maxim,max77802.h>
+#include <dt-bindings/regulator/regulator.h>
 #include "exynos5420.dtsi"
 
 / {
@@ -192,6 +193,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck2_reg: BUCK2 {
@@ -201,6 +203,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck3_reg: BUCK3 {
@@ -210,6 +213,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck4_reg: BUCK4 {
@@ -219,6 +223,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck5_reg: BUCK5 {
@@ -227,6 +232,7 @@
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck6_reg: BUCK6 {
@@ -236,6 +242,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck7_reg: BUCK7 {
@@ -244,6 +251,7 @@
 				regulator-max-microvolt = <1350000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_NORMAL>;
 			};
 
 			buck8_reg: BUCK8 {
@@ -252,6 +260,7 @@
 				regulator-max-microvolt = <2850000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck9_reg: BUCK9 {
@@ -260,6 +269,7 @@
 				regulator-max-microvolt = <2000000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_NORMAL>;
 			};
 
 			buck10_reg: BUCK10 {
@@ -268,6 +278,7 @@
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_NORMAL>;
 			};
 
 			ldo1_reg: LDO1 {
@@ -275,6 +286,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo2_reg: LDO2 {
@@ -288,6 +300,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			vqmmc_sdcard: ldo4_reg: LDO4 {
@@ -295,6 +308,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <2800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo5_reg: LDO5 {
@@ -302,6 +316,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo6_reg: LDO6 {
@@ -309,6 +324,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo7_reg: LDO7 {
@@ -322,6 +338,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo9_reg: LDO9 {
@@ -329,6 +346,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo10_reg: LDO10 {
@@ -336,6 +354,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo11_reg: LDO11 {
@@ -343,6 +362,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo12_reg: LDO12 {
@@ -350,6 +370,7 @@
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo13_reg: LDO13 {
@@ -357,6 +378,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo14_reg: LDO14 {
@@ -364,6 +386,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo15_reg: LDO15 {
@@ -371,6 +394,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo17_reg: LDO17 {
@@ -378,6 +402,7 @@
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1400000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo18_reg: LDO18 {
@@ -451,6 +476,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo32_reg: LDO32 {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index e8fdda8..3da8084 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -13,6 +13,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/clock/maxim,max77802.h>
+#include <dt-bindings/regulator/regulator.h>
 #include "exynos5800.dtsi"
 
 / {
@@ -191,6 +192,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck2_reg: BUCK2 {
@@ -200,6 +202,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck3_reg: BUCK3 {
@@ -209,6 +212,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck4_reg: BUCK4 {
@@ -218,6 +222,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck5_reg: BUCK5 {
@@ -226,6 +231,7 @@
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck6_reg: BUCK6 {
@@ -235,6 +241,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck7_reg: BUCK7 {
@@ -243,6 +250,7 @@
 				regulator-max-microvolt = <1350000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_NORMAL>;
 			};
 
 			buck8_reg: BUCK8 {
@@ -251,6 +259,7 @@
 				regulator-max-microvolt = <2850000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			buck9_reg: BUCK9 {
@@ -259,6 +268,7 @@
 				regulator-max-microvolt = <2000000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_NORMAL>;
 			};
 
 			buck10_reg: BUCK10 {
@@ -267,6 +277,7 @@
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-initial-mode = <REGULATOR_MODE_NORMAL>;
 			};
 
 			ldo1_reg: LDO1 {
@@ -274,6 +285,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo2_reg: LDO2 {
@@ -287,6 +299,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			vqmmc_sdcard: ldo4_reg: LDO4 {
@@ -294,6 +307,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <2800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo5_reg: LDO5 {
@@ -301,6 +315,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo6_reg: LDO6 {
@@ -308,6 +323,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo7_reg: LDO7 {
@@ -321,6 +337,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo9_reg: LDO9 {
@@ -328,6 +345,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo10_reg: LDO10 {
@@ -335,6 +353,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo11_reg: LDO11 {
@@ -342,6 +361,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo12_reg: LDO12 {
@@ -349,6 +369,7 @@
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo13_reg: LDO13 {
@@ -356,6 +377,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_IDLE>;
 			};
 
 			ldo14_reg: LDO14 {
@@ -363,6 +385,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo15_reg: LDO15 {
@@ -370,6 +393,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo17_reg: LDO17 {
@@ -377,6 +401,7 @@
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1400000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo18_reg: LDO18 {
@@ -450,6 +475,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
 			};
 
 			ldo32_reg: LDO32 {
-- 
2.1.0

