Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3CBLfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 06:35:34 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:56207 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3CBLfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 06:35:33 -0500
Date: Sat, 2 Mar 2013 12:35:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] compat: restore timerfd_settime and timerfd_gettime compat
Message-ID: <20130302113528.GA3467@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030211-1948-0000-0000-000004717853
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 16f8402d45de11a1699ca584a6605806fe60bfc5 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Sat, 2 Mar 2013 12:26:30 +0100
Subject: [PATCH] compat: restore timerfd settime and gettime compat syscalls

Both compat syscalls got lost with 9d94b9e2 "switch timerfd compat syscalls
to COMPAT_SYSCALL_DEFINE" because of a typo:
COMPAT instead of CONFIG_COMPAT.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/timerfd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 0e606b1..32b644f 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -383,10 +383,10 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
 	return copy_to_user(otmr, &kotmr, sizeof(kotmr)) ? -EFAULT: 0;
 }
 
-#ifdef COMPAT
+#ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
-		const struct itimerspec __user *, utmr,
-		struct itimerspec __user *, otmr)
+		const struct compat_itimerspec __user *, utmr,
+		struct compat_itimerspec __user *, otmr)
 {
 	struct itimerspec new, old;
 	int ret;
@@ -402,12 +402,12 @@ COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 }
 
 COMPAT_SYSCALL_DEFINE2(timerfd_gettime, int, ufd,
-		struct itimerspec __user *, otmr)
+		struct compat_itimerspec __user *, otmr)
 {
 	struct itimerspec kotmr;
 	int ret = do_timerfd_gettime(ufd, &kotmr);
 	if (ret)
 		return ret;
-	return put_compat_itimerspec(otmr, &t) ? -EFAULT: 0;
+	return put_compat_itimerspec(otmr, &kotmr) ? -EFAULT: 0;
 }
 #endif
-- 
1.7.12.4

