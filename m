Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3ETDdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:33:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3ETDdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:37 -0400
X-AuditID: cbfee690-b7efc6d000006d92-09-5199998eaab4
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 03/15] f2fs: fix por_doing variable coverage
Date: Mon, 20 May 2013 12:32:17 +0900
Message-id: <1369020743-18520-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDd68Fba4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PB7ufsBdM5K7rX
	vmFsYDzG3sXIySEhYCKxq+EkM4QtJnHh3nq2LkYuDiGBZYwSa+YeYYIp6mzexQ6RWMQocf/a
	PVYIp41JYmPDEaAWDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3LCAJYQEbiRtH+phA
	6lkEVCX+dCWDhHkF3CUW3m+BWqYrsfr/c7DrOAU8JLbePcUIUi4EVPP6XAlEyWc2ib27tUBs
	FgEBiW+TD7GAlEgIyEpsOgD1i6TEwRU3WCYwCi9gZFjFKJpakFxQnJReZKJXnJhbXJqXrpec
	n7uJERKuE3Yw3jtgfYgxGWjcRGYp0eR8YLjnlcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoFRc4bHG9GPF0JnP+hTONOVf6d6258FS7NOLmJaW19h
	Oz21YsaSR3KmDftNeblO5BlHWtrG6nBdlJuq4cXP0VmaxB275c5Wi6Ktx2oLozcopjPlHmsv
	dfx2js2tpvl5kLlp4Y9NOXqPjDgkPsicZ9Hdv0do4rRtt8QeHlY/39dcpLbkTOwHUTMlluKM
	REMt5qLiRADFDt+FbQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDVo3CVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxYPdz9oLpnBXda98wNjAeY+9i5OSQEDCR6GzeBWWLSVy4t56ti5GLQ0hg
	EaPE/Wv3WCGcNiaJjQ1HgDIcHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQBLCAjYS
	N470MYHUswioSvzpSgYJ8wq4Syy838IEsUxXYvX/52CLOQU8JLbePcUIUi4EVPP6XMkERt4F
	jAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj4Zn0DsZVDRaHGAU4GJV4eAUCZgYKsSaW
	FVfmHmKU4GBWEuGN7gYK8aYkVlalFuXHF5XmpBYfYkwGumkis5Rocj4wVvNK4g2NTcyMLI3M
	LIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgTEpkzl/w7za0BjRCTy2LIe9F4WV
	SEXOzHv1Yc2/y69S6w9cnehfbDzbQ7a09Xv583tmcYxtp/ySDx65nPTGTT3vsQXXhw8Zbod0
	W/9wc3v+ff4yOsZZhUVvbVTFtO3en0N3MP3oDTYrif7/+Z6k0Dr9OYKasnapva9Purzq47b8
	tLt+2tfGSUosxRmJhlrMRcWJAIOURYDLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason of using sbi->por_doing is to alleviate data writes during the
recovery.
The find_fsync_dnodes() produces some dirty dentry pages, so we should
cover it too with sbi->por_doing.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 993b601..f77aedd 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -377,6 +377,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	INIT_LIST_HEAD(&inode_list);
 
 	/* step #1: find fsynced inode numbers */
+	sbi->por_doing = 1;
 	err = find_fsync_dnodes(sbi, &inode_list);
 	if (err)
 		goto out;
@@ -385,13 +386,12 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 		goto out;
 
 	/* step #2: recover data */
-	sbi->por_doing = 1;
 	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
-	sbi->por_doing = 0;
 	BUG_ON(!list_empty(&inode_list));
 out:
 	destroy_fsync_dnodes(sbi, &inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
+	sbi->por_doing = 0;
 	write_checkpoint(sbi, false);
 	return err;
 }
-- 
1.8.1.3.566.gaa39828

