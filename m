Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaFAMSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54895 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFAMS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:26 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/26] staging: rtl8188eu: Remove struct rtw_usb_drv
Date: Sun,  1 Jun 2014 17:46:33 +0530
Message-Id: <1401625013-11208-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct rtw_usb_drv contains only one member usb_driver structure,
so no use of keeping it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index c99b9c2..d33aeb9 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -60,22 +60,16 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
 
 MODULE_DEVICE_TABLE(usb, rtw_usb_id_tbl);
 
-struct rtw_usb_drv {
-	struct usb_driver usbdrv;
+static struct usb_driver rtl8188e_usb_drv = {
+	.name = "r8188eu",
+	.probe = rtw_drv_init,
+	.disconnect = rtw_dev_remove,
+	.id_table = rtw_usb_id_tbl,
+	.suspend =  rtw_suspend,
+	.resume = rtw_resume,
+	.reset_resume = rtw_resume,
 };
 
-static struct rtw_usb_drv rtl8188e_usb_drv = {
-	.usbdrv.name = "r8188eu",
-	.usbdrv.probe = rtw_drv_init,
-	.usbdrv.disconnect = rtw_dev_remove,
-	.usbdrv.id_table = rtw_usb_id_tbl,
-	.usbdrv.suspend =  rtw_suspend,
-	.usbdrv.resume = rtw_resume,
-	.usbdrv.reset_resume   = rtw_resume,
-};
-
-static struct rtw_usb_drv *usb_drv = &rtl8188e_usb_drv;
-
 static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 {
 	u8 rst = _SUCCESS;
@@ -730,7 +724,7 @@ static int __init rtw_drv_entry(void)
 
 	DBG_88E(DRV_NAME " driver version=%s\n", DRIVERVERSION);
 
-	return usb_register(&usb_drv->usbdrv);
+	return usb_register(&rtl8188e_usb_drv);
 }
 
 static void __exit rtw_drv_halt(void)
@@ -738,7 +732,7 @@ static void __exit rtw_drv_halt(void)
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_halt\n"));
 	DBG_88E("+rtw_drv_halt\n");
 
-	usb_deregister(&usb_drv->usbdrv);
+	usb_deregister(&rtl8188e_usb_drv);
 
 	DBG_88E("-rtw_drv_halt\n");
 }
-- 
1.7.10.4

