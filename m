Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3JVMtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:49:45 -0400
Received: from ring0.de ([91.143.88.219]:36019 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3JVMtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:49:43 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH] ARM: dts: N900: GPIO key definitions
Date: Tue, 22 Oct 2013 14:49:38 +0200
Message-Id: <1382446178-27638-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree node for the GPIO keys provided by the
N900 board. This is a simple conversion of the existing
board code.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 48 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 30ac779..2841002 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -26,6 +26,54 @@
 		reg = <0x80000000 0x10000000>; /* 256 MB */
 	};
 
+	gpio_keys {
+		compatible = "gpio-keys";
+
+		camera_lens_cover {
+			label = "Camera Lens Cover";
+			gpios = <&gpio4 14 GPIO_ACTIVE_LOW>; /* 110 */
+			linux,input-type = <5>; /* EV_SW */
+			linux,code = <0x09>; /* SW_CAMERA_LENS_COVER */
+			gpio-key,wakeup;
+		};
+
+		camera_focus {
+			label = "Camera Focus";
+			gpios = <&gpio3 4 GPIO_ACTIVE_LOW>; /* 68 */
+			linux,code = <0x210>; /* KEY_CAMERA_FOCUS */
+			gpio-key,wakeup;
+		};
+
+		camera_capture {
+			label = "Camera Capture";
+			gpios = <&gpio3 5 GPIO_ACTIVE_LOW>; /* 69 */
+			linux,code = <0xd4>; /* KEY_CAMERA */
+			gpio-key,wakeup;
+		};
+
+		lock_button {
+			label = "Lock Button";
+			gpios = <&gpio4 17 GPIO_ACTIVE_LOW>; /* 113 */
+			linux,code = <0x98>; /* KEY_SCREENLOCK */
+			gpio-key,wakeup;
+		};
+
+		keypad_slide {
+			label = "Keypad Slide";
+			gpios = <&gpio3 7 GPIO_ACTIVE_LOW>; /* 71 */
+			linux,input-type = <5>; /* EV_SW */
+			linux,code = <0x0a>; /* SW_KEYPAD_SLIDE */
+			gpio-key,wakeup;
+		};
+
+		proximity_sensor {
+			label = "Proximity Sensor";
+			gpios = <&gpio3 25 GPIO_ACTIVE_HIGH>; /* 89 */
+			linux,input-type = <5>; /* EV_SW */
+			linux,code = <0x0b>; /* SW_FRONT_PROXIMITY */
+		};
+	};
+
 };
 
 &omap3_pmx_core {
-- 
1.8.4.rc3

