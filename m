Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3KNQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:38:30 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35228 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3KNQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:24 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/39] staging/lustre: patch bomb 2
Date: Fri, 15 Nov 2013 00:32:23 +0800
Message-Id: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is the second patch bomb. All 39 patches are ported from Lustre tree.
And it syncs kernel client with Lustre tree up to commit
(LU-3581 osc: Lustre returns EINTR from writes when SA_RESTART is set).

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Andreas Dilger (1):
  staging/lustre/osd-ldiskfs: remove dependency on mdd module

Andriy Skulysh (2):
  staging/lustre/ptlrpc: add rpc_cache
  staging/lustre/ldlm: ldlm_flock_deadlock() ASSERTION( req != lock )
    failed

Aurelien Degremont (1):
  staging/lustre/hsm: copy start error should set HP_FLAG_COMPLETED

Bob Glossman (1):
  staging/lustre/libcfs: improve validity test for valid file
    descriptors

Christopher J. Morrone (1):
  staging/lustre/changelogs: Account for changelog_ext_rec in
    CR_MAXSIZE

Dmitry Eremin (2):
  staging/lustre/lnet: build Lustre with Intel OFED for Xeon Phi
  staging/lustre/build: build error with gcc 4.7.0 20110509

Fan Yong (1):
  staging/lustre/llite: return compatible fsid for statfs

Gaurav Mahajan (1):
  staging/lustre/llite: Delaying creation of client side proc entries.

Henri Doreau (1):
  staging/lustre/utils: Posix copytool fixes.

JC Lafoucriere (3):
  staging/lustre/mdt: CDT cleanup follow-on patch
  staging/lustre/lmv: update coding style
  staging/lustre/mdt: HSM EXIST event not triggered at last rm/mv

James Simmons (5):
  staging/lustre/lvfs: remove llog_lvfs.c and other lvfs code from llog
  staging/lustre/autoconf: remove LC_LOCK_MAP_ACQUIRE test
  staging/lustre/autoconf: remove LC_FS_STRUCT_USE_PATH
  staging/lustre/autoconf: remove LC_SECURITY_PLUG test
  staging/lustre/osc: Lustre returns EINTR from writes when SA_RESTART
    is set

Jinshan Xiong (4):
  staging/lustre/hsm: small fixes for HSM
  staging/lustre/llite: reset writeback index in ll_writepages
  staging/lustre/llite: cancel open lock before closing file
  staging/lustre/hsm: Add support to drop all pages for ll_data_version

John L. Hammond (3):
  staging/lustre/hsm: remove hsm_nl proc file
  staging/lustre/clio: honor O_NOATIME
  staging/lustre/obd: add md_stats to MDC and LMV devices

Li Xi (1):
  staging/lustre/libcfs: Add relocation function to libcfs heap

Mikhail Pershin (1):
  staging/lustre/obdclass: fix wrong device put in case of race

Ned Bass (1):
  staging/lustre/mdc: document mdc_rpc_lock

Niu Yawei (1):
  staging/lustre/llite: use 64bits flags in ll_lov_setea()

Sebastien Buisson (5):
  staging/lustre/build: fix 'deadcode' errors
  staging/lustre/build: fix 'integer handling' issues
  staging/lustre/build: fix 'data race condition' issues
  staging/lustre/build: fix 'NULL pointer dereference' errors
  staging/lustre/build: fix 'no effect' errors

Swapnil Pimpale (1):
  staging/lustre/lov: Get the correct address of lmm_objects

Vitaly Fertman (1):
  staging/lustre/clio: wrong cl_lock usage

wang di (2):
  staging/lustre/lmv: choose right MDT for open by FID
  staging/lustre/osd: remove fld lookup during configuration

 .../lustre/include/linux/libcfs/libcfs_debug.h     |  129 +--
 .../lustre/include/linux/libcfs/libcfs_heap.h      |    1 +
 .../include/linux/libcfs/libcfs_kernelcomm.h       |    1 +
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |    2 +
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    8 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |    6 +-
 .../lustre/lustre/include/linux/lustre_compat25.h  |   14 -
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |   84 --
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    5 -
 .../lustre/lustre/include/lustre/lustre_idl.h      |    8 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   16 +-
 .../lustre/lustre/include/lustre/lustreapi.h       |    7 +-
 .../staging/lustre/lustre/include/lustre_capa.h    |   25 +-
 .../staging/lustre/lustre/include/lustre_export.h  |    1 -
 drivers/staging/lustre/lustre/include/lustre_log.h |    4 -
 drivers/staging/lustre/lustre/include/lustre_mdc.h |   18 +
 .../staging/lustre/lustre/include/lustre_update.h  |    3 +-
 drivers/staging/lustre/lustre/include/md_object.h  |   20 -
 drivers/staging/lustre/lustre/include/obd.h        |  139 ++--
 drivers/staging/lustre/lustre/include/obd_class.h  |  129 ++-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |    3 +
 drivers/staging/lustre/lustre/libcfs/debug.c       |  131 +--
 drivers/staging/lustre/lustre/libcfs/heap.c        |   18 +-
 .../lustre/lustre/libcfs/kernel_user_comm.c        |   10 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |    4 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   30 +-
 drivers/staging/lustre/lustre/llite/file.c         |   98 ++-
 .../staging/lustre/lustre/llite/llite_internal.h   |    6 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   25 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   16 -
 drivers/staging/lustre/lustre/llite/rw.c           |    6 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |   11 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |    8 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  115 +--
 drivers/staging/lustre/lustre/lov/lov_io.c         |    4 +-
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   13 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    2 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |    3 +-
 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c   |  760 ------------------
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |    6 +
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   17 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |   73 --
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   10 +-
 drivers/staging/lustre/lustre/obdclass/capa.c      |   41 +
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    2 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    5 +
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |   34 +-
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |    6 +-
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c |  847 --------------------
 .../staging/lustre/lustre/obdclass/local_storage.c |   13 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |   58 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   43 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |   21 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |   19 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   42 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |    2 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    4 +
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |   24 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    1 -
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   13 +-
 63 files changed, 772 insertions(+), 2402 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c

-- 
1.7.9.5

