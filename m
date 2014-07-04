Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaGDH7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:59:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaGDH7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:59:05 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-d5-53b65ec69981
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, devicetree@vger.kernel.org
Subject: [PATCH v2 5/5] devicetree: mfd: max14577: Add device tree bindings
 document
Date: Fri, 04 Jul 2014 09:58:29 +0200
Message-id: <1404460709-17178-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404460709-17178-1-git-send-email-k.kozlowski@samsung.com>
References: <1404460709-17178-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xq7rH4rYFG+z/zmaxccZ6VoupD5+w
	WUx68p7ZYv6Rc6wWE1dOZrbof7OQ1eLcq5WMFq9fGFqcbXrDbnH/61FGi29XOpgsLu+aw2ax
	9shddoul1y8yWUyYvpbFonXvEXaL092sFutnvGZxEPJYM28No8flvl4mj52z7rJ7rFz+hc1j
	8wotj02rOtk87lzbw+Yx72SgR9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGUs3tvMWPBPo+Lp
	xinsDYxzFbsYOTkkBEwkrrw4xQ5hi0lcuLeerYuRi0NIYCmjxJn3x1kgnD4mifezp7GCVLEJ
	GEtsXr6EDcQWEaiU+Hb6BFgRs8A1FonT3/eDFQkLhEncvT0HzGYRUJXY+30jM4jNK+Au0X1w
	ExvEOjmJk8cmg9VwCnhIfDr9DiwuBFTTsGAy0wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS
	9ZLzczcxQgL+6w7GpcesDjEKcDAq8fC+0N8ULMSaWFZcmXuIUYKDWUmEt0ppW7AQb0piZVVq
	UX58UWlOavEhRiYOTqkGxv5+h1KNvr7G1DOy8S2J896+z1icJXkz6qOuQv5sxec7NVQZuFZ2
	iSw6mhlz29PnmbpcdGT5g+Cf7h8b3mzVq/49W+bD3uZLW45OcXTTN0759lfO9eX2eqZbl+f4
	SL6Rljp/vXbuxq9HJ3PtCDOMu7MgcEdkislph1NydYGR80UCIg1nbMjarcRSnJFoqMVcVJwI
	ANhqMuVWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document describing device tree bindings for MAX14577 MFD
drivers: MFD core, extcon, regulator and charger.

Both MAX14577 and MAX77836 chipsets are documented.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++++++++++++
 1 file changed, 152 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
new file mode 100644
index 000000000000..b235250a7b41
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max14577.txt
@@ -0,0 +1,152 @@
+Maxim MAX14577/77836 Multi-Function Device
+
+MAX14577 is a Multi-Function Device with Micro-USB Interface Circuit, Li+
+Battery Charger and SFOUT LDO output for powering USB devices. It is
+interfaced to host controller using I2C.
+
+MAX77836 additionally contains PMIC (with two LDO regulators) and Fuel Gauge.
+
+
+Required properties:
+- compatible : Must be "maxim,max14577" or "maxim,max77836".
+- reg : I2C slave address for the max14577 chip (0x25 for max14577/max77836)
+- interrupts : IRQ line for the chip.
+- interrupt-parent :  The parent interrupt controller.
+
+
+Required nodes:
+ - charger :
+	Node for configuring the charger driver.
+	Required properties:
+		- compatible : "maxim,max14577-charger"
+			or "maxim,max77836-charger"
+		- maxim,fast-charge-timer : Timer in hours to trigger the
+			INT3/MBCCHGERR interrupt; Valid values:
+			- 5, 6 or 7 (hours),
+			- 0 to disable.
+		- maxim,fast-charge-uamp : Current in uA for Fast Charge;
+			Valid values:
+			- for max14577: 90000 - 950000;
+			- for max77836: 45000 - 475000;
+		- maxim,eoc-uamp : Current in uA for End-Of-Charge mode;
+			Valid values:
+			- for max14577: 50000 - 200000;
+			- for max77836: 5000 - 100000;
+		- maxim,ovp-uvolt : OverVoltage Protection Threshold in uV;
+			In an overvoltage condition, INT asserts and charging
+			stops. Valid values:
+			- 6000000, 6500000, 7000000, 7500000;
+		- maxim,constant-uvolt : Battery Constant Voltage in uV;
+			Valid values:
+			- 4000000 - 4280000 (step by 20000);
+			- 4350000;
+
+
+Optional nodes:
+- max14577-muic/max77836-muic :
+	Node used only by extcon consumers.
+	Required properties:
+		- compatible : "maxim,max14577-muic" or "maxim,max77836-muic"
+
+- regulators :
+	Required properties:
+		- compatible : "maxim,max14577-regulator"
+			or "maxim,max77836-regulator"
+
+	May contain a sub-node per regulator from the list below. Each
+	sub-node should contain the constraints and initialization information
+	for that regulator. See regulator.txt for a description of standard
+	properties for these sub-nodes.
+
+	List of valid regulator names:
+	- for max14577: CHARGER, SAFEOUT.
+	- for max77836: CHARGER, SAFEOUT, LDO1, LDO2.
+
+	The SAFEOUT is a fixed voltage regulator so there is no need to specify
+	voltages for it.
+
+
+Example:
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+max14577@25 {
+	compatible = "maxim,max14577";
+	reg = <0x25>;
+	interrupt-parent = <&gpx1>;
+	interrupts = <5 IRQ_TYPE_NONE>;
+
+	muic: max14577-muic {
+		compatible = "maxim,max14577-muic";
+	};
+
+	regulators {
+		compatible = "maxim,max14577-regulator";
+
+		SAFEOUT {
+			regulator-name = "SAFEOUT";
+		};
+		CHARGER {
+			regulator-name = "CHARGER";
+			regulator-min-microamp = <90000>;
+			regulator-max-microamp = <950000>;
+			regulator-boot-on;
+		};
+	};
+
+	charger {
+		compatible = "maxim,max14577-charger";
+
+		maxim,fast-charge-timer = <6>;
+		maxim,constant-uvolt = <4350000>;
+		maxim,fast-charge-uamp = <450000>;
+		maxim,eoc-uamp = <50000>;
+		maxim,ovp-uvolt = <6500000>;
+	};
+};
+
+
+max77836@25 {
+	compatible = "maxim,max77836";
+	reg = <0x25>;
+	interrupt-parent = <&gpx1>;
+	interrupts = <5 IRQ_TYPE_NONE>;
+
+	muic: max77836-muic {
+		compatible = "maxim,max77836-muic";
+	};
+
+	regulators {
+		compatible = "maxim,max77836-regulator";
+
+		SAFEOUT {
+			regulator-name = "SAFEOUT";
+		};
+		CHARGER {
+			regulator-name = "CHARGER";
+			regulator-min-microamp = <90000>;
+			regulator-max-microamp = <950000>;
+			regulator-boot-on;
+		};
+		LDO1 {
+			regulator-name = "LDO1";
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
+		LDO2 {
+			regulator-name = "LDO2";
+			regulator-min-microvolt = <800000>;
+			regulator-max-microvolt = <3950000>;
+		};
+	};
+
+	charger {
+		compatible = "maxim,max77836-charger";
+
+		maxim,fast-charge-timer = <6>;
+		maxim,constant-uvolt = <4350000>;
+		maxim,fast-charge-uamp = <225000>;
+		maxim,eoc-uamp = <7500>;
+		maxim,ovp-uvolt = <6500000>;
+	};
+};
-- 
1.9.1

