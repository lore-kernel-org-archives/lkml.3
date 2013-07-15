Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3GONKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:10:46 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58565 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3GONKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:10:43 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 00/17] staging/lustre: fix various build issues
Date: Mon, 15 Jul 2013 21:07:58 +0800
Message-Id: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Now that 3.11-rc1 is out, please consider queuing following patches to
fix various Lustre client build issues. I've verified that we can now
pass build on sparc/mips/s390/powerpc/x86, both 32bits and 64bits.

V2 changelog:
Add patches to fix API changes in 3.11 merge window and address comments
on v1 patches. Lustre private watchdog is now removed.

Thanks,
Tao

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andreas Dilger <andreas.dilger@intel.com>

Peng Tao (16):
  staging/lustre: replace num_physpages with totalram_pages
  staging/lustre: fix Lustre code link order
  staging/lustre: don't assert module owner
  staging/lustre: don't assert ln_refcount in LNetGetId
  stating/lustre: only build if configured as module
  staging/lustre: remove HIPQUAD
  staging/lustre: fix build error when !CONFIG_SMP
  staging/lustre: fix build on s390
  staging/lustre/llite: add missing include file for prefetchw
  staging/lustre/llite: fix build erorr if CONFIG_FS_POSIX_ACL is off
  staging/lustre: fix build when CONFIG_UIDGID_STRICT_TYPE_CHECKS is on
  staging/lustre: fix build error on non-x86 platforms
  staging/lustre: fix build warnning on 32bit system
  staging/lustre/llite: fix for d_compare API change
  staging/lustre/llite: readdir convert to iterate
  staging/lustre: drop CONFIG_BROKEN

Stephen Rothwell (1):
  staging/lustre: fix for invalidatepage() API change

 drivers/staging/lustre/Makefile                    |    2 +-
 .../staging/lustre/include/linux/libcfs/curproc.h  |    2 -
 .../staging/lustre/include/linux/libcfs/libcfs.h   |   25 -
 .../lustre/include/linux/libcfs/libcfs_cpu.h       |   46 +-
 .../lustre/include/linux/libcfs/libcfs_private.h   |    1 -
 .../lustre/include/linux/libcfs/linux/linux-cpu.h  |    6 -
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |    4 +-
 .../include/linux/libcfs/linux/linux-tcpip.h       |   15 -
 drivers/staging/lustre/lnet/Makefile               |    2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   10 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   12 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   50 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   94 ++--
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |   60 +--
 drivers/staging/lustre/lnet/lnet/acceptor.c        |   62 +--
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    5 +-
 drivers/staging/lustre/lustre/Kconfig              |    2 +-
 drivers/staging/lustre/lustre/Makefile             |    4 +-
 .../lustre/include/linux/lustre_patchless_compat.h |    2 +-
 .../lustre/lustre/include/linux/lustre_user.h      |   18 +-
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    8 +-
 drivers/staging/lustre/lustre/include/linux/obd.h  |    5 +-
 .../staging/lustre/lustre/include/lprocfs_status.h |    4 +-
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    4 -
 drivers/staging/lustre/lustre/include/lustre_net.h |    7 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   10 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 +-
 drivers/staging/lustre/lustre/libcfs/Makefile      |    2 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |   46 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   16 -
 .../lustre/lustre/libcfs/linux/linux-debug.c       |   45 +-
 .../lustre/lustre/libcfs/linux/linux-module.c      |    2 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |    4 +-
 .../lustre/lustre/libcfs/linux/linux-tracefile.c   |    2 +-
 drivers/staging/lustre/lustre/libcfs/watchdog.c    |  516 --------------------
 drivers/staging/lustre/lustre/llite/dcache.c       |    5 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   55 +--
 .../staging/lustre/lustre/llite/llite_internal.h   |   28 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   13 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   13 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   11 +-
 drivers/staging/lustre/lustre/llite/namei.c        |    7 +-
 drivers/staging/lustre/lustre/llite/remote_perm.c  |   11 +-
 drivers/staging/lustre/lustre/llite/rw.c           |    2 +-
 drivers/staging/lustre/lustre/llite/rw26.c         |    5 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    8 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |    2 +
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   12 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   25 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |    8 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    9 +-
 drivers/staging/lustre/lustre/obdclass/idmap.c     |   12 +-
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |    4 +-
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |    6 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    2 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    5 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |   16 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |   12 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    2 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |    2 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   19 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   19 +-
 65 files changed, 393 insertions(+), 1023 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/watchdog.c

-- 
1.7.9.5

