Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073Ab3GaWez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:34:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44551 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869Ab3GaWbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:22 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/18] ARM: integrator: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:04 -0700
Message-Id: <1375309877-16617-6-git-send-email-sboyd@codeaurora.org>
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
 arch/arm/mach-integrator/integrator_ap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index d9e95e6..1489f5c 100644
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

