Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbaIOXv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:51:56 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:51641 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbaIOXvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:36 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/24] MIPS: Rename mips_cpu_intc_init() -> mips_cpu_irq_of_init()
Date: Mon, 15 Sep 2014 16:51:05 -0700
Message-Id: <1410825087-5497-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mips_cpu_intc_init() is used for DT-based initialization of the CPU
IRQ domain.  Give it a more appropriate name.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 Documentation/devicetree/bindings/mips/cpu_irq.txt | 4 ++--
 arch/mips/include/asm/irq_cpu.h                    | 4 ++--
 arch/mips/kernel/irq_cpu.c                         | 4 ++--
 arch/mips/ralink/irq.c                             | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/mips/cpu_irq.txt b/Documentation/devicetree/bindings/mips/cpu_irq.txt
index 13aa4b6..fc149f3 100644
--- a/Documentation/devicetree/bindings/mips/cpu_irq.txt
+++ b/Documentation/devicetree/bindings/mips/cpu_irq.txt
@@ -1,6 +1,6 @@
 MIPS CPU interrupt controller
 
-On MIPS the mips_cpu_intc_init() helper can be used to initialize the 8 CPU
+On MIPS the mips_cpu_irq_of_init() helper can be used to initialize the 8 CPU
 IRQs from a devicetree file and create a irq_domain for IRQ controller.
 
 With the irq_domain in place we can describe how the 8 IRQs are wired to the
@@ -36,7 +36,7 @@ Example devicetree:
 
 Example platform irq.c:
 static struct of_device_id __initdata of_irq_ids[] = {
-	{ .compatible = "mti,cpu-interrupt-controller", .data = mips_cpu_intc_init },
+	{ .compatible = "mti,cpu-interrupt-controller", .data = mips_cpu_irq_of_init },
 	{ .compatible = "ralink,rt2880-intc", .data = intc_of_init },
 	{},
 };
diff --git a/arch/mips/include/asm/irq_cpu.h b/arch/mips/include/asm/irq_cpu.h
index 3f11fdb..39a160b 100644
--- a/arch/mips/include/asm/irq_cpu.h
+++ b/arch/mips/include/asm/irq_cpu.h
@@ -19,8 +19,8 @@ extern void rm9k_cpu_irq_init(void);
 
 #ifdef CONFIG_IRQ_DOMAIN
 struct device_node;
-extern int mips_cpu_intc_init(struct device_node *of_node,
-			      struct device_node *parent);
+extern int mips_cpu_irq_of_init(struct device_node *of_node,
+				struct device_node *parent);
 #endif
 
 #endif /* _ASM_IRQ_CPU_H */
diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index b097f7d..ca98a9f 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -135,8 +135,8 @@ void __init mips_cpu_irq_init(void)
 	__mips_cpu_irq_init(NULL);
 }
 
-int __init mips_cpu_intc_init(struct device_node *of_node,
-			      struct device_node *parent)
+int __init mips_cpu_irq_of_init(struct device_node *of_node,
+				struct device_node *parent)
 {
 	__mips_cpu_irq_init(of_node);
 	return 0;
diff --git a/arch/mips/ralink/irq.c b/arch/mips/ralink/irq.c
index 781b3d1..0495011 100644
--- a/arch/mips/ralink/irq.c
+++ b/arch/mips/ralink/irq.c
@@ -173,7 +173,7 @@ static int __init intc_of_init(struct device_node *node,
 }
 
 static struct of_device_id __initdata of_irq_ids[] = {
-	{ .compatible = "mti,cpu-interrupt-controller", .data = mips_cpu_intc_init },
+	{ .compatible = "mti,cpu-interrupt-controller", .data = mips_cpu_irq_of_init },
 	{ .compatible = "ralink,rt2880-intc", .data = intc_of_init },
 	{},
 };
-- 
2.1.0.rc2.206.gedb03e5

