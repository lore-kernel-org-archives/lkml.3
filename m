Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3LYOyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 09:54:52 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:63942 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3LYOyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 09:54:51 -0500
Date: Wed, 25 Dec 2013 06:54:47 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
Message-ID: <20131225145447.GA18146@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

