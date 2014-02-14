Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaBNQss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:48:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaBNQsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:48:47 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 2/5] printk: Remove obsolete check for log level "c"
Date: Fri, 14 Feb 2014 17:47:33 +0100
Message-Id: <1392396456-19236-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
References: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel log level "c" has been removed in the commit 61e99ab8e35a88b8
(printk: remove the now unnecessary "C" annotation for KERN_CONT). It is not
longer detected in printk_get_level. Hence we do not need to check it in
vprintk_emit.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b1d255f04135..54a4439d021c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1561,8 +1561,6 @@ asmlinkage int vprintk_emit(int facility, int level,
 					level = kern_level - '0';
 			case 'd':	/* KERN_DEFAULT */
 				lflags |= LOG_PREFIX;
-			case 'c':	/* KERN_CONT */
-				break;
 			}
 			text_len -= end_of_header - text;
 			text = (char *)end_of_header;
-- 
1.8.4

