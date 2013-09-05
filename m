Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3IEPqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:46:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60517 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3IEPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:46:26 -0400
Date: Thu, 5 Sep 2013 16:46:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1 (of many small ones this time ;-/)
Message-ID: <20130905154624.GS13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, this merge window it'll have a be a lot of small piles - my
fault, actually, for not keeping #for-next in anything that would resemble
a sane shape ;-/  This pile: assorted fixes (the first 3 are -stable fodder,
IMO) and cleanups + %pd/%pD formats (dentry/file pathname, up to 4 last
components) + several long-standing patches from various folks.  There
definitely will be a lot more (starting with Miklos' check_submount_and_drop()
series).  There's one trivial conflict in fs/dcache.c (lockref changes
affecting a context line), other than that this one should merge clean...

Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (22):
      shm_mnt is as longterm as it gets, TYVM...
      nfsd: racy access to ->d_name in nsfd4_encode_path()
      only regular files with FMODE_WRITE need to be on s_files
      constify touch_atime()
      coh901318: don't open-code simple_read_from_buffer()
      don't bother passing sb to oprofile_create_files()
      oprofile: don't bother with passing superblock to ->create_files()
      don't bother with passing superblock to oprofile_create_stats_files()
      oprofilefs_mkdir() doesn't need superblock argument
      oprofilefs_create_...() do not need superblock argument
      oprofile: get rid of pointless forward declarations of struct super_block
      don't pass superblock to hypfs_vm_create_files()
      don't pass superblock to hypfs_diag_create_files
      don't pass superblock to hypfs_{mkdir,create*}
      ibmasmfs: don't bother passing superblock when not needed
      git simplify nilfs check for busy subtree
      switch copy_module_from_fd() to fdget
      switch epoll_ctl() to fdget
      switch fchmod() to fdget
      powerpc kvm: use fdget
      kvm eventfd: switch to fdget
      add formats for dentry/file pathnames

Christoph Hellwig (2):
      direct-io: Implement generic deferred AIO completions
      direct-io: Handle O_(D)SYNC AIO

Jeff Layton (1):
      vfs: allow umount to handle mountpoints without revalidating them

Yan, Zheng (1):
      vfs: call d_op->d_prune() before unhashing dentry

Diffstat:
 Documentation/printk-formats.txt     |    9 ++
 arch/alpha/oprofile/common.c         |   22 ++--
 arch/avr32/oprofile/op_model_avr32.c |   17 ++--
 arch/mips/oprofile/common.c          |   20 ++--
 arch/powerpc/kvm/powerpc.c           |   20 ++--
 arch/powerpc/oprofile/common.c       |   28 +++---
 arch/s390/hypfs/hypfs.h              |   13 +--
 arch/s390/hypfs/hypfs_diag.c         |   50 +++++-----
 arch/s390/hypfs/hypfs_vm.c           |   65 ++++++------
 arch/s390/hypfs/inode.c              |   36 +++----
 arch/s390/oprofile/init.c            |   35 +++----
 arch/x86/oprofile/nmi_int.c          |   18 ++--
 arch/x86/oprofile/op_model_amd.c     |   24 +++---
 drivers/dma/coh901318.c              |   26 +----
 drivers/misc/ibmasm/ibmasmfs.c       |   26 +++---
 drivers/oprofile/oprof.h             |    3 +-
 drivers/oprofile/oprofile_files.c    |   26 +++---
 drivers/oprofile/oprofile_perf.c     |   16 ++--
 drivers/oprofile/oprofile_stats.c    |   24 +++---
 drivers/oprofile/oprofile_stats.h    |    3 +-
 drivers/oprofile/oprofilefs.c        |   44 ++++-----
 fs/block_dev.c                       |    2 +-
 fs/btrfs/file.c                      |    2 +-
 fs/cifs/file.c                       |    2 +-
 fs/dcache.c                          |   13 ++-
 fs/direct-io.c                       |  126 +++++++++++++++++++-----
 fs/eventpoll.c                       |   31 +++---
 fs/ext4/ext4.h                       |   11 --
 fs/ext4/file.c                       |    2 +-
 fs/ext4/inode.c                      |   28 ++----
 fs/ext4/page-io.c                    |   30 ++-----
 fs/ext4/super.c                      |   16 ---
 fs/file_table.c                      |    6 +-
 fs/inode.c                           |    2 +-
 fs/namei.c                           |  182 ++++++++++++++++++++++++++++++++++
 fs/namespace.c                       |    2 +-
 fs/nfsd/nfs4xdr.c                    |   14 ++-
 fs/nilfs2/super.c                    |   26 ++----
 fs/ocfs2/aops.c                      |    8 +--
 fs/open.c                            |   11 +-
 fs/super.c                           |   18 ++--
 fs/xfs/xfs_aops.c                    |   28 +-----
 fs/xfs/xfs_aops.h                    |    3 -
 include/linux/buffer_head.h          |    2 +
 include/linux/fs.h                   |    9 +-
 include/linux/namei.h                |    1 +
 include/linux/oprofile.h             |   16 ++--
 kernel/module.c                      |   13 +--
 lib/vsprintf.c                       |   82 +++++++++++++++
 mm/filemap.c                         |    2 +-
 mm/shmem.c                           |    7 +-
 virt/kvm/eventfd.c                   |   20 ++--
 52 files changed, 738 insertions(+), 502 deletions(-)
