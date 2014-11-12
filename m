Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaKLQdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:33:52 -0500
Received: from mx02.posteo.de ([89.146.194.165]:35722 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbaKLQdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:33:50 -0500
From: Martin Kepplinger <martink@posteo.de>
To: miklos@szeredi.hu
Cc: fuse-devel@lists.sourceforge.net, thierry.reding@gmail.com,
        gregkh@linuxfoundation.org, giedriuswork@gmail.com,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] fuse: don't check for file->private_data on open().
Date: Wed, 12 Nov 2014 17:31:34 +0100
Message-Id: <1415809894-24084-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20141112112643.GA30821@ulmo.nvidia.com>
References: <20141112112643.GA30821@ulmo.nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The miscdevice core now sets file->private_data to the struct miscdevice
so don't fail when this is not NULL.

Reported-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
This is a question: what does this check provide and does overwriting
file->private_data make any difference?

Is open() by the user not allowed here, if file->private_data is set?

thanks!!

 fs/fuse/inode.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 03246cd..562407e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1092,9 +1092,6 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	mutex_lock(&fuse_mutex);
-	err = -EINVAL;
-	if (file->private_data)
-		goto err_unlock;
 
 	err = fuse_ctl_add_conn(fc);
 	if (err)
-- 
1.7.10.4

