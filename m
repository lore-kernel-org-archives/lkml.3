Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3ENHsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:48:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44610 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab3ENHr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:47:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,668,1363104000"; 
   d="scan'208,223";a="7264468"
Message-ID: <5191EBA7.9010303@cn.fujitsu.com>
Date: Tue, 14 May 2013 15:45:43 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: john.stultz@linaro.org, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 15:46:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 15:46:47,
	Serialize complete at 2013/05/14 15:46:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 18072c1c3506a7e37ee485307a2c343efe5af4d0 Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 13 May 2013 15:45:24 +0900
Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()

Introduce a new timestamp function local_time_seconds() to hide the conversion of system time in UTC to local time seconds.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 include/linux/time.h |    1 +
 kernel/time.c        |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 22d81b3..1aec534 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -271,4 +271,5 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_nsec = ns;
 }
 
+extern u32 local_time_seconds(void);
 #endif
diff --git a/kernel/time.c b/kernel/time.c
index d3617db..715377d 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -712,3 +712,14 @@ struct timespec timespec_add_safe(const struct timespec lhs,
 
 	return res;
 }
+
+/*
+ * Convert system time in UTC to local time seconds.
+ */
+u32 local_time_seconds(void)
+{
+	struct timeval utc;
+	do_gettimeofday(&utc);
+	return (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
+}
+EXPORT_SYMBOL(local_time_seconds);
-- 
1.7.1

