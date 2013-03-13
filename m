Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3CMOQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:16:54 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37932 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3CMOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:16:52 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Date: Wed, 13 Mar 2013 15:16:24 +0100
Message-Id: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another version with the comments addressed plus a small bugfix and some
checkpatch cleanups.

Changes in v17:

 - fix wrong return value in a failure path in ovl_link()
 - fix subjects
 - use file_inode() and MODULE_ALIAS_FS()
 - fold bugfix patches
 - checkpatch cleanups

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current

Thanks,
Miklos

---
Andy Whitcroft (1):
      overlayfs: add statfs support

Erez Zadok (1):
      overlayfs: implement show_options

Miklos Szeredi (6):
      vfs: add i_op->dentry_open()
      vfs: export do_splice_direct() to modules
      vfs: export __inode_permission() to modules
      vfs: introduce clone_private_mount()
      overlay filesystem
      fs: limit filesystem stacking depth

Neil Brown (1):
      overlay: overlay filesystem documentation

---
 Documentation/filesystems/Locking       |    2 +
 Documentation/filesystems/overlayfs.txt |  199 +++++++++
 Documentation/filesystems/vfs.txt       |    7 +
 MAINTAINERS                             |    7 +
 fs/Kconfig                              |    1 +
 fs/Makefile                             |    1 +
 fs/ecryptfs/main.c                      |    7 +
 fs/internal.h                           |    5 -
 fs/namei.c                              |   10 +-
 fs/namespace.c                          |   18 +
 fs/open.c                               |   23 +-
 fs/overlayfs/Kconfig                    |   10 +
 fs/overlayfs/Makefile                   |    7 +
 fs/overlayfs/copy_up.c                  |  385 +++++++++++++++++
 fs/overlayfs/dir.c                      |  605 +++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  372 +++++++++++++++++
 fs/overlayfs/overlayfs.h                |   70 ++++
 fs/overlayfs/readdir.c                  |  566 +++++++++++++++++++++++++
 fs/overlayfs/super.c                    |  686 +++++++++++++++++++++++++++++++
 fs/splice.c                             |    1 +
 include/linux/fs.h                      |   14 +
 include/linux/mount.h                   |    3 +
 22 files changed, 2989 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c

