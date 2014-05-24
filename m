Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaEXAl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:41:29 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:53277 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEXAlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:41:12 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list), jason@lakedaemon.net
Subject: [PATCH v3 2/2] Documentation: add Broadcom STB Level-2 interrupt controller binding
Date: Fri, 23 May 2014 17:40:54 -0700
Message-Id: <1400892054-24457-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400892054-24457-1-git-send-email-f.fainelli@gmail.com>
References: <1400892054-24457-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Device Tree binding document for the Broadcom
Set-top-box Level 2 interrupt controller hardware.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
No changes in v2 or v3, respin

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

