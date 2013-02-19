Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab3BSLum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:50:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:65051 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3BSLul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:50:41 -0500
X-AuditID: 9c930179-b7c24ae00000119c-6d-5123670f92f4
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fat: instead of constant number, use the i_blkbits of struct inode to calculate the number of blocks
Date: Tue, 19 Feb 2013 20:50:38 +0900
Message-Id: <1361274638-9534-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To calculate the number of blocks from the number of clusters,
use the i_blkbits of struct inode instead of 9.

Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
---
 fs/fat/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 6d93360..ccdf663 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -156,7 +156,7 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
 		fat_cache_inval_inode(inode);
 	}
-	inode->i_blocks += nr_cluster << (sbi->cluster_bits - 9);
+	inode->i_blocks += nr_cluster << (sbi->cluster_bits - inode->i_blkbits);
 
 	return 0;
 }
-- 
1.7.9.5

