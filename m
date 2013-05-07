Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3EGOOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:14:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3EGNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 010/118] hfsplus: fix potential overflow in hfsplus_file_truncate()
Date: Tue,  7 May 2013 14:37:36 +0100
Message-Id: <1367933964-1564-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Dubeyko <slava@dubeyko.com>

commit 12f267a20aecf8b84a2a9069b9011f1661c779b4 upstream.

Change a u32 to loff_t hfsplus_file_truncate().

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/hfsplus/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 5849e3e..32b12e5 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -517,7 +517,7 @@ void hfsplus_file_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
+		loff_t size = inode->i_size;
 
 		res = pagecache_write_begin(NULL, mapping, size, 0,
 						AOP_FLAG_UNINTERRUPTIBLE,
-- 
1.8.1.2

