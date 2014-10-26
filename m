Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaJZDEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 23:04:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41805 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaJZDEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 23:04:45 -0400
Date: Sun, 26 Oct 2014 03:04:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20141026030442.GM7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	overlayfs merge + leak fix for d_splice_alias() failure exits.

Please, pull from the usual place:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (5):
      fix inode leaks on d_splice_alias() failure exits
      overlayfs: don't hold ->i_mutex over opening the real directory
      overlayfs: make ovl_cache_entry->name an array instead of pointer
      overlayfs: embed root into overlay_readdir_data
      overlayfs: embed middle into overlay_readdir_data

Andy Whitcroft (1):
      overlayfs: add statfs support

Erez Zadok (1):
      overlayfs: implement show_options

Miklos Szeredi (11):
      vfs: add i_op->dentry_open()
      vfs: export do_splice_direct() to modules
      vfs: export __inode_permission() to modules
      vfs: introduce clone_private_mount()
      vfs: export check_sticky()
      vfs: add whiteout support
      vfs: add RENAME_WHITEOUT
      ext4: support RENAME_WHITEOUT
      shmem: support RENAME_WHITEOUT
      overlay filesystem
      fs: limit filesystem stacking depth

Neil Brown (1):
      overlay: overlay filesystem documentation

Diffstat:
 Documentation/filesystems/Locking       |    2 +
 Documentation/filesystems/overlayfs.txt |  198 +++++++
 Documentation/filesystems/vfs.txt       |    7 +
 MAINTAINERS                             |    7 +
 fs/Kconfig                              |    1 +
 fs/Makefile                             |    1 +
 fs/btrfs/ioctl.c                        |   20 +-
 fs/dcache.c                             |    2 +
 fs/ecryptfs/main.c                      |    7 +
 fs/ext4/namei.c                         |   95 +++-
 fs/internal.h                           |    7 -
 fs/namei.c                              |   41 +-
 fs/namespace.c                          |   27 +
 fs/open.c                               |   23 +-
 fs/overlayfs/Kconfig                    |   10 +
 fs/overlayfs/Makefile                   |    7 +
 fs/overlayfs/copy_up.c                  |  414 ++++++++++++++
 fs/overlayfs/dir.c                      |  921 +++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  425 ++++++++++++++
 fs/overlayfs/overlayfs.h                |  191 +++++++
 fs/overlayfs/readdir.c                  |  590 ++++++++++++++++++++
 fs/overlayfs/super.c                    |  796 ++++++++++++++++++++++++++
 fs/splice.c                             |    1 +
 include/linux/fs.h                      |   39 ++
 include/linux/mount.h                   |    3 +
 include/uapi/linux/fs.h                 |    1 +
 mm/shmem.c                              |   36 +-
 27 files changed, 3814 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c
