Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaCXF6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 01:58:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54142 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaCXF6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 01:58:40 -0400
From: behanw@converseincode.com
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH v2] arm: LLVMLinux: use static inline in ARM ftrace.h
Date: Sun, 23 Mar 2014 22:58:29 -0700
Message-Id: <1395640709-29042-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140311083107.6aa2bba4@gandalf.local.home>
References: <20140311083107.6aa2bba4@gandalf.local.home>
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

