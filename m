Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbaCSJEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:04:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44327 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141AbaCSJED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:04:03 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] Documentation: Add device tree bindings for DA9063 PMIC
Date: Wed, 19 Mar 2014 10:03:56 +0100
Message-Id: <1395219836-25018-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0
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
1.9.0

