Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3LCOEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:04:09 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51087 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3LCOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:05 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 00/15] staging/lustre: sync with external tree, set 2
Date: Tue,  3 Dec 2013 21:58:38 +0800
Message-Id: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I updated the patchset to fix up coding style and split large patches.
Please see if they can be merged.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

v2 -> v3:
Address Levente Kurusa's comments about coding style of patch 2.
Furtuer split large patches to do seperate things.

v1 -> v2:
PATCH 1 reverts previous commit ad8dbc9. I forgot to remove it from
my local queue after the discussion last time and ended up resending it.
Sorry for the noise...
PATCH 2 is updated to fix checkpatch error about return().
PATCH 3 and 4 are extracted from one external tree commit to do separate things.
PATCH 5 and 6 are from one external tree commit as well for the same reason.
PATCh 12 is updated to remove extra GPL notice that kernel already has one.


Amir Shehata (1):
  staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer

Andrew Perepechko (1):
  staging/lustre/llite: extended attribute cache

Dmitry Eremin (5):
  staging/lustre/build: fix compilation issue with is_compat_task
  staging/lustre: clean up SET_BUT_UNUSED/UNUSED macros
  staging/lustre/pinger: remove never implemented suspend timeouts
    functionality
  staging/lustre/obdclass: remove unuse variables from
    lprocfs_stats_collect/clear
  staging/lustre/ptlrpc: better error handling in ptlrpcd_start

Fan Yong (2):
  staging/lustre/scrub: OI scrub on OST
  staging/lustre: make code align in lma_incompat

JC Lafoucriere (2):
  staging/lustre: constify uuid argument of obd_uuid2str
  staging/lustre: make obd_uuid_equals return bool

Jinshan Xiong (1):
  staging/lustre/hsm: Add hsm_release feature.

John L. Hammond (1):
  staging/lustre/llite: don't check for O_CREAT in it_create_mode

Mikhail Pershin (1):
  staging/lustre/llog: MGC to use OSD API for backup logs

Peng Tao (1):
  Revert "staging/lustre/nfs: writing to new files will return ENOENT"

 .../staging/lustre/include/linux/libcfs/libcfs.h   |    2 -
 drivers/staging/lustre/lnet/selftest/rpc.c         |    2 -
 drivers/staging/lustre/lnet/selftest/selftest.h    |    3 -
 drivers/staging/lustre/lnet/selftest/timer.c       |   11 +-
 drivers/staging/lustre/lustre/include/dt_object.h  |    2 +-
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 +
 .../lustre/lustre/include/lustre/lustre_idl.h      |   41 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   17 +-
 drivers/staging/lustre/lustre/include/lustre_ha.h  |    3 -
 drivers/staging/lustre/lustre/include/lustre_log.h |   13 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |    2 -
 .../lustre/lustre/include/lustre_req_layout.h      |    5 +
 drivers/staging/lustre/lustre/include/md_object.h  |    4 +-
 drivers/staging/lustre/lustre/include/obd.h        |   15 +-
 .../staging/lustre/lustre/include/obd_support.h    |    2 +
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 +
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    3 -
 drivers/staging/lustre/lustre/llite/Makefile       |    2 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   34 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   24 +-
 drivers/staging/lustre/lustre/llite/file.c         |  105 +++-
 .../staging/lustre/lustre/llite/llite_internal.h   |   46 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   23 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   37 ++
 drivers/staging/lustre/lustre/llite/namei.c        |    9 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    4 +
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    2 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |  102 ++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |  617 ++++++++++++++++++++
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   16 +
 drivers/staging/lustre/lustre/lov/lov_object.c     |   35 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    1 +
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   26 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   63 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   23 +-
 drivers/staging/lustre/lustre/mgc/libmgc.c         |    3 -
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  394 ++++++++-----
 drivers/staging/lustre/lustre/obdclass/llog.c      |  212 ++++---
 .../staging/lustre/lustre/obdclass/local_storage.c |    9 +-
 .../staging/lustre/lustre/obdclass/local_storage.h |    3 +
 .../lustre/lustre/obdclass/lprocfs_status.c        |    4 -
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    2 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    3 +
 drivers/staging/lustre/lustre/ptlrpc/import.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   53 ++
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |    6 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    7 +
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   65 ---
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   44 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    4 +
 51 files changed, 1621 insertions(+), 491 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/llite/xattr_cache.c

-- 
1.7.9.5

