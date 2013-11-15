Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3KOXbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:31:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42293 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3KOXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:31:44 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] xtensa: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:31:43 -0800
Message-Id: <1384558303-10731-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade
to the 64 bit function to allow us to remove the 32 bit
registration interface.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Patch is based on Linus' tip. Not event compile tested.

 arch/xtensa/kernel/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 9af3dd8..415c3f6 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -36,7 +36,7 @@ static cycle_t ccount_read(struct clocksource *cs)
 	return (cycle_t)get_ccount();
 }
 
-static u32 notrace ccount_sched_clock_read(void)
+static u64 notrace ccount_sched_clock_read(void)
 {
 	return get_ccount();
 }
@@ -141,7 +141,7 @@ void __init time_init(void)
 	setup_irq(ccount_timer.evt.irq, &timer_irqaction);
 	ccount_timer.irq_enabled = 1;
 
-	setup_sched_clock(ccount_sched_clock_read, 32, ccount_freq);
+	sched_clock_register(ccount_sched_clock_read, 32, ccount_freq);
 }
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

