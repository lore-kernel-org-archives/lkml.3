Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3KVIqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:46:40 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46956 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3KVIqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:46:30 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-41-528f19e422ee
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
Subject: [PATCH v3 5/5] mfd: max14577: Add device tree bindings document
Date: Fri, 22 Nov 2013 09:46:12 +0100
Message-id: <1385109972-28059-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xK7pPJPuDDM6f47Y4uFXTYuOM9awW
	Ux8+YbO4/uU5q8X8I+dYLSaunMxsceDPDkaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgstj0
	+BqrxcK2JSwWl3fNYbNYe+Quu8XtxhVsFhOmr2WxOLziAJPFupfTWSxOd7NavDrYxuIg5rFm
	3hpGjwWfr7B7TOj/xOixc9Zddo+Vy7+weWxeoeWxaVUnm8er1TNZPe5c28PmMe9koMfmJfUe
	fVtWMXp83iTnsXFuaABfFJdNSmpOZllqkb5dAlfGrTv/WQvWClR8OvaZtYFxK28XIyeHhICJ
	xP6DDawQtpjEhXvr2UBsIYGljBIdD7kh7D4miRV3xEBsNgFjic3LlwDVcHGICMxhldh95hkL
	iMMscJRR4m3nLiaQKmEBD4kt3+4xg9gsAqoSt+7NYASxeQXcJd6uXwRUwwG0TUFiziQbkDAn
	UHnf9N+sIGEhoJL7H6wmMPIuYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESNV93MC49
	ZnWIUYCDUYmHd4dlX5AQa2JZcWXuIUYJDmYlEd5fV4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUa
	GO3rNVqmvza5wP2GWT3gEdMBfX9XEcb93cwKnu9SF7296TSb/3NkmY7AuaNF7cdVZk95rZXi
	qhRn9irHxLeUefKUsK/PDEpEZLtar4QKxXAaSpqym1sGZZ/5sSy7TWfDjy+iprqOj+piRMqX
	rrkqVP5/6YVH8xZVlL89YXrmsDnf+x//03r8lFiKMxINtZiLihMBbYtAwXgCAAA=
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
index 0000000..20d3866
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
+Optional properties:
+- regulators : Each regulator should be represented by a child node of the
+  "regulators" node:
+
+	regulator-name {
+		regulator-name = CHARGER/SAFEOUT;
+		/* standard regulator bindings here */
+	};
+
+  Valid names for regulator are: "CHARGER" and "SAFEOUT". The SAFEOUT
+  is a constant voltage regulator so there is no need to specify voltages
+  for it.
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

