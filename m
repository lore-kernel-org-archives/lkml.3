Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3LZPgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:36:23 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:51772 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab3LZPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:36:22 -0500
Date: Thu, 26 Dec 2013 07:36:19 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t/__kernel_ulong_t in
 <linux/resource.h>
Message-ID: <20131226153619.GB23355@gmail.com>
References: <20131225145447.GA18146@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20131225145447.GA18146@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 06:54:47AM -0800, H.J. Lu wrote:
> Both x32 and x86-64 use the same struct rusage and struct rlimit for
> system calls.  But x32 log is 32-bit.  This patch change uapi
> <linux/resource.h> to use __kernel_long_t in struct rusage and
> __kernel_ulong_t in and struct rlimit.

Here is the updated patch which uses __kernel_long_t/__kernel_ulong_t
only if __BITS_PER_LONG == 64. 
 
H.J.

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-Use-__kernel_long_t-__kernel_ulong_t-in-linux-resour.patch"

>From d2a3409eb9aecd545a3f9c384dd55cfc870122ac Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 25 Dec 2013 06:50:33 -0800
Subject: [PATCH] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>

Both x32 and x86-64 use the same struct rusage and struct rlimit for
system calls.  But x32 log is 32-bit.  This patch change uapi
<linux/resource.h> to use __kernel_long_t in struct rusage and
__kernel_ulong_t in and struct rlimit if __BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/resource.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index e0ed284..87d2daa 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -23,6 +23,22 @@
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
 	struct timeval ru_stime;	/* system time used */
+#if __BITS_PER_LONG == 64
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
+#else
 	long	ru_maxrss;		/* maximum resident set size */
 	long	ru_ixrss;		/* integral shared memory size */
 	long	ru_idrss;		/* integral unshared data size */
@@ -37,11 +53,17 @@ struct	rusage {
 	long	ru_nsignals;		/* signals received */
 	long	ru_nvcsw;		/* voluntary context switches */
 	long	ru_nivcsw;		/* involuntary " */
+#endif
 };
 
 struct rlimit {
-	unsigned long	rlim_cur;
-	unsigned long	rlim_max;
+#if __BITS_PER_LONG == 64
+	__kernel_ulong_t	rlim_cur;
+	__kernel_ulong_t	rlim_max;
+#else
+	unsigned long		rlim_cur;
+	unsigned long		rlim_max;
+#endif
 };
 
 #define RLIM64_INFINITY		(~0ULL)
-- 
1.8.4.2


--qMm9M+Fa2AknHoGS--
