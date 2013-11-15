Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3KOX2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:28:31 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41309 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3KOX0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:36 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/17] ARM: iop: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:22 -0800
Message-Id: <1384557985-9414-15-git-send-email-sboyd@codeaurora.org>
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
---
 arch/arm/plat-iop/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 29606bd7..d70b733 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -54,7 +54,7 @@ static struct clocksource iop_clocksource = {
 /*
  * IOP sched_clock() implementation via its clocksource.
  */
-static u32 notrace iop_read_sched_clock(void)
+static u64 notrace iop_read_sched_clock(void)
 {
 	return 0xffffffffu - read_tcr1();
 }
@@ -142,7 +142,7 @@ void __init iop_init_time(unsigned long tick_rate)
 {
 	u32 timer_ctl;
 
-	setup_sched_clock(iop_read_sched_clock, 32, tick_rate);
+	sched_clock_register(iop_read_sched_clock, 32, tick_rate);
 
 	ticks_per_jiffy = DIV_ROUND_CLOSEST(tick_rate, HZ);
 	iop_tick_rate = tick_rate;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

