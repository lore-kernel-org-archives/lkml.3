Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaJ2FGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:06:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:42407 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaJ2FF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:05:56 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/4] f2fs: flush_dcache_page for inline data
Date: Tue, 28 Oct 2014 22:05:51 -0700
Message-Id: <1414559153-92771-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414559153-92771-1-git-send-email-jaegeuk@kernel.org>
References: <1414559153-92771-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading inline data, we should call flush_dcache_page.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index d9daf76..d6677d6 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -57,6 +57,7 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	src_addr = inline_data_addr(ipage);
 	dst_addr = kmap_atomic(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+	flush_dcache_page(page);
 	kunmap_atomic(dst_addr);
 	f2fs_put_page(ipage, 1);
 out:
-- 
2.1.1

