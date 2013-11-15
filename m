Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3KOX1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:27:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41229 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3KOX0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:32 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH 03/17] ARM: davinci: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:11 -0800
Message-Id: <1384557985-9414-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-davinci/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index 56c6eb5..24ad30f 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -285,7 +285,7 @@ static struct clocksource clocksource_davinci = {
 /*
  * Overwrite weak default sched_clock with something more precise
  */
-static u32 notrace davinci_read_sched_clock(void)
+static u64 notrace davinci_read_sched_clock(void)
 {
 	return timer32_read(&timers[TID_CLOCKSOURCE]);
 }
@@ -391,7 +391,7 @@ void __init davinci_timer_init(void)
 				    davinci_clock_tick_rate))
 		printk(err, clocksource_davinci.name);
 
-	setup_sched_clock(davinci_read_sched_clock, 32,
+	sched_clock_register(davinci_read_sched_clock, 32,
 			  davinci_clock_tick_rate);
 
 	/* setup clockevent */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

