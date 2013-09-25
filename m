Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3IYAWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:22:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab3IYAVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anand Avati <avati@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 115/117] fuse: invalidate inode attributes on xattr modification
Date: Tue, 24 Sep 2013 17:19:41 -0700
Message-Id: <20130925001753.494277084@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Avati <avati@redhat.com>

commit d331a415aef98717393dda0be69b7947da08eba3 upstream.

Calls like setxattr and removexattr result in updation of ctime.
Therefore invalidate inode attributes to force a refresh.

Signed-off-by: Anand Avati <avati@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1749,6 +1749,8 @@ static int fuse_setxattr(struct dentry *
 		fc->no_setxattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
@@ -1878,6 +1880,8 @@ static int fuse_removexattr(struct dentr
 		fc->no_removexattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 


