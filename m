Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaDSKBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 06:01:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40849 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaDSKAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 06:00:47 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>,
        =?UTF-8?q?J=C3=B6rg-Volker=20Peetz?= <jvpeetz@web.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v1 next 3/4] blk-mq: user (1 << order) to implement order_to_size()
Date: Sat, 19 Apr 2014 18:00:18 +0800
Message-Id: <1397901619-27226-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
References: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jörg-Volker Peetz <jvpeetz@web.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c277797..3a560a4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1130,12 +1130,7 @@ static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
 
 static size_t order_to_size(unsigned int order)
 {
-	size_t ret = PAGE_SIZE;
-
-	while (order--)
-		ret *= 2;
-
-	return ret;
+	return (size_t)PAGE_SIZE << order;
 }
 
 static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
-- 
1.7.9.5

