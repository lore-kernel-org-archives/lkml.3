Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaKUTo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:44:56 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63807 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaKUTos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:48 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 12/12] time: Remove timekeeping_inject_sleeptime()
Date: Fri, 21 Nov 2014 11:44:18 -0800
Message-Id: <1416599058-13836-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all users have been converted to using the 64bit
timekeeping_inject_sleeptime64(), remove the old y2038
problematic timekeeping_inject_sleeptime().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeping.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 8cab4b7..961fea3 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -225,17 +225,6 @@ static inline void timekeeping_clocktai(struct timespec *ts)
  */
 extern void timekeeping_inject_sleeptime64(struct timespec64 *delta);
 
-/**
- * Deprecated. Use timekeeping_inject_sleeptime64().
- */
-static inline void timekeeping_inject_sleeptime(struct timespec *delta)
-{
-	struct timespec64 delta64;
-
-	delta64 = timespec_to_timespec64(*delta);
-	timekeeping_inject_sleeptime64(&delta64);
-}
-
 /*
  * PPS accessor
  */
-- 
1.9.1

