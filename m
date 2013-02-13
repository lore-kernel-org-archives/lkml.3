Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097Ab3BMO1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:27:00 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:57999 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3BMO07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:26:59 -0500
From: Mikhail Gruzdev <michail.gruzdev@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mikhail Gruzdev <michail.gruzdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RESEND] printk: add pr_devel_once and pr_devel_ratelimited
Date: Wed, 13 Feb 2013 18:26:23 +0400
Message-Id: <1360765583-27802-1-git-send-email-michail.gruzdev@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize pr_devel logging macros family by adding pr_devel_once and
pr_devel_ratelimited.

Signed-off-by: Mikhail Gruzdev <michail.gruzdev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/printk.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..f282149 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -255,6 +255,15 @@ extern void dump_stack(void) __cold;
 	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_cont_once(fmt, ...)					\
 	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
+
+#if defined(DEBUG)
+#define pr_devel_once(fmt, ...)					\
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel_once(fmt, ...)					\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_once(fmt, ...)					\
@@ -298,6 +307,15 @@ extern void dump_stack(void) __cold;
 #define pr_info_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
+
+#if defined(DEBUG)
+#define pr_devel_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel_ratelimited(fmt, ...)					\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
-- 
1.7.3.4

