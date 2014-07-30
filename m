Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaG3X5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:57:53 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63656 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaG3X5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:57:50 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        k.khlebnikov@samsung.com, olof@lixom.net, peterz@infradead.org,
        takahiro.akashi@linaro.org, tglx@linutronix.de, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dwmw2@infradead.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH 3/4] arm64: LLVMLinux: Calculate current_thread_info from current_stack_pointer
Date: Wed, 30 Jul 2014 16:57:28 -0700
Message-Id: <1406764649-20326-4-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
References: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the global current_stack_pointer to get the value of the stack pointer.
This change supports being able to compile the kernel with both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon M??ller <dl9pf@gmx.de>
---
 arch/arm64/include/asm/thread_info.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index e6b6094..c2432d2 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -80,8 +80,8 @@ static inline struct thread_info *current_thread_info(void) __attribute_const__;
 
 static inline struct thread_info *current_thread_info(void)
 {
-	register unsigned long sp asm ("sp");
-	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
+	return (struct thread_info *) \
+		(current_stack_pointer & ~(THREAD_SIZE - 1));
 }
 
 #define thread_saved_pc(tsk)	\
-- 
1.9.1

