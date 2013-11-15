Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3KOXtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:49:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43469 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3KOXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:48:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 4/4] clocksource: orion: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:48:35 -0800
Message-Id: <1384559315-18699-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/time-orion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index 9c7f018..2006622 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -53,7 +53,7 @@ EXPORT_SYMBOL(orion_timer_ctrl_clrset);
 /*
  * Free-running clocksource handling.
  */
-static u32 notrace orion_read_sched_clock(void)
+static u64 notrace orion_read_sched_clock(void)
 {
 	return ~readl(timer_base + TIMER0_VAL);
 }
@@ -135,7 +135,7 @@ static void __init orion_timer_init(struct device_node *np)
 	clocksource_mmio_init(timer_base + TIMER0_VAL, "orion_clocksource",
 			      clk_get_rate(clk), 300, 32,
 			      clocksource_mmio_readl_down);
-	setup_sched_clock(orion_read_sched_clock, 32, clk_get_rate(clk));
+	sched_clock_register(orion_read_sched_clock, 32, clk_get_rate(clk));
 
 	/* setup timer1 as clockevent timer */
 	if (setup_irq(irq, &orion_clkevt_irq))
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

