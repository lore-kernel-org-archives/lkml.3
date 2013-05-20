Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3ETDRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:17:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43067 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3ETDRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:17:21 -0400
X-AuditID: cbfee68f-b7f436d000000f81-56-519995c0bf5b
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: fix to unlock page before exit
Date: Mon, 20 May 2013 12:16:07 +0900
Message-id: <1369019767-17321-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369019767-17321-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369019767-17321-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zI90DU2cGGvzeq2xxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8avZ/fYCzo5Kuac
	vMLUwLiZrYuRk0NCwERiy4RZULaYxIV764FsLg4hgWWMEu8fv2OFKdrX9J8JIjGdUeLJ3XYW
	CKeNSaLxVjtQhoODTUBbYvN+A5AGEQFmiQVTzzOC1DALTGCU+L/oPQtIQljAUuLF/IVg9SwC
	qhJTlweAhHkF3CUOT9wAtUxXYvX/5+wgNqeAh8SNaRPBrhMCqjnYthuq5jubxJZ14SA2i4CA
	xLfJh1hARkoIyEpsOsAMUSIpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+du
	YoQEbP8OxrsHrA8xJgONm8gsJZqcDwz4vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwHv5wueYTy0X7JVG728RefuF5d78vPGzt4kUyQW0P/72x
	5lEOO9qQErKg6+OHJ22T9PnZWuU+Pfx37N7CFdE+G7ryXv8qO7nV/G+NSemBr6feTdauWrJO
	33fGep+mabc/rpxTvXfJMxHW6yU2PtPLctem7bvk3vXr2H/p9OkJFv4BTlEHXi16+06JpTgj
	0VCLuag4EQCf5HXRbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd0DU2cGGjz9Km9xfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGr2f32As6OSrmnLzC1MC4ma2LkZNDQsBEYl/TfyYIW0ziwr31QHEuDiGB
	6YwST+62s0A4bUwSjbfagao4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96zgCSEBSwl
	XsxfCFbPIqAqMXV5AEiYV8Bd4vDEDawQy3QlVv9/zg5icwp4SNyYNhHsICGgmoNtu1knMPIu
	YGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcEc+kdzCuarA4xCjAwajEwysQMDNQiDWx
	rLgy9xCjBAezkghvdDdQiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OB0ZpXEm9obGJmZGlk
	ZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxRJ6NdwyZrMvgo/VKaGvXt9QaW
	pAQ5D0GRNzmLo2I+zdtSuubq1+SuPqstx44U62k2By26G95cuNDjoIHkzU2F0zLWZPaZv+y/
	mBhveTJ6747unVqOwbYLJs2TU+MUrJ9V02Nh8EqYQ846437RHNWbDi7Ln17Zr/58olvemStO
	2Ze8ZKWEZyqxFGckGmoxFxUnAgCNLZotzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we got an error after lock_page, we should unlock it before exit.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 5fcdd08..edb89a3 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -343,7 +343,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 		lock_page(page);
 
 		if (cp_ver != cpver_of_node(page))
-			goto unlock_out;
+			break;
 
 		entry = get_fsync_inode(head, ino_of_node(page));
 		if (!entry)
@@ -351,7 +351,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 
 		err = do_recover_data(sbi, entry->inode, page, blkaddr);
 		if (err)
-			goto out;
+			break;
 
 		if (entry->blkaddr == blkaddr) {
 			iput(entry->inode);
@@ -362,7 +362,6 @@ next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
 	}
-unlock_out:
 	unlock_page(page);
 out:
 	__free_pages(page, 0);
-- 
1.8.1.3.566.gaa39828

