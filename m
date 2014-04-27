Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaD0R0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:26:47 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47947 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaD0RHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:40 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 00/47] Lustre fixes and cleanups
Date: Sun, 27 Apr 2014 13:06:24 -0400
Message-Id: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

   This pile of patches brings in most of the recent fixes from
   current Lustre development tree, also code cleanups, junk removal
   and such.
   A relatively unsynced area remaining is in client io stack
   that is undergoing some major shakeups now, I'll try to tackle
   it later once things actually settle down some more.

   There are several checkpatch warnings in this patchset that
   I am not sure what to do aobut since the messages printed are
   genuinely long:

WARNING: quoted string split across lines
#61: FILE: drivers/staging/lustre/lustre/ptlrpc/import.c:1424:
+		CERROR("%s: don't know how to disconnect from %s "
+		       "(connect_op %d): rc = %d\n",

total: 0 errors, 1 warnings, 73 lines checked

0009-staging-lustre-ptlrpc-don-t-try-to-recover-no_recov-.patch has style problems, please review.

WARNING: quoted string split across lines
#311: FILE: drivers/staging/lustre/lustre/lov/lov_ea.c:352:
+	CDEBUG(level, "lsm %p, objid "DOSTID", maxbytes "LPX64", magic 0x%08X,"
+	       " stripe_size %u, stripe_count %u, refc: %d,"

WARNING: quoted string split across lines
#312: FILE: drivers/staging/lustre/lustre/lov/lov_ea.c:353:
+	       " stripe_size %u, stripe_count %u, refc: %d,"
+	       " layout_gen %u, pool ["LOV_POOLNAMEF"]\n", lsm,

total: 0 errors, 2 warnings, 337 lines checked
0016-staging-lustre-obdclass-remove-uses-of-lov_stripe_md.patch has style problems, please review.

WARNING: line over 80 characters
#110: FILE: drivers/staging/lustre/lustre/llite/statahead.c:1311:
+			CDEBUG(D_READA, "stop statahead thread: sai %p pid %u\n",

WARNING: quoted string split across lines
#120: FILE: drivers/staging/lustre/lustre/llite/statahead.c:1486:
 			       ", sent/replied "LPU64"/"LPU64", stopping "
+			       "statahead thread\n",

total: 0 errors, 2 warnings, 94 lines checked

0025-stagaing-lustre-Improve-statahead-debug-messages.patch has style problems, please review.

WARNING: quoted string split across lines
#43: FILE: drivers/staging/lustre/lustre/llite/llite_lib.c:2461:
+	       "%s: dirty page discard: %s/fid: "DFID"/%s may get corrupted "
+	       "(rc %d)\n", ll_get_fsname(page->mapping->host->i_sb, NULL, 0),

total: 0 errors, 1 warnings, 17 lines checked

0037-staging-lustre-llite-Do-not-rate-limit-dirty-page-di.patch has style problems, please review.


  Please consider for merging.

Bye,
    Oleg
Andreas Dilger (4):
  staging/lustre/ptlrpc: don't try to recover no_recov connection
  staging/lustre: quiet console permission error messages
  staging/lustre: shrink lu_object_header by 8 bytes on x86_64
  staging/lustre: pass fsync() range through RPC/IO stack

Andrew Korty (2):
  staging/lustre/gss: gssnull security flavor
  staging/lustre/gss: Shared key mechanism & flavors

Andriy Skulysh (1):
  staging/lustre/ptlrpc: add rpc_cache

Ann Koehler (1):
  staging/lustre: restore __GFP_WAIT flag to memalloc calls

Bob Glossman (1):
  staging/lustre/lloop: avoid panic during blockdev_info

Bobi Jam (3):
  staging/lustre/llite: issue OST_SYNC for fsync()
  staging/lustre/llite: deadlock taking lli_trunc_sem during file write
  staging/lustre/llite: prevent buffer overflow in fiemap

Brian Behlendorf (1):
  staging/lustre: Limit reply buffer size

Cheng Shao (1):
  staging/lustre/ptlrpc: Remove log message about export timer update

Christopher J. Morrone (2):
  staging/lustre/llite: Avoid statahead thread start/stop deadlocks
  stagaing/lustre: Improve statahead debug messages

Dmitry Eremin (8):
  staging/lustre/gss: fix few issues found by Klocwork Insight tool
  staging/lustre/gss: fix uninitialized variable
  staging/lustre/ldlm: fix NULL pointer dereference
  staging/lustre/lnet: lnet: fix issues found by Klocwork Insight tool
  staging/lustre/mdc: fix issue found by Klocwork Insight tool
  staging/lustre/libcfs: fix issues found by Klocwork Insight tool
  staging/lustre: replace semaphores with mutexes
  staging/lustre/clio: replace semaphore with mutex

Hongchao Zhang (1):
  staging/lustre/osc: don't activate deactivated obd_import

James Nunez (1):
  staging/lustre/hsm: HSM requests not delivered

Jinshan Xiong (3):
  staging/lustre/lov: to not hold sub locks at initialization
  staging/lustre/llite: access layout version under a lock
  staging/lustre/clio: Solve a race in cl_lock_put

John L. Hammond (4):
  staging/lustre/lov: remove unused lov llog code
  staging/lustre/obdclass: remove uses of lov_stripe_md
  staging/lustre: remove lustre/include/ioctl.h
  staging/lustre/llite: remove dead code

Li Xi (4):
  staging/lustre/ldlm: Hold lock when clearing flag
  staging/lustre: fix permission problem of setfacl
  staging/lustre/libcfs: add CPU table functions for uniprocessor
  staging/lustre: remove assertion of spin_is_locked()

Liang Zhen (1):
  staging/lustre/lnet: NI shutdown may loop forever

Matt Ezell (1):
  staging/lustre/lnet: Dropped messages are not accounted correctly

Niu Yawei (1):
  staging/lustre/clio: clear nowait flag agl lock re-enqueue

Oleg Drokin (1):
  staging/lustre: Fix unsafe userspace access in many proc files

Patrick Farrell (1):
  staging/lustre/ptlrpc: Fix assertion failure of null_alloc_rs()

Peng Tao (1):
  staging/lustre/hsm: count NULL terminator in hai_zero/hal_size

Ryan Haasken (2):
  staging/lustre/llite: Do not rate limit dirty page discard warning
  staging/lustre: Always clamp cdls_delay between min and max

Swapnil Pimpale (1):
  staging/lustre/osc: Update inode timestamp for lockless IO as well

wang di (1):
  staging/lustre/mdc: use cl_max_mds_md to pack getattr RPC

 .../lustre/include/linux/libcfs/libcfs_cpu.h       |   5 +
 .../lustre/include/linux/libcfs/libcfs_private.h   |   4 +-
 .../lustre/include/linux/libcfs/linux/linux-lock.h |   2 +-
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |   5 +
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   8 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   4 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |  15 +-
 drivers/staging/lustre/lnet/lnet/router.c          |   3 +-
 drivers/staging/lustre/lnet/selftest/conctl.c      |  11 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |  14 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |  41 +++-
 drivers/staging/lustre/lustre/include/dt_object.h  |   9 +-
 drivers/staging/lustre/lustre/include/ioctl.h      | 106 --------
 drivers/staging/lustre/lustre/include/lu_object.h  |   8 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |  28 ++-
 .../lustre/lustre/include/lustre/lustre_user.h     |   5 +-
 .../staging/lustre/lustre/include/lustre_debug.h   |   1 -
 drivers/staging/lustre/lustre/include/lustre_dlm.h |   2 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |  13 -
 drivers/staging/lustre/lustre/include/lustre_log.h |  10 -
 drivers/staging/lustre/lustre/include/lustre_mdc.h |  23 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |   4 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |  25 ++
 drivers/staging/lustre/lustre/include/obd.h        |  24 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  16 +-
 drivers/staging/lustre/lustre/include/obd_lov.h    | 116 ---------
 .../staging/lustre/lustre/include/obd_support.h    |  10 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |  17 +-
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |  15 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c   |   2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |  10 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   2 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |  21 ++
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |  18 +-
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  |  12 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |  10 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |  26 +-
 drivers/staging/lustre/lustre/llite/dir.c          |  15 +-
 drivers/staging/lustre/lustre/llite/file.c         | 148 ++++++-----
 drivers/staging/lustre/lustre/llite/llite_capa.c   |   4 +-
 .../staging/lustre/lustre/llite/llite_internal.h   | 177 ++++----------
 drivers/staging/lustre/lustre/llite/llite_lib.c    | 135 +++++-----
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |  23 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   4 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |  10 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  | 149 +++++++++--
 drivers/staging/lustre/lustre/llite/namei.c        |  40 +--
 drivers/staging/lustre/lustre/llite/remote_perm.c  |   2 +-
 drivers/staging/lustre/lustre/llite/rw.c           |   7 -
 drivers/staging/lustre/lustre/llite/rw26.c         |  15 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |  68 +++---
 drivers/staging/lustre/lustre/llite/super25.c      |   9 +-
 drivers/staging/lustre/lustre/llite/vvp_dev.c      |  10 +-
 drivers/staging/lustre/lustre/llite/vvp_internal.h |   2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   4 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |  35 ++-
 drivers/staging/lustre/lustre/llite/xattr.c        |   5 +
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |   4 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  25 +-
 drivers/staging/lustre/lustre/lov/Makefile         |   2 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c        |   6 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |  14 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  37 ++-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |  42 +---
 drivers/staging/lustre/lustre/lov/lov_log.c        | 272 ---------------------
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   6 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |  21 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   3 +-
 drivers/staging/lustre/lustre/lov/lov_offset.c     |   1 -
 drivers/staging/lustre/lustre/lov/lov_pack.c       |  10 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |   1 -
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |   2 +-
 drivers/staging/lustre/lustre/lov/lovsub_lock.c    |   2 +-
 drivers/staging/lustre/lustre/lov/lovsub_object.c  |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  23 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |  11 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  49 +++-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   8 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |  14 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c |   6 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |   4 +-
 drivers/staging/lustre/lustre/obdclass/debug.c     |  12 -
 drivers/staging/lustre/lustre/obdclass/genops.c    |   2 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |   9 +-
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |  29 +--
 .../staging/lustre/lustre/obdecho/echo_client.c    |   9 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |  16 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   4 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |   9 +
 drivers/staging/lustre/lustre/osc/osc_dev.c        |   4 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |  28 +--
 drivers/staging/lustre/lustre/osc/osc_lock.c       |   3 +-
 drivers/staging/lustre/lustre/osc/osc_object.c     |   2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |   1 -
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  50 +++-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |   2 +-
 drivers/staging/lustre/lustre/ptlrpc/gss/Makefile  |   3 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_bulk.c    |  12 +-
 .../lustre/lustre/ptlrpc/gss/gss_internal.h        |   7 +
 .../lustre/lustre/ptlrpc/gss/gss_krb5_mech.c       |   1 +
 .../lustre/lustre/ptlrpc/gss/gss_null_mech.c       | 195 +++++++++++++++
 .../staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c  |   4 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_sk_mech.c | 226 +++++++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c |  16 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |  36 ++-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |   2 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |   2 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |   1 +
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   2 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |   4 +
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |  32 ++-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |   6 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |  34 ++-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   4 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |  20 +-
 117 files changed, 1509 insertions(+), 1356 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/ioctl.h
 delete mode 100644 drivers/staging/lustre/lustre/include/obd_lov.h
 delete mode 100644 drivers/staging/lustre/lustre/lov/lov_log.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_null_mech.c
 create mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_sk_mech.c

-- 
1.8.5.3

