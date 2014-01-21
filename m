Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaAUFRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:17:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaAUFQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:16:44 -0500
Date: Mon, 20 Jan 2014 21:16:31 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-f8dcdf0130d3ba34f8f7531af7c45616efe1e32e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1388182464-28428-8-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-8-git-send-email-hjl.tools@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] uapi: Use __kernel_ulong_t in shmid64_ds/shminfo64/
 shm_info
Git-Commit-ID: f8dcdf0130d3ba34f8f7531af7c45616efe1e32e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 21:16:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8dcdf0130d3ba34f8f7531af7c45616efe1e32e
Gitweb:     http://git.kernel.org/tip/f8dcdf0130d3ba34f8f7531af7c45616efe1e32e
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Fri, 27 Dec 2013 14:14:23 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Jan 2014 14:45:25 -0800

uapi: Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info

Both x32 and x86-64 use the same struct shmid64_ds/shminfo64/shm_info for
system calls.  But x32 long is 32-bit. This patch replaces unsigned long
with __kernel_ulong_t in struct shmid64_ds/shminfo64/shm_info.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1388182464-28428-8-git-send-email-hjl.tools@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/uapi/asm-generic/shmbuf.h | 24 ++++++++++++------------
 include/uapi/linux/shm.h          | 10 +++++-----
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/uapi/asm-generic/shmbuf.h b/include/uapi/asm-generic/shmbuf.h
index 5768fa6..7e9fb2f 100644
--- a/include/uapi/asm-generic/shmbuf.h
+++ b/include/uapi/asm-generic/shmbuf.h
@@ -39,21 +39,21 @@ struct shmid64_ds {
 #endif
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
 	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
+	__kernel_ulong_t	shm_nattch;	/* no. of current attaches */
+	__kernel_ulong_t	__unused4;
+	__kernel_ulong_t	__unused5;
 };
 
 struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
+	__kernel_ulong_t	shmmax;
+	__kernel_ulong_t	shmmin;
+	__kernel_ulong_t	shmmni;
+	__kernel_ulong_t	shmseg;
+	__kernel_ulong_t	shmall;
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
+	__kernel_ulong_t	__unused3;
+	__kernel_ulong_t	__unused4;
 };
 
 #endif /* __ASM_GENERIC_SHMBUF_H */
diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index ec36fa1..78b6941 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -68,11 +68,11 @@ struct	shminfo {
 
 struct shm_info {
 	int used_ids;
-	unsigned long shm_tot;	/* total allocated shm */
-	unsigned long shm_rss;	/* total resident shm */
-	unsigned long shm_swp;	/* total swapped shm */
-	unsigned long swap_attempts;
-	unsigned long swap_successes;
+	__kernel_ulong_t shm_tot;	/* total allocated shm */
+	__kernel_ulong_t shm_rss;	/* total resident shm */
+	__kernel_ulong_t shm_swp;	/* total swapped shm */
+	__kernel_ulong_t swap_attempts;
+	__kernel_ulong_t swap_successes;
 };
 
 
