Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbbA1VBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:01:42 -0500
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:42345
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756700AbbA1VAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 16:00:37 -0500
X-AuditID: ac160a69-f79956d000002b3c-25-54c92a4a6517
Message-ID: <54C92A47.2030709@sandisk.com>
Date: Wed, 28 Jan 2015 19:28:23 +0100
From: Bart Van Assche <bart.vanassche@sandisk.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Ming Lei <ming.lei@canonical.com>, Sasha Levin <sasha.levin@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] blk-mq: Fix a recently introduced scsi-mq regression
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRoxnka6X1skQgwNH+C1W3+1ns1i5+iiT
	xeVdc9gsdj38zm6x+MhtZgdWj1kNvWwel8+Weuy+2cDm8fHpLRaPz5vkAlijuGxSUnMyy1KL
	9O0SuDLuf2lhKuiRrWg6ZtHA+Eiii5GTQ0LAROLU260sELaYxIV769m6GLk4hAROMEr8WngP
	ytnBKHF5+hJmmI6511tYIBJbGCUu/p3HBJLgFdCSWNS8jx3EZhFQlWib+hcsziZgJPHt/Uyw
	FaICYRLfN+9ghqgXlDg58wlYXERAQaLn90qwbcwCsxglZt7ZyQaSEBZwlTh7+ztQEQdQQlNi
	/S59kDCzgLzE9rdzmEHqJQSWsUrc3P8JbJmQgLrEySXzmSYwCs1CsmMWQvssJO0LGJlXMYrl
	ZuYU56anFhga6RUn5qVkFmfrJefnbmIExwBX5g7GFZPMDzEKcDAq8fBmxJwIEWJNLCuuzD3E
	KMHBrCTC289yMkSINyWxsiq1KD++qDQntfgQozQHi5I4r+D0LH8hgfTEktTs1NSC1CKYLBMH
	p1QDY2FnDvfLk8df2crUb/pU+bhmt9+5PTrzY4o+WKTvuigz+a4N3zu3FdbL5HZpd7s8TLXj
	tl7DKvrk4JENl9fP7DqdLhralX4t/cPXoA7eE08vZvu5OuYF7uzNv7WhOfQG2wfmhVx2z7zU
	F8ZWiPAVzag200r6uW3m/1CzdYqZ8qoccyYeP540TYmlOCPRUIu5qDgRAC+qPc59AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsXCtZEjRddL62SIQc9lDovVd/vZLFauPspk
	cXnXHDaLXQ+/s1ssPnKb2YHVY1ZDL5vH5bOlHrtvNrB5fHx6i8Xj8ya5ANYoLpuU1JzMstQi
	fbsEroz7X1qYCnpkK5qOWTQwPpLoYuTkkBAwkZh7vYUFwhaTuHBvPVsXIxeHkMAmRokrEyex
	gyR4BbQkFjXvA7NZBFQl2qb+ZQKx2QSMJL69nwnWLCoQJvF98w5miHpBiZMzn4DFRQQUJHp+
	rwQbyiywgFHixLlTrCAJYQFXibO3v4MVMQuoS/yZd4kZwpaX2P52DvMERt5ZSGbNQlI2C0nZ
	AkbmVYxiuZk5xbnpmQWGRnrFiXkpmcXZesn5uZsYwYHIGbWD8fpE80OMTBycUg2MNRe5j1ae
	0oyLsWZkfuxv+PG06+rvLyM0mMWS5BayGfpb6oaeeXB7ip7H/zw52dh7j2btkaty/vH2o66Q
	OUfJ3GL3B2rb3+Z2XBD53n2C0ebqq7cSGzcXe1x33K7b3WuyVzQ9/eycnC0MGUvLUxN/fTlz
	V5+77QfLiVk7Vtt/8WxmVHiVknpDiaU4I9FQi7moOBEAW+EyNfQBAAA=
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 63.163.107.173)
 smtp.mailfrom=Bart.VanAssche@sandisk.com; oracle.com; dkim=none (message not
 signed) header.d=none;oracle.com; dmarc=permerror action=none
 header.from=sandisk.com;
