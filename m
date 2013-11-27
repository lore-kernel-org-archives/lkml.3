Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3K0Nqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:46:45 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16005 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3K0Nqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:46:38 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-e9-5295f7bb2054
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 2/2] mfd: max14577: Add device tree bindings document
Date: Wed, 27 Nov 2013 14:46:22 +0100
Message-id: <1385559982-32039-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
References: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xy7q7v08NMnj/38Zi44z1rBZTHz5h
	s5h/5ByrxblXKxktXr8wtDjb9Ibd4v7Xo4wW3650MFksbFvCYnF51xw2i7VH7rJbLL1+kcli
	wvS1LBaHVxxgslj3cjqLxeluVotXB9tYHAQ91sxbw+ix4PMVdo+ds+6ye6xc/oXNY9OqTjaP
	V6tnsnrcubaHzWPeyUCPvi2rGD0+b5Lz2Dg3NIA7issmJTUnsyy1SN8ugSvjy5bSgscCFavm
	TmdrYHzA28XIwSEhYCLxepNSFyMnkCkmceHeerYuRi4OIYGljBINS2+wQjh9TBIvV+9mAali
	EzCW2Lx8CViViMBlZok7p6eAVTELHGWUuDHrLhNIlbCAh8TrGRvZQWwWAVWJjb/vsoHYvALu
	EotnL2CCWK0gMWeSDUiYE6i8ff1TRhBbCKjk2/rnLBMYeRcwMqxiFE0tTS4oTkrPNdQrTswt
	Ls1L10vOz93ECAn2LzsYFx+zOsQowMGoxMP74uqUICHWxLLiytxDjBIczEoivJknpwYJ8aYk
	VlalFuXHF5XmpBYfYmTi4JRqYIzYIOa70D7EMM03/9sOSXPLb+URLTP3qnf+i65cd+DA9bqI
	fu72KnX5a090dexEVjfxz/v4V2PZxV0zUtfOF/J9oywuo1iZH7/a3+XWwy1Bc7cv0WE6ubNl
	uVxuUlHZb86/kQb/BSxrD01wVuM5X9S02FjE+HxerKz6M51D0a9OCr8x1V9to8RSnJFoqMVc
	VJwIAMHpAHtUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document describing device tree bindings for MAX14577 MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max14577.txt |   48 ++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
new file mode 100644
index 0000000..f4fd163
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max14577.txt
@@ -0,0 +1,48 @@
+MAXIM MAX14577 multi-function device
+
+MAX14577 is a Multi-function device with Micro-USB Interface Circuit, Li+
+Battery Charger and SFOUT LDO output for powering USB devices. It is
+interfaced to host controller using I2C.
+
+Required properties:
+- compatible : Must be "maxim,max14577".
+- reg : I2C slave address for the max14577 chip.
+- interrupts : IRQ line for the max14577 chip.
+- interrupt-parent :  The parent interrupt controller.
+
+Optional nodes:
+- regulators :
+  Required child node properties:
+  - compatible : "maxim,max14577-regulator"
+
+  Optional child nodes:
+    Each child node representing a regulator, following standard regulator
+    bindings. Valid names for a regulator are: "CHARGER" and "SAFEOUT".
+    The SAFEOUT is a constant voltage regulator so there is no need to specify
+    voltages for it.
+
+	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
+
+Example:
+	max14577@25 {
+		compatible = "maxim,max14577";
+		reg = <0x25>;
+		interrupt-parent = <&gpx1>;
+		interrupts = <5 0>;
+
+		regulators {
+			compatible = "maxim,max14577-regulator";
+
+			safeout_reg: safeout@1 {
+				regulator-compatible = "SAFEOUT";
+				regulator-name = "SAFEOUT";
+			};
+			charger_reg: charger@0 {
+				regulator-compatible = "CHARGER";
+				regulator-name = "CHARGER";
+				regulator-min-microamp = <90000>;
+				regulator-max-microamp = <950000>;
+				regulator-boot-on;
+			};
+		};
+	};
-- 
1.7.9.5

