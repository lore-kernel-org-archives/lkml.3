Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3BGTJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:09:31 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37678 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3BGTJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:09:23 -0500
From: Rob Herring <robherring2@gmail.com>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 2/4] clocksource: bcm2835: use the device_node pointer passed to init
Date: Thu,  7 Feb 2013 13:09:02 -0600
Message-Id: <1360264144-20714-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

We've already matched the node, so use the node pointer passed in.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/bcm2835_timer.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index 50c68fe..766611d 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -95,23 +95,13 @@ static irqreturn_t bcm2835_time_interrupt(int irq, void *dev_id)
 	}
 }
 
-static struct of_device_id bcm2835_time_match[] __initconst = {
-	{ .compatible = "brcm,bcm2835-system-timer" },
-	{}
-};
-
-static void __init bcm2835_timer_init(void)
+static void __init bcm2835_timer_init(struct device_node *node)
 {
-	struct device_node *node;
 	void __iomem *base;
 	u32 freq;
 	int irq;
 	struct bcm2835_timer *timer;
 
-	node = of_find_matching_node(NULL, bcm2835_time_match);
-	if (!node)
-		panic("No bcm2835 timer node");
-
 	base = of_iomap(node, 0);
 	if (!base)
 		panic("Can't remap registers");
-- 
1.7.10.4

