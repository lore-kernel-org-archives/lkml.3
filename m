Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaFAMSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:23 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50103 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFAMST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/26] staging : rtl8188eu: Remove drv_registered from struct rtw_usb_drv
Date: Sun,  1 Jun 2014 17:46:32 +0530
Message-Id: <1401625013-11208-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 1841d54..c99b9c2 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -62,7 +62,6 @@ MODULE_DEVICE_TABLE(usb, rtw_usb_id_tbl);
 
 struct rtw_usb_drv {
 	struct usb_driver usbdrv;
-	int drv_registered;
 };
 
 static struct rtw_usb_drv rtl8188e_usb_drv = {
@@ -731,7 +730,6 @@ static int __init rtw_drv_entry(void)
 
 	DBG_88E(DRV_NAME " driver version=%s\n", DRIVERVERSION);
 
-	usb_drv->drv_registered = true;
 	return usb_register(&usb_drv->usbdrv);
 }
 
@@ -740,7 +738,6 @@ static void __exit rtw_drv_halt(void)
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_halt\n"));
 	DBG_88E("+rtw_drv_halt\n");
 
-	usb_drv->drv_registered = false;
 	usb_deregister(&usb_drv->usbdrv);
 
 	DBG_88E("-rtw_drv_halt\n");
-- 
1.7.10.4

