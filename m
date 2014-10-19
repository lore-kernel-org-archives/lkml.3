Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaJSKkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:40:41 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaJSKkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:40:06 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH 1/2] fat: Fix d_splice_alias() return code checking
Date: Sun, 19 Oct 2014 12:39:43 +0200
Message-Id: <1413715184-30196-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
Currently the code checks not for ERR_PTR.
Fix this by using IS_ERR_OR_NULL().

Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/fat/namei_vfat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6df8d3d..8f93464 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -757,7 +757,7 @@ out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	dentry = d_splice_alias(inode, dentry);
-	if (dentry)
+	if (!IS_ERR_OR_NULL(dentry))
 		dentry->d_time = dentry->d_parent->d_inode->i_version;
 	return dentry;
 
-- 
2.1.0

