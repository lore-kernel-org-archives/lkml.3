Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaLGSNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 13:13:38 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:49643 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaLGSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 13:13:37 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stas Sergeev <stsp@users.sourceforge.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: hal: rtl8188e_hal_init.c:  Remove unused function
Date: Sun,  7 Dec 2014 19:16:15 +0100
Message-Id: <1417976175-14551-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function GetEEPROMSize8188E() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   14 --------------
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    1 -
 2 files changed, 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index d6fe5e6..acf1037 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -241,20 +241,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->hal_notch_filter = &hal_notch_filter_8188e;
 }
 
-u8 GetEEPROMSize8188E(struct adapter *padapter)
-{
-	u8 size = 0;
-	u32	cr;
-
-	cr = usb_read16(padapter, REG_9346CR);
-	/*  6: EEPROM used is 93C46, 4: boot from E-Fuse. */
-	size = (cr & BOOT_FROM_EEPROM) ? 6 : 4;
-
-	MSG_88E("EEPROM type is %s\n", size == 4 ? "E-FUSE" : "93C46");
-
-	return size;
-}
-
 /*  */
 /*  */
 /*  LLT R/W/Init function */
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 42ab1d2..b8c42ee 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -391,7 +391,6 @@ void rtl8188e_InitializeFirmwareVars(struct adapter *padapter);
 s32 InitLLTTable(struct adapter *padapter, u8 txpktbuf_bndy);
 
 /*  EFuse */
-u8 GetEEPROMSize8188E(struct adapter *padapter);
 void Hal_InitPGData88E(struct adapter *padapter);
 void Hal_EfuseParseIDCode88E(struct adapter *padapter, u8 *hwinfo);
 void Hal_ReadTxPowerInfo88E(struct adapter *padapter, u8 *hwinfo,
-- 
1.7.10.4

