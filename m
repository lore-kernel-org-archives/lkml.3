Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3KOX1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:27:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41305 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3KOX0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:36 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/17] ARM: u300: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:21 -0800
Message-Id: <1384557985-9414-14-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index 9a5f9fb..9724e4e 100644
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
@@ -379,7 +379,7 @@ static void __init u300_timer_init_of(struct device_node *np)
 	clk_prepare_enable(clk);
 	rate = clk_get_rate(clk);
 
-	setup_sched_clock(u300_read_sched_clock, 32, rate);
+	sched_clock_register(u300_read_sched_clock, 32, rate);
 
 	u300_delay_timer.read_current_timer = &u300_read_current_timer;
 	u300_delay_timer.freq = rate;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

