Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaIGIjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 04:39:35 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55973 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaIGIjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 04:39:33 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Date: Sun,  7 Sep 2014 16:39:16 +0800
Message-Id: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset introduces init_flush_rq and its pair callback to
initialize pdu of flush request explicitly, instead of using
copying from request which is inefficient and buggy, and implements
them in virtio-blk and scsi-lib.

 block/blk-flush.c          |   22 +++++++++++++++++++++-
 block/blk-mq.c             |   23 ++++++++---------------
 block/blk-mq.h             |    3 ++-
 drivers/block/virtio_blk.c |   15 ++++++++++++++-
 drivers/scsi/scsi_lib.c    |   32 +++++++++++++++++++++++++++-----
 include/linux/blk-mq.h     |    9 +++++++++
 6 files changed, 81 insertions(+), 23 deletions(-)

Thanks,
--
Ming Lei

