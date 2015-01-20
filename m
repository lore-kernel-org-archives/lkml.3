Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbbATKIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:08:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32488 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbbATKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:04:57 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ae-54be2846db9e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 1/5] devicetree: power/mfd: max77693: Document new bindings
 for charger
Date: Tue, 20 Jan 2015 11:00:52 +0100
Message-id: <1421748056-25735-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
References: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7puGvtCDP5vEbHYOGM9q8WkJ++Z
	LeYfOcdqMXHlZGaL1y8MLc42vWG3uP/1KKPF5u8dbBaXd81hs/jce4TR4nQ3q8Xp3SUOPB47
	Z91l99i8Qstj06pONo871/awecw7GejRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGZvP3GIq
	6Bar2PRtFlMD4wfBLkZODgkBE4nm2SdYIGwxiQv31rN1MXJxCAksZZRoudrCDJIQEuhjkth6
	xBrEZhMwlti8fAlYkYjAHiaJTy9WsII4zALTGCUunPoO1iEsECOxvvMaI4jNIqAqceR5MyuI
	zSvgLvFjXjcbxDo5iZPHJoPFOQU8JH7MPcoCsc1dYv2/HqYJjLwLGBlWMYqmliYXFCel5xrq
	FSfmFpfmpesl5+duYoQE5ZcdjIuPWR1iFOBgVOLh1cjZEyLEmlhWXJl7iFGCg1lJhLdHYl+I
	EG9KYmVValF+fFFpTmrxIUYmDk6pBsaK0tMR62/GRxsZPmwzv+SuuSVVXzIn/JSHiYJLmRGX
	3SXhSc3ic25sXr2pI/7pj+1+zDZBu+OrzuwUv766Oa90vpSYwDQnpX01Vuf/bXJ6Kfuj3pTr
	5N/SO9I394fLpd9cPZPrh9Nyz6un1/g1ndr4NVhZPu6a5rPbKz5Xf3uo2vBW9/XJuaVKLMUZ
	iYZazEXFiQD4NIPHKAIAAA==
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

