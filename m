Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaI2AXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:23:51 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46359 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaI2AXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:23:50 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] clocksource: sh_cmt: Document SoC specific bindings
Date: Mon, 29 Sep 2014 02:23:34 +0200
Message-Id: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <5428A559.5050908@linaro.org>
References: <5428A559.5050908@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms+renesas@verge.net.au>

In general Renesas hardware is not documented to the extent
where the relationship between IP blocks on different SoCs can be assumed
although they may appear to operate the same way. Furthermore the
documentation typically does not specify a version for individual
IP blocks. For these reasons a convention of using the SoC name in place
of a version and providing SoC-specific compat strings has been adopted.

Although not universally liked this convention is used in the bindings for
a number of drivers for Renesas hardware. The purpose of this patch is to
update the Renesas R-Car Compare Match Timer (CMT) driver to follow this
convention.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
* I plan to follow up with patches to use these new bindings in the
  dtsi files for the affected SoCs.

v2
* Reorder compat entries so more-specific entries and their fallbacks
  are grouped with the fallback entry coming last.
* Explicitly document fallback

v3
* Avoid circular dependency in documentation of fallback
  behaviour of renesas,cmt-48-gen2
* Use consistent case for SoC names in compat string descriptions
---
 .../devicetree/bindings/timer/renesas,cmt.txt      | 44 +++++++++++++++++++---
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/renesas,cmt.txt b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
index a17418b..1a05c1b 100644
--- a/Documentation/devicetree/bindings/timer/renesas,cmt.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
@@ -11,15 +11,47 @@ datasheets.
 
 Required Properties:
 
-  - compatible: must contain one of the following.
-    - "renesas,cmt-32" for the 32-bit CMT
+  - compatible: must contain one or more of the following:
+    - "renesas,cmt-32-r8a7740" for the r8a7740 32-bit CMT
+		(CMT0)
+    - "renesas,cmt-32-sh7372" for the sh7372 32-bit CMT
+		(CMT0)
+    - "renesas,cmt-32-sh73a0" for the sh73a0 32-bit CMT
+		(CMT0)
+    - "renesas,cmt-32" for all 32-bit CMT without fast clock support
 		(CMT0 on sh7372, sh73a0 and r8a7740)
-    - "renesas,cmt-32-fast" for the 32-bit CMT with fast clock support
+		This is a fallback for the above renesas,cmt-32-* entries.
+
+    - "renesas,cmt-32-fast-r8a7740" for the r8a7740 32-bit CMT with fast
+		clock support (CMT[234])
+    - "renesas,cmt-32-fast-sh7372" for the sh7372 32-bit CMT with fast
+		clock support (CMT[234])
+    - "renesas,cmt-32-fast-sh73a0" for the sh73A0 32-bit CMT with fast
+		clock support (CMT[234])
+    - "renesas,cmt-32-fast" for all 32-bit CMT with fast clock support
 		(CMT[234] on sh7372, sh73a0 and r8a7740)
-    - "renesas,cmt-48" for the 48-bit CMT
+		This is a fallback for the above renesas,cmt-32-fast-* entries.
+
+    - "renesas,cmt-48-sh7372" for the sh7372 48-bit CMT
+		(CMT1)
+    - "renesas,cmt-48-sh73a0" for the sh73A0 48-bit CMT
+		(CMT1)
+    - "renesas,cmt-48-r8a7740" for the r8a7740 48-bit CMT
+		(CMT1)
+    - "renesas,cmt-48" for all non-second generation 48-bit CMT
 		(CMT1 on sh7372, sh73a0 and r8a7740)
-    - "renesas,cmt-48-gen2" for the second generation 48-bit CMT
+		This is a fallback for the above renesas,cmt-48-* entries.
+
+    - "renesas,cmt-48-r8a73a4" for the r8a73a4 48-bit CMT
+		(CMT[01])
+    - "renesas,cmt-48-r8a7790" for the r8a7790 48-bit CMT
+		(CMT[01])
+    - "renesas,cmt-48-r8a7791" for the r8a7791 48-bit CMT
+		(CMT[01])
+    - "renesas,cmt-48-gen2" for all second generation 48-bit CMT
 		(CMT[01] on r8a73a4, r8a7790 and r8a7791)
+		This is a fallback for the renesas,cmt-48-r8a73a4,
+		renesas,cmt-48-r8a7790 and renesas,cmt-48-r8a7791 entries.
 
   - reg: base address and length of the registers block for the timer module.
   - interrupts: interrupt-specifier for the timer, one per channel.
@@ -36,7 +68,7 @@ Example: R8A7790 (R-Car H2) CMT0 node
 	them channels 0 and 1 in the documentation.
 
 	cmt0: timer@ffca0000 {
-		compatible = "renesas,cmt-48-gen2";
+		compatible = "renesas,cmt-48-r8a7790", "renesas,cmt-48-gen2";
 		reg = <0 0xffca0000 0 0x1004>;
 		interrupts = <0 142 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 142 IRQ_TYPE_LEVEL_HIGH>;
-- 
1.9.1

