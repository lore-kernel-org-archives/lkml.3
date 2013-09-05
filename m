Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685Ab3IECDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:03:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47814 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3IECDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:03:04 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-2d-5227e655709f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: merge more bios of node block writes
Date: Thu, 05 Sep 2013 11:02:51 +0900
Message-id: <1378346571-11331-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA93QZ+pBBj8fGFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbFo0jHmgvXiFXMX
	rWRvYNwt1MXIySEhYCLxbvFmVghbTOLCvfVsXYxcHEICyxglns/bwg5T1PDlEVRiEaPEgavn
	WCGcNiaJfRf3MnUxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAtYSzx53MEG
	Us8ioCqxd1ciSJhXwF1i393DLBDLdCUWnTgINl9C4D6bxI4VVxlBEiwCAhLfJh9iAemVEJCV
	2HSAGaJeUuLgihssExgFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQICcH+HYx3D1gf
	YkwGGjeRWUo0OR8Ywnkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5Xm
	pBYfYmTi4JRqYNxqZDclI+nkyVmH1rTz/QwXTdw0Ic++3dX2tvMGh40MJ6ZydNntvfNh1ZlE
	iWn7v9ywP3Lf1Pnav9bFd2N+PI5N8+/lFft6dd7/75f1DIv2FnzbZilQOLNq7cSdK8O+qjdv
	cFlTtNEpYcWEVZsTpdvdrb88t117bcWb02Uv5BTVT54VmxdUNsVdiaU4I9FQi7moOBEAEt7c
	slcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd3QZ+pBBi836lpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixaNIx5oL14hVzF61kb2DcLdTFyMkhIWAi0fDlERuELSZx4d56IJuLQ0hg
	EaPEgavnWCGcNiaJfRf3MnUxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAtY
	Szx53MEGUs8ioCqxd1ciSJhXwF1i393DLBDLdCUWnTjIOoGRewEjwypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4AB/JrWDcWWDxSFGAQ5GJR7eBmP1ICHWxLLiytxDjBIczEoivBYrgUK8
	KYmVValF+fFFpTmpxYcYk4GWT2SWEk3OB0ZfXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwzp7Ys8NbbMqrk+6iRg9ePvlq+O7ZkqMKb3nE8ybeP2Ey2f11
	xmnRSzK8zuXbWTYeDl/1WGJK/tv1ctu/2/HdPPJpsfWEiTqXgkN9ZI2+vOa4/H2nkkTw2nP3
	FH1vek7VnBi5X1DNpXLGwzCFiZ7ahUrqEYbKa7tCnsx0EU4LmphlEO1zdu2ZeiWW4oxEQy3m
	ouJEAEPnw2y0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we experience bio traces as follows when running simple sequential
write test.

 f2fs_do_submit_bio: type = NODE, io = no sync, sector = 500104928, size = 4K
 f2fs_do_submit_bio: type = NODE, io = no sync, sector = 499922208, size = 368K
 f2fs_do_submit_bio: type = NODE, io = no sync, sector = 499914752, size = 140K

 -> total 512K

The first one is to write an indirect node block, and the others are to write
direct node blocks.

The reason why there are two separate bios for direct node blocks is:
0. initial state
------------------    ------------------
|                |    |xxxxxxxx        |
------------------    ------------------

1. write 368K
------------------    ------------------
|                |    |xxxxxxxxWWWWWWWW|
------------------    ------------------

2. write 140K
------------------    ------------------
|WWWWWWW         |    |xxxxxxxxWWWWWWWW|
------------------    ------------------

This is because f2fs_write_node_pages tries to write just 512K totally, so that
we can lose the chance to merge more bios nicely.

After this patch is applied, we can get the following bio traces.

  f2fs_do_submit_bio: type = NODE, io = no sync, sector = 500103168, size = 8K
  f2fs_do_submit_bio: type = NODE, io = no sync, sector = 500111368, size = 4K
  f2fs_do_submit_bio: type = NODE, io = no sync, sector = 500107272, size = 512K
  f2fs_do_submit_bio: type = NODE, io = no sync, sector = 500108296, size = 512K
  f2fs_do_submit_bio: type = NODE, io = no sync, sector = 500109320, size = 500K

And finally, we can improve the sequential write performance,
    from 458.775 MB/s to 479.945 MB/s on SSD.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c3c03c9..51ef278 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1191,9 +1191,9 @@ static int f2fs_write_node_page(struct page *page,
 /*
  * It is very important to gather dirty pages and write at once, so that we can
  * submit a big bio without interfering other data writes.
- * Be default, 512 pages (2MB), a segment size, is quite reasonable.
+ * Be default, 512 pages (2MB) * 3 node types, is more reasonable.
  */
-#define COLLECT_DIRTY_NODES	512
+#define COLLECT_DIRTY_NODES	1536
 static int f2fs_write_node_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
@@ -1211,9 +1211,10 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 		return 0;
 
 	/* if mounting is failed, skip writing node pages */
-	wbc->nr_to_write = max_hw_blocks(sbi);
+	wbc->nr_to_write = 3 * max_hw_blocks(sbi);
 	sync_node_pages(sbi, 0, wbc);
-	wbc->nr_to_write = nr_to_write - (max_hw_blocks(sbi) - wbc->nr_to_write);
+	wbc->nr_to_write = nr_to_write - (3 * max_hw_blocks(sbi) -
+						wbc->nr_to_write);
 	return 0;
 }
 
-- 
1.8.3.1.437.g0dbd812

