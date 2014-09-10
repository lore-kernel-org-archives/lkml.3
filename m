Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaIJENo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:13:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62304 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaIJENn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:13:43 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v1 0/8] block: per-distpatch_queue flush machinery
Date: Wed, 10 Sep 2014 12:13:23 +0800
Message-Id: <1410322411-17389-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As recent discussion, especially suggested by Christoph, this patchset
implements per-distpatch_queue flush machinery, so that:

	- current init_request and exit_request callbacks can
	cover flush request too, then the buggy copying way of
	initializing flush request's pdu can be fixed

	- flushing performance gets improved in case of multi hw-queue

About 70% throughput improvement is observed in sync write/randwrite
over multi dispatch-queue virtio-blk, see details in commit log
of patch 8/8.

This patchset can be pulled from below tree too:

        git://kernel.ubuntu.com/ming/linux.git v3.17-block-dev_v1

V1:
	- commit log typo fix
	- introduce blk_alloc_flush_queue() and its pair earlier, so
	that patch 5 and 8 become easier for review


 block/blk-core.c       |   11 +--
 block/blk-flush.c      |  217 ++++++++++++++++++++++++++++++++++++++----------
 block/blk-mq.c         |   27 +++---
 block/blk-mq.h         |    1 -
 block/blk-sysfs.c      |    4 +-
 block/blk.h            |   35 +++++++-
 include/linux/blk-mq.h |    2 +
 include/linux/blkdev.h |   10 +--
 8 files changed, 229 insertions(+), 78 deletions(-)

Thanks,
--
Ming Lei

