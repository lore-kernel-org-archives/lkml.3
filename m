Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3IMQ7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:59:39 -0400
Received: from kanga.kvack.org ([205.233.56.17]:56050 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab3IMQ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:59:38 -0400
Date: Fri, 13 Sep 2013 12:59:37 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@osdl.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Subject: [GIT PULL] aio changes for 3.12
Message-ID: <20130913165937.GL2517@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hell Linus, Al and everyone,

First off, sorry for this pull request being late in the merge window.  Al 
had raised a couple of concerns about 2 items in the series below.  I 
addressed the first issue (the race introduced by Gu's use of mm_populate()),
but he has not provided any further details on how he wants to rework the 
anon_inode.c changes (which were sent out months ago but have yet to be 
commented on).  The bulk of the changes have been sitting in the -next tree 
for a few months, with all the issues raised being addressed.  Please 
consider this pull.  Thanks,

		-ben

The following changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-07-14 21:47:51 -0700)

are available in the git repository at:


  git://git.kvack.org/~bcrl/aio-next.git master

for you to fetch changes up to d9b2c8714aef102dea95544a8cd9372b21af463f:

  aio: rcu_read_lock protection for new rcu_dereference calls (2013-09-09 12:29:35 -0400)

----------------------------------------------------------------
Artem Savkov (1):
      aio: rcu_read_lock protection for new rcu_dereference calls

Benjamin LaHaise (9):
      aio: fix build when migration is disabled
      aio: double aio_max_nr in calculations
      aio: convert the ioctx list to table lookup v3
      aio: be defensive to ensure request batching is non-zero instead of BUG_ON()
      aio: fix error handling and rcu usage in "convert the ioctx list to table lookup v3"
      aio: table lookup: verify ctx pointer
      aio: remove unnecessary debugging from aio_free_ring()
      aio: fix rcu sparse warnings introduced by ioctx table lookup patch
      aio: fix race in ring buffer page lookup introduced by page migration support

Gu Zheng (2):
      fs/anon_inode: Introduce a new lib function anon_inode_getfile_private()
      fs/aio: Add support to aio ring pages migration

Kent Overstreet (9):
      aio: reqs_active -> reqs_available
      aio: percpu reqs_available
      aio: percpu ioctx refcount
      aio: io_cancel() no longer returns the io_event
      aio: Don't use ctx->tail unnecessarily
      aio: Kill aio_rw_vect_retry()
      aio: Kill unneeded kiocb members
      aio: Kill ki_users
      aio: Kill ki_dtor

Peng Tao (1):
      staging/lustre: kiocb->ki_left is removed

 drivers/staging/android/logger.c           |   2 +-
 drivers/staging/lustre/lustre/llite/file.c |   4 +-
 drivers/usb/gadget/inode.c                 |   9 +-
 fs/aio.c                                   | 726 ++++++++++++++++++-----------
 fs/anon_inodes.c                           |  66 +++
 fs/block_dev.c                             |   2 +-
 fs/nfs/direct.c                            |   1 -
 fs/ocfs2/file.c                            |   6 +-
 fs/read_write.c                            |   3 -
 fs/udf/file.c                              |   2 +-
 include/linux/aio.h                        |  21 +-
 include/linux/anon_inodes.h                |   3 +
 include/linux/migrate.h                    |   3 +
 include/linux/mm_types.h                   |   5 +-
 kernel/fork.c                              |   2 +-
 mm/migrate.c                               |   2 +-
 mm/page_io.c                               |   1 -
 net/socket.c                               |  15 +-
 18 files changed, 561 insertions(+), 312 deletions(-)
