Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3FFLWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:22:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50612 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab3FFLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:22:30 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 4/7] irq: fix all checkpatch errors and warnings
Date: Thu, 6 Jun 2013 19:20:28 +0800
Message-ID: <1370517631-8684-5-git-send-email-wangkefeng.wang@huawei.com>
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

Fixes following errors and warnings:
WARNING: line over 80 characters
ERROR: spaces required around that '=' (ctx:WxV)
WARNING: Avoid unnecessary line continuations
WARNING: Prefer pr_warn(... to pr_warning(...
WARNING: suspect code indent for conditional statements (8, 12)

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/manage.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..0d6446e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -211,7 +211,8 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags,
+					IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
@@ -372,7 +373,8 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 static int __disable_irq_nosync(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
+					IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
@@ -464,7 +466,8 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 void enable_irq(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
+					IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return;
@@ -507,7 +510,8 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 int irq_set_irq_wake(unsigned int irq, unsigned int on)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
+					IRQ_GET_DESC_CHECK_GLOBAL);
 	int ret = 0;
 
 	if (!desc)
@@ -557,7 +561,7 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 	if (irq_settings_can_request(desc)) {
 		if (desc->action)
 			if (irqflags & desc->action->flags & IRQF_SHARED)
-				canrequest =1;
+				canrequest = 1;
 	}
 	irq_put_desc_unlock(desc, flags);
 	return canrequest;
@@ -1102,7 +1106,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 				goto out_mask;
 		}
 
-		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
+		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED |
 				  IRQS_ONESHOT | IRQS_WAITING);
 		irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 
@@ -1135,7 +1139,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 		if (nmsk != omsk)
 			/* hope the handler works with current  trigger mode */
-			pr_warning("irq %d uses trigger mode %u; requested %u\n",
+			pr_warn("irq %d uses trigger mode %u; requested %u\n",
 				   irq, nmsk, omsk);
 	}
 
@@ -1314,7 +1318,7 @@ void remove_irq(unsigned int irq, struct irqaction *act)
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc && !WARN_ON(irq_settings_is_per_cpu_devid(desc)))
-	    __free_irq(irq, act->dev_id);
+		__free_irq(irq, act->dev_id);
 }
 EXPORT_SYMBOL_GPL(remove_irq);
 
@@ -1504,7 +1508,8 @@ void enable_percpu_irq(unsigned int irq, unsigned int type)
 {
 	unsigned int cpu = smp_processor_id();
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_PERCPU);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags,
+					IRQ_GET_DESC_CHECK_PERCPU);
 
 	if (!desc)
 		return;
@@ -1531,7 +1536,8 @@ void disable_percpu_irq(unsigned int irq)
 {
 	unsigned int cpu = smp_processor_id();
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_PERCPU);
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags,
+					IRQ_GET_DESC_CHECK_PERCPU);
 
 	if (!desc)
 		return;
@@ -1544,7 +1550,8 @@ EXPORT_SYMBOL_GPL(disable_percpu_irq);
 /*
  * Internal function to unregister a percpu irqaction.
  */
-static struct irqaction *__free_percpu_irq(unsigned int irq, void __percpu *dev_id)
+static struct irqaction *
+__free_percpu_irq(unsigned int irq, void __percpu *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action;
@@ -1596,7 +1603,7 @@ void remove_percpu_irq(unsigned int irq, struct irqaction *act)
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc && irq_settings_is_per_cpu_devid(desc))
-	    __free_percpu_irq(irq, act->percpu_dev_id);
+		__free_percpu_irq(irq, act->percpu_dev_id);
 }
 
 /**
-- 
1.8.2.1


