Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaEVECu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:02:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34477 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaEVECr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:02:47 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>, <sameo@linux.intel.com>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@linaro.org>, <lee.jones@linaro.org>,
        <linux-omap@vger.kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v3 2/4] Regulators: Add TPS65917 Bindings
Date: Thu, 22 May 2014 09:30:37 +0530
Message-ID: <1400731239-3180-3-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400731239-3180-1-git-send-email-j-keerthy@ti.com>
References: <1400731239-3180-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TPS65917 Bindings.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 .../bindings/regulator/tps65917-pmic.txt           |   67 ++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65917-pmic.txt

diff --git a/Documentation/devicetree/bindings/regulator/tps65917-pmic.txt b/Documentation/devicetree/bindings/regulator/tps65917-pmic.txt
new file mode 100644
index 0000000..96d1fb7
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/tps65917-pmic.txt
@@ -0,0 +1,67 @@
+* tps65917 regulator IP block devicetree bindings
+
+Required properties:
+- compatible : Should be
+  ti,tps65917-pmic
+
+- interrupt-parent : The parent interrupt controller which is tps65917.
+- interrupts : The interrupt number and the type which can be looked up here:
+	       arch/arm/boot/dts/include/dt-bindings/interrupt-controller/irq.h
+- interrupts-name: The names of the individual interrupts.
+
+Optional nodes:
+- regulators : Must contain a sub-node per regulator from the list below.
+	       Each sub-node should contain the constraints and initialization
+	       information for that regulator. See regulator.txt for a
+	       description of standard properties for these sub-nodes.
+	       Additional custom properties  are listed below.
+
+	       Optional sub-node properties:
+	       ti,warm-reset - maintain voltage during warm reset(boolean)
+	       ti,roof-floor - This takes as optional argument on platform supporting
+	       the rail from desired external control. If there is no argument then
+	       it will be assume that it is controlled by NSLEEP pin.
+	       The valid value for external pins are:
+			ENABLE1 then 1,
+			ENABLE2 then 2 or
+			NSLEEP then 3.
+	       ti,mode-sleep - mode to adopt in pmic sleep 0 - off, 1 - auto,
+	       2 - eco, 3 - forced pwm
+	       ti,smps-range - OTP has the wrong range set for the hardware so override
+	       0 - low range, 1 - high range.
+
+- ti,system-power-controller: Telling whether or not this pmic is controlling
+			      the system power.
+
+Example:
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+pmic {
+	compatible = "ti,tps65917-pmic";
+	interrupt-parent = <&tps65917>;
+	interrupts = <14 IRQ_TYPE_NONE>;
+	interrupts-name = "short-irq";
+
+	ti,system-power-controller;
+
+	regulators {
+		smps1_reg : smps1 {
+			regulator-name = "smps1";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-always-on;
+			regulator-boot-on;
+			ti,warm-reset;
+			ti,roof-floor = <1>; /* ENABLE1 control */
+			ti,mode-sleep = <0>;
+			ti,smps-range = <1>;
+		};
+
+		ldo1_reg: ldo1 {
+			regulator-name = "ldo1";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+		};
+	};
+};
-- 
1.7.9.5

