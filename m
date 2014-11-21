Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaKUTsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:48:08 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42693 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaKUToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:38 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/12] time: Complete NTP adjustment threshold judging conditions
Date: Fri, 21 Nov 2014 11:44:09 -0800
Message-Id: <1416599058-13836-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "pang.xunlei" <pang.xunlei@linaro.org>

The clocksource mult-adjustment threshold is [mult-maxadj, mult+maxadj],
timekeeping_adjust() only deals with the upper threshold, but misses the
lower threshold.

This patch adds the lower threshold judging condition.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
[jstultz: Minor fix for > 80 char line]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cad61b3..41fcbe1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1403,7 +1403,8 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	}
 
 	if (unlikely(tk->tkr.clock->maxadj &&
-		(tk->tkr.mult > tk->tkr.clock->mult + tk->tkr.clock->maxadj))) {
+		(abs(tk->tkr.mult - tk->tkr.clock->mult)
+			> tk->tkr.clock->maxadj))) {
 		printk_once(KERN_WARNING
 			"Adjusting %s more than 11%% (%ld vs %ld)\n",
 			tk->tkr.clock->name, (long)tk->tkr.mult,
-- 
1.9.1

