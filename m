Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3BRFMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:12:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52994 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3BRFMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:12:47 -0500
From: J Keerthy <j-keerthy@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b-cousson@ti.com>
CC: <j-keerthy@ti.com>, <gg@slimlogic.co.uk>
Subject: [PATCH 1/4] documentation: add palmas dts definition
Date: Mon, 18 Feb 2013 10:41:23 +0530
Message-ID: <1361164283-3133-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

Add the DTS definition for the palmas device including the MFD children.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
[j-keerthy@ti.com: changed the DT node property names to follow the
convention]
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 Documentation/devicetree/bindings/mfd/palmas.txt |   67 ++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
new file mode 100644
index 0000000..5fa922e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -0,0 +1,67 @@
+Texas Instruments Palmas family
+
+The Palmas familly are Integrated Power Management Chips.
+These chips are connected to an i2c bus.
+
+
+Required properties:
+- compatible : Must be "ti,palmas";
+  For Integrated power-management in the palmas series, twl6035, twl6037,
+  tps65913
+- interrupts : This i2c device has an IRQ line connected to the main SoC
+- interrupt-controller : Since the palmas support several interrupts internally,
+  it is considered as an interrupt controller cascaded to the SoC one.
+- #interrupt-cells = <1>;
+- interrupt-parent : The parent interrupt controller.
+
+Optional node:
+- Child nodes contain in the palmas. The palmas family is made of several
+  variants that support a different number of features.
+  The child nodes will thus depend of the capability of the variant.
+- mux-pad1 if a value is given it will be used for the pad1 mux
+- mux-pad2 if a value us given it will be used for the pad2 mux
+- power-ctrl if a value is given it will be written to the POWER_CTRL register
+
+Example:
+/*
+ * Integrated Power Management Chip Palmas
+ */
+palmas@48 {
+    compatible = "ti,palmas";
+    reg = <0x48>;
+    interrupts = <39>; /* IRQ_SYS_1N cascaded to gic */
+    interrupt-controller;
+    #interrupt-cells = <1>;
+    interrupt-parent = <&gic>;
+    #address-cells = <1>;
+    #size-cells = <0>;
+
+	ti,mux-pad1 = <0x00>;
+	ti,mux-pad2 = <0x00>;
+	ti,power-ctrl = <0x03>;
+
+	palmas_pmic {
+		compatible = "ti,palmas_pmic";
+		regulators {
+			smps12_reg: smps12 {
+				regulator-min-microvolt = < 600000>;
+                regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+                ti,warm-sleep = <0>;
+                ti,roof-floor = <0>;
+                ti,mode-sleep = <0>;
+                ti,warm-reset = <0>;
+                ti,tstep = <0>;
+                ti,vsel = <0>;
+			};
+		};
+		ti,ldo6-vibrator = <0>;
+	};
+
+    palmas_rtc {
+        compatible = "ti,palmas_rtc";
+        interrupts = <8 9>;
+        reg = <0>;
+    };
+};
-- 
1.7.5.4

