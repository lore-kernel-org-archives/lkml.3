Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3KOX3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:29:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41255 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3KOX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:34 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/17] ARM: integrator: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:13 -0800
Message-Id: <1384557985-9414-6-git-send-email-sboyd@codeaurora.org>
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
 arch/arm/mach-integrator/integrator_ap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index d50dc2d..473e21b 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -277,7 +277,7 @@ struct amba_pl010_data ap_uart_data = {
 
 static unsigned long timer_reload;
 
-static u32 notrace integrator_read_sched_clock(void)
+static u64 notrace integrator_read_sched_clock(void)
 {
 	return -readl((void __iomem *) TIMER2_VA_BASE + TIMER_VALUE);
 }
@@ -298,7 +298,7 @@ static void integrator_clocksource_init(unsigned long inrate,
 
 	clocksource_mmio_init(base + TIMER_VALUE, "timer2",
 			rate, 200, 16, clocksource_mmio_readl_down);
-	setup_sched_clock(integrator_read_sched_clock, 16, rate);
+	sched_clock_register(integrator_read_sched_clock, 16, rate);
 }
 
 static void __iomem * clkevt_base;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

