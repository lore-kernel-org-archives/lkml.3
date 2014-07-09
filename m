Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaGINEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:04:23 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:48589 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaGINEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:04:20 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        pmladek@suse.cz, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] printk: use a clever macro
Date: Wed,  9 Jul 2014 08:04:15 -0500
Message-Id: <1404911056-29064-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404911056-29064-1-git-send-email-elder@linaro.org>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the IS_ENABLED() macro rather than #ifdef blocks to set certain
global values.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 646146c..6f75e8a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -453,11 +453,7 @@ static int log_store(int facility, int level,
 	return msg->text_len;
 }
 
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
-#else
-int dmesg_restrict;
-#endif
+int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);
 
 static int syslog_action_restricted(int type)
 {
@@ -947,11 +943,7 @@ static inline void boot_delay_msec(int level)
 }
 #endif
 
-#if defined(CONFIG_PRINTK_TIME)
-static bool printk_time = 1;
-#else
-static bool printk_time;
-#endif
+static bool printk_time = IS_ENABLED(CONFIG_PRINTK_TIME);
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
 static size_t print_time(u64 ts, char *buf)
-- 
1.9.1

