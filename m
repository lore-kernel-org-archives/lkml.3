Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3KOX3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:29:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41250 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3KOX0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:33 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 07/17] ARM: mmp: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:15 -0800
Message-Id: <1384557985-9414-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
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

