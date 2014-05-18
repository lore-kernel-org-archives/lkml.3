Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaERPUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:20:47 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37471 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaERPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:20:46 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/28] staging: rtl8188eu: Remove function with empty definition _ps_open_RF()
Date: Sun, 18 May 2014 20:48:56 +0530
Message-Id: <1400426361-19596-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c      |    7 -------
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h |    1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 2e7b81ce..2fe1135 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -693,7 +693,6 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_BEGIN);
 
 	if (Adapter->pwrctrlpriv.bkeepfwalive) {
-		_ps_open_RF(Adapter);
 
 		if (haldata->odmpriv.RFCalibrateInfo.bIQKInitialized) {
 			PHY_IQCalibrate_8188E(Adapter, true);
@@ -943,12 +942,6 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_END);
 	return status;
 }
 
-void _ps_open_RF(struct adapter *adapt)
-{
-	/* here call with bRegSSPwrLvl 1, bRegSSPwrLvl 2 needs to be verified */
-	/* phy_SsPwrSwitch92CU(adapt, rf_on, 1); */
-}
-
 static void _ps_close_RF(struct adapter *adapt)
 {
 	/* here call with bRegSSPwrLvl 1, bRegSSPwrLvl 2 needs to be verified */
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 75e41c4..fe3b454 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -471,6 +471,5 @@ void rtl8188e_stop_thread(struct adapter *padapter);
 void rtw_IOL_cmd_tx_pkt_buf_dump(struct adapter  *Adapter, int len);
 s32 rtl8188e_iol_efuse_patch(struct adapter *padapter);
 void rtw_cancel_all_timer(struct adapter *padapter);
-void _ps_open_RF(struct adapter *adapt);
 
 #endif /* __RTL8188E_HAL_H__ */
-- 
1.7.10.4

