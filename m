Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005Ab3GaWdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:33:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44553 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760914Ab3GaWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:24 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 12/18] ARM: sa1100: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:11 -0700
Message-Id: <1375309877-16617-13-git-send-email-sboyd@codeaurora.org>
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
 arch/arm/mach-sa1100/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 713c86c..6fd4acb 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -20,7 +20,7 @@
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 
-static u32 notrace sa1100_read_sched_clock(void)
+static u64 notrace sa1100_read_sched_clock(void)
 {
 	return readl_relaxed(OSCR);
 }
@@ -122,7 +122,7 @@ void __init sa1100_timer_init(void)
 	writel_relaxed(0, OIER);
 	writel_relaxed(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
 
-	setup_sched_clock(sa1100_read_sched_clock, 32, 3686400);
+	sched_clock_register(sa1100_read_sched_clock, 32, 3686400);
 
 	ckevt_sa1100_osmr0.cpumask = cpumask_of(0);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

