Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaKKLLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaKKLLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 170/170] mm: Remove false WARN_ON from pagecache_isize_extended()
Date: Tue, 11 Nov 2014 11:08:49 +0000
Message-Id: <1415704129-12709-171-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit f55fefd1a5a339b1bd08c120b93312d6eb64a9fb upstream.

The WARN_ON checking whether i_mutex is held in
pagecache_isize_extended() was wrong because some filesystems (e.g.
XFS) use different locks for serialization of truncates / writes. So
just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/truncate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index ed6e91a695e0..699494e6aba5 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -764,7 +764,6 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 	struct page *page;
 	pgoff_t index;
 
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
 	WARN_ON(to > inode->i_size);
 
 	if (from >= to || bsize == PAGE_CACHE_SIZE)
-- 
2.1.0

