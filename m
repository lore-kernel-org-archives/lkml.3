Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030248AbaDKK2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:28:42 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53592 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161AbaDKK0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:26:25 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 12/15] s390: add renameat2 syscall
Date: Fri, 11 Apr 2014 12:25:48 +0200
Message-Id: <1397211951-20549-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/uapi/asm/unistd.h | 3 ++-
 arch/s390/kernel/compat_wrapper.c   | 1 +
 arch/s390/kernel/syscalls.S         | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 57194268fe63..3802d2d3a18d 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -282,7 +282,8 @@
 #define __NR_finit_module	344
 #define __NR_sched_setattr	345
 #define __NR_sched_getattr	346
-#define NR_syscalls 347
+#define __NR_renameat2		347
+#define NR_syscalls 348
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.c b/arch/s390/kernel/compat_wrapper.c
index 824c39dfddfc..030051840ccd 100644
--- a/arch/s390/kernel/compat_wrapper.c
+++ b/arch/s390/kernel/compat_wrapper.c
@@ -213,3 +213,4 @@ COMPAT_SYSCALL_WRAP5(kcmp, pid_t, pid1, pid_t, pid2, int, type, unsigned long, i
 COMPAT_SYSCALL_WRAP3(finit_module, int, fd, const char __user *, uargs, int, flags);
 COMPAT_SYSCALL_WRAP3(sched_setattr, pid_t, pid, struct sched_attr __user *, attr, unsigned int, flags);
 COMPAT_SYSCALL_WRAP4(sched_getattr, pid_t, pid, struct sched_attr __user *, attr, unsigned int, size, unsigned int, flags);
+COMPAT_SYSCALL_WRAP5(renameat2, int, olddfd, const char __user *, oldname, int, newdfd, const char __user *, newname, unsigned int, flags);
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 542ef488bac1..fe5cdf29a001 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -355,3 +355,4 @@ SYSCALL(sys_kcmp,sys_kcmp,compat_sys_kcmp)
 SYSCALL(sys_finit_module,sys_finit_module,compat_sys_finit_module)
 SYSCALL(sys_sched_setattr,sys_sched_setattr,compat_sys_sched_setattr) /* 345 */
 SYSCALL(sys_sched_getattr,sys_sched_getattr,compat_sys_sched_getattr)
+SYSCALL(sys_renameat2,sys_renameat2,compat_sys_renameat2)
-- 
1.8.1.4

