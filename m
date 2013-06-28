Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3F1K7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:59:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3F1K7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:59:01 -0400
Date: Fri, 28 Jun 2013 03:58:44 -0700
From: tip-bot for Fabio Estevam <tipbot@zytor.com>
Message-ID: <tip-d55f0cc4c9a70e3105f1e813ab5f221a65ac2ec3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fabio.estevam@freescale.com, tglx@linutronix.de, festevam@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fabio.estevam@freescale.com, tglx@linutronix.de, festevam@gmail.com
In-Reply-To: <1372389789-7048-1-git-send-email-festevam@gmail.com>
References: <1372389789-7048-1-git-send-email-festevam@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: generic-chip:
  Export some irq_gc_ functions
Git-Commit-ID: d55f0cc4c9a70e3105f1e813ab5f221a65ac2ec3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 03:58:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d55f0cc4c9a70e3105f1e813ab5f221a65ac2ec3
Gitweb:     http://git.kernel.org/tip/d55f0cc4c9a70e3105f1e813ab5f221a65ac2ec3
Author:     Fabio Estevam <festevam@gmail.com>
AuthorDate: Fri, 28 Jun 2013 00:23:09 -0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 12:56:04 +0200

genirq: generic-chip: Export some irq_gc_ functions

When building imx_v6_v7_defconfig with imx-drm drivers selected as
modules, we get the following build errors:

ERROR: "irq_gc_mask_clr_bit" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_gc_mask_set_bit" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!
ERROR: "irq_gc_ack_set_bit" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!

Export the required functions to avoid this problem.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: shawn.guo@linaro.org
Cc: kernel@pengutronix.de
Link: http://lkml.kernel.org/r/1372389789-7048-1-git-send-email-festevam@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index a746a8f..76ea748 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -62,6 +62,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL_GPL(irq_gc_mask_set_bit);
 
 /**
  * irq_gc_mask_set_mask_bit - Mask chip via clearing bit in mask register
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
