Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbbAIPcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:32:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55078 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824AbbAIPYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:18 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-62-54aff2a09056
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v10 09/19] DT: Add documentation for the mfd Maxim max77693
Date: Fri, 09 Jan 2015 16:22:59 +0100
Message-id: <1420816989-1808-10-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQd0Fn9aHGHx+rGlxa905VouNM9az
	WhzdOZHJ4vqX56wW848AxfrfLGS1OPdqJaNF79XnjBZnm96wW9z/epTR4vKuOWwWW9+sY7To
	2bCV1WLp9YtMFndPHWWzmDB9LYtF694j7Ba7dz1ltTj8pp3V4sz+lWwOIh5r5q1h9Ljc18vk
	sXPWXXaPlcu/sHkc/rqQxWPTqk42jzvX9rB57Jn/g9Wjb8sqRo8Vq7+ze3zeJBfAHcVlk5Ka
	k1mWWqRvl8CVsaT9FEvBa7mKPX+nMTUw7pXsYuTkkBAwkVi3sJEFwhaTuHBvPRuILSQwnVGi
	v4m9i5ELyG5nkrh57AxYEZuAocTPF6+Zuhg5OEQEoiUuHasHqWEWmMYi8a99OyNIjbCAv8Se
	I8uZQWpYBFQlJnTagYR5BTwkpn7tAQtLCChIzJlkA2JyAoVbfjuBmEIC7hJvrhpOYORdwMiw
	ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Fp5J72Bc1WBxiFGAg1GJh3eD3PoQIdbEsuLK
	3EOMEhzMSiK8DZuBQrwpiZVVqUX58UWlOanFhxilOViUxHmV7NtChATSE0tSs1NTC1KLYLJM
	HJxSDYxG0zx3/Ti30fr5q8rrfxfmNTYm7990mkXq5dVGkcNyW9Yb5j9MuS+6vtqBWfHI0mNc
	rd9ar57dopv+fXlb4z/PD7r7ohzzLRfJZS/Ke1Tzb4Wgo5y33nUhoUNXTKf9mHzkx9mJ52Tv
	rPvnfCel1P3dnA3RXFFbU12C13X43Kn/Gn1rl+PztpbXSizFGYmGWsxFxYkAQ2OjN4ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
the flash cell of the Maxim max77693 multifunctional device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/max77693.txt |   69 ++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 01e9f30..ef184f0 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -41,7 +41,52 @@ Optional properties:
 	 To get more informations, please refer to documentaion.
 	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
 
+- led : the LED submodule device node
+
+There are two led outputs available - fled1 and fled2. Each of them can
+control a separate led or they can be connected together to double
+the maximum current for a single connected led. One led is represented
+by one child node.
+
+Required properties:
+- compatible : Must be "maxim,max77693-led".
+
+Optional properties:
+- maxim,trigger-type : Flash trigger type.
+	Possible trigger types:
+		MAX77693_LED_TRIG_TYPE_EDGE - Rising edge of the signal triggers
+			the flash,
+		MAX77693_LED_TRIG_TYPE_LEVEL - Strobe pulse length controls
+			duration of the flash.
+- maxim,boost-mode :
+	In boost mode the device can produce up to 1.2A of total current
+	on both outputs. The maximum current on each output is reduced
+	to 625mA then. If not enabled explicitly, boost setting defaults to
+	MAX77693_LED_BOOST_FIXED in case both current sources are used.
+	Possible values:
+		MAX77693_LED_BOOST_OFF - no boost,
+		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
+		MAX77693_LED_BOOST_FIXED - fixed mode.
+- maxim,boost-vout : Output voltage of the boost module in millivolts.
+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
+	if chip estimates that system voltage could drop below this level due
+	to flash power consumption.
+
+Required properties of the LED child node:
+- label : see Documentation/devicetree/bindings/leds/common.txt
+- led-sources : see Documentation/devicetree/bindings/leds/common.txt
+
+Optional properties of the LED child node:
+- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 15625 - 250000
+- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 15625 - 1000000
+- flash-timeout-us : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 62500 - 1000000
+
 Example:
+#include <dt-bindings/mfd/max77693.h>
+
 	max77693@66 {
 		compatible = "maxim,max77693";
 		reg = <0x66>;
@@ -73,4 +118,28 @@ Example:
 			pwms = <&pwm 0 40000 0>;
 			pwm-names = "haptic";
 		};
+
+		led {
+			compatible = "maxim,max77693-led";
+			maxim,trigger-type = <MAX77693_LED_TRIG_TYPE_LEVEL>;
+			maxim,boost-mode = <MAX77693_LED_BOOST_FIXED>;
+			maxim,boost-vout = <5000>;
+			maxim,vsys-min = <2400>;
+
+			camera1_flash: led1 {
+				label = "max77693-flash1";
+				led-sources = <1 0>;
+				max-microamp = <250000>;
+				flash-max-microamp = <625000>;
+				flash-timeout-us = <1000000>;
+			};
+
+			camera2_flash: led2 {
+				label = "max77693-flash2";
+				led-sources = <0 1>;
+				max-microamp = <250000>;
+				flash-max-microamp = <625000>;
+				flash-timeout-us = <1000000>;
+			};
+		};
 	};
-- 
1.7.9.5

