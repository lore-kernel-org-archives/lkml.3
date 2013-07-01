Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3GAT7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:59:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40446 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab3GAT7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:59:50 -0400
Date: Mon, 1 Jul 2013 20:59:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git, part 1
Message-ID: <20130701195949.GI4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The major change in that pile is ->readdir() replacement with ->iterate(),
dealing with ->f_pos races in ->readdir() instances for good.  There's
a lot more, but I'd prefer to split the pull request into several stages
and this is the first obvious cutoff point.  Please, pull from the
usual place - 
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (67):
      consolidate io_remap_pfn_range definitions
      samsung: don't bother with setting VM_IO
      hose_mmap_page_range(): io_remap_pfn_range() will set all those flags...
      mn10300: don't bother with VM_IO
      sparc: __pci_mmap_set_flags() is useless
      drm: io_remap_pfn_range() sets VM_IO...
      i810: VM_IO is set by io_remap_pfn_range()
      vfio: remap_pfn_range() sets all those flags...
      au1200fb: io_remap_pfn_range() sets VM_IO
      au1100fb: VM_IO is set by io_remap_pfn_range()
      pxa3xx: VM_IO is set by io_remap_pfn_range()
      compat.c: LOOP_CLR_FD is taken care of in loop.c itself...
      move linux/loop.h to drivers/block
      [readdir] introduce iterate_dir() and dir_context
      [readdir] introduce ->iterate(), ctx->pos, dir_emit()
      [readdir] simple local unixlike: switch to ->iterate()
      [readdir] switch dcache_readdir() users to ->iterate()
      [readdir] convert ext3
      [readdir] convert udf
      [readdir] convert ubifs
      [readdir] convert squashfs
      [readdir] convert romfs
      [readdir] convert configfs
      [readdir] convert efs
      [readdir] convert openpromfs
      [readdir] convert procfs
      [readdir] convert bfs
      [readdir] convert exofs
      [readdir] convert gfs2
      [readdir] convert sysfs
      [readdir] convert nilfs2
      [readdir] convert omfs
      [readdir] convert qnx4
      [readdir] convert qnx6
      [readdir] convert ext4
      [readdir] convert nfs
      [readdir] convert ceph
      [readdir] convert jfs
      [readdir] convert logfs
      [readdir] convert adfs
      [readdir] convert affs
      [readdir] convert 9p
      [readdir] convert f2fs
      [readdir] convert jffs2
      [readdir] convert isofs
      [readdir] convert ntfs
      [readdir] convert reiserfs
      reiserfs: is_privroot_deh() needs only directory inode, actually
      reiserfs: switch reiserfs_readdir_dentry to inode
      [readdir] convert hpfs
      [readdir] convert fuse
      [readdir] convert freevxfs
      [readdir] convert cifs
      [readdir] convert befs
      [readdir] convert hfs
      [readdir] convert hfsplus
      [readdir] convert ncpfs
      [readdir] convert afs
      [readdir] convert hostfs
      [readdir] convert btrfs
      [readdir] convert xfs
      [readdir] convert fatfs
      [readdir] convert ocfs2
      [readdir] convert coda
      [readdir] convert ecryptfs
      [readdir] ->readdir() is gone
      [readdir] constify ->actor

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Diffstat:
 Documentation/filesystems/Locking         |    2 +-
 Documentation/filesystems/porting         |    6 +
 Documentation/filesystems/vfs.txt         |    4 +-
 arch/alpha/include/asm/pgtable.h          |    3 -
 arch/alpha/kernel/osf_sys.c               |   15 +-
 arch/alpha/kernel/pci-sysfs.c             |    1 -
 arch/arc/include/asm/pgtable.h            |    3 -
 arch/arm/include/asm/pgtable-nommu.h      |    2 -
 arch/arm/include/asm/pgtable.h            |    7 -
 arch/arm64/include/asm/pgtable.h          |    7 -
 arch/avr32/include/asm/pgtable.h          |    3 -
 arch/blackfin/include/asm/pgtable.h       |    1 -
 arch/c6x/include/asm/pgtable.h            |    1 -
 arch/cris/include/asm/pgtable.h           |    3 -
 arch/frv/include/asm/pgtable.h            |    3 -
 arch/h8300/include/asm/pgtable.h          |    3 -
 arch/hexagon/include/asm/pgtable.h        |    4 -
 arch/ia64/include/asm/pgtable.h           |    3 -
 arch/m32r/include/asm/pgtable.h           |    3 -
 arch/m68k/include/asm/pgtable_mm.h        |    3 -
 arch/m68k/include/asm/pgtable_no.h        |    3 -
 arch/metag/include/asm/pgtable.h          |    3 -
 arch/microblaze/include/asm/pgtable.h     |    3 -
 arch/mips/include/asm/pgtable.h           |    4 +-
 arch/mn10300/include/asm/pgtable.h        |    3 -
 arch/mn10300/unit-asb2305/pci-asb2305.c   |    2 +-
 arch/openrisc/include/asm/pgtable.h       |    3 -
 arch/parisc/hpux/fs.c                     |   16 +-
 arch/parisc/include/asm/pgtable.h         |    3 -
 arch/powerpc/include/asm/pgtable.h        |    3 -
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/s390/include/asm/pgtable.h           |    3 -
 arch/score/include/asm/pgtable.h          |    3 -
 arch/sh/include/asm/pgtable.h             |    3 -
 arch/sparc/include/asm/pgtable_32.h       |    1 +
 arch/sparc/include/asm/pgtable_64.h       |    1 +
 arch/sparc/kernel/pci.c                   |   10 -
 arch/tile/include/asm/pgtable.h           |    3 -
 arch/um/include/asm/pgtable.h             |    2 -
 arch/unicore32/include/asm/pgtable.h      |    7 -
 arch/x86/include/asm/pgtable.h            |    3 -
 arch/xtensa/include/asm/pgtable.h         |    8 -
 drivers/block/cryptoloop.c                |    2 +-
 drivers/block/loop.c                      |    2 +-
 {include/linux => drivers/block}/loop.h   |    2 +-
 drivers/gpu/drm/drm_vm.c                  |    1 -
 drivers/gpu/drm/i810/i810_dma.c           |    2 +-
 drivers/vfio/pci/vfio_pci.c               |    1 -
 drivers/video/au1100fb.c                  |    2 -
 drivers/video/au1200fb.c                  |    4 -
 drivers/video/pxa3xx-gcu.c                |    1 -
 fs/9p/vfs_dir.c                           |   72 +++----
 fs/adfs/dir.c                             |   42 ++--
 fs/affs/dir.c                             |   69 ++----
 fs/afs/dir.c                              |   99 +++-----
 fs/autofs4/root.c                         |    4 +-
 fs/bad_inode.c                            |    4 +-
 fs/befs/linuxvfs.c                        |   40 ++--
 fs/bfs/dir.c                              |   35 ++--
 fs/btrfs/delayed-inode.c                  |    9 +-
 fs/btrfs/delayed-inode.h                  |    3 +-
 fs/btrfs/inode.c                          |   49 ++---
 fs/ceph/dir.c                             |   99 ++++----
 fs/cifs/cifsfs.c                          |    2 +-
 fs/cifs/cifsfs.h                          |    2 +-
 fs/cifs/readdir.c                         |  178 +++++++--------
 fs/coda/dir.c                             |   66 ++----
 fs/compat.c                               |   43 ++--
 fs/compat_ioctl.c                         |    3 -
 fs/configfs/dir.c                         |  122 ++++------
 fs/cramfs/inode.c                         |   21 +-
 fs/ecryptfs/file.c                        |   37 ++--
 fs/efs/dir.c                              |   75 +++----
 fs/exofs/dir.c                            |   38 ++--
 fs/exportfs/expfs.c                       |   14 +-
 fs/ext2/dir.c                             |   27 +--
 fs/ext3/dir.c                             |  157 +++++--------
 fs/ext4/dir.c                             |  158 ++++++-------
 fs/ext4/ext4.h                            |    2 +-
 fs/ext4/inline.c                          |  164 ++++++--------
 fs/f2fs/dir.c                             |   36 ++--
 fs/fat/dir.c                              |  104 +++++----
 fs/freevxfs/vxfs_lookup.c                 |   55 ++---
 fs/fuse/dir.c                             |   37 ++--
 fs/gfs2/dir.c                             |   56 ++---
 fs/gfs2/dir.h                             |    4 +-
 fs/gfs2/export.c                          |   10 +-
 fs/gfs2/file.c                            |   23 +--
 fs/hfs/dir.c                              |   49 ++--
 fs/hfsplus/dir.c                          |   50 ++---
 fs/hostfs/hostfs_kern.c                   |   13 +-
 fs/hpfs/dir.c                             |   56 +++---
 fs/hppfs/hppfs.c                          |   33 ++--
 fs/isofs/dir.c                            |   42 ++--
 fs/jffs2/dir.c                            |   52 ++---
 fs/jfs/jfs_dtree.c                        |   63 +++---
 fs/jfs/jfs_dtree.h                        |    2 +-
 fs/jfs/namei.c                            |    2 +-
 fs/libfs.c                                |   80 +++----
 fs/logfs/dir.c                            |   49 ++---
 fs/minix/dir.c                            |   42 ++--
 fs/ncpfs/dir.c                            |   78 +++----
 fs/nfs/dir.c                              |   51 ++--
 fs/nfsd/nfs4recover.c                     |   20 ++-
 fs/nfsd/vfs.c                             |    9 +-
 fs/nilfs2/dir.c                           |   48 ++---
 fs/ntfs/dir.c                             |   84 +++-----
 fs/ocfs2/dir.c                            |  151 ++++--------
 fs/ocfs2/dir.h                            |    5 +-
 fs/ocfs2/file.c                           |    4 +-
 fs/ocfs2/journal.c                        |   14 +-
 fs/omfs/dir.c                             |   94 +++-----
 fs/openpromfs/inode.c                     |   95 ++++----
 fs/proc/base.c                            |  363 +++++++++++------------------
 fs/proc/fd.c                              |   96 ++++-----
 fs/proc/generic.c                         |  102 +++-----
 fs/proc/internal.h                        |    8 +-
 fs/proc/namespaces.c                      |   76 ++-----
 fs/proc/proc_net.c                        |    9 +-
 fs/proc/proc_sysctl.c                     |   71 +++----
 fs/proc/root.c                            |   19 +-
 fs/qnx4/dir.c                             |   66 +++---
 fs/qnx6/dir.c                             |   31 ++--
 fs/readdir.c                              |   56 +++---
 fs/reiserfs/dir.c                         |   36 ++--
 fs/reiserfs/reiserfs.h                    |    2 +-
 fs/reiserfs/xattr.c                       |   33 ++--
 fs/romfs/super.c                          |   21 +-
 fs/squashfs/dir.c                         |   40 +---
 fs/sysfs/dir.c                            |   66 ++----
 fs/sysv/dir.c                             |   37 ++--
 fs/ubifs/dir.c                            |   69 +++---
 fs/udf/dir.c                              |   63 ++---
 fs/ufs/dir.c                              |   28 +--
 fs/xfs/xfs_dir2.c                         |   13 +-
 fs/xfs/xfs_dir2_block.c                   |   17 +-
 fs/xfs/xfs_dir2_leaf.c                    |   18 +-
 fs/xfs/xfs_dir2_priv.h                    |   11 +-
 fs/xfs/xfs_dir2_sf.c                      |   31 +--
 fs/xfs/xfs_file.c                         |   12 +-
 fs/xfs/xfs_vnodeops.h                     |    3 +-
 include/asm-generic/pgtable.h             |    4 +
 include/linux/fs.h                        |   47 ++++-
 sound/soc/samsung/idma.c                  |    1 -
 144 files changed, 1957 insertions(+), 2820 deletions(-)
 rename {include/linux => drivers/block}/loop.h (98%)
