Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKQIe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:34:26 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33523 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaKQIeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:34:22 -0500
From: gyungoh@gmail.com
X-Google-Original-From: jack.yoo@skyworksinc.com
To: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com
Cc: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: [RESUBMIT PATCH v7 3/9] devicetree: mfd: Add new SKY81452 mfd binding
Date: Mon, 17 Nov 2014 17:33:04 +0900
Message-Id: <1416213190-20935-4-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
Changes v7:
Nothing

Changes v6:
Nothing

Changes v5:
Changed DT for regulator : 'lout' node should be defined under 'regulator'
Removed compatible string from sky81452-regulator driver

Changes v4:
Nothing

Changes v3:
Nothing

Changes v2:
Added reg attribute for I2C slave address

 Documentation/devicetree/bindings/mfd/sky81452.txt | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt

diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
new file mode 100644
index 0000000..4b82a73
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
@@ -0,0 +1,33 @@
+SKY81452 bindings
+
+Required properties:
+- compatible	: Must be "skyworks,sky81452"
+- reg		: I2C slave address
+
+Required child nodes:
+- backlight	: container node for backlight following the binding
+		in video/backlight/sky81452-backlight.txt
+- regulator	: container node for regulators following the binding
+		in regulator/sky81452-regulator.txt
+
+Example:
+
+	sky81452@2c {
+		compatible = "skyworks,sky81452";
+		reg = <0x2c>;
+
+		backlight {
+			compatible = "skyworks,sky81452-backlight";
+			name = "pwm-backlight";
+			enable = <0x3F>;
+			ignore-pwm;
+		};
+
+		regulator {
+			lout {
+				regulator-name = "sky81452-lout";
+				regulator-min-microvolt = <4500000>;
+				regulator-max-microvolt = <8000000>;
+			};
+		};
+	};
-- 
1.9.1

