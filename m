Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbaGDS2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:28:51 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:15371 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759361AbaGDS2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:28:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMPAFPxtlNbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BkiiHP4ELF3WECwIkLyNJOQcRN4guAxUBtUmOLA2GUheFcIcKgigZBAmEJAWOG4lvbIIAiBGFZ4YUg0U7gTo
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH 1/1] 9p: kerneldoc warning fixes
Date: Fri,  4 Jul 2014 20:28:44 +0200
Message-Id: <1404498524-12123-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

options argument was removed from v9fs_session_info in commit 4b53e4b50077
("9p: remove unnecessary v9fses->options which duplicates the mount string")

iov and nr_segs were removed from v9fs_direct_IO
in commit d8d3d94b80aa
("pass iov_iter to ->direct_IO()")

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/9p/v9fs.h     | 1 -
 fs/9p/vfs_addr.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 099c771..fb9ffcb 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -78,7 +78,6 @@ enum p9_cache_modes {
  * @cache: cache mode of type &p9_cache_modes
  * @cachetag: the tag of the cache associated with this session
  * @fscache: session cookie associated with FS-Cache
- * @options: copy of options string given by user
  * @uname: string user name to mount hierarchy as
  * @aname: mount specifier for remote hierarchy
  * @maxdata: maximum data to be sent/recvd per protocol message
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index cc1cfae..076d3ef 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -243,9 +243,7 @@ static int v9fs_launder_page(struct page *page)
  * v9fs_direct_IO - 9P address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
  * @pos: offset in file to begin the operation
- * @nr_segs: size of iovec array
  *
  * The presence of v9fs_direct_IO() in the address space ops vector
  * allowes open() O_DIRECT flags which would have failed otherwise.
-- 
1.9.1

