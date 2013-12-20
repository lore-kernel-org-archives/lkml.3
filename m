Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3LTXMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:12:08 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:50962 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3LTXLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:11:12 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 1/3] null_blk: corrections to documentation
Date: Sat, 21 Dec 2013 00:10:59 +0100
Message-Id: <1387581061-25987-2-git-send-email-m@bjorling.me>
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

Randy Dunlap reported a couple of grammar errors and unfortunate usages of
socket/node/core.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 Documentation/block/null_blk.txt | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/block/null_blk.txt b/Documentation/block/null_blk.txt
index 9e1b047..5603dad 100644
--- a/Documentation/block/null_blk.txt
+++ b/Documentation/block/null_blk.txt
@@ -18,7 +18,7 @@ The following instances are possible:
     - Bio-based. IO requests are submitted directly to the device driver.
     - Directly accepts bio data structure and returns them.
 
-All of them has a completion queue for each core in the system.
+All of them have a completion queue for each core in the system.
 
 II. Module parameters applicable for all instances:
 
@@ -30,7 +30,7 @@ queue_mode=[0-2]: Default: 2-Multi-queue
   2: Multi-queue.
 
 home_node=[0--nr_nodes]: Default: NUMA_NO_NODE
-  Selects what socket the data structures is allocated from.
+  Selects what CPU node the data structures are allocated from.
 
 gb=[Size in GB]: Default: 250GB
   The size of the device reported to the system.
@@ -38,34 +38,34 @@ gb=[Size in GB]: Default: 250GB
 bs=[Block size (in bytes)]: Default: 512 bytes
   The block size reported to the system.
 
-nr_devices=[Num. devices]: Default: 2
+nr_devices=[Number of devices]: Default: 2
   Number of block devices instantiated. They are instantiated as /dev/nullb0,
   etc.
 
-irq_mode=[0-2]: Default: Soft-irq
+irq_mode=[0-2]: Default: 1-Soft-irq
   The completion mode used for completing IOs to the block-layer.
 
   0: None.
-  1: Soft-irq. Uses ipi to complete IOs across sockets. Simulates the overhead
-     when IOs are issued from another socket than the home the device is
+  1: Soft-irq. Uses IPI to complete IOs across CPU nodes. Simulates the overhead
+     when IOs are issued from another CPU node than the home the device is
      connected to.
   2: Timer: Waits a specific period (completion_nsec) for each IO before
      completion.
 
-completion_nsec=[Num. ns]: Default: 10.000ns
+completion_nsec=[ns]: Default: 10.000ns
   Combined with irq_mode=2 (timer). The time each completion event must wait.
 
 submit_queues=[0..nr_cpus]:
   The number of submission queues attached to the device driver. If unset, it
   defaults to 1 on single-queue and bio-based instances. For multi-queue,
-  its ignored when use_per_node_hctx module parameter is 1.
+  it is ignored when use_per_node_hctx module parameter is 1.
 
-hw_queue_depth=[0..qdepth]: Defaults: 64
+hw_queue_depth=[0..qdepth]: Default: 64
   The hardware queue depth of the device.
 
 III: Multi-queue specific parameters
 
-use_per_node_hctx=[0/1]: Defaults: 1
+use_per_node_hctx=[0/1]: Default: 1
   If 1, the multi-queue block layer is instantiated with a hardware dispatch
   queue for each CPU node in the system. If 0, it is instantiated with the
   number of queues defined in the submit_queues parameter.
-- 
1.8.3.2

