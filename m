Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbbALSGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57502 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbbALSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@fb.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 047/216] blk-mq: use 'nr_cpu_ids' as highest CPU ID count for hwq <-> cpu map
Date: Mon, 12 Jan 2015 18:02:44 +0000
Message-Id: <1421085933-32536-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit a33c1ba2913802b6fb23e974bb2f6a4e73c8b7ce upstream.

We currently use num_possible_cpus(), but that breaks on sparc64 where
the CPU ID space is discontig. Use nr_cpu_ids as the highest CPU ID
instead, so we don't end up reading from invalid memory.

Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk-mq-cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 1065d7c65fa1..72e5ed691e37 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -90,7 +90,7 @@ unsigned int *blk_mq_make_queue_map(struct blk_mq_tag_set *set)
 	unsigned int *map;
 
 	/* If cpus are offline, map them to first hctx */
-	map = kzalloc_node(sizeof(*map) * num_possible_cpus(), GFP_KERNEL,
+	map = kzalloc_node(sizeof(*map) * nr_cpu_ids, GFP_KERNEL,
 				set->numa_node);
 	if (!map)
 		return NULL;
-- 
2.1.4

