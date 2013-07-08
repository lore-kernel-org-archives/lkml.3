Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3GHJwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:52:19 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:65130 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3GHJwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:52:14 -0400
Subject: [PATCH 3/5] hugetlbfs: remove cancel_dirty_page() from
 truncate_huge_page()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>
Date: Mon, 08 Jul 2013 13:52:10 +0400
Message-ID: <20130708095210.13810.6106.stgit@zurg>
In-Reply-To: <20130708095202.13810.11659.stgit@zurg>
References: <20130708095202.13810.11659.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no backend and writeback, dirty pages accounting is disabled.
ClearPageDirty() more suits for this place.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
---
 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index a3f868a..548badf 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -323,7 +323,7 @@ static int hugetlbfs_write_end(struct file *file, struct address_space *mapping,
 
 static void truncate_huge_page(struct page *page)
 {
-	cancel_dirty_page(page, /* No IO accounting for huge pages? */0);
+	ClearPageDirty(page);
 	ClearPageUptodate(page);
 	delete_from_page_cache(page);
 }

