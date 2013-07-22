Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3GVQJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:09:53 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50155 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3GVQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:09:51 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/48] staging/lustre: minor cleanup and Intel Lustre sync
Date: Tue, 23 Jul 2013 00:06:21 +0800
Message-Id: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The first two of the patchset are minor cleanup of lustre code. And the
rest of it are patches ported from Intel Lustre tree. Please help to
queue them.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Alexander.Boyko (1):
  staging/lustre/crypto: add crc32c module loading to libcfs

Andreas Dilger (2):
  staging/lustre/ldlm: print FID in lvbo_init(), lvbo_update
  staging/lustre/mdt: duplicate link names in directory

Andriy Skulysh (1):
  staging/lustre/ldlm: Fix flock deadlock detection race

Bruce Korb (1):
  staging/lustre/dlmlock: compress out unused space

Bruno Faccini (1):
  staging/lustre/mdc: Keep resend FLocks

Dmitry Eremin (2):
  staging/lustre/llite: A not locked mutex can be unlocked.
  staging/lustre/ptlrpc: race in pinger (use-after-free situation)

Fan Yong (3):
  staging/lustre/lfsck: LFSCK 1.5 technical debts (3)
  staging/lustre/llite: return valid fsid for statfs
  staging/lustre/scrub: purge inconsistenct objects after OI scrub

Hiroya Nozaki (1):
  staging/lustre/ptlrpc: Race between start and stop service threads

Jinshan Xiong (1):
  staging/lustre/layout: introduce new layout for released files

John L. Hammond (7):
  staging/lustre/llite: use READ, WRITE around ll_rw_stats_tally()
  staging/lustre/llite: check alloc in ll_file_data_get, ll_dir_ioctl
  staging/lustre/llite: check ll_prep_md_op_data() using IS_ERR()
  staging/lustre/md: fix lu_ucred.c boilerplate
  staging/lustre/obdclass: use a dummy structure for lu_ref_link
  staging/lustre/llite: call simple_setattr() from ll_md_setattr()
  staging/lustre/procfs: return -ENOMEM from lprocfs_register()

Keith Mannthey (3):
  staging/lustre/osc: Check return code for lu_kmem_init
  staging/lustre/llite: error of listxattr when buffer is small
  staging/lustre/style: removes obsolete EXPORT_SYMTAB macros v2

Li Wei (1):
  staging/lustre/ptlrpc: Translate between host and network errnos

Liu Xuezhao (3):
  staging/lustre/fid: prepare FID module for client server split
  staging/lustre/fld: prepare FLD module for client server split
  staging/lustre/obdclass: add obd_target.h

Nathaniel Clark (1):
  staging/lustre/obdclass: be more careful processing server name

Ned Bass (1):
  staging/lustre/lmv: fix duplicate directory entries

Oleg Drokin (3):
  staging/lustre/ldlm: split client namespaces into active and inactive
  staging/lustre: Only wake up ldlm_poold as frequently as the check
    interval
  staging/lustre: Make quota namespace refcounting consistent

Patrick Farrell (1):
  staging/lustre/llite: Anonymous dentry incorrectly identified as root

Peng Tao (3):
  staging/lustre: remove bogus ifndef EXPORT_SYMBOL
  staging/lustre/obdclass: restore lu_ref
  staging/lustre/lnet: remove empty file lnet/lnet/api-errno.c

Sebastien Buisson (4):
  staging/lustre: fix 'program hangs' errors
  staging/lustre: fix 'code maintainability' errors
  staging/lustre/build: fix 'data race condition' issues
  staging/lustre/build: fix 'data race condition' issues

Thomas Leibovici (2):
  staging/lustre/lmv: support DNE with HSM.
  staging/lustre/lmv: support DNE with HSM.

jcl (5):
  staging/lustre/mdc: layout lock rpc must not take rpc_lock
  staging/lustre/mdt: add macros for fid string len
  staging/lustre/llapi: add user space method for lov_user_md
  staging/lustre/llite: force lvb_data update after layout change
  staging/lustre/mdt: HSM on disk actions record

