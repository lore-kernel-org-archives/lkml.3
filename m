Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaCKKTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:19:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaCKKLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:25 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678273"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 00/17 for-tip V3] A series patches about sched priority.
Date: Tue, 11 Mar 2014 18:09:08 +0800
Message-Id: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:35,
	Serialize complete at 2014/03/11 18:08:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	This patchset is all about priority. 

1. Add two inline functions in prio.h named nice_to_rlimit and rlimit_to_nice.
   They are converting the value between nice value [-20, 19] and 
   rlimit style value [1, 40].
2. Add a macro in ioprio.h named NICE_TO_IOPRIO.
   It convert nice value [-20, 19] to io priority [0, 7].
3. Others are all about replace hardcoding value about nice to MIN_NICE or MAX_NICE.

Changelog:
	-v2:
	  *Splite [2/16] into two patches, one is about the whitespace changes, and
	   the other is about nice_to_rlimit().
	-v1:
	  *Implement nice_to_rlimit and rlimit_to_nice with inline functions
	   rather than macro.
	  *Add a patch[16/16] to replace opened code implement with nice_to_rlimit().

Dongsheng Yang (16):
  sched/prio: Add a inline function named nice_to_rlimit() in prio.h.
  kernel/sys: Replace opened code implementation with nice_to_rlimit().
  workqueue: Replace hardcoding of -20 with MIN_NICE.
  locktorture: Replace hardcoding of 19 with MAX_NICE.
  tools/mq_perf_tests: Replace hardcoding of -20 with MIN_NICE.
  mm: Replace hardcoding of 19 with MAX_NICE.
  ioprio: Add a macro named NICE_TO_IOPRIO.
  fs/hearbeat: Replace hardcoding of -20 with MIN_NICE.
  driver/block: Replace hardcoding of -20 with MIN_NICE.
  driver/char: Replace hardcoding of 19 with MAX_NICE.
  drivers/s390: Replace hardcoding of 19 with MAX_NICE.
  sched/prio: Add an inline function named rlimit_to_nice in prio.h.
  driver/staging/android: Use rlimit_to_nice to replace opened code
    implementation.
  driver/staging/lustre: Replace hardcoding of -20 with MIN_NICE.
  driver/scsi: Replace hardcoding of -20 with MIN_NICE.
  sched: Get rid of opened code implementation of funtion
    nice_to_rlimit().

Joe Perches (1):
  kernel/sys: Fix the indent issue in switch.

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
 include/linux/sched/prio.h                     |  16 ++
 kernel/locking/locktorture.c                   |   2 +-
 kernel/sched/core.c                            |   2 +-
 kernel/sys.c                                   | 206 ++++++++++++-------------
 kernel/workqueue.c                             |   6 +-
 mm/huge_memory.c                               |   2 +-
 tools/testing/selftests/mqueue/mq_perf_tests.c |   4 +-
 23 files changed, 150 insertions(+), 129 deletions(-)

-- 
1.8.2.1

