Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402AbaE2Rzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:55:51 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45387 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbaE2Rzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:55:50 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/18] staging: rtl8188eu: Remove usb_vendor_req.h header file
Date: Thu, 29 May 2014 23:20:58 +0530
Message-Id: <1401385858-28722-18-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver doesn't need usb_vendor_req.h.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/usb_osintf.h     |    1 -
 drivers/staging/rtl8188eu/include/usb_vendor_req.h |   52 --------------------
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |    1 -
 3 files changed, 54 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_vendor_req.h

diff --git a/drivers/staging/rtl8188eu/include/usb_osintf.h b/drivers/staging/rtl8188eu/include/usb_osintf.h
index 2dce3bf..292ded7 100644
--- a/drivers/staging/rtl8188eu/include/usb_osintf.h
+++ b/drivers/staging/rtl8188eu/include/usb_osintf.h
@@ -22,7 +22,6 @@
 
 #include <osdep_service.h>
 #include <drv_types.h>
-#include <usb_vendor_req.h>
 
 extern char *rtw_initmac;
 extern int rtw_mc2u_disable;
diff --git a/drivers/staging/rtl8188eu/include/usb_vendor_req.h b/drivers/staging/rtl8188eu/include/usb_vendor_req.h
deleted file mode 100644
index 7f26c8f..0000000
--- a/drivers/staging/rtl8188eu/include/usb_vendor_req.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-#ifndef _USB_VENDOR_REQUEST_H_
-#define _USB_VENDOR_REQUEST_H_
-
-/* 4	Set/Get Register related wIndex/Data */
-#define	RT_USB_RESET_MASK_OFF		0
-#define	RT_USB_RESET_MASK_ON		1
-#define	RT_USB_SLEEP_MASK_OFF		0
-#define	RT_USB_SLEEP_MASK_ON		1
-#define	RT_USB_LDO_ON				1
-#define	RT_USB_LDO_OFF				0
-
-/* 4	Set/Get SYSCLK related	wValue or Data */
-#define	RT_USB_SYSCLK_32KHZ		0
-#define	RT_USB_SYSCLK_40MHZ		1
-#define	RT_USB_SYSCLK_60MHZ		2
-
-
-enum bt_usb_request {
-	RT_USB_SET_REGISTER		= 1,
-	RT_USB_SET_SYSCLK		= 2,
-	RT_USB_GET_SYSCLK		= 3,
-	RT_USB_GET_REGISTER		= 4
-};
-
-enum rt_usb_wvalue {
-	RT_USB_RESET_MASK	=	1,
-	RT_USB_SLEEP_MASK	=	2,
-	RT_USB_USB_HRCPWM	=	3,
-	RT_USB_LDO			=	4,
-	RT_USB_BOOT_TYPE	=	5
-};
-
-#endif
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 7526b98..05dce99 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -29,7 +29,6 @@
 #include <linux/vmalloc.h>
 #include <osdep_intf.h>
 
-#include <usb_vendor_req.h>
 #include <usb_ops.h>
 #include <usb_osintf.h>
 #include <usb_hal.h>
-- 
1.7.10.4

