Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3IXVFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:05:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42178 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3IXVFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:05:43 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ARC: Use clockevents_config_and_register over clockevents_register_device
Date: Tue, 24 Sep 2013 23:05:37 +0200
Message-Id: <1380056737-3471-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clockevents_config_and_register is more clever and correct than doing it
by hand; so use it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arc/kernel/time.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arc/kernel/time.c b/arch/arc/kernel/time.c
index 0e51e69..273df8e 100644
--- a/arch/arc/kernel/time.c
+++ b/arch/arc/kernel/time.c
@@ -227,12 +227,9 @@ void __attribute__((weak)) arc_local_timer_setup(unsigned int cpu)
 {
 	struct clock_event_device *clk = &per_cpu(arc_clockevent_device, cpu);
 
-	clockevents_calc_mult_shift(clk, arc_get_core_freq(), 5);
-
-	clk->max_delta_ns = clockevent_delta2ns(ARC_TIMER_MAX, clk);
 	clk->cpumask = cpumask_of(cpu);
-
-	clockevents_register_device(clk);
+	clockevents_config_and_register(clk, arc_get_core_freq(),
+					0, ARC_TIMER_MAX)
 
 	/*
 	 * setup the per-cpu timer IRQ handler - for all cpus
-- 
1.8.4.rc3

