Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaFEE70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:59:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaFEEUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Justin Lecher <jlec@gentoo.org>,
        Suresh Jayaraman <sjayaraman@suse.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 078/214] fs: cachefiles: add support for large files in filesystem caching
Date: Wed,  4 Jun 2014 21:17:21 -0700
Message-Id: <20140605041650.046871508@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lecher <jlec@gentoo.org>

commit 98c350cda2c14a343d34ea01a3d9c24fea5ec66d upstream.

Support the caching of large files.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=31182

Signed-off-by: Justin Lecher <jlec@gentoo.org>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.com>
Tested-by: Suresh Jayaraman <sjayaraman@suse.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - dentry_open() takes dentry and vfsmount pointers, not a path pointer]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cachefiles/rdwr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -918,7 +918,7 @@ int cachefiles_write_page(struct fscache
 	 * own time */
 	dget(object->backer);
 	mntget(cache->mnt);
-	file = dentry_open(object->backer, cache->mnt, O_RDWR,
+	file = dentry_open(object->backer, cache->mnt, O_RDWR | O_LARGEFILE,
 			   cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);


