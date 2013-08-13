Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3HMFq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:46:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59296 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3HMFq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:46:57 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <swarren@wwwdotorg.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <nm@ti.com>, <balajitk@ti.com>,
        <j-keerthy@ti.com>
Subject: [PATCH] ARM: DTS: DRA7: Add TPS659038 PMIC nodes
Date: Tue, 13 Aug 2013 11:12:36 +0530
Message-ID: <1376372556-4244-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch adds nodes for TPS659038 PMIC for DRA7 boards.

It is based on:
http://comments.gmane.org/gmane.linux.ports.arm.omap/102459.

Documentation:	Documentation/devicetree/bindings/mfd/palmas.txt
		Documentation/devicetree/bindings/regulator/palmas-pmic.txt		

Tested on DRA7 Board, 3.11-rc5 plus the above patch-set.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |  118 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index b270e24..96f409f 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -93,6 +93,124 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
 	clock-frequency = <400000>;
+
+	tps659038: tps659038@58 {
+		compatible = "ti,tps659038";
+		reg = <0x58>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+
+		tps659038_pmic {
+			compatible = "ti,tps659038-pmic";
+
+			regulators {
+				smps123_reg: smps123 {
+					/* VDD_MPU */
+						regulator-name = "smps123";
+						regulator-min-microvolt = < 600000>;
+						regulator-max-microvolt = <1500000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				smps45_reg: smps45 {
+						/* VDD_DSPEVE */
+						regulator-name = "smps45";
+						regulator-min-microvolt = < 600000>;
+						regulator-max-microvolt = <1310000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				smps6_reg: smps6 {
+						/* VDD_GPU - over VDD_SMPS6 */
+						regulator-name = "smps6";
+						regulator-min-microvolt = <600000>;
+						regulator-max-microvolt = <13100000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				smps7_reg: smps7 {
+						/* VDDS_CORE */
+						regulator-name = "smps7";
+						regulator-min-microvolt = <600000>;
+						regulator-max-microvolt = <1310000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				smps8_reg: smps8 {
+						/* VDD_IVAHD */
+						regulator-name = "smps8";
+						regulator-min-microvolt = < 600000>;
+						regulator-max-microvolt = <1310000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				smps9_reg: smps9 {
+						/* VDD_1V8 */
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
+					};
+
+				ldo2_reg: ldo2 {
+						/* VDD_RTCIO */
+						regulator-name = "ldo2";
+						regulator-min-microvolt = <3300000>;
+						regulator-max-microvolt = <3300000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				ldo3_reg: ldo3 {
+						/* VDDA_1V8 PHYs */
+						regulator-name = "ldo3";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
+					};
+
+				ldo9_reg: ldo9 {
+						/* VDD_RTC */
+						regulator-name = "ldo9";
+						regulator-min-microvolt = <1000000>;
+						regulator-max-microvolt = <1000000>;
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+				ldoln_reg: ldoln {
+						/* VDDA_1v8: PLLs */
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
+						regulator-min-microvolt = <3250000>;
+						regulator-max-microvolt = <3250000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+				};
+			};
+		};
 };
 
 &i2c2 {
-- 
1.7.9.5

