Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377AbaEQRxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:53:42 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51233 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856AbaEQRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:53:39 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] Documentation: add Broadcom STB Level-2 interrupt controller binding
Date: Sat, 17 May 2014 10:52:53 -0700
Message-Id: <1400349173-11045-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400349173-11045-1-git-send-email-f.fainelli@gmail.com>
References: <1400349173-11045-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Device Tree binding document for the Broadcom
Set-top-box Level 2 interrupt controller hardware.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/interrupt-controller/brcm,l2-intc.txt | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
new file mode 100644
index 000000000000..448273a30a11
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
@@ -0,0 +1,29 @@
+Broadcom Generic Level 2 Interrupt Controller
+
+Required properties:
+
+- compatible: should be "brcm,l2-intc"
+- reg: specifies the base physical address and size of the registers
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: specifies the number of cells needed to encode an
+  interrupt source. Should be 1.
+- interrupt-parent: specifies the phandle to the parent interrupt controller
+  this controller is cacaded from
+- interrupts: specifies the interrupt line in the interrupt-parent irq space
+  to be used for cascading
+
+Optional properties:
+
+- brcm,irq-can-wake: If present, this means the L2 controller can be used as a
+  wakeup source for system suspend/resume.
+
+Example:
+
+hif_intr2_intc: interrupt-controller@f0441000 {
+	compatible = "brcm,l2-intc";
+	reg = <0xf0441000 0x30>;
+	interrupt-controller;
+	#interrupt-cells = <1>;
+	interrupt-parent = <&intc>;
+	interrupts = <0x0 0x20 0x0>;
+};
-- 
1.9.1

