Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3GVVOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:14:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60207 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757770Ab3GVVOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:14:00 -0400
Message-ID: <1374527638.2061.63.camel@joe-AO722>
Subject: [TRIVIAL PATCH 1/2] treewide: Convert uses of typedef ctl_table to
 struct ctl_table
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jul 2013 14:13:58 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typedef is not useful, so convert all the uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
Remainder patch of what's not applied of:
https://lkml.org/lkml/2013/6/13/650

 arch/arm/kernel/isa.c              |  6 ++--
 arch/ia64/kernel/crash.c           |  4 +--
 arch/ia64/kernel/perfmon.c         |  6 ++--
 arch/s390/appldata/appldata_base.c | 16 +++++------
 arch/s390/kernel/debug.c           |  4 +--
 arch/s390/mm/cmm.c                 |  6 ++--
 arch/tile/kernel/proc.c            |  4 +--
 drivers/cdrom/cdrom.c              | 10 +++----
 drivers/infiniband/core/ucma.c     |  2 +-
 drivers/md/md.c                    |  6 ++--
 drivers/parport/procfs.c           | 58 +++++++++++++++++++-------------------
 drivers/scsi/scsi_sysctl.c         |  6 ++--
 fs/coda/sysctl.c                   |  4 +--
 fs/dcache.c                        |  2 +-
 fs/drop_caches.c                   |  2 +-
 fs/eventpoll.c                     |  2 +-
 fs/file_table.c                    |  4 +--
 fs/fscache/main.c                  |  4 +--
 fs/inode.c                         |  2 +-
 fs/lockd/svc.c                     |  6 ++--
 fs/nfs/nfs4sysctl.c                |  6 ++--
 fs/nfs/sysctl.c                    |  6 ++--
 fs/notify/inotify/inotify_user.c   |  2 +-
 fs/ntfs/sysctl.c                   |  4 +--
 fs/ocfs2/stackglue.c               |  8 +++---
 include/linux/key.h                |  2 +-
 ipc/ipc_sysctl.c                   | 14 ++++-----
 ipc/mq_sysctl.c                    | 10 +++----
 kernel/sysctl.c                    |  2 +-
 kernel/utsname_sysctl.c            |  6 ++--
 mm/page-writeback.c                |  2 +-
 mm/page_alloc.c                    | 15 +++++-----
 security/keys/sysctl.c             |  2 +-
 33 files changed, 118 insertions(+), 115 deletions(-)

diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
index 3464859..9d1cf71 100644
--- a/arch/arm/kernel/isa.c
+++ b/arch/arm/kernel/isa.c
@@ -20,7 +20,7 @@
 
 static unsigned int isa_membase, isa_portbase, isa_portshift;
 
