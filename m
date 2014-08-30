Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaH3QI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:08:57 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39673 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaH3QIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:08:55 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>
Subject: block: loop: convert to blk-mq
Date: Sun, 31 Aug 2014 00:08:21 +0800
Message-Id: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following 6 patches convert current loop driver into blk-mq:

	- loop's scalability gets improved much
	- loop driver gets quite simplified, and the conversion can
	be throught as cleanup

The previous kernel AIO patches will be submitted in another patchset
for improving loop's performance.

V2:
	- replace work queue with kthread worker because wq may cause
	regression on some fast devices(such as loop over null_blk, tmpfs
	file, ...), in these cases, loop thread becomes CPU bound actually,
	so work queue will introduce lots of unnecessary context switch, and
	decrease throughput a lot one this cases
	- introduce prepare_flush_rq_fn callback and its pair in blk-mq ops
	for setting up flush rq's pdu correctly
	- move kernel aio patches into another patchset as suggested by
	Christoph
	- no change in the other 4 patches

V1:
	- improve failure path in aio_kernel_submit()

 block/blk-flush.c      |    4 +
 block/blk-mq.c         |   16 +-
 block/blk-mq.h         |    1 -
 drivers/block/loop.c   |  411 +++++++++++++++++++++++++-----------------------
 drivers/block/loop.h   |   20 ++-
 include/linux/blk-mq.h |   14 ++
 6 files changed, 259 insertions(+), 207 deletions(-)



Thanks,
--
Ming Lei

