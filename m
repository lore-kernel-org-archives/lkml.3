Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3GWIcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:32:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29550 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3GWIcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:32:16 -0400
X-AuditID: cbfee691-b7fef6d000002d62-40-51ee3f748eeb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] f2fs: fix i_name during f2fs_sync_file
Date: Tue, 23 Jul 2013 17:31:27 +0900
Message-id: <1374568287-26045-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t8zfd0S+3eBBid/SFpc3/WXyeLSIneL
	PXtPslhc3jWHzeL83+OsDqweuxd8ZvLo27KK0ePzJjmPTU/eMgWwRHHZpKTmZJalFunbJXBl
	NF6Zz1qwgb3i1s0JbA2MX1i7GDk4JARMJLY9Euhi5AQyxSQu3FvP1sXIxSEksIxR4v65KywQ
	CROJrd9WQSWmM0r0nJjCCJIQEmhjkpi9lQlkEJuAtsTm/QYgYREBZokFU88zgtQzC2xllHj+
	fA8bSI2wgLnEzzMyIDUsAqoSq7ZdZwKxeQXcJZZ8aGeF2KUrsejEQVaQXgmB92wSTydfY4No
	EJD4NvkQC8TRshKbDjBD1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmb
	GCEhOXEH4/0D1ocYk4HGTWSWEk3OB4Z0Xkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6Ykl
	qdmpqQWpRfFFpTmpxYcYmTg4pRoYgzw/XNmecPr9V+bmmSV8u7eYxbN3T3h9zDBvWt3xlofN
	xo9sPRNN/jKqrFC/ILlQdd/TQ0Ken5fa/2fZIaWrYH90t2zadpMTIcm7fCw3fIy/OXvnL/bX
	IvO3+F/vuHa35XiIZ5L0ZMav1/t7T/k9mOER8u3Okr6IbV2NcskMrIISnK5bLh0+rsRSnJFo
	qMVcVJwIAG5DLxNfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd0S+3eBBh+Pilpc3/WXyeLSIneL
	PXtPslhc3jWHzeL83+OsDqweuxd8ZvLo27KK0ePzJjmPTU/eMgWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZjRemc9asIG94tbNCWwNjF9Yuxg5OSQETCS2flvFBmGL
	SVy4tx7I5uIQEpjOKNFzYgojSEJIoI1JYvZWpi5GDg42AW2JzfsNQMIiAswSC6aeZwSpZxbY
	yijx/PkeNpAaYQFziZ9nZEBqWARUJVZtu84EYvMKuEss+dAOtVdXYtGJg6wTGLkXMDKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAgO+WdSOxhXNlgcYhTgYFTi4fXwfhsoxJpYVlyZe4hR
	goNZSYR3qdS7QCHelMTKqtSi/Pii0pzU4kOMyUDbJzJLiSbnA+MxryTe0NjEzMjSyMzCyMTc
	nDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYVxiFG9ueYbItNhZT0ckN6H3Nbdt9oumW
	w9E1Xjapq99P7pTzLGOLXMazUP1rcc+Mz2cXRJybwr3rfa72Ys5nF4+UOfUkBzdVSKxbcLBw
	btvhSvc7d2d/OaLqFWD9ckIAT8K8qYuEzLLtFX9PTtGLMBK1rOux2KO7pOpFvXvyztf2ctaX
	C7yUWIozEg21mIuKEwEQfncrvQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As similar as the i_pino fix, i_name also should be fixed when i_nlink is 1.

The errorneous scenario is like this.

1. touch test1
2. link test1 test2
3. unlink test2
4. fsync test1

After this, i_name should be test1.

CC: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 65ca3b3..c2deb27 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -112,11 +112,13 @@ static int get_parent_ino(struct inode *inode, nid_t *pino)
 	if (!dentry)
 		return 0;
 
-	inode = igrab(dentry->d_parent->d_inode);
-	dput(dentry);
+	if (update_dent_inode(inode, &dentry->d_name)) {
+		dput(dentry);
+		return 0;
+	}
 
-	*pino = inode->i_ino;
-	iput(inode);
+	*pino = parent_ino(dentry);
+	dput(dentry);
 	return 1;
 }
 
-- 
1.8.3.1.437.g0dbd812

