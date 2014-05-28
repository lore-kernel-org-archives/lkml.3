Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaE1XAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:00:20 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:36630 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaE1XAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:00:18 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH V3] basic conversion to blk-mq
Date: Thu, 29 May 2014 00:59:57 +0200
Message-Id: <1401317998-8980-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew and Keith,

Here is an updated patch with most of the feedback fixed.

The patch is against Jens' 3.16/core tree. You may use the nvmemq_wip_review
branch at:

https://github.com/MatiasBjorling/linux-collab nvmemq_wip_review

from v2:
 * rebased on top of current 3.16/core.
 * use blk-mq queue management for spreading io queues
 * removed rcu handling and allocated all io queues up front for mgmt by blk-mq
 * removed the need for hotplugging notification
 * fixed flush data handling
 * fixed double free of spinlock
 * various cleanup

Missing work on abortion and timeouts.

Matias Bjørling (1):
  NVMe: basic conversion to blk-mq

 drivers/block/nvme-core.c | 1143 +++++++++++++++++++--------------------------
 include/linux/nvme.h      |   11 +-
 2 files changed, 486 insertions(+), 668 deletions(-)

-- 
1.9.1

