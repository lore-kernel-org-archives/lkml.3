Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab3KKQar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:30:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41642 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3KKQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:30:36 -0500
Date: Mon, 11 Nov 2013 16:30:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20131111163034.GY13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All kinds of stuff this time around; some more notable parts:
	* RCU'd vfsmounts handling
	* new primitives for coredump handling
	* files_lock is gone
	* Bruce's delegations handling series
	* exportfs fixes
plus misc stuff all over the place.  There's one trivial conflict with
mainline - drivers/usb/core/file.c (whitespace noise on mainline side
vs. switch to replace_fops() on vfs.git one); no other conflicts.  Please,
pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (72):
      9p: make v9fs_cache_inode_{get,put,set}_cookie empty inlines for !9P_CACHEFS
      ecryptfs: check DCACHE_OP_REVALIDATE instead of ->d_op
      ecryptfs: don't leave RCU pathwalk immediately
      ecryptfs: get rid of ecryptfs_set_dentry_lower{,_mnt}
      ecryptfs: ->lower_path.dentry is never NULL
      libfs: get exports to definitions of objects being exported...
      new helper: kfree_put_link()
      befs: split symlink iops in two - for short and long symlinks resp.
      nfs: use %p[dD] instead of open-coded (and often racy) equivalents
      nfsd: switch to %p[dD]
      sunrpc: switch to %pd
      ubifs: switch to %pd
      ncpfs: switch to %p[dD]
      put_mnt_ns(): use drop_collected_mounts()
      consolidate the reassignments of ->f_op in ->open() instances
      dmxdev: get rid of pointless clearing ->f_op
      rtl8188eu: remove dead code
      file->f_op is never NULL...
      initialize namespace_sem statically
      fs_is_visible only needs namespace_sem held shared
      dup_mnt_ns(): get rid of pointless grabbing of vfsmount_lock
      do_remount(): pull touch_mnt_namespace() up
      fold mntfree() into mntput_no_expire()
      fs/namespace.c: bury long-dead define
      finish_automount() doesn't need vfsmount_lock for removal from expiry list
      mnt_set_expiry() doesn't need vfsmount_lock
      fold dup_mnt_ns() into its only surviving caller
      namespace.c: get rid of mnt_ghosts
      don't bother with vfsmount_lock in mounts_poll()
      new helpers: lock_mount_hash/unlock_mount_hash
      isofs: don't pass dentry to isofs_hash{i,}_common()
      uninline destroy_super(), consolidate alloc_super()
      split __lookup_mnt() in two functions
      move taking vfsmount_lock down into prepend_path()
      make freeing super_block rcu-delayed
      hpfs: make freeing sbi and codetables rcu-delayed
      adfs: delayed freeing of sbi
      autofs4: make freeing sbi rcu-delayed
      cifs: rcu-delay unload_nls() and freeing sbi
      fat: rcu-delay unloading nls and freeing sbi
      ncpfs: rcu-delay unload_nls() and freeing ncp_server
      pid_namespace: make freeing struct pid_namespace rcu-delayed
      fuse: rcu-delay freeing fuse_conn
      switch shrink_dcache_for_umount() to use of d_walk()
      RCU'd vfsmounts
      get rid of {lock,unlock}_rcu_walk()
      get rid of s_files and files_lock
      fold __d_shrink() into its only remaining caller
      coda_revalidate_inode(): switch to passing inode...
      no need to keep brlock macros anymore...
      restore 32bit aout coredump
      new helper: dump_emit()
      switch elf_core_write_extra_phdrs() to dump_emit()
      switch elf_core_write_extra_data() to dump_emit()
      binfmt_elf: convert writing actual dump pages to dump_emit()
      convert the rest of binfmt_elf_fdpic to dump_emit()
      switch elf_coredump_extra_notes_write() to dump_emit()
      aout: switch to dump_emit
      binfmt_elf: count notes towards coredump limit
      make dump_emit() use vfs_write() instead of banging at ->f_op->write directly
      dump_skip(): dump_seek() replacement taking coredump_params
      spufs: get rid of dump_emit() wrappers
      new helper: dump_align()
      take anon inode allocation to libfs.c
      ... and kill anon_inode_getfile_private()
      constify copy_siginfo_to_user{,32}()
      constify do_coredump() argument
      elf{,_fdpic} coredump: get rid of pointless if (siginfo->si_signo)
      iget/iget5: don't bother with ->i_lock until we find a match
      qnx4: i_sb is never NULL
      ocfs2: get rid of impossible checks
      ecryptfs: ->f_op is never NULL

Benjamin LaHaise (1):
      rework aio migrate pages to use aio fs

Christoph Hellwig (1):
      exportfs: BUG_ON in crazy corner case

David Howells (1):
      VFS: Put a small type field into struct dentry::d_flags

