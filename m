Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3KOX2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:28:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab3KOX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:37 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 16/17] ARM: orion: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:24 -0800
Message-Id: <1384557985-9414-17-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
 arch/arm/plat-orion/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-orion/time.c b/arch/arm/plat-orion/time.c
index 9d2b2ac..dade292 100644
--- a/arch/arm/plat-orion/time.c
+++ b/arch/arm/plat-orion/time.c
@@ -60,7 +60,7 @@ static u32 ticks_per_jiffy;
  * at least 7.5ns (133MHz TCLK).
  */
 
-static u32 notrace orion_read_sched_clock(void)
+static u64 notrace orion_read_sched_clock(void)
 {
 	return ~readl(timer_base + TIMER0_VAL_OFF);
 }
@@ -201,7 +201,7 @@ orion_time_init(void __iomem *_bridge_base, u32 _bridge_timer1_clr_mask,
 	/*
 	 * Set scale and timer for sched_clock.
 	 */
-	setup_sched_clock(orion_read_sched_clock, 32, tclk);
+	sched_clock_register(orion_read_sched_clock, 32, tclk);
 
 	/*
 	 * Setup free-running clocksource timer (interrupts
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

