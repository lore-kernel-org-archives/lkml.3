Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaFTPA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:00:29 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64442 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaFTPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:00:24 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/41] staging: rtl8188eu: Remove rtl8188e_ReadEFuse()
Date: Fri, 20 Jun 2014 20:29:08 +0530
Message-Id: <1403276387-11841-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8188e_ReadEFuse() checks bool bPseudoTest and then calls suitable
function to read Fuse, ReadEFuseByIC() also does same thing.
So use ReadEFuseByIC() and drop rtl8188e_ReadEFuse().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index fdf2acb..1d6224a 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -961,16 +961,6 @@ static void ReadEFuse_Pseudo(struct adapter *Adapter, u8 efuseType, u16 _offset,
 	Hal_EfuseReadEFuse88E(Adapter, _offset, _size_byte, pbuf, bPseudoTest);
 }
 
-static void rtl8188e_ReadEFuse(struct adapter *Adapter, u8 efuseType,
-			       u16 _offset, u16 _size_byte, u8 *pbuf,
-			       bool bPseudoTest)
-{
-	if (bPseudoTest)
-		ReadEFuse_Pseudo (Adapter, efuseType, _offset, _size_byte, pbuf, bPseudoTest);
-	else
-		ReadEFuseByIC(Adapter, efuseType, _offset, _size_byte, pbuf, bPseudoTest);
-}
-
 /* Do not support BT */
 static void Hal_EFUSEGetEfuseDefinition88E(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut)
 {
@@ -1849,7 +1839,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	/*  Efuse related function */
 	pHalFunc->EfusePowerSwitch = &rtl8188e_EfusePowerSwitch;
-	pHalFunc->ReadEFuse = &rtl8188e_ReadEFuse;
+	pHalFunc->ReadEFuse = &ReadEFuseByIC;
 	pHalFunc->EFUSEGetEfuseDefinition = &rtl8188e_EFUSE_GetEfuseDefinition;
 	pHalFunc->EfuseGetCurrentSize = &rtl8188e_EfuseGetCurrentSize;
 	pHalFunc->Efuse_PgPacketRead = &rtl8188e_Efuse_PgPacketRead;
-- 
1.7.10.4

