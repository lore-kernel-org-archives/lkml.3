Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3L0WOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:14:35 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:41685 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab3L0WOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:14:32 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 2/8] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
Date: Fri, 27 Dec 2013 14:14:18 -0800
Message-Id: <1388182464-28428-3-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct rusage and struct rlimit for
system calls.  But x32 log is 32-bit.  This patch change uapi
<linux/resource.h> to use __kernel_long_t in struct rusage and
__kernel_ulong_t in and struct rlimit.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/resource.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index e0ed284..36fb3b5 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -23,25 +23,25 @@
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
 	struct timeval ru_stime;	/* system time used */
-	long	ru_maxrss;		/* maximum resident set size */
-	long	ru_ixrss;		/* integral shared memory size */
-	long	ru_idrss;		/* integral unshared data size */
-	long	ru_isrss;		/* integral unshared stack size */
-	long	ru_minflt;		/* page reclaims */
-	long	ru_majflt;		/* page faults */
-	long	ru_nswap;		/* swaps */
-	long	ru_inblock;		/* block input operations */
-	long	ru_oublock;		/* block output operations */
-	long	ru_msgsnd;		/* messages sent */
-	long	ru_msgrcv;		/* messages received */
-	long	ru_nsignals;		/* signals received */
-	long	ru_nvcsw;		/* voluntary context switches */
-	long	ru_nivcsw;		/* involuntary " */
+	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
+	__kernel_long_t	ru_ixrss;	/* integral shared memory size */
+	__kernel_long_t	ru_idrss;	/* integral unshared data size */
+	__kernel_long_t	ru_isrss;	/* integral unshared stack size */
+	__kernel_long_t	ru_minflt;	/* page reclaims */
+	__kernel_long_t	ru_majflt;	/* page faults */
+	__kernel_long_t	ru_nswap;	/* swaps */
+	__kernel_long_t	ru_inblock;	/* block input operations */
+	__kernel_long_t	ru_oublock;	/* block output operations */
+	__kernel_long_t	ru_msgsnd;	/* messages sent */
+	__kernel_long_t	ru_msgrcv;	/* messages received */
+	__kernel_long_t	ru_nsignals;	/* signals received */
+	__kernel_long_t	ru_nvcsw;	/* voluntary context switches */
+	__kernel_long_t	ru_nivcsw;	/* involuntary " */
 };
 
 struct rlimit {
-	unsigned long	rlim_cur;
-	unsigned long	rlim_max;
+	__kernel_ulong_t	rlim_cur;
+	__kernel_ulong_t	rlim_max;
 };
 
 #define RLIM64_INFINITY		(~0ULL)
-- 
1.8.4.2

