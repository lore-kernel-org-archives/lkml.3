Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3JUPV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:21:57 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33864 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3JUPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:21:53 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 3/4] staging/lustre: fix tv_usec build warning on parisc
Date: Mon, 21 Oct 2013 23:18:24 +0800
Message-Id: <1382368705-4199-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382368705-4199-1-git-send-email-bergwolf@gmail.com>
References: <1382368705-4199-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Fengguang:

config: make ARCH=parisc allyesconfig

All warnings:

   drivers/staging/lustre/lustre/llite/lproc_llite.c: In function 'll_rw_extents_stats_pp_seq_show':
>> drivers/staging/lustre/lustre/llite/lproc_llite.c:1069:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]
   drivers/staging/lustre/lustre/llite/lproc_llite.c: In function 'll_rw_extents_stats_seq_show':
>> drivers/staging/lustre/lustre/llite/lproc_llite.c:1133:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]
   drivers/staging/lustre/lustre/llite/lproc_llite.c: In function 'll_rw_offset_stats_seq_show':
>> drivers/staging/lustre/lustre/llite/lproc_llite.c:1299:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]
--
   drivers/staging/lustre/lustre/obdclass/lprocfs_status.c: In function 'lprocfs_stats_seq_show':
>> drivers/staging/lustre/lustre/obdclass/lprocfs_status.c:1070:5: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type '__kernel_suseconds_t' [-Wformat]
--
   drivers/staging/lustre/lustre/osc/lproc_osc.c: In function 'osc_rpc_stats_seq_show':
>> drivers/staging/lustre/lustre/osc/lproc_osc.c:575:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]
   drivers/staging/lustre/lustre/osc/lproc_osc.c: In function 'osc_stats_seq_show':
>> drivers/staging/lustre/lustre/osc/lproc_osc.c:687:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    6 +++---
 .../lustre/lustre/obdclass/lprocfs_status.c        |    2 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index d4d3c17..4bf09c4 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -1063,7 +1063,7 @@ static int ll_rw_extents_stats_pp_seq_show(struct seq_file *seq, void *v)
 		return 0;
 	}
 	seq_printf(seq, "snapshot_time:	 %lu.%lu (secs.usecs)\n",
-		   now.tv_sec, now.tv_usec);
+		   now.tv_sec, (unsigned long)now.tv_usec);
 	seq_printf(seq, "%15s %19s       | %20s\n", " ", "read", "write");
 	seq_printf(seq, "%13s   %14s %4s %4s  | %14s %4s %4s\n",
 		   "extents", "calls", "%", "cum%",
@@ -1127,7 +1127,7 @@ static int ll_rw_extents_stats_seq_show(struct seq_file *seq, void *v)
 		return 0;
 	}
 	seq_printf(seq, "snapshot_time:	 %lu.%lu (secs.usecs)\n",
-		   now.tv_sec, now.tv_usec);
+		   now.tv_sec, (unsigned long)now.tv_usec);
 
 	seq_printf(seq, "%15s %19s       | %20s\n", " ", "read", "write");
 	seq_printf(seq, "%13s   %14s %4s %4s  | %14s %4s %4s\n",
@@ -1293,7 +1293,7 @@ static int ll_rw_offset_stats_seq_show(struct seq_file *seq, void *v)
 	spin_lock(&sbi->ll_process_lock);
 
 	seq_printf(seq, "snapshot_time:	 %lu.%lu (secs.usecs)\n",
-		   now.tv_sec, now.tv_usec);
+		   now.tv_sec, (unsigned long)now.tv_usec);
 	seq_printf(seq, "%3s %10s %14s %14s %17s %17s %14s\n",
 		   "R/W", "PID", "RANGE START", "RANGE END",
 		   "SMALLEST EXTENT", "LARGEST EXTENT", "OFFSET");
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index a95f60a..76352c0 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1069,7 +1069,7 @@ static int lprocfs_stats_seq_show(struct seq_file *p, void *v)
 		struct timeval now;
 		do_gettimeofday(&now);
 		rc = seq_printf(p, "%-25s %lu.%lu secs.usecs\n",
-				"snapshot_time", now.tv_sec, now.tv_usec);
+				"snapshot_time", now.tv_sec, (unsigned long)now.tv_usec);
 		if (rc < 0)
 			return rc;
 	}
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 90d24d8..ef10e2a 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -571,7 +571,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 	client_obd_list_lock(&cli->cl_loi_list_lock);
 
 	seq_printf(seq, "snapshot_time:	 %lu.%lu (secs.usecs)\n",
-		   now.tv_sec, now.tv_usec);
+		   now.tv_sec, (unsigned long)now.tv_usec);
 	seq_printf(seq, "read RPCs in flight:  %d\n",
 		   cli->cl_r_in_flight);
 	seq_printf(seq, "write RPCs in flight: %d\n",
@@ -683,7 +683,7 @@ static int osc_stats_seq_show(struct seq_file *seq, void *v)
 	do_gettimeofday(&now);
 
 	seq_printf(seq, "snapshot_time:	 %lu.%lu (secs.usecs)\n",
-		   now.tv_sec, now.tv_usec);
+		   now.tv_sec, (unsigned long)now.tv_usec);
 	seq_printf(seq, "lockless_write_bytes\t\t"LPU64"\n",
 		   stats->os_lockless_writes);
 	seq_printf(seq, "lockless_read_bytes\t\t"LPU64"\n",
-- 
1.7.9.5

