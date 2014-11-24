Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaKXClF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:41:05 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36378 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKXCk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:40:56 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 04/11] irqchip: bcm7120-l2: fix error handling of irq_of_parse_and_map
Date: Sun, 23 Nov 2014 18:40:39 -0800
Message-Id: <1416796846-28149-5-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@chromium.org>

Return value of irq_of_parse_and_map() is unsigned int, with 0
indicating failure, so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/irq-bcm7120-l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index e7c6155b23b8..8eec8e1201d9 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -102,9 +102,9 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 	unsigned int idx;
 
 	parent_irq = irq_of_parse_and_map(dn, irq);
-	if (parent_irq < 0) {
+	if (!parent_irq) {
 		pr_err("failed to map interrupt %d\n", irq);
-		return parent_irq;
+		return -EINVAL;
 	}
 
 	/* For multiple parent IRQs with multiple words, this looks like:
-- 
2.1.1

