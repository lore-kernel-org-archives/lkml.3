Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaBUEpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:45:03 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48971 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaBUEpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:45:01 -0500
From: behanw@converseincode.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, oleg@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] x86: LLVMLinux: Reimplement current_stack_pointer without register usage.
Date: Thu, 20 Feb 2014 20:44:42 -0800
Message-Id: <1392957882-24105-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use asm to make the globally named register work again for gcc and clang.
Much more efficient than copying the stack pointer to a variable and back again.

Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/x86/include/asm/thread_info.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e1940c0..e27ccc1 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -163,10 +163,10 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-#define current_stack_pointer ({		\
-	unsigned long sp;			\
-	asm("mov %%esp,%0" : "=g" (sp));	\
-	sp;					\
+#define current_stack_pointer ({			\
+	register unsigned long sp asm("esp") __used;	\
+	asm("" : "=r" (sp));				\
+	sp;						\
 })
 
 /* how to get the thread information struct from C */
-- 
1.8.3.2

