Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3L3KTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:19:51 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:32995 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3L3KTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:19:47 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de
Cc: axel.lin@ingics.com, ezequiel.garcia@free-electrons.com,
        jg1.han@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        michael.opdenacker@free-electrons.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/20] clocksource: sun4i: Increase a bit the clock event and sources rating
Date: Mon, 30 Dec 2013 11:19:22 +0100
Message-Id: <1388398779-11222-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
References: <52C1479E.80808@linaro.org>
 <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

We want to keep this driver as the default provider of the clock events
and source, yet some other driver might fit in the "desired" category of
ratings. Hence, we need to increase a bit the rating so that we can have
more flexibility in the ratings we choose.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Emilio López <emilio@elopez.com.ar>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/sun4i_timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 6a76b4e..d7a1a1a 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -114,7 +114,7 @@ static int sun4i_clkevt_next_event(unsigned long evt,
 
 static struct clock_event_device sun4i_clockevent = {
 	.name = "sun4i_tick",
-	.rating = 300,
+	.rating = 350,
 	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode = sun4i_clkevt_mode,
 	.set_next_event = sun4i_clkevt_next_event,
@@ -172,7 +172,7 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	setup_sched_clock(sun4i_timer_sched_read, 32, rate);
 	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
-			      rate, 300, 32, clocksource_mmio_readl_down);
+			      rate, 350, 32, clocksource_mmio_readl_down);
 
 	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
 
-- 
1.7.9.5

