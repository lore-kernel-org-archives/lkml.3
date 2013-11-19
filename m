Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3KSOnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:43:49 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56253 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3KSOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:58 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 12/13] staging/lustre: remove INIT_CTL_NAME
Date: Tue, 19 Nov 2013 22:38:46 +0800
Message-Id: <1384871927-8553-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

legacy code used to support kernel where struct ctl_table
has ctl_name member.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |    1 -
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   10 --------
 .../lustre/lustre/libcfs/linux/linux-proc.c        |   25 +-------------------
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   23 ++----------------
 4 files changed, 3 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index e6f03c7..ba78541 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -206,7 +206,6 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
 
 /* compat macroses */
 
-#define INIT_CTL_NAME(a)
 #define INIT_STRATEGY(a)
 
 #endif
diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index 5e47de3..daaa043 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -855,55 +855,46 @@ static ctl_table_t lnet_table[] = {
 	 * to go via /proc for portability.
 	 */
 	{
-		INIT_CTL_NAME(PSDEV_LNET_STATS)
 		.procname = "stats",
 		.mode     = 0644,
 		.proc_handler = &proc_lnet_stats,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_ROUTES)
 		.procname = "routes",
 		.mode     = 0444,
 		.proc_handler = &proc_lnet_routes,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_ROUTERS)
 		.procname = "routers",
 		.mode     = 0444,
 		.proc_handler = &proc_lnet_routers,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_PEERS)
 		.procname = "peers",
 		.mode     = 0444,
 		.proc_handler = &proc_lnet_peers,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_PEERS)
 		.procname = "buffers",
 		.mode     = 0444,
 		.proc_handler = &proc_lnet_buffers,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_NIS)
 		.procname = "nis",
 		.mode     = 0444,
 		.proc_handler = &proc_lnet_nis,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_PTL_ROTOR)
 		.procname = "portal_rotor",
 		.mode     = 0644,
 		.proc_handler = &proc_lnet_portal_rotor,
 	},
 	{
-		INIT_CTL_NAME(0)
 	}
 };
 
 static ctl_table_t top_table[] = {
 	{
-		INIT_CTL_NAME(CTL_LNET)
 		.procname = "lnet",
 		.mode     = 0555,
 		.data     = NULL,
@@ -911,7 +902,6 @@ static ctl_table_t top_table[] = {
 		.child    = lnet_table,
 	},
 	{
-		INIT_CTL_NAME(0)
 	}
 };
 
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
index fc6c977..f2bb8672 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
@@ -371,7 +371,6 @@ static ctl_table_t lnet_table[] = {
 	 * to go via /proc for portability.
 	 */
 	{
-		INIT_CTL_NAME(PSDEV_DEBUG)
 		.procname = "debug",
 		.data     = &libcfs_debug,
 		.maxlen   = sizeof(int),
@@ -379,7 +378,6 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_dobitmasks,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_SUBSYSTEM_DEBUG)
 		.procname = "subsystem_debug",
 		.data     = &libcfs_subsystem_debug,
 		.maxlen   = sizeof(int),
@@ -387,7 +385,6 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_dobitmasks,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_PRINTK)
 		.procname = "printk",
 		.data     = &libcfs_printk,
 		.maxlen   = sizeof(int),
@@ -395,7 +392,6 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_dobitmasks,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_CONSOLE_RATELIMIT)
 		.procname = "console_ratelimit",
 		.data     = &libcfs_console_ratelimit,
 		.maxlen   = sizeof(int),
