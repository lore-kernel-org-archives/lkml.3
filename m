Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaGINF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:05:57 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:62011 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaGINES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:04:18 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        pmladek@suse.cz, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] printk: rename DEFAULT_MESSAGE_LOGLEVEL
Date: Wed,  9 Jul 2014 08:04:13 -0500
Message-Id: <1404911056-29064-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404911056-29064-1-git-send-email-elder@linaro.org>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:
    a8fe19eb kernel/printk: use symbolic defines for console loglevels
makes consistent use of symbolic values for printk() log levels.

The naming scheme used is different from the one used for
DEFAULT_MESSAGE_LOGLEVEL though.  Change that symbol name to be
MESSAGE_LOGLEVEL_DEFAULT for consistency.

Note that we don't rename CONFIG_DEFAULT_MESSAGE_LOGLEVEL (to avoid
breaking existing config files that might reference it).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 include/linux/printk.h | 2 +-
 kernel/printk/printk.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 319ff7e..3d1ccad 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -31,7 +31,7 @@ static inline const char *printk_skip_level(const char *buffer)
 }
 
 /* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
+#define MESSAGE_LOGLEVEL_DEFAULT CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
 /* We show everything that is MORE important than this.. */
 #define CONSOLE_LOGLEVEL_SILENT  0 /* Mum's the word */
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839d..ac2b64e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -56,7 +56,7 @@
 
 int console_printk[4] = {
 	CONSOLE_LOGLEVEL_DEFAULT,	/* console_loglevel */
-	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
+	MESSAGE_LOGLEVEL_DEFAULT,	/* default_message_loglevel */
 	CONSOLE_LOGLEVEL_MIN,		/* minimum_console_loglevel */
 	CONSOLE_LOGLEVEL_DEFAULT,	/* default_console_loglevel */
 };
-- 
1.9.1

