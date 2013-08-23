Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3HWAaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 20:30:24 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64411 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3HWAaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 20:30:23 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 08:30:20 +0800
Message-ID: <CAPgLHd-bUFP3Rr+yBkSgP7mm12dx4oHAvuZgswf1eTkhkdBdaA@mail.gmail.com>
Subject: [PATCH -next] f2fs: fix error return code in init_f2fs_fs()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jaegeuk.kim@samsung.com, namjae.jeon@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the kset create and add error handling
case instead of 0, as done elsewhere in this function.

Introduced by commit b59d0bae6ca30c496f298881616258f9cde0d9c6.
(f2fs: add sysfs support for controlling the gc_thread)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/f2fs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 66d1ec1..33a809f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1013,8 +1013,10 @@ static int __init init_f2fs_fs(void)
 	if (err)
 		goto fail;
 	f2fs_kset = kset_create_and_add("f2fs", NULL, fs_kobj);
-	if (!f2fs_kset)
+	if (!f2fs_kset) {
+		err = -ENOMEM;
 		goto fail;
+	}
 	err = register_filesystem(&f2fs_fs_type);
 	if (err)
 		goto fail;

