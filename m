Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab3CDERB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:17:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60825 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535Ab3CDDmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:43 -0500
Message-Id: <20130304033722.302468842@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Justin Lecher <jlec@gentoo.org>,
        Suresh Jayaraman <sjayaraman@suse.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 150/153] fs: cachefiles: add support for large files in filesystem caching
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -918,7 +918,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 	 * own time */
 	dget(object->backer);
 	mntget(cache->mnt);
-	file = dentry_open(object->backer, cache->mnt, O_RDWR,
+	file = dentry_open(object->backer, cache->mnt, O_RDWR | O_LARGEFILE,
 			   cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);



