Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021Ab3GaWeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:34:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44576 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760900Ab3GaWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:23 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 09/18] ARM: OMAP1: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:08 -0700
Message-Id: <1375309877-16617-10-git-send-email-sboyd@codeaurora.org>
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
 arch/arm/mach-omap1/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 80603d2..6ded515 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -181,7 +181,7 @@ static __init void omap_init_mpu_timer(unsigned long rate)
  * ---------------------------------------------------------------------------
  */
 
-static u32 notrace omap_mpu_read_sched_clock(void)
+static u64 notrace omap_mpu_read_sched_clock(void)
 {
 	return ~omap_mpu_timer_read(1);
 }
@@ -193,7 +193,7 @@ static void __init omap_init_clocksource(unsigned long rate)
 			"%s: can't register clocksource!\n";
 
 	omap_mpu_timer_start(1, ~0, 1);
-	setup_sched_clock(omap_mpu_read_sched_clock, 32, rate);
+	sched_clock_register(omap_mpu_read_sched_clock, 32, rate);
 
 	if (clocksource_mmio_init(&timer->read_tim, "mpu_timer2", rate,
 			300, 32, clocksource_mmio_readl_down))
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

