Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaCYRzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:55:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbaCYRzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:55:15 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/8] printk: Remove outdated comment
Date: Tue, 25 Mar 2014 18:54:54 +0100
Message-Id: <1395770101-24534-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395770101-24534-1-git-send-email-jack@suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment about interesting interlocking between lockbuf_lock and
console_sem is outdated. It was added in 2002 by commit
a880f45a48be2956d2c78a839c472287d54435c1 during conversion of
console_lock to console_sem + lockbuf_lock. At that time
release_console_sem() (today's equivalent is console_unlock()) was
indeed using lockbuf_lock to avoid races between trylock on console_sem
in printk() and unlock of console_sem. However these days the
interlocking is gone and the races are avoided by rechecking logbuf
state after releasing console_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 4dae9cbe9259..bd7ee2a9f960 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -206,8 +206,7 @@ struct printk_log {
 };
 
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters. It is also
- * used in interesting ways to provide interlocking in console_unlock();
+ * The logbuf_lock protects kmsg buffer, indices, counters.
  */
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
-- 
1.8.1.4

