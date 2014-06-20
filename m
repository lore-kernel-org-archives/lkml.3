Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbaFTPBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:01:24 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57192 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaFTPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:01:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/41] staging:rtl8188eu: Assign rtl8188e_Efuse_WordEnableDataWrite() to ->Efuse_WordEnableDataWrite
Date: Fri, 20 Jun 2014 20:29:16 +0530
Message-Id: <1403276387-11841-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign rtl8188e_Efuse_WordEnableDataWrite() to ->Efuse_WordEnableDataWrite
instead of going through many functions.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 7c53ea2..b3bc125 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1071,25 +1071,6 @@ static u8 Hal_EfuseWordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr,
 	return badworden;
 }
 
-static u8 Hal_EfuseWordEnableDataWrite_Pseudo(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data, bool bPseudoTest)
-{
-	u8 ret;
-
-	ret = Hal_EfuseWordEnableDataWrite(pAdapter, efuse_addr, word_en, data, bPseudoTest);
-	return ret;
-}
-
-static u8 rtl8188e_Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data, bool bPseudoTest)
-{
-	u8 ret = 0;
-
-	if (bPseudoTest)
-		ret = Hal_EfuseWordEnableDataWrite_Pseudo (pAdapter, efuse_addr, word_en, data, bPseudoTest);
-	else
-		ret = Hal_EfuseWordEnableDataWrite(pAdapter, efuse_addr, word_en, data, bPseudoTest);
-	return ret;
-}
-
 static u16 hal_EfuseGetCurrentSize_8188e(struct adapter *pAdapter, bool bPseudoTest)
 {
 	int	bContinual = true;
@@ -1696,7 +1677,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->EfuseGetCurrentSize = &hal_EfuseGetCurrentSize_8188e;
 	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
 	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
-	pHalFunc->Efuse_WordEnableDataWrite = &rtl8188e_Efuse_WordEnableDataWrite;
+	pHalFunc->Efuse_WordEnableDataWrite = &Hal_EfuseWordEnableDataWrite;
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
-- 
1.7.10.4

