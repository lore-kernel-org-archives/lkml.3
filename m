Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3GHKHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:07:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54917 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3GHKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:07:54 -0400
Date: Mon, 8 Jul 2013 11:07:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git, part 3
Message-ID: <20130708100752.GW4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Misc stuff all over the place.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
There will be one more pile in a couple of days.

Shortlog:
Al Viro (3):
      helper for reading ->d_count
      lustre: kill the pointless wrapper
      mode_t whack-a-mole...

Jaegeuk Kim (1):
      f2fs: fix readdir incorrectness

Jeff Layton (2):
      seq_file: add seq_list_*_percpu helpers
      locks: move file_lock_list to a set of percpu hlist_heads and convert file_lock_lock to an lglock

Wei Yongjun (1):
      ncpfs: fix error return code in ncp_parse_options()

Diffstat:
 .../lustre/include/linux/lustre_patchless_compat.h |    2 -
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    2 +-
 .../staging/lustre/lustre/include/lprocfs_status.h |    6 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |    8 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |    4 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    2 +-
 drivers/staging/lustre/lustre/llite/namei.c        |    4 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    4 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    8 +-
 fs/autofs4/expire.c                                |    8 +-
 fs/autofs4/root.c                                  |    2 +-
 fs/ceph/inode.c                                    |    4 +-
 fs/ceph/mds_client.c                               |    2 +-
 fs/coda/dir.c                                      |    2 +-
 fs/ecryptfs/inode.c                                |    2 +-
 fs/f2fs/dir.c                                      |   20 +++---
 fs/locks.c                                         |   71 ++++++++++++++------
 fs/ncpfs/inode.c                                   |   12 +++-
 fs/nfs/dir.c                                       |    6 +-
 fs/nfs/unlink.c                                    |    2 +-
 fs/nilfs2/super.c                                  |    2 +-
 fs/seq_file.c                                      |   54 +++++++++++++++
 include/linux/dcache.h                             |    5 ++
 include/linux/fs.h                                 |    1 +
 include/linux/seq_file.h                           |    6 ++
 25 files changed, 168 insertions(+), 71 deletions(-)
