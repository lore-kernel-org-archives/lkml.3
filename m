Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaFTPFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:05:17 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55672 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652AbaFTPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:05:10 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 40/41] staging: rtl8188eu: rtw_efuse.c: Remove unnecessary comments
Date: Fri, 20 Jun 2014 20:29:46 +0530
Message-Id: <1403276387-11841-41-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c |  125 ++++++----------------------
 1 file changed, 24 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 26d1d51..7eb8946 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -24,14 +24,10 @@
 #include <rtw_efuse.h>
 #include <usb_ops_linux.h>
 
-/*  */
 #define REG_EFUSE_CTRL		0x0030
 #define EFUSE_CTRL			REG_EFUSE_CTRL		/*  E-Fuse Control. */
-/*  */
 
-/*  11/16/2008 MH Add description. Get current efuse area enabled word!!. */
-u8
-Efuse_CalculateWordCnts(u8 word_en)
+u8 Efuse_CalculateWordCnts(u8 word_en)
 {
 	u8 word_cnts = 0;
 	if (!(word_en & BIT(0)))
@@ -50,8 +46,6 @@ u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data)
 	u8 tmpidx = 0;
 	u8 result;
 
-	/*  -----------------e-fuse reg ctrl --------------------------------- */
-	/* address */
 	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr & 0xff));
 	usb_write8(pAdapter, EFUSE_CTRL+2, ((u8)((addr>>8) & 0x03)) |
 		   (usb_read8(pAdapter, EFUSE_CTRL+2) & 0xFC));
@@ -70,14 +64,11 @@ u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data)
 	return result;
 }
 
-/*  11/16/2008 MH Write one byte to reald Efuse. */
 u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data)
 {
 	u8 tmpidx = 0;
 	u8 result;
 
-	/*  -----------------e-fuse reg ctrl --------------------------------- */
-	/* address */
 	usb_write8(pAdapter, EFUSE_CTRL+1, (u8)(addr&0xff));
 	usb_write8(pAdapter, EFUSE_CTRL+2,
 		   (usb_read8(pAdapter, EFUSE_CTRL+2) & 0xFC) |
@@ -97,23 +88,9 @@ u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data)
 	return result;
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	efuse_WordEnableDataRead
- *
- * Overview:	Read allowed word in current efuse section data.
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/16/2008	MHC		Create Version 0.
- * 11/21/2008	MHC		Fix Write bug when we only enable late word.
- *
- *---------------------------------------------------------------------------*/
+/*
+ * Overview:   Read allowed word in current efuse section data.
+ */
 void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata)
 {
 	if (!(word_en&BIT(0))) {
@@ -186,14 +163,14 @@ u8 rtw_efuse_access(struct adapter *padapter, u8 write, u16 start_addr, u16 cnts
 
 	return res;
 }
-/*  */
+
 u16 efuse_GetMaxSize(struct adapter *padapter)
 {
 	u16 max_size;
 	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI , TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_size);
 	return max_size;
 }
-/*  */
+
 u8 efuse_GetCurrentSize(struct adapter *padapter, u16 *size)
 {
 	Efuse_PowerSwitch(padapter, false, true);
@@ -202,7 +179,7 @@ u8 efuse_GetCurrentSize(struct adapter *padapter, u16 *size)
 
 	return _SUCCESS;
 }
-/*  */
+
 u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 {
 	u16 mapLen = 0;
@@ -221,7 +198,6 @@ u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 	return _SUCCESS;
 }
 
-/*  */
 u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 {
 	u8 offset, word_en;
@@ -313,24 +289,13 @@ exit:
 	return ret;
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	efuse_ShadowRead1Byte
- *			efuse_ShadowRead2Byte
- *			efuse_ShadowRead4Byte
- *
- * Overview:	Read from efuse init map by one/two/four bytes !!!!!
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/12/2008	MHC		Create Version 0.
+/*
+ * Function:   efuse_ShadowRead1Byte
+ *             efuse_ShadowRead2Byte
+ *             efuse_ShadowRead4Byte
  *
- *---------------------------------------------------------------------------*/
+ * Overview:   Read from efuse init map by one/two/four bytes !!!!!
+ */
 static void
 efuse_ShadowRead1Byte(
 		struct adapter *pAdapter,
@@ -341,9 +306,8 @@ efuse_ShadowRead1Byte(
 
 	*Value = pEEPROM->efuse_eeprom_data[Offset];
 
-}	/*  EFUSE_ShadowRead1Byte */
+}
 
-/* Read Two Bytes */
 static void
 efuse_ShadowRead2Byte(
 		struct adapter *pAdapter,
@@ -355,9 +319,8 @@ efuse_ShadowRead2Byte(
 	*Value = pEEPROM->efuse_eeprom_data[Offset];
 	*Value |= pEEPROM->efuse_eeprom_data[Offset+1]<<8;
 
-}	/*  EFUSE_ShadowRead2Byte */
+}
 
-/* Read Four Bytes */
 static void
 efuse_ShadowRead4Byte(
 		struct adapter *pAdapter,
@@ -371,24 +334,11 @@ efuse_ShadowRead4Byte(
 	*Value |= pEEPROM->efuse_eeprom_data[Offset+2]<<16;
 	*Value |= pEEPROM->efuse_eeprom_data[Offset+3]<<24;
 
-}	/*  efuse_ShadowRead4Byte */
+}
 
-/*-----------------------------------------------------------------------------
- * Function:	Efuse_ReadAllMap
- *
+/*
  * Overview:	Read All Efuse content
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/11/2008	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
+ */
 static void Efuse_ReadAllMap(struct adapter *pAdapter, u8 efuseType, u8 *Efuse)
 {
 	u16 mapLen = 0;
@@ -402,22 +352,9 @@ static void Efuse_ReadAllMap(struct adapter *pAdapter, u8 efuseType, u8 *Efuse)
 	Efuse_PowerSwitch(pAdapter, false, false);
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	EFUSE_ShadowMapUpdate
- *
+/*
  * Overview:	Transfer current EFUSE content to shadow init and modify map.
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/13/2008	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
+ */
 void EFUSE_ShadowMapUpdate(
 	struct adapter *pAdapter,
 	u8 efuseType)
@@ -431,24 +368,11 @@ void EFUSE_ShadowMapUpdate(
 		_rtw_memset(pEEPROM->efuse_eeprom_data, 0xFF, mapLen);
 	else
 		Efuse_ReadAllMap(pAdapter, efuseType, pEEPROM->efuse_eeprom_data);
-} /*  EFUSE_ShadowMapUpdate */
+}
 
-/*-----------------------------------------------------------------------------
- * Function:	EFUSE_ShadowRead
- *
+/*
  * Overview:	Read from efuse init map !!!!!
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/12/2008	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
+ */
 void EFUSE_ShadowRead(struct adapter *pAdapter, u8 Type, u16 Offset, u32 *Value)
 {
 	if (Type == 1)
@@ -457,5 +381,4 @@ void EFUSE_ShadowRead(struct adapter *pAdapter, u8 Type, u16 Offset, u32 *Value)
 		efuse_ShadowRead2Byte(pAdapter, Offset, (u16 *)Value);
 	else if (Type == 4)
 		efuse_ShadowRead4Byte(pAdapter, Offset, (u32 *)Value);
-
-}	/*  EFUSE_ShadowRead */
+}
-- 
1.7.10.4