wang di (1):
  staging/lustre/llite: missing last bit in ll_have_md_lock

 .../lustre/include/linux/libcfs/libcfs_prim.h      |    4 -
 drivers/staging/lustre/lnet/lnet/Makefile          |    2 +-
 drivers/staging/lustre/lnet/lnet/api-errno.c       |   39 --
 drivers/staging/lustre/lnet/selftest/rpc.c         |    4 +-
 drivers/staging/lustre/lustre/Kconfig              |   15 +
 drivers/staging/lustre/lustre/fid/Makefile         |    2 +-
 drivers/staging/lustre/lustre/fid/fid_handler.c    |  661 --------------------
 drivers/staging/lustre/lustre/fid/fid_internal.h   |   36 +-
 drivers/staging/lustre/lustre/fid/fid_lib.c        |   14 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |  133 ++--
 drivers/staging/lustre/lustre/fid/fid_store.c      |  259 --------
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    3 -
 drivers/staging/lustre/lustre/fld/Makefile         |    2 +-
 drivers/staging/lustre/lustre/fld/fld_handler.c    |  447 -------------
 drivers/staging/lustre/lustre/fld/fld_index.c      |  426 -------------
 drivers/staging/lustre/lustre/fld/fld_internal.h   |   29 -
 drivers/staging/lustre/lustre/fld/fld_request.c    |   40 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |  205 +-----
 drivers/staging/lustre/lustre/include/cl_object.h  |   10 +-
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |   10 -
 .../staging/lustre/lustre/include/lprocfs_status.h |   39 --
 drivers/staging/lustre/lustre/include/lu_object.h  |   23 +-
 drivers/staging/lustre/lustre/include/lu_ref.h     |  161 +++--
 .../lustre/lustre/include/lustre/lustre_errno.h    |  215 +++++++
 .../lustre/lustre/include/lustre/lustre_idl.h      |   82 ++-
 .../lustre/lustre/include/lustre/lustre_user.h     |   12 +
 .../staging/lustre/lustre/include/lustre_disk.h    |   56 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |  202 +-----
 .../lustre/lustre/include/lustre_dlm_flags.h       |  460 ++++++++++++++
 drivers/staging/lustre/lustre/include/lustre_fid.h |  113 ++--
 drivers/staging/lustre/lustre/include/lustre_fld.h |   41 --
 .../staging/lustre/lustre/include/lustre_import.h  |    2 +
 drivers/staging/lustre/lustre/include/lustre_mdc.h |    6 +-
 drivers/staging/lustre/lustre/include/lustre_mdt.h |   84 ---
 drivers/staging/lustre/lustre/include/lustre_net.h |   32 +
 drivers/staging/lustre/lustre/include/md_object.h  |    5 -
 drivers/staging/lustre/lustre/include/obd.h        |  168 +----
 drivers/staging/lustre/lustre/include/obd_lov.h    |   10 -
 .../staging/lustre/lustre/include/obd_support.h    |    1 +
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    2 +-
 drivers/staging/lustre/lustre/ldlm/l_lock.c        |    8 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   18 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |   45 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |  196 +++---
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    6 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |   84 ++-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   13 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   60 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |    3 -
 drivers/staging/lustre/lustre/libcfs/libcfs_lock.c |    3 -
 drivers/staging/lustre/lustre/libcfs/libcfs_mem.c  |    3 -
 .../lustre/lustre/libcfs/linux/linux-crypto.c      |    2 +
 drivers/staging/lustre/lustre/llite/dcache.c       |    7 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   17 +-
 drivers/staging/lustre/lustre/llite/file.c         |   96 +--
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   14 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |   36 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   16 +
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   10 +-
 drivers/staging/lustre/lustre/llite/namei.c        |    5 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   14 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |    7 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  203 +++++-
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   11 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |   23 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |   34 +
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    8 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   73 ++-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   19 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    1 -
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   29 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   19 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    8 +-
 drivers/staging/lustre/lustre/obdclass/Makefile    |    7 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   17 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    6 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |    5 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |    9 +-
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  |    4 -
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |   17 +
 .../lustre/lustre/obdclass/lprocfs_jobstats.c      |  562 -----------------
 .../lustre/lustre/obdclass/lprocfs_status.c        |   28 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   25 +-
 drivers/staging/lustre/lustre/obdclass/lu_ref.c    |  401 +++++++++++-
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c  |    8 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |   11 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   59 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |    1 +
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    8 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |  124 ++--
 drivers/staging/lustre/lustre/osc/osc_request.c    |    4 +
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    1 +
 drivers/staging/lustre/lustre/ptlrpc/errno.c       |  382 +++++++++++
 .../staging/lustre/lustre/ptlrpc/gss/lproc_gss.c   |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |    3 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    4 +
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   39 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   16 +-
 100 files changed, 3018 insertions(+), 3879 deletions(-)
 delete mode 100644 drivers/staging/lustre/lnet/lnet/api-errno.c
 delete mode 100644 drivers/staging/lustre/lustre/fid/fid_handler.c
 delete mode 100644 drivers/staging/lustre/lustre/fid/fid_store.c
 delete mode 100644 drivers/staging/lustre/lustre/fld/fld_handler.c
 delete mode 100644 drivers/staging/lustre/lustre/fld/fld_index.c
 create mode 100644 drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_mdt.h
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/errno.c

-- 
1.7.9.5

