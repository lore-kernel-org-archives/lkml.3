Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3GOVwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:52:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50596 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757274Ab3GOVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:51:59 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [v3.11-rc1 PATCH 2/5] printk: Add console_cmdline.h
Date: Mon, 15 Jul 2013 14:51:32 -0700
Message-Id: <ae61248a18b023be52c3df9331b73bfe3219369e.1373922863.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1373922863.git.joe@perches.com>
References: <cover.1373922863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an include file for the console_cmdline struct
so that the braille console driver can be separated.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/console_cmdline.h | 14 ++++++++++++++
 kernel/printk/printk.c          | 12 +++---------
 2 files changed, 17 insertions(+), 9 deletions(-)
 create mode 100644 kernel/printk/console_cmdline.h

diff --git a/kernel/printk/console_cmdline.h b/kernel/printk/console_cmdline.h
new file mode 100644
index 0000000..cbd69d8
--- /dev/null
+++ b/kernel/printk/console_cmdline.h
@@ -0,0 +1,14 @@
+#ifndef _CONSOLE_CMDLINE_H
+#define _CONSOLE_CMDLINE_H
+
+struct console_cmdline
+{
+	char	name[8];			/* Name of the driver	    */
+	int	index;				/* Minor dev. to use	    */
+	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	char	*brl_options;			/* Options for braille driver */
+#endif
+};
+
+#endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cd5a6cf..4e9a982 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -49,6 +49,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#include "console_cmdline.h"
+
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
@@ -103,19 +105,11 @@ static struct console *exclusive_console;
 /*
  *	Array of consoles built from command line options (console=)
  */
-struct console_cmdline
-{
-	char	name[8];			/* Name of the driver	    */
-	int	index;				/* Minor dev. to use	    */
-	char	*options;			/* Options for the driver   */
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	char	*brl_options;			/* Options for braille driver */
-#endif
-};
 
 #define MAX_CMDLINECONSOLES 8
 
 static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
+
 static int selected_console = -1;
 static int preferred_console = -1;
 int console_set_on_cmdline;
-- 
1.8.1.2.459.gbcd45b4.dirty

