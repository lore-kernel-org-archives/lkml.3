Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaGINEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:04:21 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:52813 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaGINET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:04:19 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        pmladek@suse.cz, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] printk: fix some comments
Date: Wed,  9 Jul 2014 08:04:14 -0500
Message-Id: <1404911056-29064-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404911056-29064-1-git-send-email-elder@linaro.org>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a few comments that don't accurately describe their
corresponding code.  It also fixes some minor typographical errors.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ac2b64e..646146c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -113,9 +113,9 @@ static int __down_trylock_console_sem(unsigned long ip)
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
  * definitely not the perfect debug tool (we don't know if _WE_
- * hold it are racing, but it helps tracking those weird code
- * path in the console code where we end up in places I want
- * locked without the console sempahore held
+ * hold it and are racing, but it helps tracking those weird code
+ * paths in the console code where we end up in places I want
+ * locked without the console sempahore held).
  */
 static int console_locked, console_suspended;
 
@@ -146,8 +146,8 @@ static int console_may_schedule;
  * the overall length of the record.
  *
  * The heads to the first and last entry in the buffer, as well as the
- * sequence numbers of these both entries are maintained when messages
- * are stored..
+ * sequence numbers of these entries are maintained when messages are
+ * stored.
  *
  * If the heads indicate available messages, the length in the header
  * tells the start next message. A length == 0 for the next message
@@ -344,7 +344,7 @@ static int log_make_free_space(u32 msg_size)
 	while (log_first_seq < log_next_seq) {
 		if (logbuf_has_space(msg_size, false))
 			return 0;
-		/* drop old messages until we have enough continuous space */
+		/* drop old messages until we have enough contiguous space */
 		log_first_idx = log_next(log_first_idx);
 		log_first_seq++;
 	}
@@ -1476,7 +1476,7 @@ static struct cont {
 	struct task_struct *owner;	/* task of first print*/
 	u64 ts_nsec;			/* time of first print */
 	u8 level;			/* log level of first message */
-	u8 facility;			/* log level of first message */
+	u8 facility;			/* log facility of first message */
 	enum log_flags flags;		/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
@@ -1881,11 +1881,12 @@ static int __add_preferred_console(char *name, int idx, char *options,
 	return 0;
 }
 /*
- * Set up a list of consoles.  Called from init/main.c
+ * Set up a console.  Called via do_early_param() in init/main.c
+ * for each "console=" parameter in the boot command line.
  */
 static int __init console_setup(char *str)
 {
-	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
+	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for "ttyS" */
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
@@ -2045,8 +2046,8 @@ EXPORT_SYMBOL(console_lock);
 /**
  * console_trylock - try to lock the console system for exclusive use.
  *
- * Tried to acquire a lock which guarantees that the caller has
- * exclusive access to the console system and the console_drivers list.
+ * Try to acquire a lock which guarantees that the caller has exclusive
+ * access to the console system and the console_drivers list.
  *
  * returns 1 on success, and 0 on failure to acquire the lock.
  */
-- 
1.9.1

