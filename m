Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaFTPA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:00:57 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46335 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaFTPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:00:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/41] staging: rtl8188eu: Remove function Hal_EFUSEGetEfuseDefinition_Pseudo88E()
Date: Fri, 20 Jun 2014 20:29:12 +0530
Message-Id: <1403276387-11841-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Definition of Hal_EFUSEGetEfuseDefinition_Pseudo88E() is identical
to Hal_EFUSEGetEfuseDefinition88E().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   65 ---------------------
 1 file changed, 65 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 8bd7205..9dda5f6 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1019,73 +1019,8 @@ static void Hal_EFUSEGetEfuseDefinition88E(struct adapter *pAdapter, u8 efuseTyp
 	}
 }
 
-static void Hal_EFUSEGetEfuseDefinition_Pseudo88E(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut)
-{
-	switch (type) {
-	case TYPE_EFUSE_MAX_SECTION:
-		{
-			u8 *pMax_section;
-			pMax_section = (u8 *)pOut;
-			*pMax_section = EFUSE_MAX_SECTION_88E;
-		}
-		break;
-	case TYPE_EFUSE_REAL_CONTENT_LEN:
-		{
-			u16 *pu2Tmp;
-			pu2Tmp = (u16 *)pOut;
-			*pu2Tmp = EFUSE_REAL_CONTENT_LEN_88E;
-		}
-		break;
-	case TYPE_EFUSE_CONTENT_LEN_BANK:
-		{
-			u16 *pu2Tmp;
-			pu2Tmp = (u16 *)pOut;
-			*pu2Tmp = EFUSE_REAL_CONTENT_LEN_88E;
-		}
-		break;
-	case TYPE_AVAILABLE_EFUSE_BYTES_BANK:
-		{
-			u16 *pu2Tmp;
-			pu2Tmp = (u16 *)pOut;
-			*pu2Tmp = (u16)(EFUSE_REAL_CONTENT_LEN_88E-EFUSE_OOB_PROTECT_BYTES_88E);
-		}
-		break;
-	case TYPE_AVAILABLE_EFUSE_BYTES_TOTAL:
-		{
-			u16 *pu2Tmp;
-			pu2Tmp = (u16 *)pOut;
-			*pu2Tmp = (u16)(EFUSE_REAL_CONTENT_LEN_88E-EFUSE_OOB_PROTECT_BYTES_88E);
-		}
-		break;
-	case TYPE_EFUSE_MAP_LEN:
-		{
-			u16 *pu2Tmp;
-			pu2Tmp = (u16 *)pOut;
-			*pu2Tmp = (u16)EFUSE_MAP_LEN_88E;
-		}
-		break;
-	case TYPE_EFUSE_PROTECT_BYTES_BANK:
-		{
-			u8 *pu1Tmp;
-			pu1Tmp = (u8 *)pOut;
-			*pu1Tmp = (u8)(EFUSE_OOB_PROTECT_BYTES_88E);
-		}
-		break;
-	default:
-		{
-			u8 *pu1Tmp;
-			pu1Tmp = (u8 *)pOut;
-			*pu1Tmp = 0;
-		}
-		break;
-	}
-}
-
 static void rtl8188e_EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut, bool bPseudoTest)
 {
-	if (bPseudoTest)
-		Hal_EFUSEGetEfuseDefinition_Pseudo88E(pAdapter, efuseType, type, pOut);
-	else
 		Hal_EFUSEGetEfuseDefinition88E(pAdapter, efuseType, type, pOut);
 }
 
-- 
1.7.10.4

