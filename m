Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3GEHlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:41:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40676 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3GEHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:41:14 -0400
Message-ID: <1373010070.14756.2.camel@phoenix>
Subject: [PATCH] irqchip: sun4i: Staticize sun4i_irq_ack()
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 05 Jul 2013 15:41:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sun4i_irq_ack() is only referenced in this file, so make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/irqchip/irq-sun4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index b66d4ae..a5438d8 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -38,7 +38,7 @@ static struct irq_domain *sun4i_irq_domain;
 
 static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
-void sun4i_irq_ack(struct irq_data *irqd)
+static void sun4i_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
 	unsigned int irq_off = irq % 32;
-- 
1.8.1.2



