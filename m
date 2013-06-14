Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab3FNCkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:40:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40786 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759868Ab3FNCk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:40:26 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 15/33] parport: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:40 -0700
Message-Id: <d355eaf219137c6c3f1368ce0ceab7e97344eea9.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/parport/procfs.c | 58 ++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

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
-- 
1.8.1.2.459.gbcd45b4.dirty

