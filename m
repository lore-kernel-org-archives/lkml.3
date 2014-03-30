Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaC3Tar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 15:30:47 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:36405 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaC3Taq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 15:30:46 -0400
From: Anders Darander <anders.darander@gmail.com>
To: gregkh@linuxfoundation.org
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Anders Darander <anders.darander@gmail.com>
Subject: [PATCH] Staging: ft1000-usb: fixed a few code style issues
Date: Sun, 30 Mar 2014 21:30:41 +0200
Message-Id: <1396207841-27933-1-git-send-email-anders.darander@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a few code style issues, particularly:

Add do {} while (0) wrapper around seq_* macros.
Change printk(KERN_WARN...) to netdev_warn(...).

Signed-off-by: Anders Darander <anders.darander@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 2575d0d..f2f30f6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -32,17 +32,20 @@
 
 
 #define seq_putx(m, message, size, var) \
-	seq_printf(m, message);	\
-	for (i = 0; i < (size - 1); i++) \
-		seq_printf(m, "%02x:", var[i]); \
-	seq_printf(m, "%02x\n", var[i])
+	do { \
+		seq_printf(m, message);	\
+		for (i = 0; i < (size - 1); i++) \
+			seq_printf(m, "%02x:", var[i]); \
+		seq_printf(m, "%02x\n", var[i]) \
+	while (0)
 
 #define seq_putd(m, message, size, var) \
-	seq_printf(m, message); \
-	for (i = 0; i < (size - 1); i++) \
-		seq_printf(m, "%d.", var[i]); \
-	seq_printf(m, "%d\n", var[i])
-
+	do { \
+		seq_printf(m, message); \
+		for (i = 0; i < (size - 1); i++) \
+			seq_printf(m, "%d.", var[i]); \
+		seq_printf(m, "%d\n", var[i]) \
+	while (0)
 
 #define FTNET_PROC init_net.proc_net
 
@@ -200,7 +203,7 @@ int ft1000_init_proc(struct net_device *dev)
 
 	info->ft1000_proc_dir = proc_mkdir(FT1000_PROC_DIR, FTNET_PROC);
 	if (info->ft1000_proc_dir == NULL) {
-		printk(KERN_WARNING "Unable to create %s dir.\n",
+		netdev_warn(dev,  "Unable to create %s dir.\n",
 			FT1000_PROC_DIR);
 		goto fail;
 	}
@@ -210,7 +213,7 @@ int ft1000_init_proc(struct net_device *dev)
 				 &ft1000_proc_fops, dev);
 
 	if (!ft1000_proc_file) {
-		printk(KERN_WARNING "Unable to create /proc entry.\n");
+		netdev_warn(dev, "Unable to create /proc entry.\n");
 		goto fail_entry;
 	}
 
-- 
1.9.1

