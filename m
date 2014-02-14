Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaBNQs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:48:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbaBNQs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:48:27 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/5] printk: Remove duplicated check for log level
Date: Fri, 14 Feb 2014 17:47:32 +0100
Message-Id: <1392396456-19236-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
References: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for the exact log level is already done in printk_get_level.
We do not need to duplicate it in printk_skip_level.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 include/linux/printk.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index fa47e2708c01..8860575899f2 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -24,13 +24,9 @@ static inline int printk_get_level(const char *buffer)
 
 static inline const char *printk_skip_level(const char *buffer)
 {
-	if (printk_get_level(buffer)) {
-		switch (buffer[1]) {
-		case '0' ... '7':
-		case 'd':	/* KERN_DEFAULT */
-			return buffer + 2;
-		}
-	}
+	if (printk_get_level(buffer))
+		return buffer + 2;
+
 	return buffer;
 }
 
-- 
1.8.4

