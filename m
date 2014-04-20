Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaDTItD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:49:03 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64616 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaDTIst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:48:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/10] staging: rtl8188eu: Remove _InitHWLed() function.
Date: Sun, 20 Apr 2014 14:17:12 +0530
Message-Id: <1397983638-10752-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_InitHWLed() function does nothing.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 0dfd62b..617e4c6 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -424,18 +424,6 @@ static void _InitBeaconMaxError(struct adapter *Adapter, bool		InfraMode)
 {
 }
 
-static void _InitHWLed(struct adapter *Adapter)
-{
-	struct led_priv *pledpriv = &(Adapter->ledpriv);
-
-	if (pledpriv->LedStrategy != HW_LED)
-		return;
-
-/*  HW led control */
-/*  to do .... */
-/* must consider cases of antenna diversity/ commbo card/solo card/mini card */
-}
-
 static void _InitRDGSetting(struct adapter *Adapter)
 {
 	rtw_write8(Adapter, REG_RD_CTRL, 0xFF);
@@ -870,8 +858,6 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	rtw_write16(Adapter, REG_PKT_VO_VI_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
 	rtw_write16(Adapter, REG_PKT_BE_BK_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
 
-	_InitHWLed(Adapter);
-
 	/* Keep RfRegChnlVal for later use. */
 	haldata->RfRegChnlVal[0] = PHY_QueryRFReg(Adapter, (enum rf_radio_path)0, RF_CHNLBW, bRFRegOffsetMask);
 	haldata->RfRegChnlVal[1] = PHY_QueryRFReg(Adapter, (enum rf_radio_path)1, RF_CHNLBW, bRFRegOffsetMask);
-- 
1.7.10.4

