Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3JYLUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:20:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54532 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751523Ab3JYLUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:20:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] clocksource: sun4i: change CPU mask to cpu_possible_mask
Date: Fri, 25 Oct 2013 12:16:11 +0100
Message-Id: <1382699771-4396-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt for the timer is a shared processor interrupt, so any CPU
found in the system can handle it. Switch to our cpumask to
cpu_possible_mask instead of cpumask_of(0).

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index a7f492e..6a76b4e 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -187,7 +187,7 @@ static void __init sun4i_timer_init(struct device_node *node)
 	val = readl(timer_base + TIMER_IRQ_EN_REG);
 	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
 
-	sun4i_clockevent.cpumask = cpumask_of(0);
+	sun4i_clockevent.cpumask = cpu_possible_mask;
 	sun4i_clockevent.irq = irq;
 
 	clockevents_config_and_register(&sun4i_clockevent, rate,
-- 
1.8.4

