Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937Ab3GaWbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:31:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44509 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3GaWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:21 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 02/18] ARM: clps711x: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:01 -0700
Message-Id: <1375309877-16617-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-clps711x/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index 4ca2f3c..5e5a6ac 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -259,7 +259,7 @@ asmlinkage void __exception_irq_entry clps711x_handle_irq(struct pt_regs *regs)
 	} while (1);
 }
 
-static u32 notrace clps711x_sched_clock_read(void)
+static u64 notrace clps711x_sched_clock_read(void)
 {
 	return ~readw_relaxed(CLPS711X_VIRT_BASE + TC1D);
 }
@@ -366,7 +366,7 @@ void __init clps711x_timer_init(void)
 	tmp = clps_readl(SYSCON1) & ~(SYSCON1_TC1S | SYSCON1_TC1M);
 	clps_writel(tmp, SYSCON1);
 
-	setup_sched_clock(clps711x_sched_clock_read, 16, timl);
+	sched_clock_register(clps711x_sched_clock_read, 16, timl);
 
 	clocksource_mmio_init(CLPS711X_VIRT_BASE + TC1D,
 			      "clps711x_clocksource", timl, 300, 16,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

