Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbaD2Qhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:37:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33749 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbaD2Qhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:37:39 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/3] regulator: ltc3589: Add DT binding documentation
Date: Tue, 29 Apr 2014 18:37:09 +0200
Message-Id: <1398789430-23897-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
References: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree binding documentation for Linear
Technology LTC3589, LTC3589-1, and LTC3589-2 8-port regulators.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../devicetree/bindings/regulator/ltc3589.txt      | 99 ++++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/ltc3589.txt

diff --git a/Documentation/devicetree/bindings/regulator/ltc3589.txt b/Documentation/devicetree/bindings/regulator/ltc3589.txt
new file mode 100644
index 0000000..4229a2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/ltc3589.txt
@@ -0,0 +1,99 @@
+Linear Technology LTC3589, LTC3589-1, and LTC3589-2 8-output regulators
+
+Required properties:
+- compatible: "ltc,ltc3589", "ltc,ltc3589-1" or "ltc,ltc3589-2"
+- reg: I2C slave address
+
+Required child node:
+- regulators: Contains eight regulator child nodes sw1, sw2, sw3, bb-out,
+  ldo1, ldo2, ldo3, and ldo4, specifying the initialization data as
+  documented in Documentation/devicetree/bindings/regulator/regulator.txt.
+
+Each regulator is defined using the standard binding for regulators. The
+nodes for sw1, sw2, sw3, bb-out, ldo1, and ldo2 additionally need to specify
+the resistor values of their external feedback voltage dividers:
+
+Required properties (not on ldo3, ldo4):
+- ltc,fb-voltage-divider: An array of two integers containing the resistor
+  values R1 and R2 of the feedback voltage divider in ohms.
+
+Regulators sw1, sw2, sw3, and ldo2 can regulate the feedback reference from
+0.3625 V to 0.75 V in 12.5 mV steps. The output voltage thus ranges between
+0.3625 * (1 + R1/R2) V and 0.75 * (1 + R1/R2) V. Regulators bb-out and ldo1
+have a fixed 0.8 V reference and thus output 0.8 * (1 + R1/R2) V. The ldo3
+regulator is fixed to 1.8 V on LTC3589 and to 2.8 V on LTC3589-1,2. The ldo4
+regulator can output between 1.8 V and 3.3 V on LTC3589 and between 1.2 V
+and 3.2 V on LTC3589-1,2 in four steps. The ldo1 standby regulator can not
+be disabled and thus should have the regulator-always-on property set.
+
+Example:
+
+	ltc3589: pmic@34 {
+		compatible = "ltc,ltc3589-1";
+		reg = <0x34>;
+
+		regulators {
+			sw1_reg: sw1 {
+				regulator-min-microvolt = <591930>;
+				regulator-max-microvolt = <1224671>;
+				ltc,fb-voltage-divider = <100000 158000>;
+				regulator-ramp-delay = <7000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			sw2_reg: sw2 {
+				regulator-min-microvolt = <704123>;
+				regulator-max-microvolt = <1456803>;
+				ltc,fb-voltage-divider = <180000 191000>;
+				regulator-ramp-delay = <7000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			sw3_reg: sw3 {
+				regulator-min-microvolt = <1341250>;
+				regulator-max-microvolt = <2775000>;
+				ltc,fb-voltage-divider = <270000 100000>;
+				regulator-ramp-delay = <7000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			bb_out_reg: bb-out {
+				regulator-min-microvolt = <3387341>;
+				regulator-max-microvolt = <3387341>;
+				ltc,fb-voltage-divider = <511000 158000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo1_reg: ldo1 {
+				regulator-min-microvolt = <1306329>;
+				regulator-max-microvolt = <1306329>;
+				ltc,fb-voltage-divider = <100000 158000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo2_reg: ldo2 {
+				regulator-min-microvolt = <704123>;
+				regulator-max-microvolt = <1456806>;
+				ltc,fb-voltage-divider = <180000 191000>;
+				regulator-ramp-delay = <7000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo3_reg: ldo3 {
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-boot-on;
+			};
+
+			ldo4_reg: ldo4 {
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3200000>;
+			};
+		};
+	};
-- 
1.9.1

