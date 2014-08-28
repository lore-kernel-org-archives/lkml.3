Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbaH1BAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:00:18 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:55396 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbaH1BAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:00:14 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <6b08b8a982acb7c36d0342e08c11baf9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org
Cc: robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        Caesar Wang <caesar.wang@rock-chips.com>,
        zhaoyifeng <zyf@rock-chips.com>
Subject: [PATCH v3 2/4] dt-bindings: document Rockchip thermal
Date: Thu, 28 Aug 2014 08:59:20 +0800
Message-Id: <1409187562-12370-3-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the necessary binding documentation for the thermal
found on Rockchip SoCs

Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 .../devicetree/bindings/thermal/rockchip-thermal.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt

diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
new file mode 100644
index 0000000..1ed4d4c
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
@@ -0,0 +1,20 @@
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
+
+Example:
+tsadc: tsadc@ff280000 {
+	compatible = "rockchip,rk3288-tsadc";
+	reg = <0xff280000 0x100>;
+	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
+	clock-names = "tsadc", "apb_pclk";
+};
-- 
1.9.1


