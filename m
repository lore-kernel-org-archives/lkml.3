Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513Ab3HNVih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:38:37 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:58713 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760464Ab3HNViC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:38:02 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: behanw@converseincode.com, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, charlebm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: LLVMLinux: Change "extern inline" to "gnu_inline" in ARM ftrace.h
Date: Wed, 14 Aug 2013 17:37:41 -0400
Message-Id: <1376516261-2071-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376516261-2071-1-git-send-email-behanw@converseincode.com>
References: <1376516261-2071-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

With compilers which follow the C99 standard (like modern versions of gcc and
clang), "extern inline" does the wrong thing (emits code for an externally
linkable version of the inline function). In this case using the gnu_inline
attribute makes inline do the right thing on gcc and on clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm/include/asm/ftrace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index f89515a..fb7fdc4 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -45,7 +45,8 @@ void *return_address(unsigned int);
 
 #else
 
-extern inline void *return_address(unsigned int level)
+extern inline __attribute__((gnu_inline))
+void *return_address(unsigned int level)
 {
 	return NULL;
 }
-- 
1.8.1.2

