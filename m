Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924AbaGGSmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:42:10 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38109 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaGGSmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:42:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/13] staging: rtl8188eu: rtw_efuse.c: Remove unused functions
Date: Tue,  8 Jul 2014 00:10:08 +0530
Message-Id: <1404758413-12859-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c    |   60 -------------------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h |    2 -
 2 files changed, 62 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index df8d934..5b997b2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -983,53 +983,6 @@ void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata)
 }
 
 /*
- * Function:   efuse_ShadowRead1Byte
- *             efuse_ShadowRead2Byte
- *             efuse_ShadowRead4Byte
- *
- * Overview:   Read from efuse init map by one/two/four bytes !!!!!
- */
-static void
-efuse_ShadowRead1Byte(
-		struct adapter *pAdapter,
-		u16 Offset,
-		u8 *Value)
-{
-	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
-
-	*Value = pEEPROM->efuse_eeprom_data[Offset];
-
-}
-
-static void
-efuse_ShadowRead2Byte(
-		struct adapter *pAdapter,
-		u16 Offset,
-		u16 *Value)
-{
-	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
-
-	*Value = pEEPROM->efuse_eeprom_data[Offset];
-	*Value |= pEEPROM->efuse_eeprom_data[Offset+1]<<8;
-
-}
-
-static void
-efuse_ShadowRead4Byte(
-		struct adapter *pAdapter,
-		u16 Offset,
-		u32 *Value)
-{
-	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
-
-	*Value = pEEPROM->efuse_eeprom_data[Offset];
-	*Value |= pEEPROM->efuse_eeprom_data[Offset+1]<<8;
-	*Value |= pEEPROM->efuse_eeprom_data[Offset+2]<<16;
-	*Value |= pEEPROM->efuse_eeprom_data[Offset+3]<<24;
-
-}
-
-/*
  * Overview:	Read All Efuse content
  */
 static void Efuse_ReadAllMap(struct adapter *pAdapter, u8 efuseType, u8 *Efuse)
@@ -1062,16 +1015,3 @@ void EFUSE_ShadowMapUpdate(
 	else
 		Efuse_ReadAllMap(pAdapter, efuseType, pEEPROM->efuse_eeprom_data);
 }
-
-/*
- * Overview:	Read from efuse init map !!!!!
- */
-void EFUSE_ShadowRead(struct adapter *pAdapter, u8 Type, u16 Offset, u32 *Value)
-{
-	if (Type == 1)
-		efuse_ShadowRead1Byte(pAdapter, Offset, (u8 *)Value);
-	else if (Type == 2)
-		efuse_ShadowRead2Byte(pAdapter, Offset, (u16 *)Value);
-	else if (Type == 4)
-		efuse_ShadowRead4Byte(pAdapter, Offset, (u32 *)Value);
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index adeb501..720f9ea 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -116,6 +116,4 @@ u8 Efuse_WordEnableDataWrite(struct adapter *adapter, u16 efuse_addr,
 			     u8 word_en, u8 *data);
 
 void EFUSE_ShadowMapUpdate(struct adapter *adapter, u8 efusetype);
-void EFUSE_ShadowRead(struct adapter *adapt, u8 type, u16 offset, u32 *val);
-
 #endif
-- 
1.7.10.4

