Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaAQBiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:38:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43916 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaAQBiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:38:08 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] clocksource: timer-sun5i: Switch to sched_clock_register()
Date: Thu, 16 Jan 2014 17:38:06 -0800
Message-Id: <1389922686-6249-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface supports 64 bits since 3.13-rc1.
Upgrade to the 64 bit function to allow us to remove the 32 bit
registration interface.

Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Cc'in Ingo because this is simple enough to probably just apply to timers/core

 drivers/clocksource/timer-sun5i.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index bddc52233d2a..deebcd6469fc 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -136,7 +136,7 @@ static struct irqaction sun5i_timer_irq = {
 	.dev_id = &sun5i_clockevent,
 };
 
-static u32 sun5i_timer_sched_read(void)
+static u64 sun5i_timer_sched_read(void)
 {
 	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
 }
@@ -166,7 +166,7 @@ static void __init sun5i_timer_init(struct device_node *node)
 	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
 	       timer_base + TIMER_CTL_REG(1));
 
-	setup_sched_clock(sun5i_timer_sched_read, 32, rate);
+	sched_clock_register(sun5i_timer_sched_read, 32, rate);
 	clocksource_mmio_init(timer_base + TIMER_CNTVAL_LO_REG(1), node->name,
 			      rate, 340, 32, clocksource_mmio_readl_down);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

