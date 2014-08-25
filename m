Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaHYHNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:13:01 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:53833 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaHYHNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:13:00 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] staging:r8190_rtl8256: coding style: Fixed commenting style
Date: Mon, 25 Aug 2014 12:55:27 +0530
Message-ID: <1408951527-29317-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 25 Aug 2014 07:12:58.0385 (UTC) FILETIME=[FFC2B810:01CFC033]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8190_rtl8256.c file that fixes
commenting style Error

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8192u/r8190_rtl8256.c | 59 +++++++++++++++++---------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8190_rtl8256.c b/drivers/staging/rtl8192u/r8190_rtl8256.c
index 43ed768..8fe35ad 100644
--- a/drivers/staging/rtl8192u/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192u/r8190_rtl8256.c
@@ -61,13 +61,15 @@ void PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH Bandwidth)
 				break;
 		case HT_CHANNEL_WIDTH_20_40:
 				if (priv->card_8192_version == VERSION_819xU_A || priv->card_8192_version == VERSION_819xU_B) { /* 8256 D-cut, E-cut, xiong: consider it later! */
-					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0b, bMask12Bits, 0x300); //phy para:3ba
+					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0b, bMask12Bits, 0x300); /* phy para:3ba */
 					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x2c, bMask12Bits, 0x3df);
 					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0e, bMask12Bits, 0x0a1);
 
-					//cosa add for sd3's request 01/23/2008
+					/* cosa add for sd3's request 01/23/2008
+					 *
+					 */
 					if (priv->chan == 3 || priv->chan == 9)
-						//I need to set priv->chan whenever current channel changes
+						/* I need to set priv->chan whenever current channel changes */
 						rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x14, bMask12Bits, 0x59b);
 					else
 						rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x14, bMask12Bits, 0x5ab);
@@ -91,11 +93,12 @@ void PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH Bandwidth)
 void PHY_RF8256_Config(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	// Initialize general global value
-	//
-	// TODO: Extend RF_PATH_C and RF_PATH_D in the future
+	/* Initialize general global value
+	 *
+	 * TODO: Extend RF_PATH_C and RF_PATH_D in the future
+	 */
 	priv->NumTotalRFPath = RTL819X_TOTAL_RF_PATH;
-	// Config BB and RF
+	/* Config BB and RF */
 	phy_RF8256_Config_ParaFile(dev);
 }
 /*--------------------------------------------------------------------------
@@ -107,10 +110,11 @@ void PHY_RF8256_Config(struct net_device *dev)
 void phy_RF8256_Config_ParaFile(struct net_device *dev)
 {
 	u32	u4RegValue = 0;
-	//static s1Byte				szRadioAFile[] = RTL819X_PHY_RADIO_A;
-	//static s1Byte				szRadioBFile[] = RTL819X_PHY_RADIO_B;
-	//static s1Byte				szRadioCFile[] = RTL819X_PHY_RADIO_C;
-	//static s1Byte				szRadioDFile[] = RTL819X_PHY_RADIO_D;
+	/* static s1Byte				szRadioAFile[] = RTL819X_PHY_RADIO_A;
+	 * static s1Byte				szRadioBFile[] = RTL819X_PHY_RADIO_B;
+	 * static s1Byte				szRadioCFile[] = RTL819X_PHY_RADIO_C;
+	 * static s1Byte				szRadioDFile[] = RTL819X_PHY_RADIO_D;
+	 */
 	u8	eRFPath;
 	BB_REGISTER_DEFINITION_T	*pPhyReg;
 	struct r8192_priv *priv = ieee80211_priv(dev);
@@ -119,19 +123,17 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 	u32	RF3_Final_Value = 0;
 	u8	ConstRetryTimes = 5, RetryTimes = 5;
 	u8 ret = 0;
