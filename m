Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaHaIjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:39:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62368 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaHaIjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:39:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 9/9] staging: rtl8188eu: Remove unused function SetBcnCtrlReg()
Date: Sun, 31 Aug 2014 14:08:29 +0530
Message-Id: <1409474309-24362-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
References: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   18 ------------------
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    1 -
 2 files changed, 19 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 7a8fe53..d6fe5e6 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -704,21 +704,3 @@ void Hal_ReadThermalMeter_88E(struct adapter *Adapter, u8 *PROMContent, bool Aut
 	}
 	DBG_88E("ThermalMeter = 0x%x\n", pHalData->EEPROMThermalMeter);
 }
-
-/*  This function is used only for 92C to set REG_BCN_CTRL(0x550) register. */
-/*  We just reserve the value of the register in variable pHalData->RegBcnCtrlVal and then operate */
-/*  the value of the register via atomic operation. */
-/*  This prevents from race condition when setting this register. */
-/*  The value of pHalData->RegBcnCtrlVal is initialized in HwConfigureRTL8192CE() function. */
-
-void SetBcnCtrlReg(struct adapter *padapter, u8 SetBits, u8 ClearBits)
-{
-	struct hal_data_8188e *pHalData;
-
-	pHalData = GET_HAL_DATA(padapter);
-
-	pHalData->RegBcnCtrlVal |= SetBits;
-	pHalData->RegBcnCtrlVal &= ~ClearBits;
-
-	usb_write8(padapter, REG_BCN_CTRL, (u8)pHalData->RegBcnCtrlVal);
-}
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index f5abe01..2c517ce 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -417,7 +417,6 @@ void Hal_ReadPowerSavingMode88E(struct adapter *pAdapter, u8 *hwinfo,
 void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc);
 
 /*  register */
-void SetBcnCtrlReg(struct adapter *padapter, u8 SetBits, u8 ClearBits);
 
 void rtl8188e_start_thread(struct adapter *padapter);
 void rtl8188e_stop_thread(struct adapter *padapter);
-- 
1.7.10.4

