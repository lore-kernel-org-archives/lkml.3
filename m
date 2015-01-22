Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbbAVCZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:25:51 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:63084 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbbAVCZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:25:44 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Joe Perches <joe@perches.com>,
        Petr Mladek <pmladek@suse.cz>,
        =?UTF-8?q?Simon=20K=C3=A5gstr=C3=B6m?= 
	<simon.kagstrom@netinsight.net>,
        Borislav Petkov <bp@suse.de>, Dan Streetman <ddstreet@ieee.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org (open list)
Cc: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 1/2] printk: Add dummy routine for when CONFIG_PRINTK=n
Date: Wed, 21 Jan 2015 21:26:08 -0500
Message-Id: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
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
index aeb9d7f..baa3f97 100644
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
@@ -163,6 +160,8 @@ extern int kptr_restrict;
 
 extern void wake_up_klogd(void);
 
+char *log_buf_addr_get(void);
+u32 log_buf_len_get(void);
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 void dump_stack_set_arch_desc(const char *fmt, ...);
@@ -198,6 +197,16 @@ static inline void wake_up_klogd(void)
 {
 }
 
+static inline char *log_buf_addr_get(void)
+{
+	return NULL;
+}
+
+static inline u32 log_buf_len_get(void)
+{
+	return 0;
+}
+
 static inline void log_buf_kexec_setup(void)
 {
 }
-- 
1.9.1

