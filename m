Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3DWWHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:07:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab3DWVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:54:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 06/26] hfsplus: fix potential overflow in hfsplus_file_truncate()
Date: Tue, 23 Apr 2013 14:53:46 -0700
Message-Id: <20130423215334.021394830@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215333.344045754@linuxfoundation.org>
References: <20130423215333.344045754@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


