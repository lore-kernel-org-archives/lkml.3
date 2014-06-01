Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaFAMSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:37 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59580 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFAMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/26] staging: rtl8188eu: Use module_usb_driver() macro
Date: Sun,  1 Jun 2014 17:46:34 +0530
Message-Id: <1401625013-11208-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index d33aeb9..21bf74d 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -718,24 +718,4 @@ static void rtw_dev_remove(struct usb_interface *pusb_intf)
 	return;
 }
 
-static int __init rtw_drv_entry(void)
-{
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_entry\n"));
-
-	DBG_88E(DRV_NAME " driver version=%s\n", DRIVERVERSION);
-
-	return usb_register(&rtl8188e_usb_drv);
-}
-
-static void __exit rtw_drv_halt(void)
-{
-	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_halt\n"));
-	DBG_88E("+rtw_drv_halt\n");
-
-	usb_deregister(&rtl8188e_usb_drv);
-
-	DBG_88E("-rtw_drv_halt\n");
-}
-
-module_init(rtw_drv_entry);
-module_exit(rtw_drv_halt);
+module_usb_driver(rtl8188e_usb_drv)
-- 
1.7.10.4

