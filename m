Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab3BLSSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:18:15 -0500
Received: from mail.tpi.com ([70.99.223.143]:3203 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933398Ab3BLSSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:18:14 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>
Subject: [PATCH linux-next] hugetlbfs: hugetlbfs_fill_super(): remove kfree() redundant null check
Date: Tue, 12 Feb 2013 11:17:51 -0700
Message-Id: <1360693071-61227-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch analysis:

fs/hugetlbfs/inode.c:883 hugetlbfs_fill_super() info: redundant null check on sbinfo->spool calling kfree()

Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/hugetlbfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78bde32..e2e36ef 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -879,8 +879,7 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_free;
 	return 0;
 out_free:
-	if (sbinfo->spool)
-		kfree(sbinfo->spool);
+	kfree(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
-- 
1.7.9.5

