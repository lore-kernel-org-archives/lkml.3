Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbaGWCgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:36:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:44527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbaGWCgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:36:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="547517010"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 42/70] xfs, xfs_mount: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:18 -0400
Message-Id: <1406080786-3938-43-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from xfs/xfs_mount.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 fs/xfs/xfs_mount.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3507cd0..b701946 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1531,15 +1531,13 @@ xfs_icsb_cpu_notify(
 	mp = (xfs_mount_t *)container_of(nfb, xfs_mount_t, m_icsb_notifier);
 	cntp = (xfs_icsb_cnts_t *)
 			per_cpu_ptr(mp->m_sb_cnts, (unsigned long)hcpu);
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		/* Easy Case - initialize the area and locks, and
 		 * then rebalance when online does everything else for us. */
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
 		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
@@ -1547,7 +1545,6 @@ xfs_icsb_cpu_notify(
 		xfs_icsb_unlock(mp);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		/* Disable all the counters, then fold the dead cpu's
 		 * count into the total on the global superblock and
 		 * re-enable the counters. */
-- 
2.0.0.rc2

