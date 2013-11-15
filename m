Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3KOX3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:29:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41239 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3KOX0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:33 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 04/17] ARM: imx: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:12 -0800
Message-Id: <1384557985-9414-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-imx/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
index 9b6638a..1a3a5f6 100644
--- a/arch/arm/mach-imx/time.c
+++ b/arch/arm/mach-imx/time.c
@@ -111,7 +111,7 @@ static void gpt_irq_acknowledge(void)
 
 static void __iomem *sched_clock_reg;
 
-static u32 notrace mxc_read_sched_clock(void)
+static u64 notrace mxc_read_sched_clock(void)
 {
 	return sched_clock_reg ? __raw_readl(sched_clock_reg) : 0;
 }
@@ -123,7 +123,7 @@ static int __init mxc_clocksource_init(struct clk *timer_clk)
 
 	sched_clock_reg = reg;
 
-	setup_sched_clock(mxc_read_sched_clock, 32, c);
+	sched_clock_register(mxc_read_sched_clock, 32, c);
 	return clocksource_mmio_init(reg, "mxc_timer1", c, 200, 32,
 			clocksource_mmio_readl_up);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

