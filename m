Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaCKWoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:44:30 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41349 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaCKWlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:02 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 07/17] clocksource: timer-keystone: Delete unnecessary variable
Date: Tue, 11 Mar 2014 23:40:43 +0100
Message-Id: <1394577653-8615-7-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>

Commit 438e0bff5257 added the timer-keystone device driver but make use
of an unnecessary variable in the init function. This patch deletes this
variable.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/timer-keystone.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clocksource/timer-keystone.c b/drivers/clocksource/timer-keystone.c
index 86b08cd..0250354 100644
--- a/drivers/clocksource/timer-keystone.c
+++ b/drivers/clocksource/timer-keystone.c
@@ -164,7 +164,6 @@ static void __init keystone_timer_init(struct device_node *np)
 	unsigned long rate;
 	struct clk *clk;
 	int irq, error;
-	u32 tgcr;
 
 	irq  = irq_of_parse_and_map(np, 0);
 	if (irq == NO_IRQ) {
@@ -199,12 +198,10 @@ static void __init keystone_timer_init(struct device_node *np)
 	keystone_timer_barrier();
 
 	/* reset timer as 64-bit, no pre-scaler, plus features are disabled */
-	tgcr = 0;
 	keystone_timer_writel(0, TGCR);
 
 	/* unreset timer */
-	tgcr |= TGCR_TIM_UNRESET_MASK;
-	keystone_timer_writel(tgcr, TGCR);
+	keystone_timer_writel(TGCR_TIM_UNRESET_MASK, TGCR);
 
 	/* init counter to zero */
 	keystone_timer_writel(0, TIM12);
-- 
1.7.9.5

