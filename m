Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3C0TyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:54:16 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:38550 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3C0TyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:54:15 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] fs: f2fs: Use kmemdup
Date: Wed, 27 Mar 2013 21:53:31 +0200
Message-Id: <1364414011-3144-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used kmemdup instead of kzalloc followed by memcpy.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 fs/f2fs/segment.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 777f17e..1758149 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1403,10 +1403,9 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 	bitmap_size = __bitmap_size(sbi, SIT_BITMAP);
 	src_bitmap = __bitmap_ptr(sbi, SIT_BITMAP);
 
-	dst_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	dst_bitmap = kmemdup(src_bitmap, bitmap_size, GFP_KERNEL);
 	if (!dst_bitmap)
 		return -ENOMEM;
-	memcpy(dst_bitmap, src_bitmap, bitmap_size);
 
 	/* init SIT information */
 	sit_i->s_ops = &default_salloc_ops;
-- 
1.7.9.5

