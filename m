Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaFBUzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:55:32 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:64936 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaFBUz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:55:28 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@infradead.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH v5] conversion to blk-mq
Date: Mon,  2 Jun 2014 22:55:09 +0200
Message-Id: <1401742510-10827-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew and Keith,

Here is an updated patch with the feedback from the previous days. It's against
Jens' for-3.16/core tree. You may use the nvmemq_wip_review branch at:

https://github.com/MatiasBjorling/linux-collab nvmemq_wip_review

and see the changes from v4 to v5 here:

https://github.com/MatiasBjorling/linux-collab/commit/e650bc5

Changes since v4:
  * Fix timeout retries
  * Fix naming in nvme_init_hctx
  * Fix racy behavior of admin queue in nvme_dev_remove
  * Fix wrong return values in nvme_queue_request
  * Put cqe_seen back
  * Introduce abort_completion for killing timed out I/Os
  * Move locks outside of nvme_submit_iod
  * Various renaming and style fixes

Changes since v3:
  * Added abortion logic
  * Fixed possible race on abortion
  * Removed req data with flush. Handled by by blk-mq
  * Added safety check for submitting user rq to admin queue.
  * Use dev->online_queues for nr_hw_queues
  * Fix loop with initialization in nvme_create_io_queues
  * Style fixups

Changes since v2:
  * rebased on top of current 3.16/core.
  * use blk-mq queue management for spreading io queues
  * removed rcu handling and allocated all io queues up front for mgmt by blk-mq
  * removed the need for hotplugging notification
  * fixed flush data handling
  * fixed double free of spinlock
  * various cleanup

Matias Bjørling (1):
  NVMe: conversion to blk-mq

 drivers/block/nvme-core.c | 1149 ++++++++++++++++++---------------------------
 drivers/block/nvme-scsi.c |    8 +-
 include/linux/nvme.h      |   14 +-
 3 files changed, 478 insertions(+), 693 deletions(-)

-- 
1.9.1

