Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaIFAG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:06:57 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53414 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaIFAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:06:49 -0400
From: behanw@converseincode.com
To: a.ryabinin@samsung.com, anurag19aggarwal@gmail.com, charlebm@gmail.com,
        cl@linux-foundation.org, dave.long@linaro.org,
        k.khlebnikov@samsung.com, linux@arm.linux.org.uk,
        linyongting@gmail.com, Nikolay.Borisov@arm.com, tglx@linutronix.de,
        tj@kernel.org, u.kleine-koenig@pengutronix.de
Cc: behanw@converseincode.com, Dave.Martin@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, rric@kernel.org,
        will.deacon@arm.com
Subject: [PATCH v2 2/7] arm: LLVMLinux: Use current_stack_pointer to calculate pt_regs address
Date: Fri,  5 Sep 2014 17:06:12 -0700
Message-Id: <1409961977-11762-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
References: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the global current_stack_pointer to calculate the end of the stack for
current_pt_regs()

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/arm/include/asm/ptrace.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 601264d..51622ba 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -154,9 +154,8 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 	return regs->ARM_sp;
 }
 
-#define current_pt_regs(void) ({				\
-	register unsigned long sp asm ("sp");			\
-	(struct pt_regs *)((sp | (THREAD_SIZE - 1)) - 7) - 1;	\
+#define current_pt_regs(void) ({ (struct pt_regs *)			\
+		((current_stack_pointer | (THREAD_SIZE - 1)) - 7) - 1;	\
 })
 
 #endif /* __ASSEMBLY__ */
-- 
1.9.1

