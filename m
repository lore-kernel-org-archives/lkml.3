Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab3BLSXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:23:39 -0500
Received: from mail.tpi.com ([70.99.223.143]:3395 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933551Ab3BLSXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:23:37 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org
Subject: [PATCH linux-next] jbd: start_this_handle(): remove kfree() redundant null check
Date: Tue, 12 Feb 2013 11:23:24 -0700
Message-Id: <1360693404-61617-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch analysis:

fs/jbd/transaction.c:236 start_this_handle() info: redundant null
 check on new_transaction calling kfree()

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/jbd/transaction.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 071d690..ee40b4e 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -232,8 +232,7 @@ repeat_locked:
 
 	lock_map_acquire(&handle->h_lockdep_map);
 out:
-	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
+	kfree(new_transaction);
 	return ret;
 }
 
-- 
1.7.9.5

