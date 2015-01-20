Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbbATOAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:00:39 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:28104 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbbATOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:00:34 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1421762431!38105887!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <99c7b7fb380070e5a2f7f4e9f333e8a2b12b591a.1421762065.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1421762065.git.stwiss.opensource@diasemi.com>
References: <cover.1421762065.git.stwiss.opensource@diasemi.com>
From: Steve Twiss <stwiss.opensource@diasemi.com>
Date: Tue, 20 Jan 2015 13:54:25 +0000
Subject: [PATCH V3 2/2] devicetree: Add bindings for DA9063
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>
CC: DT <devicetree@vger.kernel.org>, David Dajun Chen <david.chen@diasemi.com>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "Support Opensource" <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

Add device tree bindings for DA9063 regulators; Real-Time Clock
and Watchdog.

This patch is dependent on PATCH V2 1/2 

Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>

---
This patch applies against linux-next and v3.19-rc4 

 Documentation/devicetree/bindings/mfd/da9063.txt | 93 ++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9063.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9063.txt b/Documentation/devicetree/bindings/mfd/da9063.txt
new file mode 100644
index 0000000..42c6fa6
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9063.txt
@@ -0,0 +1,93 @@
+* Dialog DA9063 Power Management Integrated Circuit (PMIC)
+
+DA9093 consists of a large and varied group of sub-devices (I2C Only):
+
+Device                   Supply Names    Description
+------                   ------------    -----------
+da9063-regulator        :               : LDOs & BUCKs
+da9063-rtc              :               : Real-Time Clock
+da9063-watchdog         :               : Watchdog
+
+======
+
+Required properties:
+
+- compatible : Should be "dlg,da9063"
+- reg : Specifies the I2C slave address (this defaults to 0x58 but it can be
+  modified to match the chip's OTP settings).
+- interrupt-parent : Specifies the reference to the interrupt controller for
+  the DA9063.
+- interrupts : IRQ line information.
+- interrupt-controller
+
+Sub-nodes:
+
+- regulators : This node defines the settings for the LDOs and BUCKs. The
+  DA9063 regulators are bound using their names listed below:
+
+    bcore1    : BUCK CORE1
+    bcore2    : BUCK CORE2
+    bpro      : BUCK PRO
+    bmem      : BUCK MEM
+    bio       : BUCK IO
+    bperi     : BUCK PERI
+    ldo1      : LDO_1
+    ldo2      : LDO_2
+    ldo3      : LDO_3
+    ldo4      : LDO_4
+    ldo5      : LDO_5
+    ldo6      : LDO_6
+    ldo7      : LDO_7
+    ldo8      : LDO_8
+    ldo9      : LDO_9
+    ldo10     : LDO_10
+    ldo11     : LDO_11
+
+  The component follows the standard regulator framework and the bindings
+  details of individual regulator device can be found in:
+  Documentation/devicetree/bindings/regulator/regulator.txt
+
+- rtc : This node defines settings for the Real-Time Clock associated with
+  the DA9063. There are currently no entries in this binding, however
+  compatible = "dlg,da9063-rtc" should be added if a node is created.
+
+- watchdog : This node defines settings for the Watchdog timer associated
+  with the DA9063. There are currently no entries in this binding, however
+  compatible = "dlg,da9063-watchdog" should be added if a node is created.
+
+
+Example:
+
+	pmic0: da9063@58 {
+		compatible = "dlg,da9063"
+		reg = <0x58>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-controller;
+
+		rtc {
+			compatible = "dlg,da9063-rtc";
+		};
+
+		wdt {
+			compatible = "dlg,da9063-watchdog";
+		};
+
+		regulators {
+			DA9063_BCORE1: bcore1 {
+				regulator-name = "BCORE1";
+				regulator-min-microvolt = <300000>;
+				regulator-max-microvolt = <1570000>;
+				regulator-min-microamp = <500000>;
+				regulator-max-microamp = <2000000>;
+				regulator-boot-on;
+			};
+			DA9063_LDO11: ldo11 {
+				regulator-name = "LDO_11";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <3600000>;
+				regulator-boot-on;
+			};
+		};
+	};
+
-- 
end-of-patch for PATCH V3

