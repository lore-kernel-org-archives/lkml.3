Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3CaCz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 22:55:27 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41181 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3CaCz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 22:55:26 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: rob@landley.net, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] Documentation: cfq-iosched: update documentation help for cfq tunnables
Date: Sun, 31 Mar 2013 11:55:04 +0900
Message-Id: <1364698505-22236-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add the documentation text for latency, target_latency & group_idle
tunnable parameters in the block/cfq-iosched.txt.
Also fix few typo(spelling) mistakes.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 Documentation/block/cfq-iosched.txt |   47 ++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
index a5eb7d1..4d02bca 100644
--- a/Documentation/block/cfq-iosched.txt
+++ b/Documentation/block/cfq-iosched.txt
@@ -5,7 +5,7 @@ The main aim of CFQ scheduler is to provide a fair allocation of the disk
 I/O bandwidth for all the processes which requests an I/O operation.
 
 CFQ maintains the per process queue for the processes which request I/O
-operation(syncronous requests). In case of asynchronous requests, all the
+operation(synchronous requests). In case of asynchronous requests, all the
 requests from all the processes are batched together according to their
 process's I/O priority.
 
@@ -66,6 +66,47 @@ This parameter is used to set the timeout of synchronous requests. Default
 value of this is 124ms. In case to favor synchronous requests over asynchronous
 one, this value should be decreased relative to fifo_expire_async.
 
+group_idle
+-----------
+This parameter forces idling at the CFQ group level instead of CFQ
+queue level. This is introduced after after a bottleneck was observed
+in higher end storage due to idle on sequential queuee and allow dispatch
+from a single queue. The idea with this parameter is that it be be run with
+slice_idle=0 and group_idle=8, so that idling does not happen on individual
+queues in the group but happens overall on the group and still keep the IO
+controller working.
+Not idling on individual queues in the group will dispatch requests from
+multiple queues in the group at the same time and achieve higher throughput
+on higher end storage.
+
+Default value for this parameter is 8ms.
+
+latency
+-------
+This parameter is used to enable/disable the latency mode of the CFQ
+scheduler. So if latency mode (called low_latency) is enabled, then CFQ tries
+to recompute the slice time for each process based on the target_latency set
+for the system. This favors the fairness over throughput. Disabling low
+latency (setting it to 0) ignores target latency, allowing each process in the
+system to get a full time slice.
+
+By default low latency mode is enabled.
+
+target_latency
+--------------
+This parameter is used to calculate the time slice for a process if cfq's
+latency mode is enabled. It will ensure that sync requests have an estimated
+latency. But sometime if sequential workload is more (e.g. sequential read),
+then to meet the latency constraints, throughput may decrease because of less
+time for each process to issue I/O request before the cfq queue is switched.
+
+Though this can be overcome by disabling the latency_mode, but it may increase
+the read latency for some applications. So, this parameter allows for changing
+target_latency through sysfs interface which can provide the balanced
+throughput and read latency.
+
+Default value for target_latency is 300ms.
+
 slice_async
 -----------
 This parameter is same as of slice_sync but for asynchronous queue. The
@@ -98,8 +139,8 @@ in the device exceeds this parameter. This parameter is used for synchronous
 request.
 
 In case of storage with several disk, this setting can limit the parallel
-processing of request. Therefore, increasing the value can imporve the
-performace although this can cause the latency of some I/O to increase due
+processing of request. Therefore, increasing the value can improve the
+performance although this can cause the latency of some I/O to increase due
 to more number of requests.
 
 CFQ Group scheduling
-- 
1.7.9.5

