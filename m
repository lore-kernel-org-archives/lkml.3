Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaKYXkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:40:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:42282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaKYXkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:40:16 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] f2fs: make clean the page before writing
Date: Tue, 25 Nov 2014 15:39:56 -0800
Message-Id: <1416958796-39186-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416958796-39186-1-git-send-email-jaegeuk@kernel.org>
References: <1416958796-39186-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a page is set to be written to the disk, we can make clean the page.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 914b6d3..7c96c27 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -110,6 +110,9 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	kunmap_atomic(dst_addr);
 	SetPageUptodate(page);
 no_update:
+	/* clear dirty state */
+	clear_page_dirty_for_io(page);
+
 	/* write data page to try to make data consistent */
 	set_page_writeback(page);
 
-- 
2.1.1

