Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaG3X5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:57:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46314 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaG3X5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:57:46 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        k.khlebnikov@samsung.com, olof@lixom.net, peterz@infradead.org,
        takahiro.akashi@linaro.org, tglx@linutronix.de, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dwmw2@infradead.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 1/4] arm64: LLVMLinux: Add current_stack_pointer() for arm64
Date: Wed, 30 Jul 2014 16:57:26 -0700
Message-Id: <1406764649-20326-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
References: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Define a global named register for current_stack_pointer. The use of this new
variable guarantees that both gcc and clang can access this register in C code.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
---
 arch/arm64/include/asm/thread_info.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index e40b6d0..e6b6094 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,11 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 /*
+ * how to get the current stack pointer from C
+ */
+register unsigned long current_stack_pointer asm ("sp");
+
+/*
  * how to get the thread information struct from C
  */
 static inline struct thread_info *current_thread_info(void) __attribute_const__;
-- 
1.9.1