-	//3//-----------------------------------------------------------------
-	//3// <2> Initialize RF
-	//3//-----------------------------------------------------------------
+	/* Initialize RF */
 	for (eRFPath = (RF90_RADIO_PATH_E)RF90_PATH_A; eRFPath < priv->NumTotalRFPath; eRFPath++) {
 		if (!rtl8192_phy_CheckIsLegalRFPath(dev, eRFPath))
 			continue;
 
 		pPhyReg = &priv->PHYRegDef[eRFPath];
 
-		// Joseph test for shorten RF config
-	//	pHalData->RfReg0Value[eRFPath] =  rtl8192_phy_QueryRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, rGlobalCtrl, bMaskDWord);
-
-		/*----Store original RFENV control type----*/
+		/* Joseph test for shorten RF config
+		 * pHalData->RfReg0Value[eRFPath] =  rtl8192_phy_QueryRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, rGlobalCtrl, bMaskDWord);
+		 * ----Store original RFENV control type
+		 */
 		switch (eRFPath) {
 		case RF90_PATH_A:
 		case RF90_PATH_C:
@@ -150,13 +152,14 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 		rtl8192_setBBreg(dev, pPhyReg->rfintfo, bRFSI_RFENV, 0x1);
 
 		/* Set bit number of Address and Data for RF register */
-		rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2, b3WireAddressLength, 0x0);	// Set 0 to 4 bits for Z-serial and set 1 to 6 bits for 8258
-		rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2, b3WireDataLength, 0x0);	// Set 0 to 12 bits for Z-serial and 8258, and set 1 to 14 bits for ???
+		rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2, b3WireAddressLength, 0x0);	/* Set 0 to 4 bits for Z-serial and set 1 to 6 bits for 8258 */
+		rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2, b3WireDataLength, 0x0);	/* Set 0 to 12 bits for Z-serial and 8258, and set 1 to 14 bits for ??? */
 
 		rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E) eRFPath, 0x0, bMask12Bits, 0xbf);
 
-		/*----Check RF block (for FPGA platform only)----*/
-		// TODO: this function should be removed on ASIC , Emily 2007.2.2
+		/* Check RF block (for FPGA platform only)----
+		 * TODO: this function should be removed on ASIC , Emily 2007.2.2
+		 */
 		if (rtl8192_phy_checkBBAndRF(dev, HW90_BLOCK_RF, (RF90_RADIO_PATH_E)eRFPath)) {
 			RT_TRACE(COMP_ERR, "PHY_RF8256_Config():Check Radio[%d] Fail!!\n", eRFPath);
 			goto phy_RF8256_Config_ParaFile_Fail;
@@ -231,11 +234,11 @@ void PHY_SetRF8256CCKTxPower(struct net_device *dev, u8 powerlevel)
 {
 	u32	TxAGC = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	//modified by vivi, 20080109
+	/* modified by vivi, 20080109 */
 	TxAGC = powerlevel;
 
 	if (priv->bDynamicTxLowPower == TRUE) {
-		//cosa 05/22/2008 for scan
+		/* cosa 05/22/2008 for scan */
 		if (priv->CustomerID == RT_CID_819x_Netcore)
 			TxAGC = 0x22;
 		else
@@ -251,15 +254,15 @@ void PHY_SetRF8256CCKTxPower(struct net_device *dev, u8 powerlevel)
 void PHY_SetRF8256OFDMTxPower(struct net_device *dev, u8 powerlevel)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	//Joseph TxPower for 8192 testing
+	/* Joseph TxPower for 8192 testing */
 	u32 writeVal, powerBase0, powerBase1, writeVal_tmp;
 	u8 index = 0;
 	u16 RegOffset[6] = {0xe00, 0xe04, 0xe10, 0xe14, 0xe18, 0xe1c};
 	u8 byte0, byte1, byte2, byte3;
 
-	powerBase0 = powerlevel + priv->TxPowerDiff;	//OFDM rates
+	powerBase0 = powerlevel + priv->TxPowerDiff;	/* OFDM rates */
 	powerBase0 = (powerBase0<<24) | (powerBase0<<16) | (powerBase0<<8) | powerBase0;
-	powerBase1 = powerlevel;							//MCS rates
+	powerBase1 = powerlevel;							/* MCS rates */
 	powerBase1 = (powerBase1<<24) | (powerBase1<<16) | (powerBase1<<8) | powerBase1;
 
 	for (index = 0; index < 6; index++) {
@@ -279,7 +282,7 @@ void PHY_SetRF8256OFDMTxPower(struct net_device *dev, u8 powerlevel)
 		if (byte3 > 0x24)
 			byte3 = 0x24;
 
-		//for tx power track
+		/* for tx power track */
 		if (index == 3) {
 			writeVal_tmp = (byte3<<24) | (byte2<<16) | (byte1<<8) | byte0;
 			priv->Pwr_Track = writeVal_tmp;
-- 
1.7.11.7

