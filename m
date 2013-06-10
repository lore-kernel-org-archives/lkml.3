Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3FJH6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:58:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3FJH5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:57:54 -0400
Date: Mon, 10 Jun 2013 15:57:45 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] timer stats: reset entries when disable the timer usage
 statistics
Message-ID: <20130610075745.GK8399@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4dbb760213856dc382241db456c1c6487694837c Mon Sep 17 00:00:00 2001
From: Dong Zhu <bluezhudong@gmail.com>
Date: Mon, 10 Jun 2013 15:09:27 +0800

we can start/stop data collection by using :
echo [1|0] > /proc/timer_stats
when we stop the data collection,hrtimer will not update the statistics
for a timer any more,but we could still check the timer usage
statistics,unfortunately the data is not the latest, the inaccurate data
might make us confusing. So the purpose of this patch is to reset the
entries once disable operation is executed.In this way we will never
see the inaccurate timer usage statistics.

Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
---
 kernel/time/timer_stats.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 0b537f2..43f05e7 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -371,6 +371,7 @@ static ssize_t tstats_write(struct file *file, const char __user *buf,
 	switch (ctl[0]) {
 	case '0':
 		if (timer_stats_active) {
+			reset_entries();
 			timer_stats_active = 0;
 			time_stop = ktime_get();
 			sync_access();
-- 
1.7.11.7

-- 
Best Regards,
Dong Zhu
