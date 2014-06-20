Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbaFTPEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:04:00 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53587 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934278AbaFTPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 28/41] staging: rtl8188eu: efuse_OneByteWrite(): Remove unused parameter bool test
Date: Fri, 20 Jun 2014 20:29:34 +0530
Message-Id: <1403276387-11841-29-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    4 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   28 ++++++++++-----------
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 6ba8cbfa..9519888 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -89,7 +89,7 @@ u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data)
 }
 
 /*  11/16/2008 MH Write one byte to reald Efuse. */
-u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data, bool pseudo)
+u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data)
 {
 	u8 tmpidx = 0;
 	u8 result;
@@ -159,7 +159,7 @@ static u8 efuse_read8(struct adapter *padapter, u16 address, u8 *value)
 
 static u8 efuse_write8(struct adapter *padapter, u16 address, u8 *value)
 {
-	return efuse_OneByteWrite(padapter, address, *value, false);
+	return efuse_OneByteWrite(padapter, address, *value);
 }
 
 /*
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 8d76946..ff5dfff 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -901,8 +901,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 
 	if (!(word_en&BIT0)) {
 		tmpaddr = start_addr;
-		efuse_OneByteWrite(pAdapter, start_addr++, data[0], bPseudoTest);
-		efuse_OneByteWrite(pAdapter, start_addr++, data[1], bPseudoTest);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[0]);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[1]);
 
 		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[0]);
 		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[1]);
@@ -911,8 +911,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 	}
 	if (!(word_en&BIT1)) {
 		tmpaddr = start_addr;
-		efuse_OneByteWrite(pAdapter, start_addr++, data[2], bPseudoTest);
-		efuse_OneByteWrite(pAdapter, start_addr++, data[3], bPseudoTest);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[2]);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[3]);
 
 		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[2]);
 		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[3]);
@@ -921,8 +921,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 	}
 	if (!(word_en&BIT2)) {
 		tmpaddr = start_addr;
-		efuse_OneByteWrite(pAdapter, start_addr++, data[4], bPseudoTest);
-		efuse_OneByteWrite(pAdapter, start_addr++, data[5], bPseudoTest);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[4]);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[5]);
 
 		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[4]);
 		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[5]);
@@ -931,8 +931,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 	}
 	if (!(word_en&BIT3)) {
 		tmpaddr = start_addr;
-		efuse_OneByteWrite(pAdapter, start_addr++, data[6], bPseudoTest);
-		efuse_OneByteWrite(pAdapter, start_addr++, data[7], bPseudoTest);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[6]);
+		efuse_OneByteWrite(pAdapter, start_addr++, data[7]);
 
 		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[6]);
 		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[7]);
@@ -1115,14 +1115,14 @@ static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuse
 
 	while (efuse_addr < efuse_max_available_len) {
 		pg_header = ((pTargetPkt->offset & 0x07) << 5) | 0x0F;
-		efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
+		efuse_OneByteWrite(pAdapter, efuse_addr, pg_header);
 		efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 
 		while (tmp_header == 0xFF) {
 			if (repeatcnt++ > EFUSE_REPEAT_THRESHOLD_)
 				return false;
 
-			efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
+			efuse_OneByteWrite(pAdapter, efuse_addr, pg_header);
 			efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 		}
 
@@ -1132,14 +1132,14 @@ static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuse
 			pg_header_temp = pg_header;
 			pg_header = ((pTargetPkt->offset & 0x78) << 1) | pTargetPkt->word_en;
 
-			efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
+			efuse_OneByteWrite(pAdapter, efuse_addr, pg_header);
 			efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 
 			while (tmp_header == 0xFF) {
 				if (repeatcnt++ > EFUSE_REPEAT_THRESHOLD_)
 					return false;
 
-				efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
+				efuse_OneByteWrite(pAdapter, efuse_addr, pg_header);
 				efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 			}
 
@@ -1180,13 +1180,13 @@ static bool hal_EfusePgPacketWrite1ByteHeader(struct adapter *pAdapter, u8 efuse
 
 	pg_header = ((pTargetPkt->offset << 4) & 0xf0) | pTargetPkt->word_en;
 
-	efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
+	efuse_OneByteWrite(pAdapter, efuse_addr, pg_header);
 	efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 
 	while (tmp_header == 0xFF) {
 		if (repeatcnt++ > EFUSE_REPEAT_THRESHOLD_)
 			return false;
-		efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
+		efuse_OneByteWrite(pAdapter, efuse_addr, pg_header);
 		efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 	}
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index f9bc50d..cd96366 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -128,7 +128,7 @@ u8 Efuse_CalculateWordCnts(u8 word_en);
 void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
 			      void *out);
 u8 efuse_OneByteRead(struct adapter *adapter, u16 addr, u8 *data);
-u8 efuse_OneByteWrite(struct adapter *adapter, u16 addr, u8 data, bool	test);
+u8 efuse_OneByteWrite(struct adapter *adapter, u16 addr, u8 data);
 
 void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset,
 		u16 _size_byte, u8 *pbuf, bool bPseudoTest);
-- 
1.7.10.4

