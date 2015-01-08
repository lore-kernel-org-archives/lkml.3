Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbbAHSLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:11:24 -0500
Received: from mail.kernel.org ([198.145.29.136]:58467 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbbAHSLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:11:22 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/6] f2fs: add nat/sit entries into status
Date: Thu,  8 Jan 2015 10:10:59 -0800
Message-Id: <1420740661-72288-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds NAT/SIT entry informations.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/debug.c | 8 +++++---
 fs/f2fs/f2fs.h  | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index dd7835b..1f0fb58 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -57,7 +57,9 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->node_pages = NODE_MAPPING(sbi)->nrpages;
 	si->meta_pages = META_MAPPING(sbi)->nrpages;
 	si->nats = NM_I(sbi)->nat_cnt;
-	si->sits = SIT_I(sbi)->dirty_sentries;
+	si->dirty_nats = NM_I(sbi)->dirty_nat_cnt;
+	si->sits = MAIN_SEGS(sbi);
+	si->dirty_sits = SIT_I(sbi)->dirty_sentries;
 	si->fnids = NM_I(sbi)->fcnt;
 	si->bg_gc = sbi->bg_gc;
 	si->util_free = (int)(free_user_blocks(sbi) >> sbi->log_blocks_per_seg)
@@ -260,8 +262,8 @@ static int stat_show(struct seq_file *s, void *v)
 			   si->ndirty_dent, si->ndirty_dirs);
 		seq_printf(s, "  - meta: %4d in %4d\n",
 			   si->ndirty_meta, si->meta_pages);
-		seq_printf(s, "  - NATs: %9d\n  - SITs: %9d\n",
-			   si->nats, si->sits);
+		seq_printf(s, "  - NATs: %9d/%9d\n  - SITs: %9d/%9d\n",
+			   si->dirty_nats, si->nats, si->dirty_sits, si->sits);
 		seq_printf(s, "  - free_nids: %9d\n",
 			   si->fnids);
 		seq_puts(s, "\nDistribution of User Blocks:");
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index febad35..d39b230 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1513,7 +1513,7 @@ struct f2fs_stat_info {
 	int main_area_segs, main_area_sections, main_area_zones;
 	int hit_ext, total_ext;
 	int ndirty_node, ndirty_dent, ndirty_dirs, ndirty_meta;
-	int nats, sits, fnids;
+	int nats, dirty_nats, sits, dirty_sits, fnids;
 	int total_count, utilization;
 	int bg_gc, inline_inode, inline_dir, inmem_pages;
 	unsigned int valid_count, valid_node_count, valid_inode_count;
-- 
2.1.1

