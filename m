Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbaFKRYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:24:39 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37519 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFKRYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:24:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 22/22] staging: rtl8188eu: Remove empty files rtw_io.[c,h]
Date: Wed, 11 Jun 2014 22:51:41 +0530
Message-Id: <1402507301-3722-22-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile               |    1 -
 drivers/staging/rtl8188eu/core/rtw_io.c          |   53 ----------------------
 drivers/staging/rtl8188eu/include/drv_types.h    |    1 -
 drivers/staging/rtl8188eu/include/rtw_io.h       |   36 ---------------
 drivers/staging/rtl8188eu/os_dep/os_intfs.c      |    1 +
 drivers/staging/rtl8188eu/os_dep/osdep_service.c |    1 +
 6 files changed, 2 insertions(+), 91 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_io.c
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_io.h

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 450394e..2654bf8 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -20,7 +20,6 @@ r8188eu-y :=				\
 		core/rtw_debug.o	\
 		core/rtw_efuse.o	\
 		core/rtw_ieee80211.o	\
-		core/rtw_io.o		\
 		core/rtw_ioctl_set.o	\
 		core/rtw_iol.o		\
 		core/rtw_led.o		\
diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
deleted file mode 100644
index dd56896..0000000
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ /dev/null
@@ -1,53 +0,0 @@
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
-/*
-
-The purpose of rtw_io.c
-
-a. provides the API
-
-b. provides the protocol engine
-
-c. provides the software interface between caller and the hardware interface
-
-
-Compiler Flag Option:
-
-USB:
-   a. USE_ASYNC_IRP: Both sync/async operations are provided.
-
-Only sync read/rtw_write_mem operations are provided.
-
-jackson@realtek.com.tw
-
-*/
-
-#define _RTW_IO_C_
-#include <osdep_service.h>
-#include <drv_types.h>
-#include <rtw_io.h>
-#include <osdep_intf.h>
-#include <usb_ops.h>
-
-#define rtw_le16_to_cpu(val)		le16_to_cpu(val)
-#define rtw_le32_to_cpu(val)		le32_to_cpu(val)
-#define rtw_cpu_to_le16(val)		cpu_to_le16(val)
-#define rtw_cpu_to_le32(val)		cpu_to_le32(val)
-
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 8063caa..9c3f905 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -40,7 +40,6 @@
 #include <rtw_qos.h>
 #include <rtw_security.h>
 #include <rtw_pwrctrl.h>
-#include <rtw_io.h>
 #include <rtw_eeprom.h>
 #include <sta_info.h>
 #include <rtw_mlme.h>
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
deleted file mode 100644
index a9a6d19..0000000
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ /dev/null
@@ -1,36 +0,0 @@
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
-
-#ifndef _RTW_IO_H_
-#define _RTW_IO_H_
-
-#include <osdep_service.h>
-#include <osdep_intf.h>
-
-#include <asm/byteorder.h>
-#include <linux/semaphore.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/atomic.h>
-
-#include <linux/usb.h>
-#include <linux/usb/ch9.h>
-
-#endif	/* _RTL8711_IO_H_ */
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 1d961bd..34f7370 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -20,6 +20,7 @@
 #define _OS_INTFS_C_
 
 #include <osdep_service.h>
+#include <osdep_intf.h>
 #include <drv_types.h>
 #include <xmit_osdep.h>
 #include <recv_osdep.h>
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 2579a40..9b76e08 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -22,6 +22,7 @@
 #define _OSDEP_SERVICE_C_
 
 #include <osdep_service.h>
+#include <osdep_intf.h>
 #include <drv_types.h>
 #include <recv_osdep.h>
 #include <linux/vmalloc.h>
-- 
1.7.10.4

