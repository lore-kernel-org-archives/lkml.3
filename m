Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaGIM2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:28:32 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:44756 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaGIMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:23:54 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/13] irqchip: renesas-intc-irqpin: Document SoC-specific bindings
Date: Wed,  9 Jul 2014 14:23:32 +0200
Message-Id: <1404908623-909-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation only mentioned the generic fallback compatible property.
Add the missing SoC-specific compatible properties, which are already in
use.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 .../bindings/interrupt-controller/renesas,intc-irqpin.txt         | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt b/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
index 1f8b0c507c26..c73acd060093 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
@@ -2,7 +2,13 @@ DT bindings for the R-/SH-Mobile irqpin controller
 
 Required properties:
 
-- compatible: has to be "renesas,intc-irqpin"
+- compatible: has to be "renesas,intc-irqpin-<soctype>", "renesas,intc-irqpin"
+  as fallback.
+  Examples with soctypes are:
+    - "renesas,intc-irqpin-r8a7740" (R-Mobile A1)
+    - "renesas,intc-irqpin-r8a7778" (R-Car M1A)
+    - "renesas,intc-irqpin-r8a7779" (R-Car H1)
+    - "renesas,intc-irqpin-sh73a0" (SH-Mobile AG5)
 - #interrupt-cells: has to be <2>: an interrupt index and flags, as defined in
   interrupts.txt in this directory
 
-- 
1.9.1

