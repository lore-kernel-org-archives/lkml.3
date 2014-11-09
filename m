Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaKIHgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 02:36:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:55421 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbaKIHgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 02:36:18 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/5] f2fs: do not skip any writes under memory pressure
Date: Sat,  8 Nov 2014 23:36:09 -0800
Message-Id: <1415518569-20626-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under memory pressure, let's avoid skipping data writes.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 6723ccc..7f327c0 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -711,6 +711,9 @@ static inline unsigned int max_hw_blocks(struct f2fs_sb_info *sbi)
  */
 static inline int nr_pages_to_skip(struct f2fs_sb_info *sbi, int type)
 {
+	if (sbi->sb->s_bdi->dirty_exceeded)
+		return 0;
+
 	if (type == DATA)
 		return sbi->blocks_per_seg;
 	else if (type == NODE)
-- 
2.1.1

