Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962AbaFUMvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:51:22 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45564 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934914AbaFUMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:51:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 7/7] staging: rtl8188eu: Merge usb_ops.h into usb_ops_linux.h
Date: Sat, 21 Jun 2014 18:19:37 +0530
Message-Id: <1403354977-23644-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
References: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |    1 -
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    1 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    2 -
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    1 -
 drivers/staging/rtl8188eu/include/usb_ops.h       |   55 ---------------------
 drivers/staging/rtl8188eu/include/usb_ops_linux.h |   25 ++++++++++
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c     |    2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |    2 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |    1 -
 13 files changed, 29 insertions(+), 67 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_ops.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index f1398ab..3dea17f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -26,7 +26,6 @@
 #include <hal_intf.h>
 
 #include <usb_osintf.h>
-#include <usb_ops.h>
 
 extern void indicate_wx_scan_complete_event(struct adapter *padapter);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 0e73df5..eaf43f2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -23,7 +23,6 @@
 #include <drv_types.h>
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
-#include <usb_ops.h>
 #include <wifi.h>
 #include <linux/vmalloc.h>
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index a113f0f..eb938a5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -23,7 +23,6 @@
 #include <drv_types.h>
 #include <wifi.h>
 #include <osdep_intf.h>
-#include <usb_ops.h>
 #include <usb_osintf.h>
 #include <linux/vmalloc.h>
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 7ea0320..4d3ea7c 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -28,8 +28,6 @@
 
 #include <rtw_iol.h>
 
-#include <usb_ops.h>
-
 void iol_mode_enable(struct adapter *padapter, u8 enable)
 {
 	u8 reg_0xf0 = 0;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 0f6222d..32e59c5 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -23,7 +23,7 @@
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
 
-#include <usb_ops.h>
+#include <usb_ops_linux.h>
 #include <wifi.h>
 
 #include <rtl8188e_hal.h>
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 4bc2ce0..3112e6c 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -22,7 +22,7 @@
 #include <drv_types.h>
 #include <wifi.h>
 #include <osdep_intf.h>
-#include <usb_ops.h>
+#include <usb_ops_linux.h>
 #include <rtl8188e_hal.h>
 
 s32	rtl8188eu_init_xmit_priv(struct adapter *adapt)
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 03701ca..8c26d0a 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -26,7 +26,6 @@
 #include <rtl8188e_hal.h>
 #include <rtl8188e_led.h>
 #include <rtw_iol.h>
-#include <usb_ops.h>
 #include <usb_hal.h>
 #include <usb_osintf.h>
 
diff --git a/drivers/staging/rtl8188eu/include/usb_ops.h b/drivers/staging/rtl8188eu/include/usb_ops.h
deleted file mode 100644
index ea23b459..0000000
--- a/drivers/staging/rtl8188eu/include/usb_ops.h
+++ /dev/null
@@ -1,55 +0,0 @@
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
-#ifndef __USB_OPS_H_
-#define __USB_OPS_H_
-
-#include <linux/version.h>
-#include <osdep_service.h>
-#include <drv_types.h>
-#include <osdep_intf.h>
-
-#define REALTEK_USB_VENQT_READ		0xC0
-#define REALTEK_USB_VENQT_WRITE		0x40
-
-#define ALIGNMENT_UNIT			16
-#define MAX_VENDOR_REQ_CMD_SIZE	254	/* 8188cu SIE Support */
-#define MAX_USB_IO_CTL_SIZE	(MAX_VENDOR_REQ_CMD_SIZE + ALIGNMENT_UNIT)
-
-#include <usb_ops_linux.h>
-
-#define USB_HIGH_SPEED_BULK_SIZE	512
-#define USB_FULL_SPEED_BULK_SIZE	64
-
-static inline u8 rtw_usb_bulk_size_boundary(struct adapter *padapter,
-					    int buf_len)
-{
-	u8 rst = true;
-	struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
-
-	if (pdvobjpriv->ishighspeed)
-		rst = (0 == (buf_len) % USB_HIGH_SPEED_BULK_SIZE) ?
-		      true : false;
-	else
-		rst = (0 == (buf_len) % USB_FULL_SPEED_BULK_SIZE) ?
-		      true : false;
-	return rst;
-}
-
-#endif /* __USB_OPS_H_ */
diff --git a/drivers/staging/rtl8188eu/include/usb_ops_linux.h b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
index 5fc4247..01b3810 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops_linux.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
@@ -29,6 +29,16 @@
 
 #define RTW_USB_BULKOUT_TIME	5000/* ms */
 
+#define REALTEK_USB_VENQT_READ		0xC0
+#define REALTEK_USB_VENQT_WRITE		0x40
+
+#define ALIGNMENT_UNIT			16
+#define MAX_VENDOR_REQ_CMD_SIZE	254	/* 8188cu SIE Support */
+#define MAX_USB_IO_CTL_SIZE	(MAX_VENDOR_REQ_CMD_SIZE + ALIGNMENT_UNIT)
+
+#define USB_HIGH_SPEED_BULK_SIZE	512
+#define USB_FULL_SPEED_BULK_SIZE	64
+
 #define _usbctrl_vendorreq_async_callback(urb, regs)	\
 	_usbctrl_vendorreq_async_callback(urb)
 #define usb_bulkout_zero_complete(purb, regs)		\
@@ -42,6 +52,21 @@
 #define usb_read_interrupt_complete(purb, regs)		\
 	usb_read_interrupt_complete(purb)
 
+static inline u8 rtw_usb_bulk_size_boundary(struct adapter *padapter,
+					    int buf_len)
+{
+	u8 rst = true;
+	struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
+
+	if (pdvobjpriv->ishighspeed)
+		rst = (0 == (buf_len) % USB_HIGH_SPEED_BULK_SIZE) ?
+		      true : false;
+	else
+		rst = (0 == (buf_len) % USB_FULL_SPEED_BULK_SIZE) ?
+		      true : false;
+	return rst;
+}
+
 unsigned int ffaddr2pipehdl(struct dvobj_priv *pdvobj, u32 addr);
 
 u8 usb_read8(struct adapter *adapter, u32 addr);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 56e24fa..9b5c549 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -29,7 +29,6 @@
 #include <rtw_ioctl.h>
 #include <rtw_ioctl_set.h>
 #include <rtw_mp_ioctl.h>
-#include <usb_ops.h>
 #include <rtl8188e_hal.h>
 
 #include <rtw_mp.h>
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 64dfc02..632ed82 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -26,7 +26,7 @@
 #include <recv_osdep.h>
 
 #include <osdep_intf.h>
-#include <usb_ops.h>
+#include <usb_ops_linux.h>
 
 /* alloc os related resource in struct recv_frame */
 int rtw_os_recv_resource_alloc(struct adapter *padapter,
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 4af2c95..714c14e 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -28,7 +28,7 @@
 #include <linux/vmalloc.h>
 #include <osdep_intf.h>
 
-#include <usb_ops.h>
+#include <usb_ops_linux.h>
 #include <usb_osintf.h>
 #include <usb_hal.h>
 #include <rtw_ioctl.h>
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index ad7c48e..9e8b8c1 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -19,7 +19,6 @@
 #define _USB_OPS_LINUX_C_
 
 #include <drv_types.h>
-#include <usb_ops.h>
 #include <recv_osdep.h>
 #include <rtw_sreset.h>
 
-- 
1.7.10.4

