Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaIERcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:32:17 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:34896 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaIERah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:30:37 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/16] of: Add binding document for MIPS GIC
Date: Fri,  5 Sep 2014 10:30:13 -0700
Message-Id: <1409938218-9026-12-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Global Interrupt Controller (GIC) present on certain MIPS systems
can be used to route external interrupts to individual VPEs and CPU
interrupt vectors.  It also supports a timer and software-generated
interrupts.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v1:
 - moved from mips/ to interrupt-controller/
 - removed interrupts and interrupt-parent properties
 - added available-cpu-vectors property
 - dropped third cell in interrupt specifier
---
 .../bindings/interrupt-controller/mips-gic.txt     | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt b/Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt
new file mode 100644
index 0000000..81ca911
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt
@@ -0,0 +1,39 @@
+MIPS Global Interrupt Controller (GIC)
+
+The MIPS GIC routes external interrupts to individual VPEs and IRQ pins.
+It also supports local (per-processor) interrupts and software-generated
+interrupts which can be used as IPIs.
+
+Required properties:
+- compatible : Should be "mti,global-interrupt-controller"
+- reg : Base address and length of the GIC registers.
+- interrupts : Core interrupts to which the GIC may route external interrupts.
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt specifier.  Should be 2.
+  - The first cell is the GIC interrupt number.
+  - The second cell encodes the interrupt flags.
+    See <include/dt-bindings/interrupt-controller/irq.h> for a list of valid
+    flags.
+- mti,available-cpu-vectors : Specifies the list of CPU interrupt vectors
+  to which the GIC may route interrupts.  May contain up to 6 entries, one
+  for each of the CPU's hardware interrupt vectors.  Valid values are 2 - 7.
+
+Example:
+
+	gic: interrupt-controller@1bdc0000 {
+		compatible = "mti,global-interrupt-controller";
+		reg = <0x1bdc0000 0x20000>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+
+		mti,available-cpu-vectors = <2>, <3>, <4>, <5>;
+	};
+
+	uart@18101400 {
+		...
+		interrupt-parent = <&gic>;
+		interrupts = <24 IRQ_TYPE_LEVEL_HIGH>;
+		...
+	};
-- 
2.1.0.rc2.206.gedb03e5

