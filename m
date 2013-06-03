Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3FCMQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:16:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41262 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab3FCMQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:16:44 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <swarren@wwwdotorg.org>, <broonie@opensource.wolfsonmicro.com>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <mturquette@linaro.org>,
        <sameo@linux.intel.com>, <wim@iguana.be>, <lgirdwood@gmail.com>,
        <gg@slimlogic.co.uk>, <t-kristo@ti.com>, J Keerthy <j-keerthy@ti.com>,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: [PATCH] mfd: DT bindings for the palmas family MFD
Date: Mon, 3 Jun 2013 17:38:53 +0530
Message-ID: <1370261333-5121-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk> 

Add the various binding files for the palmas family of chips. There is a
top level MFD binding then a seperate binding for regulators IP blocks on chips.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 Documentation/devicetree/bindings/mfd/palmas.txt   |   49 ++++++
 .../devicetree/bindings/regulator/palmas-pmic.txt  |  165 ++++++++++++++++++++
 2 files changed, 214 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/palmas-pmic.txt

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
new file mode 100644
index 0000000..c6c5e78
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -0,0 +1,49 @@
+* palmas device tree bindings
+
+The TI palmas family current members :-
+twl6035 (palmas)
+twl6037 (palmas)
+tps65913 (palmas)
+tps65914 (palmas)
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035
+  ti,twl6036
+  ti,twl6037
+  ti,tps65913
+  ti,tps65914
+  ti,tps80036
+and also the generic series names
+  ti,palmas
+- interrupt-controller : palmas has its own internal IRQs
+- #interrupt-cells : should be set to 2 for IRQ number and flags
+  The first cell is the IRQ number.
+  The second cell is the flags, encoded as the trigger masks from
+  Documentation/devicetree/bindings/interrupts.txt
+- interrupt-parent : The parent interrupt controller.
+
+Optional properties:
+  ti,mux_padX : set the pad register X (1-2) to the correct muxing for the
+  		hardware, if not set will use muxing in OTP.
+
+Example:
+
+palmas {
+	compatible = "ti,twl6035", "ti,palmas";
+	reg = <0x48>
+	interrupt-parent = <&intc>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+
+	ti,mux-pad1 = <0>;
+	ti,mux-pad2 = <0>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	pmic {
+		compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
+		....
+	};
+}
diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
new file mode 100644
index 0000000..f7bbc3e
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -0,0 +1,165 @@
+* palmas regulator IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-pmic
+  ti,twl6036-pmic
+  ti,twl6037-pmic
+  ti,tps65913-pmic
+  ti,tps65914-pmic
+and also the generic series names
+  ti,palmas-pmic
+
+Optional properties:
+- ti,ldo6-vibrator : ldo6 is in vibrator mode
+
+Optional nodes:
+- regulators : should contain the constrains and init information for the
+	       regulators. It should contain a subnode per regulator from the
+	       list.
+	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
+	       smps45, smps457, smps7 depending on varient, smps6, smps[8-10],
+	       ldo[1-9], ldoln, ldousb
+
+	       optional chip specific regulator fields :-
+	       ti,warm-reset - maintain voltage during warm reset(boolean)
+	       ti,roof-floor - control voltage selection by pin(boolean)
+	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 - auto,
+	       2 - eco, 3 - forced pwm
+	       ti,tstep - slope control 0 - Jump, 1 10mV/us, 2 5mV/us, 3 2.5mV/us
+	       ti,smps-range - OTP has the wrong range set for the hardware so override
+	       0 - low range, 1 - high range
+
+Example:
+
+pmic@0 {
+	compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
+	interrupt-parent = <&palmas>;
+	interrupts = <14 0>;
+	interrupt-name = "short-irq";
+
+	ti,ldo6_vibrator;
+
+	regulators {
+		smps12_reg : smps12 {
+			regulator-name = "smps12";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-always-on;
+			regulator-boot-on;
+			ti,warm-reset;
+			ti,roof-floor;
+			ti,mode-sleep = <0>;
+			ti,tstep = <0>;
+			ti,smps-range = <1>;
+		};
+
+		smps3_reg: smps3 {
+			regulator-name = "smps3";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1310000>;
+		};
+
+		smps45_reg: smps45 {
+			regulator-name = "smps45";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1310000>;
+		};
+
+		smps6_reg: smps6 {
+			regulator-name = "smps6";
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
+
+		smps7_reg: smps7 {
+			regulator-name = "smps7";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		smps8_reg: smps8 {
+			regulator-name = "smps8";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1310000>;
+		};
+
+		smps9_reg: smps9 {
+			regulator-name = "smps9";
+			regulator-min-microvolt = <2100000>;
+			regulator-max-microvolt = <2100000>;
+		};
+
+		smps10_reg: smps10 {
+			regulator-name = "smps10";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+		};
+
+		ldo1_reg: ldo1 {
+			regulator-name = "ldo1";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+		};
+
+		ldo2_reg: ldo2 {
+			regulator-name = "ldo2";
+			regulator-min-microvolt = <2900000>;
+			regulator-max-microvolt = <2900000>;
+		};
+
+		ldo3_reg: ldo3 {
+			regulator-name = "ldo3";
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3000000>;
+		};
+
+		ldo4_reg: ldo4 {
+			regulator-name = "ldo4";
+			regulator-min-microvolt = <2200000>;
+			regulator-max-microvolt = <2200000>;
+		};
+
+		ldo5_reg: ldo5 {
+			regulator-name = "ldo5";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		ldo6_reg: ldo6 {
+			regulator-name = "ldo6";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+		};
+
+		ldo7_reg: ldo7 {
+			regulator-name = "ldo7";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+		};
+
+		ldo8_reg: ldo8 {
+			regulator-name = "ldo8";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+		};
+
+		ldo9_reg: ldo9 {
+			regulator-name = "ldo9";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		ldoln_reg: ldoln {
+			regulator-name = "ldoln";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		ldousb_reg: ldousb {
+			regulator-name = "ldousb";
+			regulator-min-microvolt = <3250000>;
+			regulator-max-microvolt = <3250000>;
+		};
+	};
+};
-- 
1.7.5.4

