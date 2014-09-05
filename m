Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaIEUwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:52:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52507 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaIEUwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:52:35 -0400
From: Nishanth Menon <nm@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH V2 2/3] Documentation: dt-bindings: mfd: palmas: document optional wakeup IRQ
Date: Fri, 5 Sep 2014 15:51:50 -0500
Message-ID: <1409950311-25236-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409950311-25236-1-git-send-email-nm@ti.com>
References: <1409950311-25236-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent pinctrl-single changes, SoCs such as OMAP family can
treat wake-up events from deeper low power states as interrupts.

This is usable when the wakeup from deeper low power states is
triggered by a different hardware mechanism tied to pinctrl compared
to the routine interrupt handling generating the reqular interrupt
events. This is usually done on SoCs where the routine interrupt
sources such as GPIO need to be disabled to be actually achieve low
power state and wakeup is triggered from pinctrl interrupt source.

Provide documentation example for the case where the system needs two
interrupt sources when SoC is in deep sleep(1 to exit from deep sleep,
and other from the module handling the actual event).

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 Documentation/devicetree/bindings/mfd/palmas.txt |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
index d193859..1c821d6 100644
--- a/Documentation/devicetree/bindings/mfd/palmas.txt
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -51,3 +51,23 @@ palmas@48 {
 		....
 	};
 }
+
+Example: With interrupts extended
+ See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+ Use pinmux 0x418 as wakeup interrupt and gpio1_0 as interrupt source
+
+palmas@48 {
+	compatible = "ti,twl6035", "ti,palmas";
+	reg = <0x48>
+	interrupt-parent = <&intc>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	interrupts-extended = <&gpio1 0 IRQ_TYPE_LEVEL_HIGH>,
+			      <&pinmux 0x418>;
+	pmic {
+		compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
+		....
+	};
+}
-- 
1.7.9.5

