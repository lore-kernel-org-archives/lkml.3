Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbaIQEAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:00:24 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:52458 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaIQEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:00:20 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <0e417d5ead785d637fc98657559a3346>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, dmitry.torokhov@gmail.com,
        addy.ke@rock-chips.com, zyf@rock-chips.com, cjf@rock-chips.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v5 2/4] dt-bindings: document Rockchip thermal
Date: Wed, 17 Sep 2014 11:59:11 +0800
Message-Id: <1410926353-15674-3-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410926353-15674-1-git-send-email-caesar.wang@rock-chips.com>
References: <1410926353-15674-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the necessary binding documentation for the thermal
found on Rockchip SoCs

Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 .../bindings/thermal/rockchip-thermal.txt          | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt

diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
new file mode 100644
index 0000000..6fc8bc3
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
@@ -0,0 +1,41 @@
+* Temperature Sensor ADC (TSADC) on rockchip SoCs
+
+Required properties:
+- compatible: "rockchip,rk3288-tsadc"
+- reg: physical base address of the controller and length of memory mapped
+       region.
+- interrupts: The interrupt number to the cpu. The interrupt specifier format
+	      depends on the interrupt controller.
+- clocks: Must contain an entry for each entry in clock-names.
+- clock-names: Shall be "tsadc" for the converter-clock, and "apb_pclk" for
+	       the peripheral clock.
+- num-trips:  number of total trip points, this is required, set it 0 if none,
+  	      if greater than 0, the following properties must be defined;
+- tripN-temp: temperature of trip point N, should be in ascending order;
+- tripN-type: type of trip point N, should be one of "active" "passive" "hot"
+	      "critical";
+- tripN-cdev-num: number of the cooling devices which can be bound to trip
+		  point N, this is required if trip point N is defined, set it 0 if none,
+		  otherwise the following cooling device names must be defined;
+- tripN-cdev-nameM: name of the No. M cooling device of trip point N;
+
+Example:
+tsadc: tsadc@ff280000 {
+	compatible = "rockchip,rk3288-tsadc";
+	reg = <0xff280000 0x100>;
+	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
+	clock-names = "tsadc", "apb_pclk";
+
+	num-trips = <2>;
+
+	trip0-temp = <80>;
+	trip0-type = "passive";
+	trip0-cdev-num = <1>;
+	trip0-cdev-name0 = "thermal-cpufreq-0";
+
+	trip1-temp = <100>;
+	trip1-type = "critical";
+	trip1-cdev-num = <1>;
+	trip1-cdev-name0 = "thermal-cpufreq-0";
+};
-- 
1.9.1


