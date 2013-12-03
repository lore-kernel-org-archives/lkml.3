Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3LCR5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:57:23 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47190 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3LCR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:57:19 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 0/4] staging/lustre: fix build and remove ll_file_get_iov_count
Date: Wed,  4 Dec 2013 01:54:55 +0800
Message-Id: <1386093299-8837-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Patch 1 is added because there is a newly introduced (7fc1f83) error
when CONFIG_FS_POSIX_ACL is off.
Patch 2 is updated to fix build errors in itself.

Please see if they can be merged. Thanks and sorry for the noise.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Peng Tao (4):
  staging/lustre: fix build error in ll_setxattr_common
  staging/lustre/llite: remove ll_file_get_iov_count
  staging/lustre: fix undefined reference if CONFIG_PROC_FS is off
  staging/lustre: don't compile procfs code when CONFIG_PROC_FS is off

 drivers/staging/lustre/lustre/fid/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    2 -
 drivers/staging/lustre/lustre/fld/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fld/fld_internal.h   |    1 -
 drivers/staging/lustre/lustre/fld/fld_request.c    |    2 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |    3 -
 .../staging/lustre/lustre/include/lprocfs_status.h |    8 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |   17 +-
 .../staging/lustre/lustre/include/obd_support.h    |    3 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |    9 +
 drivers/staging/lustre/lustre/llite/Makefile       |    3 +-
 drivers/staging/lustre/lustre/llite/file.c         |   36 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   14 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    1 +
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    4 -
 drivers/staging/lustre/lustre/llite/xattr.c        |    2 +-
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
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   13 +
 .../lustre/lustre/obdclass/linux/linux-module.c    |    4 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |    4 +
 .../lustre/lustre/obdclass/lprocfs_status.c        |  348 ++++++++++----------
 drivers/staging/lustre/lustre/osc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    3 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    6 +
 37 files changed, 263 insertions(+), 270 deletions(-)

-- 
1.7.9.5

