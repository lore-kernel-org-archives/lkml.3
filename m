Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaCKFBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:01:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaCKFBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:01:39 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676436"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 00/15] A series patch for priority.
Date: Tue, 11 Mar 2014 12:59:15 +0800
Message-Id: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:50,
	Serialize complete at 2014/03/11 12:58:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	This patchset is all about priority. 

1. Add two macros in prio.h named NICE_TO_RLIMIT and RLIMIT_TO_NICE.
   They are converting the value between nice value [-20, 19] and 
   rlimit style value [1, 40].
2. Add a macro in ioprio.h named NICE_TO_IOPRIO.
   It convert nice value [-20, 19] to io priority [0, 7].
3. Others are all about replace hardcoding value about nice to MIN_NICE or MAX_NICE.

Dongsheng Yang (14):
  sched/prio: Add a macro named NICE_TO_RLIMIT in prio.h.
  workqueue: Replace hardcoding of -20 with MIN_NICE.
  locktorture: Replace hardcoding of 19 with MAX_NICE.
  tools/mq_perf_tests: Replace hardcoding of -20 with MIN_NICE.
  mm: Replace hardcoding of 19 with MAX_NICE.
  ioprio: Add a macro named NICE_TO_IOPRIO.
  fs/hearbeat: Replace hardcoding of -20 with MIN_NICE.
  driver/block: Replace hardcoding of -20 with MIN_NICE.
  driver/char: Replace hardcoding of 19 with MAX_NICE.
  drivers/s390: Replace hardcoding of 19 with MAX_NICE.
  driver/staging/android: Use RLIMIT_TO_NICE to replace opened code
    implementation.
  sched/prio: Add a macro named RLIMIT_TO_NICE in prio.h.
  driver/staging/lustre: Replace hardcoding of -20 with MIN_NICE.
  driver/scsi: Replace hardcoding of 20 with MIN_NICE.

Joe Perches (1):
  kernel/sys: Replace opened code implementation with NICE_TO_RLIMIT
    macro.

 drivers/block/loop.c                           |   2 +-
 drivers/block/nbd.c                            |   2 +-
 drivers/block/pktcdvd.c                        |   2 +-
 drivers/char/ipmi/ipmi_si_intf.c               |   2 +-
 drivers/s390/crypto/ap_bus.c                   |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c              |   4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                 |   2 +-
 drivers/scsi/fcoe/fcoe.c                       |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                 |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c               |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c               |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                  |   2 +-
 drivers/staging/android/binder.c               |   4 +-
 drivers/staging/lustre/lustre/llite/lloop.c    |   2 +-
 fs/ocfs2/cluster/heartbeat.c                   |   2 +-
 include/linux/ioprio.h                         |   7 +-
 include/linux/sched/prio.h                     |   6 +
 kernel/locking/locktorture.c                   |   2 +-
 kernel/sys.c                                   | 206 ++++++++++++-------------
 kernel/workqueue.c                             |   6 +-
 mm/huge_memory.c                               |   2 +-
 tools/testing/selftests/mqueue/mq_perf_tests.c |   4 +-
 22 files changed, 139 insertions(+), 128 deletions(-)

-- 
1.8.2.1

