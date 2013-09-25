Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3IYAMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:12:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3IYAMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anand Avati <avati@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 40/40] fuse: invalidate inode attributes on xattr modification
Date: Tue, 24 Sep 2013 17:12:12 -0700
Message-Id: <20130925001046.275408689@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1503,6 +1503,8 @@ static int fuse_setxattr(struct dentry *
 		fc->no_setxattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
@@ -1632,6 +1634,8 @@ static int fuse_removexattr(struct dentr
 		fc->no_removexattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 


