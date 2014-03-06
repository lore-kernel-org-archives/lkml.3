Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaCFF6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:58:38 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53553 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCFF6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:58:36 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        devicetree@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] devicetree: bindings: gpio-davinic: fix documentation
Date: Thu,  6 Mar 2014 11:28:25 +0530
Message-Id: <1394085505-11227-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch adds missing #gpio-cells and also adds a
usage example for leds.

Reported-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 .../devicetree/bindings/gpio/gpio-davinci.txt      |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
index 4ce9862..5079ba7 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
@@ -8,6 +8,10 @@ Required Properties:
 
 - gpio-controller : Marks the device node as a gpio controller.
 
+- #gpio-cells : Should be two.
+  - first cell is the pin number
+  - second cell is used to specify optional parameters (unused)
+
 - interrupt-parent: phandle of the parent interrupt controller.
 
 - interrupts: Array of GPIO interrupt number. Only banked or unbanked IRQs are
@@ -27,6 +31,7 @@ Example:
 gpio: gpio@1e26000 {
 	compatible = "ti,dm6441-gpio";
 	gpio-controller;
+	#gpio-cells = <2>;
 	reg = <0x226000 0x1000>;
 	interrupt-parent = <&intc>;
 	interrupts = <42 IRQ_TYPE_EDGE_BOTH 43 IRQ_TYPE_EDGE_BOTH
@@ -39,3 +44,19 @@ gpio: gpio@1e26000 {
 	interrupt-controller;
 	#interrupt-cells = <2>;
 };
+
+leds {
+	compatible = "gpio-leds";
+
+	led1 {
+		label = "davinci:green:usr1";
+		gpios = <&gpio 10 GPIO_ACTIVE_HIGH>;
+		...
+	};
+
+	led2 {
+		label = "davinci:red:debug1";
+		gpios = <&gpio 11 GPIO_ACTIVE_HIGH>;
+		...
+	};
+};
-- 
1.7.9.5

