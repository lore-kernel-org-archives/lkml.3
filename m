Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3FFLWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:22:07 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30489 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3FFLWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:22:05 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 7/7] irq: fix all checkpatch errors and warnings
Date: Thu, 6 Jun 2013 19:20:31 +0800
Message-ID: <1370517631-8684-8-git-send-email-wangkefeng.wang@huawei.com>
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

Fix following issue, and use pr_foo().
WARNING: line over 80 characters
ERROR: spaces required around that '>=' (ctx:WxV)

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/irqdesc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..9ba01f5 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -7,6 +7,9 @@
  * Detailed information is available in Documentation/DocBook/genericirq
  *
  */
+
+#define pr_fmt(fmt)  "NR_IRQS: " fmt
+
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/export.h>
@@ -219,7 +222,7 @@ int __init early_irq_init(void)
 
 	/* Let arch update nr_irqs and return the nr of preallocated irqs */
 	initcnt = arch_probe_nr_irqs();
-	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
+	pr_info("%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
 
 	if (WARN_ON(nr_irqs > IRQ_BITMAP_BITS))
 		nr_irqs = IRQ_BITMAP_BITS;
@@ -255,7 +258,7 @@ int __init early_irq_init(void)
 
 	init_irq_default_affinity();
 
-	printk(KERN_INFO "NR_IRQS:%d\n", NR_IRQS);
+	pr_info("%d\n", NR_IRQS);
 
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
@@ -369,7 +372,7 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
 					   from, cnt, 0);
 	ret = -EEXIST;
-	if (irq >=0 && start != irq)
+	if (irq >= 0 && start != irq)
 		goto err;
 
 	if (start + cnt > nr_irqs) {
@@ -404,7 +407,8 @@ int irq_reserve_irqs(unsigned int from, unsigned int cnt)
 		return -EINVAL;
 
 	mutex_lock(&sparse_irq_lock);
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
+	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs,
+						from, cnt, 0);
 	if (start == from)
 		bitmap_set(allocated_irqs, start, cnt);
 	else
@@ -465,7 +469,8 @@ int irq_set_percpu_devid(unsigned int irq)
 	if (desc->percpu_enabled)
 		return -EINVAL;
 
-	desc->percpu_enabled = kzalloc(sizeof(*desc->percpu_enabled), GFP_KERNEL);
+	desc->percpu_enabled = kzalloc(sizeof(*desc->percpu_enabled),
+					GFP_KERNEL);
 
 	if (!desc->percpu_enabled)
 		return -ENOMEM;
-- 
1.8.2.1


