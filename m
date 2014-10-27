Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaJ0Fr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:29 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40578 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaJ0Fr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:27 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 06/12] time: Fix build warnings for time64_t to __kernel_time_t warning on 64-bit systems.
Date: Mon, 27 Oct 2014 13:46:36 +0800
Message-Id: <1414388802-5866-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

This patch fixed the build warnings brought by former patches.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 include/linux/time64.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/time64.h b/include/linux/time64.h
index a383147..02f2c87 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -3,15 +3,15 @@
 
 #include <uapi/linux/time.h>
 
-typedef __s64 time64_t;
-
 /*
  * This wants to go into uapi/linux/time.h once we agreed about the
  * userspace interfaces.
  */
 #if __BITS_PER_LONG == 64
-# define timespec64 timespec
+typedef __kernel_time_t time64_t;
+#define timespec64 timespec
 #else
+typedef __s64 time64_t;
 struct timespec64 {
 	time64_t	tv_sec;			/* seconds */
 	long		tv_nsec;		/* nanoseconds */
-- 
1.7.9.5

