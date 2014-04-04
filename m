Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaDDWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:16:27 -0400
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:33863 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753447AbaDDWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:16:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3866:3867:4605:5007:6119:6261:6642:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12681:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ear06_71e5311351d4f
X-Filterd-Recvd-Size: 3531
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] usb: ftdi-elan: Use pr_<level>
Date: Fri,  4 Apr 2014 15:16:07 -0700
Message-Id: <f71532d26432d8474ff90b4691115f91edc4e99e.1396649386.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1396649386.git.joe@perches.com>
References: <cover.1396649386.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Add pr_fmt to prefix messages appropriately.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/ftdi-elan.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 10c54b3..8ab1f8f 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -35,6 +35,9 @@
  * via an ELAN U132 adapter.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -623,7 +626,7 @@ static int ftdi_elan_open(struct inode *inode, struct file *file)
 	interface = usb_find_interface(&ftdi_elan_driver, subminor);
 
 	if (!interface) {
-		printk(KERN_ERR "can't find device for minor %d\n", subminor);
+		pr_err("can't find device for minor %d\n", subminor);
 		return -ENODEV;
 	} else {
 		struct usb_ftdi *ftdi = usb_get_intfdata(interface);
@@ -2722,10 +2725,8 @@ static int ftdi_elan_probe(struct usb_interface *interface,
 	struct usb_ftdi *ftdi;
 
 	ftdi = kzalloc(sizeof(struct usb_ftdi), GFP_KERNEL);
-	if (!ftdi) {
-		printk(KERN_ERR "Out of memory\n");
+	if (!ftdi)
 		return -ENOMEM;
-	}
 
 	mutex_lock(&ftdi_module_lock);
 	list_add_tail(&ftdi->ftdi_list, &ftdi_static_list);
@@ -2849,7 +2850,7 @@ static struct usb_driver ftdi_elan_driver = {
 static int __init ftdi_elan_init(void)
 {
 	int result;
-	printk(KERN_INFO "driver %s\n", ftdi_elan_driver.name);
+	pr_info("driver %s\n", ftdi_elan_driver.name);
 	mutex_init(&ftdi_module_lock);
 	INIT_LIST_HEAD(&ftdi_static_list);
 	status_queue = create_singlethread_workqueue("ftdi-status-control");
@@ -2866,8 +2867,7 @@ static int __init ftdi_elan_init(void)
 		destroy_workqueue(status_queue);
 		destroy_workqueue(command_queue);
 		destroy_workqueue(respond_queue);
-		printk(KERN_ERR "usb_register failed. Error number %d\n",
-		       result);
+		pr_err("usb_register failed. Error number %d\n", result);
 	}
 	return result;
 
@@ -2876,7 +2876,7 @@ err_respond_queue:
 err_command_queue:
 	destroy_workqueue(status_queue);
 err_status_queue:
-	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
+	pr_err("%s couldn't create workqueue\n", ftdi_elan_driver.name);
 	return -ENOMEM;
 }
 
@@ -2885,7 +2885,7 @@ static void __exit ftdi_elan_exit(void)
 	struct usb_ftdi *ftdi;
 	struct usb_ftdi *temp;
 	usb_deregister(&ftdi_elan_driver);
-	printk(KERN_INFO "ftdi_u132 driver deregistered\n");
+	pr_info("ftdi_u132 driver deregistered\n");
 	list_for_each_entry_safe(ftdi, temp, &ftdi_static_list, ftdi_list) {
 		ftdi_status_cancel_work(ftdi);
 		ftdi_command_cancel_work(ftdi);
-- 
1.8.1.2.459.gbcd45b4.dirty

