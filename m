Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaDVOXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:23:44 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14973 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbaDVOXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:23:42 -0400
Date: Tue, 22 Apr 2014 07:23:41 -0700
From: Drew Richardson <drew.richardson@arm.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] Export block tracepoints for use by kernel modules
Message-ID: <20140422142341.GC21121@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
Use struct pointer instead of name hash for reg/unreg tracepoints"),
any tracepoints used in a kernel module must be exported.

Signed-off-by: Drew Richardson <drew.richardson@arm.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 block/blk-core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096c4bb5..a23f958ef20a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -44,6 +44,21 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_unplug);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_touch_buffer);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_dirty_buffer);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_abort);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_requeue);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_complete);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_insert);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_issue);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_bounce);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_backmerge);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_frontmerge);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_queue);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_getrq);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_sleeprq);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_plug);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_split);
 
 DEFINE_IDA(blk_queue_ida);
 
-- 
1.8.3.2

