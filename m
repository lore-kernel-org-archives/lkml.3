Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3EDUXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 16:23:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46820 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3EDUXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 16:23:41 -0400
Date: Sat, 4 May 2013 21:23:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git pile 2
Message-ID: <20130504202340.GI25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes, etc.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (6):
      do_mount(): fix a leak introduced in 3.9 ("mount: consolidate permission checks")
      do_coredump(): don't wait for thaw if coredump has already been interrupted
      more mode_t whack-a-mole...
      kill fs/read_write.h
      create_mnt_ns: unidiomatic use of list_add()
      xtensa simdisk: fix braino in "xtensa simdisk: switch to proc_create_data()"

Geert Uytterhoeven (2):
      nubus: Kill nubus_proc_detach_device()
      sun3_scsi: add ->show_info()

Han Shen (1):
      Removed unused typedef to avoid "unused local typedef" warnings.

James Hogan (3):
      hostfs: remove "will unlock" comment
      hostfs: move HOSTFS_SUPER_MAGIC to <linux/magic.h>
      hostfs: use kmalloc instead of kzalloc

Jan Kara (1):
      fs: Fix hang with BSD accounting on frozen filesystem

Syam Sidhardhan (1):
      proc_devtree: Replace include linux/module.h with linux/export.h

Wei Yongjun (1):
      vfs: use list_move instead of list_del/list_add

Yan, Zheng (1):
      fs: remove dentry_lru_prune()

Diffstat:
 arch/xtensa/platforms/iss/simdisk.c |    2 +-
 drivers/hwmon/abx500.c              |    2 +-
 drivers/nubus/proc.c                |   15 ---
 drivers/scsi/sun3_NCR5380.c         |  185 +++++++++++++++--------------------
 drivers/scsi/sun3_scsi.c            |    1 +
 drivers/scsi/sun3_scsi.h            |    2 +-
 fs/compat.c                         |    2 -
 fs/compat_ioctl.c                   |    1 -
 fs/coredump.c                       |    9 +-
 fs/dcache.c                         |   34 ++-----
 fs/hostfs/hostfs_kern.c             |    8 +-
 fs/namespace.c                      |    7 +-
 fs/proc/proc_devtree.c              |    2 +-
 fs/read_write.c                     |    5 +-
 fs/read_write.h                     |    9 --
 include/linux/fs.h                  |    7 ++
 include/linux/nubus.h               |    1 -
 include/uapi/linux/magic.h          |    1 +
 kernel/acct.c                       |    7 +-
 19 files changed, 124 insertions(+), 176 deletions(-)
 delete mode 100644 fs/read_write.h
