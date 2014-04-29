Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaD2BZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:25:30 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42571 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaD2BZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:25:29 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 1/2] staging: rtl8188eu: Remove debugging messages from  usb_dvobj_init()
Date: Tue, 29 Apr 2014 06:55:12 +0530
Message-Id: <1398734713-4367-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unnecessary debugging messages are removed from usb_dvobj_init().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   34 +++------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 49a4ce4..8a52829 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -187,30 +187,13 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 		if (phost_endp) {
 			pendp_desc = &phost_endp->desc;
 
-			DBG_88E("\nusb_endpoint_descriptor(%d):\n", i);
-			DBG_88E("bLength=%x\n", pendp_desc->bLength);
-			DBG_88E("bDescriptorType=%x\n",
-				pendp_desc->bDescriptorType);
-			DBG_88E("bEndpointAddress=%x\n",
-				pendp_desc->bEndpointAddress);
-			DBG_88E("wMaxPacketSize=%d\n",
-				le16_to_cpu(pendp_desc->wMaxPacketSize));
-			DBG_88E("bInterval=%x\n", pendp_desc->bInterval);
-
 			if (RT_usb_endpoint_is_bulk_in(pendp_desc)) {
-				DBG_88E("RT_usb_endpoint_is_bulk_in = %x\n",
-					RT_usb_endpoint_num(pendp_desc));
 				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = RT_usb_endpoint_num(pendp_desc);
 				pdvobjpriv->RtNumInPipes++;
 			} else if (usb_endpoint_is_int(pendp_desc)) {
-				DBG_88E("usb_endpoint_is_int = %x, Interval = %x\n",
-					RT_usb_endpoint_num(pendp_desc),
-					pendp_desc->bInterval);
 				pdvobjpriv->RtInPipe[pdvobjpriv->RtNumInPipes] = RT_usb_endpoint_num(pendp_desc);
 				pdvobjpriv->RtNumInPipes++;
 			} else if (RT_usb_endpoint_is_bulk_out(pendp_desc)) {
-				DBG_88E("RT_usb_endpoint_is_bulk_out = %x\n",
-					RT_usb_endpoint_num(pendp_desc));
 				pdvobjpriv->RtOutPipe[pdvobjpriv->RtNumOutPipes] = RT_usb_endpoint_num(pendp_desc);
 				pdvobjpriv->RtNumOutPipes++;
 			}
@@ -218,25 +201,14 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 		}
 	}
 
-	DBG_88E("nr_endpoint=%d, in_num=%d, out_num=%d\n\n",
-		pdvobjpriv->nr_endpoint, pdvobjpriv->RtNumInPipes,
-		pdvobjpriv->RtNumOutPipes);
-
-	if (pusbd->speed == USB_SPEED_HIGH) {
+	if (pusbd->speed == USB_SPEED_HIGH)
 		pdvobjpriv->ishighspeed = true;
-		DBG_88E("USB_SPEED_HIGH\n");
-	} else {
+	else
 		pdvobjpriv->ishighspeed = false;
-		DBG_88E("NON USB_SPEED_HIGH\n");
-	}
 
-	if (rtw_init_intf_priv(pdvobjpriv) == _FAIL) {
-		RT_TRACE(_module_os_intfs_c_, _drv_err_,
-			 ("\n Can't INIT rtw_init_intf_priv\n"));
+	if (rtw_init_intf_priv(pdvobjpriv) == _FAIL)
 		goto free_dvobj;
-	}
 
-	/* 3 misc */
 	sema_init(&(pdvobjpriv->usb_suspend_sema), 0);
 	rtw_reset_continual_urb_error(pdvobjpriv);
 
-- 
1.7.10.4

