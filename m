Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaAUFRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:17:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaAUFQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:16:32 -0500
Date: Mon, 20 Jan 2014 21:16:22 -0800
From: "tip-bot for H.J. Lu" <tipbot@zytor.com>
Message-ID: <tip-386916598e901e406c1f1fc801ade2646a1e8137@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1388182464-28428-7-git-send-email-hjl.tools@gmail.com>
References: <1388182464-28428-7-git-send-email-hjl.tools@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x86, uapi, x32:
  Use __kernel_ulong_t in x86 struct semid64_ds
Git-Commit-ID: 386916598e901e406c1f1fc801ade2646a1e8137
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 20 Jan 2014 21:16:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  386916598e901e406c1f1fc801ade2646a1e8137
Gitweb:     http://git.kernel.org/tip/386916598e901e406c1f1fc801ade2646a1e8137
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Fri, 27 Dec 2013 14:14:22 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Jan 2014 14:45:13 -0800

x86, uapi, x32: Use __kernel_ulong_t in x86 struct semid64_ds

Both x32 and x86-64 use the same struct semid64_ds for system calls.
But x32 long is 32-bit. This patch replaces unsigned long with
__kernel_ulong_t in x86 struct semid64_ds.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1388182464-28428-7-git-send-email-hjl.tools@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
