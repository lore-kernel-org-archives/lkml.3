Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbaE2RxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:53:16 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48202 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972AbaE2RxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:53:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/18] staging: rtl8188eu: Remove function rtw_hal_sreset_xmit_status_check()
Date: Thu, 29 May 2014 23:20:47 +0530
Message-Id: <1401385858-28722-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_hal_sreset_xmit_status_check() is a wrapper to call
rtl8188e_sreset_xmit_status_check(), which calls
rtl8188e_silentreset_for_specific_platform() in case of transmission has
stopped to do a silent reset and restore the transmission but
rtl8188e_silentreset_for_specific_platform() has empty defination,
so we can remove rtw_hal_sreset_xmit_status_check() because it doesn't
serve its purpose.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c     |    2 --
 drivers/staging/rtl8188eu/hal/hal_intf.c     |    6 ------
 drivers/staging/rtl8188eu/include/hal_intf.h |    1 -
 3 files changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 1e0b8b4..25f1c36 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1542,8 +1542,6 @@ static void dynamic_chk_wk_hdl(struct adapter *padapter, u8 *pbuf, int sz)
 		expire_timeout_chk(padapter);
 #endif
 
-	rtw_hal_sreset_xmit_status_check(padapter);
-
 	linked_status_chk(padapter);
 	traffic_status_watchdog(padapter);
 
diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 699775b..cf03d9c 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -380,12 +380,6 @@ void rtw_hal_sreset_reset(struct adapter *adapt)
 		adapt->HalFunc.silentreset(adapt);
 }
 
-void rtw_hal_sreset_xmit_status_check(struct adapter *adapt)
-{
-	if (adapt->HalFunc.sreset_xmit_status_check)
-		adapt->HalFunc.sreset_xmit_status_check(adapt);
-}
-
 void rtw_hal_sreset_linked_status_check(struct adapter *adapt)
 {
 	if (adapt->HalFunc.sreset_linked_status_check)
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 734e935..eb7df0e 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -368,7 +368,6 @@ void	rtw_hal_antdiv_rssi_compared(struct adapter *padapter,
 
 void rtw_hal_sreset_init(struct adapter *padapter);
 void rtw_hal_sreset_reset(struct adapter *padapter);
-void rtw_hal_sreset_xmit_status_check(struct adapter *padapter);
 void rtw_hal_sreset_linked_status_check(struct adapter *padapter);
 u8   rtw_hal_sreset_get_wifi_status(struct adapter *padapter);
 
-- 
1.7.10.4

