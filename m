Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3LFD7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:59:40 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:32830 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3LFD7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:59:37 -0500
From: learc83 <learc83@gmail.com>
To: duncan.sands@free.fr
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, learc83 <learc83@gmail.com>
Subject: [PATCH] Usb: atm: usbatm: fixed a pointer variable format issue
Date: Thu,  5 Dec 2013 22:59:23 -0500
Message-Id: <1386302363-10975-1-git-send-email-learc83@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a pointer variable format issue.

Signed-off-by: Seth Archer Brown <learc83@gmail.com>
---
 drivers/usb/atm/usbatm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index 25a7bfc..dada014 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -170,9 +170,9 @@ struct usbatm_control {
 static void usbatm_atm_dev_close(struct atm_dev *atm_dev);
 static int usbatm_atm_open(struct atm_vcc *vcc);
 static void usbatm_atm_close(struct atm_vcc *vcc);
-static int usbatm_atm_ioctl(struct atm_dev *atm_dev, unsigned int cmd, void __user * arg);
+static int usbatm_atm_ioctl(struct atm_dev *atm_dev, unsigned int cmd, void __user *arg);
 static int usbatm_atm_send(struct atm_vcc *vcc, struct sk_buff *skb);
-static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t * pos, char *page);
+static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t *pos, char *page);
 
 static struct atmdev_ops usbatm_atm_devops = {
 	.dev_close	= usbatm_atm_dev_close,
@@ -739,7 +739,7 @@ static void usbatm_atm_dev_close(struct atm_dev *atm_dev)
 	usbatm_put_instance(instance);	/* taken in usbatm_atm_init */
 }
 
-static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t * pos, char *page)
+static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t *pos, char *page)
 {
 	struct usbatm_data *instance = atm_dev->dev_data;
 	int left = *pos;
@@ -895,7 +895,7 @@ static void usbatm_atm_close(struct atm_vcc *vcc)
 }
 
 static int usbatm_atm_ioctl(struct atm_dev *atm_dev, unsigned int cmd,
-			  void __user * arg)
+			  void __user *arg)
 {
 	struct usbatm_data *instance = atm_dev->dev_data;
 
-- 
1.7.10.4

