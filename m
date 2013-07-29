Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab3G2RBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:01:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58145 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3G2RBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:01:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH v3 5/6] Documentation: Add device tree bindings for DA9063 PMIC
Date: Mon, 29 Jul 2013 19:00:46 +0200
Message-Id: <1375117247-6376-6-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
References: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for the Dialog Semiconductors
DA9063 PMIC and its regulator nodes.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/mfd/da9063-i2c.txt         | 68 ++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9063-i2c.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9063-i2c.txt b/Documentation/devicetree/bindings/mfd/da9063-i2c.txt
new file mode 100644
index 0000000..776b662
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9063-i2c.txt
@@ -0,0 +1,68 @@
+* Dialog DA9063 Power Management Integrated Circuit (PMIC)
+
+Required properties:
+- compatible : Should be "dialog,da9063"
+- interrupt-parent : phandle pointing to the interrupt controller
+- interrupts : interrupt number and flags in interrupt-parent
+  for the chip IRQ line. Interrupt bindings are documented here:
+  Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+
+Sub-nodes:
+- regulators : Contain the regulator nodes. The DA9063 regulators are
+  bound using their names as listed below:
+
+    bcore1     : regulator BCORE1
+    bcore2     : regulator BCORE2
+    bpro       : regulator BPRO
+    bmem       : regulator BMEM
+    bio        : regulator BIO
+    bperi      : regulator BPERI
+    ldo1       : regulator LDO1
+    ldo2       : regulator LDO4
+    ldo3       : regulator LDO3
+    ldo4       : regulator LDO4
+    ldo5       : regulator LDO5
+    ldo6       : regulator LDO6
+    ldo7       : regulator LDO7
+    ldo8       : regulator LDO8
+    ldo9       : regulator LDO9
+    ldo10      : regulator LDO10
+    ldo11      : regulator LDO11
+
+  The PMIC can also be configured to merge both bcore1/2 into a single
+  supply and to merge bmem and bio into a single supply. In this case,
+  the following regulators are bound instead of bcore1/2 and bpro/bmem:
+
+    bcores-merged   : merged regulators BCORE1, BCORE2
+    bmem-bio-merged : merged regulators BMEM, BIO
+
+  See Documentation/devicetree/bindings/regulator/regulator.txt for
+  binding details of individual regulator device nodes.
+
+
+Examples:
+
+&i2c1 {
+	status = "okay";
+
+	pmic@58 {
+		compatible = "dialog,da9063";
+		reg = <0x58>;
+		interrupt-parent = <&gpio4>;
+		interrupts = <17 0x8>; /* active-low GPIO4_17 */
+
+		regulators {
+			bcore1 {
+				regulator-min-microvolt = <300000>;
+				regulator-max-microvolt = <1570000>;
+			};
+
+			bcore2 {
+				regulator-min-microvolt = <300000>;
+				regulator-max-microvolt = <1570000>;
+			};
+
+			/* ... */
+		};
+	};
+};
-- 
1.8.3.2

