Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaLAIxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:53:31 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58248 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaLAIxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:53:13 -0500
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
Subject: [PATCH v10 4/4] ARM: dts: rockchip: add suspend settings for rk3288-evb-rk808
Date: Mon,  1 Dec 2014 16:52:20 +0800
Message-Id: <1417423940-1669-5-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend-voltages and necessary pin-states for suspend on
rk3288-evb-rk808 boards. global_pwroff would be pulled high when
RK3288 entering suspend, this pin is a sleep signal for RK808, so
RK808 could goto sleep mode, and some regulators would be disable.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v10:
- remove regulator-suspend-mem-enabled and regulator-suspend-mem-microvolt
- enable the lcd, codec, sdmmc power during suspend

Changes in v9:
- update the subject and description

Changes in v8:
- keep all except cpu&tp power rail on during suspend
- add regulator-on-in-suspend before set suspend voltage
- add a reference of ddrio_pwroff and ddr0_retention

Changes in v7:
- add regulator-state-mem sub node for suspend

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 arch/arm/boot/dts/rk3288-evb-rk808.dts | 53 +++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
index d8c775e6..d453ddd 100644
--- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
+++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
@@ -31,7 +31,7 @@
 		interrupt-parent = <&gpio0>;
 		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
-		pinctrl-0 = <&pmic_int>;
+		pinctrl-0 = <&pmic_int &global_pwroff>;
 		rockchip,system-power-controller;
 		wakeup-source;
 		#clock-cells = <1>;
@@ -50,6 +50,9 @@
 				regulator-min-microvolt = <750000>;
 				regulator-max-microvolt = <1350000>;
 				regulator-name = "vdd_arm";
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			vdd_gpu: DCDC_REG2 {
@@ -58,12 +61,19 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1250000>;
 				regulator-name = "vdd_gpu";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <1000000>;
+				};
 			};
 
 			vcc_ddr: DCDC_REG3 {
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-name = "vcc_ddr";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			vcc_io: DCDC_REG4 {
@@ -72,6 +82,10 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcc_io";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <3300000>;
+				};
 			};
 
 			vccio_pmu: LDO_REG1 {
@@ -80,6 +94,10 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vccio_pmu";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <3300000>;
+				};
 			};
 
 			vcc_tp: LDO_REG2 {
@@ -88,6 +106,9 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcc_tp";
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			vdd_10: LDO_REG3 {
@@ -96,6 +117,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-name = "vdd_10";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <1000000>;
+				};
 			};
 
 			vcc18_lcd: LDO_REG4 {
@@ -104,6 +129,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-name = "vcc18_lcd";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <1800000>;
+				};
 			};
 
 			vccio_sd: LDO_REG5 {
@@ -112,6 +141,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vccio_sd";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <3300000>;
+				};
 			};
 
 			vdd10_lcd: LDO_REG6 {
@@ -120,6 +153,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-name = "vdd10_lcd";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <1000000>;
+				};
 			};
 
 			vcc_18: LDO_REG7 {
@@ -128,6 +165,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-name = "vcc_18";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <1800000>;
+				};
 			};
 
 			vcca_codec: LDO_REG8 {
@@ -136,18 +177,28 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcca_codec";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+					regulator-suspend-microvolt = <3300000>;
+				};
 			};
 
 			vcc_wl: SWITCH_REG1 {
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-name = "vcc_wl";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			vcc_lcd: SWITCH_REG2 {
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-name = "vcc_lcd";
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 		};
 	};
-- 
1.9.1

