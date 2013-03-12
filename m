Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3CLPmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:42:24 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:65418 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab3CLPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:42:21 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
Date: Tue, 12 Mar 2013 16:41:35 +0100
Message-Id: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al and Linus,

Please consider overlayfs for inclusion into 3.10.

It's included in Ubuntu and openSUSE, used by OpenWrt and various other
projects.  I regularly get emails asking when it will be included in mainline.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v16

Thanks,
Miklos

---
Andy Whitcroft (3):
      overlayfs-add-statfs-support
      ovl-switch-to-inode_permission
      overlayfs-copy-up-i_uid-i_gid-from-the-underlying-inode

Erez Zadok (1):
      overlayfs-implement-show_options

Miklos Szeredi (6):
      vfs-add-i_op-dentry_open
      vfs-export-do_splice_direct-to-modules
      vfs-introduce-clone_private_mount
      overlay filesystem
      fs-limit-filesystem-stacking-depth
      vfs-export-inode_permission-to-modules

Neil Brown (1):
      overlay-overlay-filesystem-documentation

Robin Dong (2):
      overlayfs-fix-possible-leak-in-ovl_new_inode
      overlayfs-create-new-inode-in-ovl_link

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
 fs/overlayfs/Kconfig                    |    4 +
 fs/overlayfs/Makefile                   |    7 +
 fs/overlayfs/copy_up.c                  |  385 +++++++++++++++++
 fs/overlayfs/dir.c                      |  604 +++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  372 +++++++++++++++++
 fs/overlayfs/overlayfs.h                |   70 ++++
 fs/overlayfs/readdir.c                  |  566 +++++++++++++++++++++++++
 fs/overlayfs/super.c                    |  685 +++++++++++++++++++++++++++++++
 fs/splice.c                             |    1 +
 include/linux/fs.h                      |   14 +
 include/linux/mount.h                   |    3 +
 22 files changed, 2981 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c

