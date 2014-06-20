Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbaFTPCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:02:54 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46728 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbaFTPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:02:52 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/41] staging: rtl8188eu: Rename hal_EfusePgPacketRead_8188e() to Efuse_PgPacketRead()
Date: Fri, 20 Jun 2014 20:29:24 +0530
Message-Id: <1403276387-11841-19-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename hal_EfusePgPacketRead_8188e() to Efuse_PgPacketRead()
and remove original EFUSE_GetEfuseDefinition() function,
so that driver can call hal_EfusePgPacketRead_8188e() directly
without going through Efuse_PgPacketRead().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    9 ---------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    3 +--
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 --
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index ac77184..e15784e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -264,15 +264,6 @@ u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data, bool pseudo)
 	return result;
 }
 
-int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool pseudo)
-{
-	int	ret = 0;
-
-	ret =  pAdapter->HalFunc.Efuse_PgPacketRead(pAdapter, offset, data, pseudo);
-
-	return ret;
-}
-
 int Efuse_PgPacketWrite(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *data, bool pseudo)
 {
 	int ret;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 7515102..24d3993 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -989,7 +989,7 @@ u16 Efuse_GetCurrentSize(struct adapter *pAdapter, bool bPseudoTest)
 	return efuse_addr;
 }
 
-static int hal_EfusePgPacketRead_8188e(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseudoTest)
+int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseudoTest)
 {
 	u8 ReadState = PG_STATE_HEADER;
 	int	bContinual = true;
@@ -1542,7 +1542,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->write_rfreg = &rtl8188e_PHY_SetRFReg;
 
 	/*  Efuse related function */
-	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
 	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 5e64df7..9597c35 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -233,8 +233,6 @@ struct hal_ops {
 			       enum rf_radio_path eRFPath, u32 RegAddr,
 			       u32 BitMask, u32 Data);
 
-	int	(*Efuse_PgPacketRead)(struct adapter *adapter, u8 offset,
-				      u8 *data, bool bPseudoTest);
 	bool	(*Efuse_PgPacketWrite)(struct adapter *padapter, u8 offset,
 				       u8 word_en, u8 *data, bool bPseudoTest);
 	bool	(*Efuse_PgPacketWrite_BT)(struct adapter *padapter, u8 offset,
-- 
1.7.10.4

