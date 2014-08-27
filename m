Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaH0E3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:29:47 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36171 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaH0E3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:29:44 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        cl@linux-foundation.org, jays.lee@samsung.com,
        k.khlebnikov@samsung.com, larry.bassel@linaro.org, olof@lixom.net,
        peterz@infradead.org, takahiro.akashi@linaro.org, tglx@linutronix.de,
        tj@kernel.org, will.deacon@arm.com
Cc: christoffer.dall@linaro.org, kgene.kim@samsung.com, khilman@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sungjinn.chung@samsung.com, Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2 1/6] arm64: LLVMLinux: Add current_stack_pointer() for arm64
Date: Tue, 26 Aug 2014 21:29:29 -0700
Message-Id: <1409113774-3172-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409113774-3172-1-git-send-email-behanw@converseincode.com>
References: <20140826141608.GT23445@arm.com>
 <1409113774-3172-1-git-send-email-behanw@converseincode.com>
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
Reviewed-by: Olof Johansson <olof@lixom.net>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/thread_info.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 45108d8..356e037 100644
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

