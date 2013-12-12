Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3LLCMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:12:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33660 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3LLCMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:12:44 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-c3-52a91b95a3e5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: introduce sysfs entry to control in-place-update policy
Date: Thu, 12 Dec 2013 11:11:32 +0900
Message-id: <1386814292-25175-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zY92p0iuDDGbP17a4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PVqeSCU8YVJ1d8
	ZmtgPKfRxcjJISFgInFm2052CFtM4sK99WxdjFwcQgLLGCXWf/zEClN05dJWJojEIkaJi72/
	GEESQgLNTBLvvpV0MXJwsAloS2zebwASFhFgllgw9TwjSD2zwARGif+L3rOAJIQF/CTObVnL
	DGKzCKhK/L/2khmkl1fAXeLF5DiIXdoS255PBOuVEHjMJvG04wUbRL2AxLfJh1hA6iUEZCU2
	HWCGqJeUOLjiBssERsEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MULCr28H480D1ocY
	k4HGTWSWEk3OB4ZvXkm8obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgFGU96mK6JqOlpbOA7fcNwWl7vp3Y0JzLModLZNU+x+W83RvKQtIumJv75V8Q
	t+dtsJzMK9nCUNjKtt74WEhtYraQ9eXNL2W3cXdeZ0+q/cx6Vqksp/q4acOM1Qaz6x4s2uBZ
	zn8h71vJdt5EYenunKCIONmkQ+qTlOxlVPpdd1lO776WdUGJpTgj0VCLuag4EQB6K9afVQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAd2p0iuDDCbNVbO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFj1ankglPGFSdXfGZrYDyn0cXIySEhYCJx5dJWJghbTOLCvfVsXYxcHEIC
	ixglLvb+YgRJCAk0M0m8+1bSxcjBwSagLbF5vwFIWESAWWLB1POMIPXMAhMYJf4ves8CkhAW
	8JM4t2UtM4jNIqAq8f/aS2aQXl4Bd4kXk+MgdmlLbHs+kXECI/cCRoZVjKKpBckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGMHB/UxqB+PKBotDjAIcjEo8vC8OrggSYk0sK67MPcQowcGsJML7RGhl
	kBBvSmJlVWpRfnxRaU5q8SHGZKDlE5mlRJPzgZGXVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbr
	QCGB9MSS1OzU1ILUIpgtTBycUg2M3PoH2lq9Fx6p5Dn7zPZgD49JqNNW1VzvXq3T8yITOQ9f
	2n+ukOu6eQx38ZxLbUu3mC/py+KdPjd0ym7OFT3iKXcuKJm88Vqjv2KK4Yvwpws7f2yzebe2
	50ta8NSSfyevzijJ8nR4r/ihnu36rsTlylteTV5xWaVL6+fE1T/Cy4V5I/oX3RVyUGIpzkg0
	1GIuKk4EAEPEQW2yAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new sysfs entries for users to control the policy of
in-place-updates, namely IPU, in f2fs.

Sometimes f2fs suffers from performance degradation due to its out-of-place
update policy that produces many additional node block writes.
If the storage performance is very dependant on the amount of data writes
instead of IO patterns, we'd better drop this out-of-place update policy.

This patch suggests 5 polcies and their triggering conditions as follows.

[sysfs entry name = ipu_policy]

0: F2FS_IPU_FORCE       all the time,
1: F2FS_IPU_SSR         if SSR mode is activated,
2: F2FS_IPU_UTIL        if FS utilization is over threashold,
3: F2FS_IPU_SSR_UTIL    if SSR mode is activated and FS utilization is over
                        threashold,
4: F2FS_IPUT_DISABLE    disable IPU. (=default option)

[sysfs entry name = min_ipu_util]

This parameter controls the threshold to trigger in-place-updates.
The number indicates percentage of the filesystem utilization, and used by
F2FS_IPU_UTIL and F2FS_IPU_SSR_UTIL policies.

For more details, see need_inplace_update() in segment.h.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 11 ++++++++++
 fs/f2fs/f2fs.h                     |  3 +++
 fs/f2fs/segment.c                  |  2 ++
 fs/f2fs/segment.h                  | 44 ++++++++++++++++++++++++++++++++------
 fs/f2fs/super.c                    |  4 ++++
 5 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index a3fe811..4f9b146 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -171,6 +171,17 @@ Files in /sys/fs/f2fs/<devname>
 			      conduct checkpoint to reclaim the prefree segments
 			      to free segments. By default, 100 segments, 200MB.
 
