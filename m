Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbbAROIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:08:24 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:47138 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751844AbbAROIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:08:12 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: lustre: libcfs: declare internal symbols as static
Date: Sun, 18 Jan 2015 15:06:49 +0100
Message-Id: <1421590012-7082-4-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
References: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warnings like:
  warning: symbol '...' was not declared. Should it be static?

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: Jinshan Xiong <jinshan.xiong@intel.com>
Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: HPDD-discuss@lists.01.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/lustre/lustre/libcfs/debug.c       |  8 ++++----
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |  2 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        | 24 +++++++++++++---------
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |  2 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |  2 +-
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index a7a7ac6..7170088 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -115,7 +115,7 @@ static wait_queue_head_t debug_ctlwq;
 char libcfs_debug_file_path_arr[PATH_MAX] = LIBCFS_DEBUG_FILE_PATH_DEFAULT;
 
 /* We need to pass a pointer here, but elsewhere this must be a const */
-char *libcfs_debug_file_path;
+static char *libcfs_debug_file_path;
 module_param(libcfs_debug_file_path, charp, 0644);
 MODULE_PARM_DESC(libcfs_debug_file_path,
 		 "Path for dumping debug logs, set 'NONE' to prevent log dumping");
@@ -124,7 +124,7 @@ int libcfs_panic_in_progress;
 
 /* libcfs_debug_token2mask() expects the returned
  * string in lower-case */
-const char *
+static const char *
 libcfs_debug_subsys2str(int subsys)
 {
 	switch (1 << subsys) {
@@ -185,7 +185,7 @@ libcfs_debug_subsys2str(int subsys)
 
 /* libcfs_debug_token2mask() expects the returned
  * string in lower-case */
-const char *
+static const char *
 libcfs_debug_dbg2str(int debug)
 {
 	switch (1 << debug) {
@@ -350,7 +350,7 @@ void libcfs_debug_dumplog_internal(void *arg)
 	current->journal_info = journal_info;
 }
 
-int libcfs_debug_dumplog_thread(void *arg)
+static int libcfs_debug_dumplog_thread(void *arg)
 {
 	libcfs_debug_dumplog_internal(arg);
 	wake_up(&debug_ctlwq);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index 9515347..277f6b8 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -82,7 +82,7 @@ int cfs_cap_raised(cfs_cap_t cap)
 	return cap_raised(current_cap(), cap);
 }
 
-void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
+static void cfs_kernel_cap_pack(kernel_cap_t kcap, cfs_cap_t *cap)
 {
 	/* XXX lost high byte */
 	*cap = kcap.cap[0];
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
index 83d3f08..c539e37 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
@@ -232,8 +232,9 @@ static int proc_debug_mb(struct ctl_table *table, int write,
 				 __proc_debug_mb);
 }
 
-int proc_console_max_delay_cs(struct ctl_table *table, int write,
-			      void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_console_max_delay_cs(struct ctl_table *table, int write,
+				     void __user *buffer, size_t *lenp,
+				     loff_t *ppos)
 {
 	int rc, max_delay_cs;
 	struct ctl_table dummy = *table;
@@ -264,8 +265,9 @@ int proc_console_max_delay_cs(struct ctl_table *table, int write,
 	return rc;
 }
 
-int proc_console_min_delay_cs(struct ctl_table *table, int write,
-			      void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_console_min_delay_cs(struct ctl_table *table, int write,
+				     void __user *buffer, size_t *lenp,
+				     loff_t *ppos)
 {
 	int rc, min_delay_cs;
 	struct ctl_table dummy = *table;
@@ -296,8 +298,8 @@ int proc_console_min_delay_cs(struct ctl_table *table, int write,
 	return rc;
 }
 
-int proc_console_backoff(struct ctl_table *table, int write,
-			 void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_console_backoff(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int rc, backoff;
 	struct ctl_table dummy = *table;
@@ -324,16 +326,18 @@ int proc_console_backoff(struct ctl_table *table, int write,
 	return rc;
 }
 
-int libcfs_force_lbug(struct ctl_table *table, int write, void __user *buffer,
-		      size_t *lenp, loff_t *ppos)
+static int libcfs_force_lbug(struct ctl_table *table, int write,
+			     void __user *buffer,
+			     size_t *lenp, loff_t *ppos)
 {
 	if (write)
 		LBUG();
 	return 0;
 }
 
-int proc_fail_loc(struct ctl_table *table, int write, void __user *buffer,
-		  size_t *lenp, loff_t *ppos)
+static int proc_fail_loc(struct ctl_table *table, int write,
+			 void __user *buffer,
+			 size_t *lenp, loff_t *ppos)
 {
 	int rc;
 	long old_fail_loc = cfs_fail_loc;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index b91a1f9..cd2fc01 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -43,7 +43,7 @@
 /* For sys_open & sys_close */
 #include <linux/syscalls.h>
 
-int
+static int
 libcfs_sock_ioctl(int cmd, unsigned long arg)
 {
 	mm_segment_t	oldmm = get_fs();
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 5917c31..d18de04 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -55,7 +55,7 @@ static struct tracefiled_ctl trace_tctl;
 struct mutex cfs_trace_thread_mutex;
 static int thread_running = 0;
 
-atomic_t cfs_tage_allocated = ATOMIC_INIT(0);
+static atomic_t cfs_tage_allocated = ATOMIC_INIT(0);
 
 static void put_pages_on_tcd_daemon_list(struct page_collection *pc,
 					 struct cfs_trace_cpu_data *tcd);
-- 
1.9.1

