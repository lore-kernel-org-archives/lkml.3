Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaDVHLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:11:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43002 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaDVHGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:06:24 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-arm-kernel@lists.infradead.org>, <mszeredi@suse.cz>,
        <tytso@mit.edu>
Subject: [PATCH] ARM: Wire up the renameat2() syscall
Date: Tue, 22 Apr 2014 10:05:38 +0300
Message-ID: <1398150338-23475-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new renameat2() system call was only wired up for ARM causing:
 CALL    /home/ujfalusi/work/kernel/kernel.org-next-linux-next/scripts/checksyscalls.sh
<stdin>:1232:2: warning: #warning syscall renameat2 not implemented [-Wcpp]

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi,

I have noticed this with linux-next.

Regards,
Peter

 arch/arm/include/uapi/asm/unistd.h | 1 +
 arch/arm/kernel/calls.S            | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
index fb5584d0cc05..ba94446c72d9 100644
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -408,6 +408,7 @@
 #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
 #define __NR_sched_setattr		(__NR_SYSCALL_BASE+380)
 #define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
+#define __NR_renameat2			(__NR_SYSCALL_BASE+382)
 
 /*
  * This may need to be greater than __NR_last_syscall+1 in order to
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 166e945de832..8f51bdcdacbb 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -391,6 +391,7 @@
 		CALL(sys_finit_module)
 /* 380 */	CALL(sys_sched_setattr)
 		CALL(sys_sched_getattr)
+		CALL(sys_renameat2)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
-- 
1.9.2

