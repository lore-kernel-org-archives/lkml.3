Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaFTPBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:01:07 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34295 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaFTPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:01:03 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/41] staging: rtl8188eu: Rename Hal_EFUSEGetEfuseDefinition88E()
Date: Fri, 20 Jun 2014 20:29:13 +0530
Message-Id: <1403276387-11841-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename Hal_EFUSEGetEfuseDefinition88E() to rtl8188e_EFUSE_GetEfuseDefinition()
and remove original rtl8188e_EFUSE_GetEfuseDefinition(), so that driver can call
Hal_EFUSEGetEfuseDefinition88E() directly without going through
rtl8188e_EFUSE_GetEfuseDefinition().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    7 +------
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index b450458..7752efd 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -229,7 +229,7 @@ static void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset,
 void EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut, bool pseudo
 	)
 {
-	pAdapter->HalFunc.EFUSEGetEfuseDefinition(pAdapter, efuseType, type, pOut, pseudo);
+	pAdapter->HalFunc.EFUSEGetEfuseDefinition(pAdapter, efuseType, type, pOut);
 }
 
 /*-----------------------------------------------------------------------------
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 9dda5f6..7c05bbe 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -957,7 +957,7 @@ exit:
 }
 
 /* Do not support BT */
-static void Hal_EFUSEGetEfuseDefinition88E(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut)
+static void rtl8188e_EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut)
 {
 	switch (type) {
 	case TYPE_EFUSE_MAX_SECTION:
@@ -1019,11 +1019,6 @@ static void Hal_EFUSEGetEfuseDefinition88E(struct adapter *pAdapter, u8 efuseTyp
 	}
 }
 
-static void rtl8188e_EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut, bool bPseudoTest)
-{
-		Hal_EFUSEGetEfuseDefinition88E(pAdapter, efuseType, type, pOut);
-}
-
 static u8 Hal_EfuseWordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_en, u8 *data, bool bPseudoTest)
 {
 	u16	tmpaddr = 0;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index ecc92a6..d971e6e 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -238,7 +238,7 @@ struct hal_ops {
 	void (*ReadEFuse)(struct adapter *padapter, u8 efuseType, u16 _offset,
 			  u16 _size_byte, u8 *pbuf, bool bPseudoTest);
 	void (*EFUSEGetEfuseDefinition)(struct adapter *padapter, u8 efuseType,
-					u8 type, void *pOut, bool bPseudoTest);
+					u8 type, void *pOut);
 	u16	(*EfuseGetCurrentSize)(struct adapter *padapter,
 				       bool bPseudoTest);
 	int	(*Efuse_PgPacketRead)(struct adapter *adapter, u8 offset,
-- 
1.7.10.4

