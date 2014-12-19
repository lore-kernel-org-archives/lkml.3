Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaLSQ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:57:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59186 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLSQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:57:53 -0500
Date: Fri, 19 Dec 2014 16:57:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git pile 3
Message-ID: <20141219165751.GY22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes and patches from the last cycle.  There will be at least
one more pile this cycle, maybe two.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (7):
      btrfs: filp_open() returns ERR_PTR() on failure, not NULL...
      lustre: get rid of playing with ->fs
      move_extent_per_page(): get rid of unused w_flags
      new helper: iter_is_iovec()
      vm_area_operations: kill ->migrate()
      unfuck binfmt_misc.c (broken by commit e6084d4)
      [regression] chunk lost from bd9b51

Dmitry V. Levin (2):
      vfs: cleanup show_mountinfo
      vfs: make mounts and mountstats honor root dir like mountinfo does

Miklos Szeredi (1):
      init: fix read-write root mount

Diffstat:
 .../lustre/lustre/include/linux/lustre_compat25.h  | 24 ----------------------
 drivers/staging/lustre/lustre/llite/dir.c          |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    | 17 +--------------
 fs/binfmt_misc.c                                   |  7 +++----
 fs/btrfs/volumes.c                                 |  2 +-
 fs/ext4/move_extent.c                              |  4 ----
 fs/kernfs/file.c                                   | 22 --------------------
 fs/proc_namespace.c                                | 16 +++++++++++----
 include/linux/migrate.h                            | 10 ---------
 include/linux/mm.h                                 |  2 --
 include/linux/uio.h                                |  5 +++++
 init/do_mounts.c                                   |  6 ++++--
 mm/filemap.c                                       |  2 +-
 mm/mempolicy.c                                     |  5 -----
 mm/migrate.c                                       | 21 -------------------
 mm/shmem.c                                         |  2 +-
 net/socket.c                                       |  1 -
 17 files changed, 29 insertions(+), 119 deletions(-)
