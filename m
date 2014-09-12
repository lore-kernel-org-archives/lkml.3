Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaILOrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:47:42 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53450 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaILOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:47:41 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 0/9] block: per-distpatch_queue flush machinery
Date: Fri, 12 Sep 2014 22:47:24 +0800
Message-Id: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
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
of patch 9/9.

This patchset can be pulled from below tree too:

        git://kernel.ubuntu.com/ming/linux.git v3.17-block-dev_v2

V2:
	- refactor blk_mq_init_hw_queues() and its pair, also it is a fix
	on failure path, so that conversion to per-queue flush becomes simple.
	- allocate/initialize flush queue in blk_mq_init_hw_queues()
	- add sync write tests on virtio-blk which is backed by SSD image

V1:
        - commit log typo fix
        - introduce blk_alloc_flush_queue() and its pair earlier, so
        that patch 5 and 8 become easier for review

