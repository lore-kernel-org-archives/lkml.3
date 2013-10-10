Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3JJC6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab3JJC6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:58:34 -0400
Date: Thu, 10 Oct 2013 10:59:47 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] timer stats: reset entries when disable the timer
 usage statistics
Message-ID: <20131010025947.GD2139@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f41628c61d8a9172677ba33a55b61e37ce28f7a6 Mon Sep 17 00:00:00 2001
From: Dong Zhu <bluezhudong@gmail.com> 
Date: Thu, 10 Oct 2013 10:38:13 +0800

When we stop timer statistics collection (via echo 0 >
/proc/timers_stats), the statistics data is still exported as if it were
correct, which can cause applicaitons to misuse the statistics.

This patch resets the statistics when we stop collecting them, to avoid
this problem.

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
