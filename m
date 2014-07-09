Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaGIM23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:28:29 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:44755 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaGIMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:23:54 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/13] irqchip: renesas-irqc: Add DT binding documentation
Date: Wed,  9 Jul 2014 14:23:33 +0200
Message-Id: <1404908623-909-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The renesas-irqc driver supports DT, but the DT binding documentation was
missing.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 .../bindings/interrupt-controller/renesas,irqc.txt | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt b/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt
new file mode 100644
index 000000000000..f819e2a5907c
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt
@@ -0,0 +1,30 @@
+DT bindings for the R-Mobile/R-Car interrupt controller
+
+Required properties:
+
+- compatible: has to be "renesas,irqc-<soctype>", "renesas,irqc" as fallback.
+  Examples with soctypes are:
+    - "renesas,irqc-r8a73a4" (R-Mobile AP6)
+    - "renesas,irqc-r8a7790" (R-Car H2)
+    - "renesas,irqc-r8a7791" (R-Car M2)
+- #interrupt-cells: has to be <2>: an interrupt index and flags, as defined in
+  interrupts.txt in this directory
+
+Optional properties:
+
+- any properties, listed in interrupts.txt, and any standard resource allocation
+  properties
+
+Example:
+
+	irqc0: interrupt-controller@e61c0000 {
+		compatible = "renesas,irqc-r8a7790", "renesas,irqc";
+		#interrupt-cells = <2>;
+		interrupt-controller;
+		reg = <0 0xe61c0000 0 0x200>;
+		interrupts = <0 0 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 1 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 2 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 3 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
-- 
1.9.1

