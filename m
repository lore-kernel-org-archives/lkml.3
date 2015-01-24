Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbbAXBoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:44:24 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53866 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbAXBoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:15 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/8] time: Expose get_monotonic_boottime64 for in-kernel use
Date: Fri, 23 Jan 2015 17:43:55 -0800
Message-Id: <1422063840-2837-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
References: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the 2038 conversion process, add a
get_monotonic_boottime64 accessor so we can depracate
get_monotonic_boottime.

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeping.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 9148013..3eaae47 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -229,6 +229,11 @@ static inline void get_monotonic_boottime(struct timespec *ts)
 	*ts = ktime_to_timespec(ktime_get_boottime());
 }
 
+static inline void get_monotonic_boottime64(struct timespec64 *ts)
+{
+	*ts = ktime_to_timespec64(ktime_get_boottime());
+}
+
 static inline void timekeeping_clocktai(struct timespec *ts)
 {
 	*ts = ktime_to_timespec(ktime_get_clocktai());
-- 
1.9.1

