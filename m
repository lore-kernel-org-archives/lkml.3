Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018Ab3GaWdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:33:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44551 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760912Ab3GaWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:23 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 11/18] ARM: pxa: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:10 -0700
Message-Id: <1375309877-16617-12-git-send-email-sboyd@codeaurora.org>
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
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-pxa/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 9aa852a..d1bfaa7 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -33,7 +33,7 @@
  * calls to sched_clock() which should always be the case in practice.
  */
 
-static u32 notrace pxa_read_sched_clock(void)
+static u64 notrace pxa_read_sched_clock(void)
 {
 	return readl_relaxed(OSCR);
 }
@@ -149,7 +149,7 @@ void __init pxa_timer_init(void)
 	writel_relaxed(0, OIER);
 	writel_relaxed(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
 
-	setup_sched_clock(pxa_read_sched_clock, 32, clock_tick_rate);
+	sched_clock_register(pxa_read_sched_clock, 32, clock_tick_rate);
 
 	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

