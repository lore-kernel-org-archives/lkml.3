Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaDUEnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:43:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24393 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaDUEgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:36:12 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <broonie@kernel.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.u>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wenyou.yang@atmel.com>
Subject: [PATCH] ARM: dts: at91-sama5d3_xplained: add the regulator device node
Date: Mon, 21 Apr 2014 12:29:07 +0800
Message-ID: <1398054547-5834-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts |   42 +++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index ce13755..57cdd83 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -48,6 +48,48 @@
 
 			i2c1: i2c@f0018000 {
 				status = "okay";
+
+				pmic: act8865@5b {
+					compatible = "active-semi,act8865";
+					reg = <0x5b>;
+					status = "okay";
+
+					regulators {
+						vcc_1v8_reg: DCDC_REG1 {
+							regulator-name = "VCC_1V8";
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <1800000>;
+							regulator-always-on;
+						};
+
+						vcc_1v2_reg: DCDC_REG2 {
+							regulator-name = "VCC_1V2";
+							regulator-min-microvolt = <1200000>;
+							regulator-max-microvolt = <1200000>;
+							regulator-always-on;
+						};
+
+						vcc_3v3_reg: DCDC_REG3 {
+							regulator-name = "VCC_3V3";
+							regulator-min-microvolt = <3300000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+
+						vddfuse_reg: LDO_REG1 {
+							regulator-name = "FUSE_2V5";
+							regulator-min-microvolt = <2500000>;
+							regulator-max-microvolt = <2500000>;
+						};
+
+						vddana_reg: LDO_REG2 {
+							regulator-name = "VDDANA";
+							regulator-min-microvolt = <3300000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+					};
+				};
 			};
 
 			macb0: ethernet@f0028000 {
-- 
1.7.9.5

