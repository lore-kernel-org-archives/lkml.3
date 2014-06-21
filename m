Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbaFUMuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:50:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57889 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934520AbaFUMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:50:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 2/7] staging: rtl8188eu: Remove macros specific to kernel version < 2.6.12
Date: Sat, 21 Jun 2014 18:19:32 +0530
Message-Id: <1403354977-23644-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
References: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/usb_ops.h |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/usb_ops.h b/drivers/staging/rtl8188eu/include/usb_ops.h
index ff730f4..e10b711 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops.h
@@ -38,7 +38,6 @@ enum{
 #define MAX_VENDOR_REQ_CMD_SIZE	254	/* 8188cu SIE Support */
 #define MAX_USB_IO_CTL_SIZE	(MAX_VENDOR_REQ_CMD_SIZE + ALIGNMENT_UNIT)
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 12))
 #define rtw_usb_control_msg(dev, pipe, request, requesttype,		\
 			    value, index, data, size, timeout_ms)	\
 	usb_control_msg((dev), (pipe), (request), (requesttype), (value),\
@@ -46,20 +45,7 @@ enum{
 #define rtw_usb_bulk_msg(usb_dev, pipe, data, len, actual_length, timeout_ms) \
 	usb_bulk_msg((usb_dev), (pipe), (data), (len),			\
 		     (actual_length), (timeout_ms))
-#else
-#define rtw_usb_control_msg(dev, pipe, request, requesttype,		\
-			    value, index, data, size, timeout_ms)	\
-	usb_control_msg((dev), (pipe), (request), (requesttype),	\
-			(value), (index), (data), (size),		\
-			((timeout_ms) == 0) ||				\
-			((timeout_ms)*HZ/1000 > 0) ?			\
-			((timeout_ms)*HZ/1000) : 1)
-#define rtw_usb_bulk_msg(usb_dev, pipe, data, len,			\
-			 actual_length, timeout_ms) \
-	usb_bulk_msg((usb_dev), (pipe), (data), (len), (actual_length), \
-		     ((timeout_ms) == 0) || ((timeout_ms)*HZ/1000 > 0) ?\
-		     ((timeout_ms)*HZ/1000) : 1)
-#endif
+
 #include <usb_ops_linux.h>
 
 void rtl8188eu_set_hw_type(struct adapter *padapter);
-- 
1.7.10.4

