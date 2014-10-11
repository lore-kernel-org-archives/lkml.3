Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaJKH3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 03:29:48 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:59383 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaJKH3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 03:29:43 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <e8d7553ca3873a24b973a2ac55266e46>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com, arnd@arndb.de
Cc: zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v9 2/5] dt-bindings: document Rockchip thermal
Date: Sat, 11 Oct 2014 15:29:20 +0800
Message-Id: <1413012563-7690-3-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413012563-7690-1-git-send-email-caesar.wang@rock-chips.com>
References: <1413012563-7690-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the necessary binding documentation for the thermal
found on Rockchip SoCs

Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 .../bindings/thermal/rockchip-thermal.txt          | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt

diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
new file mode 100644
index 0000000..d5ff410
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
@@ -0,0 +1,45 @@
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
+- #thermal-sensor-cells: Should be 1. See ./thermal.txt for a description.
+
+Exiample:
+tsadc: tsadc@ff280000 {
+	compatible = "rockchip,rk3288-tsadc";
+	reg = <0xff280000 0x100>;
+	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
+	clock-names = "tsadc", "apb_pclk";
+};
+
+Example: referring to thermal sensors:
+thermal-zones {
+       cpu_thermal: cpu_thermal {
+	        polling-delay-passive = <500>; /* milliseconds */
+	        polling-delay = <1000>; /* milliseconds */
+
+			        /* sensor	ID */
+	        thermal-sensors = <&tsadc	1>;
+
+	        trips {
+		        cpu_alert0: cpu_alert {
+			        temperature = <80000>; /* millicelsius */
+			        hysteresis = <2000>; /* millicelsius */
+			        type = "passive";
+		        };
+		        cpu_crit: cpu_crit {
+			        temperature = <125000>; /* millicelsius */
+			        hysteresis = <2000>; /* millicelsius */
+			    type = "critical";
+		        };
+	        };
+       };
+};
-- 
1.9.1


