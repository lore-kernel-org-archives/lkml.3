Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbaFTPDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:55 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64096 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbaFTPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:51 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 27/41] staging: rtl8188eu: efuse_OneByteRead():Remove unused parameter bool test
Date: Fri, 20 Jun 2014 20:29:33 +0530
Message-Id: <1403276387-11841-28-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   44 ++++++++++-----------
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index dc82973..6ba8cbfa 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -63,7 +63,7 @@ Efuse_CalculateWordCnts(u8 word_en)
 	return word_cnts;
 }
 
-u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data, bool pseudo)
+u8 efuse_OneByteRead(struct adapter *pAdapter, u16 addr, u8 *data)
 {
 	u8 tmpidx = 0;
 	u8 result;
@@ -154,7 +154,7 @@ void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata)
 
 static u8 efuse_read8(struct adapter *padapter, u16 address, u8 *value)
 {
-	return efuse_OneByteRead(padapter, address, value, false);
+	return efuse_OneByteRead(padapter, address, value);
 }
 
 static u8 efuse_write8(struct adapter *padapter, u16 address, u8 *value)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 1e9ece2..8d76946 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -904,8 +904,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 		efuse_OneByteWrite(pAdapter, start_addr++, data[0], bPseudoTest);
 		efuse_OneByteWrite(pAdapter, start_addr++, data[1], bPseudoTest);
 
-		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[0], bPseudoTest);
-		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[1], bPseudoTest);
+		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[0]);
+		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[1]);
 		if ((data[0] != tmpdata[0]) || (data[1] != tmpdata[1]))
 			badworden &= (~BIT0);
 	}
@@ -914,8 +914,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 		efuse_OneByteWrite(pAdapter, start_addr++, data[2], bPseudoTest);
 		efuse_OneByteWrite(pAdapter, start_addr++, data[3], bPseudoTest);
 
-		efuse_OneByteRead(pAdapter, tmpaddr    , &tmpdata[2], bPseudoTest);
-		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[3], bPseudoTest);
+		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[2]);
+		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[3]);
 		if ((data[2] != tmpdata[2]) || (data[3] != tmpdata[3]))
 			badworden &= (~BIT1);
 	}
@@ -924,8 +924,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 		efuse_OneByteWrite(pAdapter, start_addr++, data[4], bPseudoTest);
 		efuse_OneByteWrite(pAdapter, start_addr++, data[5], bPseudoTest);
 
-		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[4], bPseudoTest);
-		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[5], bPseudoTest);
+		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[4]);
+		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[5]);
 		if ((data[4] != tmpdata[4]) || (data[5] != tmpdata[5]))
 			badworden &= (~BIT2);
 	}
@@ -934,8 +934,8 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 		efuse_OneByteWrite(pAdapter, start_addr++, data[6], bPseudoTest);
 		efuse_OneByteWrite(pAdapter, start_addr++, data[7], bPseudoTest);
 
-		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[6], bPseudoTest);
-		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[7], bPseudoTest);
+		efuse_OneByteRead(pAdapter, tmpaddr, &tmpdata[6]);
+		efuse_OneByteRead(pAdapter, tmpaddr+1, &tmpdata[7]);
 		if ((data[6] != tmpdata[6]) || (data[7] != tmpdata[7]))
 			badworden &= (~BIT3);
 	}
