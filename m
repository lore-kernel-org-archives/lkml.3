Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3JUR5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:57:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab3JUR5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:57:21 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: [patch] blk-mq: zero out ctx_map during initialization
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 21 Oct 2013 13:57:19 -0400
Message-ID: <x491u3ecxs0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ctx_map may contain random garbage, leading to (potentially chronic but
harmless) false positives in blk_mq_hctx_has_pending.

Note: I have not observed this in practice, just by code inspection.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 923e9e1..e9be5ed 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1197,7 +1197,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 			break;
 
 		num_maps = ALIGN(nr_cpu_ids, BITS_PER_LONG) / BITS_PER_LONG;
-		hctx->ctx_map = kmalloc_node(num_maps * sizeof(unsigned long),
+		hctx->ctx_map = kzalloc_node(num_maps * sizeof(unsigned long),
 						GFP_KERNEL, node);
 		if (!hctx->ctx_map)
 			break;
