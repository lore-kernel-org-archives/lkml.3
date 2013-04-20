Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3DTNPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 09:15:32 -0400
Received: from mail.df.lth.se ([194.47.250.12]:56978 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab3DTNP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 09:15:29 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] clocksource: nomadik-mtu: fix up clocksource/timer
Date: Sat, 20 Apr 2013 15:08:07 +0200
Message-Id: <1366463287-9922-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Nomadik clocksource driver has had a bad define making it
impossible to use it for sched_clock() for a while. Fix this
and also enable it for the Nomadik.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-nomadik/Kconfig     | 1 +
 drivers/clocksource/nomadik-mtu.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-nomadik/Kconfig b/arch/arm/mach-nomadik/Kconfig
index 954f0e3..8c1ccd4 100644
--- a/arch/arm/mach-nomadik/Kconfig
+++ b/arch/arm/mach-nomadik/Kconfig
@@ -5,6 +5,7 @@ config ARCH_NOMADIK
 	select ARM_AMBA
 	select ARM_VIC
 	select CLKSRC_NOMADIK_MTU
+	select CLKSRC_NOMADIK_MTU_SCHED_CLOCK
 	select COMMON_CLK
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 071f6ea..e405531 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -67,7 +67,7 @@ static u32 clk_prescale;
 static u32 nmdk_cycle;		/* write-once */
 static struct delay_timer mtu_delay_timer;
 
-#ifdef CONFIG_NOMADIK_MTU_SCHED_CLOCK
+#ifdef CONFIG_CLKSRC_NOMADIK_MTU_SCHED_CLOCK
 /*
  * Override the global weak sched_clock symbol with this
  * local implementation which uses the clocksource to get some
@@ -233,7 +233,7 @@ void __init nmdk_timer_init(void __iomem *base, int irq)
 		pr_err("timer: failed to initialize clock source %s\n",
 		       "mtu_0");
 
-#ifdef CONFIG_NOMADIK_MTU_SCHED_CLOCK
+#ifdef CONFIG_CLKSRC_NOMADIK_MTU_SCHED_CLOCK
 	setup_sched_clock(nomadik_read_sched_clock, 32, rate);
 #endif
 
-- 
1.8.1.4

