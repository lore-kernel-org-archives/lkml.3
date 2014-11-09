Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaKIQ0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 11:26:13 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57432 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaKIQ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 11:26:11 -0500
From: Faisal Abbas <90.abbasfaisal@gmail.com>
To: dhowells@redhat.com, fabf@skynet.be
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] FRV: Wire up new syscalls
Date: Sun,  9 Nov 2014 21:26:03 +0500
Message-Id: <1415550363-6172-1-git-send-email-90.abbasfaisal@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling source tree for FRV generates following warnings so wire these syscalls up.

<stdin>:1187:2: warning: #warning syscall recvmmsg not implemented [-Wcpp]
<stdin>:1190:2: warning: #warning syscall fanotify_init not implemented [-Wcpp]
<stdin>:1193:2: warning: #warning syscall fanotify_mark not implemented [-Wcpp]
<stdin>:1196:2: warning: #warning syscall prlimit64 not implemented [-Wcpp]
<stdin>:1199:2: warning: #warning syscall name_to_handle_at not implemented [-Wcpp]
<stdin>:1202:2: warning: #warning syscall open_by_handle_at not implemented [-Wcpp]
<stdin>:1205:2: warning: #warning syscall clock_adjtime not implemented [-Wcpp]
<stdin>:1208:2: warning: #warning syscall syncfs not implemented [-Wcpp]
<stdin>:1211:2: warning: #warning syscall sendmmsg not implemented [-Wcpp]
<stdin>:1217:2: warning: #warning syscall process_vm_readv not implemented [-Wcpp]
<stdin>:1220:2: warning: #warning syscall process_vm_writev not implemented [-Wcpp]
<stdin>:1223:2: warning: #warning syscall kcmp not implemented [-Wcpp]
<stdin>:1226:2: warning: #warning syscall finit_module not implemented [-Wcpp]
<stdin>:1229:2: warning: #warning syscall sched_setattr not implemented [-Wcpp]
<stdin>:1232:2: warning: #warning syscall sched_getattr not implemented [-Wcpp]
<stdin>:1235:2: warning: #warning syscall renameat2 not implemented [-Wcpp]
<stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcpp]
<stdin>:1241:2: warning: #warning syscall getrandom not implemented [-Wcpp]
<stdin>:1244:2: warning: #warning syscall memfd_create not implemented [-Wcpp]
<stdin>:1247:2: warning: #warning syscall bpf not implemented [-Wcpp]

Signed-off-by: Faisal Abbas <90.abbasfaisal@gmail.com>
---
 arch/frv/include/asm/unistd.h      |    2 +-
 arch/frv/include/uapi/asm/unistd.h |   20 ++++++++++++++++++++
 arch/frv/kernel/entry.S            |   22 +++++++++++++++++++++-
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index 17b5df8..a7f3488 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -4,7 +4,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls 338
+#define NR_syscalls 358
 
 /* #define __ARCH_WANT_OLD_READDIR */
 #define __ARCH_WANT_OLD_STAT
diff --git a/arch/frv/include/uapi/asm/unistd.h b/arch/frv/include/uapi/asm/unistd.h
index 9e2612f..0549798 100644
--- a/arch/frv/include/uapi/asm/unistd.h
+++ b/arch/frv/include/uapi/asm/unistd.h
@@ -344,5 +344,25 @@
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
 #define __NR_setns		337
+#define __NR_recvmmsg		338
+#define __NR_fanotify_init	339
+#define __NR_fanotify_mark	340
+#define __NR_prlimit64		341
+#define __NR_name_to_handle_at	342
+#define __NR_open_by_handle_at	343
+#define __NR_clock_adjtime	344
+#define __NR_syncfs		345
+#define __NR_sendmmsg		346
+#define __NR_process_vm_readv	347
+#define __NR_process_vm_writev	348
+#define __NR_kcmp		349
+#define __NR_finit_module	350
+#define __NR_sched_setattr	351
+#define __NR_sched_getattr	352
+#define __NR_renameat2		353
+#define __NR_seccomp		354
+#define __NR_getrandom		355
+#define __NR_memfd_create	356
+#define __NR_bpf		357
 
 #endif /* _UAPI_ASM_UNISTD_H_ */
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index dfcd263..66debb5 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1515,5 +1515,25 @@ sys_call_table:
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
 	.long sys_setns
-
+	.long sys_recvmmsg
+	.long sys_fanotify_init
+	.long sys_fanotify_mark
+	.long sys_prlimit64
+	.long sys_name_to_handle_at
+	.long sys_open_by_handle_at
+	.long sys_clock_adjtime
+	.long sys_syncfs
+	.long sys_sendmmsg
+	.long sys_process_vm_readv
+	.long sys_process_vm_writev
+	.long sys_kcmp
+	.long sys_finit_module
+	.long sys_sched_setattr
+	.long sys_sched_getattr
+	.long sys_renameat2
+	.long sys_seccomp
+	.long sys_getrandom
+	.long sys_memfd_create
+	.long sys_bpf
+
 syscall_table_size = (. - sys_call_table)
-- 
1.7.9.5

