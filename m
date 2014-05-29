Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbaE2Vvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:51:55 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:51503 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbaE2Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:51:52 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH v4] basic conversion to blk-mq
Date: Thu, 29 May 2014 23:51:24 +0200
Message-Id: <1401400285-25003-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew and Keith,

Thanks for the quick review.

The patch has been updated with the feedback from Keith and Jens. It's against
Jens' 3.16/core tree. You may use the nvmemq_wip_review branch at:

https://github.com/MatiasBjorling/linux-collab nvmemq_wip_review

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

Keith, what kind of retry scheme do you like for timeout retries?

Matias Bjørling (1):
  NVMe: basic conversion to blk-mq

 drivers/block/nvme-core.c | 1100 ++++++++++++++++++---------------------------
 include/linux/nvme.h      |   11 +-
 2 files changed, 442 insertions(+), 669 deletions(-)

-- 
1.9.1

