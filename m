Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaFAMSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:16 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42609 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFAMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/26] staging: rtl8188eu: Use unregistering flag from struct usb_interface
Date: Sun,  1 Jun 2014 17:46:31 +0530
Message-Id: <1401625013-11208-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use unregistering flag from struct usb_interface to find
driver registration status.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 523d500..1841d54 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -707,7 +707,7 @@ static void rtw_dev_remove(struct usb_interface *pusb_intf)
 	DBG_88E("+rtw_dev_remove\n");
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+dev_remove()\n"));
 
-	if (usb_drv->drv_registered)
+	if (!pusb_intf->unregistering)
 		padapter->bSurpriseRemoved = true;
 
 	rtw_pm_set_ips(padapter, IPS_NONE);
-- 
1.7.10.4

