Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbaGARGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:06:47 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46527 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbaGARFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:05:47 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 3/5] staging: rtl8188eu: Remove usb_osintf.h header file.
Date: Tue,  1 Jul 2014 22:35:11 +0530
Message-Id: <1404234313-21634-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
References: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c |    2 +-
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c |    2 --
 drivers/staging/rtl8188eu/core/rtw_mlme.c      |    1 -
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c   |    1 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c      |    1 -
 drivers/staging/rtl8188eu/hal/usb_halinit.c    |    1 -
 drivers/staging/rtl8188eu/include/osdep_intf.h |    5 +++-
 drivers/staging/rtl8188eu/include/usb_osintf.h |   38 ------------------------
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c    |   19 ++++++------
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c  |    1 -
 11 files changed, 14 insertions(+), 58 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_osintf.h

diff --git a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
index a375b75..24665d6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -20,11 +20,11 @@
 #define _IEEE80211_C
 
 #include <drv_types.h>
+#include <osdep_intf.h>
 #include <ieee80211.h>
 #include <wifi.h>
 #include <osdep_service.h>
 #include <wlan_bssdef.h>
-#include <usb_osintf.h>
 
 u8 RTW_WPA_OUI_TYPE[] = { 0x00, 0x50, 0xf2, 1 };
 u16 RTW_WPA_VERSION = 1;
diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index a97da87..39932cb 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -25,8 +25,6 @@
 #include <rtw_ioctl_set.h>
 #include <hal_intf.h>
 
-#include <usb_osintf.h>
-
 extern void indicate_wx_scan_complete_event(struct adapter *padapter);
 
 #define IS_MAC_ADDRESS_BROADCAST(addr) \
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 0cb9e15..45e2739 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -30,7 +30,6 @@
 #include <wifi.h>
 #include <wlan_bssdef.h>
 #include <rtw_ioctl_set.h>
-#include <usb_osintf.h>
 #include <linux/vmalloc.h>
 
 extern unsigned char	MCS_rate_2R[16];
diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index 9b80c8a..5605d95 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -24,7 +24,6 @@
 #include <osdep_intf.h>
 #include <usb_ops_linux.h>
 #include <linux/usb.h>
-#include <usb_osintf.h>
 
 static int rtw_hw_suspend(struct adapter *padapter)
 {
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 95c508a..639ace0 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -23,7 +23,6 @@
 #include <drv_types.h>
 #include <wifi.h>
 #include <osdep_intf.h>
-#include <usb_osintf.h>
 #include <linux/vmalloc.h>
 
 static u8 P802_1H_OUI[P80211_OUI_LEN] = { 0x00, 0x00, 0xf8 };
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 19cf5f5..2bec1c3 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -27,7 +27,6 @@
 #include <rtl8188e_led.h>
 #include <rtw_iol.h>
 #include <usb_hal.h>
-#include <usb_osintf.h>
 
 #define		HAL_MAC_ENABLE	1
 #define		HAL_BB_ENABLE		1
diff --git a/drivers/staging/rtl8188eu/include/osdep_intf.h b/drivers/staging/rtl8188eu/include/osdep_intf.h
index 523141a..efa7868 100644
--- a/drivers/staging/rtl8188eu/include/osdep_intf.h
+++ b/drivers/staging/rtl8188eu/include/osdep_intf.h
@@ -24,6 +24,9 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
+extern char *rtw_initmac;
+extern int rtw_mc2u_disable;
+
 u8 rtw_init_drv_sw(struct adapter *padapter);
 u8 rtw_free_drv_sw(struct adapter *padapter);
 u8 rtw_reset_drv_sw(struct adapter *padapter);
@@ -40,8 +43,8 @@ u16 rtw_recv_select_queue(struct sk_buff *skb);
 void rtw_proc_init_one(struct net_device *dev);
 void rtw_proc_remove_one(struct net_device *dev);
 
+int pm_netdev_open(struct net_device *pnetdev, u8 bnormal);
 void rtw_ips_dev_unload(struct adapter *padapter);
-
 int rtw_ips_pwr_up(struct adapter *padapter);
 void rtw_ips_pwr_down(struct adapter *padapter);
 
diff --git a/drivers/staging/rtl8188eu/include/usb_osintf.h b/drivers/staging/rtl8188eu/include/usb_osintf.h
deleted file mode 100644
index 85805ca..0000000
--- a/drivers/staging/rtl8188eu/include/usb_osintf.h
+++ /dev/null
@@ -1,38 +0,0 @@
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
-#ifndef __USB_OSINTF_H
-#define __USB_OSINTF_H
-
-#include <osdep_service.h>
-#include <drv_types.h>
-
-extern char *rtw_initmac;
-extern int rtw_mc2u_disable;
-
-#define USBD_HALTED(Status) ((u32)(Status) >> 30 == 3)
-
-int pm_netdev_open(struct net_device *pnetdev, u8 bnormal);
-void dhcp_flag_bcast(struct adapter *priv, struct sk_buff *skb);
-void *scdb_findEntry(struct adapter *priv, unsigned char *macAddr,
-		     unsigned char *ipAddr);
-
-int rtw_resume_process(struct adapter *padapter);
-
-#endif
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 7536be6..e3c0353 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -27,7 +27,6 @@
 #include <hal_intf.h>
 #include <rtw_ioctl.h>
 
-#include <usb_osintf.h>
 #include <usb_hal.h>
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 3c8720c..f1630c2 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -29,7 +29,6 @@
 #include <osdep_intf.h>
 
 #include <usb_ops_linux.h>
-#include <usb_osintf.h>
 #include <usb_hal.h>
 #include <rtw_ioctl.h>
 
@@ -302,15 +301,7 @@ exit:
 	return ret;
 }
 
-static int rtw_resume(struct usb_interface *pusb_intf)
-{
-	struct dvobj_priv *dvobj = usb_get_intfdata(pusb_intf);
-	struct adapter *padapter = dvobj->if1;
-
-	return rtw_resume_process(padapter);
-}
-
-int rtw_resume_process(struct adapter *padapter)
+static int rtw_resume_process(struct adapter *padapter)
 {
 	struct net_device *pnetdev;
 	struct pwrctrl_priv *pwrpriv = NULL;
@@ -357,6 +348,14 @@ exit:
 	return ret;
 }
 
+static int rtw_resume(struct usb_interface *pusb_intf)
+{
+	struct dvobj_priv *dvobj = usb_get_intfdata(pusb_intf);
+	struct adapter *padapter = dvobj->if1;
+
+	return rtw_resume_process(padapter);
+}
+
 /*
  * drv_init() - a device potentially for us
  *
diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index b5efa45..8e7d6f1 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -27,7 +27,6 @@
 #include <mlme_osdep.h>
 #include <xmit_osdep.h>
 #include <osdep_intf.h>
-#include <usb_osintf.h>
 
 uint rtw_remainder_len(struct pkt_file *pfile)
 {
-- 
1.7.10.4

