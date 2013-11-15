Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3KOX3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:29:02 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3KOX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:34 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH 06/17] ARM: IXP4xx: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:26:14 -0800
Message-Id: <1384557985-9414-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Imre Kaloz <kaloz@openwrt.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
---
 arch/arm/mach-ixp4xx/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 9edaf47..bc9d8ec 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -475,7 +475,7 @@ void __init ixp4xx_sys_init(void)
 /*
  * sched_clock()
  */
-static u32 notrace ixp4xx_read_sched_clock(void)
+static u64 notrace ixp4xx_read_sched_clock(void)
 {
 	return *IXP4XX_OSTS;
 }
@@ -493,7 +493,7 @@ unsigned long ixp4xx_timer_freq = IXP4XX_TIMER_FREQ;
 EXPORT_SYMBOL(ixp4xx_timer_freq);
 static void __init ixp4xx_clocksource_init(void)
 {
-	setup_sched_clock(ixp4xx_read_sched_clock, 32, ixp4xx_timer_freq);
+	sched_clock_register(ixp4xx_read_sched_clock, 32, ixp4xx_timer_freq);
 
 	clocksource_mmio_init(NULL, "OSTS", ixp4xx_timer_freq, 200, 32,
 			ixp4xx_clocksource_read);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

