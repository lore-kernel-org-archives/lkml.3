Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaGJNB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:01:59 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38230 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaGJNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:01:26 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        pmladek@suse.cz, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] printk: rename DEFAULT_MESSAGE_LOGLEVEL
Date: Thu, 10 Jul 2014 08:01:21 -0500
Message-Id: <1404997284-20844-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404997284-20844-1-git-send-email-elder@linaro.org>
References: <1404997284-20844-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:
    a8fe19eb kernel/printk: use symbolic defines for console loglevels
makes consistent use of symbolic values for printk() log levels.

The naming scheme used is different from the one used for
DEFAULT_MESSAGE_LOGLEVEL though.  Change that symbol name to be
MESSAGE_LOGLEVEL_DEFAULT for consistency.  And because the value
of that symbol comes from a similarly-named config option, rename
CONFIG_DEFAULT_MESSAGE_LOGLEVEL as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 include/linux/printk.h | 2 +-
 kernel/printk/printk.c | 2 +-
 lib/Kconfig.debug      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 319ff7e..0990997 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -31,7 +31,7 @@ static inline const char *printk_skip_level(const char *buffer)
 }
 
 /* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
+#define MESSAGE_LOGLEVEL_DEFAULT CONFIG_MESSAGE_LOGLEVEL_DEFAULT
 
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
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa..fd939e1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -15,7 +15,7 @@ config PRINTK_TIME
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
-config DEFAULT_MESSAGE_LOGLEVEL
+config MESSAGE_LOGLEVEL_DEFAULT
 	int "Default message log level (1-7)"
 	range 1 7
 	default "4"
-- 
1.9.1

