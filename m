Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965278AbaE2Rx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:53:58 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35781 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaE2Rx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:53:56 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/18] staging: rtl8188eu: Remove function rtw_hal_sreset_reset()
Date: Thu, 29 May 2014 23:20:51 +0530
Message-Id: <1401385858-28722-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_hal_sreset_reset() is a wrapper to call
rtl8188e_silentreset_for_specific_platform(), which has empty defination.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c      |    2 --
 drivers/staging/rtl8188eu/hal/hal_intf.c       |    6 ------
 drivers/staging/rtl8188eu/include/hal_intf.h   |    1 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |    4 ----
 4 files changed, 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 155282e..260243b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -804,8 +804,6 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 	rtw_os_xmit_schedule(adapter);
 
 	pmlmeext = &adapter->mlmeextpriv;
-	if (pmlmeext->sitesurvey_res.bss_cnt == 0)
-		rtw_hal_sreset_reset(adapter);
 }
 
 void rtw_dummy_event_callback(struct adapter *adapter , u8 *pbuf)
diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 7499ceb..1afc566 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -374,12 +374,6 @@ void rtw_hal_sreset_init(struct adapter *adapt)
 		adapt->HalFunc.sreset_init_value(adapt);
 }
 
-void rtw_hal_sreset_reset(struct adapter *adapt)
-{
-	if (adapt->HalFunc.silentreset)
-		adapt->HalFunc.silentreset(adapt);
-}
-
 u8   rtw_hal_sreset_get_wifi_status(struct adapter *adapt)
 {
 	u8 status = 0;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index c3f94d8..bed9035 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -365,7 +365,6 @@ void	rtw_hal_antdiv_rssi_compared(struct adapter *padapter,
 				     struct wlan_bssid_ex *src);
 
 void rtw_hal_sreset_init(struct adapter *padapter);
-void rtw_hal_sreset_reset(struct adapter *padapter);
 u8   rtw_hal_sreset_get_wifi_status(struct adapter *padapter);
 
 int rtw_hal_iol_cmd(struct adapter  *adapter, struct xmit_frame *xmit_frame,
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index f04aaa3..97f8b3e 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -4449,10 +4449,6 @@ static int rtw_dbg_port(struct net_device *dev,
 			}
 			break;
 		case 0x0f:
-			if (extra_arg == 0) {
-				DBG_88E("###### silent reset test.......#####\n");
-				rtw_hal_sreset_reset(padapter);
-			}
 			break;
 		case 0x15:
 			{
-- 
1.7.10.4

