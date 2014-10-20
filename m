Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaJTTE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:04:26 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:41740 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaJTTEP (ORCPT
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
Subject: [PATCH 13/19] clocksource: mips-gic: Staticize local symbols
Date: Mon, 20 Oct 2014 12:04:00 -0700
Message-Id: <1413831846-32100-14-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of variables and functions which are unnecessarily
global.  Mark them static.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clocksource/mips-gic-timer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/mips-gic-timer.c b/drivers/clocksource/mips-gic-timer.c
index 3cf5912..2603f50 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -15,8 +15,8 @@
 
 #include <asm/time.h>
 
-DEFINE_PER_CPU(struct clock_event_device, gic_clockevent_device);
-int gic_timer_irq_installed;
+static DEFINE_PER_CPU(struct clock_event_device, gic_clockevent_device);
+static int gic_timer_irq_installed;
 
 static int gic_next_event(unsigned long delta, struct clock_event_device *evt)
 {
@@ -30,13 +30,13 @@ static int gic_next_event(unsigned long delta, struct clock_event_device *evt)
 	return res;
 }
 
-void gic_set_clock_mode(enum clock_event_mode mode,
+static void gic_set_clock_mode(enum clock_event_mode mode,
 				struct clock_event_device *evt)
 {
 	/* Nothing to do ...  */
 }
 
-irqreturn_t gic_compare_interrupt(int irq, void *dev_id)
+static irqreturn_t gic_compare_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *cd;
 	int cpu = smp_processor_id();
@@ -53,7 +53,7 @@ struct irqaction gic_compare_irqaction = {
 	.name = "timer",
 };
 
-void gic_event_handler(struct clock_event_device *dev)
+static void gic_event_handler(struct clock_event_device *dev)
 {
 }
 
-- 
2.1.0.rc2.206.gedb03e5

