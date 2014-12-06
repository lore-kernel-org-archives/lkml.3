Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaLFTzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 14:55:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:37328 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaLFTzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 14:55:46 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/5] f2fs: set page private for inmemory pages for truncation
Date: Sat,  6 Dec 2014 11:55:37 -0800
Message-Id: <1417895739-15251-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
References: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inmemory pages should be handled by invalidate_page since it needs to be
released int the truncation path.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c79d67e..3ebcf96 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -180,6 +180,8 @@ void register_inmem_page(struct inode *inode, struct page *page)
 	struct inmem_pages *new;
 	int err;
 
+	SetPagePrivate(page);
+
 	new = f2fs_kmem_cache_alloc(inmem_entry_slab, GFP_NOFS);
 
 	/* add atomic page indices to the list */
-- 
2.1.1

