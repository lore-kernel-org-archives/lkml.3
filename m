Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab3FFLWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:22:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30702 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab3FFLWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:22:52 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 3/7] irq: fix checkpatch error
Date: Thu, 6 Jun 2013 19:20:27 +0800
Message-ID: <1370517631-8684-4-git-send-email-wangkefeng.wang@huawei.com>
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

ERROR: space required before the open parenthesis '('
WARNING: Prefer pr_warn(... to pr_warning(...
Just fix above 2 issue.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/irqdomain.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 5a83dde..fd47f33 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -419,7 +419,7 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 		irq_data->hwirq = 0;
 
 		/* Clear reverse map */
-		switch(domain->revmap_type) {
+		switch (domain->revmap_type) {
 		case IRQ_DOMAIN_MAP_LINEAR:
 			if (hwirq < domain->revmap_data.linear.size)
 				domain->revmap_data.linear.revmap[hwirq] = 0;
@@ -570,7 +570,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	if (domain == NULL)
 		domain = irq_default_domain;
 	if (domain == NULL) {
-		pr_warning("irq_create_mapping called for"
+		pr_warn("irq_create_mapping called for"
 			   " NULL domain, hwirq=%lx\n", hwirq);
 		WARN_ON(1);
 		return 0;
@@ -672,7 +672,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 		if (intsize > 0)
 			return intspec[0];
 #endif
-		pr_warning("no irq domain found for %s !\n",
+		pr_warn("no irq domain found for %s !\n",
 			   of_node_full_name(controller));
 		return 0;
 	}
-- 
1.8.2.1


