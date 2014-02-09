Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaBIImJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:42:09 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33153 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBIImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:42:08 -0500
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 3/3] staging: rtl8188eu: remove header file ethernet.h
Date: Sun,  9 Feb 2014 14:10:46 +0530
Message-Id: <1391935247-3797-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391935247-3797-1-git-send-email-navin.patidar@gmail.com>
References: <1391935247-3797-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ethernet.h" is included in three files but only "rtw_recv.c" using two macros
defined in "ethernet.h", so move used macros in "rtw_recv.c" and
remove "include/ethernet.h" header file and inclusion of this header file.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c      |    4 ++-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
 drivers/staging/rtl8188eu/include/ethernet.h   |   42 ------------------------
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    1 -
 4 files changed, 3 insertions(+), 45 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/ethernet.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index b49a246..b9d86cd 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -23,10 +23,12 @@
 #include <drv_types.h>
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
-#include <ethernet.h>
 #include <usb_ops.h>
 #include <wifi.h>

+#define ETHERNET_HEADER_SIZE	14	/*  Ethernet Header Length */
+#define LLC_HEADER_SIZE			6	/*  LLC Header Length */
+
 static u8 SNAP_ETH_TYPE_IPX[2] = {0x81, 0x37};
 static u8 SNAP_ETH_TYPE_APPLETALK_AARP[2] = {0x80, 0xf3};

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 540c5ad..b1b1584 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -22,7 +22,6 @@
 #include <drv_types.h>
 #include <recv_osdep.h>
 #include <mlme_osdep.h>
-#include <ethernet.h>

 #include <usb_ops.h>
 #include <wifi.h>
diff --git a/drivers/staging/rtl8188eu/include/ethernet.h b/drivers/staging/rtl8188eu/include/ethernet.h
deleted file mode 100644
index a59f912..0000000
--- a/drivers/staging/rtl8188eu/include/ethernet.h
+++ /dev/null
@@ -1,42 +0,0 @@
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
-/*! \file */
-#ifndef __INC_ETHERNET_H
-#define __INC_ETHERNET_H
-
-#define ETHERNET_ADDRESS_LENGTH		6	/*  Ethernet Address Length */
-#define ETHERNET_HEADER_SIZE		14	/*  Ethernet Header Length */
-#define LLC_HEADER_SIZE			6	/*  LLC Header Length */
-#define TYPE_LENGTH_FIELD_SIZE		2	/*  Type/Length Size */
-#define MINIMUM_ETHERNET_PACKET_SIZE	60	/*  Min Ethernet Packet Size */
-#define MAXIMUM_ETHERNET_PACKET_SIZE	1514	/*  Max Ethernet Packet Size */
-
-/*  Is Multicast Address? */
-#define RT_ETH_IS_MULTICAST(_addr)	((((u8 *)(_addr))[0]&0x01) != 0)
-#define RT_ETH_IS_BROADCAST(_addr)	(			\
-		((u8 *)(_addr))[0] == 0xff &&		\
-		((u8 *)(_addr))[1] == 0xff &&		\
-		((u8 *)(_addr))[2] == 0xff &&		\
-		((u8 *)(_addr))[3] == 0xff &&		\
-		((u8 *)(_addr))[4] == 0xff &&		\
-		((u8 *)(_addr))[5] == 0xff)	/*  Is Broadcast Address? */
-
-
-#endif /*  #ifndef __INC_ETHERNET_H */
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 2a18b32..b4f44f2 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -26,7 +26,6 @@
 #include <recv_osdep.h>

 #include <osdep_intf.h>
-#include <ethernet.h>
 #include <usb_ops.h>

 /* init os related resource in struct recv_priv */
--
1.7.10.4

