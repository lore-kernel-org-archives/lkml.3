Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3KUObk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:31:40 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41258 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3KUObj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:31:39 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/10] staging/lustre/libcfs: cleanup linux-fs.h and kp30.h
Date: Thu, 21 Nov 2013 22:28:21 +0800
Message-Id: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Andreas,

Following patches remove linux-fs.h and clean up kp30.h a bit.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Peng Tao (10):
  staging/lustre/libcfs: remove filp_size/filp_poff
  staging/lustre/libcfs: remove filp_fsync
  staging/lustre/libcfs: remove filp_read
  staging/lustre/libcfs: remove filp_write
  staging/lustre: move IFTODT/DTTOIF to lustre_idl.h
  staging/lustre/libcfs: remove flock wrappers
  staging/lustre/libcfs: remove linux-fs.h
  staging/lustre/libcfs: remove lwt code
  staging/lustre: remove CFS_MODULE_PARM
  staging/lustre/libcfs: remove LI_POISON

 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |    3 -
 .../lustre/include/linux/libcfs/linux/kp30.h       |  113 ---------
 .../lustre/include/linux/libcfs/linux/libcfs.h     |    1 -
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |   92 -------
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |   96 +++----
 .../lustre/lnet/klnds/socklnd/socklnd_modparams.c  |  112 ++++-----
 drivers/staging/lustre/lnet/lnet/acceptor.c        |   16 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |   16 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |    4 +-
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |    4 +-
 drivers/staging/lustre/lnet/lnet/module.c          |    4 +-
 drivers/staging/lustre/lnet/lnet/router.c          |   44 ++--
 drivers/staging/lustre/lnet/selftest/brw_test.c    |    7 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |    8 +-
 drivers/staging/lustre/lnet/selftest/ping_test.c   |    3 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   12 +
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   17 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    8 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    4 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |   42 ++--
 drivers/staging/lustre/lustre/libcfs/hash.c        |    4 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |    6 +-
 drivers/staging/lustre/lustre/libcfs/lwt.c         |  266 --------------------
 drivers/staging/lustre/lustre/libcfs/module.c      |   53 +---
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |   22 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |    3 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    4 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |    3 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |    8 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   26 +-
 31 files changed, 253 insertions(+), 752 deletions(-)
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/lwt.c

-- 
1.7.9.5

