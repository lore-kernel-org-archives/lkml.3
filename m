Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaCEOY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40700 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaCEOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 003/131] irqchip: orion: clear bridge cause register on init
Date: Wed,  5 Mar 2014 14:22:07 +0000
Message-Id: <1394029455-23128-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

commit 7b119fd1bdc59a8060df5b659b9f7a70e0169fd6 upstream.

It is good practice to mask and clear pending irqs on init. We already
mask all irqs, so also clear the bridge irq cause register.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-orion.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index e51d400..4137c3d 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -180,8 +180,9 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
 
-	/* mask all interrupts */
+	/* mask and clear all interrupts */
 	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_MASK);
+	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_CAUSE);
 
 	irq_set_handler_data(irq, domain);
 	irq_set_chained_handler(irq, orion_bridge_irq_handler);
-- 
1.9.0

