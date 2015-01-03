Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbbACSa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 13:30:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47027 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbbACSaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 13:30:55 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V3] ARM: dts: am57xx-beagle-x15: Add GPIO controlled fan node
Date: Sat, 3 Jan 2015 12:30:26 -0600
Message-ID: <1420309826-7904-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS gpio now controls a 5v 500mA TL5209 regulator which may be supply
a fan (such as AFB02505HHB) over J1 connector for various purposes.
Provide device tree node to enable the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
V3: Rebased to v3.19-rc1, added label for GPIO fan (for future cooling device
    reference)
V2: https://patchwork.kernel.org/patch/5445111/
V1: https://patchwork.kernel.org/patch/5444911/

Enable and disable can be controlled by (post the RPM, it finds
closest match - even a 1 will do)

echo '13000' > /sys/class/hwmon/hwmon0/fan1_target
and
echo '0' > /sys/class/hwmon/hwmon0/fan1_target

Test log: http://slexy.org/view/s2T0ajh46z

requires CONFIG_GPIO_PALMAS and CONFIG_SENSORS_GPIO_FAN to be operational
Applies on v3.19-rc1

 arch/arm/boot/dts/am57xx-beagle-x15.dts |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/am57xx-beagle-x15.dts b/arch/arm/boot/dts/am57xx-beagle-x15.dts
index 6c2e8e4..c171720 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15.dts
+++ b/arch/arm/boot/dts/am57xx-beagle-x15.dts
@@ -80,6 +80,14 @@
 			default-state = "off";
 		};
 	};
+
+	gpio_fan: gpio_fan {
+		/* Based on 5v 500mA AFB02505HHB */
+		compatible = "gpio-fan";
+		gpios =  <&tps659038_gpio 1 GPIO_ACTIVE_HIGH>;
+		gpio-fan,speed-map = <0    0
+				      13000 1>;
+	};
 };
 
 &dra7_pmx_core {
@@ -394,6 +402,12 @@
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

