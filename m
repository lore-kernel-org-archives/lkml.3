Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3CCQEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 11:04:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59054 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3CCQEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 11:04:32 -0500
Date: Sun, 3 Mar 2013 16:04:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs bits
Message-ID: <20130303160430.GL4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Unfortunately, it looks like xattr series will have to wait until
the next cycle ;-/  This pile contains 9p cleanups and fixes (races in
v9fs_fid_add(), etc.), fixup for nommu breakage in shmem.c, several cleanups
and a bit more file_inode() work.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (13):
      selinux: opened file can't have NULL or negative ->f_path.dentry
      more file_inode() open-coded instances
      9p: don't bother with private lock in ->d_fsdata; dentry->d_lock will do just fine
      9p: turn fid->dlist into hlist
      v9fs: get rid of v9fs_dentry
      9p: v9fs_fid_add() can't fail now
      9p: double iput() in ->lookup() if d_materialise_unique() fails
      9p: untangle ->lookup() a bit
      9p: make sure ->lookup() adds fid to the right dentry
      9p: if v9fs_fid_lookup() gets to asking server, it'd better have hashed dentry
      cache the value of file_inode() in struct file
      fix nommu breakage in shmem.c
      constify path_get/path_put and fs_struct.c stuff

Diffstat:
 arch/s390/hypfs/inode.c              |    6 +--
 arch/x86/kernel/msr.c                |    9 ++---
 drivers/staging/comedi/comedi_fops.c |   14 ++++----
 drivers/tty/tty_io.c                 |   16 ++++------
 fs/9p/fid.c                          |   55 ++++++++++++++++------------------
 fs/9p/fid.h                          |   22 +-------------
 fs/9p/vfs_dentry.c                   |   17 ++--------
 fs/9p/vfs_inode.c                    |   40 ++++++++----------------
 fs/9p/vfs_inode_dotl.c               |   19 ++++-------
 fs/ext4/indirect.c                   |    2 +-
 fs/f2fs/file.c                       |    6 ++--
 fs/file_table.c                      |    2 +
 fs/fs_struct.c                       |    6 ++--
 fs/fuse/dev.c                        |    2 +-
 fs/fuse/file.c                       |   24 +++++++-------
 fs/internal.h                        |    2 +-
 fs/namei.c                           |    4 +-
 fs/open.c                            |    3 +-
 fs/seq_file.c                        |    2 +-
 include/linux/fs.h                   |    3 +-
 include/linux/fs_struct.h            |    4 +-
 include/linux/path.h                 |    4 +-
 include/net/9p/client.h              |    2 +-
 kernel/futex.c                       |    2 +-
 mm/shmem.c                           |    5 +--
 security/selinux/hooks.c             |    9 -----
 26 files changed, 109 insertions(+), 171 deletions(-)
