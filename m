Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3A0Mue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:50:34 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:52341 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A0Muc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:50:32 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] arch: avr32: add dummy syscalls
Date: Sun, 27 Jan 2013 13:50:15 +0100
Message-Id: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dummy syscalls so that compiling
for this architecture does not provoke warnings when
checksyscalls.sh is called.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/avr32/include/asm/unistd.h      |  2 +-
 arch/avr32/include/uapi/asm/unistd.h | 29 +++++++++++++++++++++++++++++
 arch/avr32/kernel/syscall_table.S    | 29 +++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/avr32/include/asm/unistd.h b/arch/avr32/include/asm/unistd.h
index 0bdf637..570c100 100644
--- a/arch/avr32/include/asm/unistd.h
+++ b/arch/avr32/include/asm/unistd.h
@@ -10,7 +10,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define NR_syscalls		284
+#define NR_syscalls		312
 
 /* Old stuff */
 #define __IGNORE_uselib
diff --git a/arch/avr32/include/uapi/asm/unistd.h b/arch/avr32/include/uapi/asm/unistd.h
index 3eaa687..51c0e76 100644
--- a/arch/avr32/include/uapi/asm/unistd.h
+++ b/arch/avr32/include/uapi/asm/unistd.h
@@ -301,5 +301,34 @@
 #define __NR_eventfd		281
 #define __NR_setns		283
 
+#define __NR_epoll_create1	285
+#define __NR_pread64		286
+#define __NR_pwrite64		286
+#define __NR_timerfd_create	287
+#define __NR_fallocate		288
+#define __NR_timerfd_settime	289
+#define __NR_timerfd_gettime	290
+#define __NR_signalfd4		291
+#define __NR_eventfd2		292
+#define __NR_dup3		293
+#define __NR_pipe2		294
+#define __NR_inotify_init1	295
+#define __NR_preadv		296
+#define __NR_pwritev		297
+#define __NR_rt_tgsigqueueinfo	298
+#define __NR_perf_event_open	299
+#define __NR_recvmmsg		300
+#define __NR_fanotify_init	301
+#define __NR_fanotify_mark	302
+#define __NR_prlimit64		303
+#define __NR_name_to_handle_at	304
+#define __NR_open_by_handle_at	305
+#define __NR_clock_adjtime	306
+#define __NR_syncfs		307
+#define __NR_sendmmsg		308
+#define __NR_process_vm_readv	309
+#define __NR_process_vm_writev	310
+#define __NR_kcmp		311
+#define __NR_finit_module	312
 
 #endif /* _UAPI__ASM_AVR32_UNISTD_H */
diff --git a/arch/avr32/kernel/syscall_table.S b/arch/avr32/kernel/syscall_table.S
index f27bb87..6ad2330 100644
--- a/arch/avr32/kernel/syscall_table.S
+++ b/arch/avr32/kernel/syscall_table.S
@@ -298,3 +298,32 @@ sys_call_table:
 	.long	sys_recvmmsg
 	.long	sys_setns
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
+	.long	sys_epoll_create1	/* 285 */
+	.long	sys_pread64
+	.long	sys_pwrite64
+	.long	sys_timerfd_create
+	.long	sys_fallocate
+	.long	sys_timerfd_settime
+	.long	sys_timerfd_gettime /* 290 */
+	.long	sys_signalfd4
+	.long	sys_eventfd2
+	.long	sys_dup3
+	.long	sys_pipe2
+	.long	sys_inotify_init1 /* 295 */
+	.long	sys_preadv
+	.long	sys_pwritev
+	.long	sys_rt_tgsigqueueinfo
+	.long	sys_perf_event_open
+	.long	sys_recvmmsg /* 300 */
+	.long	sys_fanotify_init
+	.long	sys_fanotify_mark
+	.long	sys_prlimit64
+	.long	sys_name_to_handle_at
+	.long	sys_open_by_handle_at /* 305 */
+	.long	sys_clock_adjtime
+	.long	sys_syncfs
+	.long	sys_sendmmsg
+	.long	sys_process_vm_readv
+	.long	sys_process_vm_writev /* 310 */
+	.long	sys_kcmp
+	.long	sys_finit_module
-- 
1.7.11.7

