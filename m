Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaKPWBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:25 -0500
Received: from 1wt.eu ([62.212.114.60]:47979 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaKPWBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:23 -0500
Message-Id: <20141116215328.857299108@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 05/48] MIPS: asm: thread_info: Add _TIF_SECCOMP flag
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

Add _TIF_SECCOMP flag to _TIF_WORK_SYSCALL_ENTRY to indicate
that the system call needs to be checked against a seccomp filter.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Reviewed-by: Paul Burton <paul.burton@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/6405/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
(cherry picked from commit 137f7df8cead00688524c82360930845396b8a21)
[wt: fixes CVE-2014-4157 - no _TIF_NOHZ nor _TIF_SYSCALL_TRACEPOINT in 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/mips/include/asm/thread_info.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 2ef1662..b0e25eb 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -145,7 +145,8 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define _TIF_FPUBOUND		(1<<TIF_FPUBOUND)
 #define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
 
-#define _TIF_WORK_SYSCALL_ENTRY	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT)
+#define _TIF_WORK_SYSCALL_ENTRY	(_TIF_SYSCALL_TRACE | \
+				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
-- 
1.7.12.2.21.g234cd45.dirty



