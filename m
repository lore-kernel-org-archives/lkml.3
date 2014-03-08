Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaCHCKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:10:35 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57669 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaCHCKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:10:34 -0500
From: behanw@converseincode.com
To: khali@linux-fr.org, rostedt@goodmis.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH v2] module: LLVMLinux: Remove unused function warning from __param_check macro
Date: Fri,  7 Mar 2014 18:10:23 -0800
Message-Id: <1394244623-25623-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <531A73EB.6060403@codeaurora.org>
References: <531A73EB.6060403@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

This code makes a compile time type check that is optimized away. Clang
complains that it generates an unused function.

I believe GCC won't complain for a static inline fuction but would if it
was just a static function.

Adding the unused attribute to the function definition removes the warning.

This code works for both gcc and clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/linux/moduleparam.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index c3eb102..7f2a726 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -346,7 +346,7 @@ static inline void destroy_params(const struct kernel_param *params,
 /* The macros to do compile-time type checking stolen from Jakub
    Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
 #define __param_check(name, p, type) \
-	static inline type *__check_##name(void) { return(p); }
+	static inline __always_unused type *__check_##name(void) { return(p); }
 
 extern struct kernel_param_ops param_ops_byte;
 extern int param_set_byte(const char *val, const struct kernel_param *kp);
-- 
1.8.3.2

