Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3LCGoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:44:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35528 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab3LCGoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:44:01 -0500
From: Keerthy <j-keerthy@ti.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <grant.likely@linaro.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 1/4] mfd: DT bindings for TPS65218 PMIC
Date: Tue, 3 Dec 2013 12:13:22 +0530
Message-ID: <1386053006-6480-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings for TPS65218 PMIC.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 Documentation/devicetree/bindings/mfd/tps65218.txt |   27 ++++++++++++++++++++
 .../devicetree/bindings/regulator/tps65218.txt     |   22 ++++++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.txt

diff --git a/Documentation/devicetree/bindings/mfd/tps65218.txt b/Documentation/devicetree/bindings/mfd/tps65218.txt
new file mode 100644
index 0000000..87cb7a8
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/tps65218.txt
@@ -0,0 +1,27 @@
+The TPS65218 Integrated Power Management Chips.
+These chips are connected to an i2c bus.
+
+Required properties:
+- compatible : Must be "ti,tps65218";
+- interrupts : This i2c device has an IRQ line connected to the main SoC
+- interrupt-controller : Since the tps65218 support several interrupts
+  internally, it is considered as an interrupt controller cascaded to the SoC.
+- #interrupt-cells = <2>;
+- interrupt-parent : The parent interrupt controller.
+
+Optional node:
+- Child nodes contain in the tps65218.
+  It supports a number of features.
+  The children nodes will thus depend of the capability of the variant.
+
+Example:
+/*
+ * Integrated Power Management Chip
+ */
+tps@24 {
+    compatible = "ti,tps65218";
+    reg = <0x24>;
+    interrupt-controller;
+    #interrupt-cells = <2>;
+    interrupt-parent = <&gic>;
+};
diff --git a/Documentation/devicetree/bindings/regulator/tps65218.txt b/Documentation/devicetree/bindings/regulator/tps65218.txt
new file mode 100644
index 0000000..1ccf170
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/tps65218.txt
@@ -0,0 +1,22 @@
+TPS65218 family of regulators
+
+Required properties:
+For tps65218 regulators/LDOs
+- compatible:
+  - "ti,tps65218-dcdc1" for DCDC1
+  - "ti,tps65218-dcdc2" for DCDC2
+  - "ti,tps65218-dcdc3" for DCDC3
+  - "ti,tps65218-dcdc4" for DCDC4
+  - "ti,tps65218-dcdc5" for DCDC5
+  - "ti,tps65218-dcdc6" for DCDC6
+  - "ti,tps65218-ldo1" for LDO1 LDO
+
+Optional properties:
+- Any optional property defined in bindings/regulator/regulator.txt
+
+Example:
+	xyz: regulator@0 {
+		compatible = "ti,tps65218-dcdc1";
+		regulator-min-microvolt  = <1000000>;
+		regulator-max-microvolt  = <3000000>;
+	};
-- 
1.7.9.5

