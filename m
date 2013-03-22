Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab3CVL3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:29:10 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:58520 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab3CVL3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:29:09 -0400
MIME-Version: 1.0
Date: Fri, 22 Mar 2013 19:29:07 +0800
Message-ID: <CAPgLHd-xuqvH6tr8d+78MjX-d7E6Jb_6oyb8hV_GMw-yYyBB0g@mail.gmail.com>
Subject: [PATCH -next] loopdev: fix error return code in loop_add()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, yan@linux.vnet.ibm.com,
        tj@kernel.org, ebiederm@xmission.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1e0cc5a..4afe38e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1638,6 +1638,7 @@ static int loop_add(struct loop_device **l, int i)
 		goto out_free_dev;
 	i = err;
 
+	err = -ENOMEM;
 	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!lo->lo_queue)
 		goto out_free_dev;


