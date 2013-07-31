Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995Ab3GaWdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:33:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44525 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760910Ab3GaWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:23 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 10/18] ARM: OMAP2+: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:09 -0700
Message-Id: <1375309877-16617-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-omap2/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index b37e1fc..54b3cbe 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -369,7 +369,7 @@ static struct clocksource clocksource_gpt = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-static u32 notrace dmtimer_read_sched_clock(void)
+static u64 notrace dmtimer_read_sched_clock(void)
 {
 	if (clksrc.reserved)
 		return __omap_dm_timer_read_counter(&clksrc,
@@ -461,7 +461,7 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 	__omap_dm_timer_load_start(&clksrc,
 				   OMAP_TIMER_CTRL_ST | OMAP_TIMER_CTRL_AR, 0,
 				   OMAP_TIMER_NONPOSTED);
-	setup_sched_clock(dmtimer_read_sched_clock, 32, clksrc.rate);
+	sched_clock_register(dmtimer_read_sched_clock, 32, clksrc.rate);
 
 	if (clocksource_register_hz(&clocksource_gpt, clksrc.rate))
 		pr_err("Could not register clocksource %s\n",
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

