Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaJTTFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:05:14 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:60895 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaJTTEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:15 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] clocksource: mips-gic: Remove gic_event_handler
Date: Mon, 20 Oct 2014 12:04:02 -0700
Message-Id: <1413831846-32100-16-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove gic_event_handler since it is completely unnecessary.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clocksource/mips-gic-timer.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/clocksource/mips-gic-timer.c b/drivers/clocksource/mips-gic-timer.c
index bced17d..763aa1c 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -54,10 +54,6 @@ struct irqaction gic_compare_irqaction = {
 	.name = "timer",
 };
 
-static void gic_event_handler(struct clock_event_device *dev)
-{
-}
-
 int gic_clockevent_init(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -86,7 +82,6 @@ int gic_clockevent_init(void)
 	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= gic_next_event;
 	cd->set_mode		= gic_set_clock_mode;
-	cd->event_handler	= gic_event_handler;
 
 	clockevents_register_device(cd);
 
-- 
2.1.0.rc2.206.gedb03e5

