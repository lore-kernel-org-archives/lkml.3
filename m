Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3KOX2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:28:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41332 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3KOX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 17/17] ARM: versatile: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:25 -0800
Message-Id: <1384557985-9414-18-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
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

