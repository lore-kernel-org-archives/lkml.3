Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3FIKjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:39:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53510 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3FIKjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:39:09 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v8 2/4] block: Extend cmd_flags in struct request
Date: Sun,  9 Jun 2013 13:38:55 +0300
Message-Id: <1370774339-27968-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment no new request flags can be added to enum rq_flag_bits
due to cmd_flags field size limitation. This commit adds a new filed to be used as
an extensions to cmd_flags.

Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>

diff --git a/block/blk-core.c b/block/blk-core.c
index fe3683c..3a14987 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3226,6 +3226,8 @@ int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
 			sizeof(((struct request *)0)->cmd_flags));
+	BUILD_BUG_ON(__REQ_EXT_NR_BITS > 8 *
+			sizeof(((struct request *)0)->cmd_flags_ext));
 
 	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
 	kblockd_workqueue = alloc_workqueue("kblockd",
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fa1abeb..40a921f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -181,6 +181,11 @@ enum rq_flag_bits {
 	__REQ_NR_BITS,		/* stops here */
 };
 
+/* Request flags. For use in the cmd_flags_ext field of struct request */
+enum ext_rq_flag_bits {
+	__REQ_EXT_NR_BITS,	/* stops here */
+};
+
 #define REQ_WRITE		(1 << __REQ_WRITE)
 #define REQ_FAILFAST_DEV	(1 << __REQ_FAILFAST_DEV)
 #define REQ_FAILFAST_TRANSPORT	(1 << __REQ_FAILFAST_TRANSPORT)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 968720f..aa36278 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -100,6 +100,7 @@ struct request {
 	struct request_queue *q;
 
 	unsigned int cmd_flags;
+	unsigned int cmd_flags_ext;
 	enum rq_cmd_type_bits cmd_type;
 	unsigned long atomic_flags;
 
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundatio
