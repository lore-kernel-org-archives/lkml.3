Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987Ab3GaWb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:31:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44625 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760936Ab3GaWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 17/18] ARM: SAMSUNG: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:16 -0700
Message-Id: <1375309877-16617-18-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/plat-samsung/samsung-time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/samsung-time.c b/arch/arm/plat-samsung/samsung-time.c
index 2957075..1e2119b 100644
--- a/arch/arm/plat-samsung/samsung-time.c
+++ b/arch/arm/plat-samsung/samsung-time.c
@@ -312,7 +312,7 @@ static void __iomem *samsung_timer_reg(void)
  * this wraps around for now, since it is just a relative time
  * stamp. (Inspired by U300 implementation.)
  */
-static u32 notrace samsung_read_sched_clock(void)
+static u64 notrace samsung_read_sched_clock(void)
 {
 	void __iomem *reg = samsung_timer_reg();
 
@@ -337,7 +337,7 @@ static void __init samsung_clocksource_init(void)
 	samsung_time_setup(timer_source.source_id, TCNT_MAX);
 	samsung_time_start(timer_source.source_id, PERIODIC);
 
-	setup_sched_clock(samsung_read_sched_clock, TSIZE, clock_rate);
+	sched_clock_register(samsung_read_sched_clock, TSIZE, clock_rate);
 
 	if (clocksource_mmio_init(samsung_timer_reg(), "samsung_clocksource_timer",
 			clock_rate, 250, TSIZE, clocksource_mmio_readl_down))
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

