Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935132AbaH0PUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:20:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39139 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935105AbaH0PUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:20:31 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ef-53fdf73c2740
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 7/8] devicetree: mfd: max14577: Add device tree bindings
 document
Date: Wed, 27 Aug 2014 17:20:13 +0200
Message-id: <1409152814-17302-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xy7o23/8GG7TOlbPYOGM9q8XUh0/Y
	LCY9ec9sMf/IOVaLiSsnM1v0v1nIanHu1UpGi9cvDC3ONr1ht7j/9SijxbcrHUwWm793sFlc
	3jWHzeJz7xFGi7VH7rJbLL1+kcliwvS1LBate4+wW5zuZrU4vbvEQcRjzbw1jB6X+3qZPHbO
	usvusXL5FzaPzSu0PDat6mTzuHNtD5vHvJOBHn1bVjF6fN4kF8AVxWWTkpqTWZZapG+XwJWx
	dNdN1oLVqhUdC9cwNTDOkuti5OSQEDCRuPNgFQuELSZx4d56ti5GLg4hgaWMEq3HZ7JCOH1M
	EqfezWcGqWITMJbYvHwJG4gtIrCASeLiulyQImaBF8wSj9buBisSFgiT6Fq5CqyIRUBV4vuU
	GUCTODh4Bdwl7r93gtgmJ3Hy2GRWEJtTwEPiZe8FJpASIaCSu/P4JzDyLmBkWMUomlqaXFCc
	lJ5rpFecmFtcmpeul5yfu4kREv5fdzAuPWZ1iFGAg1GJh1fh9J9gIdbEsuLK3EOMEhzMSiK8
	ZQf+BgvxpiRWVqUW5ccXleakFh9iZOLglGpgzPx0rm2qqaxMQ9xDi+Y3T79UnHdewPP+pZje
	QZ6nEXMZHTTXzJqnkLZ+oxWv5dqlp/cotc15fe/Go4joMMafsyfWOM2RlV4s8enq39ILm/ga
	eq2S/O3N3Fi1JK3kz0u1zZpfmiT/nOeC4bZfK1dGJJXO4frQx5P7XnnGmsi2Q9tfeTTE1ft/
	UWIpzkg01GIuKk4EAFsgeKpdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document describing device tree bindings for MAX14577 MFD
drivers: MFD core, extcon, regulator and charger.

Both MAX14577 and MAX77836 chipsets are documented.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: devicetree@vger.kernel.org
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max14577.txt | 146 +++++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
new file mode 100644
index 000000000000..236264c10b92
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max14577.txt
@@ -0,0 +1,146 @@
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
+		maxim,constant-uvolt = <4350000>;
+		maxim,fast-charge-uamp = <225000>;
+		maxim,eoc-uamp = <7500>;
+		maxim,ovp-uvolt = <6500000>;
+	};
+};
-- 
1.9.1

