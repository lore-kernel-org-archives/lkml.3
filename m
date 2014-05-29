Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259AbaE2Rxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:53:47 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42456 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaE2Rxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:53:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/18] staging:rtl8188eu: Remove function rtl8188e_sreset_linked_status_check()
Date: Thu, 29 May 2014 23:20:50 +0530
Message-Id: <1401385858-28722-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove rtl8188e_sreset_linked_status_check() and function pointer
->sreset_linked_status_check pointing to it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c   |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c     |   17 -----------------
 drivers/staging/rtl8188eu/include/hal_intf.h        |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_sreset.h |    1 -
 4 files changed, 20 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 55eaf57..a0f5172 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1873,7 +1873,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
 	pHalFunc->silentreset = &rtl8188e_silentreset_for_specific_platform;
-	pHalFunc->sreset_linked_status_check  = &rtl8188e_sreset_linked_status_check;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
 
 	pHalFunc->GetHalODMVarHandler = &rtl8188e_GetHalODMVar;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c b/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
index fd114c1..7fb0f68 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
@@ -26,20 +26,3 @@ void rtl8188e_silentreset_for_specific_platform(struct adapter *padapter)
 {
 }
 
-void rtl8188e_sreset_linked_status_check(struct adapter *padapter)
-{
-	u32 rx_dma_status = 0;
-	u8 fw_status = 0;
-	rx_dma_status = rtw_read32(padapter, REG_RXDMA_STATUS);
-	if (rx_dma_status != 0x00) {
-		DBG_88E("%s REG_RXDMA_STATUS:0x%08x\n", __func__, rx_dma_status);
-		rtw_write32(padapter, REG_RXDMA_STATUS, rx_dma_status);
-	}
-	fw_status = rtw_read8(padapter, REG_FMETHR);
-	if (fw_status != 0x00) {
-		if (fw_status == 1)
-			DBG_88E("%s REG_FW_STATUS (0x%02x), Read_Efuse_Fail !!\n", __func__, fw_status);
-		else if (fw_status == 2)
-			DBG_88E("%s REG_FW_STATUS (0x%02x), Condition_No_Match !!\n", __func__, fw_status);
-	}
-}
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 5d67e90..c3f94d8 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -253,7 +253,6 @@ struct hal_ops {
 
 	void (*sreset_init_value)(struct adapter *padapter);
 	void (*silentreset)(struct adapter *padapter);
-	void (*sreset_linked_status_check) (struct adapter *padapter);
 	u8 (*sreset_get_wifi_status)(struct adapter *padapter);
 
 	int (*IOL_exec_cmds_sync)(struct adapter *padapter,
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h b/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
index d4f0d72..eb884b7 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
@@ -25,6 +25,5 @@
 #include <rtw_sreset.h>
 
 void rtl8188e_silentreset_for_specific_platform(struct adapter *padapter);
-void rtl8188e_sreset_linked_status_check(struct adapter *padapter);
 
 #endif
-- 
1.7.10.4

