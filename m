Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3KVPv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:51:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34135 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3KVPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:51:24 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-21-528f7d7b7094
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 5/5] mfd: max14577: Add device tree bindings document
Date: Fri, 22 Nov 2013 16:51:09 +0100
Message-id: <1385135469-27044-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385135469-27044-1-git-send-email-k.kozlowski@samsung.com>
References: <1385135469-27044-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7rVtf1BBue+s1kc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PFuVcrGS1evzC0ONv0ht3i/tejjBbfrnQwWWx6
	fI3VYmHbEhaLy7vmsFmsPXKX3eJ24wo2iwnT17JYHF5xgMli3cvpLBanu1ktXh1sY3EQ81gz
	bw2jx4LPV9g9JvR/YvTYOesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7WHzmHcy0GPzknqP
	vi2rGD0+b5Lz2Dg3NIAvissmJTUnsyy1SN8ugSvjy5bSgscCFavmTmdrYHzA28XIySEhYCKx
	7sdsNghbTOLCvfVgtpDAUkaJo2vdIew+JomH5+xBbDYBY4nNy5cA1XBxiAjMYZXYfeYZC4jD
	LHCUUeJt5y4mkCphAQ+JxavegE1iEVCVePH2HVCcg4NXwF2i5SYriCkhoCAxZ5INSAUnUPWj
	hoWMIGEhoIr+9Y4TGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJmC87GBcfszrE
	KMDBqMTDu8OyL0iINbGsuDL3EKMEB7OSCC8HMN6EeFMSK6tSi/Lji0pzUosPMTJxcEo1MCpc
	rnUpSo2VPfJqxx25ZX8vGd+UnG/xnXfu79yVE79FG9xsN+Z8dfST6ZvJB0KPbWSwFuEvrD3C
	Gx73hz9LfymP+4FN02QXzHjWuEODQ7grK3imjffaGeumzxHek3bS6cr8xWn9P/m8HSzEgp9+
	nfbfz/L+xIynrpI324sjy3RvJZ/w+DV1/R0lluKMREMt5qLiRADZJEX2dgIAAA==
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