@@ -403,21 +399,18 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_dointvec
 	},
 	{
-		INIT_CTL_NAME(PSDEV_CONSOLE_MAX_DELAY_CS)
 		.procname = "console_max_delay_centisecs",
 		.maxlen   = sizeof(int),
 		.mode     = 0644,
 		.proc_handler = &proc_console_max_delay_cs
 	},
 	{
-		INIT_CTL_NAME(PSDEV_CONSOLE_MIN_DELAY_CS)
 		.procname = "console_min_delay_centisecs",
 		.maxlen   = sizeof(int),
 		.mode     = 0644,
 		.proc_handler = &proc_console_min_delay_cs
 	},
 	{
-		INIT_CTL_NAME(PSDEV_CONSOLE_BACKOFF)
 		.procname = "console_backoff",
 		.maxlen   = sizeof(int),
 		.mode     = 0644,
@@ -425,7 +418,6 @@ static ctl_table_t lnet_table[] = {
 	},
 
 	{
-		INIT_CTL_NAME(PSDEV_DEBUG_PATH)
 		.procname = "debug_path",
 		.data     = libcfs_debug_file_path_arr,
 		.maxlen   = sizeof(libcfs_debug_file_path_arr),
@@ -434,7 +426,6 @@ static ctl_table_t lnet_table[] = {
 	},
 
 	{
-		INIT_CTL_NAME(PSDEV_CPT_TABLE)
 		.procname = "cpu_partition_table",
 		.maxlen   = 128,
 		.mode     = 0444,
@@ -442,7 +433,6 @@ static ctl_table_t lnet_table[] = {
 	},
 
 	{
-		INIT_CTL_NAME(PSDEV_LNET_UPCALL)
 		.procname = "upcall",
 		.data     = lnet_upcall,
 		.maxlen   = sizeof(lnet_upcall),
@@ -450,7 +440,6 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_dostring,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_DEBUG_LOG_UPCALL)
 		.procname = "debug_log_upcall",
 		.data     = lnet_debug_log_upcall,
 		.maxlen   = sizeof(lnet_debug_log_upcall),
@@ -458,7 +447,6 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_dostring,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_MEMUSED)
 		.procname = "lnet_memused",
 		.data     = (int *)&libcfs_kmemory.counter,
 		.maxlen   = sizeof(int),
@@ -467,7 +455,6 @@ static ctl_table_t lnet_table[] = {
 		INIT_STRATEGY(&sysctl_intvec)
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_CATASTROPHE)
 		.procname = "catastrophe",
 		.data     = &libcfs_catastrophe,
 		.maxlen   = sizeof(int),
@@ -476,7 +463,6 @@ static ctl_table_t lnet_table[] = {
 		INIT_STRATEGY(&sysctl_intvec)
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_PANIC_ON_LBUG)
 		.procname = "panic_on_lbug",
 		.data     = &libcfs_panic_on_lbug,
 		.maxlen   = sizeof(int),
@@ -485,27 +471,23 @@ static ctl_table_t lnet_table[] = {
 		INIT_STRATEGY(&sysctl_intvec)
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_DUMP_KERNEL)
 		.procname = "dump_kernel",
 		.maxlen   = 256,
 		.mode     = 0200,
 		.proc_handler = &proc_dump_kernel,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_DAEMON_FILE)
 		.procname = "daemon_file",
 		.mode     = 0644,
 		.maxlen   = 256,
 		.proc_handler = &proc_daemon_file,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_DEBUG_MB)
 		.procname = "debug_mb",
 		.mode     = 0644,
 		.proc_handler = &proc_debug_mb,
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_WATCHDOG_RATELIMIT)
 		.procname = "watchdog_ratelimit",
 		.data     = &libcfs_watchdog_ratelimit,
 		.maxlen   = sizeof(int),
@@ -514,7 +496,7 @@ static ctl_table_t lnet_table[] = {
 		.extra1   = &min_watchdog_ratelimit,
 		.extra2   = &max_watchdog_ratelimit,
 	},
