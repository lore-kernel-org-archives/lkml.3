Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab3J2CAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 22:00:09 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:64703 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3J2CAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 22:00:08 -0400
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 10:00:07 +0800
Message-ID: <CAPgLHd_bHP-DMMbsFkc1RwmDK4dp+cZY8LRBFyDDuoEohJ-O_g@mail.gmail.com>
Subject: [PATCH] befs: fix return value check in befs_iget()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: viro@zeniv.linux.org.uk, ebiederm@xmission.com, keescook@chromium.org,
        serge.hallyn@canonical.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function iget_locked() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check should
be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/befs/linuxvfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index e9c75e2..d714dda 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -319,8 +319,8 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", ino);
 
 	inode = iget_locked(sb, ino);
-	if (IS_ERR(inode))
-		return inode;
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
 		return inode;
 

