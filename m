Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLERcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:32:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41711 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaLERcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:32:45 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, "Menon, Nishanth" <nm@ti.com>
Subject: [PATCH] ARM: dts: am57xx-beagle-x15: Add GPIO controlled fan node
Date: Fri, 5 Dec 2014 11:32:18 -0600
Message-ID: <1417800739-13146-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Menon, Nishanth" <nm@ti.com>

TPS gpio now controls a 5v 500mA TL5209 regulator which may be supply
a fan (such as AFB02505HHB) over J1 connector for various purposes.
Provide device tree node to enable the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
Depends on the following:
https://patchwork.kernel.org/patch/5439201/
https://patchwork.kernel.org/patch/5439191/

enable and disable can be controlled by
echo '1' > /sys/class/hwmon/hwmon0/fan1_target
and
echo '0' > /sys/class/hwmon/hwmon0/fan1_target

requires CONFIG_GPIO_PALMAS and CONFIG_SENSORS_GPIO_FAN to be operational
Applies on 
https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/log/?h=omap-for-v3.19/dt-v2

 arch/arm/boot/dts/am57xx-beagle-x15.dts |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/am57xx-beagle-x15.dts b/arch/arm/boot/dts/am57xx-beagle-x15.dts
index 49edbda..7fe82ef 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15.dts
+++ b/arch/arm/boot/dts/am57xx-beagle-x15.dts
@@ -80,6 +80,15 @@
 			default-state = "off";
 		};
 	};
+
+	gpio_fan {
+		/* Based on 5v 500mA AFB02505HHB */
+		compatible = "gpio-fan";
+		pinctrl-names = "default";
+		gpios =  <&tps659038_gpio 1 GPIO_ACTIVE_HIGH>;
+		gpio-fan,speed-map = <0    0
+				      13000 1>;
+	};
 };
 
 &dra7_pmx_core {
@@ -314,6 +323,12 @@
 			wakeup-source;
 			ti,palmas-long-press-seconds = <12>;
 		};
+
+		tps659038_gpio: tps659038_gpio {
+			compatible = "ti,palmas-gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
 	};
 
 	tmp102: tmp102@48 {
-- 
1.7.9.5

