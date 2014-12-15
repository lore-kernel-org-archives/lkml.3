Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLOH1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:27:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:34416 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaLOH1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:27:41 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/7] f2fs: fix wrong condition check to trigger f2fs_sync_fs
Date: Sun, 14 Dec 2014 23:27:33 -0800
Message-Id: <1418628458-82740-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
References: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is not enough available memory, we need to trigger f2fs_sync_fs.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 42607a6..11e4b5c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -290,7 +290,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
 	/* check the # of cached NAT entries and prefree segments */
 	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK) ||
 			excess_prefree_segs(sbi) ||
-			available_free_memory(sbi, INO_ENTRIES))
+			!available_free_memory(sbi, INO_ENTRIES))
 		f2fs_sync_fs(sbi->sb, true);
 }
 
-- 
2.1.1

