Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231AbaE2Rxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:53:38 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41476 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaE2Rxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:53:37 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/18] staging:rtl8188eu: Remove function rtw_hal_sreset_linked_status_check()
Date: Thu, 29 May 2014 23:20:49 +0530
Message-Id: <1401385858-28722-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_hal_sreset_linked_status_check() is a wrapper to call
rtl8188e_sreset_linked_status_check(), which doesn't do anything
useful.

rtl8188e_sreset_linked_status_check() will also be removed later.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c |    2 --
 drivers/staging/rtl8188eu/hal/hal_intf.c      |    6 ------
 drivers/staging/rtl8188eu/include/hal_intf.h  |    1 -
 3 files changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index f5b49f3..b2a1251 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -7549,8 +7549,6 @@ void linked_status_chk(struct adapter *padapter)
 	if (padapter->bRxRSSIDisplay)
 		_linked_rx_signal_strehgth_display(padapter);
 
-	rtw_hal_sreset_linked_status_check(padapter);
-
 	if (is_client_associated_to_ap(padapter)) {
 		/* linked infrastructure client mode */
 
diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index cf03d9c..7499ceb 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -380,12 +380,6 @@ void rtw_hal_sreset_reset(struct adapter *adapt)
 		adapt->HalFunc.silentreset(adapt);
 }
 
-void rtw_hal_sreset_linked_status_check(struct adapter *adapt)
-{
-	if (adapt->HalFunc.sreset_linked_status_check)
-		adapt->HalFunc.sreset_linked_status_check(adapt);
-}
-
 u8   rtw_hal_sreset_get_wifi_status(struct adapter *adapt)
 {
 	u8 status = 0;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 85fd521..5d67e90 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -367,7 +367,6 @@ void	rtw_hal_antdiv_rssi_compared(struct adapter *padapter,
 
 void rtw_hal_sreset_init(struct adapter *padapter);
 void rtw_hal_sreset_reset(struct adapter *padapter);
-void rtw_hal_sreset_linked_status_check(struct adapter *padapter);
 u8   rtw_hal_sreset_get_wifi_status(struct adapter *padapter);
 
 int rtw_hal_iol_cmd(struct adapter  *adapter, struct xmit_frame *xmit_frame,
-- 
1.7.10.4

