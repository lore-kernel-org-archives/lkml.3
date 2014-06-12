Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbaFLMA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:00:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39463 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610AbaFLL4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:30 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
Date: Thu, 12 Jun 2014 17:23:16 +0530
Message-ID: <1402574007-13987-9-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

remove un-necessary space in function pointer.

Fixes checkpatch warning:
WARNING: Unnecessary space before function pointer arguments
 #37: FILE: drivers/irqchip/irq-crossbar.c:37:
 +	void (*write) (int, int);

WARNING: Missing a blank line after declarations
+	int *register_offsets;
+	void (*write)(int, int);

WARNING: Prefer kcalloc over kzalloc with multiply
+	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);

WARNING: Prefer kcalloc over kzalloc with multiply
+	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/irqchip/irq-crossbar.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 5da9d36..58790d4 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -34,7 +34,8 @@ struct crossbar_device {
 	uint *irq_map;
 	void __iomem *crossbar_base;
 	int *register_offsets;
-	void (*write) (int, int);
+
+	void (*write)(int, int);
 };
 
 /**
@@ -150,7 +151,7 @@ static int __init crossbar_of_init(struct device_node *node,
 		goto err1;
 
 	of_property_read_u32(node, "ti,max-irqs", &max);
-	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
+	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->irq_map)
 		goto err2;
 
@@ -176,7 +177,7 @@ static int __init crossbar_of_init(struct device_node *node,
 		}
 	}
 
-	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
+	cb->register_offsets = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->register_offsets)
 		goto err3;
 
-- 
1.7.9.5

