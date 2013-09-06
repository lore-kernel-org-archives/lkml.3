Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3IFVak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:30:40 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38899 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3IFVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:30:39 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: behanw@converseincode.com, Will Deacon <will.deacon@arm.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Will Drewry <wad@chromium.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/5] arm: LLVMLinux: Add current_stack_pointer macro for ARM
Date: Fri,  6 Sep 2013 17:28:07 -0400
Message-Id: <1378502899-1241-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

A macro to get the current stack pointer which allows for a single place in
which to do so with ASM. Before this named registers (a gcc extension) was used
to get the stack pointer. Using ASM is a more portable way of getting the stack
pointer which works with both gcc and clang.  This macro is of the same name
used in the X86 arch.

Author: Behan Webster <behanw@converseincode.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/arm/include/asm/thread_info.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index df5e13d..94283f8 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -100,6 +100,15 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 /*
+ * how to get the current stack pointer from C
+ */
+#define current_stack_pointer ({ \
+	unsigned long current_sp; \
+	asm ("mov %0, r13" : "=r" (current_sp)); \
+	current_sp; \
+})
+
+/*
  * how to get the thread information struct from C
  */
 static inline struct thread_info *current_thread_info(void) __attribute_const__;
-- 
1.8.1.2

