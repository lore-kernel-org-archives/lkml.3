Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3EMT0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:26:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50757 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3EMT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:26:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363158000"; 
   d="scan'208";a="46876043"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCHv6 03/11] ARM: smp: Remove duplicate dummy timer implementation
Date: Mon, 13 May 2013 12:26:07 -0700
Message-Id: <1368473175-4841-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0.dirty
In-Reply-To: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop ARM's version of the dummy timer now that we have a generic
implementation in drivers/clocksource.

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

