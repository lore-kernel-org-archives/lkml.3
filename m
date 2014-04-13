Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaDMXAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 19:00:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:48520 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaDMXAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 19:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,853,1389772800"; 
   d="scan'208";a="418489412"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v3 0/7] Page I/O
Date: Sun, 13 Apr 2014 18:59:49 -0400
Message-Id: <cover.1397429628.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Now that 3.15-rc1 is out, could you queue these patches for 3.16 please?
Patches 1-3 & 7 are, IMO, worthwhile cleanups / bug fixes, regardless
of the rest of the patch set.

If this patch series gets in, I'll take care of including the NVMe
driver piece.  It'll be a bit more tricky than the proof of concept that
I've been flashing around because we have to make sure that the device
responds better to page sized I/Os than accumulating larger I/Os.

It's indisputably a win for brd and for other NVM technology devices
that are accessed synchronously rather than through DMA.

Matthew Wilcox (7):
  Remove block_write_full_page_endio()
  Factor clean_buffers() out of __mpage_writepage()
  Factor page_endio() out of mpage_end_io()
  Add bdev_read_page() and bdev_write_page()
  swap: Use bdev_read_page() / bdev_write_page()
  brd: Add support for rw_page
  brd: Return -ENOSPC rather than -ENOMEM on page allocation failure

 drivers/block/brd.c         | 16 +++++++--
 fs/block_dev.c              | 63 ++++++++++++++++++++++++++++++++++
 fs/buffer.c                 | 21 +++---------
 fs/ext4/page-io.c           |  2 +-
 fs/mpage.c                  | 84 +++++++++++++++++++++++----------------------
 fs/ocfs2/file.c             |  2 +-
 include/linux/blkdev.h      |  4 +++
 include/linux/buffer_head.h |  2 --
 include/linux/pagemap.h     |  2 ++
 mm/filemap.c                | 25 ++++++++++++++
 mm/page_io.c                | 23 +++++++++++--
 11 files changed, 178 insertions(+), 66 deletions(-)

-- 
1.9.1

