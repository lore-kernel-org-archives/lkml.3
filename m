Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3KOX33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:29:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41244 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3KOX0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:33 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 02/17] ARM: clps711x: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:10 -0800
Message-Id: <1384557985-9414-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
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
index 134641d..a193591 100644
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

