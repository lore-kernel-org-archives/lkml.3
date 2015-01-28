Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965455AbbA1E1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:27:38 -0500
Received: from mail.kernel.org ([198.145.29.136]:41537 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965386AbbA1E0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:40 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 175/177] mm: Remove false WARN_ON from pagecache_isize_extended()
Date: Wed, 28 Jan 2015 12:10:33 +0800
Message-Id: <1422418236-12852-266-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit f55fefd1a5a339b1bd08c120b93312d6eb64a9fb upstream.

The WARN_ON checking whether i_mutex is held in
pagecache_isize_extended() was wrong because some filesystems (e.g.
XFS) use different locks for serialization of truncates / writes. So
just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/truncate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 708a499..57625f7 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -607,7 +607,6 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 	struct page *page;
 	pgoff_t index;
 
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
 	WARN_ON(to > inode->i_size);
 
 	if (from >= to || bsize == PAGE_CACHE_SIZE)
-- 
1.9.1

