Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaCGTKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:10:43 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60608 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCGTKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:10:42 -0500
From: behanw@converseincode.com
To: khali@linux-fr.org, rostedt@goodmis.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] module: LLVMLinux: Remove unused function warning from __param_check macro
Date: Fri,  7 Mar 2014 11:08:47 -0800
Message-Id: <1394219327-5591-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

This code makes a compile time type check that is optimized away. Clang
complains that it generates an unused function.

I believe GCC won't complain for a static inline fuction but would if it
was just a static function.

Adding the unused attribute to the function declaration removes the warning.

This code works for both gcc and clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/linux/moduleparam.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index c3eb102..5ce1f67 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -346,6 +346,7 @@ static inline void destroy_params(const struct kernel_param *params,
 /* The macros to do compile-time type checking stolen from Jakub
    Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
 #define __param_check(name, p, type) \
+	static inline type *__check_##name(void) __attribute__ ((unused)); \
 	static inline type *__check_##name(void) { return(p); }
 
 extern struct kernel_param_ops param_ops_byte;
-- 
1.8.3.2

