Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaFKKdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:33:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22466 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFKKdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:33:22 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-86-539830706404
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: remove unused variables in f2fs_sm_info
Date: Wed, 11 Jun 2014 18:32:23 +0800
Message-id: <006b01cf8560$91034920$b309db60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+FYEvJXvXLoiPBSzOwMYa0FDZeLg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd0CgxnBBjubJC2erJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgynh7vLzgHVfFgicy
	DYxtnF2MnBwSAiYS79bPYYawxSQu3FvP1sXIxSEksIhRoqvvFzuE84NRYuerv+wgVWwCKhLL
	O/4zgdgiQPahRZfB4swCmRL3mmaATRIW8JC49GEXI4jNIqAqMevwDLAaXgFLiUVznrFC2IIS
	PybfY4Ho1ZLYvK2JFcKWl9i85i3URQoSO86+ZoTYpSdx4/NyZogacYmNR26xTGAUmIVk1Cwk
	o2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFh/ExqB+PKBotDjAIcjEo8
	vAckpgcLsSaWFVfmHmKU4GBWEuG9pTgjWIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB
	9MSS1OzU1ILUIpgsEwenVAMj6/lqxQlLgm1n1/AmnV+Z0f7GuVje58Bqq09vRP2ZojdbPHs/
	1+v7huaDa6bW1WZNqMz6uPZ4UPY8ZZX91X8t2i6eODyvdenl/63LInd4PL/LzqcePZ1bv22W
	4VWD2lbzV1omM7c6ek8ysL1a5S7D0fzz97Gki+9iJOWLlJemJrjxaOyZ2FatxFKckWioxVxU
	nAgAzOxOSV8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variables in struct f2fs_sm_info.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h    |    3 ---
 fs/f2fs/segment.c |    2 --
 2 files changed, 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e51c732..7ef7acd 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -342,9 +342,6 @@ struct f2fs_sm_info {
 	struct dirty_seglist_info *dirty_info;	/* dirty segment information */
 	struct curseg_info *curseg_array;	/* active segment information */
 
-	struct list_head wblist_head;	/* list of under-writeback pages */
-	spinlock_t wblist_lock;		/* lock for checkpoint */
-
 	block_t seg0_blkaddr;		/* block address of 0'th segment */
 	block_t main_blkaddr;		/* start block address of main area */
 	block_t ssa_blkaddr;		/* start block address of SSA area */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index f25f0e0..b22d5a0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1885,8 +1885,6 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 
 	/* init sm info */
 	sbi->sm_info = sm_info;
-	INIT_LIST_HEAD(&sm_info->wblist_head);
-	spin_lock_init(&sm_info->wblist_lock);
 	sm_info->seg0_blkaddr = le32_to_cpu(raw_super->segment0_blkaddr);
 	sm_info->main_blkaddr = le32_to_cpu(raw_super->main_blkaddr);
 	sm_info->segment_count = le32_to_cpu(raw_super->segment_count);
-- 
1.7.9.5


