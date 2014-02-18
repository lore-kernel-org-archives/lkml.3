Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaBRS3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:29:38 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52056 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaBRS3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:29:37 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] clocksource: timer-keystone: Delete unnecessary variable
Date: Tue, 18 Feb 2014 19:29:28 +0100
Message-Id: <1392748168-17080-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <52FA1E59.1000307@linaro.org>
References: <52FA1E59.1000307@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 438e0bff5257 added the timer-keystone device driver but make use
of an unnecessary variable in the init function.
This patch delets this variable.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/clocksource/timer-keystone.c | 5 +----
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
1.8.1.2

