Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3EUD6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:58:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32269 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3EUD6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:58:21 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-0a-519af0d9cf69
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: fix wrong condition check
Date: Tue, 21 May 2013 12:56:33 +0900
Message-id: <1369108593-880-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369108593-880-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369108593-880-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zA92bH2YFGiw9L2txfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bdxi0sBQvZK6Zu
	mMfcwHiftYuRk0NCwETiQd9ldghbTOLCvfVsXYxcHEICyxglPhzYxgxTtODObyYQW0hgOqPE
	3516EEVtTBLTrq4F6ubgYBPQlti83wCkRkSAWWLB1POMIDXMAhMYJf4ves8CUiMMNGjplzyQ
	GhYBVYmfrUvZQGxeAVeJiTOmQe3SlVj9/znYQZwCbhI9k/4wgbQKAdXcflEAMlJC4DubxLKz
	rewQcwQkvk0+BDZeQkBWYtMBqDGSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGJXnFibnFpXrpe
	cn7uJkZIuE7YwXjvgPUhxmSgcROZpUST84HhnlcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGRmmWBsvvwh0OVyZdLVix9pGzUdZLv8AJkzbY8E2/
	+/OCXnqd4OEZ5RPlr+xMsH2yupSRQ0/i5Mf9Ri0hxudd1/7WkShcW9+yo8D9jvaEBZuOfzAu
	eznnCNdL++Z4u/8d1zf+19y4kvnyHG2O9b9mth01OHfUePutsGYmXsOppzf9+/Rq04Z3BQFK
	LMUZiYZazEXFiQA3QhW2bQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd2bH2YFGrzZJ2VxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPG3cYtLAUL2SumbpjH3MB4n7WLkZNDQsBEYsGd30wQtpjEhXvr2UBsIYHp
	jBJ/d+p1MXIB2W1MEtOurmXvYuTgYBPQlti83wCkRkSAWWLB1POMIDXMAhMYJf4ves8CUiMM
	NHTplzyQGhYBVYmfrUvBZvIKuEpMnDGNGWKXrsTq/8/ZQWxOATeJnkl/mEBahYBqbr8omMDI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDQ8k97BuKrB4hCjAAejEg+vgOGsQCHW
	xLLiytxDjBIczEoivN+bgUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD4zUvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgdAzbcIDbUOW5nI5K3c//q6rE
	p8/5Ldicoxl1Rsmk6NDOyWWmVRlTZnhXXAs2/3QsfwqXz6bm7O2m9yqOX7i77/S+zI2nGOQM
	XFbFck32Z/oo8t582bsLR3e5Zp9/3HTpjW+xz4anGmVVfJq657IEJjbXTNp08VnRo42Ky3fc
	qjsXbaRTonuNXYmlOCPRUIu5qDgRABEIoszKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While an orphan inode has zero link_count, f2fs_gc is able to select the inode
for foreground gc.

- f2fs_gc
 - do_garbage_collect
   - gc_data_segment
     : f2fs_iget is failed
     : get_valid_blocks() != 0, so that retry
--> here we got the infinite loop.

This patch resolved this issue.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index a18946e..b44a4c1 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -109,12 +109,6 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	ret = do_read_inode(inode);
 	if (ret)
 		goto bad_inode;
-
-	if (!sbi->por_doing && inode->i_nlink == 0) {
-		ret = -ENOENT;
-		goto bad_inode;
-	}
-
 make_now:
 	if (ino == F2FS_NODE_INO(sbi)) {
 		inode->i_mapping->a_ops = &f2fs_node_aops;
-- 
1.8.1.3.566.gaa39828

