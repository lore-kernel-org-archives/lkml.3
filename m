Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3ILPk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:40:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36345 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab3ILPky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:40:54 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tglx@linutronix.de>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <r.sricharan@ti.com>
Subject: [RFC PATCH 2/4] ARM: DTS: DRA: Add crossbar device binding
Date: Thu, 12 Sep 2013 21:09:09 +0530
Message-ID: <1379000351-15672-3-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379000351-15672-1-git-send-email-r.sricharan@ti.com>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the irq crossbar device node.

There is a IRQ crossbar device in the soc, which
maps the irq requests from the peripherals to the
mpu interrupt controller's inputs. The Peripheral irq
requests are connected to only one crossbar
input and the output of the crossbar is connected to only one
controller's input line. This models the crossbar as an interrupt
controller. This a cascaded irqchip where the peripheral interrupt
lines are connected to the crossbar and the crossbar's outputs
are in turn connected to the GIC.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index a5d9350..da977e1 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -84,6 +84,7 @@
 		#size-cells = <1>;
 		ranges;
 		ti,hwmods = "l3_main_1", "l3_main_2";
+		interrupt-parent = <&crossbar_mpu>;
 
 		counter32k: counter@4ae04000 {
 			compatible = "ti,omap-counter32k";
@@ -491,5 +492,20 @@
 			dmas = <&sdma 70>, <&sdma 71>;
 			dma-names = "tx0", "rx0";
 		};
+
+		crossbar_mpu: @4a020000 {
+			compatible = "crossbar-irqchip";
+			interrupt-parent = <&gic>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			reg = <0x4a002a48 0x130>;
+			max-crossbar-lines = <512>;
+			max-irqs = <160>;
+			reg-size = <2>;
+			irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+		};
+
 	};
 };
-- 
1.7.9.5

