Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3LZNbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 08:31:49 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63363 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3LZNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 08:31:48 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v1 0/5] block: blk-mq: support blk_cleanup_queue on mq
Date: Thu, 26 Dec 2013 21:31:33 +0800
Message-Id: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 1st one moves request initializtion out of completion handler.

The following 2 patches support drain/sync mq queue in blk_cleanup_queue.

The 4th patch calls blk_cleanup_queue() in removing device path
to fix queue leak problem.

The 5th patch doesn't export blk_mq_free_queue() because the function
is called in release handler of queue kobject, and drivers needn't
to call it.

V1:
    - add patch 1/5
    - add comments on blk_execute_rq_nowait 2/5
    - set QUEUE_FLAG_DEAD for MQ 2/5
    - use __blk_mq_drain_queue() helper 2/5

 block/blk-core.c         |   21 ++++++++++++--
 block/blk-exec.c         |    4 +++
 block/blk-mq.c           |   71 +++++++++++++++++++++++-----------------------
 block/blk-mq.h           |    2 ++
 block/blk-sysfs.c        |    1 +
 drivers/block/null_blk.c |   10 ++-----
 include/linux/blk-mq.h   |    1 -
 7 files changed, 63 insertions(+), 47 deletions(-)


Thanks,
--
Ming Lei


