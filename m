Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3LFLdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:33:00 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32205 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab3LFLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:32:30 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-bb-52a1b5cce0ec
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
Subject: [PATCH v7 3/3] mfd: max14577: Add device tree bindings document
Date: Fri, 06 Dec 2013 12:32:14 +0100
Message-id: <1386329534-14186-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386329534-14186-1-git-send-email-k.kozlowski@samsung.com>
References: <1386329534-14186-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xK7pnti4MMvi8W9Hi4FZNi40z1rNa
	TH34hM3i+pfnrBbzj5xjtZi4cjKzxblXKxktXr8wtDjb9Ibd4v7Xo4wW3650MFlsenyN1WJh
	2xIWi8u75rBZrD1yl91i6fWLTBYTpq9lsTi84gCTxbqX01ksXh1sY3EQ8Vgzbw2jx4LPV9g9
	JvR/YvTYOesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7QEKLan36NuyitHj8yY5j41zQwN4
	o7hsUlJzMstSi/TtErgyDs39w1wwVbhi2dG7zA2Mb/m7GDk5JARMJNo3zGWBsMUkLtxbz9bF
	yMUhJLCUUWLejBWsEE4fk8T8C8/YQarYBIwlNi9fAlYlInCLRWLCy3XsIA6zwEZGifdHNzKB
	VAkLeEjMvvAFzGYRUJX4+eADK4jNK+AucfnBVsYuRg6gfQoScybZgIQ5gcqPHTkHdoYQUMmt
	ze9YJzDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREiFfdjAuPmZ1iFGAg1GJhzdh
	zYIgIdbEsuLK3EOMEhzMSiK8NssXBgnxpiRWVqUW5ccXleakFh9iZOLglGpgVPG5ct/BTXxF
	0Akdrt56x4JgVe1mZk81fxG2hibRewIHGSVP7CtWr43se9nX6ZXs92pZ9OGMA6W/b/1e1rTt
	8/9Nf0/HXi+8OJ/r8+OfmpF+ScZ5HlIn9eZ1zr/5zHOm249AhSdn1lb3zNp9wWPzsX1/Du3d
	Gy/M9TaM31DpVMI7n62OKkW9SizFGYmGWsxFxYkA2J89nm4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document describing device tree bindings for MAX14577 MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max14577.txt |   65 ++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
new file mode 100644
index 000000000000..0b2449aaf8bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max14577.txt
@@ -0,0 +1,65 @@
+Maxim MAX14577 Multi-Function Device
+
+MAX14577 is a Multi-Function Device with Micro-USB Interface Circuit, Li+
+Battery Charger and SFOUT LDO output for powering USB devices. It is
+interfaced to host controller using I2C.
+
+
+Required properties:
+- compatible : Must be "maxim,max14577".
+- reg : I2C slave address for the max14577 chip.
+- interrupts : IRQ line for the max14577 chip.
+- interrupt-parent :  The parent interrupt controller.
+
+
+Optional nodes:
+- max14577-muic :
+	Node used only by extcon consumers.
+	Required properties:
+		- compatible : "maxim,max14577-muic"
+
+- regulators :
+	Required properties:
+		- compatible : "maxim,max14577-regulator"
+
+	May contain a sub-node per regulator from the list below. Each
+	sub-node should contain the constraints and initialization information
+	for that regulator. See regulator.txt for a description of standard
+	properties for these sub-nodes.
+
+	List of valid regulator names: CHARGER, SAFEOUT.
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
+		safeout_reg: regulator@1 {
+			regulator-compatible = "SAFEOUT";
+			regulator-name = "SAFEOUT";
+		};
+		charger_reg: regulator@0 {
+			regulator-compatible = "CHARGER";
+			regulator-name = "CHARGER";
+			regulator-min-microamp = <90000>;
+			regulator-max-microamp = <950000>;
+			regulator-boot-on;
+		};
+	};
+};
-- 
1.7.9.5

