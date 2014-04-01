Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaDAGaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:30:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41998 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaDAGaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:30:10 -0400
From: Anders Darander <anders.darander@gmail.com>
To: gregkh@linuxfoundation.org
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Anders Darander <anders.darander@gmail.com>
Subject: [PATCH] Staging: ft1000-usb: use netdev_warn
Date: Tue,  1 Apr 2014 08:29:40 +0200
Message-Id: <1396333780-10228-2-git-send-email-anders.darander@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396333780-10228-1-git-send-email-anders.darander@gmail.com>
References: <1396333780-10228-1-git-send-email-anders.darander@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue by replacing printk with netdev_warn.

Signed-off-by: Anders Darander <anders.darander@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 28f07a7..e89b5d2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -203,7 +203,7 @@ int ft1000_init_proc(struct net_device *dev)
 
 	info->ft1000_proc_dir = proc_mkdir(FT1000_PROC_DIR, FTNET_PROC);
 	if (info->ft1000_proc_dir == NULL) {
-		printk(KERN_WARNING "Unable to create %s dir.\n",
+		netdev_warn(dev, "Unable to create %s dir.\n",
 			FT1000_PROC_DIR);
 		goto fail;
 	}
@@ -213,7 +213,7 @@ int ft1000_init_proc(struct net_device *dev)
 				 &ft1000_proc_fops, dev);
 
 	if (!ft1000_proc_file) {
-		printk(KERN_WARNING "Unable to create /proc entry.\n");
+		netdev_warn(dev, "Unable to create /proc entry.\n");
 		goto fail_entry;
 	}
 
-- 
1.9.1

