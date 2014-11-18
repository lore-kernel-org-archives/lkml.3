Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaKROOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:14:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbaKROK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 189/206] mm: Remove false WARN_ON from pagecache_isize_extended()
Date: Tue, 18 Nov 2014 15:09:04 +0100
Message-Id: <50c36a9ad170f54c46c22a59a94f75ebcb2e51fd.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f55fefd1a5a339b1bd08c120b93312d6eb64a9fb upstream.

The WARN_ON checking whether i_mutex is held in
pagecache_isize_extended() was wrong because some filesystems (e.g.
XFS) use different locks for serialization of truncates / writes. So
just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/truncate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 7dfb7c70fd4b..827ad8d2b5cd 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -697,7 +697,6 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 	struct page *page;
 	pgoff_t index;
 
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
 	WARN_ON(to > inode->i_size);
 
 	if (from >= to || bsize == PAGE_CACHE_SIZE)
-- 
2.1.3