X-Forefront-Antispam-Report: CIP:63.163.107.173;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51234002)(65816999)(83506001)(575784001)(87936001)(86362001)(54356999)(77156002)(87266999)(77096005)(50986999)(62966003)(33656002)(23676002)(80316001)(36756003)(92566002)(106466001)(46102003)(229853001)(65806001)(50466002)(110136001)(19580395003)(47776003)(19580405001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB119;H:milsmgep12.sandisk.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR02MB119;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB119;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB119;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 18:28:26.5975
 (UTC)
X-MS-Exchange-CrossTenant-Id: fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d;Ip=[63.163.107.173]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB119
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB232;
X-OriginatorOrg: sandisk.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a use-after-free that was introduced via patch
"blk-mq: fix hctx/ctx kobject use-after-free" (commit
76d697d10769; kernel v3.19-rc4) and fixes the following crash:

general protection fault: 0000 [#1] SMP
Workqueue: srp_remove srp_remove_work [ib_srp]
task: ffff88083530c880 ti: ffff880835774000 task.ti: ffff880835774000
 [<ffffffff8125a43c>] blk_mq_tag_wakeup_all+0x1c/0x90
RDI: 6b6b6b6b6b6b6b6b
Call Trace:
 [<ffffffff8125792e>] blk_mq_wake_waiters+0x4e/0x80
 [<ffffffff81247e86>] blk_set_queue_dying+0x26/0x90
 [<ffffffff8124abe5>] blk_cleanup_queue+0x35/0x250
 [<ffffffffa001ce4a>] __scsi_remove_device+0x5a/0xe0 [scsi_mod]
 [<ffffffffa001b48f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
 [<ffffffffa000d646>] scsi_remove_host+0x86/0x140 [scsi_mod]
 [<ffffffffa0884c0b>] srp_remove_work+0x9b/0x210 [ib_srp]
 [<ffffffff8106ff48>] process_one_work+0x1d8/0x780
 [<ffffffff8107060b>] worker_thread+0x11b/0x460
 [<ffffffff81075c8f>] kthread+0xef/0x110
 [<ffffffff814dbdac>] ret_from_fork+0x7c/0xb0

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-sysfs.c | 15 +++++----------
 block/blk-mq.c       | 12 +++++++-----
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 6774a0e..921f7cf 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -19,6 +19,8 @@ static void blk_mq_sysfs_release(struct kobject *kobj)
 
 	q = container_of(kobj, struct request_queue, mq_kobj);
 	free_percpu(q->queue_ctx);
+	kfree(q->queue_hw_ctx);
+	q->queue_hw_ctx = NULL;
 }
 
 static void blk_mq_ctx_release(struct kobject *kobj)
@@ -34,6 +36,7 @@ static void blk_mq_hctx_release(struct kobject *kobj)
 	struct blk_mq_hw_ctx *hctx;
 
 	hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
+	kfree(hctx->ctxs);
 	kfree(hctx);
 }
 
@@ -388,21 +391,13 @@ void blk_mq_unregister_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx;
-	int i, j;
+	int i;
 
-	queue_for_each_hw_ctx(q, hctx, i) {
+	queue_for_each_hw_ctx(q, hctx, i)
 		blk_mq_unregister_hctx(hctx);
 
-		hctx_for_each_ctx(hctx, ctx, j)
-			kobject_put(&ctx->kobj);
-
-		kobject_put(&hctx->kobj);
-	}
-
 	kobject_uevent(&q->mq_kobj, KOBJ_REMOVE);
 	kobject_del(&q->mq_kobj);
-	kobject_put(&q->mq_kobj);
 
 	kobject_put(&disk_to_dev(disk)->kobj);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9ee3b87..6d007a4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1604,7 +1604,8 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 		struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 {
-	unsigned flush_start_tag = set->queue_depth;
+	struct blk_mq_ctx *ctx;
+	unsigned j, flush_start_tag = set->queue_depth;
 
 	blk_mq_tag_idle(hctx);
 
@@ -1618,8 +1619,10 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 
 	blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 	blk_free_flush_queue(hctx->fq);
-	kfree(hctx->ctxs);
 	blk_mq_free_bitmap(&hctx->ctx_map);
+	hctx_for_each_ctx(hctx, ctx, j)
+		kobject_put(&ctx->kobj);
+	kobject_put(&hctx->kobj);
 }
 
 static void blk_mq_exit_hw_queues(struct request_queue *q,
@@ -2000,10 +2003,9 @@ void blk_mq_free_queue(struct request_queue *q)
 
 	percpu_ref_exit(&q->mq_usage_counter);
 
-	kfree(q->queue_hw_ctx);
-	kfree(q->mq_map);
+	kobject_put(&q->mq_kobj);
 
-	q->queue_hw_ctx = NULL;
+	kfree(q->mq_map);
 	q->mq_map = NULL;
 
 	mutex_lock(&all_q_mutex);
-- 
2.1.2

