Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044Ab3GaWew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:34:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44561 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760882Ab3GaWbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:22 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 07/18] ARM: mmp: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:06 -0700
Message-Id: <1375309877-16617-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-mmp/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 7ac41e8..024022d 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -61,7 +61,7 @@ static inline uint32_t timer_read(void)
 	return __raw_readl(mmp_timer_base + TMR_CVWR(1));
 }
 
-static u32 notrace mmp_read_sched_clock(void)
+static u64 notrace mmp_read_sched_clock(void)
 {
 	return timer_read();
 }
@@ -195,7 +195,7 @@ void __init timer_init(int irq)
 {
 	timer_config();
 
-	setup_sched_clock(mmp_read_sched_clock, 32, CLOCK_TICK_RATE);
+	sched_clock_register(mmp_read_sched_clock, 32, CLOCK_TICK_RATE);
 
 	ckevt.cpumask = cpumask_of(0);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

