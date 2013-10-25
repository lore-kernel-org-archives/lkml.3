Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3JYNKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:10:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54914 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753495Ab3JYNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:10:03 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org, kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 1/5] clocksource: sun4i: Increase a bit the clock event and sources rating
Date: Fri, 25 Oct 2013 14:07:39 +0100
Message-Id: <1382706463-3892-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to keep this driver as the default provider of the clock events
and source, yet some other driver might fit in the "desired" category of
ratings. Hence, we need to increase a bit the rating so that we can have
more flexibility in the ratings we choose.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/clocksource/sun4i_timer.c | 4 ++--
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
1.8.4

