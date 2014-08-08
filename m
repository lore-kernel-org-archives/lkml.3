Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbaHHVpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:45:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537AbaHHVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 19/26] sparc: Hook up renameat2 syscall.
Date: Fri,  8 Aug 2014 14:35:26 -0700
Message-Id: <20140808213414.469901345@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213413.648794968@linuxfoundation.org>
References: <20140808213413.648794968@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 26053926feb1c16ade9c30bc7443bf28d829d08e ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/uapi/asm/unistd.h |    3 ++-
 arch/sparc/kernel/sys32.S            |    1 +
 arch/sparc/kernel/systbls_32.S       |    1 +
 arch/sparc/kernel/systbls_64.S       |    2 ++
 4 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/sparc/include/uapi/asm/unistd.h
+++ b/arch/sparc/include/uapi/asm/unistd.h
@@ -410,8 +410,9 @@
 #define __NR_finit_module	342
 #define __NR_sched_setattr	343
 #define __NR_sched_getattr	344
+#define __NR_renameat2		345
 
-#define NR_syscalls		345
+#define NR_syscalls		346
 
 /* Bitmask values returned from kern_features system call.  */
 #define KERN_FEATURE_MIXED_MODE_STACK	0x00000001
--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -48,6 +48,7 @@ SIGN1(sys32_futex, compat_sys_futex, %o1
 SIGN1(sys32_recvfrom, compat_sys_recvfrom, %o0)
 SIGN1(sys32_recvmsg, compat_sys_recvmsg, %o0)
 SIGN1(sys32_sendmsg, compat_sys_sendmsg, %o0)
+SIGN2(sys32_renameat2, sys_renameat2, %o0, %o2)
 
 	.globl		sys32_mmap2
 sys32_mmap2:
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -86,3 +86,4 @@ sys_call_table:
 /*330*/	.long sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
 /*335*/	.long sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.long sys_ni_syscall, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
+/*345*/	.long sys_renameat2
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -87,6 +87,7 @@ sys_call_table32:
 /*330*/	.word compat_sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, compat_sys_open_by_handle_at, compat_sys_clock_adjtime
 	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
+	.word sys32_renameat2
 
 #endif /* CONFIG_COMPAT */
 
@@ -165,3 +166,4 @@ sys_call_table:
 /*330*/	.word sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
+	.word sys_renameat2


