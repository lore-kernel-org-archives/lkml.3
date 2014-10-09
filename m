Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaJIHKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:10:31 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:45796 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:10:22 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH 2/2] time: Complete NTP adjustment threshold judging conditions
Date: Thu,  9 Oct 2014 15:04:31 +0800
Message-Id: <1412838271-11175-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
References: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource mult-adjustment threshold is [mult-maxadj, mult+maxadj],
timekeeping_adjust() only deals with the upper threshold, but misses the
lower threshold.

This patch adds the lower threshold judging condition.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cad61b3..469cdbf 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1403,7 +1403,7 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	}
 
 	if (unlikely(tk->tkr.clock->maxadj &&
-		(tk->tkr.mult > tk->tkr.clock->mult + tk->tkr.clock->maxadj))) {
+		(abs(tk->tkr.mult - tk->tkr.clock->mult) > tk->tkr.clock->maxadj))) {
 		printk_once(KERN_WARNING
 			"Adjusting %s more than 11%% (%ld vs %ld)\n",
 			tk->tkr.clock->name, (long)tk->tkr.mult,
-- 
1.7.10.4

