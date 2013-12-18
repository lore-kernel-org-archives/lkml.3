Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3LRMl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:41:59 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:58705 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab3LRMl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:41:56 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 1/3] null_blk: documentation
Date: Wed, 18 Dec 2013 13:41:42 +0100
Message-Id: <1387370504-30853-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387370504-30853-1-git-send-email-m@bjorling.me>
References: <1387370504-30853-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description of module and its parameters.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 Documentation/block/null_blk.txt | 71 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/block/null_blk.txt

diff --git a/Documentation/block/null_blk.txt b/Documentation/block/null_blk.txt
new file mode 100644
index 0000000..9e1b047
--- /dev/null
+++ b/Documentation/block/null_blk.txt
@@ -0,0 +1,71 @@
+Null block device driver
+================================================================================
+
+I. Overview
+
+The null block device (/dev/nullb*) is used for benchmarking the various
+block-layer implementations. It emulates a block device of X gigabytes in size.
+The following instances are possible:
+
+  Single-queue block-layer
+    - Request-based.
+    - Single submission queue per device.
+    - Implements IO scheduling algorithms (CFQ, Deadline, noop).
+  Multi-queue block-layer
+    - Request-based.
+    - Configurable submission queues per device.
+  No block-layer (Known as bio-based)
+    - Bio-based. IO requests are submitted directly to the device driver.
+    - Directly accepts bio data structure and returns them.
+
+All of them has a completion queue for each core in the system.
+
+II. Module parameters applicable for all instances:
+
+queue_mode=[0-2]: Default: 2-Multi-queue
+  Selects which block-layer the module should instantiate with.
+
+  0: Bio-based.
+  1: Single-queue.
+  2: Multi-queue.
+
+home_node=[0--nr_nodes]: Default: NUMA_NO_NODE
+  Selects what socket the data structures is allocated from.
+
+gb=[Size in GB]: Default: 250GB
+  The size of the device reported to the system.
+
+bs=[Block size (in bytes)]: Default: 512 bytes
+  The block size reported to the system.
+
+nr_devices=[Num. devices]: Default: 2
+  Number of block devices instantiated. They are instantiated as /dev/nullb0,
+  etc.
+
+irq_mode=[0-2]: Default: Soft-irq
+  The completion mode used for completing IOs to the block-layer.
+
+  0: None.
+  1: Soft-irq. Uses ipi to complete IOs across sockets. Simulates the overhead
+     when IOs are issued from another socket than the home the device is
+     connected to.
+  2: Timer: Waits a specific period (completion_nsec) for each IO before
+     completion.
+
+completion_nsec=[Num. ns]: Default: 10.000ns
+  Combined with irq_mode=2 (timer). The time each completion event must wait.
+
+submit_queues=[0..nr_cpus]:
+  The number of submission queues attached to the device driver. If unset, it
+  defaults to 1 on single-queue and bio-based instances. For multi-queue,
+  its ignored when use_per_node_hctx module parameter is 1.
+
+hw_queue_depth=[0..qdepth]: Defaults: 64
+  The hardware queue depth of the device.
+
+III: Multi-queue specific parameters
+
+use_per_node_hctx=[0/1]: Defaults: 1
+  If 1, the multi-queue block layer is instantiated with a hardware dispatch
+  queue for each CPU node in the system. If 0, it is instantiated with the
+  number of queues defined in the submit_queues parameter.
-- 
1.8.3.2

