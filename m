Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaCRNGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:06:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53160 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaCRNGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:06:48 -0400
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 0/5] staging/lustre/libcfs: clean up wait queue related wrappers
Date: Tue, 18 Mar 2014 21:05:51 +0800
Message-Id: <1395147956-2056-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Following patches remove wait queue related wrappers from lustre. The only thing
left is add_wait_queue_exclusive_head() that we hope to make into generic
helpers in a separate patch.

Thanks,
	Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>

Peng Tao (5):
  staging/lustre/libcfs: remove init_waitqueue_entry_current
  staging/lustre/libcfs: remove waitq_wait
  staging/lustre/libcfs: remove waitq_timedwait
  staging/lustre/libcfs: remove schedule_timeout_and_set_state
  staging/lustre/libcfs: remove cfs_pause

 .../lustre/include/linux/libcfs/libcfs_prim.h      |    9 -----
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    6 ++-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   10 +++---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    6 ++-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   15 ++++----
 drivers/staging/lustre/lnet/lnet/acceptor.c        |    3 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    3 +-
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |    7 ++--
 drivers/staging/lustre/lnet/lnet/peer.c            |    3 +-
 drivers/staging/lustre/lnet/lnet/router.c          |   12 ++++---
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    3 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |    3 +-
 drivers/staging/lustre/lnet/selftest/selftest.h    |    6 +++-
 drivers/staging/lustre/lustre/fid/fid_request.c    |   10 +++---
 drivers/staging/lustre/lustre/include/linux/obd.h  |    3 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |    8 ++---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    4 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |    4 +-
 drivers/staging/lustre/lustre/libcfs/fail.c        |    4 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   38 --------------------
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    5 +--
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |    5 +--
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    6 ++-
 drivers/staging/lustre/lustre/lov/lov_object.c     |    4 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    4 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |    4 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    4 +-
 drivers/staging/lustre/lustre/obdecho/echo.c       |    3 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |    4 +-
 .../lustre/lustre/ptlrpc/gss/gss_svc_upcall.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    4 +-
 33 files changed, 89 insertions(+), 121 deletions(-)

-- 
1.7.7.6

