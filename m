Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaGJFdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:33:08 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38921 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaGJFdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:33:05 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk, mingo@redhat.com, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, Behan Webster <behanw@converseincode.com>
Subject: [PATCH] arm: LLVMLinux: use static inline in ARM ftrace.h
Date: Wed,  9 Jul 2014 22:32:52 -0700
Message-Id: <1404970372-5026-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

With compilers which follow the C99 standard (like modern versions of gcc and
clang), "extern inline" does the wrong thing (emits code for an externally
linkable version of the inline function). In this case using static inline
and removing the NULL version of return_address in return_address.c does
the right thing.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
CC: linux@arm.linux.org.uk
---
 arch/arm/include/asm/ftrace.h    | 2 +-
 arch/arm/kernel/return_address.c | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 39eb16b..bfe2a2f 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -45,7 +45,7 @@ void *return_address(unsigned int);
 
 #else
 
-extern inline void *return_address(unsigned int level)
+static inline void *return_address(unsigned int level)
 {
 	return NULL;
 }
diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index fafedd8..f6aa84d 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -63,11 +63,6 @@ void *return_address(unsigned int level)
 #warning "TODO: return_address should use unwind tables"
 #endif
 
-void *return_address(unsigned int level)
-{
-	return NULL;
-}
-
 #endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) / else */
 
 EXPORT_SYMBOL_GPL(return_address);
-- 
1.9.1

