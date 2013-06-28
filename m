Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3F1DX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:23:27 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:50777 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3F1DX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:23:26 -0400
From: Fabio Estevam <festevam@gmail.com>
To: tglx@linutronix.de
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] irq: generic-chip: Export some irq_gc_ functions
Date: Fri, 28 Jun 2013 00:23:09 -0300
Message-Id: <1372389789-7048-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

When building imx_v6_v7_defconfig with imx-drm drivers selected as modules, we 
get the following build errors:

ERROR: "irq_gc_mask_clr_bit" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_gc_mask_set_bit" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_gc_ack_set_bit" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!

Export the required functions to avoid this problem.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 kernel/irq/generic-chip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index dd34b0a..00b0e11 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -62,6 +62,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL_GPL(irq_gc_mask_set_bit);
 
 /**
  * irq_gc_mask_clr_bit - Mask chip via clearing bit in mask register
@@ -81,6 +82,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL_GPL(irq_gc_mask_clr_bit);
 
 /**
  * irq_gc_unmask_enable_reg - Unmask chip via enable register
@@ -115,6 +117,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL_GPL(irq_gc_ack_set_bit);
 
 /**
  * irq_gc_ack_clr_bit - Ack pending interrupt via clearing bit
-- 
1.8.1.2

