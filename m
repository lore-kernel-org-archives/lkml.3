Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbbAMPpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:45:32 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43518 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbAMPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:45:31 -0500
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH v2 0/4] block & aio: improve loop with kernel aio
Date: Tue, 13 Jan 2015 23:44:44 +0800
Message-Id: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

The 1st two patches introduce kernel AIO support, most of
is borrowed from previous Dave's work, and thanks to ITER_BVEC,
it is much simper to implement kernel AIO now.

The last two patches applies kernel aio to loop-mq.

Follows benefits from using kernel aio in loop:
	- avoid double cache, and memory usage decreased a lot
	- system load gets much decreased

In the commit log of patch 4, detailed performance data
and system resource monitor information is provided about
using kernel aio for loop block.

V2:
	- remove 'extra' parameter to aio_kernel_alloc()
	- try to avoid memory allcation inside queue req callback
	- introduce 'use_mq' sysfs file for enabling kernel aio or disabling it
V1:
	- link:
		http://marc.info/?t=140803157700004&r=1&w=2
	- improve failure path in aio_kernel_submit()

 drivers/block/loop.c |  173 ++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/block/loop.h |   11 ++++
 fs/aio.c             |  121 +++++++++++++++++++++++++++++++++++
 fs/direct-io.c       |    9 ++-
 include/linux/aio.h  |   17 ++++-
 5 files changed, 323 insertions(+), 8 deletions(-)


Thanks,
Ming Lei

