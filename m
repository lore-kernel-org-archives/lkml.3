Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaD3CgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:36:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30116 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaD3CgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:36:01 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-61-5360618cbddb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/4] f2fs: no need to wait on page writebck to meta pages
Date: Wed, 30 Apr 2014 11:33:42 +0900
Message-id: <1398825223-23062-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1398825223-23062-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1398825223-23062-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zQ92exIRggyMvVSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyniyZitLwSu2iocL
	+RsYL7F2MXJySAiYSPTu/MwCYYtJXLi3nq2LkYtDSGAZo8TD9ieMMEVzblxgh0gsYpS4cnwT
	O0hCSKCTSWLNo4ouRg4ONgFtic37DUDCIgLMEgumnmcEqWcWmMAo8X/Re7ANwgKeEvNnf2EC
	sVkEVCWmLrnAAtLLK+AucWByKcQubYltzyeC7eUU8JC4+PoiI8Qqd4l9bw6CHSch8JtN4uD+
	HewQcwQkvk0+BDZHQkBWYtMBZog5khIHV9xgmcAovICRYRWjaGpBckFxUnqRqV5xYm5xaV66
	XnJ+7iZGSLhO3MF4/4D1IcZkoHETmaVEk/OB4Z5XEm9obGZkYWpiamxkbmlGmrCSOG/6o6Qg
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxZSX2ntPRWTtY/W+6cFczV8erC5Pr6jbdifewL
	LikcVkt6bSzHqzrlTYTD0f0sM5ZsunxUdX/v7q97K1Q7dEWlbmxK2hnRJXKUt89+77Wk/u2e
	X0rXHW+d/uuCjL2hq9gMn83O1mseCTS8OR9zeadG9sdT3hP15MOCuA9pr6j8FXR7xgl5X2Yl
	luKMREMt5qLiRABTAiwtbQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd2exIRgg7Z9ihbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWY8WbOVpeAVW8XDhfwNjJdYuxg5OSQETCTm3LjADmGLSVy4t56ti5GLQ0hg
	EaPEleObwBJCAp1MEmseVXQxcnCwCWhLbN5vABIWEWCWWDD1PCNIPbPABEaJ/4ves4AkhAU8
	JebP/sIEYrMIqEpMXXKBBaSXV8Bd4sDkUohd2hLbnk9kBLE5BTwkLr6+yAixyl1i35uDbBMY
	eRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6GZ1I7GFc2WBxiFOBgVOLhFdgaHyzE
	mlhWXJl7iFGCg1lJhJc5ICFYiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBkZpXEm9obGJm
	ZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzOD6xZv4mG+Rb1dz48NCPd
	YPvbR34N/f+lpu+aZfQ51TBpu/rlypabniJJyycl6XSovVSrZUkJrP+zz6i/1fZPf7LJho7d
	cV7TZU6fFfv1ftZVoSfMcRNmZ99w+rb+t1XR4dh/9sc2RAXY7v9aKOb4SUB7idqF5xfebTRb
	tm4HW5xqmXJmqY4SS3FGoqEWc1FxIgBFzLbIygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes grab_cache_page_write_begin for meta pages.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 1346ce9..b6f6ead 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -33,11 +33,14 @@ struct page *grab_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 	struct address_space *mapping = META_MAPPING(sbi);
 	struct page *page = NULL;
 repeat:
-	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
+	page = grab_cache_page(mapping, index);
 	if (!page) {
 		cond_resched();
 		goto repeat;
 	}
+	/* meta pages should not be under writeback */
+	if (PageWriteback(page))
+		WARN_ON(1);
 
 	SetPageUptodate(page);
 	return page;
-- 
1.8.4.474.g128a96c

