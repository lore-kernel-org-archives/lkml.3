Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbaD2O4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:56:14 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54729 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaD2O4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:56:10 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nick Swenson <nks@daterainc.com>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/3] blk-mq: add percpu_ida kobjects
Date: Tue, 29 Apr 2014 22:53:53 +0800
Message-Id: <1398783234-7062-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
References: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that the percpu_ida performance can be monitored.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq-sysfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 8145b5b..4171ae2 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -329,6 +329,8 @@ void blk_mq_unregister_disk(struct gendisk *disk)
 			kobject_del(&ctx->kobj);
 			kobject_put(&ctx->kobj);
 		}
+		percpu_ida_kobject_del(&hctx->tags->free_tags);
+		percpu_ida_kobject_del(&hctx->tags->reserved_tags);
 		kobject_del(&hctx->kobj);
 		kobject_put(&hctx->kobj);
 	}
@@ -362,6 +364,11 @@ int blk_mq_register_disk(struct gendisk *disk)
 		if (ret)
 			break;
 
+		percpu_ida_kobject_add(&hctx->tags->free_tags,
+				&hctx->kobj, "free_tags");
+		percpu_ida_kobject_add(&hctx->tags->reserved_tags,
+				&hctx->kobj, "reserved_tags");
+
 		if (!hctx->nr_ctx)
 			continue;
 
-- 
1.7.9.5

