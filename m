Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3BDPme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:42:34 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:45223 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab3BDPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:30 -0500
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: sameo@linux.intel.com, qingx@marvell.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 6/6] Documentation: add docs for max8925 dt
Date: Mon,  4 Feb 2013 23:40:47 +0800
Message-Id: <1359992448-22229-6-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

add docs for dt of max8925-mfd, max8925-backlight, and
max8925-battery

Signed-off-by: Qing Xu <qingx@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 Documentation/devicetree/bindings/mfd/max8925.txt  |   64 ++++++++++++++++++++
 .../bindings/power_supply/max8925_batter.txt       |   18 ++++++
 .../bindings/video/backlight/max8925-backlight.txt |   10 +++
 3 files changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max8925.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/max8925_batter.txt
 create mode 100644 Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt

diff --git a/Documentation/devicetree/bindings/mfd/max8925.txt b/Documentation/devicetree/bindings/mfd/max8925.txt
new file mode 100644
index 0000000..4f0dc66
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max8925.txt
@@ -0,0 +1,64 @@
+* Maxim max8925 Power Management IC
+
+Required parent device properties:
+- compatible : "maxim,max8925"
+- reg : the I2C slave address for the max8925 chip
+- interrupts : IRQ line for the max8925 chip
+- interrupt-controller: describes the max8925 as an interrupt
+  controller (has its own domain)
+- #interrupt-cells : should be 1.
+	- The cell is the max8925 local IRQ number
+
+Optional parent device properties:
+- maxim,tsc-irq: there are 2 IRQ lines for max8925, one is indicated in
+  interrupts property, the other is indicated here.
+
+max8925 consists of a large and varied group of sub-devices:
+
+Device			 Supply Names	 Description
+------			 ------------	 -----------
+max8925-onkey		:		: On key
+max8925-rtc		:		: RTC
+max8925-regulator	:		: Regulators
+max8925-backlight	:		: Backlight
+max8925-touch		:		: Touchscreen
+max8925-power		:		: Charger
+
+Example:
+
+	pmic: max8925@3c {
+		compatible = "maxim,max8925";
+		reg = <0x3c>;
+		interrupts = <1>;
+		interrupt-parent = <&intcmux4>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		maxim,tsc-irq = <0>;
+
+		regulators {
+			SDV1 {
+				regulator-min-microvolt = <637500>;
+				regulator-max-microvolt = <1425000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			LDO1 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+		};
+		backlight {
+			maxim,max8925-dual-string = <0>;
+		};
+		charger {
+			batt-detect = <0>;
+			topoff-threshold = <1>;
+			fast-charge = <7>;
+			no-temp-support = <0>;
+			no-insert-detect = <0>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/power_supply/max8925_batter.txt b/Documentation/devicetree/bindings/power_supply/max8925_batter.txt
new file mode 100644
index 0000000..d7e3e0c
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/max8925_batter.txt
@@ -0,0 +1,18 @@
+max8925-battery bindings
+~~~~~~~~~~~~~~~~
+
+Optional properties :
+ - batt-detect: whether support battery detect
+ - topoff-threshold: set charging current in topoff mode
+ - fast-charge: set charging current in fast mode
+ - no-temp-support: whether support temperature protection detect
+ - no-insert-detect: whether support insert detect
+
+Example:
+	charger {
+		batt-detect = <0>;
+		topoff-threshold = <1>;
+		fast-charge = <7>;
+		no-temp-support = <0>;
+		no-insert-detect = <0>;
+	};
diff --git a/Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt b/Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt
new file mode 100644
index 0000000..b4cffda
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt
@@ -0,0 +1,10 @@
+88pm860x-backlight bindings
+
+Optional properties:
+  - maxim,max8925-dual-string: whether support dual string
+
+Example:
+
+	backlights {
+		maxim,max8925-dual-string = <0>;
+	};
-- 
1.7.10.4

