Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbaFAMTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:18 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52897 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaFAMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:15 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/26] staging: rtl8188eu: Remove usb_alloc_vendor_req_buf from struct dvobj_priv
Date: Sun,  1 Jun 2014 17:46:40 +0530
Message-Id: <1401625013-11208-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |   17 +++++------------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index c441d46..7586de71 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -172,7 +172,6 @@ struct dvobj_priv {
 	int	ep_num[5]; /* endpoint number */
 	struct mutex  usb_vendor_req_mutex;
 
-	u8 *usb_alloc_vendor_req_buf;
 	u8 *usb_vendor_req_buf;
 
 	struct usb_interface *pusbintf;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 2333fa6..1265a47 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -54,26 +54,19 @@ MODULE_DEVICE_TABLE(usb, rtw_usb_id_tbl);
 
 static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 {
-	u8 rst = _SUCCESS;
-
 	mutex_init(&dvobj->usb_vendor_req_mutex);
+	dvobj->usb_vendor_req_buf = rtw_zmalloc(MAX_USB_IO_CTL_SIZE);
+	if (!dvobj->usb_vendor_req_buf)
+		return _FAIL;
 
-	dvobj->usb_alloc_vendor_req_buf = rtw_zmalloc(MAX_USB_IO_CTL_SIZE);
-	if (dvobj->usb_alloc_vendor_req_buf == NULL) {
-		DBG_88E("alloc usb_vendor_req_buf failed...\n");
-		rst = _FAIL;
-		goto exit;
-	}
-	dvobj->usb_vendor_req_buf = (u8 *)N_BYTE_ALIGMENT((size_t)(dvobj->usb_alloc_vendor_req_buf), ALIGNMENT_UNIT);
-exit:
-	return rst;
+	return _SUCCESS;
 }
 
 static u8 rtw_deinit_intf_priv(struct dvobj_priv *dvobj)
 {
 	u8 rst = _SUCCESS;
 
-	kfree(dvobj->usb_alloc_vendor_req_buf);
+	kfree(dvobj->usb_vendor_req_buf);
 	mutex_destroy(&dvobj->usb_vendor_req_mutex);
 	return rst;
 }
-- 
1.7.10.4

