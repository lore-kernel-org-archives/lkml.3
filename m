Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaHWOTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:19:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63653 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaHWOT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:19:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/20] staging: rtl8188eu: Remove unused wrapper function rtw_hal_read_bbreg()
Date: Sat, 23 Aug 2014 19:48:23 +0530
Message-Id: <1408803521-13715-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c          |    9 ---------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    1 -
 drivers/staging/rtl8188eu/include/hal_intf.h      |    4 ----
 3 files changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index bc89e99..0d21e60 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -256,15 +256,6 @@ void rtw_hal_add_ra_tid(struct adapter *adapt, u32 bitmap, u8 arg,
 					       rssi_level);
 }
 
-u32 rtw_hal_read_bbreg(struct adapter *adapt, u32 regaddr, u32 bitmask)
-{
-	u32 data = 0;
-
-	if (adapt->HalFunc.read_bbreg)
-		data = adapt->HalFunc.read_bbreg(adapt, regaddr, bitmask);
-	return data;
-}
-
 void rtw_hal_write_bbreg(struct adapter *adapt, u32 regaddr, u32 bitmask,
 			 u32 data)
 {
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 50b1332..204d2e4 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -230,7 +230,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	pHalFunc->AntDivBeforeLinkHandler = &AntDivBeforeLink8188E;
 	pHalFunc->AntDivCompareHandler = &AntDivCompare8188E;
-	pHalFunc->read_bbreg = &rtl8188e_PHY_QueryBBReg;
 	pHalFunc->write_bbreg = &rtl8188e_PHY_SetBBReg;
 	pHalFunc->read_rfreg = &rtl8188e_PHY_QueryRFReg;
 	pHalFunc->write_rfreg = &rtl8188e_PHY_SetRFReg;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 1c5303e..606fd60 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -213,9 +213,6 @@ struct hal_ops {
 			    struct xmit_frame *pxmitframe);
 	s32 (*mgnt_xmit)(struct adapter *padapter,
 			 struct xmit_frame *pmgntframe);
-
-	u32	(*read_bbreg)(struct adapter *padapter, u32 RegAddr,
-			      u32 BitMask);
 	void	(*write_bbreg)(struct adapter *padapter, u32 RegAddr,
 			       u32 BitMask, u32 Data);
 	u32	(*read_rfreg)(struct adapter *padapter,
@@ -303,7 +300,6 @@ void	rtw_hal_clone_data(struct adapter *dst_adapt,
 
 void rtw_hal_bcn_related_reg_setting(struct adapter *padapter);
 
-u32	rtw_hal_read_bbreg(struct adapter *padapter, u32 RegAddr, u32 BitMask);
 void	rtw_hal_write_bbreg(struct adapter *padapter, u32 RegAddr, u32 BitMask,
 			    u32 Data);
 u32	rtw_hal_read_rfreg(struct adapter *padapter, enum rf_radio_path eRFPath,
-- 
1.7.10.4

