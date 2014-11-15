Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaKOL1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 06:27:36 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56476 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaKOL1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 06:27:35 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: Add IRQ 0 to domain debug file
Date: Sat, 15 Nov 2014 14:27:20 +0300
Message-Id: <1416050840-24721-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently irq_domain_mapping debugfs file dumps IRQ information starting
from IRQ 1. IRQ 0 is missing from that file. Add it to have the complete
picture of IRQ/domains mappings.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 kernel/irq/irqdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6534ff6..0e0c7a8 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -585,7 +585,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
 		      "chip name", (int)(2 * sizeof(void *) + 2), "chip data",
 		      "active", "type", "domain");
 
-	for (i = 1; i < nr_irqs; i++) {
+	for (i = 0; i < nr_irqs; i++) {
 		desc = irq_to_desc(i);
 		if (!desc)
 			continue;
-- 
2.1.1

