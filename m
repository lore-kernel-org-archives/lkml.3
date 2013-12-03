Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3LCOvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:51:12 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39552 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3LCOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:09 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 0/9] staging/lustre: minor cleanups and CONFIG_PROC_FS fix up
Date: Tue,  3 Dec 2013 22:41:57 +0800
Message-Id: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Patch 1-7 are small cleanup and fixup.
Patch 8 and 9 fix build errors when CONFIG_PROC_FS is off.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Peng Tao (9):
  staging/lustre/obdclass: fix false used uninitialized warning
  staging/lustre/obdclass: lprocfs_{alloc_stats,register} always defined
  staging/lustre/ldlm: inline ldlm_proc_setup
  staging/lustre/obdclass: move obd_sysctl_init out of class_procfs_init
  staging/lustre: fix defined not used warning
  staging/lustre/llite: fix used uninitialized warning
  staging/lustre/llite: remove ll_file_get_iov_count
  staging/lustre: fix undefined reference if CONFIG_PROC_FS is off
  staging/lustre: don't compile procfs code when CONFIG_PROC_FS is off

 drivers/staging/lustre/lnet/lnet/router_proc.c     |    4 -
 drivers/staging/lustre/lustre/fid/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    2 -
 drivers/staging/lustre/lustre/fld/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fld/fld_internal.h   |    1 -
 drivers/staging/lustre/lustre/fld/fld_request.c    |    2 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |    3 -
 .../staging/lustre/lustre/include/lprocfs_status.h |    8 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    3 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |   17 +-
 .../staging/lustre/lustre/include/obd_support.h    |    3 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    2 -
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |    9 +
 .../lustre/lustre/libcfs/linux/linux-proc.c        |    8 -
 drivers/staging/lustre/lustre/llite/Makefile       |    3 +-
 drivers/staging/lustre/lustre/llite/file.c         |   40 +--
 .../staging/lustre/lustre/llite/llite_internal.h   |   14 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    1 +
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    4 -
 drivers/staging/lustre/lustre/lmv/Makefile         |    4 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |    5 -
 drivers/staging/lustre/lustre/lov/Makefile         |    3 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |    2 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |    4 +-
 drivers/staging/lustre/lustre/lvfs/Makefile        |    3 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |    2 -
 drivers/staging/lustre/lustre/mdc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |    3 -
 drivers/staging/lustre/lustre/mgc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c      |    3 -
 drivers/staging/lustre/lustre/mgc/mgc_internal.h   |    2 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    2 +
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   20 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |    3 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |    5 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |    6 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |  348 ++++++++++----------
 drivers/staging/lustre/lustre/osc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    3 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    6 +
 41 files changed, 273 insertions(+), 292 deletions(-)

-- 
1.7.9.5

