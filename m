Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaJTMf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:35:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61465 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaJTMfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:35:21 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-a2-544501863b70
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-api@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/5] devicetree: mfd: max77693: Document new bindings for
 charger
Date: Mon, 20 Oct 2014 14:34:45 +0200
Message-id: <1413808489-3524-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t/xa7ptjK4hBo0HjSw2zljPajHpyXtm
	i/lHzrFaTFw5mdni9QtDi7NNb9gt7n89ymix+XsHm8XlXXPYLD73HmG0WHvkLrvF6W5Wi9O7
	Sxx4PXbOusvusXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy
	Jl56w1pwUrTiw99rTA2MuwS7GDk5JARMJG5vPscCYYtJXLi3nq2LkYtDSGApo8SaK9sYIZw+
	JomGPw/ZQarYBIwlNi9fAlYlIrCPSeLU87fMIA6zwFFGiem9b5m6GDk4hAXCJB4tVABpYBFQ
	lbi3op0VJMwr4Caxco4ZxDY5iZPHJrOC2JwC7hLzt3cwgthCQCWnLh5insDIu4CRYRWjaGpp
	ckFxUnqukV5xYm5xaV66XnJ+7iZGSHB+3cG49JjVIUYBDkYlHt4dZi4hQqyJZcWVuYcYJTiY
	lUR4Xf4DhXhTEiurUovy44tKc1KLDzEycXBKNTByxt564h3klbf+r11x/Of+18dTIjbw5D03
	7eprrrreeiSF/aGJV/qGj8X7Yj4ckludq7nm0O2z7T/zpvP+mFOXvsPgieiHlTv5chI05Ne3
	Hd2/O3y93pdOvsC8pVOu37jyxuHhhcN/5P3Uil2CJKUiS/ZGFMy5XWl+umwb5x2lgIzfrAyR
	7YeUWIozEg21mIuKEwEB/WM8LAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document new device tree bindings for Maxim 77693 charger driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77693.txt | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc417bf..d0c3d787df12 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,42 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+- charger : Node configuring the charger driver.
+  If present, required properties:
+  - compatible : Must be "maxim,max77693-charger".
+
+  Optional properties (if not set, defaults will be used):
+  - maxim,constant-microvolt : Battery constant voltage in uV. The charger
+    will operate in fast charge constant current mode till battery voltage
+    reaches this level. Then the charger will switch to fast charge constant
+    voltage mode. Also vsys (system voltage) will be set to this value when
+    DC power is supplied but charger is not enabled.
+    Valid values: 3650000 - 4400000, step by 25000 (rounded down)
+    Default: 4200000
+
+  - maxim,min-system-microvolt : Minimal system voltage in uV.
+    Valid values: 3000000 - 3700000, step by 100000 (rounded down)
+    Default: 3600000
+
+  - maxim,thermal-regulation-celsius : Temperature in Celsius for entering
+    high temperature charging mode. If die temperature exceeds this value
+    the charging current will be reduced by 105 mA/Celsius.
+    Valid values: 70, 85, 100, 115
+    Default: 100
+
+  - maxim,battery-overcurrent-microamp : Overcurrent protection threshold
+    in uA (current from battery to system).
+    Valid values: 2000000 - 3500000, step by 250000 (rounded down)
+    Default: 3500000
+
+  - maxim,charge-input-threshold-microvolt : Threshold voltage in uV for
+    triggering input voltage regulation loop. If input voltage decreases
+    below this value, the input current will be reduced to reach the
+    threshold voltage.
+    Valid values: 4300000, 4700000, 4800000, 4900000
+    Default: 4300000
+
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +88,14 @@ Example:
 					regulator-boot-on;
 			};
 		};
+
+		charger {
+			compatible = "maxim,max77693-charger";
+
+			maxim,constant-microvolt = <4200000>;
+			maxim,min-system-microvolt = <3600000>;
+			maxim,thermal-regulation-celsius = <75>;
+			maxim,battery-overcurrent-microamp = <3000000>;
+			maxim,charge-input-threshold-microvolt = <4300000>;
+		};
 	};
-- 
1.9.1

