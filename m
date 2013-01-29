Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3A2Hjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:39:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40097 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3A2Hje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:39:34 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <anilkumar@ti.com>, <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <khilman@deeprootsystems.com>, <nsekhar@ti.com>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH V2 6/6] ARM: davinci: da850: add tps6507x regulator DT data
Date: Tue, 29 Jan 2013 13:08:54 +0530
Message-ID: <1359445134-13323-7-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tps6507x regulator device tree data to da850-evm by
adding regulator consumers with tightened constraints
and regulator-name.TPS6507x regulator handle can be obtained
by using this regulator name.
Regulator constraints are added as per da850 board file.

Regulator names are given as per maximum output voltage the
regulator is capable to provide.
for e.g. regulator name for dcdc1 is "VDCDC1_3.3V".
Also, add tps6507x PMIC I2C slave device under I2C0 node.

Tested on da850-evm.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
Changes since V1:
 - No change

:100644 100644 c9ed683... 58e6961... M	arch/arm/boot/dts/da850-evm.dts
 arch/arm/boot/dts/da850-evm.dts |   63 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c9ed683..58e6961 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -31,6 +31,10 @@
 			status = "okay";
 			pinctrl-names = "default";
 			pinctrl-0 = <&i2c0_pins>;
+
+			tps: tps@48 {
+				reg = <0x48>;
+			};
 		};
 	};
 	nand_cs3@62000000 {
@@ -38,4 +42,63 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&nand_cs3_pins>;
 	};
+	vbat: fixedregulator@0 {
+		compatible = "regulator-fixed";
+		regulator-name = "vbat";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-boot-on;
+	};
+};
+
+/include/ "tps6507x.dtsi"
+
+&tps {
+        vdcdc1_2-supply = <&vbat>;
+        vdcdc3-supply = <&vbat>;
+        vldo1_2-supply = <&vbat>;
+
+        regulators {
+                vdcdc1_reg: regulator@0 {
+                        regulator-name = "VDCDC1_3.3V";
+                        regulator-min-microvolt = <3150000>;
+                        regulator-max-microvolt = <3450000>;
+                        regulator-always-on;
+                        regulator-boot-on;
+                };
+
+                vdcdc2_reg: regulator@1 {
+                        regulator-name = "VDCDC2_3.3V";
+                        regulator-min-microvolt = <1710000>;
+                        regulator-max-microvolt = <3450000>;
+                        regulator-always-on;
+                        regulator-boot-on;
+                        ti,defdcdc_default = <1>;
+                };
+
+                vdcdc3_reg: regulator@2 {
+                        regulator-name = "VDCDC3_1.2V";
+                        regulator-min-microvolt = <950000>;
+                        regulator-max-microvolt = <1350000>;
+                        regulator-always-on;
+                        regulator-boot-on;
+                        ti,defdcdc_default = <1>;
+                };
+
+                ldo1_reg: regulator@3 {
+                        regulator-name = "LDO1_1.8V";
+                        regulator-min-microvolt = <1710000>;
+                        regulator-max-microvolt = <1890000>;
+                        regulator-always-on;
+                        regulator-boot-on;
+                };
+
+                ldo2_reg: regulator@4 {
+                        regulator-name = "LDO2_1.2V";
+                        regulator-min-microvolt = <1140000>;
+                        regulator-max-microvolt = <1320000>;
+                        regulator-always-on;
+                        regulator-boot-on;
+                };
+        };
 };
-- 
1.7.4.1

