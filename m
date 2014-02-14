Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaBNQtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:49:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbaBNQtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:49:07 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 3/5] printk: Add comment about tricky check for text buffer size
Date: Fri, 14 Feb 2014 17:47:34 +0100
Message-Id: <1392396456-19236-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
References: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no check for potential "text_len" overflow. It is not needed
because only valid level is detected. It took me some time to understand why.
It would deserve a comment ;-)

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 54a4439d021c..bc6eed48a454 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1562,6 +1562,11 @@ asmlinkage int vprintk_emit(int facility, int level,
 			case 'd':	/* KERN_DEFAULT */
 				lflags |= LOG_PREFIX;
 			}
+			/*
+			 * No need to check length here because vscnprintf
+			 * put '\0' at the end of the string. Only valid and
+			 * newly printed level is detected.
+			 */
 			text_len -= end_of_header - text;
 			text = (char *)end_of_header;
 		}
-- 
1.8.4

