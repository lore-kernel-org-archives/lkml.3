Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3LTXLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:11:17 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:41807 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3LTXLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:11:14 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 2/3] null_blk: set use_per_node_hctx param to false
Date: Sat, 21 Dec 2013 00:11:00 +0100
Message-Id: <1387581061-25987-3-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387581061-25987-1-git-send-email-m@bjorling.me>
References: <1387581061-25987-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matias Bjørling <m@bjorling.me>

The defaults for the module is to instantiate itself with blk-mq and a
submit queue for each CPU node in the system.

To save resources, initialize instead with a single submit queue.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 Documentation/block/null_blk.txt | 9 +++++----
 drivers/block/null_blk.c         | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/block/null_blk.txt b/Documentation/block/null_blk.txt
index 5603dad..b2830b4 100644
--- a/Documentation/block/null_blk.txt
+++ b/Documentation/block/null_blk.txt
@@ -65,7 +65,8 @@ hw_queue_depth=[0..qdepth]: Default: 64
 
 III: Multi-queue specific parameters
 
-use_per_node_hctx=[0/1]: Default: 1
-  If 1, the multi-queue block layer is instantiated with a hardware dispatch
-  queue for each CPU node in the system. If 0, it is instantiated with the
-  number of queues defined in the submit_queues parameter.
+use_per_node_hctx=[0/1]: Default: 0
+  0: The number of submit queues are set to the value of the submit_queues
+     parameter.
+  1: The multi-queue block layer is instantiated with a hardware dispatch
+     queue for each CPU node in the system.
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 8f2e7c3..9b0311b 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -101,9 +101,9 @@ static int hw_queue_depth = 64;
 module_param(hw_queue_depth, int, S_IRUGO);
 MODULE_PARM_DESC(hw_queue_depth, "Queue depth for each hardware queue. Default: 64");
 
-static bool use_per_node_hctx = true;
+static bool use_per_node_hctx = false;
 module_param(use_per_node_hctx, bool, S_IRUGO);
-MODULE_PARM_DESC(use_per_node_hctx, "Use per-node allocation for hardware context queues. Default: true");
+MODULE_PARM_DESC(use_per_node_hctx, "Use per-node allocation for hardware context queues. Default: false");
 
 static void put_tag(struct nullb_queue *nq, unsigned int tag)
 {
-- 
1.8.3.2

