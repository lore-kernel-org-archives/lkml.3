Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBNQtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:49:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbaBNQts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:49:48 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 5/5] printk: Do not compute the size of the message twice
Date: Fri, 14 Feb 2014 17:47:36 +0100
Message-Id: <1392396456-19236-6-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
References: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a tiny optimization. It removes duplicate computation of the
message size.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a463707ca88f..9acbb9db1b43 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -351,7 +351,7 @@ static void log_store(int facility, int level,
 	else
 		msg->ts_nsec = local_clock();
 	memset(log_dict(msg) + dict_len, 0, pad_len);
-	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
+	msg->len = size;
 
 	/* insert message */
 	log_next_idx += msg->len;
-- 
1.8.4

