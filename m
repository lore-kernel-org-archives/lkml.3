Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3GXIft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:35:49 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:31802 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855Ab3GXIfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:35:46 -0400
From: mail-agent-noreply@emc.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 0/8] staging/lustre: Intel tree sync and two fixups
Date: Wed, 24 Jul 2013 16:31:24 +0800
Message-Id: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

Hi Greg,

I've fixed up the rest of Intel tree ported patches and rebased them on top
of your staging-next. Also I found that the Lustre errno translate code breaks
build on non-x86 systems. I've added one patch to fix it. Please queue them if
they are OK to you.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

John L. Hammond (2):
  staging/lustre/llite: handle io init failure in ll_fault_io_init()
  staging/lustre/obdclass: use a dummy structure for lu_ref_link

Liu Xuezhao (1):
  staging/lustre/obdclass: add obd_target.h

Peng Tao (2):
  staging/lustre: fix Kconfig bool defaults
  staging/lustre: fix build on non-x86

Sebastien Buisson (2):
  staging/lustre: fix 'data race condition' issues in at_reset()
  staging/lustre/llite: fix 'data race condition' issues of lli_flags

Thomas Leibovici (1):
  staging/lustre/lmv: support DNE with HSM.

 drivers/staging/lustre/lustre/Kconfig              |    2 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |   10 +-
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |   10 -
 .../staging/lustre/lustre/include/lprocfs_status.h |   36 --
 drivers/staging/lustre/lustre/include/lu_object.h  |   18 +-
 drivers/staging/lustre/lustre/include/lu_ref.h     |   14 +-
 .../staging/lustre/lustre/include/lustre_import.h  |    2 +
 drivers/staging/lustre/lustre/include/obd.h        |  140 +-----
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    4 +
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |   36 +-
 drivers/staging/lustre/lustre/llite/namei.c        |    5 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  200 +++++++-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    1 -
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   18 +-
 drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   17 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    6 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |    5 +-
 .../lustre/lustre/obdclass/lprocfs_jobstats.c      |  560 --------------------
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   15 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    1 -
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    8 +-
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/errno.c       |    4 +-
 24 files changed, 301 insertions(+), 815 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c

