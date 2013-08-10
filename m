Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528Ab3HJPls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:41:48 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:39129
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934434Ab3HJPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:40:31 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="23671830"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/gpio/gpio-omap.c: convert comma to semicolon
Date: Sat, 10 Aug 2013 17:40:21 +0200
Message-Id: <1376149225-3997-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace a comma between expression statements by a semicolon.

A simplified version of the semantic patch that performs this
transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression e1,e2,e;
type T;
identifier i;
@@

 e1
-,
+;
 e2;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I can't tell if the assignment to ct->regs.mask is really intended to be
under the if.  The proposed patch preserves the current semantics, but not
the current indentation.

 drivers/gpio/gpio-omap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index dfeb3a3..db80880 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1029,10 +1029,10 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
 	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
 	ct->chip.irq_set_type = gpio_irq_type;
 
-	if (bank->regs->wkup_en)
-		ct->chip.irq_set_wake = gpio_wake_enable,
-
-	ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
+	if (bank->regs->wkup_en) {
+		ct->chip.irq_set_wake = gpio_wake_enable;
+		ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
+	}
 	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
 			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
 }

