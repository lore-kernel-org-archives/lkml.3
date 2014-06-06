Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaFFQPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:15:33 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42856 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaFFQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:15:31 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/13] staging: rtl8188eu: Remove rtw_deinit_intf_priv()
Date: Fri,  6 Jun 2014 21:45:10 +0530
Message-Id: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index c2e5276..f874270 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -62,15 +62,6 @@ static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 	return _SUCCESS;
 }

-static u8 rtw_deinit_intf_priv(struct dvobj_priv *dvobj)
-{
-	u8 rst = _SUCCESS;
-
-	kfree(dvobj->usb_vendor_req_buf);
-	mutex_destroy(&dvobj->usb_vendor_req_mutex);
-	return rst;
-}
-
 static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 {
 	int	i;
@@ -175,7 +166,9 @@ static void usb_dvobj_deinit(struct usb_interface *usb_intf)
 				usb_reset_device(interface_to_usbdev(usb_intf));
 			}
 		}
-		rtw_deinit_intf_priv(dvobj);
+
+		kfree(dvobj->usb_vendor_req_buf);
+		mutex_destroy(&dvobj->usb_vendor_req_mutex);
 		kfree(dvobj);
 	}

--
1.7.10.4

