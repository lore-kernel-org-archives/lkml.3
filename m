Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3EJTfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:35:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab3EJTd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:33:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/8] CacheFiles: name i_mutex lock class explicitly [ver #2]
To: Trond.Myklebust@netapp.com, torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cachefs@redhat.com, "J. Bruce Fields" <bfields@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 10 May 2013 20:33:23 +0100
Message-ID: <20130510193323.3045.57648.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130510193257.3045.77981.stgit@warthog.procyon.org.uk>
References: <20130510193257.3045.77981.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

Just some cleanup.

(And note the caller of this function may, for example, call vfs_unlink
on a child, so the "1" (I_MUTEX_PARENT) really was what was intended
here.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 8c01c5fc..07cbd44 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -836,7 +836,7 @@ static struct dentry *cachefiles_check_active(struct cachefiles_cache *cache,
 	//       dir->d_name.len, dir->d_name.len, dir->d_name.name, filename);
 
 	/* look up the victim */
-	mutex_lock_nested(&dir->d_inode->i_mutex, 1);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 
 	start = jiffies;
 	victim = lookup_one_len(filename, dir, strlen(filename));

