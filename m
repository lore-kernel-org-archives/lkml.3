Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaHWOTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:19:21 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55672 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaHWOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:19:20 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/20] staging: rtl8188eu: Rework function phy_CalculateBitShift()
Date: Sat, 23 Aug 2014 19:48:22 +0530
Message-Id: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   42 ++++-------------------
 1 file changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 0f90cf4..522f185 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -24,48 +24,18 @@
 #include <rtw_iol.h>
 #include <rtl8188e_hal.h>
 
-/*---------------------------Define Local Constant---------------------------*/
-/* Channel switch:The size of command tables for switch channel*/
 #define MAX_PRECMD_CNT 16
 #define MAX_RFDEPENDCMD_CNT 16
 #define MAX_POSTCMD_CNT 16
 
 #define MAX_DOZE_WAITING_TIMES_9x 64
 
-/*---------------------------Define Local Constant---------------------------*/
-
-
-/*------------------------Define global variable-----------------------------*/
-
-/*------------------------Define local variable------------------------------*/
-
-
-/*--------------------Define export function prototype-----------------------*/
-/*  Please refer to header file */
-/*--------------------Define export function prototype-----------------------*/
-
-/*----------------------------Function Body----------------------------------*/
-/*  */
-/*  1. BB register R/W API */
-/*  */
-
-/**
-* Function:	phy_CalculateBitShift
-*
-* OverView:	Get shifted position of the BitMask
-*
-* Input:
-*			u32		BitMask,
-*
-* Output:	none
-* Return:		u32		Return the shift bit bit position of the mask
-*/
-static	u32 phy_CalculateBitShift(u32 BitMask)
+static u32 cal_bit_shift(u32 bitmask)
 {
 	u32 i;
 
 	for (i = 0; i <= 31; i++) {
-		if (((BitMask>>i) &  0x1) == 1)
+		if (((bitmask >> i) & 0x1) == 1)
 			break;
 	}
 	return i;
@@ -95,7 +65,7 @@ rtl8188e_PHY_QueryBBReg(
 	u32 ReturnValue = 0, OriginalValue, BitShift;
 
 	OriginalValue = usb_read32(Adapter, RegAddr);
-	BitShift = phy_CalculateBitShift(BitMask);
+	BitShift = cal_bit_shift(BitMask);
 	ReturnValue = (OriginalValue & BitMask) >> BitShift;
 	return ReturnValue;
 }
@@ -125,7 +95,7 @@ void rtl8188e_PHY_SetBBReg(struct adapter *Adapter, u32 RegAddr, u32 BitMask, u3
 
 	if (BitMask != bMaskDWord) { /* if not "double word" write */
 		OriginalValue = usb_read32(Adapter, RegAddr);
-		BitShift = phy_CalculateBitShift(BitMask);
+		BitShift = cal_bit_shift(BitMask);
 		Data = ((OriginalValue & (~BitMask)) | (Data << BitShift));
 	}
 
@@ -310,7 +280,7 @@ u32 rtl8188e_PHY_QueryRFReg(struct adapter *Adapter, enum rf_radio_path eRFPath,
 
 	Original_Value = phy_RFSerialRead(Adapter, eRFPath, RegAddr);
 
-	BitShift =  phy_CalculateBitShift(BitMask);
+	BitShift =  cal_bit_shift(BitMask);
 	Readback_Value = (Original_Value & BitMask) >> BitShift;
 	return Readback_Value;
 }
@@ -347,7 +317,7 @@ rtl8188e_PHY_SetRFReg(
 	/*  RF data is 12 bits only */
 	if (BitMask != bRFRegOffsetMask) {
 		Original_Value = phy_RFSerialRead(Adapter, eRFPath, RegAddr);
-		BitShift =  phy_CalculateBitShift(BitMask);
+		BitShift =  cal_bit_shift(BitMask);
 		Data = ((Original_Value & (~BitMask)) | (Data << BitShift));
 	}
 
-- 
1.7.10.4

