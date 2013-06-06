Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3FFLXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:23:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30701 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab3FFLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:22:51 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH RESEND] irq: fix typos around irq_thread_check_affinity
Date: Thu, 6 Jun 2013 19:20:14 +0800
Message-ID: <1370517614-12084-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG CPU_MASK_OFFSTACK mentioned should be CPUMASK_OFFSTACK,
and fix a misspelling, chasnge -> change.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/manage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..78c6d0f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -727,7 +727,7 @@ out_unlock:
 
 #ifdef CONFIG_SMP
 /*
- * Check whether we need to chasnge the affinity of the interrupt thread.
+ * Check whether we need to change the affinity of the interrupt thread.
  */
 static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
@@ -750,7 +750,7 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	raw_spin_lock_irq(&desc->lock);
 	/*
 	 * This code is triggered unconditionally. Check the affinity
-	 * mask pointer. For CPU_MASK_OFFSTACK=n this is optimized out.
+	 * mask pointer. For CPUMASK_OFFSTACK=n this is optimized out.
 	 */
 	if (desc->irq_data.affinity)
 		cpumask_copy(mask, desc->irq_data.affinity);
-- 
1.8.2.2