+ ipu_policy                   This parameter controls the policy of in-place
+                              updates in f2fs. There are five policies:
+                               0: F2FS_IPU_FORCE, 1: F2FS_IPU_SSR,
+                               2: F2FS_IPU_UTIL,  3: F2FS_IPU_SSR_UTIL,
+                               4: F2FS_IPUT_DISABLE.
+
+ min_ipu_util                 This parameter controls the threshold to trigger
+                              in-place-updates. The number indicates percentage
+                              of the filesystem utilization, and used by
+                              F2FS_IPU_UTIL and F2FS_IPU_SSR_UTIL policies.
+
 ================================================================================
 USAGE
 ================================================================================
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 022ce32..1b05a62 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -325,6 +325,9 @@ struct f2fs_sm_info {
 	struct list_head discard_list;		/* 4KB discard list */
 	int nr_discards;			/* # of discards in the list */
 	int max_discards;			/* max. discards to be issued */
+
+	unsigned int ipu_policy;	/* in-place-update policy */
+	unsigned int min_ipu_util;	/* in-place-update threshold */
 };
 
 /*
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0b2e8ce..5b890ce 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1799,6 +1799,8 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->main_segments = le32_to_cpu(raw_super->segment_count_main);
 	sm_info->ssa_blkaddr = le32_to_cpu(raw_super->ssa_blkaddr);
 	sm_info->rec_prefree_segments = DEF_RECLAIM_PREFREE_SEGMENTS;
+	sm_info->ipu_policy = F2FS_IPU_DISABLE;
+	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
 
 	INIT_LIST_HEAD(&sm_info->discard_list);
 	sm_info->nr_discards = 0;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index ea56376..e9a10bd 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -476,19 +476,51 @@ static inline int utilization(struct f2fs_sb_info *sbi)
 
 /*
  * Sometimes f2fs may be better to drop out-of-place update policy.
- * So, if fs utilization is over MIN_IPU_UTIL, then f2fs tries to write
- * data in the original place likewise other traditional file systems.
- * But, currently set 100 in percentage, which means it is disabled.
- * See below need_inplace_update().
+ * And, users can control the policy through sysfs entries.
+ * There are five policies with triggering conditions as follows.
+ * F2FS_IPU_FORCE - all the time,
+ * F2FS_IPU_SSR - if SSR mode is activated,
+ * F2FS_IPU_UTIL - if FS utilization is over threashold,
+ * F2FS_IPU_SSR_UTIL - if SSR mode is activated and FS utilization is over
+ *                     threashold,
+ * F2FS_IPUT_DISABLE - disable IPU. (=default option)
  */
-#define MIN_IPU_UTIL		100
+#define DEF_MIN_IPU_UTIL	70
+
+enum {
+	F2FS_IPU_FORCE,
+	F2FS_IPU_SSR,
+	F2FS_IPU_UTIL,
+	F2FS_IPU_SSR_UTIL,
+	F2FS_IPU_DISABLE,
+};
+
 static inline bool need_inplace_update(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+	/* IPU can be done only for the user data */
 	if (S_ISDIR(inode->i_mode))
 		return false;
-	if (need_SSR(sbi) && utilization(sbi) > MIN_IPU_UTIL)
+
+	switch (SM_I(sbi)->ipu_policy) {
+	case F2FS_IPU_FORCE:
 		return true;
+	case F2FS_IPU_SSR:
+		if (need_SSR(sbi))
+			return true;
+		break;
+	case F2FS_IPU_UTIL:
+		if (utilization(sbi) > SM_I(sbi)->min_ipu_util)
+			return true;
+		break;
+	case F2FS_IPU_SSR_UTIL:
+		if (need_SSR(sbi) && utilization(sbi) > SM_I(sbi)->min_ipu_util)
+			return true;
+		break;
+	case F2FS_IPU_DISABLE:
+		break;
+	}
 	return false;
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 5c574fa..f16da92 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -178,6 +178,8 @@ F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_no_gc_sleep_time, no_gc_sleep_time);
 F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_idle, gc_idle);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, reclaim_segments, rec_prefree_segments);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, max_small_discards, max_discards);
+F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, ipu_policy, ipu_policy);
+F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, min_ipu_util, min_ipu_util);
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
@@ -187,6 +189,8 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(gc_idle),
 	ATTR_LIST(reclaim_segments),
 	ATTR_LIST(max_small_discards),
+	ATTR_LIST(ipu_policy),
+	ATTR_LIST(min_ipu_util),
 	NULL,
 };
 
-- 
1.8.4.474.g128a96c