J. Bruce Fields (25):
      vfs: split out vfs_getattr_nosec
      exportfs: fix 32-bit nfsd handling of 64-bit inode numbers
      dcache: use IS_ROOT to decide where dentry is hashed
      dcache: Don't set DISCONNECTED on "pseudo filesystem" dentries
      dcache: don't clear DCACHE_DISCONNECTED too early
      dcache: fix outdated DCACHE_NEED_LOOKUP comment
      exportfs: more detailed comment for path_reconnect
      exportfs: clear DISCONNECTED on all parents sooner
      exportfs: stop retrying once we race with rename/remove
      exportfs: eliminate unused "noprogress" counter
      exportfs: move most of reconnect_path to helper function
      exportfs: better variable name
      exportfs: fix quadratic behavior in filehandle lookup
      vfs: pull ext4's double-i_mutex-locking into common code
      vfs: don't use PARENT/CHILD lock classes for non-directories
      vfs: rename I_MUTEX_QUOTA now that it's not used for quotas
      vfs: take i_mutex on renamed file
      locks: introduce new FL_DELEG lock flag
      locks: implement delegations
      namei: minor vfs_unlink cleanup
      locks: break delegations on unlink
      locks: helper functions for delegation breaking
      locks: break delegations on rename
      locks: break delegations on link
      locks: break delegations on any attribute modification

Miklos Szeredi (1):
      vfs: introduce d_instantiate_no_diralias()

