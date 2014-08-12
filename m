Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHLOAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:00:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51066 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbaHLOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:00:08 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mfd: arizona: Add additional dummy IRQ callbacks
Date: Tue, 12 Aug 2014 14:51:20 +0100
Message-Id: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use a dummy IRQ chip to dispatch interrupts to the two seperate IRQ
domains on the Arizona devices. Currently only the enable and disable
callbacks are defined however, there are some situations where additional
callbacks will be used from the IRQ core, which currently results in an
NULL pointer deference. Add handlers for more of the IRQ callbacks and
combine these into a single function since they are all identical.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index d420dbc..71e8f06 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -144,18 +144,17 @@ static irqreturn_t arizona_irq_thread(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void arizona_irq_enable(struct irq_data *data)
-{
-}
-
-static void arizona_irq_disable(struct irq_data *data)
+static void arizona_irq_dummy(struct irq_data *data)
 {
 }
 
 static struct irq_chip arizona_irq_chip = {
 	.name			= "arizona",
-	.irq_disable		= arizona_irq_disable,
-	.irq_enable		= arizona_irq_enable,
+	.irq_disable		= arizona_irq_dummy,
+	.irq_enable		= arizona_irq_dummy,
+	.irq_ack		= arizona_irq_dummy,
+	.irq_mask		= arizona_irq_dummy,
+	.irq_unmask		= arizona_irq_dummy,
 };
 
 static int arizona_irq_map(struct irq_domain *h, unsigned int virq,
-- 
1.7.2.5

