Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaGGSmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:42:00 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46600 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaGGSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:41:58 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/13] staging: rtl8188eu: Remove unused function HalDetectPwrDownMode88E()
Date: Tue,  8 Jul 2014 00:10:07 +0530
Message-Id: <1404758413-12859-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   19 -------------------
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    2 --
 2 files changed, 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 1abf974..161138f 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1079,25 +1079,6 @@ void Hal_ReadThermalMeter_88E(struct adapter *Adapter, u8 *PROMContent, bool Aut
 	DBG_88E("ThermalMeter = 0x%x\n", pHalData->EEPROMThermalMeter);
 }
 
-bool HalDetectPwrDownMode88E(struct adapter *Adapter)
-{
-	u8 tmpvalue = 0;
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	struct pwrctrl_priv *pwrctrlpriv = &Adapter->pwrctrlpriv;
-
-	EFUSE_ShadowRead(Adapter, 1, EEPROM_RF_FEATURE_OPTION_88E, (u32 *)&tmpvalue);
-
-	/*  2010/08/25 MH INF priority > PDN Efuse value. */
-	if (tmpvalue & BIT(4) && pwrctrlpriv->reg_pdnmode)
-		pHalData->pwrdown = true;
-	else
-		pHalData->pwrdown = false;
-
-	DBG_88E("HalDetectPwrDownMode(): PDN =%d\n", pHalData->pwrdown);
-
-	return pHalData->pwrdown;
-}	/*  HalDetectPwrDownMode */
-
 /*  This function is used only for 92C to set REG_BCN_CTRL(0x550) register. */
 /*  We just reserve the value of the register in variable pHalData->RegBcnCtrlVal and then operate */
 /*  the value of the register via atomic operation. */
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index a0a3ca7..4b7b069 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -451,8 +451,6 @@ void Hal_EfuseParseBoardType88E(struct adapter *pAdapter, u8 *hwinfo,
 void Hal_ReadPowerSavingMode88E(struct adapter *pAdapter, u8 *hwinfo,
 				bool AutoLoadFail);
 
-bool HalDetectPwrDownMode88E(struct adapter *Adapter);
-
 void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc);
 
 /*  register */
-- 
1.7.10.4

