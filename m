Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3A2Pm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:42:57 -0500
Received: from relay3.sgi.com ([192.48.152.1]:36610 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751870Ab3A2Pmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:42:54 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.8-rc6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130129154250.1B3CC4266DC@whiskey.americas.sgi.com>
Date: Tue, 29 Jan 2013 09:42:50 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these fixes for XFS.  Here are fixes for returning
   EFSCORRUPTED on probe of a non-xfs filesystem, the stack switch in
   xfs_bmapi_allocate, a crash in _xfs_buf_find, speculative
   preallocation as the filesystem nears ENOSPC, an unmount hang, a race
   with AIO, and a regression with xfs_fsr.

Thanks,
	Ben 

The following changes since commit 37f13561de6039b3a916d1510086030d097dea0f:

  xfs: recalculate leaf entry pointer after compacting a dir2 block (2013-01-16 16:08:55 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.8-rc6

for you to fetch changes up to 65e3aa77f1b0269720660a6879f6f28d158f54c8:

  xfs: Fix xfs_swap_extents() after removal of xfs_flushinval_pages() (2013-01-28 16:05:10 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.8-rc6

- fix return value when filesystem probe finds no XFS magic, a
  regression introduced in 9802182.

- fix stack switch in __xfs_bmapi_allocate by moving the check for stack
  switch up into xfs_bmapi_write.

- fix oops in _xfs_buf_find by validating that the requested block is
  within the filesystem bounds.

- limit speculative preallocation near ENOSPC.

- fix an unmount hang in xfs_wait_buftarg by freeing the
  xfs_buf_log_item in xfs_buf_item_unlock.

- fix a possible use after free with AIO.

- fix xfs_swap_extents after removal of xfs_flushinval_pages, a
  regression introduced in fb59581404a.

----------------------------------------------------------------
Brian Foster (1):
      xfs: pull up stack_switch check into xfs_bmapi_write

Dave Chinner (3):
      xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
      xfs: limit speculative prealloc near ENOSPC thresholds
      xfs: fix shutdown hang on invalid inode during create

Eric Sandeen (1):
      xfs: Do not return EFSCORRUPTED when filesystem probe finds no XFS magic

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO

Torsten Kaiser (1):
      xfs: Fix xfs_swap_extents() after removal of xfs_flushinval_pages()

 fs/xfs/xfs_aops.c     |  2 +-
 fs/xfs/xfs_bmap.c     |  6 +++---
 fs/xfs/xfs_buf.c      | 20 ++++++++++++++++++++
 fs/xfs/xfs_buf_item.c | 12 ++++++++++--
 fs/xfs/xfs_dfrag.c    |  4 ++--
 fs/xfs/xfs_iomap.c    |  9 +++++++++
 fs/xfs/xfs_mount.c    |  2 +-
 fs/xfs/xfs_trace.h    |  1 +
 8 files changed, 47 insertions(+), 9 deletions(-)
