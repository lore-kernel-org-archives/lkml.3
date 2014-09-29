Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaI2A1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:27:04 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38605 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaI2AXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:23:51 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] clocksource: sh_mtu2: Document r7s72100 binding
Date: Mon, 29 Sep 2014 02:23:35 +0200
Message-Id: <1411950226-21598-2-git-send-email-daniel.lezcano@linaro.org>
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
to update the Renesas R-Car Multi-Function Timer Pulse Unit 2 (MTU2) driver
to follow this convention.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
* I plan to follow up with a patch patch to use the new binding in the
  dtsi files for the r7s72100 SoC.

v2
* Suggestions by Mark Rutland and Sergei Shtylyov
  - Compatible strings should be "one or more" not "one" of those listed
  - Describe the generic binding as covering any MTU2 device
  - Re-order compat strings from most to least specific

v3
* Suggested by Laurent Pinchart
  - Reword compat documentation for consistency with a more extensive
    CMT change
---
 Documentation/devicetree/bindings/timer/renesas,mtu2.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
index 917453f..d9a8d5a 100644
--- a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
@@ -8,7 +8,10 @@ are independent. The MTU2 hardware supports five channels indexed from 0 to 4.
 
 Required Properties:
 
-  - compatible: must contain "renesas,mtu2"
+  - compatible: must be one or more of the following:
+    - "renesas,mtu2-r7s72100" for the r7s72100 MTU2
+    - "renesas,mtu2" for any MTU2
+      This is a fallback for the above renesas,mtu2-* entries
 
   - reg: base address and length of the registers block for the timer module.
 
@@ -26,7 +29,7 @@ Required Properties:
 Example: R7S72100 (RZ/A1H) MTU2 node
 
 	mtu2: timer@fcff0000 {
-		compatible = "renesas,mtu2";
+		compatible = "renesas,mtu2-r7s72100", "renesas,mtu2";
 		reg = <0xfcff0000 0x400>;
 		interrupts = <0 139 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 146 IRQ_TYPE_LEVEL_HIGH>,
-- 
1.9.1

