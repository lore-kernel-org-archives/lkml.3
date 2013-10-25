Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3JYQHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:07:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:40216 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3JYQHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:07:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,571,1378882800"; 
   d="scan'208";a="417211339"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>
Subject: [f2fs-dev 0/5] f2fs: Enable f2fs support inline data
Date: Sat, 26 Oct 2013 00:01:54 +0800
Message-Id: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

f2fs inode is so large, so small files can be stored directly in the inode,
rather than just storing a single block address and storing the data elsewhere.

This patch set makes files less than ~3.4K store directly in inode block.
a) space saving
   Test with kernel src(without repo data), it can save about 10% space
   with this patch set;
b) performance
   Test this patch set with iozone, there is no obvious performance difference
   with the results of disabling this feature.

Huajun Li (5):
  f2fs: Add flags and helpers to support inline data
  f2fs: Add a new mount option: inline_data
  f2fs: Add a new function: f2fs_reserve_block()
  f2fs: Key functions to handle inline data
  f2fs: Handle inline data read and write

 fs/f2fs/Makefile        |    2 +-
 fs/f2fs/data.c          |   77 ++++++++++++++++++++-----
 fs/f2fs/f2fs.h          |   22 ++++++++
 fs/f2fs/file.c          |   42 +++++++++++++-
 fs/f2fs/inline.c        |  144 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/super.c         |    8 ++-
 include/linux/f2fs_fs.h |    8 +++
 7 files changed, 283 insertions(+), 20 deletions(-)
 create mode 100644 fs/f2fs/inline.c

-- 
1.7.9.5

