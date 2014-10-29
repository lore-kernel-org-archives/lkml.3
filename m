Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbaJ2Lx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:53:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:65305 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaJ2LxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:53:23 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 7/7] ARM: dts: add suspend voltage setting for RK808
Date: Wed, 29 Oct 2014 19:52:05 +0800
Message-Id: <1414583525-17395-8-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

global_pwroff would be pull to high when RK3288 entering suspend,
this pin is a sleep signal for RK808, so RK808 could goto sleep
mode, and some regulators would be disable.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 arch/arm/boot/dts/rk3288-evb-rk808.dts |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
index ff522f8..319fcb6 100644
--- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
+++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
@@ -27,7 +27,7 @@
 		interrupt-parent = <&gpio0>;
 		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
-		pinctrl-0 = <&pmic_int>;
+		pinctrl-0 = <&pmic_int &global_pwroff>;
 		rockchip,system-power-controller;
 		wakeup-source;
 		#clock-cells = <1>;
@@ -46,6 +46,7 @@
 				regulator-min-microvolt = <750000>;
 				regulator-max-microvolt = <1300000>;
 				regulator-name = "vdd_arm";
+				regulator-suspend-mem-disabled;
 			};
 
 			vdd_gpu: DCDC_REG2 {
@@ -54,12 +55,14 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1250000>;
 				regulator-name = "vdd_gpu";
+				regulator-suspend-mem-disabled;
 			};
 
 			vcc_ddr: DCDC_REG3 {
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-name = "vcc_ddr";
+				regulator-suspend-mem-enabled;
 			};
 
 			vcc_io: DCDC_REG4 {
@@ -68,6 +71,7 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcc_io";
+				regulator-suspend-mem-microvolt = <3300000>;
 			};
 
 			vccio_pmu: LDO_REG1 {
@@ -76,6 +80,7 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vccio_pmu";
+				regulator-suspend-mem-microvolt = <3300000>;
 			};
 
 			vcc_tp: LDO_REG2 {
@@ -84,6 +89,7 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcc_tp";
+				regulator-suspend-mem-disabled;
 			};
 
 			vdd_10: LDO_REG3 {
@@ -92,6 +98,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-name = "vdd_10";
+				regulator-suspend-mem-microvolt = <1000000>;
 			};
 
 			vcc18_lcd: LDO_REG4 {
@@ -100,6 +107,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-name = "vcc18_lcd";
+				regulator-suspend-mem-disabled;
 			};
 
 			vccio_sd: LDO_REG5 {
@@ -108,6 +116,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vccio_sd";
+				regulator-suspend-mem-disabled;
 			};
 
 			vdd10_lcd: LDO_REG6 {
@@ -116,6 +125,7 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-name = "vdd10_lcd";
+				regulator-suspend-mem-disabled;
 			};
 
 			vcc_18: LDO_REG7 {
@@ -124,6 +134,7 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-name = "vcc_18";
+				regulator-suspend-mem-microvolt = <1800000>;
 			};
 
 			vcca_codec: LDO_REG8 {
@@ -132,18 +143,21 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcca_codec";
+				regulator-suspend-mem-disabled;
 			};
 
 			vcc_wl: SWITCH_REG1 {
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-name = "vcc_wl";
+				regulator-suspend-mem-enabled;
 			};
 
 			vcc_lcd: SWITCH_REG2 {
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-name = "vcc_lcd";
+				regulator-suspend-mem-disabled;
 			};
 		};
 	};
-- 
1.7.9.5

