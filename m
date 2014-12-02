Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbaLBIGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:06:22 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:55410 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbaLBIGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:06:19 -0500
From: gyungoh@gmail.com
X-Google-Original-From: jack.yoo@skyworksinc.com
To: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com
Cc: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        treding@nvidia.com, florian.vaussard@epfl.ch, trivial@kernel.org,
        linux@roeck-us.net, andrew@lunn.ch, jic23@kernel.org
Subject: [PATCH v9 4/8] devicetree: backlight: Add new SKY81452 backlight binding
Date: Tue,  2 Dec 2014 17:05:25 +0900
Message-Id: <1417507529-13654-5-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
Changes v9:
Nothing

Changes v8:
Renamed property names for backlight with vendor prefix
Modified gpio-enable property to generic property for GPIO
Made up the example for backlight DT

Changes v7:
Nothing

Changes v6:
Nothing

Changes v5:
Nothing

Changes v4:
Nothing

Changes v3:
Nothing

Changes v2:
Added reg attribute for I2C slave address

 .../video/backlight/sky81452-backlight.txt         | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt

diff --git a/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
new file mode 100644
index 0000000..8daebf5
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
@@ -0,0 +1,29 @@
+SKY81452-backlight bindings
+
+Required properties:
+- compatible		: Must be "skyworks,sky81452-backlight"
+
+Optional properties:
+- name			: Name of backlight device. Default is 'lcd-backlight'.
+- gpios			: GPIO to use to EN pin.
+			See Documentation/devicetree/bindings/gpio/gpio.txt
+- skyworks,en-channels	: Enable mask for current sink channel 1 to 6.
+- skyworks,ignore-pwm	: Ignore both PWM input
+- skyworks,dpwm-mode	: Enable DPWM dimming mode, otherwise Analog dimming.
+- skyworks,phase-shift	: Enable phase shift mode
+- skyworks,ovp-level	: Over-voltage protection level.
+			Should be between 14 or 28V.
+- skyworks,short-detection-threshold	: It should be one of 4, 5, 6 and 7V.
+- skyworks,current-limit	: It should be 2300mA or 2750mA.
+
+Example:
+
+	backlight {
+		compatible = "skyworks,sky81452-backlight";
+		name = "pwm-backlight";
+		skyworks,en-channels = <0x3f>;
+		skyworks,ignore-pwm;
+		skyworks,phase-shift;
+		skyworks,ovp-level = <20>;
+		skyworks,current-limit = <2300>;
+	};
-- 
1.9.1

