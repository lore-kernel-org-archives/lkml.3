Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbaFTPEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:04:33 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61812 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934461AbaFTPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:04:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 33/41] staging: rtl8188eu: Efuse_WordEnableDataWrite(): Remove unused parameter test
Date: Fri, 20 Jun 2014 20:29:39 +0530
Message-Id: <1403276387-11841-34-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    8 ++++----
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index b895d36..1945099 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -882,7 +882,7 @@ void EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, v
 	}
 }
 
-u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data, bool bPseudoTest)
+u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data)
 {
 	u16	tmpaddr = 0;
 	u16	start_addr = efuse_addr;
@@ -1071,7 +1071,7 @@ static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, st
 
 	if (Efuse_PgPacketRead(pAdapter, pFixPkt->offset, originaldata, bPseudoTest)) {
 		/* check if data exist */
-		badworden = Efuse_WordEnableDataWrite(pAdapter, efuse_addr+1, pFixPkt->word_en, originaldata, bPseudoTest);
+		badworden = Efuse_WordEnableDataWrite(pAdapter, efuse_addr+1, pFixPkt->word_en, originaldata);
 
 		if (badworden != 0xf) {	/*  write fail */
 			PgWriteSuccess = Efuse_PgPacketWrite(pAdapter, pFixPkt->offset, badworden, originaldata, bPseudoTest);
@@ -1198,7 +1198,7 @@ static bool hal_EfusePgPacketWriteData(struct adapter *pAdapter, u8 efuseType, u
 	u32	PgWriteSuccess = 0;
 
 	badworden = 0x0f;
-	badworden = Efuse_WordEnableDataWrite(pAdapter, efuse_addr+1, pTargetPkt->word_en, pTargetPkt->data, bPseudoTest);
+	badworden = Efuse_WordEnableDataWrite(pAdapter, efuse_addr+1, pTargetPkt->word_en, pTargetPkt->data);
 	if (badworden == 0x0F) {
 		/*  write ok */
 		return true;
@@ -1325,7 +1325,7 @@ static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u
 			    (!hal_EfuseCheckIfDatafollowed(pAdapter, curPkt.word_cnts, startAddr+1, bPseudoTest)) &&
 			    wordEnMatched(pTargetPkt, &curPkt, &matched_wden)) {
 				/*  Here to write partial data */
-				badworden = Efuse_WordEnableDataWrite(pAdapter, startAddr+1, matched_wden, pTargetPkt->data, bPseudoTest);
+				badworden = Efuse_WordEnableDataWrite(pAdapter, startAddr+1, matched_wden, pTargetPkt->data);
 				if (badworden != 0x0F) {
 					u32	PgWriteSuccess = 0;
 					/*  if write fail on some words, write these bad words again */
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 1de6fa7..f8737a4 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -138,7 +138,7 @@ bool Efuse_PgPacketWrite(struct adapter *adapter, u8 offset, u8 word, u8 *data,
 			bool test);
 void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata);
 u8 Efuse_WordEnableDataWrite(struct adapter *adapter, u16 efuse_addr,
-			     u8 word_en, u8 *data, bool test);
+			     u8 word_en, u8 *data);
 
 void EFUSE_ShadowMapUpdate(struct adapter *adapter, u8 efusetype);
 void EFUSE_ShadowRead(struct adapter *adapt, u8 type, u16 offset, u32 *val);
-- 
1.7.10.4

