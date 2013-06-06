Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab3FFLYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:24:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31460 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3FFLYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:24:31 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 2/7] irq: fix checkpatch error
Date: Thu, 6 Jun 2013 19:20:26 +0800
Message-ID: <1370517631-8684-3-git-send-email-wangkefeng.wang@huawei.com>
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

Change printk(KERN_WARNING ... to pr_warn(...
Fix ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/handle.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 131ca17..07a1c15 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -47,7 +47,7 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 	if (test_and_set_bit(IRQTF_WARNED, &action->thread_flags))
 		return;
 
-	printk(KERN_WARNING "IRQ %d device %s returned IRQ_WAKE_THREAD "
+	pr_warn("IRQ %d device %s returned IRQ_WAKE_THREAD "
 	       "but no thread function available.", irq, action->name);
 }
 
@@ -142,8 +142,9 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 		res = action->handler(irq, action->dev_id);
 		trace_irq_handler_exit(irq, action, res);
 
-		if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pF enabled interrupts\n",
-			      irq, action->handler))
+		if (WARN_ONCE(!irqs_disabled(),
+				"irq %u handler %pF enabled interrupts\n",
+				irq, action->handler))
 			local_irq_disable();
 
 		switch (res) {
-- 
1.8.2.1


