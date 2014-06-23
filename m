Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaFWNIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:08:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbaFWNFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 87/93] MIPS: asm: thread_info: Add _TIF_SECCOMP flag
Date: Mon, 23 Jun 2014 14:03:06 +0100
Message-Id: <1403528592-2163-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 137f7df8cead00688524c82360930845396b8a21 upstream.

Add _TIF_SECCOMP flag to _TIF_WORK_SYSCALL_ENTRY to indicate
that the system call needs to be checked against a seccomp filter.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Reviewed-by: Paul Burton <paul.burton@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/6405/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/include/asm/thread_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 61215a34acc6..897cd58407c8 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -134,7 +134,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_LOAD_WATCH		(1<<TIF_LOAD_WATCH)
 
 #define _TIF_WORK_SYSCALL_ENTRY	(_TIF_NOHZ | _TIF_SYSCALL_TRACE |	\
-				 _TIF_SYSCALL_AUDIT)
+				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	(_TIF_NOHZ | _TIF_SYSCALL_TRACE |	\
-- 
1.9.1

