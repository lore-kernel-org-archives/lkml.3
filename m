Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbaCRRbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:31:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45295 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258AbaCRRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:31:09 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        ckeepax@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] arizona: Correct small errors in the DT binding documentation
Date: Tue, 18 Mar 2014 17:22:29 +0000
Message-Id: <1395163353-1608-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395163353-1608-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395163353-1608-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does not alter the binding at all it only brings the
documentation up to date with the existing binding.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   23 +++++++++++---------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 0e295c9..36a0c3d 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -5,9 +5,10 @@ of analogue I/O.
 
 Required properties:
 
-  - compatible : one of the following chip-specific strings:
-	"wlf,wm5102"
-	"wlf,wm5110"
+  - compatible : One of the following chip-specific strings:
+        "wlf,wm5102"
+        "wlf,wm5110"
+        "wlf,wm8997"
   - reg : I2C slave address when connected using I2C, chip select number when
     using SPI.
 
@@ -25,8 +26,9 @@ Required properties:
   - #gpio-cells : Must be 2. The first cell is the pin number and the
     second cell is used to specify optional parameters (currently unused).
 
-  - AVDD1-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
-    SPKVDDL-supply, SPKVDDR-supply : power supplies for the device, as covered
+  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply (wm5102, wm5110),
+    CPVDD-supply, SPKVDDL-supply (wm5102, wm5110), SPKVDDR-supply (wm5102,
+    wm5110), SPKVDD-supply (wm8997) : Power supplies for the device, as covered
     in Documentation/devicetree/bindings/regulator/regulator.txt
 
 Optional properties:
@@ -46,6 +48,7 @@ codec: wm5102@1a {
 	compatible = "wlf,wm5102";
 	reg = <0x1a>;
 	interrupts = <347>;
+	interrupt-controller;
 	#interrupt-cells = <2>;
         interrupt-parent = <&gic>;
 
@@ -53,10 +56,10 @@ codec: wm5102@1a {
 	#gpio-cells = <2>;
 
 	wlf,gpio-defaults = <
-		0x00000000, /* AIF1TXLRCLK */
-		0xffffffff,
-		0xffffffff,
-		0xffffffff,
-		0xffffffff,
+		0x00000000 /* AIF1TXLRCLK */
+		0xffffffff
+		0xffffffff
+		0xffffffff
+		0xffffffff
 	>;
 };
-- 
1.7.2.5

