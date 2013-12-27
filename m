Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3L0WO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:14:56 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:63128 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab3L0WOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:14:35 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 6/8] Use __kernel_ulong_t in x86 struct semid64_ds
Date: Fri, 27 Dec 2013 14:14:22 -0800
Message-Id: <1388182464-28428-7-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct semid64_ds for system calls.
But x32 long is 32-bit. This patch replaces unsigned long with
__kernel_ulong_t in x86 struct semid64_ds.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 arch/x86/include/uapi/asm/sembuf.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sembuf.h b/arch/x86/include/uapi/asm/sembuf.h
index ee50c80..cc2d6a3 100644
--- a/arch/x86/include/uapi/asm/sembuf.h
+++ b/arch/x86/include/uapi/asm/sembuf.h
@@ -13,12 +13,12 @@
 struct semid64_ds {
 	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
 	__kernel_time_t	sem_otime;	/* last semop time */
-	unsigned long	__unused1;
+	__kernel_ulong_t __unused1;
 	__kernel_time_t	sem_ctime;	/* last change time */
-	unsigned long	__unused2;
-	unsigned long	sem_nsems;	/* no. of semaphores in array */
-	unsigned long	__unused3;
-	unsigned long	__unused4;
+	__kernel_ulong_t __unused2;
+	__kernel_ulong_t sem_nsems;	/* no. of semaphores in array */
+	__kernel_ulong_t __unused3;
+	__kernel_ulong_t __unused4;
 };
 
 #endif /* _ASM_X86_SEMBUF_H */
-- 
1.8.4.2

