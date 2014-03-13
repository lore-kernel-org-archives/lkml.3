Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaCMSEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:04:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbaCMSEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:04:34 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 3/4] irqchip: sun4i: Fix a comment about mask register initialization
Date: Thu, 13 Mar 2014 19:03:53 +0100
Message-Id: <1394733834-26839-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment was claiming that we were masking all irqs, while the code actually
*un*masks all of them.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/irqchip/irq-sun4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 5c25048..8a2fbee 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -109,7 +109,7 @@ static int __init sun4i_of_init(struct device_node *node,
 	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(1));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(2));
 
-	/* Mask all the interrupts */
+	/* Unmask all the interrupts, ENABLE_REG(x) is used for masking */
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(0));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(1));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(2));
-- 
1.9.0

