Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbaGWLYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:24:08 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:42590 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbaGWLYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:24:05 -0400
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, sachin.kamat@linaro.org, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: obdclass: fix sparse warnings about static declaration
Date: Wed, 23 Jul 2014 19:23:43 +0400
Message-Id: <1406129023-10177-1-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
---
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   28 ++++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index a4cd46b..7c6767b 100644
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
@@ -388,7 +388,7 @@ static struct ctl_table parent_table[] = {
 };
 #endif
 
-void obd_sysctl_init(void)
+static void obd_sysctl_init(void)
 {
 #ifdef CONFIG_SYSCTL
 	if (!obd_table_header)
@@ -396,7 +396,7 @@ void obd_sysctl_init(void)
 #endif
 }
 
-void obd_sysctl_clean(void)
+static void obd_sysctl_clean(void)
 {
 #ifdef CONFIG_SYSCTL
 	if (obd_table_header)
-- 
1.7.10.4

