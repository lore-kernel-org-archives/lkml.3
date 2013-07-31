Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033Ab3GaWe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:34:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44568 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887Ab3GaWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:23 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 08/18] ARM: msm: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:07 -0700
Message-Id: <1375309877-16617-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index b6418fd..3c9b4da 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -170,7 +170,7 @@ static struct local_timer_ops msm_local_timer_ops __cpuinitdata = {
 };
 #endif /* CONFIG_LOCAL_TIMERS */
 
-static notrace u32 msm_sched_clock_read(void)
+static u64 notrace msm_sched_clock_read(void)
 {
 	return msm_clocksource.read(&msm_clocksource);
 }
@@ -215,7 +215,7 @@ err:
 	res = clocksource_register_hz(cs, dgt_hz);
 	if (res)
 		pr_err("clocksource_register failed\n");
-	setup_sched_clock(msm_sched_clock_read, sched_bits, dgt_hz);
+	sched_clock_register(msm_sched_clock_read, sched_bits, dgt_hz);
 }
 
 #ifdef CONFIG_OF
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

