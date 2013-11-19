Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3KSDhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:37:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23991 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3KSDhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:37:06 -0500
X-AuditID: cbfee68f-b7f836d000001b39-1c-528adce046bf
Message-id: <1384832174.26319.28.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: split sbi->write_mutex for DATA/NODE/META
 to avoid unnecessary race
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 19 Nov 2013 12:36:14 +0900
In-reply-to: <1384831096.26319.25.camel@kjgkr>
References: <001201cee4c8$de450360$9acf0a20$@samsung.com>
 <1384831096.26319.25.camel@kjgkr>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zY90Hd7qCDFa+U7H43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFi5mnmgm+KFRs7
	b7E2ML6X7mLk5JAQMJH4ffkgK4QtJnHh3nq2LkYuDiGBZYwS13oamGCKTv18ygiRmM4ocfrt
	C1YI5xWjxKaNK9hBqngFdCUWnvoI1iEskC0x//IroA4ODjYBbYnN+w1AwkICihJv998F2yYi
	oCTxa/4iMJtZIFNizuvJYDaLgKrEp0cfmUFsTgE9iX/vLrJC9MZK9CzsAVvFLyAqcXjhdmaI
	XnWJSfMWMUMcqiSxu72THSIuL7F5zVtmiNMEJX5MvscCcrOEwCF2iSPXDrJALBOQ+Db5EAvI
	nRICshKbDkDNkZQ4uOIGywRGiVlIVsxCMnYWkrELGJlXMYqmFiQXFCelFxnrFSfmFpfmpesl
	5+duYoTEXP8OxrsHrA8xJgOtnMgsJZqcD4zZvJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChIS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyOtZlPZg/Q6zK6K9nxPX1mtHyU3uYss6NJlN+8SW
	AwsYHX2OOsfs+G+b9klxSuDX6u8t8VLz04Wk/QoW2dz/ExlSqvc6SS/0/IltFuqal60WMlgc
	5ow8NG+j0srKe82nn5/YsH41pyRj6ustMpfmrct7nVEgFtNU61m+dc6h/68OGxZIzU/TVGIp
	zkg01GIuKk4EAGaxiZnPAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd0Hd7qCDNYsVrD43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxYuZp5oJvihUbO2+xNjC+l+5i5OSQEDCROPXzKSOELSZx4d56ti5GLg4h
	gemMEqffvmCFcF4xSmzauIIdpIpXQFdi4amPTCC2sEC2xPzLr4C6OTjYBLQlNu83AAkLCShK
	vN1/lxXEFhFQkvg1fxGYzSyQKTHn9WQwm0VAVeLTo4/MIDangJ7Ev3cXWSF6YyV6FvaAreIX
	EJU4vHA7M0SvusSkeYuYIQ5Vktjd3skOEZeX2LzmLTPEaYISPybfY5nAKDQLScssJGWzkJQt
	YGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc0c+kdjCubLA4xCjAwajEwzvBvStIiDWx
	rLgy9xCjBAezkgiv5BWgEG9KYmVValF+fFFpTmrxIcZkoO8mMkuJJucDk01eSbyhsYmZkaWR
	mYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKARMWI++HtHO+axbPLHS7vdv28J6r
	dee5N18y+a+2p22tC3fKRZ1PF2wFEty5Xlb4xirdmXL46qNn/puTRTJy/styluitnDlbYnnS
	m4IlZUL35r2R+v/pd5nE099xjPI/PSLbHEQlVKbcUto5e/LKjNK7VZfXcHwueF2dFOSwTFlH
	wEhv1wPnoCVKLMUZiYZazEXFiQDO1SnrLAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think we don't need to make two patches for this.
How about this?

>From 71c27f78e72d680edcd7b1c0917842343044653c Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Mon, 18 Nov 2013 17:16:17 +0900
Subject: [PATCH] f2fs: use sbi->write_mutex for write bios

This patch removes an unnecessary semaphore (i.e., sbi->bio_sem).
There is no reason to use the semaphore when f2fs submits read and write
IOs.
Instead, let's use a write mutex and cover the sbi->bio[] by the lock.

Change log from v1:
 o split write_mutex suggested by Chao Yu

Chao described,
"All DATA/NODE/META bio buffers in superblock is protected by
'sbi->write_mutex', but each bio buffer area is independent, So we
should split write_mutex to three for DATA/NODE/META."

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c    |  4 ----
 fs/f2fs/f2fs.h    |  2 +-
 fs/f2fs/segment.c | 13 +++++++++----
 fs/f2fs/super.c   |  6 +++++-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 076a60c..5920639 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -383,8 +383,6 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct
page *page,
 
 	trace_f2fs_readpage(page, blk_addr, type);
 
-	down_read(&sbi->bio_sem);
-
 	/* Allocate a new bio */
 	bio = f2fs_bio_alloc(bdev, 1);
 
@@ -394,13 +392,11 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct
page *page,
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
-		up_read(&sbi->bio_sem);
 		f2fs_put_page(page, 1);
 		return -EFAULT;
 	}
 
 	submit_bio(type, bio);
-	up_read(&sbi->bio_sem);
 	return 0;
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6a49554..6e67f28 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -374,7 +374,7 @@ struct f2fs_sb_info {
 	struct f2fs_sm_info *sm_info;		/* segment manager */
 	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
 	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
-	struct rw_semaphore bio_sem;		/* IO semaphore */
+	struct mutex write_mutex[NR_PAGE_TYPE];	/* mutex for writing IOs */
 
 	/* for checkpoint */
 	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index dad5f1a..119af0b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -871,9 +871,14 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 
 void f2fs_submit_bio(struct f2fs_sb_info *sbi, enum page_type type,
bool sync)
 {
-	down_write(&sbi->bio_sem);
+	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+
+	if (!sbi->bio[btype])
+		return;
+
+	mutex_lock(&sbi->write_mutex[btype]);
 	do_submit_bio(sbi, type, sync);
-	up_write(&sbi->bio_sem);
+	mutex_unlock(&sbi->write_mutex[btype]);
 }
 
 static void submit_write_page(struct f2fs_sb_info *sbi, struct page
*page,
@@ -884,7 +889,7 @@ static void submit_write_page(struct f2fs_sb_info
*sbi, struct page *page,
 
 	verify_block_addr(sbi, blk_addr);
 
-	down_write(&sbi->bio_sem);
+	mutex_lock(&sbi->write_mutex[type]);
 
 	inc_page_count(sbi, F2FS_WRITEBACK);
 
@@ -919,7 +924,7 @@ retry:
 
 	sbi->last_block_in_bio[type] = blk_addr;
 
-	up_write(&sbi->bio_sem);
+	mutex_unlock(&sbi->write_mutex[type]);
 	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a022412..e194578 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -820,6 +820,7 @@ static int f2fs_fill_super(struct super_block *sb,
void *data, int silent)
 	struct buffer_head *raw_super_buf;
 	struct inode *root;
 	long err = -EINVAL;
+	int i;
 
 	/* allocate memory for f2fs-specific super block info */
 	sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
@@ -876,7 +877,10 @@ static int f2fs_fill_super(struct super_block *sb,
void *data, int silent)
 	mutex_init(&sbi->node_write);
 	sbi->por_doing = false;
 	spin_lock_init(&sbi->stat_lock);
-	init_rwsem(&sbi->bio_sem);
+
+	for (i = 0; i < NR_PAGE_TYPE; i++)
+		mutex_init(&sbi->write_mutex[i]);
+
 	init_rwsem(&sbi->cp_rwsem);
 	init_waitqueue_head(&sbi->cp_wait);
 	init_sb_info(sbi);
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

