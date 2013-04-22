Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3DVOt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:49:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452Ab3DVO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Hin-Tak Leung" <htl10@users.sourceforge.net>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Vyacheslav Dubeyko" <slava@dubeyko.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.768974199@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [70/75] hfsplus: fix potential overflow in hfsplus_file_truncate()
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/hfsplus/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -517,7 +517,7 @@ void hfsplus_file_truncate(struct inode
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
+		loff_t size = inode->i_size;
 
 		res = pagecache_write_begin(NULL, mapping, size, 0,
 						AOP_FLAG_UNINTERRUPTIBLE,

