Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982Ab3GaWdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:33:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44561 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760918Ab3GaWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:24 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 13/18] ARM: u300: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:12 -0700
Message-Id: <1375309877-16617-14-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-u300/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index b5db207..d23a1f0 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -341,7 +341,7 @@ static struct irqaction u300_timer_irq = {
  * stamp. (Inspired by OMAP implementation.)
  */
 
-static u32 notrace u300_read_sched_clock(void)
+static u64 notrace u300_read_sched_clock(void)
 {
 	return readl(u300_timer_base + U300_TIMER_APP_GPT2CC);
 }
@@ -380,7 +380,7 @@ static void __init u300_timer_init_of(struct device_node *np)
 	clk_prepare_enable(clk);
 	rate = clk_get_rate(clk);
 
-	setup_sched_clock(u300_read_sched_clock, 32, rate);
+	sched_clock_register(u300_read_sched_clock, 32, rate);
 
 	u300_delay_timer.read_current_timer = &u300_read_current_timer;
 	u300_delay_timer.freq = rate;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

