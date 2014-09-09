Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaIIQIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:08:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33464 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbaIIQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:08:29 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: arizona: Use handle_simple_irq for IRQ dispatch chip
Date: Tue,  9 Sep 2014 17:00:09 +0100
Message-Id: <1410278409-28216-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use a dummy IRQ chip to dispatch interrupts to the two seperate IRQ
domains on the Arizona devices. This is just a simple software IRQ chip
and thus the current handle_edge_irq is unnecessary for its needs.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 5e2f450..3a3fe7c 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -172,7 +172,7 @@ static int arizona_irq_map(struct irq_domain *h, unsigned int virq,
 	struct regmap_irq_chip_data *data = h->host_data;
 
 	irq_set_chip_data(virq, data);
-	irq_set_chip_and_handler(virq, &arizona_irq_chip, handle_edge_irq);
+	irq_set_chip_and_handler(virq, &arizona_irq_chip, handle_simple_irq);
 	irq_set_nested_thread(virq, 1);
 
 	/* ARM needs us to explicitly flag the IRQ as valid
-- 
1.7.2.5

