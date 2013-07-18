Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3GRIur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:50:47 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:52816 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab3GRIuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:50:44 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] Documentation: Add device tree binding file for MOXA ART SoCs interrupt controller
Date: Thu, 18 Jul 2013 10:50:26 +0200
Message-Id: <1374137426-6763-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding document for MOXA ART SoCs interrupt controller.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    The MOXA ART irqchip driver was added without accompanying devicetree document.
    ( in next-20130716   drivers/irqchip/irq-moxart.c )
    
    Applies to next-20130716

 .../interrupt-controller/moxa,moxart-ic.txt        | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
new file mode 100644
index 0000000..58f1fe1
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
@@ -0,0 +1,28 @@
+* MOXA ART Interrupt Controller
+
+MOXA ART Interrupt Controller (moxart-ic) is used on MOXA ART SoCs
+and supports 32 non-configurable number of interrupts
+
+Main node required properties:
+
+- compatible : "moxa,moxart-ic"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The type shall be a <u32> and the value shall be 2.
+
+  The first cell contains the interrupt number in the range [0-31].
+  The second cell contains the interrupt type
+
+- reg: physical base address and size of the intc registers map.
+- interrupt-mask: Specifies if the interrupt is edge or level-triggered
+  each bit represent an interrupt 0-31 where 1 signify edge
+
+Example:
+
+	intc: interrupt-controller@98800000 {
+		compatible = "moxa,moxart-ic";
+		reg = <0x98800000 0x38>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		interrupt-mask = <0x00080000>;
+	};
-- 
1.8.2.1

