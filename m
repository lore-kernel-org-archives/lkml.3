Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbaGDTxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:53:23 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:12756 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbaGDTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:53:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMMAG8Ft1NbsGwr/2dsb2JhbABSCIMOrHAFAQEBAQEBBQFuAZIohz+BCxd1hAsCUyOBCRE3iEYBtU6VIoVwiFxWHYQtBY4bgW6IAYJsiBGLe4NFOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH 1/1] ntfs: kernel-doc warning fixes
Date: Fri,  4 Jul 2014 21:53:18 +0200
Message-Id: <1404503598-32536-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cached_page and lru_pvec were removed from
ntfs_attr_extend_initialized in commit 2ec93b0bf35f
("ntfs: clean up ntfs_attr_extend_initialized")

lru_pvec has been removed from __ntfs_grab_cache_pages in commit 4c99000ac47c
("ntfs: use add_to_page_cache_lru()")

Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ntfs-dev@lists.sourceforge.net
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ntfs/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 5c9e2c8..f5ec1ce 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -74,8 +74,6 @@ static int ntfs_file_open(struct inode *vi, struct file *filp)
  * ntfs_attr_extend_initialized - extend the initialized size of an attribute
  * @ni:			ntfs inode of the attribute to extend
  * @new_init_size:	requested new initialized size in bytes
- * @cached_page:	store any allocated but unused page here
- * @lru_pvec:		lru-buffering pagevec of the caller
  *
  * Extend the initialized size of an attribute described by the ntfs inode @ni
  * to @new_init_size bytes.  This involves zeroing any non-sparse space between
@@ -395,7 +393,6 @@ static inline void ntfs_fault_in_pages_readable_iovec(const struct iovec *iov,
  * @nr_pages:	number of page cache pages to obtain
  * @pages:	array of pages in which to return the obtained page cache pages
  * @cached_page: allocated but as yet unused page
- * @lru_pvec:	lru-buffering pagevec of caller
  *
  * Obtain @nr_pages locked page cache pages from the mapping @mapping and
  * starting at index @index.
-- 
1.9.1

