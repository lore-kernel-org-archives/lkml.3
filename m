Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3KNQGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:06:43 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36515 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab3KNQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:06:35 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/40] staging/lustre: patch bomb 1
Date: Fri, 15 Nov 2013 00:02:30 +0800
Message-Id: <1384444990-12191-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here are 40 patches. Three cleanup patches and 37 patches ported
from Lustre master to commit
LU-2940 llite: Fix for oops in vvp_pgcache_show()

There are two more patchsets that I will send out following up.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Amir Shehata (2):
  staging/lustre/lnet: Fix assert on empty group in selftest module
  staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer

Andreas Dilger (2):
  staging/lustre/ldlm: fix resource/fid check, use DLDLMRES
  staging/lustre/idl: remove LASSERT/CLASSERT from lustre_idl.h

Andrew Perepechko (1):
  staging/lustre/llite: extended attribute cache

Andriy Skulysh (2):
  staging/lustre/ptlrpc: Fix race during exp_flock_hash creation
  staging/lustre/ptlrpc: flock deadlock detection does not work

Artem Blagodarenko (1):
  staging/lustre/mgs: set_param -P option that sets value permanently

Dmitry Eremin (2):
  staging/lustre/build: clean up unused variables and dead code
  staging/lustre/build: fix compilation issue with is_compat_task

Doug Oucharek (1):
  staging/lustre/lnet: Add LNet Router Priority parameter

Fan Yong (2):
  staging/lustre/scrub: OI scrub on OST
  staging/lustre/scrub: control OI scrub on OST from user space

JC Lafoucriere (5):
  staging/lustre/llite: Access to released file trigs a restore
  staging/lustre/mdt: HSM coordinator client interface
  staging/lustre/mdt: HSM coordinator agent interface
  staging/lustre/api: HSM import uses new released pattern
  staging/lustre/utils: HSM Posix CopyTool

James Simmons (2):
  staging/lustre/autoconf: remove vectored fops tests
  staging/lustre/autoconf: remove LIBCFS_HAVE_IS_COMPAT_TASK test

Jinshan Xiong (2):
  staging/lustre/hsm: Implementation of exclusive open
  staging/lustre/hsm: Add hsm_release feature.

John L. Hammond (7):
  staging/lustre: validate open handle cookies
  staging/lustre/llite: use correct FID in ll_och_fill()
  staging/lustre/lov: convert magic to host-endian in lov_dump_lmm()
  staging/lustre/mdc: prevent fall through in mdc_iocontrol()
  staging/lustre/lu: shrink lu_object by 8 bytes on x86_64
  staging/lustre/llite: don't check for O_CREAT in it_create_mode
  staging/lustre/llite: pass correct pointer to obd_iocontrol()

Lai Siyao (1):
  staging/lustre/llite: remove ll_d_root_ops

Li Xi (1):
  staging/lustre/llog: fix return value of llog_alloc_handle

Mikhail Pershin (4):
  staging/lustre/server: use unified request handler for MGS
  staging/lustre/llog: MGC to use OSD API for backup logs
  staging/lustre/target: move OUT to the unified target code
  staging/lustre/seq: unified SEQ handler

Nathaniel Clark (1):
  staging/lustre/xattr: separate ACL and XATTR caches

Patrick Farrell (1):
  staging/lustre/nfs: writing to new files will return ENOENT

