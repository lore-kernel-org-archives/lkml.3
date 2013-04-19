Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967869Ab3DSC3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 22:29:44 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42307 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967782Ab3DSC3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:29:42 -0400
Message-ID: <5170AC10.60504@gmail.com>
Date: Fri, 19 Apr 2013 10:29:36 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        tytso@mit.edu
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH] fs/buffer.c: Remove the unnecessary init operation after
 allocating buffer_head.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because alloc struct buffer_head using kmem_cache_zalloc,so it's not need to
call 'init_buffer(bh, NULL, NULL)'.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/buffer.c       | 2 --
 fs/jbd/journal.c  | 1 -
 fs/jbd2/journal.c | 1 -
 3 files changed, 4 deletions(-)

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
index 81cc7ea..0c3fe90 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -311,7 +311,6 @@ int journal_write_metadata_buffer(transaction_t *transaction,
     new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
     /* keep subsequent assertions sane */
     new_bh->b_state = 0;
-    init_buffer(new_bh, NULL, NULL);
     atomic_set(&new_bh->b_count, 1);
     new_jh = journal_add_journal_head(new_bh);    /* This sleeps */
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index ed10991..95120c6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -368,7 +368,6 @@ retry_alloc:
 
     /* keep subsequent assertions sane */
     new_bh->b_state = 0;
-    init_buffer(new_bh, NULL, NULL);
     atomic_set(&new_bh->b_count, 1);
     new_jh = jbd2_journal_add_journal_head(new_bh);    /* This sleeps */
 
-- 
1.8.2.rc2.4.g7799588

