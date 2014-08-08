Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbaHHVZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:25:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40836 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440AbaHHUub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Cross <ccross@android.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 084/259] arm64: implement TASK_SIZE_OF
Date: Fri,  8 Aug 2014 13:38:27 -0700
Message-Id: <1407530482-4483-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit fa2ec3ea10bd377f9d55772b1dab65178425a1a2 upstream.

include/linux/sched.h implements TASK_SIZE_OF as TASK_SIZE if it
is not set by the architecture headers.  TASK_SIZE uses the
current task to determine the size of the virtual address space.
On a 64-bit kernel this will cause reading /proc/pid/pagemap of a
64-bit process from a 32-bit process to return EOF when it reads
past 0xffffffff.

Implement TASK_SIZE_OF exactly the same as TASK_SIZE with
test_tsk_thread_flag instead of test_thread_flag.

Signed-off-by: Colin Cross <ccross@android.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/memory.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 3776217..acc3efa 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -56,6 +56,8 @@
 #define TASK_SIZE_32		UL(0x100000000)
 #define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
 				TASK_SIZE_32 : TASK_SIZE_64)
+#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
+				TASK_SIZE_32 : TASK_SIZE_64)
 #else
 #define TASK_SIZE		TASK_SIZE_64
 #endif /* CONFIG_COMPAT */
-- 
1.9.1

