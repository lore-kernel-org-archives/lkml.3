Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbaJAMch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:32:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaJAMcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:32:36 -0400
From: Hannes Reinecke <hare@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] block: misplaced rq_complete tracepoint
Date: Wed,  1 Oct 2014 14:32:31 +0200
Message-Id: <1412166751-73709-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rq_complete tracepoint was never issued for empty requests,
causing the resulting blktrace information to never show any
completion for those request.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3aff9f5..eb05abf 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2414,11 +2414,11 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
 	int total_bytes;
 
+	trace_block_rq_complete(req->q, req, nr_bytes);
+
 	if (!req->bio)
 		return false;
 
-	trace_block_rq_complete(req->q, req, nr_bytes);
-
 	/*
 	 * For fs requests, rq is just carrier of independent bio's
 	 * and each partial completion should be handled separately.
-- 
1.8.5.2

