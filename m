Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3CKNph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:45:37 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:52231 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3CKNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:45:36 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 21:45:34 +0800
Message-ID: <CAPgLHd-GV3sHfWdFMKY_Y1qAb9kSvsU98PAXiDA1ur49ErjqLw@mail.gmail.com>
Subject: [PATCH -next] staging: sync: fix return value check in sync_fence_alloc()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, konkers@android.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function anon_inode_getfile() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/android/sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index b9bb974..bf66c19 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -261,7 +261,7 @@ static struct sync_fence *sync_fence_alloc(const char *name)
 
 	fence->file = anon_inode_getfile("sync_fence", &sync_fence_fops,
 					 fence, 0);
-	if (fence->file == NULL)
+	if (IS_ERR(fence->file))
 		goto err;
 
 	kref_init(&fence->kref);

