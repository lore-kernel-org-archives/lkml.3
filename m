Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3LYQyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 11:54:06 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:34366 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3LYQyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 11:54:04 -0500
Date: Wed, 25 Dec 2013 08:53:59 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info
Message-ID: <20131225165359.GA29550@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct shmid64_ds/shminfo64/shm_info for
system calls.  But x32 long is 32-bit. This patch replaces unsigned long
with __kernel_ulong_t in struct shmid64_ds/shminfo64/shm_info.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
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
 
 
-- 
1.8.4.2

