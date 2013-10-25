Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3JYLUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:20:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54523 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466Ab3JYLUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:20:03 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/2] clockevent: sun4i: Fill the irq field in the clockevent structure
Date: Fri, 25 Oct 2013 12:16:10 +0100
Message-Id: <1382699771-4396-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock event structure irq field was not filled previously to the
interrupt we're using.

This was resulting in the timer not being used at all when using a
configuration with SMP enabled on a system with several CPUs, and with
the cpumask set to the cpu_possible_mask.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 2fb4695..a7f492e 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -188,6 +188,7 @@ static void __init sun4i_timer_init(struct device_node *node)
 	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
 
 	sun4i_clockevent.cpumask = cpumask_of(0);
+	sun4i_clockevent.irq = irq;
 
 	clockevents_config_and_register(&sun4i_clockevent, rate,
 					TIMER_SYNC_TICKS, 0xffffffff);
-- 
1.8.4

