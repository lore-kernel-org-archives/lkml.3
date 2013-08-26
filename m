Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab3HZI35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:29:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:57916 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3HZI34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:29:56 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benoit Cousson <bcousson@baylibre.com>, tony@atomide.com
Cc: Joel Fernandes <joelf@ti.com>, santosh.shilimkar@ti.com,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Matt Porter <mdp@ti.com>, Matt Porter <mporter@ti.com>,
        Joel A Fernandes <joelagnel@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2] ARM: dts: add AM33XX EDMA support
Date: Mon, 26 Aug 2013 10:29:44 +0200
Message-Id: <1377505784-9820-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mdp@ti.com>

Adds AM33XX EDMA support to the am33xx.dtsi as documented in
Documentation/devicetree/bindings/dma/ti-edma.txt

Joel: Drop DT entries that are non-hardware-description for now as discussed in [1]

[1] https://patchwork.kernel.org/patch/2226761/

Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Could someone please pick this up?

v1..v2:
	- s/edma@/dma-controller@/

 arch/arm/boot/dts/am33xx.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 38b446b..784f774 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -96,6 +96,18 @@
 			reg = <0x48200000 0x1000>;
 		};
 
+		edma: dma-controller@49000000 {
+			compatible = "ti,edma3";
+			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
+			reg =	<0x49000000 0x10000>,
+				<0x44e10f90 0x10>;
+			interrupts = <12 13 14>;
+			#dma-cells = <1>;
+			dma-channels = <64>;
+			ti,edma-regions = <4>;
+			ti,edma-slots = <256>;
+		};
+
 		gpio0: gpio@44e07000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio1";
-- 
1.8.4.rc3