Peng Tao (3):
  staging/lustre/llite: restore ll_fiemap
  staging/lustre: remove lu_target.h
  staging/lustre: remove llog_server.c

 .../staging/lustre/include/linux/libcfs/curproc.h  |    1 -
 .../staging/lustre/include/linux/libcfs/libcfs.h   |    2 -
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |    1 +
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |    5 +-
 .../staging/lustre/include/linux/lnet/lib-types.h  |    2 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    5 +-
 drivers/staging/lustre/lnet/lnet/config.c          |   39 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |    6 +
 drivers/staging/lustre/lnet/lnet/router.c          |   19 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   16 +-
 drivers/staging/lustre/lnet/selftest/conctl.c      |   56 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    2 +-
 drivers/staging/lustre/lnet/selftest/console.c     |  105 ++--
 drivers/staging/lustre/lnet/selftest/console.h     |    6 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |    2 -
 drivers/staging/lustre/lnet/selftest/selftest.h    |    3 -
 drivers/staging/lustre/lnet/selftest/timer.c       |    6 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |    6 +-
 drivers/staging/lustre/lustre/include/dt_object.h  |    2 +-
 .../lustre/lustre/include/linux/lustre_compat25.h  |    4 +-
 .../lustre/lustre/include/linux/lustre_intent.h    |    2 +-
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 +
 drivers/staging/lustre/lustre/include/lu_object.h  |   19 -
 drivers/staging/lustre/lustre/include/lu_target.h  |   91 ---
 .../lustre/lustre/include/lustre/lustre_idl.h      |  111 ++--
 .../lustre/lustre/include/lustre/lustre_user.h     |   63 +-
 .../lustre/lustre/include/lustre/lustreapi.h       |  208 ++++---
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    2 +
 .../staging/lustre/lustre/include/lustre_disk.h    |    2 +
 .../lustre/lustre/include/lustre_dlm_flags.h       |   24 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    6 -
 drivers/staging/lustre/lustre/include/lustre_ha.h  |    3 -
 .../staging/lustre/lustre/include/lustre_handles.h |    5 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |   11 +-
 drivers/staging/lustre/lustre/include/lustre_log.h |   13 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |   19 +-
 .../lustre/lustre/include/lustre_req_layout.h      |    7 +
 drivers/staging/lustre/lustre/include/md_object.h  |    4 +-
 drivers/staging/lustre/lustre/include/obd.h        |   15 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |    9 +-
 .../staging/lustre/lustre/include/obd_support.h    |   10 +
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    6 +
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   69 ++-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    7 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |   47 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   39 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   19 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   13 -
 drivers/staging/lustre/lustre/libcfs/workitem.c    |   55 +-
 drivers/staging/lustre/lustre/llite/Makefile       |    2 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   77 +--
 drivers/staging/lustre/lustre/llite/dir.c          |   47 +-
 drivers/staging/lustre/lustre/llite/file.c         |  622 ++++++++++++++++++--
 .../staging/lustre/lustre/llite/llite_internal.h   |   59 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   91 ++-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    6 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   36 ++
 drivers/staging/lustre/lustre/llite/namei.c        |   53 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |    7 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    4 +
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   54 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    2 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |  105 ++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |  559 ++++++++++++++++++
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   16 +
 drivers/staging/lustre/lustre/lov/lov_internal.h   |    4 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |   15 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   35 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   20 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    5 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   31 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  104 +++-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  116 ++--
 drivers/staging/lustre/lustre/mgc/libmgc.c         |    3 -
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  492 ++++++++++------
 drivers/staging/lustre/lustre/obdclass/genops.c    |    2 +-
 drivers/staging/lustre/lustre/obdclass/llog.c      |  214 ++++---
 .../staging/lustre/lustre/obdclass/local_storage.c |    9 +-
 .../staging/lustre/lustre/obdclass/local_storage.h |    3 +
 .../lustre/lustre/obdclass/lprocfs_status.c        |    5 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   26 +-
 .../lustre/lustre/obdclass/lustre_handles.c        |    4 +-
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |    4 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |   50 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    3 +
 .../staging/lustre/lustre/obdecho/echo_client.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   10 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   63 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_server.c |  450 --------------
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   16 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |   59 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   65 --
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   44 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   60 +-
 99 files changed, 3043 insertions(+), 1793 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/lu_target.h
 create mode 100644 drivers/staging/lustre/lustre/llite/xattr_cache.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/llog_server.c

-- 
1.7.9.5

