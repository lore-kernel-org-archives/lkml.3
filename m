Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3L3KWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:22:53 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:43778 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab3L3KUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:20:01 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de
Cc: axel.lin@ingics.com, ezequiel.garcia@free-electrons.com,
        jg1.han@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        michael.opdenacker@free-electrons.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/20] clocksource: orion: Switch to sched_clock_register()
Date: Mon, 30 Dec 2013 11:19:30 +0100
Message-Id: <1388398779-11222-11-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
References: <52C1479E.80808@linaro.org>
 <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/time-orion.c |    4 ++--
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
1.7.9.5

