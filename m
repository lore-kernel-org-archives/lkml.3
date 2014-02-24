Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaBXHUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:20:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64883 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaBXHTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:19:45 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-64-530af28cf011
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: implement a lock-free stat_show
Date: Mon, 24 Feb 2014 16:18:04 +0900
Message-id: <1393226284-22447-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1393226284-22447-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1393226284-22447-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ92eT1zBBpMauCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypj0/xVjwRnFikk3
	PrM0ME6X6WLk5JAQMJE4vPYeM4QtJnHh3nq2LkYuDiGBZYwSHx5tBXI4wIoubmGCiE9nlDi4
	eDYrhNPJJHFu5lZWkCI2AW2JzfsNQAaJCDBLLJh6nhGkhllgAqPE/0XvWUASwgJWEse7t7GB
	2CwCqhKP25Yzgti8Au4SMzquM0FcoS2x7flEsDingIfEsvnv2UFsIaCaaV8egQ2VEPjOJnF/
	43YmiEECEt8mH2KBuFRWYtMBqG8kJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJDveLE3OLSvHS9
	5PzcTYyQkO3dwXj7gPUhxmSgcROZpUST84Ehn1cSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAh
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjCITD2ocPr3+jWxexr6dbG9qvF7zBC3SyivuzTqz
	OzK/x501c+anzc77xfoDeft0+ILE+x7Li38Mfmqz4As73741da1WIrb9fzu7FpYnH3qye3dz
	fv0tN6XtHwOemxbdme2l/HKrl5haHx/7xZMui5S8Hy7b5rdw99kX+9W+auekVz3SX1gkqcRS
	nJFoqMVcVJwIAMVz02JvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd2eT1zBBm1tbBbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZM+v+KseCMYsWkG59ZGhiny3QxcnBICJhIXNzC1MXICWSKSVy4t56ti5GL
	Q0hgOqPEwcWzWSGcTiaJczO3soI0sAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgL
	WEkc797GBmKzCKhKPG5bzghi8wq4S8zouA61TVti2/OJYHFOAQ+JZfPfs4PYQkA10748YpzA
	yLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBEPJPewbiqweIQowAHoxIPr0Q1V7AQ
	a2JZcWXuIUYJDmYlEd4f94FCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA+M1rySeENjEzMj
	SyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYBTWLHdfu39hh4u0qMf9v5zz
	qle6pD/5PM3af/cuBcM9tmxXmUKlLbZxyOgzfrRWSvt09sMk2319bhkez0rYxbK5Dt7Q8BVg
	erJBNsbMu3/ZtXnyDAa6WUHKbi77LvcoznOSuyrl+yR7acU3cxflf28v6j76umaywr/A+d++
	c7z62ms1v/fodCWW4oxEQy3mouJEAM3GRrrMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stat_show is just to show the current status of f2fs.
So, we can remove all the there-in locks.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/debug.c   |  3 ---
 fs/f2fs/f2fs.h    | 18 +++---------------
 fs/f2fs/segment.h | 27 +++------------------------
 3 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 46a12e4..b7111c4 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -86,7 +86,6 @@ static void update_sit_info(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_stat_info *si = F2FS_STAT(sbi);
 	unsigned int blks_per_sec, hblks_per_sec, total_vblocks, bimodal, dist;
-	struct sit_info *sit_i = SIT_I(sbi);
 	unsigned int segno, vblocks;
 	int ndirty = 0;
 
@@ -94,7 +93,6 @@ static void update_sit_info(struct f2fs_sb_info *sbi)
 	total_vblocks = 0;
 	blks_per_sec = sbi->segs_per_sec * (1 << sbi->log_blocks_per_seg);
 	hblks_per_sec = blks_per_sec / 2;
-	mutex_lock(&sit_i->sentry_lock);
 	for (segno = 0; segno < TOTAL_SEGS(sbi); segno += sbi->segs_per_sec) {
 		vblocks = get_valid_blocks(sbi, segno, sbi->segs_per_sec);
 		dist = abs(vblocks - hblks_per_sec);
@@ -105,7 +103,6 @@ static void update_sit_info(struct f2fs_sb_info *sbi)
 			ndirty++;
 		}
 	}
