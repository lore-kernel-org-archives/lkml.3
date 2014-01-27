Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaA0OZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:25:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43962 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaA0OZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:25:22 -0500
Date: Mon, 27 Jan 2014 14:25:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1
Message-ID: <20140127142520.GD10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted stuff; the biggest pile here is Christoph's ACL series.
Plus assorted cleanups and fixes all over the place...  There will be
another pile later this week.

There's a couple of conflicts - rcupdate.h and posix_acl.h; proposed resolution
in vfs.git#conflict-resolution.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (13):
      ecryptfs: fix failure handling in ->readlink()
      xfs: switch to kfree_put_link()
      affs: use ->kill_sb() to simplify ->put_super() and failure exits of ->mount()
      cramfs: get rid of ->put_super()
      cramfs: take headers to fs/cramfs
      efs: get rid of ->put_super()
      qnx4: clean qnx4_fill_super() up
      btrfs: sanitize BTRFS_IOC_FILE_EXTENT_SAME
      eventfd_ctx_fdget(): use fdget() instead of fget()
      nls: have register_nls() set ->owner
      afs: get rid of junk in fs/afs/proc.c
      kill reiserfs_bdevname()
      __dentry_path() fixes

Christoph Hellwig (21):
      reiserfs: prefix ACL symbols with reiserfs_
      fs: merge xattr_acl.c into posix_acl.c
      fs: add get_acl helper
      fs: add a set_acl inode operation
      fs: add generic xattr_acl handlers
      fs: make posix_acl_chmod more useful
      fs: make posix_acl_create more useful
      btrfs: use generic posix ACL infrastructure
      ext2/3/4: use generic posix ACL infrastructure
      f2fs: use generic posix ACL infrastructure
      hfsplus: use generic posix ACL infrastructure
      jffs2: use generic posix ACL infrastructure
      ocfs2: use generic posix ACL infrastructure
      reiserfs: use generic posix ACL infrastructure
      xfs: use generic posix ACL infrastructure
      jfs: use generic posix ACL infrastructure
      gfs2: use generic posix ACL infrastructure
      nfs: use generic posix ACL infrastructure for v3 Posix ACLs
      fs: remove generic_acl
      nfsd: use get_acl and ->set_acl
      hfsplus: remove can_set_xattr

Eric W. Biederman (2):
      vfs: Is mounted should be testing mnt_ns for NULL or error.
      vfs: Remove second variable named error in __dentry_path

Oleg Nesterov (5):
      introduce __fcheck_files() to fix rcu_dereference_check_fdtable(), kill rcu_my_thread_group_empty()
      change close_files() to use rcu_dereference_raw(files->fdt)
      fs: factor out common code in fget() and fget_raw()
      fs: factor out common code in fget_light() and fget_raw_light()
      fs: __fget_light() can use __fget() in slow path

Rakesh Pandit (1):
      befs: iget_locked() doesn't return an ERR_PTR

Steven Whitehouse (1):
      Fix race when checking i_size on direct i/o read

