Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934636AbaE2RvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:51:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41866 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2RvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:51:10 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/18] staging: rtl8188eu: Remove "silentreset_mutex" from struct sreset_priv
Date: Thu, 29 May 2014 23:20:41 +0530
Message-Id: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

silentreset_mutex initialized but not being used.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_sreset.c    |    1 -
 drivers/staging/rtl8188eu/include/rtw_sreset.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_sreset.c b/drivers/staging/rtl8188eu/core/rtw_sreset.c
index ee20d4a..b7b787e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sreset.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sreset.c
@@ -25,7 +25,6 @@ void sreset_init_value(struct adapter *padapter)
 	struct hal_data_8188e	*pHalData = GET_HAL_DATA(padapter);
 	struct sreset_priv *psrtpriv = &pHalData->srestpriv;
 
-	mutex_init(&psrtpriv->silentreset_mutex);
 	psrtpriv->silent_reset_inprogress = false;
 	psrtpriv->Wifi_Error_Status = WIFI_STATUS_SUCCESS;
 	psrtpriv->last_tx_time = 0;
diff --git a/drivers/staging/rtl8188eu/include/rtw_sreset.h b/drivers/staging/rtl8188eu/include/rtw_sreset.h
index 2a1244f..fbfdffb 100644
--- a/drivers/staging/rtl8188eu/include/rtw_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtw_sreset.h
@@ -24,7 +24,6 @@
 #include <drv_types.h>
 
 struct sreset_priv {
-	struct mutex	silentreset_mutex;
 	u8	silent_reset_inprogress;
 	u8	Wifi_Error_Status;
 	unsigned long last_tx_time;
-- 
1.7.10.4

