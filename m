Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3JRLqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:46:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59602 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751793Ab3JRLqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:46:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM / Hibernate: Use bool for boolean fields of struct snapshot_data
Date: Fri, 18 Oct 2013 13:58:45 +0200
Message-ID: <3456387.pM1vmRfZ0X@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The snapshot_data structure used internally by the hibernate user
space interface code in user.c has three char fields that are used
to store boolean values.  Change their data type to bool and use
true and false instead of 1 and 0, respectively, in assignments
involving those fields.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/user.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-pm/kernel/power/user.c
===================================================================
--- linux-pm.orig/kernel/power/user.c
+++ linux-pm/kernel/power/user.c
@@ -36,9 +36,9 @@ static struct snapshot_data {
 	struct snapshot_handle handle;
 	int swap;
 	int mode;
-	char frozen;
-	char ready;
-	char platform_support;
+	bool frozen;
+	bool ready;
+	bool platform_support;
 	bool free_bitmaps;
 } snapshot_state;
 
@@ -93,9 +93,9 @@ static int snapshot_open(struct inode *i
 	if (error)
 		atomic_inc(&snapshot_device_available);
 
-	data->frozen = 0;
-	data->ready = 0;
-	data->platform_support = 0;
+	data->frozen = false;
+	data->ready = false;
+	data->platform_support = false;
 
  Unlock:
 	unlock_system_sleep();
@@ -229,7 +229,7 @@ static long snapshot_ioctl(struct file *
 		if (error)
 			thaw_processes();
 		else
-			data->frozen = 1;
+			data->frozen = true;
 
 		break;
 
@@ -240,7 +240,7 @@ static long snapshot_ioctl(struct file *
 		free_basic_memory_bitmaps();
 		data->free_bitmaps = false;
 		thaw_processes();
-		data->frozen = 0;
+		data->frozen = false;
 		break;
 
 	case SNAPSHOT_CREATE_IMAGE:
@@ -270,7 +270,7 @@ static long snapshot_ioctl(struct file *
 	case SNAPSHOT_FREE:
 		swsusp_free();
 		memset(&data->handle, 0, sizeof(struct snapshot_handle));
-		data->ready = 0;
+		data->ready = false;
 		/*
 		 * It is necessary to thaw kernel threads here, because
 		 * SNAPSHOT_CREATE_IMAGE may be invoked directly after
@@ -334,7 +334,7 @@ static long snapshot_ioctl(struct file *
 		 * PM_HIBERNATION_PREPARE
 		 */
 		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
-		data->ready = 0;
+		data->ready = false;
 		break;
 
 	case SNAPSHOT_PLATFORM_SUPPORT:

