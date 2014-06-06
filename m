Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaFFQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:15:41 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58939 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaFFQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:15:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/13] staging: rtl8188eu: Remove rtw_init_intf_priv()
Date: Fri,  6 Jun 2014 21:45:11 +0530
Message-Id: <1402071320-14400-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index f874270..a84ee97 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -52,16 +52,6 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
 
 MODULE_DEVICE_TABLE(usb, rtw_usb_id_tbl);
 
-static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
-{
-	mutex_init(&dvobj->usb_vendor_req_mutex);
-	dvobj->usb_vendor_req_buf = rtw_zmalloc(MAX_USB_IO_CTL_SIZE);
-	if (!dvobj->usb_vendor_req_buf)
-		return _FAIL;
-
-	return _SUCCESS;
-}
-
 static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 {
 	int	i;
@@ -125,7 +115,10 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	else
 		pdvobjpriv->ishighspeed = false;
 
-	if (rtw_init_intf_priv(pdvobjpriv) == _FAIL)
+	mutex_init(&pdvobjpriv->usb_vendor_req_mutex);
+	pdvobjpriv->usb_vendor_req_buf = rtw_zmalloc(MAX_USB_IO_CTL_SIZE);
+
+	if (!pdvobjpriv->usb_vendor_req_buf)
 		goto free_dvobj;
 
 	rtw_reset_continual_urb_error(pdvobjpriv);
-- 
1.7.10.4

