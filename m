Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3DVBLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:11:49 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:42368 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3DVBLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:11:48 -0400
Message-ID: <51748E45.8060806@gmail.com>
Date: Mon, 22 Apr 2013 09:11:33 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        tytso@mit.edu, Jan Kara <jack@suse.cz>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH V1] fs/buffer.c: Remove unnecessary init operation after,
 allocating buffer_head.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because alloc 'struct buffer_head' using kmem_cache_zalloc,so it doesn't
need to call 'init_buffer(bh, NULL, NULL)' and other set-zero-operation.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/buffer.c       | 2 --
 fs/jbd/journal.c  | 2 --
 fs/jbd2/journal.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b4dcb34..52b7739 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -865,8 +865,6 @@ try_again:
 
         /* Link the buffer to its page */
         set_bh_page(bh, page, offset);
-
-        init_buffer(bh, NULL, NULL);
     }
     return head;
 /*
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 81cc7ea..865c430 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -310,8 +310,6 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 
     new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
     /* keep subsequent assertions sane */
-    new_bh->b_state = 0;
-    init_buffer(new_bh, NULL, NULL);
     atomic_set(&new_bh->b_count, 1);
     new_jh = journal_add_journal_head(new_bh);    /* This sleeps */
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index ed10991..8b220f1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -367,8 +367,6 @@ retry_alloc:
     }
 
     /* keep subsequent assertions sane */
-    new_bh->b_state = 0;
-    init_buffer(new_bh, NULL, NULL);
     atomic_set(&new_bh->b_count, 1);
     new_jh = jbd2_journal_add_journal_head(new_bh);    /* This sleeps */
 
-- 
1.8.2.rc2.4.g7799588

