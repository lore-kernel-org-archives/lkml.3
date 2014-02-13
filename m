Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaBMKtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:49:07 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:15440 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbaBMKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:49:05 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-3.tower-39.messagelabs.com!1392288350!13299030!3
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <574af9f46ca08e66f6e9bda8ef3a51e7c5c5178b.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 13 Feb 2014 10:45:52 +0000
Subject: [PATCH 2/2] mfd: da9055: Add DT binding documentation for PMIC
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/devicetree/bindings/mfd/da9055.txt |   73 ++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9055.txt b/Documentation/devicetree/bindings/mfd/da9055.txt
new file mode 100644
index 0000000..f903c3f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9055.txt
@@ -0,0 +1,73 @@
+* Dialog DA9055 Power Management Integrated Circuit (PMIC)
+
+DA9055 consists of a large and varied group of sub-devices (I2C Only):
+
+Device			 Supply Names	 Description
+------			 ------------	 -----------
+da9055-gpio		:		: GPIOs
+da9055-regulator	:		: Regulators
+da9055-onkey		:		: On key
+da9055-rtc		:		: RTC
+da9055-hwmon		:		: ADC
+da9055-watchdog		:		: Watchdog
+
+The CODEC device in DA9055 has a separate, configurable I2C address and so
+is instantiated separately from the PMIC.
+
+For details on accompanying CODEC I2C device, see the following:
+Documentation/devicetree/bindings/sound/da9055.txt
+
+======
+
+Required properties:
+- compatible : Should be "dlg,da9055-pmic"
+- reg: Specifies the I2C slave address (defaults to 0x5a but can be modified)
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the IRQs from da9055 are delivered to.
+- interrupts: IRQ line info for da9055 chip.
+- interrupt-controller: da9055 has internal IRQs (has own IRQ domain).
+- #interrupt-cells: Should be 1, is the local IRQ number for da9055.
+
+Sub-nodes:
+- regulators : Contain the regulator nodes. The DA9055 regulators are
+  bound using their names as listed below:
+
+    buck1     : regulator BUCK1
+    buck2     : regulator BUCK2
+    ldo1      : regulator LDO1
+    ldo2      : regulator LDO2
+    ldo3      : regulator LDO3
+    ldo4      : regulator LDO4
+    ldo5      : regulator LDO5
+    ldo6      : regulator LDO6
+
+  The bindings details of individual regulator device can be found in:
+  Documentation/devicetree/bindings/regulator/regulator.txt
+
+
+Example:
+
+	pmic: da9055-pmic@5a {
+		compatible = "dlg,da9055-pmic";
+		reg = <0x5a>;
+		interrupt-parent = <&intc>;
+		interrupts = <5 0x8>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		regulators {
+			buck1: BUCK1 {
+				regulator-min-microvolt = <725000>;
+				regulator-max-microvolt = <2075000>;
+			};
+
+			buck2: BUCK2 {
+				regulator-min-microvolt = <925000>;
+				regulator-max-microvolt = <2500000>;
+			};
+			ldo1: LDO1 {
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <3300000>;
+			};
+		};
+	};
--
1.7.0.4

