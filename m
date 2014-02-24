Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaBXKNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:13:42 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53244 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaBXKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:24 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-72-530b1acb81c0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v4 15/16] mfd: max14577: Add device tree bindings document
Date: Mon, 24 Feb 2014 11:10:40 +0100
Message-id: <1393236641-14977-16-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xy7qnpbiDDbad4bHYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVpMXDmZ2eL1C0OLs01v2C3ufz3KaLHp8TVWi8u75rBZrD1yl91i
	6fWLTBYTpq9lsWjde4Td4nQ3q8X6Ga9ZHAQ91sxbw+ixc9Zddo/NK7Q8Nq3qZPO4c20Pm8e8
	k4Eem5fUe/RtWcXo8XmTXABnFJdNSmpOZllqkb5dAlfG3uNP2Aqma1Scme7YwHhcoYuRk0NC
	wERiRetVJghbTOLCvfVsXYxcHEICSxklrv48COX0MUk0PV/DClLFJmAssXn5ErCEiMAWJone
	D18YQRxmgfdMEm03pzOCVAkLeEksOviKHcRmEVCVuLR+OUsXIwcHr4CHRMPzLBBTQkBBYs4k
	G5AKTqDo3ZYHYPOFBNwlvs27zjKBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCw
	/rKDcfExq0OMAhyMSjy8EtVcwUKsiWXFlbmHGCU4mJVEeM14uYOFeFMSK6tSi/Lji0pzUosP
	MTJxcEo1MKb9FZ1Ufep4AIf/4t0pnKePTzo256OhBWvSvtOWF/0CSz6KHE8xflBZeDxLb419
	IHfx/98VGws/V13KkFw1z+LxTR19n6fSJxknJ5VzMLBvdQiSCa4RKci+G9mh88/gnlu7ipnM
	v73JLVsNjfJO+XU2nWFjflXetdPvv8j7CTaLLxUUv3b1VGIpzkg01GIuKk4EAJI5XQ9JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document describing device tree bindings for MAX14577 MFD
drivers: MFD core, extcon, regulator and charger.

Both MAX14577 and MAX77836 chipsets are documented.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max14577.txt |  149 ++++++++++++++++++++
 1 file changed, 149 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
new file mode 100644
index 000000000000..111115b0a6f3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max14577.txt
@@ -0,0 +1,149 @@
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
+ - charger :
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
1.7.9.5

