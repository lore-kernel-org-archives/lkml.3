Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaFTPC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:02:29 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37300 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbaFTPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:02:24 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/41] staging: rtl8188eu: Rename function Hal_EfuseWordEnableDataWrite()
Date: Fri, 20 Jun 2014 20:29:21 +0530
Message-Id: <1403276387-11841-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename Hal_EfuseWordEnableDataWrite() to Efuse_WordEnableDataWrite()
and remove original EFUSE_GetEfuseDefinition() function,
so that driver can call Hal_EfuseWordEnableDataWrite() directly
without going through Efuse_WordEnableDataWrite().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    9 ---------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    3 +--
 drivers/staging/rtl8188eu/include/hal_intf.h      |    3 ---
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 7adb7b4..f2d374d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -350,15 +350,6 @@ void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata)
 	}
 }
 
-u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data, bool pseudo)
-{
-	u8 ret = 0;
-
-	ret =  pAdapter->HalFunc.Efuse_WordEnableDataWrite(pAdapter, efuse_addr, word_en, data, pseudo);
-
-	return ret;
-}
-
 static u8 efuse_read8(struct adapter *padapter, u16 address, u8 *value)
 {
 	return efuse_OneByteRead(padapter, address, value, false);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 525973f..8e93d48 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1026,7 +1026,7 @@ void EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, v
 	}
 }
 
-static u8 Hal_EfuseWordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data, bool bPseudoTest)
+u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data, bool bPseudoTest)
 {
 	u16	tmpaddr = 0;
 	u16	start_addr = efuse_addr;
@@ -1681,7 +1681,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->ReadEFuse = &ReadEFuseByIC;
 	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
 	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
-	pHalFunc->Efuse_WordEnableDataWrite = &Hal_EfuseWordEnableDataWrite;
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 38285d6..a7cad6f 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -239,9 +239,6 @@ struct hal_ops {
 				      u8 *data, bool bPseudoTest);
 	bool	(*Efuse_PgPacketWrite)(struct adapter *padapter, u8 offset,
 				       u8 word_en, u8 *data, bool bPseudoTest);
-	u8	(*Efuse_WordEnableDataWrite)(struct adapter *padapter,
-					     u16 efuse_addr, u8 word_en,
-					     u8 *data, bool bPseudoTest);
 	bool	(*Efuse_PgPacketWrite_BT)(struct adapter *padapter, u8 offset,
 					  u8 word_en, u8 *data, bool test);
 
-- 
1.7.10.4

