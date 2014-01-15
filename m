Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaAOR6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:58:35 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:42961 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752979AbaAOR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:58:31 -0500
Date: Wed, 15 Jan 2014 19:58:28 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <viro@zeniv.linux.org.uk>
CC: <ebiederm@xmission.com>, <keescook@chromium.org>, <rakesh@tuxera.com>,
        <serge.hallyn@canonical.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] befs: iget_locked() doesn't return an ERR_PTR
Message-ID: <20140115175828.GA3514@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix befs_iget return value if iget_locked fails.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 fs/befs/linuxvfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index daa15d6..845d2d6 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -324,8 +324,8 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", ino);
 
 	inode = iget_locked(sb, ino);
-	if (IS_ERR(inode))
-		return inode;
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
 		return inode;
 
-- 
1.7.11.7
