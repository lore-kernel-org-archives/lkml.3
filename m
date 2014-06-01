Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbaFAMTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:12 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53473 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaFAMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/26] staging: rtl8188eu: Remove usb_suspend_sema from struct dvobj_priv
Date: Sun,  1 Jun 2014 17:46:39 +0530
Message-Id: <1401625013-11208-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 3181418..c441d46 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -170,7 +170,6 @@ struct dvobj_priv {
 	u8	RtNumInPipes;
 	u8	RtNumOutPipes;
 	int	ep_num[5]; /* endpoint number */
-	struct semaphore usb_suspend_sema;
 	struct mutex  usb_vendor_req_mutex;
 
 	u8 *usb_alloc_vendor_req_buf;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 45d2608..2333fa6 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -144,7 +144,6 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	if (rtw_init_intf_priv(pdvobjpriv) == _FAIL)
 		goto free_dvobj;
 
-	sema_init(&(pdvobjpriv->usb_suspend_sema), 0);
 	rtw_reset_continual_urb_error(pdvobjpriv);
 
 	usb_get_dev(pusbd);
-- 
1.7.10.4

