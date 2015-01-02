Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbABPYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:24:38 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60161 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbbABPYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:24:36 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RESEND 4/4] ARM: dts: Configure regulators for suspend on exynos Peach boards
Date: Fri,  2 Jan 2015 16:24:17 +0100
Message-Id: <1420212257-22443-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420212257-22443-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1420212257-22443-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core now has support to choose if a regulator
has to be enabled or disabled during system suspend and also
supports changing the regulator operating mode during runtime
and when the system enters into sleep mode.

To lower power during suspend, configure the regulators state
using the same configuration found in the ChromeOS 3.8 kernel

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 81 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 81 ++++++++++++++++++++++++++++++
 2 files changed, 162 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index a4c5152..c47bb70 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -13,6 +13,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/clock/maxim,max77802.h>
+#include <dt-bindings/regulator/maxim,max77802.h>
 #include "exynos5420.dtsi"
 
 / {
@@ -201,6 +202,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck2_reg: BUCK2 {
@@ -210,6 +214,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck3_reg: BUCK3 {
@@ -219,6 +226,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck4_reg: BUCK4 {
@@ -228,6 +238,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck5_reg: BUCK5 {
@@ -236,6 +249,9 @@
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck6_reg: BUCK6 {
@@ -245,6 +261,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck7_reg: BUCK7 {
@@ -253,6 +272,9 @@
 				regulator-max-microvolt = <1350000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck8_reg: BUCK8 {
@@ -261,6 +283,9 @@
 				regulator-max-microvolt = <2850000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck9_reg: BUCK9 {
@@ -269,6 +294,9 @@
 				regulator-max-microvolt = <2000000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck10_reg: BUCK10 {
@@ -277,6 +305,9 @@
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			ldo1_reg: LDO1 {
@@ -284,6 +315,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo2_reg: LDO2 {
@@ -297,6 +332,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			vqmmc_sdcard: ldo4_reg: LDO4 {
@@ -304,6 +343,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <2800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo5_reg: LDO5 {
@@ -311,6 +353,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo6_reg: LDO6 {
@@ -318,6 +363,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo7_reg: LDO7 {
@@ -331,6 +379,9 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo9_reg: LDO9 {
@@ -338,6 +389,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo10_reg: LDO10 {
@@ -345,6 +400,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo11_reg: LDO11 {
@@ -352,6 +410,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo12_reg: LDO12 {
@@ -359,6 +421,9 @@
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo13_reg: LDO13 {
@@ -366,6 +431,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo14_reg: LDO14 {
@@ -373,6 +442,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo15_reg: LDO15 {
@@ -380,6 +452,9 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo17_reg: LDO17 {
@@ -387,6 +462,9 @@
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1400000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo18_reg: LDO18 {
@@ -460,6 +538,9 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo32_reg: LDO32 {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 1367276..06737c6 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -13,6 +13,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/clock/maxim,max77802.h>
+#include <dt-bindings/regulator/maxim,max77802.h>
 #include "exynos5800.dtsi"
 
 / {
@@ -201,6 +202,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck2_reg: BUCK2 {
@@ -210,6 +214,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck3_reg: BUCK3 {
@@ -219,6 +226,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck4_reg: BUCK4 {
@@ -228,6 +238,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck5_reg: BUCK5 {
@@ -236,6 +249,9 @@
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck6_reg: BUCK6 {
@@ -245,6 +261,9 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-ramp-delay = <12500>;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck7_reg: BUCK7 {
@@ -253,6 +272,9 @@
 				regulator-max-microvolt = <1350000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck8_reg: BUCK8 {
@@ -261,6 +283,9 @@
 				regulator-max-microvolt = <2850000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck9_reg: BUCK9 {
@@ -269,6 +294,9 @@
 				regulator-max-microvolt = <2000000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck10_reg: BUCK10 {
@@ -277,6 +305,9 @@
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
 				regulator-boot-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			ldo1_reg: LDO1 {
@@ -284,6 +315,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo2_reg: LDO2 {
@@ -297,6 +332,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			vqmmc_sdcard: ldo4_reg: LDO4 {
@@ -304,6 +343,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <2800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo5_reg: LDO5 {
@@ -311,6 +353,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo6_reg: LDO6 {
@@ -318,6 +363,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo7_reg: LDO7 {
@@ -331,6 +379,9 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo9_reg: LDO9 {
@@ -338,6 +389,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo10_reg: LDO10 {
@@ -345,6 +400,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo11_reg: LDO11 {
@@ -352,6 +410,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo12_reg: LDO12 {
@@ -359,6 +421,9 @@
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo13_reg: LDO13 {
@@ -366,6 +431,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-mode = <MAX77802_OPMODE_LP>;
+				};
 			};
 
 			ldo14_reg: LDO14 {
@@ -373,6 +442,9 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo15_reg: LDO15 {
@@ -380,6 +452,9 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo17_reg: LDO17 {
@@ -387,6 +462,9 @@
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1400000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo18_reg: LDO18 {
@@ -460,6 +538,9 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo32_reg: LDO32 {
-- 
2.1.3

