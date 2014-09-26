Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaIZOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:34:50 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:35412 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbaIZOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:34:42 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <2454404e35531a31942881589fd0a063>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com
Cc: dmitry.torokhov@gmail.com, arnd@arndb.de, zyf@rock-chips.com,
        dianders@chromium.org, cjf@rock-chips.com, zhengsq@rock-chips.com,
        linux-rockchip@list.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v6 3/3] ARM: dts: add main Thermal info to rk3288
Date: Fri, 26 Sep 2014 22:33:12 +0800
Message-Id: <1411741992-18890-4-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411741992-18890-1-git-send-email-caesar.wang@rock-chips.com>
References: <1411741992-18890-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 36be7bb..6092d34 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -15,6 +15,7 @@
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/pinctrl/rockchip.h>
 #include <dt-bindings/clock/rk3288-cru.h>
+#include <dt-bindings/thermal/thermal.h>
 #include "skeleton.dtsi"
 
 / {
@@ -215,6 +216,43 @@
 		status = "disabled";
 	};
 
+        thermal-zones {
+                cpu {
+                        polling-delay-passive = <2000>;
+                        polling-delay = <1000>;
+
+                        thermal-sensors =
+                                <&tsadc 0>;
+
+                        trips {
+                                cpu_alert0: cpu_alert {
+                                        temperature = <80000>; /* millicelsius */
+                                        hysteresis = <2000>; /* millicelsius */
+                                        type = "passive";
+                                };
+                                cpu_crit: cpu_crit {
+                                        temperature = <120000>; /* millicelsius */
+                                        hysteresis = <2000>; /* millicelsius */
+                                        type = "critical";
+                                };
+                        };
+                };
+        };
+
+        tsadc: tsadc@ff280000 {
+                compatible = "rockchip,rk3288-tsadc";
+                reg = <0xff280000 0x100>;
+                interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
+                clock-names = "tsadc", "apb_pclk";
+                pinctrl-names = "tsadc_int";
+                pinctrl-0 = <&otp_out>;
+                reset-gpios = <&gpio0 10 GPIO_ACTIVE_HIGH>;
+
+                #thermal-sensor-cells = <1>;
+                hw-shut-temp = <115000>;
+        };
+
 	usb_host0_ehci: usb@ff500000 {
 		compatible = "generic-ehci";
 		reg = <0xff500000 0x100>;
@@ -611,5 +649,11 @@
 				rockchip,pins = <5 15 3 &pcfg_pull_none>;
 			};
 		};
+
+                tsadc {
+                        otp_out: otp-out {
+                                rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_none>;
+                    };
+                };
 	};
 };
-- 
1.9.1


