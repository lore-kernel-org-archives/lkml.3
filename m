Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3LDKkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:40:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29763 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3LDKke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:40:34 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-92-529f069f28c1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 3/3] mfd: max14577: Add device tree bindings document
Date: Wed, 04 Dec 2013 11:40:15 +0100
Message-id: <1386153615-25456-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
References: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xy7rz2eYHGSy7xWVxcKumxcYZ61kt
	pj58wmZx/ctzVov5R86xWkxcOZnZ4tyrlYwWr18YWpxtesNucf/rUUaLb1c6mCw2Pb7GarGw
	bQmLxeVdc9gs1h65y26x9PpFJosJ09eyWBxecYDJYt3L6SwWrw62sTiIeKyZt4bRY8HnK+we
	E/o/MXrsnHWX3WPl8i9sHptXaHlsWtXJ5vFq9UxWjzvX9gCFltR79G1ZxejxeZOcx8a5oQG8
	UVw2Kak5mWWpRfp2CVwZ/7/9Zyl4K1Axd89S9gbGV7xdjBwcEgImEs+WanQxcgKZYhIX7q1n
	62Lk4hASWMoo8e/dESinj0nizvHNTCBVbALGEpuXLwFLiAjcYpGY8HIdO4jDLLCRUeL90Y1g
	VcICHhLLP90Cs1kEVCXWPvnCBmLzCrhLTJtyiQlitYLEnEk2IGFOoPLDD2Yxg9hCQCVr12xl
	m8DIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSHx82cG4+JjVIUYBDkYlHl4O9nlB
	QqyJZcWVuYcYJTiYlUR4D7HODxLiTUmsrEotyo8vKs1JLT7EyMTBKdXAmFLQz+EWpNUnMePS
	4YTt/sb26b3GOtz7HFLYfLpuioQVKPy8K3VoV+bWlrSG4PfuORnaLhuqrrbt3zZH8MNBVrfj
	OldWtr3R04iPb2OVWHsiR88ydl/Z3nzfxMeKO+ojElpOlm9fPiffIm279RttPcdYFTWRtpV3
	BLXvWh7m2ZKid//Xu81KLMUZiYZazEXFiQBpbSqgbQIAAA==
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
index 000000000000..f4fd16360b6b
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

