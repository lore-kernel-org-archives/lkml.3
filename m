Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3GDGLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:11:40 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32827 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3GDGLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:11:38 -0400
Message-ID: <1372918293.25529.2.camel@phoenix>
Subject: [PATCH] irqchip: vt8500: Staticize local symbols
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Olof Johansson <olof@lixom.net>, Tony Prisk <linux@prisktech.co.nz>,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Jul 2013 14:11:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is converted to use IRQCHIP_DECLARE and irqchip_init.
vt8500_handle_irq() and vt8500_irq_init() are only referenced in this file now,
make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/irqchip/irq-vt8500.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index d970595..1846e7d 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -178,7 +178,8 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
+static asmlinkage
+void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 {
 	u32 stat, i;
 	int irqnr, virq;
@@ -203,7 +204,8 @@ asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 	}
 }
 
-int __init vt8500_irq_init(struct device_node *node, struct device_node *parent)
+static int __init vt8500_irq_init(struct device_node *node,
+				  struct device_node *parent)
 {
 	int irq, i;
 	struct device_node *np = node;
-- 
1.8.1.2



