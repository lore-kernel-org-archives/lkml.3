Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaJ2FGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:06:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:42420 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaJ2FF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:05:57 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/4] f2fs: do not discard data protected by the previous checkpoint
Date: Tue, 28 Oct 2014 22:05:52 -0700
Message-Id: <1414559153-92771-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414559153-92771-1-git-send-email-jaegeuk@kernel.org>
References: <1414559153-92771-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not discard any data protected by the previous checkpoint all
the time.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d391a59..06dda73 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -517,7 +517,7 @@ static void add_discard_addrs(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* SIT_VBLOCK_MAP_SIZE should be multiple of sizeof(unsigned long) */
 	for (i = 0; i < entries; i++)
-		dmap[i] = (cur_map[i] ^ ckpt_map[i]) & ckpt_map[i];
+		dmap[i] = ~(cur_map[i] | ckpt_map[i]);
 
 	while (force || SM_I(sbi)->nr_discards <= SM_I(sbi)->max_discards) {
 		start = __find_rev_next_bit(dmap, max_blocks, end + 1);
-- 
2.1.1

