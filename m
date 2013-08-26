Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3HZFiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:38:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50354 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab3HZFiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:38:18 -0400
From: Keerthy <j-keerthy@ti.com>
To: <bcousson@baylibre.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pawel.moll@arm.com>, <devicetree@vger.kernel.org>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <nm@ti.com>, <balajitk@ti.com>, <j-keerthy@ti.com>
Subject: [PATCH] ARM: DTS: DRA7: Add TPS659038 PMIC nodes
Date: Mon, 26 Aug 2013 11:06:51 +0530
Message-ID: <1377495411-21984-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch adds nodes for TPS659038 PMIC for DRA7 boards.

It is based on top of:
http://comments.gmane.org/gmane.linux.ports.arm.omap/102459.

Documentation:	Documentation/devicetree/bindings/mfd/palmas.txt
		Documentation/devicetree/bindings/regulator/palmas-pmic.txt		

Boot Tested on DRA7 d1 Board.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |  118 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

Index: linux/arch/arm/boot/dts/dra7-evm.dts
===================================================================
--- linux.orig/arch/arm/boot/dts/dra7-evm.dts	2013-08-26 09:57:52.496173554 +0530
+++ linux/arch/arm/boot/dts/dra7-evm.dts	2013-08-26 10:38:44.995414695 +0530
@@ -93,6 +93,119 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
 	clock-frequency = <400000>;
+
+	tps659038: tps659038@58 {
+		compatible = "ti,tps659038";
+		reg = <0x58>;
+
+		tps659038_pmic {
+			compatible = "ti,tps659038-pmic";
+
+			regulators {
+				smps123_reg: smps123 {
+					/* VDD_MPU */
+						regulator-name = "smps123";
+						regulator-min-microvolt = < 850000>;
+						regulator-max-microvolt = <1250000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				smps45_reg: smps45 {
+						/* VDD_DSPEVE */
+						regulator-name = "smps45";
+						regulator-min-microvolt = < 850000>;
+						regulator-max-microvolt = <1150000>;
+						regulator-boot-on;
+					};
+
+				smps6_reg: smps6 {
+						/* VDD_GPU - over VDD_SMPS6 */
+						regulator-name = "smps6";
+						regulator-min-microvolt = <850000>;
+						regulator-max-microvolt = <12500000>;
+						regulator-boot-on;
+					};
+
+				smps7_reg: smps7 {
+						/* CORE_VDD */
+						regulator-name = "smps7";
+						regulator-min-microvolt = <850000>;
+						regulator-max-microvolt = <1030000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				smps8_reg: smps8 {
+						/* VDD_IVAHD */
+						regulator-name = "smps8";
+						regulator-min-microvolt = < 850000>;
+						regulator-max-microvolt = <1250000>;
+						regulator-boot-on;
+					};
+
+				smps9_reg: smps9 {
+						/* VDDS1V8 */
+						regulator-name = "smps9";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				ldo1_reg: ldo1 {
+						/* LDO1_OUT --> SDIO  */
+						regulator-name = "ldo1";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <3300000>;
+						regulator-boot-on;
+					};
+
+				ldo2_reg: ldo2 {
+						/* VDD_RTCIO */
+						/* LDO2 -> VDDSHV5, LDO2 also goes to CAN_PHY_3V3 */
+						regulator-name = "ldo2";
+						regulator-min-microvolt = <3300000>;
+						regulator-max-microvolt = <3300000>;
+						regulator-boot-on;
+					};
+
+				ldo3_reg: ldo3 {
+						/* VDDA_1V8_PHY */
+						regulator-name = "ldo3";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
+						regulator-boot-on;
+					};
+
+				ldo9_reg: ldo9 {
+						/* VDD_RTC */
+						regulator-name = "ldo9";
+						regulator-min-microvolt = <1050000>;
+						regulator-max-microvolt = <1050000>;
+						regulator-boot-on;
+					};
+
+				ldoln_reg: ldoln {
+						/* VDDA_1V8_PLL */
+						regulator-name = "ldoln";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				ldousb_reg: ldousb {
+						/* VDDA_3V_USB: VDDA_USBHS33 */
+						regulator-name = "ldousb";
+						regulator-min-microvolt = <3300000>;
+						regulator-max-microvolt = <3300000>;
+						regulator-boot-on;
+					};
+
+				};
+			};
+		};
 };
 
 &i2c2 {
