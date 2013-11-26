Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3KZCFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:05:41 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53410 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3KZCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:05:39 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/16] staging/lustre: sync with external tree, set 2
Date: Tue, 26 Nov 2013 10:04:54 +0800
Message-Id: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Following 16 patches were ported from Lustre external tree. Please see if
it is ok to apply them.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Amir Shehata (1):
  staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer

Andrew Perepechko (1):
  staging/lustre/llite: extended attribute cache

Andriy Skulysh (1):
  staging/lustre/ptlrpc: Fix race during exp_flock_hash creation

Dmitry Eremin (2):
  staging/lustre/build: clean up unused variables and dead code
  staging/lustre/build: fix compilation issue with is_compat_task

Fan Yong (2):
  staging/lustre/scrub: OI scrub on OST
  staging/lustre/scrub: control OI scrub on OST from user space

JC Lafoucriere (2):
  staging/lustre/mdt: HSM coordinator client interface
  staging/lustre/mdt: HSM coordinator agent interface

Jinshan Xiong (1):
  staging/lustre/hsm: Add hsm_release feature.

John L. Hammond (3):
  staging/lustre/mdc: prevent fall through in mdc_iocontrol()
  staging/lustre/lu: shrink lu_object by 8 bytes on x86_64
  staging/lustre/llite: don't check for O_CREAT in it_create_mode

Mikhail Pershin (2):
  staging/lustre/server: use unified request handler for MGS
  staging/lustre/llog: MGC to use OSD API for backup logs

Patrick Farrell (1):
  staging/lustre/nfs: writing to new files will return ENOENT

 .../staging/lustre/include/linux/libcfs/libcfs.h   |    2 -
 drivers/staging/lustre/lnet/selftest/rpc.c         |    2 -
 drivers/staging/lustre/lnet/selftest/selftest.h    |    3 -
 drivers/staging/lustre/lnet/selftest/timer.c       |    6 +-
 drivers/staging/lustre/lustre/include/dt_object.h  |    2 +-
 .../lustre/lustre/include/linux/lustre_compat25.h  |    4 +-
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 +
 drivers/staging/lustre/lustre/include/lu_object.h  |   19 -
 .../lustre/lustre/include/lustre/lustre_idl.h      |   44 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   24 +-
 drivers/staging/lustre/lustre/include/lustre_ha.h  |    3 -
 drivers/staging/lustre/lustre/include/lustre_log.h |   13 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |    2 -
 .../lustre/lustre/include/lustre_req_layout.h      |    7 +
 drivers/staging/lustre/lustre/include/md_object.h  |    4 +-
 drivers/staging/lustre/lustre/include/obd.h        |   15 +-
 .../staging/lustre/lustre/include/obd_support.h    |   10 +
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   28 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 +
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    8 +
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    3 -
 drivers/staging/lustre/lustre/libcfs/workitem.c    |   56 +-
 drivers/staging/lustre/lustre/llite/Makefile       |    2 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   36 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   24 +-
 drivers/staging/lustre/lustre/llite/file.c         |  105 +++-
 .../staging/lustre/lustre/llite/llite_internal.h   |   46 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   22 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   36 ++
 drivers/staging/lustre/lustre/llite/namei.c        |   15 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    4 +
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    2 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |  102 ++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |  640 ++++++++++++++++++++
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   16 +
 drivers/staging/lustre/lustre/lov/lov_object.c     |   35 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    1 +
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   26 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   63 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   54 +-
 drivers/staging/lustre/lustre/mgc/libmgc.c         |    3 -
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  401 +++++++-----
 drivers/staging/lustre/lustre/obdclass/llog.c      |  212 ++++---
 .../staging/lustre/lustre/obdclass/local_storage.c |    9 +-
 .../staging/lustre/lustre/obdclass/local_storage.h |    3 +
 .../lustre/lustre/obdclass/lprocfs_status.c        |    4 -
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   26 +-
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |    4 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    3 +
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   10 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   60 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   16 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    7 +
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   65 --
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   44 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    4 +
 59 files changed, 1750 insertions(+), 618 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/llite/xattr_cache.c

-- 
1.7.9.5

