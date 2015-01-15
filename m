Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbbAOHEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:04:21 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:45680 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbAOHDq (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 02:03:46 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Jan Kara <jack@suse.cz>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/3] jbd: drop jbd_ENOSYS debug
Date: Wed, 14 Jan 2015 22:59:13 -0800
Message-Id: <1421305154-14788-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1421305154-14788-1-git-send-email-dave@stgolabs.net>
References: <1421305154-14788-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick search shows that there are no users, drop the
macro for both jbd and jbd2.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Jan Kara <jack@suse.cz>
---
My goal here was to just change how we set current state, however
I realized that the function is not used.

 include/linux/jbd.h  | 9 ---------
 include/linux/jbd2.h | 9 ---------
 2 files changed, 18 deletions(-)

diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 31229e0..d326152 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -956,15 +956,6 @@ void __log_wait_for_space(journal_t *journal);
 extern void	__journal_drop_transaction(journal_t *, transaction_t *);
 extern int	cleanup_journal_tail(journal_t *);
 
-/* Debugging code only: */
-
-#define jbd_ENOSYS() \
-do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
-	current->state = TASK_UNINTERRUPTIBLE;			           \
-	schedule();						           \
-} while (1)
-
 /*
  * is_journal_abort
  *
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 704b9a5..20e7f78 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1251,15 +1251,6 @@ void __jbd2_log_wait_for_space(journal_t *journal);
 extern void __jbd2_journal_drop_transaction(journal_t *, transaction_t *);
 extern int jbd2_cleanup_journal_tail(journal_t *);
 
-/* Debugging code only: */
-
-#define jbd_ENOSYS() \
-do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
-	current->state = TASK_UNINTERRUPTIBLE;			           \
-	schedule();						           \
-} while (1)
-
 /*
  * is_journal_abort
  *
-- 
2.1.2

