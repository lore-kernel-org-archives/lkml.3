Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaFPQHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:07:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48349 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaFPQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:07:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 9/9] staging: rtl8188eu: Remove file rtw_br_ext.h
Date: Mon, 16 Jun 2014 21:35:46 +0530
Message-Id: <1402934746-29422-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
References: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver doesn't need rtw_br_ext.h any more.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c       |    1 -
 drivers/staging/rtl8188eu/include/drv_types.h  |    1 -
 drivers/staging/rtl8188eu/include/rtw_br_ext.h |   64 ------------------------
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |    1 -
 4 files changed, 67 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_br_ext.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index bb4c703..2384695 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -24,7 +24,6 @@
 #include <recv_osdep.h>
 #include <cmd_osdep.h>
 #include <mlme_osdep.h>
-#include <rtw_br_ext.h>
 #include <rtw_mlme_ext.h>
 
 /*
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index baafe33..6750135 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -51,7 +51,6 @@
 #include <rtw_p2p.h>
 #include <rtw_ap.h>
 #include <rtw_mp.h>
-#include <rtw_br_ext.h>
 
 #define SPEC_DEV_ID_NONE		BIT(0)
 #define SPEC_DEV_ID_DISABLE_HT		BIT(1)
diff --git a/drivers/staging/rtl8188eu/include/rtw_br_ext.h b/drivers/staging/rtl8188eu/include/rtw_br_ext.h
deleted file mode 100644
index f0b2a20..0000000
--- a/drivers/staging/rtl8188eu/include/rtw_br_ext.h
+++ /dev/null
@@ -1,64 +0,0 @@
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
-#ifndef _RTW_BR_EXT_H_
-#define _RTW_BR_EXT_H_
-
-#define MACADDRLEN		6
-#define _DEBUG_ERR		DBG_88E
-#define _DEBUG_INFO		DBG_88E
-#define DEBUG_WARN		DBG_88E
-#define DEBUG_INFO		DBG_88E
-#define DEBUG_ERR		DBG_88E
-#define GET_MY_HWADDR(padapter)		((padapter)->eeprompriv.mac_addr)
-
-#define NAT25_HASH_BITS		4
-#define NAT25_HASH_SIZE		(1 << NAT25_HASH_BITS)
-#define NAT25_AGEING_TIME	300
-
-#define MAX_NETWORK_ADDR_LEN	17
-
-struct nat25_network_db_entry {
-	struct nat25_network_db_entry	*next_hash;
-	struct nat25_network_db_entry	**pprev_hash;
-	atomic_t	use_count;
-	unsigned char	macAddr[6];
-	unsigned long	ageing_timer;
-	unsigned char	networkAddr[MAX_NETWORK_ADDR_LEN];
-};
-
-enum NAT25_METHOD {
-	NAT25_MIN,
-	NAT25_CHECK,
-	NAT25_INSERT,
-	NAT25_LOOKUP,
-	NAT25_PARSE,
-	NAT25_MAX
-};
-
-struct br_ext_info {
-	unsigned int	nat25_disable;
-	unsigned int	macclone_enable;
-	unsigned int	dhcp_bcst_disable;
-	int	addPPPoETag;		/* 1: Add PPPoE relay-SID, 0: disable */
-	unsigned char	nat25_dmzMac[MACADDRLEN];
-	unsigned int	nat25sc_disable;
-};
-
-#endif /*  _RTW_BR_EXT_H_ */
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 1c30f4c..e19ec25 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -29,7 +29,6 @@
 
 #include <usb_osintf.h>
 #include <usb_hal.h>
-#include <rtw_br_ext.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
-- 
1.7.10.4

