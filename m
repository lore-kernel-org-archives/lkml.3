Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaEMAaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:30:20 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49012 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaEMAaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:30:16 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/7] irqchip: s3c24xx: fix function type for IRQCHIP_OF_DECLARE
Date: Mon, 12 May 2014 19:29:51 -0500
Message-Id: <1399940993-1773-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Adding function type checking to IRQCHIP_OF_DECLARE found a type mismatch
with s3c2410_init_intc_of and s3c2416_init_intc_of. The function only takes
the 1st 2 parameters.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-s3c24xx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-s3c24xx.c b/drivers/irqchip/irq-s3c24xx.c
index bbcc944..78a6acc 100644
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@ -1323,8 +1323,7 @@ static struct s3c24xx_irq_of_ctrl s3c2410_ctrl[] = {
 };
 
 int __init s3c2410_init_intc_of(struct device_node *np,
-			struct device_node *interrupt_parent,
-			struct s3c24xx_irq_of_ctrl *ctrl, int num_ctrl)
+			struct device_node *interrupt_parent)
 {
 	return s3c_init_intc_of(np, interrupt_parent,
 				s3c2410_ctrl, ARRAY_SIZE(s3c2410_ctrl));
@@ -1346,8 +1345,7 @@ static struct s3c24xx_irq_of_ctrl s3c2416_ctrl[] = {
 };
 
 int __init s3c2416_init_intc_of(struct device_node *np,
-			struct device_node *interrupt_parent,
-			struct s3c24xx_irq_of_ctrl *ctrl, int num_ctrl)
+			struct device_node *interrupt_parent)
 {
 	return s3c_init_intc_of(np, interrupt_parent,
 				s3c2416_ctrl, ARRAY_SIZE(s3c2416_ctrl));
-- 
1.9.1

