Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbaJ3CTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:19:49 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64258 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaJ3CTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:19:43 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V2 03/15] genirq: Generic chip: Move irq_reg_{readl,writel} accessors into generic-chip.c
Date: Wed, 29 Oct 2014 19:17:56 -0700
Message-Id: <1414635488-14137-4-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to implement per-irqchip behavior when necessary, instead
of hardcoding the behavior for all irqchip drivers at compile time.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 include/linux/irq.h       |  7 -------
 kernel/irq/generic-chip.c | 10 ++++++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 03f48d9..8049e93 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -639,13 +639,6 @@ void arch_teardown_hwirq(unsigned int irq);
 void irq_init_desc(unsigned int irq);
 #endif
 
-#ifndef irq_reg_writel
-# define irq_reg_writel(val, addr)	writel(val, addr)
-#endif
-#ifndef irq_reg_readl
-# define irq_reg_readl(addr)		readl(addr)
-#endif
-
 /**
  * struct irq_chip_regs - register offsets for struct irq_gci
  * @enable:	Enable register offset to reg_base
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index cf80e7b..380595f 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -17,6 +17,16 @@
 static LIST_HEAD(gc_list);
 static DEFINE_RAW_SPINLOCK(gc_lock);
 
+static void irq_reg_writel(u32 val, void __iomem *addr)
+{
+	writel(val, addr);
+}
+
+static u32 irq_reg_readl(void __iomem *addr)
+{
+	return readl(addr);
+}
+
 /**
  * irq_gc_noop - NOOP function
  * @d: irq_data
-- 
2.1.1

