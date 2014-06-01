Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaFAMSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:42 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48686 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFAMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/26] staging: rtl8188eu: Remove function declarations in usb_intf.c
Date: Sun,  1 Jun 2014 17:46:35 +0530
Message-Id: <1401625013-11208-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   28 ++++++++++-----------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 21bf74d..45d2608 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -35,14 +35,6 @@
 
 int ui_pid[3] = {0, 0, 0};
 
-static int rtw_suspend(struct usb_interface *intf, pm_message_t message);
-static int rtw_resume(struct usb_interface *intf);
-
-
-static int rtw_drv_init(struct usb_interface *pusb_intf, const struct usb_device_id *pdid);
-static void rtw_dev_remove(struct usb_interface *pusb_intf);
-
-
 #define USB_VENDER_ID_REALTEK		0x0bda
 
 /* DID_USB_v916_20130116 */
@@ -60,16 +52,6 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
 
 MODULE_DEVICE_TABLE(usb, rtw_usb_id_tbl);
 
-static struct usb_driver rtl8188e_usb_drv = {
-	.name = "r8188eu",
-	.probe = rtw_drv_init,
-	.disconnect = rtw_dev_remove,
-	.id_table = rtw_usb_id_tbl,
-	.suspend =  rtw_suspend,
-	.resume = rtw_resume,
-	.reset_resume = rtw_resume,
-};
-
 static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 {
 	u8 rst = _SUCCESS;
@@ -718,4 +700,14 @@ static void rtw_dev_remove(struct usb_interface *pusb_intf)
 	return;
 }
 
+static struct usb_driver rtl8188e_usb_drv = {
+	.name = "r8188eu",
+	.probe = rtw_drv_init,
+	.disconnect = rtw_dev_remove,
+	.id_table = rtw_usb_id_tbl,
+	.suspend =  rtw_suspend,
+	.resume = rtw_resume,
+	.reset_resume = rtw_resume,
+};
+
 module_usb_driver(rtl8188e_usb_drv)
-- 
1.7.10.4

