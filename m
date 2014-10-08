Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaJHT00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:26:26 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61760 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaJHT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:26:24 -0400
Date: Wed, 8 Oct 2014 15:26:20 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>, bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking changes for v3.18
Message-ID: <20141008152620.7125508f@synchrony.poochiereds.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 66f09ca717e7905e0eebe000b86e27d0274b95ac:

  nfs: do not start the callback thread until we set rqstp->rq_task (2014-09-02 17:53:30 -0400)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git linux-next

for you to fetch changes up to 1b2b32dcdb3df28dd103033c73cac2417fa05845:

  locks: fix fcntl_setlease/getlease return when !CONFIG_FILE_LOCKING (2014-10-07 14:06:13 -0400)

----------------------------------------------------------------

This release is a little more busy for file locking changes than the last.

- a set of patches from Kinglong Mee to fix the lockowner handling in knfsd
- a pile of cleanups to the internal file lease API. This should get us a bit
  closer to allowing for setlease methods that can block.

There are some dependencies between mine and Bruce's trees this
cycle, and I based my tree on top of the requisite patches in Bruce's
tree. Hopefully I haven't screwed this up. Let me know if there are
any problems pulling it in and I'll do my best to get it resolved.

----------------------------------------------------------------
Jeff Layton (20):
      locks: pass correct "before" pointer to locks_unlink_lock in generic_add_lease
      lockd: rip out deferred lock handling from testlock codepath
      locks: remove lock_may_read and lock_may_write
      locks: consolidate "nolease" routines
      security: make security_file_set_fowner, f_setown and __f_setown void return
      locks: close potential race in lease_get_mtime
      nfsd: fix potential lease memory leak in nfs4_setlease
      locks: generic_delete_lease doesn't need a file_lock at all
      locks: clean up vfs_setlease kerneldoc comments
      nfsd: don't keep a pointer to the lease in nfs4_file
      locks: plumb a "priv" pointer into the setlease routines
      locks: define a lm_setup handler for leases
      locks: move i_lock acquisition into generic_*_lease handlers
      locks: move freeing of leases outside of i_lock
      locks: remove i_have_this_lease check from __break_lease
      locks: __break_lease cleanup in preparation of allowing direct removal of leases
      locks: give lm_break a return value
      locks: set fl_owner for leases to filp instead of current->files
      locks: flock_make_lock should return a struct file_lock (or PTR_ERR)
      locks: fix fcntl_setlease/getlease return when !CONFIG_FILE_LOCKING

Joe Perches (1):
      locks: Remove unused conf argument from lm_grant

Kinglong Mee (5):
      locks: Rename __locks_copy_lock() to locks_copy_conflock()
      locks: New ops in lock_manager_operations for get/put owner
      locks: Copy fl_lmops information for conflock in locks_copy_conflock()
      NFSD: New helper nfs4_get_stateowner() for atomic_inc sop reference
      NFSD: Get reference of lockowner when coping file_lock

 Documentation/filesystems/Locking |  11 +--
 Documentation/filesystems/vfs.txt |   7 +-
 drivers/net/tun.c                 |   4 +-
 drivers/tty/tty_io.c              |   3 +-
 fs/cifs/cifsfs.c                  |   7 +-
 fs/dlm/plock.c                    |   8 +--
 fs/fcntl.c                        |  21 ++----
 fs/gfs2/file.c                    |  22 +-----
 fs/libfs.c                        |  18 +++++
 fs/lockd/svclock.c                |  68 +++---------------
 fs/locks.c                        | 444 ++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------
 fs/nfs/file.c                     |  13 +---
 fs/nfs/internal.h                 |   1 -
 fs/nfs/nfs4file.c                 |   2 +-
 fs/nfsd/nfs4state.c               | 104 ++++++++++++++++------------
 fs/nfsd/state.h                   |   1 -
 fs/notify/dnotify/dnotify.c       |   8 +--
 include/linux/fs.h                |  59 ++++++----------
 include/linux/lockd/lockd.h       |   1 -
 include/linux/security.h          |   8 +--
 include/trace/events/filelock.h   |  14 ++--
 net/socket.c                      |   3 +-
 security/capability.c             |   4 +-
 security/security.c               |   4 +-
 security/selinux/hooks.c          |   4 +-
 security/smack/smack_lsm.c        |   3 +-
 26 files changed, 354 insertions(+), 488 deletions(-)

-- 
Jeff Layton <jlayton@poochiereds.net>
