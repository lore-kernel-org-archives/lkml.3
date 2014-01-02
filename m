Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaABWXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:23:49 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56483 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaABWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:23:46 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 9/9] timekeeping: Remove comment that's mostly out of date
Date: Thu,  2 Jan 2014 14:23:27 -0800
Message-Id: <1388701407-5029-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
References: <52C5E6A0.7010507@linaro.org>
 <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to 92bb1fcf57a0c2e45f7e67fbf0a8ed475a749236 (Only
do nanosecond rounding on GENERIC_TIME_VSYSCALL_OLD
systems), the comment here was accuate, but now we can
mostly avoid the extra rounding which causes the unlikey
to be actually likely here.

So remove the out of date comment.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3ff3064..abfa4e8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1134,16 +1134,6 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 		 * we can adjust by 1.
 		 */
 		error >>= 2;
-		/*
-		 * XXX - In update_wall_time, we round up to the next
-		 * nanosecond, and store the amount rounded up into
-		 * the error. This causes the likely below to be unlikely.
-		 *
-		 * The proper fix is to avoid rounding up by using
-		 * the high precision tk->xtime_nsec instead of
-		 * xtime.tv_nsec everywhere. Fixing this will take some
-		 * time.
-		 */
 		if (likely(error <= interval))
 			adj = 1;
 		else
-- 
1.8.3.2

