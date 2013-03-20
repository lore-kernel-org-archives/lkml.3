Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3CTWy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:54:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63942 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3CTWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:40 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 11/11] devtree: add binding documentation for sp804
Date: Wed, 20 Mar 2013 17:54:11 -0500
Message-Id: <1363820051-24428-12-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haojian Zhuang <haojian.zhuang@linaro.org>

The sp804 binding is already in use by several platforms. This adds missing
documentation for the binding and also extends the binding to handle some
additional possible interrupt configurations.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 .../devicetree/bindings/timer/arm,sp804.txt        |   29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/arm,sp804.txt

diff --git a/Documentation/devicetree/bindings/timer/arm,sp804.txt b/Documentation/devicetree/bindings/timer/arm,sp804.txt
new file mode 100644
index 0000000..5cd8eee
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/arm,sp804.txt
@@ -0,0 +1,29 @@
+ARM sp804 Dual Timers
+---------------------------------------
+
+Required properties:
+- compatible: Should be "arm,sp804" & "arm,primecell"
+- interrupts: Should contain the list of Dual Timer interrupts. This is the
+	interrupt for timer 1 and timer 2. In the case of a single entry, it is
+	the combined interrupt or if "arm,sp804-has-irq" is present that
+	specifies which timer interrupt is connected.
+- reg: Should contain location and length for dual timer register.
+- clocks: clocks driving the dual timer hardware. This list should be 1 or 3
+	clocks.	With 3 clocks, the order is timer0 clock, timer1 clock,
+	apb_pclk. A single clock can also be specified if the same clock is
+	used for all clock inputs.
+
+Optional properties:
+- arm,sp804-has-irq = <#>: In the case of only 1 timer irq line connected, this
+	specifies if the irq connection is for timer 1 or timer 2. A value of 1
+	or 2 should be used.
+
+Example:
+
+	timer0: timer@fc800000 {
+		compatible = "arm,sp804", "arm,primecell";
+		reg = <0xfc800000 0x1000>;
+		interrupts = <0 0 4>, <0 1 4>;
+		clocks = <&timclk1 &timclk2 &pclk>;
+		clock-names = "timer1", "timer2", "apb_pclk";
+	};
-- 
1.7.10.4

