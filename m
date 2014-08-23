Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaHWOTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:19:45 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48999 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHWOTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:19:42 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/20] staging: rtl8188eu: Remove unused wrapper function rtw_hal_write_bbreg()
Date: Sat, 23 Aug 2014 19:48:25 +0530
Message-Id: <1408803521-13715-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c          |    7 -------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    1 -
 drivers/staging/rtl8188eu/include/hal_intf.h      |    4 ----
 3 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 0d21e60..538a0f6 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -256,13 +256,6 @@ void rtw_hal_add_ra_tid(struct adapter *adapt, u32 bitmap, u8 arg,
 					       rssi_level);
 }
 
-void rtw_hal_write_bbreg(struct adapter *adapt, u32 regaddr, u32 bitmask,
-			 u32 data)
-{
-	if (adapt->HalFunc.write_bbreg)
-		adapt->HalFunc.write_bbreg(adapt, regaddr, bitmask, data);
-}
-
 u32 rtw_hal_read_rfreg(struct adapter *adapt, enum rf_radio_path rfpath,
 		       u32 regaddr, u32 bitmask)
 {
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 204d2e4..ae7cb8d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -230,7 +230,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	pHalFunc->AntDivBeforeLinkHandler = &AntDivBeforeLink8188E;
 	pHalFunc->AntDivCompareHandler = &AntDivCompare8188E;
-	pHalFunc->write_bbreg = &rtl8188e_PHY_SetBBReg;
 	pHalFunc->read_rfreg = &rtl8188e_PHY_QueryRFReg;
 	pHalFunc->write_rfreg = &rtl8188e_PHY_SetRFReg;
 
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 606fd60..9191993 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -213,8 +213,6 @@ struct hal_ops {
 			    struct xmit_frame *pxmitframe);
 	s32 (*mgnt_xmit)(struct adapter *padapter,
 			 struct xmit_frame *pmgntframe);
-	void	(*write_bbreg)(struct adapter *padapter, u32 RegAddr,
-			       u32 BitMask, u32 Data);
 	u32	(*read_rfreg)(struct adapter *padapter,
 			      enum rf_radio_path eRFPath, u32 RegAddr,
 			      u32 BitMask);
@@ -300,8 +298,6 @@ void	rtw_hal_clone_data(struct adapter *dst_adapt,
 
 void rtw_hal_bcn_related_reg_setting(struct adapter *padapter);
 
-void	rtw_hal_write_bbreg(struct adapter *padapter, u32 RegAddr, u32 BitMask,
-			    u32 Data);
 u32	rtw_hal_read_rfreg(struct adapter *padapter, enum rf_radio_path eRFPath,
 			   u32 RegAddr, u32 BitMask);
 void	rtw_hal_write_rfreg(struct adapter *padapter,
-- 
1.7.10.4

