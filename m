Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbbAZJzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:55:51 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33609 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752749AbbAZJzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:55:48 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 3/5] clocksource: sun5i: Remove sched_clock
Date: Mon, 26 Jan 2015 10:50:54 +0100
Message-Id: <1422265856-27631-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not possible to remove a sched_clock once it has been added, nor is it
possible to change its rate.

Since we will need to support a rate change, and that we have other
sched_clocks in the system anyway, remove it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/timer-sun5i.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index 2f70ed528174..295bb5e1010c 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -130,11 +130,6 @@ static irqreturn_t sun5i_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static u64 sun5i_timer_sched_read(void)
-{
-	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
-}
-
 static void __init sun5i_timer_init(struct device_node *node)
 {
 	struct reset_control *rstc;
@@ -166,7 +161,6 @@ static void __init sun5i_timer_init(struct device_node *node)
 	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
 	       timer_base + TIMER_CTL_REG(1));
 
-	sched_clock_register(sun5i_timer_sched_read, 32, rate);
 	clocksource_mmio_init(timer_base + TIMER_CNTVAL_LO_REG(1), node->name,
 			      rate, 340, 32, clocksource_mmio_readl_down);
 
-- 
2.2.2

