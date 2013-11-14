Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3KNQn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:43:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3KNQn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:26 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/26] staging/lustre: patch bomb 3
Date: Fri, 15 Nov 2013 00:42:47 +0800
Message-Id: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is the last patch bomb for now. All 26 patches are ported from Lustre
tree. And it syncs kernel Lustre client with Lustre tree up to commit
(Revert "LU-1346 libcfs: replace CFS_CAP_XXX with kernel definition").

Now kernel client is still a few dozens patches away. I will close the
gap in the next few days. My estimation is there will be another 20
patches or so and then we are in sync.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Andreas Dilger (1):
  staging/lustre/seq: make seq_proc_write_common() safer

Andrew Perepechko (2):
  staging/lustre/llite: speedup in unlink/rmdir
  staging/lustre/lprocfs: implement log2 using bitops

Andriy Skulysh (1):
  staging/lustre/ldlm: Fix flock detection for different mounts

Bobi Jam (2):
  staging/lustre/ldlm: MDT mount fails on MDS w/o MGS on it
  staging/lustre/lov: avoid subobj's coh_parent race

Bruno Faccini (2):
  staging/lustre/ldlm: Fix a race during FLock handling
  staging/lustre/ldlm: refine LU-2665 patch for POSIX compliance

Christopher J. Morrone (1):
  staging/lustre/changelogs: Correct KUC code max changelog msg size

Fan Yong (1):
  staging/lustre/scrub: support dryrun mode OI scrub

James Simmons (2):
  staging/lustre/autoconf: remove quota_on/quota_off checks
  staging/lustre/autoconf: remove LC_BI_HW_SEGMENTS test

Jinshan Xiong (3):
  staging/lustre/llite: error setting max_cache_mb at mount time
  staging/lustre/llite: Truncate to restore file
  staging/lustre/osc: osc_extent_wait() shouldn't be interruptible

John L. Hammond (2):
  staging/lustre/hsm: handle file ownership and timestamps
  staging/lustre/hsm: reprocess LDLM resource in mdt_hsm_release()

Keith Mannthey (1):
  staging/lustre/ptlrpc: skip rpcs that fail ptl_send_rpc

Nikitas Angelinas (1):
  staging/lustre/nrs: Fix a race condition in the ORR policy

Niu Yawei (1):
  staging/lustre/clio: incorrect assertions in 'enable-invariants'

Oleg Drokin (1):
  staging/lustre/clio: Do not shrink sublock at cancel

Sebastien Buisson (2):
  staging/lustre/build: fix race issues thanks to oap_lock
  staging/lustre/build: fix 'NULL pointer dereference' errors

Swapnil Pimpale (2):
  staging/lustre/dcache: Unsafe error handling arnd ll_splice_alias
  staging/lustre/ptlrpc: Return a meaningful status from ptlrpcd_init()

wang di (1):
  staging/lustre/mdt: return EXDEV for cross-MDT rename

 .../include/linux/libcfs/libcfs_kernelcomm.h       |    2 +
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    2 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |    2 +
 drivers/staging/lustre/lnet/selftest/conctl.c      |   51 +++++++++--------
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |   14 +++--
 drivers/staging/lustre/lustre/include/dt_object.h  |    4 ++
 .../lustre/lustre/include/linux/lustre_compat25.h  |   47 ---------------
 .../lustre/lustre/include/lustre/lustre_idl.h      |    2 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |    3 +
 .../lustre/lustre/include/lustre/lustreapi.h       |    4 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    5 ++
 drivers/staging/lustre/lustre/include/lustre_net.h |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   60 +++++++++++++++++---
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    1 +
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   14 ++++-
 drivers/staging/lustre/lustre/llite/file.c         |    5 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   57 +++++++++----------
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    4 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   51 +++++++----------
 drivers/staging/lustre/lustre/llite/statahead.c    |   27 +++++----
 drivers/staging/lustre/lustre/llite/vvp_io.c       |    5 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |    2 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   12 ++--
 drivers/staging/lustre/lustre/lov/lov_request.c    |    2 +-
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |    4 ++
 drivers/staging/lustre/lustre/lov/lovsub_lock.c    |    5 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   38 ++++++-------
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |    4 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   21 ++++---
 drivers/staging/lustre/lustre/mgc/libmgc.c         |    4 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   18 ++++--
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |    7 ++-
 .../lustre/lustre/obdclass/lprocfs_status.c        |   30 +++++-----
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   38 +++++++++----
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    8 ++-
 drivers/staging/lustre/lustre/osc/osc_io.c         |    2 +
 drivers/staging/lustre/lustre/ptlrpc/client.c      |    1 +
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   13 +++--
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |   10 ++--
 41 files changed, 335 insertions(+), 252 deletions(-)

-- 
1.7.9.5