-static ctl_table ctl_isa_vars[4] = {
+static struct ctl_table ctl_isa_vars[4] = {
 	{
 		.procname	= "membase",
 		.data		= &isa_membase, 
@@ -44,7 +44,7 @@ static ctl_table ctl_isa_vars[4] = {
 
 static struct ctl_table_header *isa_sysctl_header;
 
-static ctl_table ctl_isa[2] = {
+static struct ctl_table ctl_isa[2] = {
 	{
 		.procname	= "isa",
 		.mode		= 0555,
@@ -52,7 +52,7 @@ static ctl_table ctl_isa[2] = {
 	}, {}
 };
 
-static ctl_table ctl_bus[2] = {
+static struct ctl_table ctl_bus[2] = {
 	{
 		.procname	= "bus",
 		.mode		= 0555,
diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index b942f40..2955f35 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -237,7 +237,7 @@ kdump_init_notifier(struct notifier_block *self, unsigned long val, void *data)
 }
 
 #ifdef CONFIG_SYSCTL
-static ctl_table kdump_ctl_table[] = {
+static struct ctl_table kdump_ctl_table[] = {
 	{
 		.procname = "kdump_on_init",
 		.data = &kdump_on_init,
@@ -255,7 +255,7 @@ static ctl_table kdump_ctl_table[] = {
 	{ }
 };
 
-static ctl_table sys_table[] = {
+static struct ctl_table sys_table[] = {
 	{
 	  .procname = "kernel",
 	  .mode = 0555,
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 5a9ff1c..81c962b 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -521,7 +521,7 @@ static pmu_config_t		*pmu_conf;
 pfm_sysctl_t pfm_sysctl;
 EXPORT_SYMBOL(pfm_sysctl);
 
-static ctl_table pfm_ctl_table[]={
+static struct ctl_table pfm_ctl_table[] = {
 	{
 		.procname	= "debug",
 		.data		= &pfm_sysctl.debug,
@@ -552,7 +552,7 @@ static ctl_table pfm_ctl_table[]={
 	},
 	{}
 };
-static ctl_table pfm_sysctl_dir[] = {
+static struct ctl_table pfm_sysctl_dir[] = {
 	{
 		.procname	= "perfmon",
 		.mode		= 0555,
@@ -560,7 +560,7 @@ static ctl_table pfm_sysctl_dir[] = {
 	},
  	{}
 };
-static ctl_table pfm_sysctl_root[] = {
+static struct ctl_table pfm_sysctl_root[] = {
 	{
 		.procname	= "kernel",
 		.mode		= 0555,
diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 87a2209..c0ef020a 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -48,9 +48,9 @@ static struct platform_device *appldata_pdev;
  * /proc entries (sysctl)
  */
 static const char appldata_proc_name[APPLDATA_PROC_NAME_LENGTH] = "appldata";
-static int appldata_timer_handler(ctl_table *ctl, int write,
+static int appldata_timer_handler(struct ctl_table *ctl, int write,
 				  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int appldata_interval_handler(ctl_table *ctl, int write,
+static int appldata_interval_handler(struct ctl_table *ctl, int write,
 					 void __user *buffer,
 					 size_t *lenp, loff_t *ppos);
 
@@ -201,8 +201,8 @@ static void __appldata_vtimer_setup(int cmd)
  * Start/Stop timer, show status of timer (0 = not active, 1 = active)
  */
 static int
-appldata_timer_handler(ctl_table *ctl, int write,
-			   void __user *buffer, size_t *lenp, loff_t *ppos)
+appldata_timer_handler(struct ctl_table *ctl, int write,
+		       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int len;
 	char buf[2];
@@ -243,8 +243,8 @@ out:
  * current timer interval.
  */
 static int
-appldata_interval_handler(ctl_table *ctl, int write,
-			   void __user *buffer, size_t *lenp, loff_t *ppos)
+appldata_interval_handler(struct ctl_table *ctl, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int len, interval;
 	char buf[16];
@@ -286,8 +286,8 @@ out:
  * monitoring (0 = not in process, 1 = in process)
  */
 static int
-appldata_generic_handler(ctl_table *ctl, int write,
-			   void __user *buffer, size_t *lenp, loff_t *ppos)
+appldata_generic_handler(struct ctl_table *ctl, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct appldata_ops *ops = NULL, *tmp_ops;
 	int rc, len, found;
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index f1279dc..fc5672f 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -889,8 +889,8 @@ static int debug_active=1;
  * if debug_active is already off
  */
 static int
-s390dbf_procactive(ctl_table *table, int write,
-                     void __user *buffer, size_t *lenp, loff_t *ppos)
+s390dbf_procactive(struct ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (!write || debug_stoppable || !debug_active)
 		return proc_dointvec(table, write, buffer, lenp, ppos);
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 9d84a1f..0caf085 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -253,7 +253,8 @@ static int cmm_skip_blanks(char *cp, char **endp)
 
 static struct ctl_table cmm_table[];
 
-static int cmm_pages_handler(ctl_table *ctl, int write, void __user *buffer,
+static int cmm_pages_handler(struct ctl_table *ctl, int write,
+			     void __user *buffer,
 			     size_t *lenp, loff_t *ppos)
 {
 	char buf[16], *p;
@@ -293,7 +294,8 @@ static int cmm_pages_handler(ctl_table *ctl, int write, void __user *buffer,
 	return 0;
 }
 
-static int cmm_timeout_handler(ctl_table *ctl, int write,  void __user *buffer,
+static int cmm_timeout_handler(struct ctl_table *ctl, int write,
+			       void __user *buffer,
 			       size_t *lenp, loff_t *ppos)
 {
 	char buf[64], *p;
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index dafc447..6570813 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -114,7 +114,7 @@ arch_initcall(proc_tile_init);
  */
 
 #ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
-static ctl_table unaligned_subtable[] = {
+static struct ctl_table unaligned_subtable[] = {
 	{
 		.procname	= "enabled",
 		.data		= &unaligned_fixup,
@@ -139,7 +139,7 @@ static ctl_table unaligned_subtable[] = {
 	{}
 };
 
-static ctl_table unaligned_table[] = {
+static struct ctl_table unaligned_table[] = {
 	{
 		.procname	= "unaligned_fixup",
 		.mode		= 0555,
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..d49a76f 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3465,7 +3465,7 @@ static int cdrom_print_info(const char *header, int val, char *info,
 	return 0;
 }
 
-static int cdrom_sysctl_info(ctl_table *ctl, int write,
+static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
                            void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int pos;
@@ -3578,7 +3578,7 @@ static void cdrom_update_settings(void)
 	mutex_unlock(&cdrom_mutex);
 }
 
-static int cdrom_sysctl_handler(ctl_table *ctl, int write,
+static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
@@ -3604,7 +3604,7 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write,
 }
 
 /* Place files in /proc/sys/dev/cdrom */
-static ctl_table cdrom_table[] = {
+static struct ctl_table cdrom_table[] = {
 	{
 		.procname	= "info",
 		.data		= &cdrom_sysctl_settings.info, 
@@ -3650,7 +3650,7 @@ static ctl_table cdrom_table[] = {
 	{ }
 };
 
-static ctl_table cdrom_cdrom_table[] = {
+static struct ctl_table cdrom_cdrom_table[] = {
 	{
 		.procname	= "cdrom",
 		.maxlen		= 0,
@@ -3661,7 +3661,7 @@ static ctl_table cdrom_cdrom_table[] = {
 };
 
 /* Make sure that /proc/sys/dev is there */
-static ctl_table cdrom_root_table[] = {
+static struct ctl_table cdrom_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b0f189b..3f93093 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -57,7 +57,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 static unsigned int max_backlog = 1024;
 
 static struct ctl_table_header *ucma_ctl_table_hdr;
-static ctl_table ucma_ctl_table[] = {
+static struct ctl_table ucma_ctl_table[] = {
 	{
 		.procname	= "max_backlog",
 		.data		= &max_backlog,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b71d75e..77e6819 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -112,7 +112,7 @@ static inline int speed_max(struct mddev *mddev)
 
 static struct ctl_table_header *raid_table_header;
 
-static ctl_table raid_table[] = {
+static struct ctl_table raid_table[] = {
 	{
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
@@ -130,7 +130,7 @@ static ctl_table raid_table[] = {
 	{ }
 };
 
-static ctl_table raid_dir_table[] = {
+static struct ctl_table raid_dir_table[] = {
 	{
 		.procname	= "raid",
 		.maxlen		= 0,
@@ -140,7 +140,7 @@ static ctl_table raid_dir_table[] = {
 	{ }
 };
 
-static ctl_table raid_root_table[] = {
+static struct ctl_table raid_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 92ed045..3b47080 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -31,7 +31,7 @@
 #define PARPORT_MIN_SPINTIME_VALUE 1
 #define PARPORT_MAX_SPINTIME_VALUE 1000
 
-static int do_active_device(ctl_table *table, int write,
+static int do_active_device(struct ctl_table *table, int write,
 		      void __user *result, size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
@@ -68,7 +68,7 @@ static int do_active_device(ctl_table *table, int write,
 }
 
 #ifdef CONFIG_PARPORT_1284
-static int do_autoprobe(ctl_table *table, int write,
+static int do_autoprobe(struct ctl_table *table, int write,
 			void __user *result, size_t *lenp, loff_t *ppos)
 {
 	struct parport_device_info *info = table->extra2;
@@ -110,9 +110,9 @@ static int do_autoprobe(ctl_table *table, int write,
 }
 #endif /* IEEE1284.3 support. */
 
-static int do_hardware_base_addr (ctl_table *table, int write,
-				  void __user *result,
-				  size_t *lenp, loff_t *ppos)
+static int do_hardware_base_addr(struct ctl_table *table, int write,
+				 void __user *result,
+				 size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[20];
@@ -138,9 +138,9 @@ static int do_hardware_base_addr (ctl_table *table, int write,
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-static int do_hardware_irq (ctl_table *table, int write,
-			    void __user *result,
-			    size_t *lenp, loff_t *ppos)
+static int do_hardware_irq(struct ctl_table *table, int write,
+			   void __user *result,
+			   size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[20];
@@ -166,9 +166,9 @@ static int do_hardware_irq (ctl_table *table, int write,
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-static int do_hardware_dma (ctl_table *table, int write,
-			    void __user *result,
-			    size_t *lenp, loff_t *ppos)
+static int do_hardware_dma(struct ctl_table *table, int write,
+			   void __user *result,
+			   size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[20];
@@ -194,9 +194,9 @@ static int do_hardware_dma (ctl_table *table, int write,
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-static int do_hardware_modes (ctl_table *table, int write,
-			      void __user *result,
-			      size_t *lenp, loff_t *ppos)
+static int do_hardware_modes(struct ctl_table *table, int write,
+			     void __user *result,
+			     size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[40];
@@ -255,11 +255,11 @@ PARPORT_MAX_SPINTIME_VALUE;
 
 struct parport_sysctl_table {
 	struct ctl_table_header *sysctl_header;
-	ctl_table vars[12];
-	ctl_table device_dir[2];
-	ctl_table port_dir[2];
-	ctl_table parport_dir[2];
-	ctl_table dev_dir[2];
+	struct ctl_table vars[12];
+	struct ctl_table device_dir[2];
+	struct ctl_table port_dir[2];
+	struct ctl_table parport_dir[2];
+	struct ctl_table dev_dir[2];
 };
 
 static const struct parport_sysctl_table parport_sysctl_template = {
@@ -369,12 +369,12 @@ static const struct parport_sysctl_table parport_sysctl_template = {
 struct parport_device_sysctl_table
 {
 	struct ctl_table_header *sysctl_header;
-	ctl_table vars[2];
-	ctl_table device_dir[2];
-	ctl_table devices_root_dir[2];
-	ctl_table port_dir[2];
-	ctl_table parport_dir[2];
-	ctl_table dev_dir[2];
+	struct ctl_table vars[2];
+	struct ctl_table device_dir[2];
+	struct ctl_table devices_root_dir[2];
+	struct ctl_table port_dir[2];
+	struct ctl_table parport_dir[2];
+	struct ctl_table dev_dir[2];
 };
 
 static const struct parport_device_sysctl_table
@@ -422,10 +422,10 @@ parport_device_sysctl_template = {
 struct parport_default_sysctl_table
 {
 	struct ctl_table_header *sysctl_header;
-	ctl_table vars[3];
-        ctl_table default_dir[2];
-	ctl_table parport_dir[2];
-	ctl_table dev_dir[2];
+	struct ctl_table vars[3];
+	struct ctl_table default_dir[2];
+	struct ctl_table parport_dir[2];
+	struct ctl_table dev_dir[2];
 };
 
 static struct parport_default_sysctl_table
diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 2b6b93f..546f162 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -12,7 +12,7 @@
 #include "scsi_priv.h"
 
 
-static ctl_table scsi_table[] = {
+static struct ctl_table scsi_table[] = {
 	{ .procname	= "logging_level",
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
@@ -21,14 +21,14 @@ static ctl_table scsi_table[] = {
 	{ }
 };
 
-static ctl_table scsi_dir_table[] = {
+static struct ctl_table scsi_dir_table[] = {
 	{ .procname	= "scsi",
 	  .mode		= 0555,
 	  .child	= scsi_table },
 	{ }
 };
 
-static ctl_table scsi_root_table[] = {
+static struct ctl_table scsi_root_table[] = {
 	{ .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= scsi_dir_table },
diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index af56ad5..34218a8 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -14,7 +14,7 @@
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
 
-static ctl_table coda_table[] = {
+static struct ctl_table coda_table[] = {
 	{
 		.procname	= "timeout",
 		.data		= &coda_timeout,
@@ -39,7 +39,7 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-static ctl_table fs_table[] = {
+static struct ctl_table fs_table[] = {
 	{
 		.procname	= "coda",
 		.mode		= 0555,
diff --git a/fs/dcache.c b/fs/dcache.c
index 7489b6f..0fb89d0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -152,7 +152,7 @@ static long get_nr_dentry_unused(void)
 	return sum < 0 ? 0 : sum;
 }
 
-int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
+int proc_nr_dentry(struct ctl_table *table, int write, void __user *buffer,
 		   size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 9fd702f..d9fba09 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -50,7 +50,7 @@ static void drop_slab(void)
 	} while (nr_objects > 10);
 }
 
-int drop_caches_sysctl_handler(ctl_table *table, int write,
+int drop_caches_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int ret;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d5e7de0..b9e4cd4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -289,7 +289,7 @@ static LIST_HEAD(tfile_check_list);
 static long zero;
 static long long_max = LONG_MAX;
 
-ctl_table epoll_table[] = {
+struct ctl_table epoll_table[] = {
 	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
diff --git a/fs/file_table.c b/fs/file_table.c
index 7528930..dbd7d48 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -79,14 +79,14 @@ EXPORT_SYMBOL_GPL(get_max_files);
  * Handle nr_files sysctl
  */
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
-int proc_nr_files(ctl_table *table, int write,
+int proc_nr_files(struct ctl_table *table, int write,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	files_stat.nr_files = get_nr_files();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #else
-int proc_nr_files(ctl_table *table, int write,
+int proc_nr_files(struct ctl_table *table, int write,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 7c27907..5b2c174 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-ctl_table fscache_sysctls[] = {
+struct ctl_table fscache_sysctls[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,7 +87,7 @@ ctl_table fscache_sysctls[] = {
 	{}
 };
 
-ctl_table fscache_sysctls_root[] = {
+struct ctl_table fscache_sysctls_root[] = {
 	{
 		.procname	= "fscache",
 		.mode		= 0555,
diff --git a/fs/inode.c b/fs/inode.c
index e315c0a..b9083f3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -105,7 +105,7 @@ long get_nr_dirty_inodes(void)
  * Handle nr_inode sysctl
  */
 #ifdef CONFIG_SYSCTL
-int proc_nr_inodes(ctl_table *table, int write,
+int proc_nr_inodes(struct ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	inodes_stat.nr_inodes = get_nr_inodes();
diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 10d6c41..140cc67 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -435,7 +435,7 @@ EXPORT_SYMBOL_GPL(lockd_down);
  * Sysctl parameters (same as module parameters, different interface).
  */
 
-static ctl_table nlm_sysctls[] = {
+static struct ctl_table nlm_sysctls[] = {
 	{
 		.procname	= "nlm_grace_period",
 		.data		= &nlm_grace_period,
@@ -489,7 +489,7 @@ static ctl_table nlm_sysctls[] = {
 	{ }
 };
 
-static ctl_table nlm_sysctl_dir[] = {
+static struct ctl_table nlm_sysctl_dir[] = {
 	{
 		.procname	= "nfs",
 		.mode		= 0555,
@@ -498,7 +498,7 @@ static ctl_table nlm_sysctl_dir[] = {
 	{ }
 };
 
-static ctl_table nlm_sysctl_root[] = {
+static struct ctl_table nlm_sysctl_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
diff --git a/fs/nfs/nfs4sysctl.c b/fs/nfs/nfs4sysctl.c
index 2628d92..b6ebe7e 100644
--- a/fs/nfs/nfs4sysctl.c
+++ b/fs/nfs/nfs4sysctl.c
@@ -16,7 +16,7 @@ static const int nfs_set_port_min = 0;
 static const int nfs_set_port_max = 65535;
 static struct ctl_table_header *nfs4_callback_sysctl_table;
 
-static ctl_table nfs4_cb_sysctls[] = {
+static struct ctl_table nfs4_cb_sysctls[] = {
 	{
 		.procname = "nfs_callback_tcpport",
 		.data = &nfs_callback_set_tcpport,
@@ -36,7 +36,7 @@ static ctl_table nfs4_cb_sysctls[] = {
 	{ }
 };
 
-static ctl_table nfs4_cb_sysctl_dir[] = {
+static struct ctl_table nfs4_cb_sysctl_dir[] = {
 	{
 		.procname = "nfs",
 		.mode = 0555,
@@ -45,7 +45,7 @@ static ctl_table nfs4_cb_sysctl_dir[] = {
 	{ }
 };
 
-static ctl_table nfs4_cb_sysctl_root[] = {
+static struct ctl_table nfs4_cb_sysctl_root[] = {
 	{
 		.procname = "fs",
 		.mode = 0555,
diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index 6b3f253..bb6ed81 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -13,7 +13,7 @@
 
 static struct ctl_table_header *nfs_callback_sysctl_table;
 
-static ctl_table nfs_cb_sysctls[] = {
+static struct ctl_table nfs_cb_sysctls[] = {
 	{
 		.procname	= "nfs_mountpoint_timeout",
 		.data		= &nfs_mountpoint_expiry_timeout,
@@ -31,7 +31,7 @@ static ctl_table nfs_cb_sysctls[] = {
 	{ }
 };
 
-static ctl_table nfs_cb_sysctl_dir[] = {
+static struct ctl_table nfs_cb_sysctl_dir[] = {
 	{
 		.procname = "nfs",
 		.mode = 0555,
@@ -40,7 +40,7 @@ static ctl_table nfs_cb_sysctl_dir[] = {
 	{ }
 };
 
-static ctl_table nfs_cb_sysctl_root[] = {
+static struct ctl_table nfs_cb_sysctl_root[] = {
 	{
 		.procname = "fs",
 		.mode = 0555,
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 60f954a..cf4d837 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -58,7 +58,7 @@ struct kmem_cache *event_priv_cachep __read_mostly;
 
 static int zero;
 
-ctl_table inotify_table[] = {
+struct ctl_table inotify_table[] = {
 	{
 		.procname	= "max_user_instances",
 		.data		= &inotify_max_user_instances,
diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
index 79a8918..a3e6626 100644
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -34,7 +34,7 @@
 #include "debug.h"
 
 /* Definition of the ntfs sysctl. */
-static ctl_table ntfs_sysctls[] = {
+static struct ctl_table ntfs_sysctls[] = {
 	{
 		.procname	= "ntfs-debug",
 		.data		= &debug_msgs,		/* Data pointer and size. */
@@ -46,7 +46,7 @@ static ctl_table ntfs_sysctls[] = {
 };
 
 /* Define the parent directory /proc/sys/fs. */
-static ctl_table sysctls_root[] = {
+static struct ctl_table sysctls_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 39abf89..cb7ec0b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -643,7 +643,7 @@ error:
 
 #define FS_OCFS2_NM		1
 
-static ctl_table ocfs2_nm_table[] = {
+static struct ctl_table ocfs2_nm_table[] = {
 	{
 		.procname	= "hb_ctl_path",
 		.data		= ocfs2_hb_ctl_path,
@@ -654,7 +654,7 @@ static ctl_table ocfs2_nm_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_mod_table[] = {
+static struct ctl_table ocfs2_mod_table[] = {
 	{
 		.procname	= "nm",
 		.data		= NULL,
@@ -665,7 +665,7 @@ static ctl_table ocfs2_mod_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_kern_table[] = {
+static struct ctl_table ocfs2_kern_table[] = {
 	{
 		.procname	= "ocfs2",
 		.data		= NULL,
@@ -676,7 +676,7 @@ static ctl_table ocfs2_kern_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_root_table[] = {
+static struct ctl_table ocfs2_root_table[] = {
 	{
 		.procname	= "fs",
 		.data		= NULL,
diff --git a/include/linux/key.h b/include/linux/key.h
index 4dfde11..3b98ce0 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -310,7 +310,7 @@ do {									\
 } while (0)
 
 #ifdef CONFIG_SYSCTL
-extern ctl_table key_sysctls[];
+extern struct ctl_table key_sysctls[];
 #endif
 /*
  * the userspace interface
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 130dfec..27fab60 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -18,7 +18,7 @@
 #include <linux/msg.h>
 #include "util.h"
 
-static void *get_ipc(ctl_table *table)
+static void *get_ipc(struct ctl_table *table)
 {
 	char *which = table->data;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -27,7 +27,7 @@ static void *get_ipc(ctl_table *table)
 }
 
 #ifdef CONFIG_PROC_SYSCTL
-static int proc_ipc_dointvec(ctl_table *table, int write,
+static int proc_ipc_dointvec(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -38,7 +38,7 @@ static int proc_ipc_dointvec(ctl_table *table, int write,
 	return proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
 }
 
-static int proc_ipc_dointvec_minmax(ctl_table *table, int write,
+static int proc_ipc_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -49,7 +49,7 @@ static int proc_ipc_dointvec_minmax(ctl_table *table, int write,
 	return proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 }
 
-static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
+static int proc_ipc_dointvec_minmax_orphans(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
@@ -62,7 +62,7 @@ static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
 	return err;
 }
 
-static int proc_ipc_callback_dointvec(ctl_table *table, int write,
+static int proc_ipc_callback_dointvec(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -85,7 +85,7 @@ static int proc_ipc_callback_dointvec(ctl_table *table, int write,
 	return rc;
 }
 
-static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
+static int proc_ipc_doulongvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -119,7 +119,7 @@ static void ipc_auto_callback(int val)
 	}
 }
 
-static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
+static int proc_ipcauto_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 383d638..ee514bb 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -14,7 +14,7 @@
 #include <linux/sysctl.h>
 
 #ifdef CONFIG_PROC_SYSCTL
-static void *get_mq(ctl_table *table)
+static void *get_mq(struct ctl_table *table)
 {
 	char *which = table->data;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -22,7 +22,7 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-static int proc_mq_dointvec_minmax(ctl_table *table, int write,
+static int proc_mq_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table mq_table;
@@ -45,7 +45,7 @@ static int msg_max_limit_max = HARD_MSGMAX;
 static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
 static int msg_maxsize_limit_max = HARD_MSGSIZEMAX;
 
-static ctl_table mq_sysctls[] = {
+static struct ctl_table mq_sysctls[] = {
 	{
 		.procname	= "queues_max",
 		.data		= &init_ipc_ns.mq_queues_max,
@@ -94,7 +94,7 @@ static ctl_table mq_sysctls[] = {
 	{}
 };
 
-static ctl_table mq_sysctl_dir[] = {
+static struct ctl_table mq_sysctl_dir[] = {
 	{
 		.procname	= "mqueue",
 		.mode		= 0555,
@@ -103,7 +103,7 @@ static ctl_table mq_sysctl_dir[] = {
 	{}
 };
 
-static ctl_table mq_sysctl_root[] = {
+static struct ctl_table mq_sysctl_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index cf3e631..3b1b245 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -192,7 +192,7 @@ static int proc_dostring_coredump(struct ctl_table *table, int write,
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
 
-static int sysrq_sysctl_handler(ctl_table *table, int write,
+static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 4f69f9a..09af144 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_PROC_SYSCTL
 
-static void *get_uts(ctl_table *table, int write)
+static void *get_uts(struct ctl_table *table, int write)
 {
 	char *which = table->data;
 	struct uts_namespace *uts_ns;
@@ -32,7 +32,7 @@ static void *get_uts(ctl_table *table, int write)
 	return which;
 }
 
-static void put_uts(ctl_table *table, int write, void *which)
+static void put_uts(struct ctl_table *table, int write, void *which)
 {
 	if (!write)
 		up_read(&uts_sem);
@@ -44,7 +44,7 @@ static void put_uts(ctl_table *table, int write, void *which)
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
  */
-static int proc_do_uts_string(ctl_table *table, int write,
+static int proc_do_uts_string(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table uts_table;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3f0c895..56459b3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1546,7 +1546,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
-int dirty_writeback_centisecs_handler(ctl_table *table, int write,
+int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..dd798b1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3243,7 +3243,7 @@ early_param("numa_zonelist_order", setup_numa_zonelist_order);
 /*
  * sysctl handler for numa_zonelist_order
  */
-int numa_zonelist_order_handler(ctl_table *table, int write,
+int numa_zonelist_order_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos)
 {
@@ -5618,8 +5618,9 @@ module_init(init_per_zone_wmark_min)
  *	that we can call two helper functions whenever min_free_kbytes
  *	changes.
  */
-int min_free_kbytes_sysctl_handler(ctl_table *table, int write, 
-	void __user *buffer, size_t *length, loff_t *ppos)
+int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
+				   void __user *buffer,
+				   size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
 	if (write) {
@@ -5630,7 +5631,7 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 }
 
 #ifdef CONFIG_NUMA
-int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5646,7 +5647,7 @@ int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
-int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5672,7 +5673,7 @@ int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
  * minimum watermarks. The lowmem reserve ratio can only make sense
  * if in function of the boot time zone sizes.
  */
-int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
+int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec_minmax(table, write, buffer, length, ppos);
@@ -5685,7 +5686,7 @@ int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
  * can have before it gets flushed back to buddy allocator.
  */
-int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
+int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index ee32d18..9a9df6f 100644
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -15,7 +15,7 @@
 
 static const int zero, one = 1, max = INT_MAX;
 
-ctl_table key_sysctls[] = {
+struct ctl_table key_sysctls[] = {
 	{
 		.procname = "maxkeys",
 		.data = &key_quota_maxkeys,


