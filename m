Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3BGTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:09:29 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47237 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3BGTJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:09:26 -0500
From: Rob Herring <robherring2@gmail.com>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 3/4] clocksource: vt8500: use the device_node pointer passed to init
Date: Thu,  7 Feb 2013 13:09:03 -0600
Message-Id: <1360264144-20714-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

We've already matched the node, so use the node pointer passed in.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/vt8500_timer.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
index 8efc86b..2422552 100644
--- a/drivers/clocksource/vt8500_timer.c
+++ b/drivers/clocksource/vt8500_timer.c
@@ -129,22 +129,10 @@ static struct irqaction irq = {
 	.dev_id  = &clockevent,
 };
 
-static struct of_device_id vt8500_timer_ids[] = {
-	{ .compatible = "via,vt8500-timer" },
-	{ }
-};
-
-static void __init vt8500_timer_init(void)
+static void __init vt8500_timer_init(struct device_node *np)
 {
-	struct device_node *np;
 	int timer_irq;
 
-	np = of_find_matching_node(NULL, vt8500_timer_ids);
-	if (!np) {
-		pr_err("%s: Timer description missing from Device Tree\n",
-								__func__);
-		return;
-	}
 	regbase = of_iomap(np, 0);
 	if (!regbase) {
 		pr_err("%s: Missing iobase description in Device Tree\n",
-- 
1.7.10.4

