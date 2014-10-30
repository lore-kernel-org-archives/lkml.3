Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbaJ3LR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63353 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbaJ3LRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:17:23 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 06/11] time: Remove do_settimeofday()
Date: Thu, 30 Oct 2014 19:15:40 +0800
Message-Id: <1414667745-7703-7-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove do_settimeofday(), since it has no users by now.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 include/linux/timekeeping.h |    1 -
 kernel/time/timekeeping.c   |   16 ----------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index afc61c3..24abc46 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -11,7 +11,6 @@ extern int timekeeping_suspended;
  */
 extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday64(const struct timespec64 *ts);
-extern int do_settimeofday(const struct timespec *tv);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f0dcbc0..e776d6b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -744,22 +744,6 @@ int do_settimeofday64(const struct timespec64 *ts)
 EXPORT_SYMBOL(do_settimeofday64);
 
 /**
- * do_settimeofday - Sets the time of day
- * @tv:		pointer to the timespec variable containing the new time
- *
- * Sets the time of day to the new time and update NTP and notify hrtimers
- * TODO: [2038 safety] should be replaced by do_settimeofday64().
- */
-int do_settimeofday(const struct timespec *tv)
-{
-	struct timespec64 ts64;
-
-	ts64 = timespec_to_timespec64(*tv);
-	return do_settimeofday64(&ts64);
-}
-EXPORT_SYMBOL(do_settimeofday);
-
-/**
  * timekeeping_inject_offset - Adds or subtracts from the current time.
  * @tv:		pointer to the timespec variable containing the offset
  *
-- 
1.7.9.5

