Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaASM1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:27:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaASM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:27:41 -0500
Date: Sun, 19 Jan 2014 04:27:25 -0800
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-00e2bcd6d35f59fce7fa0e76e24d08f74c6a8506@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sboyd@codeaurora.org, daniel.lezcano@linaro.org,
        maxime.ripard@free-electrons.com
In-Reply-To: <1389922686-6249-1-git-send-email-sboyd@codeaurora.org>
References: <1389922686-6249-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Timer-sun5i:
  Switch to sched_clock_register()
Git-Commit-ID: 00e2bcd6d35f59fce7fa0e76e24d08f74c6a8506
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:27:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00e2bcd6d35f59fce7fa0e76e24d08f74c6a8506
Gitweb:     http://git.kernel.org/tip/00e2bcd6d35f59fce7fa0e76e24d08f74c6a8506
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Thu, 16 Jan 2014 17:38:06 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 19 Jan 2014 13:23:23 +0100

clocksource: Timer-sun5i: Switch to sched_clock_register()

The 32-bit sched_clock() interface supports 64 bits since
3.13-rc1. Upgrade to the 64-bit function to allow us to remove
the 32-bit registration interface.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1389922686-6249-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/clocksource/timer-sun5i.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index bddc522..deebcd6 100644
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
 
