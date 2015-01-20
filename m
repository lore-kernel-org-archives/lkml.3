Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbbATXwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:52:38 -0500
Received: from mail-yk0-f180.google.com ([209.85.160.180]:59040 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbATXwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:52:37 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Joe Perches <joe@perches.com>,
        John Stultz <john.stultz@linaro.org>,
        Dan Streetman <ddstreet@ieee.org>,
        =?UTF-8?q?Simon=20K=C3=A5gstr=C3=B6m?= 
	<simon.kagstrom@netinsight.net>,
        Borislav Petkov <bp@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org (open list)
Cc: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 1/2] printk: Add dummy routine for when CONFIG_PRINTK=n
Date: Tue, 20 Jan 2015 18:51:49 -0500
Message-Id: <1421797911-23650-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are missing dummy routines for log_buf_addr_get() and log_buf_len_get()
for when CONFIG_PRINTK is not set causing build failures.

This patch adds these dummy routines at the appropriate location.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Michael Ellerman <mpe@ellerman.id.au>
---
 include/linux/printk.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index aeb9d7f..f52f02b 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -10,9 +10,6 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-extern char *log_buf_addr_get(void);
-extern u32 log_buf_len_get(void);
-
 static inline int printk_get_level(const char *buffer)
 {
 	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
@@ -168,6 +165,8 @@ void __init setup_log_buf(int early);
 void dump_stack_set_arch_desc(const char *fmt, ...);
 void dump_stack_print_info(const char *log_lvl);
 void show_regs_print_info(const char *log_lvl);
+char *log_buf_addr_get(void);
+u32 log_buf_len_get(void);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -217,6 +216,16 @@ static inline void dump_stack_print_info(const char *log_lvl)
 static inline void show_regs_print_info(const char *log_lvl)
 {
 }
+
+static inline char *log_buf_addr_get(void)
+{
+	return NULL;
+}
+
+static linline u32 log_buf_len_get(void)
+{
+	return 0;
+}
 #endif
 
 extern asmlinkage void dump_stack(void) __cold;
-- 
1.9.1

