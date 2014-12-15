Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaLOTcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:32:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaLOTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:32:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Andy Whitcroft <apw@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 96/96] mm: Remove false WARN_ON from pagecache_isize_extended()
Date: Mon, 15 Dec 2014 11:26:56 -0800
Message-Id: <1418671616-25482-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

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
Buglink: http://bugs.launchpad.net/bugs/1402764
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/truncate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 855c38c..ac18edc 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -649,7 +649,6 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 	struct page *page;
 	pgoff_t index;
 
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
 	WARN_ON(to > inode->i_size);
 
 	if (from >= to || bsize == PAGE_CACHE_SIZE)
-- 
1.9.1

