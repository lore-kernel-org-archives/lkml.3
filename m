Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbbAEKRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:17:23 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36401 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbbAEKRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:17:17 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-90-54aa64ab5d8e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 1/4] devicetree: power/mfd: max77693: Document new bindings
 for charger
Date: Mon, 05 Jan 2015 11:16:56 +0100
Message-id: <1420453019-28614-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
References: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Vd3VKatCDHrv6FlMevKe2WL+kXOs
	FhNXTma2eP3C0OL+16OMFpu/d7BZXN41h83ic+8RRovT3awWp3eXOHB57Jx1l91j8wotj02r
	Otk87lzbw+Yx72SgR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVsPnOLqaBbrGLTt1lMDYwf
	BLsYOTkkBEwk1na9ZYSwxSQu3FvP1sXIxSEksJRR4tiTtSwQTh+TxJ6Lx9hBqtgEjCU2L18C
	ViUisIdJ4tOLFawgCWYBQ4mf7/6AFQkLxEjc6dvP3MXIwcEioCrx60EeSJhXwF1iycQ97BDb
	5CROHpsM1sop4CEx/+V3ZhBbCKjmwL7HzBMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vO
	z93ECAm/rzsYlx6zOsQowMGoxMPrcWJliBBrYllxZe4hRgkOZiUR3nW3gEK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYF73xsbn3lF/D9dHt59/8u/ckTFliyRDjqOrsc/zT+pscbfq2rQdXxsv1
	vS7/9SBpq/kh18lRq/VOrF7hf/LeFq9rjzweHEl99Phfz431DirvJKqibGZJKQXctX9RfaHv
	gt+1VKu2xricO6v7WLIMXsSzHzkzPSTi7nSb25ylXAoaUlHhE/uqlFiKMxINtZiLihMBsTW3
	tB0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document new device tree bindings for Maxim 77693 charger driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77693.txt | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 01e9f30fe678..38e64405e98d 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -41,6 +41,41 @@ Optional properties:
 	 To get more informations, please refer to documentaion.
 	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
 
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
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -73,4 +108,14 @@ Example:
 			pwms = <&pwm 0 40000 0>;
 			pwm-names = "haptic";
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

