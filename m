Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3CLXH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:07:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3CLWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 062/100] vfs: dont BUG_ON() if following a /proc fd pseudo-symlink results in a symlink
Date: Tue, 12 Mar 2013 15:31:47 -0700
Message-Id: <20130312223129.642831856@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7b54c165a0c012edbaeaa73c5c87cb73721eb580 upstream.

It's "normal" - it can happen if the file descriptor you followed was
opened with O_NOFOLLOW.

Reported-by: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -693,8 +693,6 @@ void nd_jump_link(struct nameidata *nd,
 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
 	nd->flags |= LOOKUP_JUMPED;
-
-	BUG_ON(nd->inode->i_op->follow_link);
 }
 
 static inline void put_link(struct nameidata *nd, struct path *link, void *cookie)


