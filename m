Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaKFPMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:12:23 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33317 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKFPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:12:12 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-17-545b8fc9d9d6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v3 1/4] devicetree: power/mfd: max77693: Document new
 bindings for charger
Date: Thu, 06 Nov 2014 16:11:57 +0100
Message-id: <1415286720-6358-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415286720-6358-1-git-send-email-k.kozlowski@samsung.com>
References: <1415286720-6358-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xK7on+6NDDNY947LYOGM9q8WkJ++Z
	LeYfOcdqMXHlZGaL1y8MLc42vWG3uP/1KKPF5u8dbBabHl9jtbi8aw6bxefeI4wWM87vY7JY
	e+Quu8XpblaL07tLLFbt+sPoIOCxc9Zddo/NK7Q8Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo
	8XmTXABHFJdNSmpOZllqkb5dAlfG5jO3mAq6xSo2fZvF1MD4QbCLkZNDQsBEYuOOM+wQtpjE
	hXvr2boYuTiEBJYySlw6Oo8RwuljkriyvJEVpIpNwFhi8/IlYFUiAnuYJD69WMEK4jALbGeS
	+PNtApDDwSEskCzxb3c+SAOLgKrE7GnrmUFsXgE3iW+TJjJCrJOTOHlsMlg5p4C7RPe3SpCw
	EFDJ86/zGCcw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERLCX3YwLj5mdYhRgINR
	iYd3A2d0iBBrYllxZe4hRgkOZiUR3uoeoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGFuZTb/mk
	FIQNu/wO/3yctGxhEp9J+9muRaLWIXmTeWdpp6/5baSt+eOis5jiIS9fUXYB5u1MujdbXlw+
	oKr2uMpRqmLVlrtLhaXuHvuyb+n+47FCG/ZuOPa9/srCHOc/SdNeTtE5ctzg4aWtZ2PD5ipd
	eHr7/6njC5Vur1nxpOIlq6RAx3keTiWW4oxEQy3mouJEAH15GKU/AgAA
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

