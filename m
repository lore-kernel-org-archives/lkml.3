Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab3FFLXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:23:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30885 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3FFLXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:23:31 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 6/7] irq: fix checkpatch warnings
Date: Thu, 6 Jun 2013 19:20:30 +0800
Message-ID: <1370517631-8684-7-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
In-Reply-To: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line over and code indent warning, and use pr_foo().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/spurious.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 7b5f012..84cf547 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -68,7 +68,8 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 	raw_spin_lock(&desc->lock);
 
 	/* PER_CPU and nested thread interrupts are never polled */
-	if (irq_settings_is_per_cpu(desc) || irq_settings_is_nested_thread(desc))
+	if (irq_settings_is_per_cpu(desc) ||
+			irq_settings_is_nested_thread(desc))
 		goto out;
 
 	/*
@@ -123,7 +124,7 @@ static int misrouted_irq(int irq)
 
 	for_each_irq_desc(i, desc) {
 		if (!i)
-			 continue;
+			continue;
 
 		if (i == irq)	/* Already tried */
 			continue;
@@ -150,7 +151,7 @@ static void poll_spurious_irqs(unsigned long dummy)
 		unsigned int state;
 
 		if (!i)
-			 continue;
+			continue;
 
 		/* Racy but it doesn't matter */
 		state = desc->istate;
@@ -191,14 +192,14 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	unsigned long flags;
 
 	if (bad_action_ret(action_ret)) {
-		printk(KERN_ERR "irq event %d: bogus return value %x\n",
+		pr_err("irq event %d: bogus return value %x\n",
 				irq, action_ret);
 	} else {
-		printk(KERN_ERR "irq %d: nobody cared (try booting with "
+		pr_err("irq %d: nobody cared (try booting with "
 				"the \"irqpoll\" option)\n", irq);
 	}
 	dump_stack();
-	printk(KERN_ERR "handlers:\n");
+	pr_err("handlers:\n");
 
 	/*
 	 * We need to take desc->lock here. note_interrupt() is called
@@ -209,11 +210,11 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	while (action) {
-		printk(KERN_ERR "[<%p>] %pf", action->handler, action->handler);
+		pr_err("[<%p>] %pf", action->handler, action->handler);
 		if (action->thread_fn)
-			printk(KERN_CONT " threaded [<%p>] %pf",
+			pr_cont(" threaded [<%p>] %pf",
 					action->thread_fn, action->thread_fn);
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 		action = action->next;
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -313,7 +314,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		/*
 		 * Now kill the IRQ
 		 */
-		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
+		pr_emerg("Disabling IRQ #%d\n", irq);
 		desc->istate |= IRQS_SPURIOUS_DISABLED;
 		desc->depth++;
 		irq_disable(desc);
@@ -329,7 +330,7 @@ bool noirqdebug __read_mostly;
 int noirqdebug_setup(char *str)
 {
 	noirqdebug = 1;
-	printk(KERN_INFO "IRQ lockup detection disabled\n");
+	pr_info("IRQ lockup detection disabled\n");
 
 	return 1;
 }
@@ -341,8 +342,8 @@ MODULE_PARM_DESC(noirqdebug, "Disable irq lockup detection when true");
 static int __init irqfixup_setup(char *str)
 {
 	irqfixup = 1;
-	printk(KERN_WARNING "Misrouted IRQ fixup support enabled.\n");
-	printk(KERN_WARNING "This may impact system performance.\n");
+	pr_warn("Misrouted IRQ fixup support enabled.\n");
+	pr_warn("This may impact system performance.\n");
 
 	return 1;
 }
@@ -353,10 +354,8 @@ module_param(irqfixup, int, 0644);
 static int __init irqpoll_setup(char *str)
 {
 	irqfixup = 2;
-	printk(KERN_WARNING "Misrouted IRQ fixup and polling support "
-				"enabled\n");
-	printk(KERN_WARNING "This may significantly impact system "
-				"performance\n");
+	pr_warn("Misrouted IRQ fixup and polling support enabled\n");
+	pr_warn("This may significantly impact system performance\n");
 	return 1;
 }
 
-- 
1.8.2.1


