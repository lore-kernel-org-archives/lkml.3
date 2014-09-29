Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaI2AX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:23:57 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46898 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaI2AXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:23:53 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] clocksource: sh_tmu: Document r8a7779 binding
Date: Mon, 29 Sep 2014 02:23:36 +0200
Message-Id: <1411950226-21598-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
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

Although not universally liked this convention is used in the bindings
for a number of drivers for Renesas hardware. The purpose of this patch is
to update the Renesas R-Car Timer Unit (TMU) driver to follow this
convention.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
* I plan to follow up with a patch patch to use the new binding in the
  dtsi files for the r8a7779 SoC.
commit 471269b790aec03385dc4fb127ed7094ff83c16d

v2
* Suggestions by Mark Rutland and Sergei Shtylyov
  - Compatible strings should be "one or more" not "one" of those listed
  - Describe the generic binding as covering any MTU2 device
  - Re-order compat strings from most to least specific

v3
* Suggested by Laurent Pinchart
  - Reword in keeping with a similar though more extensive patch for CMT
---
 Documentation/devicetree/bindings/timer/renesas,tmu.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
index 425d0c5..7db89fb 100644
--- a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
@@ -8,7 +8,10 @@ are independent. The TMU hardware supports up to three channels.
 
 Required Properties:
 
-  - compatible: must contain "renesas,tmu"
+  - compatible: must contain one or more of the following:
+    - "renesas,tmu-r8a7779" for the r8a7779 TMU
+    - "renesas,tmu" for any TMU.
+      This is a fallback for the above renesas,tmu-* entries
 
   - reg: base address and length of the registers block for the timer module.
 
@@ -27,7 +30,7 @@ Optional Properties:
 Example: R8A7779 (R-Car H1) TMU0 node
 
 	tmu0: timer@ffd80000 {
-		compatible = "renesas,tmu";
+		compatible = "renesas,tmu-r8a7779", "renesas,tmu";
 		reg = <0xffd80000 0x30>;
 		interrupts = <0 32 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 33 IRQ_TYPE_LEVEL_HIGH>,
-- 
1.9.1

