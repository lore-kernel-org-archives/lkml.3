Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117Ab3DGQ5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 12:57:38 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61941 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934098Ab3DGQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 12:57:37 -0400
From: Zhihui Zhang <zzhsuny@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Zhihui Zhang <zzhsuny@gmail.com>
Subject: [PATCH] F2FS: Fix the logic of IS_DNODE()
Date: Sun,  7 Apr 2013 12:57:04 -0400
Message-Id: <1365353824-11745-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 fs/f2fs/node.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index afdb130..2be47b2 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -239,7 +239,7 @@ static inline bool IS_DNODE(struct page *node_page)
 		return false;
 	if (ofs >= 6 + 2 * NIDS_PER_BLOCK) {
 		ofs -= 6 + 2 * NIDS_PER_BLOCK;
-		if ((long int)ofs % (NIDS_PER_BLOCK + 1))
+		if (!((long int)ofs % (NIDS_PER_BLOCK + 1)))
 			return false;
 	}
 	return true;
-- 
1.7.9.5

