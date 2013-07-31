Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab3GaWcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:32:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44576 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760919Ab3GaWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:24 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 15/18] ARM: OMAP: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:14 -0700
Message-Id: <1375309877-16617-16-git-send-email-sboyd@codeaurora.org>
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
 arch/arm/plat-omap/counter_32k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
index d9bc98e..384a776d 100644
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -38,7 +38,7 @@
  */
 static void __iomem *sync32k_cnt_reg;
 
-static u32 notrace omap_32k_read_sched_clock(void)
+static u64 notrace omap_32k_read_sched_clock(void)
 {
 	return sync32k_cnt_reg ? __raw_readl(sync32k_cnt_reg) : 0;
 }
@@ -115,7 +115,7 @@ int __init omap_init_clocksource_32k(void __iomem *vbase)
 		return ret;
 	}
 
-	setup_sched_clock(omap_32k_read_sched_clock, 32, 32768);
+	sched_clock_register(omap_32k_read_sched_clock, 32, 32768);
 	register_persistent_clock(NULL, omap_read_persistent_clock);
 	pr_info("OMAP clocksource: 32k_counter at 32768 Hz\n");
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