-	mutex_unlock(&sit_i->sentry_lock);
 	dist = TOTAL_SECS(sbi) * hblks_per_sec * hblks_per_sec / 100;
 	si->bimodal = bimodal / dist;
 	if (si->dirty_count)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 11fd8be..4beedcc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -704,11 +704,7 @@ static inline int get_blocktype_secs(struct f2fs_sb_info *sbi, int block_type)
 
 static inline block_t valid_user_blocks(struct f2fs_sb_info *sbi)
 {
-	block_t ret;
-	spin_lock(&sbi->stat_lock);
-	ret = sbi->total_valid_block_count;
-	spin_unlock(&sbi->stat_lock);
-	return ret;
+	return sbi->total_valid_block_count;
 }
 
 static inline unsigned long __bitmap_size(struct f2fs_sb_info *sbi, int flag)
@@ -804,11 +800,7 @@ static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
 
 static inline unsigned int valid_node_count(struct f2fs_sb_info *sbi)
 {
-	unsigned int ret;
-	spin_lock(&sbi->stat_lock);
-	ret = sbi->total_valid_node_count;
-	spin_unlock(&sbi->stat_lock);
-	return ret;
+	return sbi->total_valid_node_count;
 }
 
 static inline void inc_valid_inode_count(struct f2fs_sb_info *sbi)
@@ -829,11 +821,7 @@ static inline void dec_valid_inode_count(struct f2fs_sb_info *sbi)
 
 static inline unsigned int valid_inode_count(struct f2fs_sb_info *sbi)
 {
-	unsigned int ret;
-	spin_lock(&sbi->stat_lock);
-	ret = sbi->total_valid_inode_count;
-	spin_unlock(&sbi->stat_lock);
-	return ret;
+	return sbi->total_valid_inode_count;
 }
 
 static inline void f2fs_put_page(struct page *page, int unlock)
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 4024546..c3d5e36 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -380,26 +380,12 @@ static inline void get_sit_bitmap(struct f2fs_sb_info *sbi,
 
 static inline block_t written_block_count(struct f2fs_sb_info *sbi)
 {
-	struct sit_info *sit_i = SIT_I(sbi);
-	block_t vblocks;
-
-	mutex_lock(&sit_i->sentry_lock);
-	vblocks = sit_i->written_valid_blocks;
-	mutex_unlock(&sit_i->sentry_lock);
-
-	return vblocks;
+	return SIT_I(sbi)->written_valid_blocks;
 }
 
 static inline unsigned int free_segments(struct f2fs_sb_info *sbi)
 {
-	struct free_segmap_info *free_i = FREE_I(sbi);
-	unsigned int free_segs;
-
-	read_lock(&free_i->segmap_lock);
-	free_segs = free_i->free_segments;
-	read_unlock(&free_i->segmap_lock);
-
-	return free_segs;
+	return FREE_I(sbi)->free_segments;
 }
 
 static inline int reserved_segments(struct f2fs_sb_info *sbi)
@@ -409,14 +395,7 @@ static inline int reserved_segments(struct f2fs_sb_info *sbi)
 
 static inline unsigned int free_sections(struct f2fs_sb_info *sbi)
 {
-	struct free_segmap_info *free_i = FREE_I(sbi);
-	unsigned int free_secs;
-
-	read_lock(&free_i->segmap_lock);
-	free_secs = free_i->free_sections;
-	read_unlock(&free_i->segmap_lock);
-
-	return free_secs;
+	return FREE_I(sbi)->free_sections;
 }
 
 static inline unsigned int prefree_segments(struct f2fs_sb_info *sbi)
-- 
1.8.4.474.g128a96c

