Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058Ab3GaWey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:34:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44553 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760875Ab3GaWbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:31:22 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: [PATCH 06/18] ARM: IXP4xx: Switch to sched_clock_register()
Date: Wed, 31 Jul 2013 15:31:05 -0700
Message-Id: <1375309877-16617-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
In-Reply-To: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-ixp4xx/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 5327dec..124631e 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -448,7 +448,7 @@ void __init ixp4xx_sys_init(void)
 /*
  * sched_clock()
  */
-static u32 notrace ixp4xx_read_sched_clock(void)
+static u64 notrace ixp4xx_read_sched_clock(void)
 {
 	return *IXP4XX_OSTS;
 }
@@ -466,7 +466,7 @@ unsigned long ixp4xx_timer_freq = IXP4XX_TIMER_FREQ;
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

