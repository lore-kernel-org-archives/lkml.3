Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaIISkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:40:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:15571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaIISkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570724853"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 0/7] staging/lustre: remove the lvfs layer
Date: Tue, 9 Sep 2014 13:39:01 -0500
Message-ID: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Howdy,

This series removes the lvfs module, its headers, the headers that it
headers included but were not needed, and some adjacent compatability
code.

James Simmons (2):
  staging/lustre/lvfs: remove the lvfs layer
  staging/lustre: remove portals_compat25.h

John L. Hammond (5):
  staging/lustre: remove linux/lustre_common.h
  staging/lustre: remove lvfs_linux.h
  staging/lustre: remove unused lvfs code
  staging/lustre/libcfs: remove upcall cache
  staging/lustre: remove lvfs.h

 .../lustre/include/linux/libcfs/libcfs_fail.h      |    4 +-
 .../lustre/include/linux/libcfs/linux/libcfs.h     |    1 -
 .../lustre/include/linux/libcfs/linux/linux-time.h |    2 -
 .../include/linux/libcfs/linux/portals_compat25.h  |   81 ----
 .../staging/lustre/include/linux/libcfs/lucache.h  |  162 -------
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    4 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  |    1 -
 drivers/staging/lustre/lustre/Makefile             |    2 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |    2 +-
 .../lustre/lustre/include/linux/lustre_common.h    |   22 -
 .../lustre/lustre/include/linux/lustre_compat25.h  |    1 -
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |  172 --------
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 -
 drivers/staging/lustre/lustre/include/linux/lvfs.h |  134 ------
 .../lustre/lustre/include/linux/lvfs_linux.h       |   61 ---
 .../staging/lustre/lustre/include/lustre_fsfilt.h  |   48 ---
 drivers/staging/lustre/lustre/include/lustre_lib.h |    1 -
 drivers/staging/lustre/lustre/include/lvfs.h       |   57 ---
 drivers/staging/lustre/lustre/include/obd.h        |    5 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |   10 -
 .../staging/lustre/lustre/include/obd_support.h    |    2 +-
 drivers/staging/lustre/lustre/libcfs/Makefile      |    2 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |    3 +-
 .../lustre/lustre/libcfs/linux/linux-debug.c       |    5 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   20 +-
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |  455 --------------------
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    4 +-
 drivers/staging/lustre/lustre/llite/file.c         |    2 +-
 drivers/staging/lustre/lustre/lvfs/Makefile        |    4 -
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |  139 ------
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |  170 --------
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |  297 -------------
 drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +
 .../lustre/lustre/obdclass/lprocfs_counters.c      |  139 ++++++
 .../lustre/lustre/obdclass/lprocfs_status.c        |   79 ++++
 .../staging/lustre/lustre/obdclass/obd_config.c    |    2 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    2 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/llog_net.c    |    2 -
 40 files changed, 251 insertions(+), 1853 deletions(-)
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/portals_compat25.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/lucache.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_common.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_fsfilt.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lvfs.h
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/upcall_cache.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/Makefile
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_counters.c

-- 
1.7.9.5

