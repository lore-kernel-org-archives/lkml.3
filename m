Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbaFTPCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:02:15 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44348 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbaFTPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:02:11 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/41] staging: rtl8188eu: Rename rtl8188e_EfusePowerSwitch() to Efuse_PowerSwitch()
Date: Fri, 20 Jun 2014 20:29:20 +0530
Message-Id: <1403276387-11841-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename rtl8188e_EfusePowerSwitch() to Efuse_PowerSwitch()
and remove original Efuse_PowerSwitch() function,
so that driver can call rtl8188e_EfusePowerSwitch() directly
without going through Efuse_PowerSwitch().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |   27 ---------------------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   12 ++++++---
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 --
 3 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 5cf5a30..7adb7b4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -76,33 +76,6 @@ Efuse_Write1ByteToFakeContent(
 	return true;
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	Efuse_PowerSwitch
- *
- * Overview:	When we want to enable write operation, we should change to
- *				pwr on state. When we stop write, we should switch to 500k mode
- *				and disable LDO 2.5V.
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/17/2008	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
-void
-Efuse_PowerSwitch(
-		struct adapter *pAdapter,
-		u8 write,
-		u8 PwrState)
-{
-	pAdapter->HalFunc.EfusePowerSwitch(pAdapter, write, PwrState);
-}
-
 /*  11/16/2008 MH Add description. Get current efuse area enabled word!!. */
 u8
 Efuse_CalculateWordCnts(u8 word_en)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 507e62b..525973f 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -750,8 +750,15 @@ hal_EfusePgPacketWriteData(
 		struct pgpkt *pTargetPkt,
 		bool bPseudoTest);
 
-static void
-rtl8188e_EfusePowerSwitch(
+/*
+ * Function:	Efuse_PowerSwitch
+ *
+ * Overview:	When we want to enable write operation, we should change to
+ *				pwr on state. When we stop write, we should switch to 500k mode
+ *				and disable LDO 2.5V.
+ */
+
+void Efuse_PowerSwitch(
 		struct adapter *pAdapter,
 		u8 bWrite,
 		u8 PwrState)
@@ -1671,7 +1678,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->write_rfreg = &rtl8188e_PHY_SetRFReg;
 
 	/*  Efuse related function */
-	pHalFunc->EfusePowerSwitch = &rtl8188e_EfusePowerSwitch;
 	pHalFunc->ReadEFuse = &ReadEFuseByIC;
 	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
 	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index adf3847..38285d6 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -233,8 +233,6 @@ struct hal_ops {
 			       enum rf_radio_path eRFPath, u32 RegAddr,
 			       u32 BitMask, u32 Data);
 
-	void (*EfusePowerSwitch)(struct adapter *padapter, u8 bWrite,
-				 u8 PwrState);
 	void (*ReadEFuse)(struct adapter *padapter, u8 efuseType, u16 _offset,
 			  u16 _size_byte, u8 *pbuf, bool bPseudoTest);
 	int	(*Efuse_PgPacketRead)(struct adapter *adapter, u8 offset,
-- 
1.7.10.4

