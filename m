Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaH3Mvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 08:51:45 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34435 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaH3Mve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 08:51:34 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 4/4] mfd: rn5t618: document device tree bindings
Date: Sat, 30 Aug 2014 14:50:26 +0200
Message-Id: <1409403026-28818-5-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
References: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the device tree bindings documentation for Ricoh RN5T618.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Reviewed-by: Mark Brown <broonie@linaro.org>
---
 Documentation/devicetree/bindings/mfd/rn5t618.txt |   36 +++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rn5t618.txt

diff --git a/Documentation/devicetree/bindings/mfd/rn5t618.txt b/Documentation/devicetree/bindings/mfd/rn5t618.txt
new file mode 100644
index 0000000..937785a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/rn5t618.txt
@@ -0,0 +1,36 @@
+* Ricoh RN5T618 PMIC
+
+Ricoh RN5T618 is a power management IC which integrates 3 step-down
+DCDC converters, 7 low-dropout regulators, a Li-ion battery charger,
+fuel gauge, ADC, GPIOs and a watchdog timer. It can be controlled
+through a I2C interface.
+
+Required properties:
+ - compatible: should be "ricoh,rn5t618"
+ - reg: the I2C slave address of the device
+
+Sub-nodes:
+ - regulators: the node is required if the regulator functionality is
+   needed. The valid regulator names are: DCDC1, DCDC2, DCDC3, LDO1,
+   LDO2, LDO3, LDO4, LDO5, LDORTC1 and LDORTC2.
+   The common bindings for each individual regulator can be found in:
+   Documentation/devicetree/bindings/regulator/regulator.txt
+
+Example:
+
+	pmic@32 {
+		compatible = "ricoh,rn5t618";
+		reg = <0x32>;
+
+		regulators {
+			DCDC1 {
+				regulator-min-microvolt = <1050000>;
+				regulator-max-microvolt = <1050000>;
+			};
+
+			DCDC2 {
+				regulator-min-microvolt = <1175000>;
+				regulator-max-microvolt = <1175000>;
+			};
+		};
+	};
-- 
1.7.10.4

