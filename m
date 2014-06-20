Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaFTPB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:01:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48672 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbaFTPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:01:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/41] staging: rtl8188eu: Rename hal_EfuseGetCurrentSize_8188e()
Date: Fri, 20 Jun 2014 20:29:19 +0530
Message-Id: <1403276387-11841-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename hal_EfuseGetCurrentSize_8188e() to Efuse_GetCurrentSize()
and remove original Efuse_GetCurrentSize() function,
so that driver can call hal_EfuseGetCurrentSize_8188e() directly
without going through Efuse_GetCurrentSize().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |   28 ---------------------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    3 +--
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 --
 3 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 4c6ed3b..5cf5a30 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -103,34 +103,6 @@ Efuse_PowerSwitch(
 	pAdapter->HalFunc.EfusePowerSwitch(pAdapter, write, PwrState);
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	efuse_GetCurrentSize
- *
- * Overview:	Get current efuse size!!!
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
- *
- *---------------------------------------------------------------------------*/
-u16
-Efuse_GetCurrentSize(
-	struct adapter *pAdapter,
-	bool pseudo)
-{
-	u16 ret = 0;
-
-	ret = pAdapter->HalFunc.EfuseGetCurrentSize(pAdapter, pseudo);
-
-	return ret;
-}
-
 /*  11/16/2008 MH Add description. Get current efuse area enabled word!!. */
 u8
 Efuse_CalculateWordCnts(u8 word_en)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 80cb54d..507e62b 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1071,7 +1071,7 @@ static u8 Hal_EfuseWordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr,
 	return badworden;
 }
 
-static u16 hal_EfuseGetCurrentSize_8188e(struct adapter *pAdapter, bool bPseudoTest)
+u16 Efuse_GetCurrentSize(struct adapter *pAdapter, bool bPseudoTest)
 {
 	int	bContinual = true;
 	u16	efuse_addr = 0;
@@ -1673,7 +1673,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	/*  Efuse related function */
 	pHalFunc->EfusePowerSwitch = &rtl8188e_EfusePowerSwitch;
 	pHalFunc->ReadEFuse = &ReadEFuseByIC;
-	pHalFunc->EfuseGetCurrentSize = &hal_EfuseGetCurrentSize_8188e;
 	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
 	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
 	pHalFunc->Efuse_WordEnableDataWrite = &Hal_EfuseWordEnableDataWrite;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index d9b0e71..adf3847 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -237,8 +237,6 @@ struct hal_ops {
 				 u8 PwrState);
 	void (*ReadEFuse)(struct adapter *padapter, u8 efuseType, u16 _offset,
 			  u16 _size_byte, u8 *pbuf, bool bPseudoTest);
-	u16	(*EfuseGetCurrentSize)(struct adapter *padapter,
-				       bool bPseudoTest);
 	int	(*Efuse_PgPacketRead)(struct adapter *adapter, u8 offset,
 				      u8 *data, bool bPseudoTest);
 	bool	(*Efuse_PgPacketWrite)(struct adapter *padapter, u8 offset,
-- 
1.7.10.4