Diffstat:
 arch/blackfin/kernel/setup.c                      |    2 +-
 arch/cris/arch-v32/drivers/axisflashmap.c         |    2 -
 fs/9p/acl.c                                       |    4 +-
 fs/Kconfig                                        |    6 +-
 fs/Makefile                                       |    3 +-
 fs/affs/super.c                                   |   57 ++-
 fs/afs/internal.h                                 |    1 -
 fs/afs/proc.c                                     |  122 ++----
 fs/befs/linuxvfs.c                                |    4 +-
 fs/btrfs/acl.c                                    |  142 +------
 fs/btrfs/ctree.h                                  |    7 +-
 fs/btrfs/inode.c                                  |    7 +-
 fs/btrfs/ioctl.c                                  |   70 ++--
 fs/btrfs/xattr.c                                  |    5 +-
 fs/btrfs/xattr.h                                  |    2 -
 fs/cramfs/inode.c                                 |   50 ++-
 include/linux/cramfs_fs.h => fs/cramfs/internal.h |    6 -
 fs/cramfs/uncompress.c                            |    2 +-
 fs/dcache.c                                       |   10 +-
 fs/ecryptfs/inode.c                               |   29 +-
 fs/efs/super.c                                    |   39 +-
 fs/eventfd.c                                      |   13 +-
 fs/ext2/acl.c                                     |  188 +--------
 fs/ext2/acl.h                                     |    8 +-
 fs/ext2/file.c                                    |    1 +
 fs/ext2/inode.c                                   |    2 +-
 fs/ext2/namei.c                                   |    2 +
 fs/ext2/xattr.c                                   |    8 +-
 fs/ext2/xattr.h                                   |    2 -
 fs/ext3/acl.c                                     |  223 ++---------
 fs/ext3/acl.h                                     |    9 +-
 fs/ext3/file.c                                    |    1 +
 fs/ext3/inode.c                                   |    2 +-
 fs/ext3/namei.c                                   |    2 +
 fs/ext3/xattr.c                                   |    8 +-
 fs/ext3/xattr.h                                   |    2 -
 fs/ext4/acl.c                                     |  223 ++---------
 fs/ext4/acl.h                                     |    9 +-
 fs/ext4/file.c                                    |    1 +
 fs/ext4/inode.c                                   |    2 +-
 fs/ext4/namei.c                                   |    2 +
 fs/ext4/xattr.c                                   |    8 +-
 fs/ext4/xattr.h                                   |    2 -
 fs/f2fs/acl.c                                     |  174 +--------
 fs/f2fs/acl.h                                     |    7 +-
 fs/f2fs/f2fs.h                                    |    4 +
 fs/f2fs/file.c                                    |    3 +-
 fs/f2fs/namei.c                                   |    2 +
 fs/f2fs/xattr.c                                   |    9 +-
 fs/f2fs/xattr.h                                   |    2 -
 fs/file.c                                         |   98 ++---
 fs/fuse/file.c                                    |    3 +
 fs/generic_acl.c                                  |  184 ---------
 fs/gfs2/acl.c                                     |  234 ++---------
 fs/gfs2/acl.h                                     |    4 +-
 fs/gfs2/inode.c                                   |   34 +-
 fs/gfs2/xattr.c                                   |    4 +-
 fs/hfsplus/acl.h                                  |    9 +-
 fs/hfsplus/dir.c                                  |    1 +
 fs/hfsplus/inode.c                                |    3 +-
 fs/hfsplus/posix_acl.c                            |  168 +-------
 fs/hfsplus/xattr.c                                |   92 +----
 fs/hfsplus/xattr.h                                |    2 -
 fs/jffs2/acl.c                                    |  141 +------
 fs/jffs2/acl.h                                    |    7 +-
 fs/jffs2/dir.c                                    |    1 +
 fs/jffs2/file.c                                   |    1 +
 fs/jffs2/fs.c                                     |    7 +-
 fs/jffs2/symlink.c                                |    1 -
 fs/jffs2/xattr.c                                  |    9 +-
 fs/jfs/acl.c                                      |  105 ++---
 fs/jfs/file.c                                     |    4 +-
 fs/jfs/jfs_acl.h                                  |    7 +-
 fs/jfs/jfs_xattr.h                                |    2 +
 fs/jfs/namei.c                                    |    1 +
 fs/jfs/super.c                                    |    2 +
 fs/jfs/xattr.c                                    |  108 ++----
 fs/mount.h                                        |    2 +-
 fs/namei.c                                        |   24 +-
 fs/nfs/inode.c                                    |    4 -
 fs/nfs/nfs3acl.c                                  |  291 +++-----------
 fs/nfs/nfs3proc.c                                 |   76 ++--
 fs/nfs/nfs3super.c                                |    3 +
 fs/nfsd/acl.h                                     |   16 +-
 fs/nfsd/nfs2acl.c                                 |   72 ++--
 fs/nfsd/nfs3acl.c                                 |   62 +--
 fs/nfsd/nfs4acl.c                                 |  120 ++++--
 fs/nfsd/nfs4proc.c                                |    1 +
 fs/nfsd/vfs.c                                     |  241 ------------
 fs/nfsd/vfs.h                                     |    8 -
 fs/nls/mac-celtic.c                               |    1 -
 fs/nls/mac-centeuro.c                             |    1 -
 fs/nls/mac-croatian.c                             |    1 -
 fs/nls/mac-cyrillic.c                             |    1 -
 fs/nls/mac-gaelic.c                               |    1 -
 fs/nls/mac-greek.c                                |    1 -
 fs/nls/mac-iceland.c                              |    1 -
 fs/nls/mac-inuit.c                                |    1 -
 fs/nls/mac-roman.c                                |    1 -
 fs/nls/mac-romanian.c                             |    1 -
 fs/nls/mac-turkish.c                              |    1 -
 fs/nls/nls_ascii.c                                |    1 -
 fs/nls/nls_base.c                                 |    5 +-
 fs/nls/nls_cp1250.c                               |    1 -
 fs/nls/nls_cp1251.c                               |    1 -
 fs/nls/nls_cp1255.c                               |    1 -
 fs/nls/nls_cp437.c                                |    1 -
 fs/nls/nls_cp737.c                                |    1 -
 fs/nls/nls_cp775.c                                |    1 -
 fs/nls/nls_cp850.c                                |    1 -
 fs/nls/nls_cp852.c                                |    1 -
 fs/nls/nls_cp855.c                                |    1 -
 fs/nls/nls_cp857.c                                |    1 -
 fs/nls/nls_cp860.c                                |    1 -
 fs/nls/nls_cp861.c                                |    1 -
 fs/nls/nls_cp862.c                                |    1 -
 fs/nls/nls_cp863.c                                |    1 -
 fs/nls/nls_cp864.c                                |    1 -
 fs/nls/nls_cp865.c                                |    1 -
 fs/nls/nls_cp866.c                                |    1 -
 fs/nls/nls_cp869.c                                |    1 -
 fs/nls/nls_cp874.c                                |    1 -
 fs/nls/nls_cp932.c                                |    1 -
 fs/nls/nls_cp936.c                                |    1 -
 fs/nls/nls_cp949.c                                |    1 -
 fs/nls/nls_cp950.c                                |    1 -
 fs/nls/nls_euc-jp.c                               |    1 -
 fs/nls/nls_iso8859-1.c                            |    1 -
 fs/nls/nls_iso8859-13.c                           |    1 -
 fs/nls/nls_iso8859-14.c                           |    1 -
 fs/nls/nls_iso8859-15.c                           |    1 -
 fs/nls/nls_iso8859-2.c                            |    1 -
 fs/nls/nls_iso8859-3.c                            |    1 -
 fs/nls/nls_iso8859-4.c                            |    1 -
 fs/nls/nls_iso8859-5.c                            |    1 -
 fs/nls/nls_iso8859-6.c                            |    1 -
 fs/nls/nls_iso8859-7.c                            |    1 -
 fs/nls/nls_iso8859-9.c                            |    1 -
 fs/nls/nls_koi8-r.c                               |    1 -
 fs/nls/nls_koi8-ru.c                              |    1 -
 fs/nls/nls_koi8-u.c                               |    1 -
 fs/nls/nls_utf8.c                                 |    1 -
 fs/ocfs2/acl.c                                    |  234 +----------
 fs/ocfs2/acl.h                                    |   13 +-
 fs/ocfs2/file.c                                   |    4 +-
 fs/ocfs2/namei.c                                  |   25 +-
 fs/ocfs2/refcounttree.c                           |   19 +-
 fs/ocfs2/xattr.c                                  |   21 +-
 fs/ocfs2/xattr.h                                  |    6 +-
 fs/posix_acl.c                                    |  428 ++++++++++++++++++++-
 fs/qnx4/inode.c                                   |   63 ++-
 fs/qnx4/qnx4.h                                    |    2 -
 fs/reiserfs/acl.h                                 |    4 +-
 fs/reiserfs/file.c                                |    1 +
 fs/reiserfs/namei.c                               |    4 +-
 fs/reiserfs/procfs.c                              |    4 +-
 fs/reiserfs/reiserfs.h                            |    8 -
 fs/reiserfs/super.c                               |    8 +-
 fs/reiserfs/xattr.c                               |    5 +-
 fs/reiserfs/xattr_acl.c                           |  190 ++-------
 fs/xattr_acl.c                                    |  180 ---------
 fs/xfs/xfs_acl.c                                  |  151 +-------
 fs/xfs/xfs_acl.h                                  |    9 +-
 fs/xfs/xfs_iops.c                                 |   55 ++-
 fs/xfs/xfs_iops.h                                 |    2 +-
 fs/xfs/xfs_xattr.c                                |    4 +-
 include/linux/cramfs_fs_sb.h                      |   20 -
 include/linux/fdtable.h                           |   35 +-
 include/linux/fs.h                                |    1 +
 include/linux/generic_acl.h                       |   14 -
 include/linux/nfs_fs.h                            |   24 +-
 include/linux/nls.h                               |    3 +-
 include/linux/posix_acl.h                         |   43 ++-
 include/linux/posix_acl_xattr.h                   |    3 +
 include/linux/rcupdate.h                          |    2 -
 init/do_mounts_rd.c                               |    2 +-
 kernel/rcu/update.c                               |   11 -
 mm/filemap.c                                      |   42 +-
 mm/shmem.c                                        |   57 ++-
 179 files changed, 1542 insertions(+), 3852 deletions(-)
 rename include/linux/cramfs_fs.h => fs/cramfs/internal.h (70%)
 delete mode 100644 fs/generic_acl.c
 delete mode 100644 fs/xattr_acl.c
 delete mode 100644 include/linux/cramfs_fs_sb.h
 delete mode 100644 include/linux/generic_acl.h