Diffstat:
 Documentation/filesystems/directory-locking        |   31 ++-
 Documentation/filesystems/porting                  |    8 +
 arch/arm64/kernel/signal32.c                       |    2 +-
 arch/ia64/kernel/elfcore.c                         |   12 +-
 arch/ia64/kernel/signal.c                          |    2 +-
 arch/mips/kernel/signal32.c                        |    2 +-
 arch/parisc/kernel/signal32.c                      |    2 +-
 arch/parisc/kernel/signal32.h                      |    2 +-
 arch/powerpc/include/asm/spu.h                     |    3 +-
 arch/powerpc/kernel/signal_32.c                    |    2 +-
 arch/powerpc/platforms/cell/spu_syscalls.c         |    5 +-
 arch/powerpc/platforms/cell/spufs/coredump.c       |   89 ++----
 arch/powerpc/platforms/cell/spufs/spufs.h          |    3 +-
 arch/s390/kernel/compat_signal.c                   |    2 +-
 arch/sparc/kernel/signal32.c                       |    2 +-
 arch/tile/kernel/compat_signal.c                   |    2 +-
 arch/x86/ia32/ia32_aout.c                          |   86 +++---
 arch/x86/ia32/ia32_signal.c                        |    2 +-
 arch/x86/um/elfcore.c                              |   15 +-
 drivers/base/devtmpfs.c                            |    6 +-
 drivers/char/misc.c                                |   12 +-
 drivers/gpu/drm/drm_fops.c                         |   17 +-
 drivers/media/dvb-core/dmxdev.c                    |    4 -
 drivers/media/dvb-core/dvbdev.c                    |   19 +-
 drivers/mtd/nand/nandsim.c                         |    2 +-
 drivers/staging/comedi/comedi_compat32.c           |    3 -
 .../lustre/lustre/include/linux/lustre_compat25.h  |    4 +-
 drivers/staging/lustre/lustre/llite/namei.c        |    2 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h  |    5 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c   |  208 -----------
 drivers/usb/core/file.c                            |   16 +-
 fs/9p/cache.h                                      |   12 +
 fs/9p/vfs_file.c                                   |    2 -
 fs/9p/vfs_inode.c                                  |    6 -
 fs/9p/vfs_inode_dotl.c                             |    4 -
 fs/adfs/adfs.h                                     |    9 +-
 fs/adfs/super.c                                    |    3 +-
 fs/aio.c                                           |   63 +++-
 fs/anon_inodes.c                                   |  114 +------
 fs/attr.c                                          |   25 ++-
 fs/autofs4/autofs_i.h                              |    3 +-
 fs/autofs4/dev-ioctl.c                             |    6 -
 fs/autofs4/inode.c                                 |   13 +-
 fs/befs/linuxvfs.c                                 |   61 ++--
 fs/binfmt_aout.c                                   |   13 +-
 fs/binfmt_elf.c                                    |  127 +++----
 fs/binfmt_elf_fdpic.c                              |  152 +++------
 fs/binfmt_em86.c                                   |    2 +-
 fs/cachefiles/interface.c                          |    4 +-
 fs/cachefiles/namei.c                              |    4 +-
 fs/char_dev.c                                      |    6 +-
 fs/cifs/cifs_fs_sb.h                               |    1 +
 fs/cifs/cifsfs.c                                   |    2 +-
 fs/cifs/cifsfs.h                                   |    2 -
 fs/cifs/connect.c                                  |   10 +-
 fs/cifs/link.c                                     |    7 -
 fs/coda/coda_linux.h                               |    2 +-
 fs/coda/dir.c                                      |    6 +-
 fs/coda/file.c                                     |    6 +-
 fs/coda/inode.c                                    |    2 +-
 fs/compat_ioctl.c                                  |    4 +-
 fs/coredump.c                                      |   71 +++--
 fs/dcache.c                                        |  342 ++++++++++--------
 fs/ecryptfs/dentry.c                               |   29 +-
 fs/ecryptfs/ecryptfs_kernel.h                      |   19 +-
 fs/ecryptfs/file.c                                 |    8 +-
 fs/ecryptfs/inode.c                                |   29 +-
 fs/ecryptfs/main.c                                 |    3 +-
 fs/eventpoll.c                                     |    2 +-
 fs/exec.c                                          |   35 +-
 fs/exportfs/expfs.c                                |  269 ++++++++------
 fs/ext4/ext4.h                                     |    2 -
 fs/ext4/ioctl.c                                    |    4 +-
 fs/ext4/move_extent.c                              |   40 +--
 fs/fat/fat.h                                       |    1 +
 fs/fat/inode.c                                     |   19 +-
 fs/fcntl.c                                         |    5 +-
 fs/file_table.c                                    |  129 +-------
 fs/fs-writeback.c                                  |    1 +
 fs/fuse/cuse.c                                     |    2 +-
 fs/fuse/dir.c                                      |   40 +--
 fs/fuse/fuse_i.h                                   |    5 +-
 fs/fuse/inode.c                                    |    4 +-
 fs/gfs2/inode.c                                    |    9 +-
 fs/hpfs/hpfs_fn.h                                  |    1 +
 fs/hpfs/namei.c                                    |    2 +-
 fs/hpfs/super.c                                    |   28 +-
 fs/inode.c                                         |   62 +++-
 fs/internal.h                                      |    7 -
 fs/ioctl.c                                         |    4 +-
 fs/isofs/inode.c                                   |   12 +-
 fs/libfs.c                                         |  122 +++++--
 fs/locks.c                                         |   69 +++-
 fs/mount.h                                         |   20 +-
 fs/namei.c                                         |  322 ++++++++++-------
 fs/namespace.c                                     |  390 ++++++++++----------
 fs/ncpfs/dir.c                                     |   55 +--
 fs/ncpfs/file.c                                    |   12 +-
 fs/ncpfs/inode.c                                   |   19 +-
 fs/ncpfs/ncp_fs_sb.h                               |    2 +-
 fs/nfs/dir.c                                       |  119 +++----
 fs/nfs/direct.c                                    |   17 +-
 fs/nfs/file.c                                      |  117 +++----
 fs/nfs/namespace.c                                 |    5 +-
 fs/nfs/nfs3proc.c                                  |    8 +-
 fs/nfs/nfs4file.c                                  |    4 +-
 fs/nfs/nfs4namespace.c                             |    7 +-
 fs/nfs/nfs4proc.c                                  |    5 +-
 fs/nfs/proc.c                                      |    8 +-
 fs/nfs/unlink.c                                    |    9 +-
 fs/nfs/write.c                                     |    6 +-
 fs/nfsd/nfs4recover.c                              |   12 +-
 fs/nfsd/nfs4state.c                                |   17 +-
 fs/nfsd/nfsfh.c                                    |   28 +-
 fs/nfsd/nfsfh.h                                    |    4 +-
 fs/nfsd/vfs.c                                      |   23 +-
 fs/ntfs/inode.c                                    |    2 +-
 fs/ocfs2/inode.c                                   |   10 -
 fs/open.c                                          |   32 ++-
 fs/pnode.c                                         |   13 +-
 fs/proc/self.c                                     |   10 +-
 fs/proc_namespace.c                                |    8 +-
 fs/qnx4/namei.c                                    |    4 -
 fs/read_write.c                                    |   25 +-
 fs/readdir.c                                       |    2 +-
 fs/select.c                                        |    4 +-
 fs/splice.c                                        |    6 +-
 fs/stat.c                                          |   31 ++-
 fs/super.c                                         |  201 ++++------
 fs/sync.c                                          |    2 +-
 fs/ubifs/dir.c                                     |   41 +--
 fs/ubifs/journal.c                                 |    6 +-
 fs/ubifs/xattr.c                                   |   16 +-
 fs/utimes.c                                        |    9 +-
 include/asm-generic/siginfo.h                      |    2 +-
 include/linux/anon_inodes.h                        |    3 -
 include/linux/binfmts.h                            |    3 +-
 include/linux/compat.h                             |    2 +-
 include/linux/coredump.h                           |   10 +-
 include/linux/dcache.h                             |  104 +++++-
 include/linux/elf.h                                |    6 +-
 include/linux/elfcore.h                            |    7 +-
 include/linux/fs.h                                 |  106 ++++--
 include/linux/lglock.h                             |   10 -
 include/linux/mount.h                              |    2 +
 include/linux/namei.h                              |    2 +-
 include/linux/pid_namespace.h                      |    1 +
 ipc/mqueue.c                                       |    2 +-
 kernel/elfcore.c                                   |   10 +-
 kernel/pid_namespace.c                             |    8 +-
 kernel/signal.c                                    |    2 +-
 mm/memory.c                                        |    2 +-
 mm/mmap.c                                          |    4 +-
 mm/nommu.c                                         |    2 +-
 net/9p/trans_fd.c                                  |    4 +-
 net/sunrpc/rpc_pipe.c                              |   12 +-
 sound/core/sound.c                                 |   22 +-
 sound/sound_core.c                                 |   17 +-
 159 files changed, 2100 insertions(+), 2492 deletions(-)
