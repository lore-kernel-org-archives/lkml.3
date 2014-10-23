Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaJWXZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:25:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48161 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJWXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:25:48 -0400
Date: Fri, 24 Oct 2014 01:25:39 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlay filesystem v25
Message-ID: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v25

Plenty of bugs fixed relative to the previous version, thanks to Al Viro's
review and is now officially be BugFree(TM).  Also passes the
unionmount-testsuite by David Howells.

Thanks,
Miklos

---
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

---
 Documentation/filesystems/Locking       |   2 +
 Documentation/filesystems/overlayfs.txt | 198 +++++++
 Documentation/filesystems/vfs.txt       |   7 +
 MAINTAINERS                             |   7 +
 fs/Kconfig                              |   1 +
 fs/Makefile                             |   1 +
 fs/btrfs/ioctl.c                        |  20 +-
 fs/ecryptfs/main.c                      |   7 +
 fs/ext4/namei.c                         |  95 +++-
 fs/internal.h                           |   7 -
 fs/namei.c                              |  41 +-
 fs/namespace.c                          |  27 +
 fs/open.c                               |  23 +-
 fs/overlayfs/Kconfig                    |  10 +
 fs/overlayfs/Makefile                   |   7 +
 fs/overlayfs/copy_up.c                  | 414 ++++++++++++++
 fs/overlayfs/dir.c                      | 921 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    | 425 +++++++++++++++
 fs/overlayfs/overlayfs.h                | 191 +++++++
 fs/overlayfs/readdir.c                  | 587 ++++++++++++++++++++
 fs/overlayfs/super.c                    | 796 +++++++++++++++++++++++++++
 fs/splice.c                             |   1 +
 include/linux/fs.h                      |  39 ++
 include/linux/mount.h                   |   3 +
 include/uapi/linux/fs.h                 |   1 +
 mm/shmem.c                              |  36 +-
 26 files changed, 3809 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c

