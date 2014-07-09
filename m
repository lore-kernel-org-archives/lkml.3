Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaGIFiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:38:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44666 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaGIFio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:38:44 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v3 2/7] mfd: Add DT bindings for tps65218 PMIC
Date: Wed, 9 Jul 2014 11:06:28 +0530
Message-ID: <1404884193-20580-3-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404884193-20580-1-git-send-email-j-keerthy@ti.com>
References: <1404884193-20580-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings for tps65218 PMIC

Signed-off-by: Keerthy <j-keerthy@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/devicetree/bindings/mfd/tps65218.txt |   89 ++++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt

diff --git a/Documentation/devicetree/bindings/mfd/tps65218.txt b/Documentation/devicetree/bindings/mfd/tps65218.txt
new file mode 100644
index 0000000..01ac973
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/tps65218.txt
@@ -0,0 +1,89 @@
+Texas Instruments TPS65218 family
+
+The TPS65218 are Integrated Power Management Chips.
+
+Required properties:
+- compatible : Must be "ti,tps65218";
+  For Integrated power-management used in AM437x based boards
+- interrupts : This i2c device has an IRQ line connected to the main SoC
+- interrupt-controller : Since the tps65218 supports several interrupts
+  internally, it is considered as an interrupt controller cascaded to the
+  SoC one.
+- #interrupt-cells = <2>;
+- interrupt-parent : The parent interrupt controller which is gic.
+
+Optional node:
+- TPS65218 PMIC has a number of child nodes. Mainly the regularors and SMPSs.
+
+Example:
+/*
+ * Integrated Power Management Chip
+ */
+tps65218: tps65218@24 {
+	reg = <0x24>;
+	compatible = "ti,tps65218";
+	interrupts = <GIC_SPI 7 IRQ_TYPE_NONE>; /* NMIn */
+	interrupt-parent = <&gic>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+
+	dcdc1: regulator-dcdc1 {
+		compatible = "ti,tps65218-dcdc1";
+		/* VDD_CORE voltage limits min of OPP50 and max of OPP100 */
+		regulator-name = "vdd_core";
+		regulator-min-microvolt = <912000>;
+		regulator-max-microvolt = <1144000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	dcdc2: regulator-dcdc2 {
+		compatible = "ti,tps65218-dcdc2";
+		/* VDD_MPU voltage limits min of OPP50 and max of OPP_NITRO */
+		regulator-name = "vdd_mpu";
+		regulator-min-microvolt = <912000>;
+		regulator-max-microvolt = <1378000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	dcdc3: regulator-dcdc3 {
+		compatible = "ti,tps65218-dcdc3";
+		regulator-name = "vdcdc3";
+		regulator-min-microvolt = <1350000>;
+		regulator-max-microvolt = <1350000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	dcdc4: regulator-dcdc4 {
+		compatible = "ti,tps65218-dcdc4";
+		regulator-name = "v3_3d";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	dcdc5: regulator-dcdc5 {
+		compatible = "ti,tps65218-dcdc5";
+		regulator-name = "v1_0bat";
+		regulator-min-microvolt = <1000000>;
+		regulator-max-microvolt = <1000000>;
+	};
+
+	dcdc6: regulator-dcdc6 {
+		compatible = "ti,tps65218-dcdc6";
+		regulator-name = "v1_8vat";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+	};
+
+	ldo1: regulator-ldo1 {
+		compatible = "ti,tps65218-ldo1";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+};
-- 
1.7.9.5

