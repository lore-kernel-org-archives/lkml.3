Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3LKGI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:08:26 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:39422 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3LKGIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:08:25 -0500
Message-ID: <52A80113.7060506@huawei.com>
Date: Wed, 11 Dec 2013 14:07:15 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <matthew@wil.cx>, <viro@zeniv.linux.org.uk>
CC: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Li Zefan" <lizefan@huawei.com>, <bfields@redhat.com>
Subject: [PATCH] fs: new helper: file_inode(file)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..a146e2a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2780,7 +2780,7 @@ static inline bool dir_emit(struct dir_context *ctx,
 static inline bool dir_emit_dot(struct file *file, struct dir_context *ctx)
 {
 	return ctx->actor(ctx, ".", 1, ctx->pos,
-			  file->f_path.dentry->d_inode->i_ino, DT_DIR) == 0;
+			  file_inode(file)->i_ino, DT_DIR) == 0;
 }
 static inline bool dir_emit_dotdot(struct file *file, struct dir_context *ctx)
 {
-- 
1.8.2.2

