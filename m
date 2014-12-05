Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbaLEAtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:49:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:44877 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaLEAtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:49:53 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] f2fs: fix missing kmem_cache_free
Date: Thu,  4 Dec 2014 16:49:41 -0800
Message-Id: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes missing kmem_cache_free when handling errors.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b1466cf..c59341d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -158,7 +158,7 @@ retry:
 		head->entry_cnt = 0;
 
 		if (radix_tree_insert(&nm_i->nat_set_root, set, head)) {
-			cond_resched();
+			kmem_cache_free(nat_entry_set_slab, head);
 			goto retry;
 		}
 	}
-- 
2.1.1

