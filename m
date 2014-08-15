Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaHOSSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:18:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62074 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaHOSSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:18:14 -0400
Date: Fri, 15 Aug 2014 23:48:05 +0530
From: Hema Prathaban <hemaklnce@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com
Subject: [PATCH] staging: lustre: lustre: libcfs: pr_warn instead printk
Message-ID: <20140815181805.GA4709@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warning using checkpatch.pl
WARNING: Prefer [subsystem eg: netdev]_warn([subsystem]dev, ... then
dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index 6b58469..8143ebe 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -344,7 +344,7 @@ void libcfs_debug_dumplog_internal(void *arg)
 		snprintf(debug_file_name, sizeof(debug_file_name) - 1,
 			 "%s.%ld.%ld", libcfs_debug_file_path_arr,
 			 get_seconds(), (long_ptr_t)arg);
-		printk(KERN_ALERT "LustreError: dumping log to %s\n",
+		pr_alert(KERN_ALERT "LustreError: dumping log to %s\n",
 		       debug_file_name);
 		cfs_tracefile_dump_all_pages(debug_file_name);
 		libcfs_run_debug_log_upcall(debug_file_name);
@@ -376,7 +376,7 @@ void libcfs_debug_dumplog(void)
 			     (void *)(long)current_pid(),
 			     "libcfs_debug_dumper");
 	if (IS_ERR(dumper))
-		printk(KERN_ERR "LustreError: cannot start log dump thread:"
+		pr_err(KERN_ERR "LustreError: cannot start log dump thread:"
 		       " %ld\n", PTR_ERR(dumper));
 	else
 		schedule();
@@ -453,7 +453,7 @@ int libcfs_debug_mark_buffer(const char *text)
 
 void libcfs_debug_set_level(unsigned int debug_level)
 {
-	printk(KERN_WARNING "Lustre: Setting portals debug level to %08x\n",
+	pr_warn(KERN_WARNING "Lustre: Setting portals debug level to %08x\n",
 	       debug_level);
 	libcfs_debug = debug_level;
 }
-- 
1.9.1

