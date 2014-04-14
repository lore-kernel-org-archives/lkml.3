Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaDNCCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 22:02:07 -0400
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:44505 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754113AbaDNB4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:56:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1535:1544:1605:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3868:3871:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13255:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plane29_53fc50b465136
X-Filterd-Recvd-Size: 5341
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -next 3.16 06/19] parport: Convert use of typedef ctl_table to struct ctl_table
Date: Sun, 13 Apr 2014 18:55:38 -0700
Message-Id: <c5121846c1a45f29c1537361f9c40e21982831c1.1397438826.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1397438826.git.joe@perches.com>
References: <cover.1397438826.git.joe@perches.com>
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

