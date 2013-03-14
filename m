Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3CNKxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:53:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51916 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab3CNKhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Justin Lecher <jlec@gentoo.org>, Suresh Jayaraman <sjayaraman@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 43/88] fs: cachefiles: add support for large files in filesystem caching
Date: Thu, 14 Mar 2013 10:35:36 +0000
Message-Id: <1363257381-15900-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cachefiles/rdwr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 0e3c092..b4d2438 100644
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
-- 
1.8.1.2

