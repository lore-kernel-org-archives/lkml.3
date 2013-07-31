Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974Ab3GaWbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:31:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44629 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760939Ab3GaWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 18/18] ARM: versatile: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:17 -0700
Message-Id: <1375309877-16617-19-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/plat-versatile/sched-clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-versatile/sched-clock.c b/arch/arm/plat-versatile/sched-clock.c
index 51b109e..c966ae9 100644
--- a/arch/arm/plat-versatile/sched-clock.c
+++ b/arch/arm/plat-versatile/sched-clock.c
@@ -26,7 +26,7 @@
 
 static void __iomem *ctr;
 
-static u32 notrace versatile_read_sched_clock(void)
+static u64 notrace versatile_read_sched_clock(void)
 {
 	if (ctr)
 		return readl(ctr);
@@ -37,5 +37,5 @@ static u32 notrace versatile_read_sched_clock(void)
 void __init versatile_sched_clock_init(void __iomem *reg, unsigned long rate)
 {
 	ctr = reg;
-	setup_sched_clock(versatile_read_sched_clock, 32, rate);
+	sched_clock_register(versatile_read_sched_clock, 32, rate);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

