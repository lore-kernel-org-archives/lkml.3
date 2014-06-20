Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaFTPDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:48 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58738 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaFTPDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 26/41] staging: rtl8188eu: Remove unused function EFUSE_Read1Byte()
Date: Fri, 20 Jun 2014 20:29:32 +0530
Message-Id: <1403276387-11841-27-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c    |   59 -------------------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h |    1 -
 2 files changed, 60 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 16377f6..dc82973 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -63,65 +63,6 @@ Efuse_CalculateWordCnts(u8 word_en)
 	return word_cnts;
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	EFUSE_Read1Byte
- *
- * Overview:	Copy from WMAC fot EFUSE read 1 byte.
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 09/23/2008	MHC		Copy from WMAC.
- *
- *---------------------------------------------------------------------------*/
-u8 EFUSE_Read1Byte(struct adapter *Adapter, u16 Address)
-{
-	u8 data;
-	u8 Bytetemp = {0x00};
-	u8 temp = {0x00};
-	u32 k = 0;
-	u16 contentLen = 0;
-
-	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI , TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&contentLen);
-
-	if (Address < contentLen) {	/* E-fuse 512Byte */
-		/* Write E-fuse Register address bit0~7 */
-		temp = Address & 0xFF;
-		usb_write8(Adapter, EFUSE_CTRL+1, temp);
-		Bytetemp = usb_read8(Adapter, EFUSE_CTRL+2);
-		/* Write E-fuse Register address bit8~9 */
-		temp = ((Address >> 8) & 0x03) | (Bytetemp & 0xFC);
-		usb_write8(Adapter, EFUSE_CTRL+2, temp);
-
-		/* Write 0x30[31]= 0 */
-		Bytetemp = usb_read8(Adapter, EFUSE_CTRL+3);
-		temp = Bytetemp & 0x7F;
-		usb_write8(Adapter, EFUSE_CTRL+3, temp);
-
-		/* Wait Write-ready (0x30[31]= 1) */
-		Bytetemp = usb_read8(Adapter, EFUSE_CTRL+3);
-		while (!(Bytetemp & 0x80)) {
-			Bytetemp = usb_read8(Adapter, EFUSE_CTRL+3);
-			k++;
-			if (k == 1000) {
-				k = 0;
-				break;
-			}
-		}
-		data = usb_read8(Adapter, EFUSE_CTRL);
-		return data;
-	} else {
-		return 0xFF;
-	}
-
-} /* EFUSE_Read1Byte */
-
-/*  11/16/2008 MH Read one byte from real Efuse. */
 u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data, bool pseudo)
 {
 	u8 tmpidx = 0;
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index d8be20d..0849f85 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -140,7 +140,6 @@ void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata);
 u8 Efuse_WordEnableDataWrite(struct adapter *adapter, u16 efuse_addr,
 			     u8 word_en, u8 *data, bool test);
 
-u8 EFUSE_Read1Byte(struct adapter *adapter, u16 address);
 void EFUSE_ShadowMapUpdate(struct adapter *adapter, u8 efusetype, bool test);
 void EFUSE_ShadowRead(struct adapter *adapt, u8 type, u16 offset, u32 *val);
 
-- 
1.7.10.4

