Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaCCTv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:51:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34337 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaCCTvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:51:53 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 2/5] dt: define IRQ flags bit 4 as src/dst inversion
Date: Mon,  3 Mar 2014 12:51:37 -0700
Message-Id: <1393876300-3061-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Some devices have configurable IRQ output polarities. Software might
use IRQ specifier flag bits[3:0] to determine how to configure such a
device's IRQ output polarity in order to match how the IRQ controller
input is configured. If the board or SoC inverts the signal between the
device's IRQ output and controller's IRQ output, software must be
aware of this fact, in order to program the IRQ output to the correct
(i.e. opposite) polarity. This flag provides that information.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3: New patch.
---
 Documentation/devicetree/bindings/arm/gic.txt                     | 8 ++++++++
 .../devicetree/bindings/interrupt-controller/interrupts.txt       | 8 ++++++++
 include/dt-bindings/interrupt-controller/irq.h                    | 1 +
 3 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index bae0d87a38b2..b0b65a440239 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -33,6 +33,14 @@ Main node required properties:
 		2 = high-to-low edge triggered
 		4 = active high level-sensitive
 		8 = active low level-sensitive
+	bit[4] IRQ is inverted between source and sink.
+	Some devices have configurable IRQ output polarities. Software might
+	use flag bits[3:0] to determine how to configure such a device's IRQ
+	output polarity in order to match how the IRQ controller input is
+	configured. If the board or SoC inverts the signal between the
+	device's IRQ output and controller's IRQ output, software must be
+	aware of this fact, in order to program the IRQ output to the correct
+	(i.e. opposite) polarity. This flag provides that information.
 	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
 	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
 	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
index 1486497a24c1..636eb0f478bf 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
@@ -76,6 +76,14 @@ commonly used:
         2 = high-to-low edge triggered
         4 = active high level-sensitive
         8 = active low level-sensitive
+    - bit[4] IRQ is inverted between source and sink
+        Some devices have configurable IRQ output polarities. Software might
+        use flag bits[3:0] to determine how to configure such a device's IRQ
+        output polarity in order to match how the IRQ controller input is
+        configured. If the board or SoC inverts the signal between the
+        device's IRQ output and controller's IRQ output, software must be
+        aware of this fact, in order to program the IRQ output to the correct
+        (i.e. opposite) polarity. This flag provides that information.
 
   Example:
 
diff --git a/include/dt-bindings/interrupt-controller/irq.h b/include/dt-bindings/interrupt-controller/irq.h
index 33a1003c55aa..5b04918c5c72 100644
--- a/include/dt-bindings/interrupt-controller/irq.h
+++ b/include/dt-bindings/interrupt-controller/irq.h
@@ -15,5 +15,6 @@
 #define IRQ_TYPE_EDGE_BOTH	(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING)
 #define IRQ_TYPE_LEVEL_HIGH	4
 #define IRQ_TYPE_LEVEL_LOW	8
+#define IRQ_SRC_DST_INVERTED	16
 
 #endif
-- 
1.8.1.5

