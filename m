Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaIFAGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:06:53 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46237 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaIFAGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:06:47 -0400
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
Subject: [PATCH v2 1/7] arm: LLVMLinux: Add global named register current_stack_pointer for ARM
Date: Fri,  5 Sep 2014 17:06:11 -0700
Message-Id: <1409961977-11762-2-git-send-email-behanw@converseincode.com>
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

Define a global named register for current_stack_pointer. The use of this new
variable guarantees that both gcc and clang can access this register in C code.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
---
 arch/arm/include/asm/thread_info.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index fc44d37..bb43515 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -101,6 +101,11 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 /*
+ * how to get the current stack pointer in C
+ */
+register unsigned long current_stack_pointer asm ("sp");
+
+/*
  * how to get the thread information struct from C
  */
 static inline struct thread_info *current_thread_info(void) __attribute_const__;
-- 
1.9.1

