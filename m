Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbaCSIGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:06:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64435 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaCSIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:04:01 -0400
X-AuditID: cbfee68f-b7f156d00000276c-56-53294f6d3125
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 5/5] f2fs: change reclaim rate in percentage
Date: Wed, 19 Mar 2014 17:02:09 +0900
Message-id: <1395216129-13656-5-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ91cf81gg/7rqhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZXztPcdScEq0ouP0
	UeYGxpmCXYycHBICJhL7nl1lgbDFJC7cW8/WxcjFISSwjFHiQvN1oAQHWFH3eV+I+HRGiV3L
	d7BAOJ1MEns/nGQHKWIT0JbYvN8AZJCIALPEgqnnGUFqmAUmMEr8X/QebIOwgI3E3XnXmEFs
	FgFViTcLfoPZvALuEhdfL2SDuEJbYtvziYwgNqeAh8ShmxfAaoSAap6+vQK2WELgN5vEyfY3
	UIMEJL5NPgR1qazEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJjveLE3OLSvHS95Pzc
	TYyQkO3fwXj3gPUhxmSgcROZpUST84Ehn1cSb2hsZmRhamJqbGRuaUaasJI47/2HSUFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGFv5r3X7V0+65yTcZeUtsexwrvsiz9tNRX8EZnMw776W
	ytpmoDnv+2buvbzvvn48GbI7cFL9Y/sdZgn/XH6EMHvNzZ6zRnt5lxXjXQ5HtrNvLkrP3trx
	9lf90oLjd57/nPzm6YXeTo1iSdUFT4M3zmk1mJ223mvyWwZV74qgubqF2ze//WfZflyJpTgj
	0VCLuag4EQB+MkT1bwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd1cf81gg85JShbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZ87T3HUnBKtKLj9FHmBsaZgl2MHBwSAiYS3ed9uxg5gUwxiQv31rN1MXJx
	CAlMZ5TYtXwHC4TTySSx98NJdpAGNgFtic37DUAaRASYJRZMPc8IUsMsMIFR4v+i9ywgCWEB
	G4m7864xg9gsAqoSbxb8BrN5BdwlLr5eyAaxTVti2/OJjCA2p4CHxKGbF8BqhIBqnr69wjKB
	kXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCIeCa1g3Flg8UhRgEORiUe3gNRGsFC
	rIllxZW5hxglOJiVRHiF7wKFeFMSK6tSi/Lji0pzUosPMSYDXTWRWUo0OR8YrXkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwFghLLTsv7SUcZ/T/Sqzniwn
	w27++Pnsh+/u4BMVYnNQu7Su8P68/LW6pUczH5hpO37zu7ghQPvqjPQNu450t2adjmg6Nj/4
	8PHJH2Ji7Ct8FN6vvcqZfrtt29fy/PMaPadnuameatvpE7lS3HJidrOa6JN627myu55N7Oxa
	OmHRzZ8fj83amqTEUpyRaKjFXFScCACAKFImzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more reasonable to determine the reclaiming rate of prefree segments
according to the volume size, which is set to 5% by default.
For example, if the volume is 128GB, the prefree segments are reclaimed
when the number reaches to 6.4GB.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 8 +++++---
 fs/f2fs/segment.c                  | 3 ++-
 fs/f2fs/segment.h                  | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index f415b9f..2f6d021 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -169,9 +169,11 @@ Files in /sys/fs/f2fs/<devname>
 
  reclaim_segments             This parameter controls the number of prefree
                               segments to be reclaimed. If the number of prefree
-			      segments is larger than this number, f2fs tries to
-			      conduct checkpoint to reclaim the prefree segments
-			      to free segments. By default, 100 segments, 200MB.
+			      segments is larger than the number of segments
+			      in the proportion to the percentage over total
+			      volume size, f2fs tries to conduct checkpoint to
+			      reclaim the prefree segments to free segments.
+			      By default, 5% over total # of segments.
 
  max_small_discards	      This parameter controls the number of discard
 			      commands that consist small blocks less than 2MB.
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6c5a4f0..e7ff23a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1758,7 +1758,8 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->ovp_segments = le32_to_cpu(ckpt->overprov_segment_count);
 	sm_info->main_segments = le32_to_cpu(raw_super->segment_count_main);
 	sm_info->ssa_blkaddr = le32_to_cpu(raw_super->ssa_blkaddr);
-	sm_info->rec_prefree_segments = DEF_RECLAIM_PREFREE_SEGMENTS;
+	sm_info->rec_prefree_segments = sm_info->main_segments *
+					DEF_RECLAIM_PREFREE_SEGMENTS / 100;
 	sm_info->ipu_policy = F2FS_IPU_DISABLE;
 	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
 
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 9fc46ee..7091204 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -14,7 +14,7 @@
 #define NULL_SEGNO			((unsigned int)(~0))
 #define NULL_SECNO			((unsigned int)(~0))
 
-#define DEF_RECLAIM_PREFREE_SEGMENTS	100	/* 200MB of prefree segments */
+#define DEF_RECLAIM_PREFREE_SEGMENTS	5	/* 5% over total segments */
 
 /* L: Logical segment # in volume, R: Relative segment # in main area */
 #define GET_L2R_SEGNO(free_i, segno)	(segno - free_i->start_segno)
-- 
1.8.4.474.g128a96c

