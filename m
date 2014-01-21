Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaAUFQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:16:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaAUFQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:16:00 -0500
Date: Mon, 20 Jan 2014 21:15:45 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-b684bfedc94d4b2efff09dc499a9985321c482f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1388182464-28428-3-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-3-git-send-email-hjl.tools@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] uapi: Use __kernel_long_t/__kernel_ulong_t in <
 linux/resource.h>
Git-Commit-ID: b684bfedc94d4b2efff09dc499a9985321c482f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 21:15:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b684bfedc94d4b2efff09dc499a9985321c482f5
Gitweb:     http://git.kernel.org/tip/b684bfedc94d4b2efff09dc499a9985321c482f5
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Fri, 27 Dec 2013 14:14:18 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Jan 2014 14:44:17 -0800

uapi: Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>

Both x32 and x86-64 use the same struct rusage and struct rlimit for
system calls.  But x32 log is 32-bit.  This patch change uapi
<linux/resource.h> to use __kernel_long_t in struct rusage and
__kernel_ulong_t in and struct rlimit.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1388182464-28428-3-git-send-email-hjl.tools@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
