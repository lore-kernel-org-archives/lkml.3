Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaCACRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:09 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42555 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaCACRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:07 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 00/17] Lustre stability patches
Date: Fri, 28 Feb 2014 21:16:29 -0500
Message-Id: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes most of the issues I hit during
Lustre regression test suite. All observed crashes are gone too.

Please consider for inclusion.

Alexey Lyashkov (1):
  lustre/mdc: use ibits_known mask for lock match

Ann Koehler (1):
  lustre/osc: Don't flush active extents.

Bruno Faccini (1):
  lustre/ldlm: set l_lvb_type coherent when layout is returned

Hongchao Zhang (1):
  lustre/recovery: free open/close request promptly

John L. Hammond (3):
  staging/lustre/llite: fix open lock matching in ll_md_blocking_ast()
  lustre/clio: honor O_NOATIME
  lustre/mdc: fix bad ERR_PTR usage in mdc_locks.c

Lai Siyao (1):
  lustre/llite: simplify dentry revalidate

Liang Zhen (2):
  lustre/ptlrpc: rq_commit_cb is called for twice
  lustre/ptlrpc: re-enqueue ptlrpcd worker

Niu Yawei (1):
  lustre/quota: improper assert in osc_quota_chkdq()

Oleg Drokin (3):
  lustre/mdc: Check for all attributes validity in revalidate
  lustre/llite: Do not send parent dir fid in getattr by fid
  lustre/libcfs: warn if all HTs in a core are gone

Peng Tao (1):
  lustre/ptlrpc: skip rpcs that fail ptl_send_rpc

Sebastien Buisson (1):
  lustre/ptlrpc: fix 'data race condition' issues

wang di (1):
  lustre/mdc: comments on LOOKUP and PERM lock

 drivers/staging/lustre/lustre/include/cl_object.h  |   6 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |  32 ++-
 .../staging/lustre/lustre/include/lustre_export.h  |  17 ++
 .../staging/lustre/lustre/include/lustre_import.h  |  11 +
 drivers/staging/lustre/lustre/include/lustre_net.h |   2 +
 drivers/staging/lustre/lustre/include/obd.h        |   5 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |   4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |   1 +
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |  19 +-
 drivers/staging/lustre/lustre/llite/dcache.c       | 290 ++-------------------
 drivers/staging/lustre/lustre/llite/dir.c          |   2 +-
 drivers/staging/lustre/lustre/llite/file.c         |  60 +++--
 .../staging/lustre/lustre/llite/llite_internal.h   |   6 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   3 +-
 drivers/staging/lustre/lustre/llite/namei.c        |  78 +++---
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |   1 -
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   5 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |   1 +
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      | 102 ++++----
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |   1 +
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  27 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |   2 +
 .../lustre/lustre/obdclass/lprocfs_status.c        |   1 +
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   6 +
 drivers/staging/lustre/lustre/osc/osc_io.c         |  14 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |   7 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      | 155 ++++++++---
 drivers/staging/lustre/lustre/ptlrpc/import.c      |  33 ++-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   4 +
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |  57 +++-
 31 files changed, 480 insertions(+), 474 deletions(-)

-- 
1.8.5.3

