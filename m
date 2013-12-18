Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3LRMmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:42:04 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:46043 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3LRMl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:41:59 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 3/3] null_blk: warning on ignored submit_queues param
Date: Wed, 18 Dec 2013 13:41:44 +0100
Message-Id: <1387370504-30853-4-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387370504-30853-1-git-send-email-m@bjorling.me>
References: <1387370504-30853-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the user know when the number of submission queues are being
ignored.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/block/null_blk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index f0aeb2a..8f2e7c3 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -590,9 +590,12 @@ static int __init null_init(void)
 	}
 #endif
 
-	if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
+	if (queue_mode == NULL_Q_MQ && use_per_node_hctx) {
+		if (submit_queues > 0)
+			pr_warn("null_blk: submit_queues param is set to %u.",
+							nr_online_nodes);
 		submit_queues = nr_online_nodes;
-	else if (submit_queues > nr_cpu_ids)
+	} else if (submit_queues > nr_cpu_ids)
 		submit_queues = nr_cpu_ids;
 	else if (!submit_queues)
 		submit_queues = 1;
-- 
1.8.3.2

