Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3DMH6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 03:58:55 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34470 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3DMH6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 03:58:53 -0400
Message-ID: <51691037.80901@gmail.com>
Date: Sat, 13 Apr 2013 15:58:47 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH]fs/block_dev.c: Using .ki_left to judge whether do used
 .ki_left to judge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/block_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index aae187a..f0328f1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1559,7 +1559,7 @@ static ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
         return 0;
 
     size -= pos;
-    if (size < INT_MAX)
+    if (size < iocb->ki_left)
         nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);
     return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
-- 
1.8.2.rc2.4.g7799588

