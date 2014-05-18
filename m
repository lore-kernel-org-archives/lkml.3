Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaERP0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:26:47 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33287 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaERP0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:26:46 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 25/28] staging: rtl8188eu: Remove function with empty defination ODM_CheckPowerStatus()
Date: Sun, 18 May 2014 20:49:18 +0530
Message-Id: <1400426361-19596-26-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 056052d..7c22658 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -804,24 +804,12 @@ static void pathb_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 	}
 }
 
-/*  */
-/*  2011/07/26 MH Add an API for testing IQK fail case. */
-/*  */
-/*  MP Already declare in odm.c */
-static bool ODM_CheckPowerStatus(struct adapter *Adapter)
-{
-	return	true;
-}
-
 void _PHY_SaveADDARegisters(struct adapter *adapt, u32 *ADDAReg, u32 *ADDABackup, u32 RegisterNum)
 {
 	u32 i;
 	struct hal_data_8188e	*pHalData = GET_HAL_DATA(adapt);
 	struct odm_dm_struct *dm_odm = &pHalData->odmpriv;
 
-	if (!ODM_CheckPowerStatus(adapt))
-		return;
-
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Save ADDA parameters.\n"));
 	for (i = 0; i < RegisterNum; i++) {
 		ADDABackup[i] = PHY_QueryBBReg(adapt, ADDAReg[i], bMaskDWord);
@@ -1294,8 +1282,6 @@ void PHY_IQCalibrate_8188E(struct adapter *adapt, bool recovery)
 	bool is2t;
 
 	is2t = (dm_odm->RFType == ODM_2T2R) ? true : false;
-	if (!ODM_CheckPowerStatus(adapt))
-		return;
 
 	if (!(dm_odm->SupportAbility & ODM_RF_CALIBRATION))
 		return;
-- 
1.7.10.4

