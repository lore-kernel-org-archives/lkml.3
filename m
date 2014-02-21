Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBUCXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:23:49 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51732 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaBUCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:23:46 -0500
From: behanw@converseincode.com
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux@arm.linux.org.uk, kpark3469@gmail.com
Cc: keun-o.park@windriver.com, dave.martin@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] arm: LLVMLinux: use static inline in ARM ftrace.h
Date: Thu, 20 Feb 2014 18:22:50 -0800
Message-Id: <1392949370-26422-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
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
---
 arch/arm/include/asm/ftrace.h    | 2 +-
 arch/arm/kernel/return_address.c | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index f89515a..2bb8cac 100644
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
1.8.3.2

