Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbaFTPBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:01:18 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55417 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaFTPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:01:15 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/41] staging:rtl8188eu:assign hal_EfusePgPacketWrite_8188e() to ->Efuse_PgPacketWrite
Date: Fri, 20 Jun 2014 20:29:15 +0530
Message-Id: <1403276387-11841-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

assign hal_EfusePgPacketWrite_8188e() to ->Efuse_PgPacketWrite directly
instead of going through many functions.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   29 +--------------------
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 +-
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index c5bbb08..7c53ea2 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1567,33 +1567,6 @@ static bool hal_EfusePgPacketWrite_8188e(struct adapter *pAdapter, u8 offset, u8
 	return true;
 }
 
-static int Hal_EfusePgPacketWrite_Pseudo(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *data, bool bPseudoTest)
-{
-	int ret;
-
-	ret = hal_EfusePgPacketWrite_8188e(pAdapter, offset, word_en, data, bPseudoTest);
-	return ret;
-}
-
-static int Hal_EfusePgPacketWrite(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *data, bool bPseudoTest)
-{
-	int	ret = 0;
-	ret = hal_EfusePgPacketWrite_8188e(pAdapter, offset, word_en, data, bPseudoTest);
-
-	return ret;
-}
-
-static int rtl8188e_Efuse_PgPacketWrite(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *data, bool bPseudoTest)
-{
-	int	ret;
-
-	if (bPseudoTest)
-		ret = Hal_EfusePgPacketWrite_Pseudo (pAdapter, offset, word_en, data, bPseudoTest);
-	else
-		ret = Hal_EfusePgPacketWrite(pAdapter, offset, word_en, data, bPseudoTest);
-	return ret;
-}
-
 static struct HAL_VERSION ReadChipVersion8188E(struct adapter *padapter)
 {
 	u32				value32;
@@ -1722,7 +1695,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->EFUSEGetEfuseDefinition = &rtl8188e_EFUSE_GetEfuseDefinition;
 	pHalFunc->EfuseGetCurrentSize = &hal_EfuseGetCurrentSize_8188e;
 	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
-	pHalFunc->Efuse_PgPacketWrite = &rtl8188e_Efuse_PgPacketWrite;
+	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
 	pHalFunc->Efuse_WordEnableDataWrite = &rtl8188e_Efuse_WordEnableDataWrite;
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index d971e6e..f4f6443 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -243,7 +243,7 @@ struct hal_ops {
 				       bool bPseudoTest);
 	int	(*Efuse_PgPacketRead)(struct adapter *adapter, u8 offset,
 				      u8 *data, bool bPseudoTest);
-	int	(*Efuse_PgPacketWrite)(struct adapter *padapter, u8 offset,
+	bool	(*Efuse_PgPacketWrite)(struct adapter *padapter, u8 offset,
 				       u8 word_en, u8 *data, bool bPseudoTest);
 	u8	(*Efuse_WordEnableDataWrite)(struct adapter *padapter,
 					     u16 efuse_addr, u8 word_en,
-- 
1.7.10.4

