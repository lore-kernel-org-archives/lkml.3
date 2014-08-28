Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaH1Wgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:36:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43198 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaH1WgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:36:07 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jason@lakedaemon.net, tglx@linutronix.de, computersforpeace@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 2/2] Documentation: bcm7120-l2: Add Broadcom BCM7120-style L2 binding
Date: Thu, 28 Aug 2014 15:35:26 -0700
Message-Id: <1409265326-7579-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com>
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Device Tree binding document for the Broadcom
BCM7120-style Set-top-box Level 2 interrupt controller hardware.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
new file mode 100644
index 000000000000..3818ffed7347
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
@@ -0,0 +1,44 @@
+Broadcom BCM7120-style Level 2 interrupt controller
+
+Required properties:
+
+- compatible: should be "brcm,bcm7120-l2-intc"
+- reg: specifies the base physical address and size of the registers
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: specifies the number of cells needed to encode an interrupt
+  source, should be 1.
+- interrupt-parent: specifies the phandle to the parent interrupt controller
+  this one is cascaded from
+- interrupts: specifies the interrupt line(s) in the interrupt-parent domain
+  to be used for cascading
+- brcm,int-map-mask: 32-bits bit mask describing how the interrupts at this level
+  map to their respective parents. Should match exactly the number of interrupts
+  specified in the 'interrupts' property.
+
+Optional properties:
+
+- interrupt-names: if present, the litteral names for the parent interrupts
+  specified in the 'interrupts' property.
+
+- brcm,irq-can-wake: if present, this means the L2 controller can be used as a
+  wakeup source for system suspend/resume.
+
+- brcm,int-fwd-mask: if present, a 32-bits bit mask describing the interrupts
+  which need to be enabled in this controller to flow to the higher level
+  interrupt controller. This is typically needed for the UARTs interrupts to
+  flow through the top-level interrupt controller (e.g: ARM GIC on ARM-based
+  platforms).
+
+Example:
+
+irq0_intc: interrupt-controller@f0406800 {
+	compatible = "brcm,bcm7120-l2-intc";
+	interrupt-parent = <&intc>;
+	#interrupt-cells = <1>;
+	reg = <0xf0406800 0x8>;
+	interrupt-controller;
+	interrupts = <0x0 0x42 0x0>, <0x0 0x40 0x0>;
+	interrupt-names = "upg_main", "upg_bsc";
+	brcm,int-map-mask = <0xeb8>, <0x140>;
+	brcm,int-fwd-mask = <0x7>;
+};
-- 
1.9.1

