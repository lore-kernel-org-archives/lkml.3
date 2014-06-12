Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbaFLL5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:57:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58248 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbaFLL4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:51 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 13/19] irqchip: crossbar: change the goto naming
Date: Thu, 12 Jun 2014 17:23:21 +0530
Message-ID: <1402574007-13987-14-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Using err1,2,3,4 etc makes it hard to ensure a new exit path in the
middle will not result in spurious changes, so rename the error paths
as per the function it does.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/irqchip/irq-crossbar.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 524e6e9..cf0d79f 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -152,17 +152,17 @@ static int __init crossbar_of_init(struct device_node *node,
 
 	cb->crossbar_base = of_iomap(node, 0);
 	if (!cb->crossbar_base)
-		goto err1;
+		goto err_cb;
 
 	of_property_read_u32(node, "ti,max-irqs", &max);
 	if (!max) {
 		pr_err("missing 'ti,max-irqs' property\n");
 		ret = -EINVAL;
-		goto err2;
+		goto err_base;
 	}
 	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->irq_map)
-		goto err2;
+		goto err_base;
 
 	cb->int_max = max;
 
@@ -181,7 +181,7 @@ static int __init crossbar_of_init(struct device_node *node,
 			if (entry > max) {
 				pr_err("Invalid reserved entry\n");
 				ret = -EINVAL;
-				goto err3;
+				goto err_irq_map;
 			}
 			cb->irq_map[entry] = IRQ_RESERVED;
 		}
@@ -189,7 +189,7 @@ static int __init crossbar_of_init(struct device_node *node,
 
 	cb->register_offsets = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->register_offsets)
-		goto err3;
+		goto err_irq_map;
 
 	of_property_read_u32(node, "ti,reg-size", &size);
 
@@ -206,7 +206,7 @@ static int __init crossbar_of_init(struct device_node *node,
 	default:
 		pr_err("Invalid reg-size property\n");
 		ret = -EINVAL;
-		goto err4;
+		goto err_reg_offset;
 		break;
 	}
 
@@ -234,7 +234,7 @@ static int __init crossbar_of_init(struct device_node *node,
 			if (entry > max) {
 				pr_err("Invalid skip entry\n");
 				ret = -EINVAL;
-				goto err4;
+				goto err_reg_offset;
 			}
 			cb->irq_map[entry] = IRQ_SKIP;
 		}
@@ -251,13 +251,13 @@ static int __init crossbar_of_init(struct device_node *node,
 	register_routable_domain_ops(&routable_irq_domain_ops);
 	return 0;
 
-err4:
+err_reg_offset:
 	kfree(cb->register_offsets);
-err3:
+err_irq_map:
 	kfree(cb->irq_map);
-err2:
+err_base:
 	iounmap(cb->crossbar_base);
-err1:
+err_cb:
 	kfree(cb);
 	return ret;
 }
-- 
1.7.9.5

