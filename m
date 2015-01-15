Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbbAOFmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 00:42:23 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:13100 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbAOFmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 00:42:22 -0500
Message-ID: <54B7532E.7010000@huawei.com>
Date: Thu, 15 Jan 2015 13:42:06 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>
CC: <hch@infradead.org>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] blk-mq: cleanup additional nr_hw_queues check
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54B7533C.0020,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 4dd040a605dcd6cf2087fd3742474a37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check set->nr_hw_queues twice in blk_mq_alloc_tag_set(),
remove the latter one.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 block/blk-mq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a7d4a98..eddeccc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2097,7 +2097,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (set->queue_depth < set->reserved_tags + BLK_MQ_TAG_MIN)
 		return -EINVAL;

-	if (!set->nr_hw_queues || !set->ops->queue_rq || !set->ops->map_queue)
+	if (!set->ops->queue_rq || !set->ops->map_queue)
 		return -EINVAL;

 	if (set->queue_depth > BLK_MQ_MAX_DEPTH) {
-- 
1.6.0.2