@@ -955,13 +955,13 @@ u16 Efuse_GetCurrentSize(struct adapter *pAdapter, bool bPseudoTest)
 		rtw_hal_get_hwreg(pAdapter, HW_VAR_EFUSE_BYTES, (u8 *)&efuse_addr);
 
 	while (bContinual &&
-	       efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data, bPseudoTest) &&
+	       efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data) &&
 	       AVAILABLE_EFUSE_ADDR(efuse_addr)) {
 		if (efuse_data != 0xFF) {
 			if ((efuse_data&0x1F) == 0x0F) {		/* extended header */
 				hoffset = efuse_data;
 				efuse_addr++;
-				efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data, bPseudoTest);
+				efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data);
 				if ((efuse_data & 0x0F) == 0x0F) {
 					efuse_addr++;
 					continue;
@@ -1018,11 +1018,11 @@ int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseu
 	while (bContinual && AVAILABLE_EFUSE_ADDR(efuse_addr)) {
 		/*   Header Read ------------- */
 		if (ReadState & PG_STATE_HEADER) {
-			if (efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data, bPseudoTest) && (efuse_data != 0xFF)) {
+			if (efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data) && (efuse_data != 0xFF)) {
 				if (EXT_HEADER(efuse_data)) {
 					tmp_header = efuse_data;
 					efuse_addr++;
-					efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data, bPseudoTest);
+					efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data);
 					if (!ALL_WORDS_DISABLED(efuse_data)) {
 						hoffset = ((tmp_header & 0xE0) >> 5) | ((efuse_data & 0xF0) >> 1);
 						hworden = efuse_data & 0x0F;
@@ -1040,7 +1040,7 @@ int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseu
 
 				if (hoffset == offset) {
 					for (tmpidx = 0; tmpidx < word_cnts*2; tmpidx++) {
-						if (efuse_OneByteRead(pAdapter, efuse_addr+1+tmpidx, &efuse_data, bPseudoTest)) {
+						if (efuse_OneByteRead(pAdapter, efuse_addr+1+tmpidx, &efuse_data)) {
 							tmpdata[tmpidx] = efuse_data;
 							if (efuse_data != 0xff)
 								bDataEmpty = false;
@@ -1116,14 +1116,14 @@ static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuse
 	while (efuse_addr < efuse_max_available_len) {
 		pg_header = ((pTargetPkt->offset & 0x07) << 5) | 0x0F;
 		efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
-		efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header, bPseudoTest);
+		efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 
 		while (tmp_header == 0xFF) {
 			if (repeatcnt++ > EFUSE_REPEAT_THRESHOLD_)
 				return false;
 
 			efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
-			efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header, bPseudoTest);
+			efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 		}
 
 		/* to write ext_header */
@@ -1133,14 +1133,14 @@ static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuse
 			pg_header = ((pTargetPkt->offset & 0x78) << 1) | pTargetPkt->word_en;
 
 			efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
-			efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header, bPseudoTest);
+			efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 
 			while (tmp_header == 0xFF) {
 				if (repeatcnt++ > EFUSE_REPEAT_THRESHOLD_)
 					return false;
 
 				efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
-				efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header, bPseudoTest);
+				efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 			}
 
 			if ((tmp_header & 0x0F) == 0x0F) {	/* word_en PG fail */
@@ -1181,13 +1181,13 @@ static bool hal_EfusePgPacketWrite1ByteHeader(struct adapter *pAdapter, u8 efuse
 	pg_header = ((pTargetPkt->offset << 4) & 0xf0) | pTargetPkt->word_en;
 
 	efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
-	efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header, bPseudoTest);
+	efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 
 	while (tmp_header == 0xFF) {
 		if (repeatcnt++ > EFUSE_REPEAT_THRESHOLD_)
 			return false;
 		efuse_OneByteWrite(pAdapter, efuse_addr, pg_header, bPseudoTest);
-		efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header, bPseudoTest);
+		efuse_OneByteRead(pAdapter, efuse_addr, &tmp_header);
 	}
 
 	if (pg_header == tmp_header) {
@@ -1277,7 +1277,7 @@ static bool hal_EfuseCheckIfDatafollowed(struct adapter *pAdapter, u8 word_cnts,
 	u8 i, efuse_data;
 
 	for (i = 0; i < (word_cnts*2); i++) {
-		if (efuse_OneByteRead(pAdapter, (startAddr+i), &efuse_data, bPseudoTest) && (efuse_data != 0xFF))
+		if (efuse_OneByteRead(pAdapter, (startAddr+i), &efuse_data) && (efuse_data != 0xFF))
 			bRet = true;
 	}
 	return bRet;
@@ -1314,11 +1314,11 @@ static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u
 			break;
 		}
 
-		if (efuse_OneByteRead(pAdapter, startAddr, &efuse_data, bPseudoTest) && (efuse_data != 0xFF)) {
+		if (efuse_OneByteRead(pAdapter, startAddr, &efuse_data) && (efuse_data != 0xFF)) {
 			if (EXT_HEADER(efuse_data)) {
 				cur_header = efuse_data;
 				startAddr++;
-				efuse_OneByteRead(pAdapter, startAddr, &efuse_data, bPseudoTest);
+				efuse_OneByteRead(pAdapter, startAddr, &efuse_data);
 				if (ALL_WORDS_DISABLED(efuse_data)) {
 					bRet = false;
 					break;
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 0849f85..f9bc50d 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -127,7 +127,7 @@ u16 Efuse_GetCurrentSize(struct adapter *adapter, bool test);
 u8 Efuse_CalculateWordCnts(u8 word_en);
 void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
 			      void *out);
-u8 efuse_OneByteRead(struct adapter *adapter, u16 addr, u8 *data, bool test);
+u8 efuse_OneByteRead(struct adapter *adapter, u16 addr, u8 *data);
 u8 efuse_OneByteWrite(struct adapter *adapter, u16 addr, u8 data, bool	test);
 
 void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset,
-- 
1.7.10.4

