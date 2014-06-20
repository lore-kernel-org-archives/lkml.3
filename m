Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaFTPBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:01:13 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:53491 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaFTPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:01:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/41] staging: rtl8188eu: assign hal_EfusePgPacketRead_8188e() to ->Efuse_PgPacketRead
Date: Fri, 20 Jun 2014 20:29:14 +0530
Message-Id: <1403276387-11841-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

assign hal_EfusePgPacketRead_8188e() to ->Efuse_PgPacketRead directly
instead of going through many functions.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   29 +--------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 7c05bbe..c5bbb08 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1223,33 +1223,6 @@ static int hal_EfusePgPacketRead_8188e(struct adapter *pAdapter, u8 offset, u8 *
 		return true;
 }
 
-static int Hal_EfusePgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseudoTest)
-{
-	int	ret;
-
-	ret = hal_EfusePgPacketRead_8188e(pAdapter, offset, data, bPseudoTest);
-	return ret;
-}
-
-static int Hal_EfusePgPacketRead_Pseudo(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseudoTest)
-{
-	int	ret;
-
-	ret = hal_EfusePgPacketRead_8188e(pAdapter, offset, data, bPseudoTest);
-	return ret;
-}
-
-static int rtl8188e_Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseudoTest)
-{
-	int	ret;
-
-	if (bPseudoTest)
-		ret = Hal_EfusePgPacketRead_Pseudo (pAdapter, offset, data, bPseudoTest);
-	else
-		ret = Hal_EfusePgPacketRead(pAdapter, offset, data, bPseudoTest);
-	return ret;
-}
-
 static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, struct pgpkt *pFixPkt, u16 *pAddr, bool bPseudoTest)
 {
 	u8 originaldata[8], badworden = 0;
@@ -1748,7 +1721,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->ReadEFuse = &ReadEFuseByIC;
 	pHalFunc->EFUSEGetEfuseDefinition = &rtl8188e_EFUSE_GetEfuseDefinition;
 	pHalFunc->EfuseGetCurrentSize = &hal_EfuseGetCurrentSize_8188e;
-	pHalFunc->Efuse_PgPacketRead = &rtl8188e_Efuse_PgPacketRead;
+	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
 	pHalFunc->Efuse_PgPacketWrite = &rtl8188e_Efuse_PgPacketWrite;
 	pHalFunc->Efuse_WordEnableDataWrite = &rtl8188e_Efuse_WordEnableDataWrite;
 
-- 
1.7.10.4

