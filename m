Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbaE2Rvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:51:31 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53879 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2Rva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:51:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/18] staging: rtl8188eu:Remove "silent_reset_inprogress" from struct sreset_priv
Date: Thu, 29 May 2014 23:20:42 +0530
Message-Id: <1401385858-28722-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

psrtpriv->silent_reset_inprogress is always false.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_sreset.c    |    4 ----
 drivers/staging/rtl8188eu/include/rtw_sreset.h |    1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_sreset.c b/drivers/staging/rtl8188eu/core/rtw_sreset.c
index b7b787e..434c433 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sreset.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sreset.c
@@ -25,7 +25,6 @@ void sreset_init_value(struct adapter *padapter)
 	struct hal_data_8188e	*pHalData = GET_HAL_DATA(padapter);
 	struct sreset_priv *psrtpriv = &pHalData->srestpriv;
 
-	psrtpriv->silent_reset_inprogress = false;
 	psrtpriv->Wifi_Error_Status = WIFI_STATUS_SUCCESS;
 	psrtpriv->last_tx_time = 0;
 	psrtpriv->last_tx_complete_time = 0;
@@ -35,7 +34,6 @@ void sreset_reset_value(struct adapter *padapter)
 	struct hal_data_8188e	*pHalData = GET_HAL_DATA(padapter);
 	struct sreset_priv *psrtpriv = &pHalData->srestpriv;
 
-	psrtpriv->silent_reset_inprogress = false;
 	psrtpriv->Wifi_Error_Status = WIFI_STATUS_SUCCESS;
 	psrtpriv->last_tx_time = 0;
 	psrtpriv->last_tx_complete_time = 0;
@@ -49,8 +47,6 @@ u8 sreset_get_wifi_status(struct adapter *padapter)
 	u8 status = WIFI_STATUS_SUCCESS;
 	u32 val32 = 0;
 
-	if (psrtpriv->silent_reset_inprogress)
-		return status;
 	val32 = rtw_read32(padapter, REG_TXDMA_STATUS);
 	if (val32 == 0xeaeaeaea) {
 		psrtpriv->Wifi_Error_Status = WIFI_IF_NOT_EXIST;
diff --git a/drivers/staging/rtl8188eu/include/rtw_sreset.h b/drivers/staging/rtl8188eu/include/rtw_sreset.h
index fbfdffb..8474180 100644
--- a/drivers/staging/rtl8188eu/include/rtw_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtw_sreset.h
@@ -24,7 +24,6 @@
 #include <drv_types.h>
 
 struct sreset_priv {
-	u8	silent_reset_inprogress;
 	u8	Wifi_Error_Status;
 	unsigned long last_tx_time;
 	unsigned long last_tx_complete_time;
-- 
1.7.10.4

