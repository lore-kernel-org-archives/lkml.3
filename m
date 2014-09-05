Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaIEUIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:08:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:57737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaIEUIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:08:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="475552590"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 00/12] staging/lustre: yet more dead code removal
Date: Fri, 5 Sep 2014 15:08:06 -0500
Message-ID: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Howdy,

This series yet removes more dead and obsolete code from drivers/staging/lustre
in the form of methods from struct obd_ops and server specific llog handling.

John L. Hammond (12):
  staging/lustre/lov: remove unused OBD methods
  staging/lustre/osc: remove unused OBD methods
  staging/lustre/osc: remove obsolete llog handling code
  staging/lustre: remove obd_ost.h
  staging/lustre/mdc: remove unused OBD methods
  staging/lustre/mdc: inline llog methods
  staging/lustre/mgc: inline mgc_cancel()
  staging/lustre: remove unused OBD methods
  staging/lustre/mgc: remove server specific llog handling
  staging/lustre/ptlrpc: remove sptlrpc_conf_target_get_rules()
  staging/lustre/obdclass: remove llog_ioctl.c
  staging/lustre/obdclass: remove local_storage.[ch]

 .../staging/lustre/lustre/include/lustre_lite.h    |    1 -
 drivers/staging/lustre/lustre/include/lustre_log.h |   10 -
 drivers/staging/lustre/lustre/include/lustre_sec.h |    3 -
 drivers/staging/lustre/lustre/include/obd.h        |   47 -
 drivers/staging/lustre/lustre/include/obd_class.h  |  279 ------
 drivers/staging/lustre/lustre/include/obd_ost.h    |  100 ---
 drivers/staging/lustre/lustre/lov/lov_internal.h   |   45 -
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   27 -
 drivers/staging/lustre/lustre/lov/lov_obd.c        |  531 ------------
 drivers/staging/lustre/lustre/lov/lov_pack.c       |  172 ----
 drivers/staging/lustre/lustre/lov/lov_request.c    |  784 -----------------
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  157 +---
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  101 +--
 drivers/staging/lustre/lustre/obdclass/Makefile    |    4 +-
 drivers/staging/lustre/lustre/obdclass/debug.c     |    1 -
 drivers/staging/lustre/lustre/obdclass/genops.c    |    1 -
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |  418 ---------
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |   25 -
 .../staging/lustre/lustre/obdclass/local_storage.c |  894 --------------------
 .../staging/lustre/lustre/obdclass/local_storage.h |   91 --
 .../lustre/lustre/obdclass/lprocfs_status.c        |   20 -
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |    1 -
 drivers/staging/lustre/lustre/osc/osc_quota.c      |    2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  401 +--------
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |    1 -
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |  327 -------
 26 files changed, 82 insertions(+), 4361 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/obd_ost.h
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/local_storage.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/local_storage.h

-- 
1.7.9.5

