Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaE1RMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:12:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46304 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753041AbaE1RL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:11:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        lee.jones@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/5] ARM: sun7i: cubieboard2: Enable the AXP209
Date: Wed, 28 May 2014 19:11:09 +0200
Message-Id: <1401297069-7423-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the AXP209 PMIC with the regulators in use on the cubie2.

The RTC regulator can be disabled, but since the RTC driver doesn't grab the
regulator for now, the driver wouldn't work anymore.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts | 41 +++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
index a5ad945197e8..1b9983b3f45e 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
@@ -76,6 +76,39 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&i2c0_pins_a>;
 			status = "okay";
+
+			axp209: pmic@34 {
+				compatible = "x-powers,axp209";
+				reg = <0x34>;
+				interrupt-parent = <&nmi_intc>;
+				interrupts = <0 8>;
+
+				interrupt-controller;
+				#interrupt-cells = <1>;
+
+				regulators {
+					x-powers,dcdc-freq = <1500>;
+
+					vdd_cpu: dcdc2 {
+						vin-supply = <&reg_axp_ipsout>;
+						regulator-always-on;
+					};
+
+					vdd_dll: dcdc3 {
+						vin-supply = <&reg_axp_ipsout>;
+						regulator-always-on;
+					};
+
+					vdd_rtc: ldo1 {
+						vin-supply = <&reg_axp_ipsout>;
+					};
+
+					avcc: ldo2 {
+						vin-supply = <&reg_axp_ipsout>;
+						regulator-always-on;
+					};
+				};
+			};
 		};
 
 		i2c1: i2c@01c2b000 {
@@ -124,4 +157,12 @@
 	reg_usb2_vbus: usb2-vbus {
 		status = "okay";
 	};
+
+	reg_axp_ipsout: axp_ipsout {
+		compatible = "regulator-fixed";
+		regulator-name = "axp-ipsout";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
+	};
 };
-- 
1.9.3

