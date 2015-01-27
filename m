Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbbA0QRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:17:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53291 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbA0QRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:17:32 -0500
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Remove newline from trace_printk warning banner
Date: Tue, 27 Jan 2015 17:17:20 +0100
Message-Id: <1422375440-31970-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Remove the output-confusing newline below:

[    0.191328]
**********************************************************
[    0.191493] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.191586] **                                                      **
...

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4a9079b9f082..7a04946ffb06 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2036,7 +2036,7 @@ void trace_printk_init_buffers(void)
 
 	/* trace_printk() is for debug use only. Don't use it in production. */
 
-	pr_warning("\n**********************************************************\n");
+	pr_warning("**********************************************************\n");
 	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
 	pr_warning("**                                                      **\n");
 	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
-- 
2.2.0.33.gc18b867

