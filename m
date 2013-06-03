Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3FCUeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:34:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45453 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3FCUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:34:07 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCHv7 03/11] ARM: smp: Remove duplicate dummy timer implementation
Date: Mon,  3 Jun 2013 13:33:54 -0700
Message-Id: <1370291642-13259-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org>
References: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop ARM's version of the dummy timer now that we have a generic
implementation in drivers/clocksource.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>,
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 47ab905..4dc883a 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -503,24 +503,6 @@ void tick_broadcast(const struct cpumask *mask)
 }
 #endif
 
-static void broadcast_timer_set_mode(enum clock_event_mode mode,
-	struct clock_event_device *evt)
-{
-}
-
-static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
-{
-	evt->name	= "dummy_timer";
-	evt->features	= CLOCK_EVT_FEAT_ONESHOT |
-			  CLOCK_EVT_FEAT_PERIODIC |
-			  CLOCK_EVT_FEAT_DUMMY;
-	evt->rating	= 100;
-	evt->mult	= 1;
-	evt->set_mode	= broadcast_timer_set_mode;
-
-	clockevents_register_device(evt);
-}
-
 static struct local_timer_ops *lt_ops;
 
 #ifdef CONFIG_LOCAL_TIMERS
@@ -544,8 +526,8 @@ static void __cpuinit percpu_timer_setup(void)
 
 	evt->cpumask = cpumask_of(cpu);
 
-	if (!lt_ops || lt_ops->setup(evt))
-		broadcast_timer_setup(evt);
+	if (lt_ops)
+		lt_ops->setup(evt);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

