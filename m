Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaI1Kjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:39:42 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:48064 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaI1Kja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:39:30 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <ade4d90d34e43fa40ad6dc93e2d593d1>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com
Cc: dmitry.torokhov@gmail.com, arnd@arndb.de, zyf@rock-chips.com,
        dianders@chromium.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, cf@rock-chips.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v7 4/5] ARM: dts: add main Thermal info to rk3288
Date: Sun, 28 Sep 2014 18:38:12 +0800
Message-Id: <1411900693-30484-5-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411900693-30484-1-git-send-email-caesar.wang@rock-chips.com>
References: <1411900693-30484-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is depend on rk3xxx-cpu-thermal.dtsi,or
it will compile error.

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 36be7bb..79102b6 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -15,6 +15,7 @@
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/pinctrl/rockchip.h>
 #include <dt-bindings/clock/rk3288-cru.h>
+#include <dt-bindings/thermal/thermal.h>
 #include "skeleton.dtsi"
 
 / {
@@ -215,6 +216,23 @@
 		status = "disabled";
 	};
 
+	thermal-zones {
+		#include "rk3xxx-cpu-thermal.dtsi"
+	};
+
+	tsadc: tsadc@ff280000 {
+		compatible = "rockchip,rk3288-tsadc";
+		reg = <0xff280000 0x100>;
+		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
+		clock-names = "tsadc", "apb_pclk";
+		pinctrl-names = "otp_out";
+		pinctrl-0 = <&otp_out>;
+		#thermal-sensor-cells = <1>;
+		hw-shut-temp = <120000>;
+		status = "disabled";
+	};
+
 	usb_host0_ehci: usb@ff500000 {
 		compatible = "generic-ehci";
 		reg = <0xff500000 0x100>;
@@ -611,5 +629,11 @@
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


