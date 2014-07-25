Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107AbaGYAUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:20:02 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61388 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934824AbaGYAUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:20:00 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        navin.patidar@gmail.com, Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH] staging: rtl8188eu: Fix static symbol sparse warnings
Date: Thu, 24 Jul 2014 20:19:43 -0400
Message-Id: <1406247583-12708-1-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings:
drivers/staging/rtl8188eu/core/rtw_cmd.c:52:5: warning:
  symbol '_rtw_enqueue_cmd' was not declared. Should it be static?
drivers/staging/rtl8188eu/core/rtw_wlan_util.c:1225:5: warning:
  symbol 'wifirate2_ratetbl_inx' was not declared. Should it be static?
drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c:25:4: warning:
  symbol 'ODM_GetRightChnlPlaceforIQK' was not declared. Should it be static?
drivers/staging/rtl8188eu/os_dep/ioctl_linux.c:3109:5: warning:
  symbol 'rtw_ioctl' was not declared. Should it be static?

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c       | 2 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c | 2 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c | 2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 08c325e..104b01f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -49,7 +49,7 @@ ISR/Call-Back functions can't call this sub-function.
 
 */
 
-int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj)
+static int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj)
 {
 	unsigned long irqL;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 83e706f..33ccbbb 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -1222,7 +1222,7 @@ unsigned int is_ap_in_wep(struct adapter *padapter)
 	}
 }
 
-int wifirate2_ratetbl_inx(unsigned char rate)
+static int wifirate2_ratetbl_inx(unsigned char rate)
 {
 	int	inx = 0;
 	rate = rate & 0x7f;
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 7fa744b..d2bcc16 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -22,7 +22,7 @@
 #define		ODM_TXPWRTRACK_MAX_IDX_88E		6
 
 
-u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
+static u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
 {
 	u8	channel_all[ODM_TARGET_CHNL_NUM_2G_5G] = {
 		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index d9cee8c..d598fec 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -32,6 +32,7 @@
 
 #include <rtw_iol.h>
 #include <linux/vmalloc.h>
+#include "osdep_intf.h"
 
 #define RTL_IOCTL_WPA_SUPPLICANT	(SIOCIWFIRSTPRIV + 30)
 
-- 
1.9.1

