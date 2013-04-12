Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3DLCXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:23:23 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:32951 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3DLCXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:23:20 -0400
MIME-Version: 1.0
Date: Fri, 12 Apr 2013 10:23:18 +0800
Message-ID: <CAPgLHd8FKGg=JFK3_f2PJxNjS5S5OD-+PotHEKLM6pi9C5QJOg@mail.gmail.com>
Subject: [PATCH -next] f2fs: fix error return code in f2fs_fill_super()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jaegeuk.kim@samsung.com, namjae.jeon@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.
Introduce by commit c0d39e(f2fs: fix return values from validate superblock)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/f2fs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1b16cea..35b13b9 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -534,7 +534,8 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	set_opt(sbi, POSIX_ACL);
 #endif
 	/* parse mount options */
-	if (parse_options(sb, sbi, (char *)data))
+	err = parse_options(sb, sbi, (char *)data);
+	if (err)
 		goto free_sb_buf;
 
 	sb->s_maxbytes = max_file_size(le32_to_cpu(raw_super->log_blocksize));

