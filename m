Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3LRFaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:30:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:14288 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3LRFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:30:07 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-doc@vger.kernel.org>, <vpalatin@chromium.org>,
        <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH v3 3/3] ARM: dts: sama5d3xcm: add the regulator device node
Date: Wed, 18 Dec 2013 13:25:01 +0800
Message-ID: <1387344301-19843-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387343691-18985-1-git-send-email-wenyou.yang@atmel.com>
References: <1387343691-18985-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/boot/dts/sama5d3xcm.dtsi |   46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index 726a0f3..4571751 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -38,6 +38,52 @@
 			macb0: ethernet@f0028000 {
 				phy-mode = "rgmii";
 			};
+
+			i2c1: i2c@f0018000 {
+				pmic: act8865@5b {
+					compatible = "active-semi,act8865";
+					reg = <0x5b>;
+					status = "disabled";
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
+							regulator-min-microvolt = <1100000>;
+							regulator-max-microvolt = <1300000>;
+							regulator-suspend-mem-microvolt = <1150000>;
+							regulator-suspend-standby-microvolt = <1150000>;
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
+							regulator-name = "VDDANA";
+							regulator-min-microvolt = <3300000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+
+						vddana_reg: LDO_REG2 {
+							regulator-name = "FUSE_2V5";
+							regulator-min-microvolt = <2500000>;
+							regulator-max-microvolt = <2500000>;
+						};
+					};
+				};
+			};
 		};
 
 		nand0: nand@60000000 {
-- 
1.7.9.5

