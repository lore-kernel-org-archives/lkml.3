Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3FHNKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 09:10:43 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47603 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3FHNKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:10:42 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] irqchip: Return -EPERM for reserved IRQs
Date: Sat,  8 Jun 2013 14:04:46 +0100
Message-Id: <1370696686-1666-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irqdomain core will report a log message for any attempted map call
that fails unless the error code is -EPERM. This patch changes the
Versatile irq controller drivers to use -EPERM because it is normal for
a subset of the IRQ inputs to be marked as reserved on the various
Versatile platforms.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/irqchip/irq-versatile-fpga.c | 2 +-
 drivers/irqchip/irq-vic.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-versatile-fpga.c b/drivers/irqchip/irq-versatile-fpga.c
index 065b7a3..47a52ab 100644
--- a/drivers/irqchip/irq-versatile-fpga.c
+++ b/drivers/irqchip/irq-versatile-fpga.c
@@ -119,7 +119,7 @@ static int fpga_irqdomain_map(struct irq_domain *d, unsigned int irq,
 
 	/* Skip invalid IRQs, only register handlers for the real ones */
 	if (!(f->valid & BIT(hwirq)))
-		return -ENOTSUPP;
+		return -EPERM;
 	irq_set_chip_data(irq, f);
 	irq_set_chip_and_handler(irq, &f->chip,
 				handle_level_irq);
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 884d11c..2bbb004 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -197,7 +197,7 @@ static int vic_irqdomain_map(struct irq_domain *d, unsigned int irq,
 
 	/* Skip invalid IRQs, only register handlers for the real ones */
 	if (!(v->valid_sources & (1 << hwirq)))
-		return -ENOTSUPP;
+		return -EPERM;
 	irq_set_chip_and_handler(irq, &vic_chip, handle_level_irq);
 	irq_set_chip_data(irq, v->base);
 	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-- 
1.8.1.2

