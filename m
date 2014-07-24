Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934339AbaGXHxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:53:05 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61713 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203AbaGXHxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:53:03 -0400
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, sachin.kamat@linaro.org, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: lustre: obdclass: fix sparse warnings about static declaration
Date: Thu, 24 Jul 2014 11:52:43 +0400
Message-Id: <1406188363-17580-1-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140724070642.GA30889@crion89>
References: <20140724070642.GA30889@crion89>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
---
 changes since v1:

 removed from patch  static declarations for functions obd_sysctl_init and
 obd_sysctl_clean to fix build issue.
 

.../lustre/lustre/obdclass/linux/linux-sysctl.c    |   24 ++++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index a4cd46b..38a9b31 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -52,7 +52,7 @@
 #include "../../include/lprocfs_status.h"
 
 #ifdef CONFIG_SYSCTL
-struct ctl_table_header *obd_table_header = NULL;
+static struct ctl_table_header *obd_table_header;
 #endif
 
 
@@ -79,8 +79,8 @@ enum {
 };
 
 
-int proc_set_timeout(struct ctl_table *table, int write, void __user *buffer,
-		     size_t *lenp, loff_t *ppos)
+static int proc_set_timeout(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int rc;
 
@@ -90,8 +90,8 @@ int proc_set_timeout(struct ctl_table *table, int write, void __user *buffer,
 	return rc;
 }
 
-int proc_memory_alloc(struct ctl_table *table, int write, void __user *buffer,
-		      size_t *lenp, loff_t *ppos)
+static int proc_memory_alloc(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char buf[22];
 	int len;
@@ -114,8 +114,8 @@ int proc_memory_alloc(struct ctl_table *table, int write, void __user *buffer,
 	return 0;
 }
 
-int proc_pages_alloc(struct ctl_table *table, int write, void __user *buffer,
-		     size_t *lenp, loff_t *ppos)
+static int proc_pages_alloc(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char buf[22];
 	int len;
@@ -138,7 +138,7 @@ int proc_pages_alloc(struct ctl_table *table, int write, void __user *buffer,
 	return 0;
 }
 
-int proc_mem_max(struct ctl_table *table, int write, void __user *buffer,
+static int proc_mem_max(struct ctl_table *table, int write, void __user *buffer,
 		 size_t *lenp, loff_t *ppos)
 {
 	char buf[22];
@@ -162,8 +162,8 @@ int proc_mem_max(struct ctl_table *table, int write, void __user *buffer,
 	return 0;
 }
 
-int proc_pages_max(struct ctl_table *table, int write, void __user *buffer,
-		   size_t *lenp, loff_t *ppos)
+static int proc_pages_max(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char buf[22];
 	int len;
@@ -186,7 +186,7 @@ int proc_pages_max(struct ctl_table *table, int write, void __user *buffer,
 	return 0;
 }
 
-int proc_max_dirty_pages_in_mb(struct ctl_table *table, int write,
+static int proc_max_dirty_pages_in_mb(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int rc = 0;
@@ -228,7 +228,7 @@ int proc_max_dirty_pages_in_mb(struct ctl_table *table, int write,
 	return rc;
 }
 
-int proc_alloc_fail_rate(struct ctl_table *table, int write,
+static int proc_alloc_fail_rate(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int rc	  = 0;
-- 
1.7.10.4

