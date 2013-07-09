Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3GIPnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:43:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab3GIPnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:43:11 -0400
Subject: [PATCH 2/3] firmware/dmi_scan: Fix most checkpatch errors and
 warnings
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1373384438.4391.6.camel@chaos.site>
References: <1373384438.4391.6.camel@chaos.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 09 Jul 2013 17:42:54 +0200
Message-ID: <1373384574.4391.9.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix all errors and trivial warnings reported by checkpatch for file
drivers/firmware/dmi_scan.c.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/firmware/dmi_scan.c |   47 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- linux-3.11-rc0.orig/drivers/firmware/dmi_scan.c	2013-07-09 15:38:09.687390047 +0200
+++ linux-3.11-rc0/drivers/firmware/dmi_scan.c	2013-07-09 16:08:13.979592957 +0200
@@ -63,7 +63,7 @@ static char * __init dmi_string(const st
 	if (str != NULL)
 		strcpy(str, bp);
 	else
-		printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
+		pr_err("dmi_string: cannot allocate %Zu bytes.\n", len);
 
 	return str;
 }
@@ -140,9 +140,10 @@ int dmi_available;
 /*
  *	Save a DMI string
  */
-static void __init dmi_save_ident(const struct dmi_header *dm, int slot, int string)
+static void __init dmi_save_ident(const struct dmi_header *dm, int slot,
+		int string)
 {
-	const char *d = (const char*) dm;
+	const char *d = (const char *) dm;
 	char *p;
 
 	if (dmi_ident[slot])
@@ -155,9 +156,10 @@ static void __init dmi_save_ident(const
 	dmi_ident[slot] = p;
 }
 
-static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int index)
+static void __init dmi_save_uuid(const struct dmi_header *dm, int slot,
+		int index)
 {
-	const u8 *d = (u8*) dm + index;
+	const u8 *d = (u8 *) dm + index;
 	char *s;
 	int is_ff = 1, is_00 = 1, i;
 
@@ -188,12 +190,13 @@ static void __init dmi_save_uuid(const s
 	else
 		sprintf(s, "%pUB", d);
 
-        dmi_ident[slot] = s;
+	dmi_ident[slot] = s;
 }
 
-static void __init dmi_save_type(const struct dmi_header *dm, int slot, int index)
+static void __init dmi_save_type(const struct dmi_header *dm, int slot,
+		int index)
 {
-	const u8 *d = (u8*) dm + index;
+	const u8 *d = (u8 *) dm + index;
 	char *s;
 
 	if (dmi_ident[slot])
@@ -217,7 +220,7 @@ static void __init dmi_save_one_device(i
 
 	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
 	if (!dev) {
-		printk(KERN_ERR "dmi_save_one_device: out of memory.\n");
+		pr_err("dmi_save_one_device: out of memory.\n");
 		return;
 	}
 
@@ -256,8 +259,7 @@ static void __init dmi_save_oem_strings_
 
 		dev = dmi_alloc(sizeof(*dev));
 		if (!dev) {
-			printk(KERN_ERR
-			   "dmi_save_oem_strings_devices: out of memory.\n");
+			pr_err("dmi_save_oem_strings_devices: out of memory.\n");
 			break;
 		}
 
@@ -272,11 +274,11 @@ static void __init dmi_save_oem_strings_
 static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
 {
 	struct dmi_device *dev;
-	void * data;
+	void *data;
 
 	data = dmi_alloc(dm->length);
 	if (data == NULL) {
-		printk(KERN_ERR "dmi_save_ipmi_device: out of memory.\n");
+		pr_err("dmi_save_ipmi_device: out of memory.\n");
 		return;
 	}
 
@@ -284,7 +286,7 @@ static void __init dmi_save_ipmi_device(
 
 	dev = dmi_alloc(sizeof(*dev));
 	if (!dev) {
-		printk(KERN_ERR "dmi_save_ipmi_device: out of memory.\n");
+		pr_err("dmi_save_ipmi_device: out of memory.\n");
 		return;
 	}
 
@@ -302,7 +304,7 @@ static void __init dmi_save_dev_onboard(
 
 	onboard_dev = dmi_alloc(sizeof(*onboard_dev) + strlen(name) + 1);
 	if (!onboard_dev) {
-		printk(KERN_ERR "dmi_save_dev_onboard: out of memory.\n");
+		pr_err("dmi_save_dev_onboard: out of memory.\n");
 		return;
 	}
 	onboard_dev->instance = instance;
@@ -320,7 +322,7 @@ static void __init dmi_save_dev_onboard(
 
 static void __init dmi_save_extended_devices(const struct dmi_header *dm)
 {
-	const u8 *d = (u8*) dm + 5;
+	const u8 *d = (u8 *) dm + 5;
 
 	/* Skip disabled device */
 	if ((*d & 0x80) == 0)
@@ -338,7 +340,7 @@ static void __init dmi_save_extended_dev
  */
 static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
 {
-	switch(dm->type) {
+	switch (dm->type) {
 	case 0:		/* BIOS Information */
 		dmi_save_ident(dm, DMI_BIOS_VENDOR, 4);
 		dmi_save_ident(dm, DMI_BIOS_VERSION, 5);
@@ -495,8 +497,7 @@ void __init dmi_scan_machine(void)
 			dmi_available = 1;
 			goto out;
 		}
-	}
-	else {
+	} else {
 		p = dmi_ioremap(0xF0000, 0x10000);
 		if (p == NULL)
 			goto error;
@@ -514,7 +515,7 @@ void __init dmi_scan_machine(void)
 		dmi_iounmap(p, 0x10000);
 	}
  error:
-	printk(KERN_INFO "DMI not present or invalid.\n");
+	pr_info("DMI not present or invalid.\n");
  out:
 	dmi_initialized = 1;
 }
@@ -650,7 +651,7 @@ int dmi_name_in_serial(const char *str)
 
 /**
  *	dmi_name_in_vendors - Check if string is in the DMI system or board vendor name
- *	@str: 	Case sensitive Name
+ *	@str: Case sensitive Name
  */
 int dmi_name_in_vendors(const char *str)
 {
@@ -677,13 +678,13 @@ EXPORT_SYMBOL(dmi_name_in_vendors);
  *	A new search is initiated by passing %NULL as the @from argument.
  *	If @from is not %NULL, searches continue from next device.
  */
-const struct dmi_device * dmi_find_device(int type, const char *name,
+const struct dmi_device *dmi_find_device(int type, const char *name,
 				    const struct dmi_device *from)
 {
 	const struct list_head *head = from ? &from->list : &dmi_devices;
 	struct list_head *d;
 
-	for(d = head->next; d != &dmi_devices; d = d->next) {
+	for (d = head->next; d != &dmi_devices; d = d->next) {
 		const struct dmi_device *dev =
 			list_entry(d, struct dmi_device, list);
 


-- 
Jean Delvare
Suse L3

