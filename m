Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3HMHRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:17:04 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:27930
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914Ab3HMHRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:17:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,867,1367964000"; 
   d="scan'208";a="23817381"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5 v2] drivers/gpio/gpio-omap.c: convert comma to semicolon
Date: Tue, 13 Aug 2013 09:16:56 +0200
Message-Id: <1376378216-18473-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace a comma between expression statements by a semicolon.  This changes
the semantics of the code, but given the current indentation appears to be
what is intended.

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
Not tested.  The first version did a different transformation to avoid
changing the semantics.  This one leaves the layout as it is, but changes
the semantics.

 drivers/gpio/gpio-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index dfeb3a3..9f19ec9 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1030,7 +1030,7 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
 	ct->chip.irq_set_type = gpio_irq_type;
 
 	if (bank->regs->wkup_en)
-		ct->chip.irq_set_wake = gpio_wake_enable,
+		ct->chip.irq_set_wake = gpio_wake_enable;
 
 	ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
 	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
