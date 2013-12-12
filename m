Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3LLBYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:24:30 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:60554 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013Ab3LLBY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:24:28 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 20:24:28 EST
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <lgirdwood@gmail.com>
CC: <broonie@kernel.org>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <vpalatin@chromium.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <wenyou.yang@atmel.com>
Subject: [PATCH 2/3] regulator: act8865: add device tree binding doc
Date: Thu, 12 Dec 2013 09:18:50 +0800
Message-ID: <1386811131-2720-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386811131-2720-1-git-send-email-wenyou.yang@atmel.com>
References: <1386811131-2720-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 .../bindings/regulator/act8865-regulator.txt       |   58 ++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/act8865-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
new file mode 100644
index 0000000..e191a92
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
@@ -0,0 +1,58 @@
+ACT8865 regulator
+-------------------
+
+Required properties:
+- compatible: "active-semi,act8865"
+- reg: I2C slave address
+- vsel-state-low: Initial state of vsel0 input is low, to select default output voltage.
+
+Example:
+--------
+
+	i2c1: i2c@f0018000 {
+		status = "okay";
+
+		pmic: act8865@5b {
+			compatible = "active-semi,act8865";
+			reg = <0x5b>;
+			vsel-state-low;
+
+			regulators {
+				vcc_1v8_reg: DCDC_REG1 {
+					regulator-name = "DCDC_REG1";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				vcc_1v2_reg: DCDC_REG2 {
+					regulator-name = "DCDC_REG2";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1300000>;
+					regulator-suspend-mem-microvolt = <1150000>;
+					regulator-suspend-standby-microvolt = <1150000>;
+					regulator-always-on;
+				};
+
+				vcc_3v3_reg: DCDC_REG3 {
+					regulator-name = "DCDC_REG3";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				vddfuse_reg: LDO_REG4 {
+					regulator-name = "LDO_REG4";
+					regulator-min-microvolt = <2500000>;
+					regulator-max-microvolt = <2500000>;
+				};
+
+				vddana_reg: LDO_REG5 {
+					regulator-name = "LDO_REG5";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+			};
+		};
+	};
-- 
1.7.9.5

