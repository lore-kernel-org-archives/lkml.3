Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaDNQY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:24:57 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60237 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaDNQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:24:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 07/38] tick-oneshot: drop local_irq_save/restore from tick_switch_to_oneshot()
Date: Mon, 14 Apr 2014 21:53:29 +0530
Message-Id: <1bd46e057b41f48b0ec58136ee404356728e0371.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_switch_to_oneshot() is just reading value of
__this_cpu_read(tick_cpu_device.mode) and doesn't need to disable local
interrupts for that. Drop local_irq_save/restore calls from this routine.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-oneshot.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 6a531ec..39492f1 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -92,14 +92,7 @@ int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
  */
 int tick_oneshot_mode_active(void)
 {
-	unsigned long flags;
-	int ret;
-
-	local_irq_save(flags);
-	ret = tick_get_cpu_device()->mode == TICKDEV_MODE_ONESHOT;
-	local_irq_restore(flags);
-
-	return ret;
+	return tick_get_cpu_device()->mode == TICKDEV_MODE_ONESHOT;
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
-- 
1.7.12.rc2.18.g61b472e

