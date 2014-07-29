Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaG2OHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:07:46 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41000 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaG2OGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:06:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH 3/6] irqchip: irq-st: Add documentation for STi based syscfg IRQs
Date: Tue, 29 Jul 2014 15:05:41 +0100
Message-Id: <1406642744-22589-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406642744-22589-1-git-send-email-lee.jones@linaro.org>
References: <1406642744-22589-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../interrupt-controller/st,sti-irq-syscfg.txt     | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
new file mode 100644
index 0000000..ced6014
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
@@ -0,0 +1,35 @@
+STMicroelectronics STi System Configuration Controlled IRQs
+-----------------------------------------------------------
+
+On STi based systems; External, CTI (Core Sight), PMU (Performance Management),
+and PL310 L2 Cache IRQs are controlled using System Configuration registers.
+This driver is used to unmask them prior to use.
+
+Required properties:
+- compatible	: Should be set to one of:
+			"st,stih415-irq-syscfg"
+			"st,stih416-irq-syscfg"
+			"st,stih407-irq-syscfg"
+			"st,stid127-irq-syscfg"
+- st,syscfg	: Phandle to Cortex-A9 IRQ system config registers
+- st,irq-device	: Array of IRQs to enable - should be 2 in length
+- st,fiq-device	: Array of FIQs to enable - should be 2 in length
+
+Optional properties:
+- st,invert-ext	: External IRQs can be inverted at will.  This property inverts
+		  these IRQs using bitwise logic.  A number of defines have been
+		  provided for convenience:
+			ST_IRQ_SYSCFG_EXT_1_INV
+			ST_IRQ_SYSCFG_EXT_2_INV
+			ST_IRQ_SYSCFG_EXT_3_INV
+Example:
+
+irq-syscfg {
+	compatible    = "st,stih416-irq-syscfg";
+	st,syscfg     = <&syscfg_cpu>;
+	st,irq-device = <ST_IRQ_SYSCFG_PMU_0>,
+			<ST_IRQ_SYSCFG_PMU_1>;
+	st,fiq-device = <ST_IRQ_SYSCFG_DISABLED>,
+			<ST_IRQ_SYSCFG_DISABLED>;
+	st,invert-ext = <(ST_IRQ_SYSCFG_EXT_1_INV | ST_IRQ_SYSCFG_EXT_3_INV)>;
+};
-- 
1.9.1