-	{       INIT_CTL_NAME(PSDEV_LNET_FORCE_LBUG)
+	{
 		.procname = "force_lbug",
 		.data     = NULL,
 		.maxlen   = 0,
@@ -522,7 +504,6 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &libcfs_force_lbug
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_FAIL_LOC)
 		.procname = "fail_loc",
 		.data     = &cfs_fail_loc,
 		.maxlen   = sizeof(cfs_fail_loc),
@@ -530,7 +511,6 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_fail_loc
 	},
 	{
-		INIT_CTL_NAME(PSDEV_LNET_FAIL_VAL)
 		.procname = "fail_val",
 		.data     = &cfs_fail_val,
 		.maxlen   = sizeof(int),
@@ -538,14 +518,12 @@ static ctl_table_t lnet_table[] = {
 		.proc_handler = &proc_dointvec
 	},
 	{
-		INIT_CTL_NAME(0)
 	}
 };
 
 #ifdef CONFIG_SYSCTL
 static ctl_table_t top_table[] = {
 	{
-		INIT_CTL_NAME(CTL_LNET)
 		.procname = "lnet",
 		.mode     = 0555,
 		.data     = NULL,
@@ -553,7 +531,6 @@ static ctl_table_t top_table[] = {
 		.child    = lnet_table,
 	},
 	{
-		INIT_CTL_NAME(0)
 	}
 };
 #endif
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index acd2619..d66be02 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -282,7 +282,6 @@ int LL_PROC_PROTO(proc_at_history)
 #ifdef CONFIG_SYSCTL
 static ctl_table_t obd_table[] = {
 	{
-		INIT_CTL_NAME(OBD_TIMEOUT)
 		.procname = "timeout",
 		.data     = &obd_timeout,
 		.maxlen   = sizeof(int),
@@ -290,7 +289,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_set_timeout
 	},
 	{
-		INIT_CTL_NAME(OBD_DEBUG_PEER_ON_TIMEOUT)
 		.procname = "debug_peer_on_timeout",
 		.data     = &obd_debug_peer_on_timeout,
 		.maxlen   = sizeof(int),
@@ -298,7 +296,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_dointvec
 	},
 	{
-		INIT_CTL_NAME(OBD_DUMP_ON_TIMEOUT)
 		.procname = "dump_on_timeout",
 		.data     = &obd_dump_on_timeout,
 		.maxlen   = sizeof(int),
@@ -306,7 +303,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_dointvec
 	},
 	{
-		INIT_CTL_NAME(OBD_DUMP_ON_EVICTION)
 		.procname = "dump_on_eviction",
 		.data     = &obd_dump_on_eviction,
 		.maxlen   = sizeof(int),
@@ -314,7 +310,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_dointvec
 	},
 	{
-		INIT_CTL_NAME(OBD_MEMUSED)
 		.procname = "memused",
 		.data     = NULL,
 		.maxlen   = 0,
@@ -322,7 +317,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_memory_alloc
 	},
 	{
-		INIT_CTL_NAME(OBD_PAGESUSED)
 		.procname = "pagesused",
 		.data     = NULL,
 		.maxlen   = 0,
@@ -330,7 +324,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_pages_alloc
 	},
 	{
-		INIT_CTL_NAME(OBD_MAXMEMUSED)
 		.procname = "memused_max",
 		.data     = NULL,
 		.maxlen   = 0,
@@ -338,7 +331,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_mem_max
 	},
 	{
-		INIT_CTL_NAME(OBD_MAXPAGESUSED)
 		.procname = "pagesused_max",
 		.data     = NULL,
 		.maxlen   = 0,
@@ -346,7 +338,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_pages_max
 	},
 	{
-		INIT_CTL_NAME(OBD_LDLM_TIMEOUT)
 		.procname = "ldlm_timeout",
 		.data     = &ldlm_timeout,
 		.maxlen   = sizeof(int),
@@ -354,7 +345,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_set_timeout
 	},
 	{
-		INIT_CTL_NAME(OBD_ALLOC_FAIL_RATE)
 		.procname = "alloc_fail_rate",
 		.data     = &obd_alloc_fail_rate,
 		.maxlen   = sizeof(int),
@@ -362,7 +352,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_alloc_fail_rate
 	},
 	{
-		INIT_CTL_NAME(OBD_MAX_DIRTY_PAGES)
 		.procname = "max_dirty_mb",
 		.data     = &obd_max_dirty_pages,
 		.maxlen   = sizeof(int),
@@ -370,7 +359,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_max_dirty_pages_in_mb
 	},
 	{
-		INIT_CTL_NAME(OBD_AT_MIN)
 		.procname = "at_min",
 		.data     = &at_min,
 		.maxlen   = sizeof(int),
@@ -378,7 +366,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_at_min
 	},
 	{
-		INIT_CTL_NAME(OBD_AT_MAX)
 		.procname = "at_max",
 		.data     = &at_max,
 		.maxlen   = sizeof(int),
@@ -386,7 +373,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_at_max
 	},
 	{
-		INIT_CTL_NAME(OBD_AT_EXTRA)
 		.procname = "at_extra",
 		.data     = &at_extra,
 		.maxlen   = sizeof(int),
@@ -394,7 +380,6 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_at_extra
 	},
 	{
-		INIT_CTL_NAME(OBD_AT_EARLY_MARGIN)
 		.procname = "at_early_margin",
 		.data     = &at_early_margin,
 		.maxlen   = sizeof(int),
@@ -402,26 +387,22 @@ static ctl_table_t obd_table[] = {
 		.proc_handler = &proc_at_early_margin
 	},
 	{
-		INIT_CTL_NAME(OBD_AT_HISTORY)
 		.procname = "at_history",
 		.data     = &at_history,
 		.maxlen   = sizeof(int),
 		.mode     = 0644,
 		.proc_handler = &proc_at_history
-	},
-	{       INIT_CTL_NAME(0)    }
+	}
 };
 
 static ctl_table_t parent_table[] = {
 	{
-		INIT_CTL_NAME(OBD_SYSCTL)
 		.procname = "lustre",
 		.data     = NULL,
 		.maxlen   = 0,
 		.mode     = 0555,
 		.child    = obd_table
-	},
-	{       INIT_CTL_NAME(0)   }
+	}
 };
 #endif
 
-- 
1.7.9.5

