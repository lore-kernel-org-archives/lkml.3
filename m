Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaG2K7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:59:43 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38143 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaG2K7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:59:41 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <oort10@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] staging:r8190: coding style: Fixed checkpatch reported Error
Date: Tue, 29 Jul 2014 16:41:53 +0530
Message-ID: <1406632313-2187-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 29 Jul 2014 10:59:40.0819 (UTC) FILETIME=[324A2E30:01CFAB1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8190_rtl8256.c file that fixes
checkpatch reported space & coding style issues.

Signed-off-by: Sanjeev Sharma<Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8192u/r8190_rtl8256.c | 169 +++++++++++++++----------------
 1 file changed, 79 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8190_rtl8256.c b/drivers/staging/rtl8192u/r8190_rtl8256.c
index 08e1bc9..43ed768 100644
--- a/drivers/staging/rtl8192u/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192u/r8190_rtl8256.c
@@ -23,62 +23,64 @@
  * Return:      NONE
  * Note:	8226 support both 20M  and 40 MHz
  *---------------------------------------------------------------------------*/
-void PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH Bandwidth)	//20M or 40M
+void PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH Bandwidth)
 {
 	u8	eRFPath;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	//for(eRFPath = RF90_PATH_A; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
-	for(eRFPath = 0; eRFPath <RF90_PATH_MAX; eRFPath++)
-	{
+	/* for(eRFPath = RF90_PATH_A; eRFPath <pHalData->NumTotalRFPath;
+	 *  eRFPath++)
+	 */
+	for (eRFPath = 0; eRFPath < RF90_PATH_MAX; eRFPath++) {
 		if (!rtl8192_phy_CheckIsLegalRFPath(dev, eRFPath))
 			continue;
 
-		switch (Bandwidth)
-		{
-			case HT_CHANNEL_WIDTH_20:
-				if(priv->card_8192_version == VERSION_819xU_A || priv->card_8192_version == VERSION_819xU_B)// 8256 D-cut, E-cut, xiong: consider it later!
-				{
-					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0b, bMask12Bits, 0x100); //phy para:1ba
-					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x2c, bMask12Bits, 0x3d7);
-					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0e, bMask12Bits, 0x021);
-
-					//cosa add for sd3's request 01/23/2008
-					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x14, bMask12Bits, 0x5ab);
-				}
-				else
-				{
+		switch (Bandwidth) {
+		case HT_CHANNEL_WIDTH_20:
+				if (priv->card_8192_version == VERSION_819xU_A
+					|| priv->card_8192_version
+					== VERSION_819xU_B) { /* 8256 D-cut, E-cut, xiong: consider it later! */
+					rtl8192_phy_SetRFReg(dev,
+						(RF90_RADIO_PATH_E)eRFPath,
+						0x0b, bMask12Bits, 0x100); /* phy para:1ba */
+					rtl8192_phy_SetRFReg(dev,
+						(RF90_RADIO_PATH_E)eRFPath,
+						0x2c, bMask12Bits, 0x3d7);
+					rtl8192_phy_SetRFReg(dev,
+						(RF90_RADIO_PATH_E)eRFPath,
+						0x0e, bMask12Bits, 0x021);
+
+					/* cosa add for sd3's request 01/23/2008
+					 */
+					rtl8192_phy_SetRFReg(dev,
+						(RF90_RADIO_PATH_E)eRFPath,
+						0x14, bMask12Bits, 0x5ab);
+				} else {
 					RT_TRACE(COMP_ERR, "PHY_SetRF8256Bandwidth(): unknown hardware version\n");
-				}
-
+					}
 				break;
-			case HT_CHANNEL_WIDTH_20_40:
-				if(priv->card_8192_version == VERSION_819xU_A ||priv->card_8192_version == VERSION_819xU_B)// 8256 D-cut, E-cut, xiong: consider it later!
-				{
+		case HT_CHANNEL_WIDTH_20_40:
+				if (priv->card_8192_version == VERSION_819xU_A || priv->card_8192_version == VERSION_819xU_B) { /* 8256 D-cut, E-cut, xiong: consider it later! */
 					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0b, bMask12Bits, 0x300); //phy para:3ba
 					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x2c, bMask12Bits, 0x3df);
 					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0e, bMask12Bits, 0x0a1);
 
 					//cosa add for sd3's request 01/23/2008
-					if(priv->chan == 3 || priv->chan == 9) //I need to set priv->chan whenever current channel changes
+					if (priv->chan == 3 || priv->chan == 9)
+						//I need to set priv->chan whenever current channel changes
 						rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x14, bMask12Bits, 0x59b);
 					else
 						rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x14, bMask12Bits, 0x5ab);
-				}
-				else
-				{
+				} else {
 					RT_TRACE(COMP_ERR, "PHY_SetRF8256Bandwidth(): unknown hardware version\n");
-				}
-
-
+					}
 				break;
-			default:
-				RT_TRACE(COMP_ERR, "PHY_SetRF8256Bandwidth(): unknown Bandwidth: %#X\n",Bandwidth);
+		default:
+				RT_TRACE(COMP_ERR, "PHY_SetRF8256Bandwidth(): unknown Bandwidth: %#X\n", Bandwidth);
 				break;
 
 		}
 	}
-	return;
 }
 /*--------------------------------------------------------------------------
  * Overview:    Interface to config 8256
@@ -95,8 +97,6 @@ void PHY_RF8256_Config(struct net_device *dev)
 	priv->NumTotalRFPath = RTL819X_TOTAL_RF_PATH;
 	// Config BB and RF
 	phy_RF8256_Config_ParaFile(dev);
-
-	return;
 }
 /*--------------------------------------------------------------------------
  * Overview:    Interface to config 8256
@@ -122,8 +122,7 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 	//3//-----------------------------------------------------------------
 	//3// <2> Initialize RF
 	//3//-----------------------------------------------------------------
-	for(eRFPath = (RF90_RADIO_PATH_E)RF90_PATH_A; eRFPath <priv->NumTotalRFPath; eRFPath++)
-	{
+	for (eRFPath = (RF90_RADIO_PATH_E)RF90_PATH_A; eRFPath < priv->NumTotalRFPath; eRFPath++) {
 		if (!rtl8192_phy_CheckIsLegalRFPath(dev, eRFPath))
 			continue;
 
@@ -133,13 +132,12 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 	//	pHalData->RfReg0Value[eRFPath] =  rtl8192_phy_QueryRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, rGlobalCtrl, bMaskDWord);
 
 		/*----Store original RFENV control type----*/
-		switch (eRFPath)
-		{
+		switch (eRFPath) {
 		case RF90_PATH_A:
 		case RF90_PATH_C:
 			u4RegValue = rtl8192_QueryBBReg(dev, pPhyReg->rfintfs, bRFSI_RFENV);
 			break;
-		case RF90_PATH_B :
+		case RF90_PATH_B:
 		case RF90_PATH_D:
 			u4RegValue = rtl8192_QueryBBReg(dev, pPhyReg->rfintfs, bRFSI_RFENV<<16);
 			break;
@@ -159,8 +157,7 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 
 		/*----Check RF block (for FPGA platform only)----*/
 		// TODO: this function should be removed on ASIC , Emily 2007.2.2
-		if (rtl8192_phy_checkBBAndRF(dev, HW90_BLOCK_RF, (RF90_RADIO_PATH_E)eRFPath))
-		{
+		if (rtl8192_phy_checkBBAndRF(dev, HW90_BLOCK_RF, (RF90_RADIO_PATH_E)eRFPath)) {
 			RT_TRACE(COMP_ERR, "PHY_RF8256_Config():Check Radio[%d] Fail!!\n", eRFPath);
 			goto phy_RF8256_Config_ParaFile_Fail;
 		}
@@ -168,39 +165,34 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 		RetryTimes = ConstRetryTimes;
 		RF3_Final_Value = 0;
 		/*----Initialize RF fom connfiguration file----*/
-		switch (eRFPath)
-		{
+		switch (eRFPath) {
 		case RF90_PATH_A:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
-			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev,(RF90_RADIO_PATH_E)eRFPath);
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0) {
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
 			}
 			break;
 		case RF90_PATH_B:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
-			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev,(RF90_RADIO_PATH_E)eRFPath);
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0) {
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
 			}
 			break;
 		case RF90_PATH_C:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
-			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev,(RF90_RADIO_PATH_E)eRFPath);
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0) {
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
 			}
 			break;
 		case RF90_PATH_D:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
-			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev,(RF90_RADIO_PATH_E)eRFPath);
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0) {
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(dev, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
@@ -209,50 +201,48 @@ void phy_RF8256_Config_ParaFile(struct net_device *dev)
 		}
 
 		/*----Restore RFENV control type----*/;
-		switch (eRFPath)
-		{
+		switch (eRFPath) {
 		case RF90_PATH_A:
 		case RF90_PATH_C:
 			rtl8192_setBBreg(dev, pPhyReg->rfintfs, bRFSI_RFENV, u4RegValue);
 			break;
-		case RF90_PATH_B :
+		case RF90_PATH_B:
 		case RF90_PATH_D:
 			rtl8192_setBBreg(dev, pPhyReg->rfintfs, bRFSI_RFENV<<16, u4RegValue);
 			break;
 		}
 
-		if(ret){
+		if (ret) {
 			RT_TRACE(COMP_ERR, "phy_RF8256_Config_ParaFile():Radio[%d] Fail!!", eRFPath);
 			goto phy_RF8256_Config_ParaFile_Fail;
 		}
 
 	}
 
-	RT_TRACE(COMP_PHY, "PHY Initialization Success\n") ;
-	return ;
+	RT_TRACE(COMP_PHY, "PHY Initialization Success\n");
+	return;
 
 phy_RF8256_Config_ParaFile_Fail:
-	RT_TRACE(COMP_ERR, "PHY Initialization failed\n") ;
-	return ;
+	RT_TRACE(COMP_ERR, "PHY Initialization failed\n");
 }
 
 
 void PHY_SetRF8256CCKTxPower(struct net_device *dev, u8 powerlevel)
 {
-	u32	TxAGC=0;
+	u32	TxAGC = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	//modified by vivi, 20080109
 	TxAGC = powerlevel;
 
-	if(priv->bDynamicTxLowPower == TRUE) //cosa 05/22/2008 for scan
-	{
-		if(priv->CustomerID == RT_CID_819x_Netcore)
+	if (priv->bDynamicTxLowPower == TRUE) {
+		//cosa 05/22/2008 for scan
+		if (priv->CustomerID == RT_CID_819x_Netcore)
 			TxAGC = 0x22;
 		else
 			TxAGC += priv->CckPwEnl;
 	}
 
-	if(TxAGC > 0x24)
+	if (TxAGC > 0x24)
 		TxAGC = 0x24;
 	rtl8192_setBBreg(dev, rTxAGC_CCK_Mcs32, bTxAGCRateCCK, TxAGC);
 }
@@ -268,43 +258,42 @@ void PHY_SetRF8256OFDMTxPower(struct net_device *dev, u8 powerlevel)
 	u8 byte0, byte1, byte2, byte3;
 
 	powerBase0 = powerlevel + priv->TxPowerDiff;	//OFDM rates
-	powerBase0 = (powerBase0<<24) | (powerBase0<<16) |(powerBase0<<8) |powerBase0;
+	powerBase0 = (powerBase0<<24) | (powerBase0<<16) | (powerBase0<<8) | powerBase0;
 	powerBase1 = powerlevel;							//MCS rates
-	powerBase1 = (powerBase1<<24) | (powerBase1<<16) |(powerBase1<<8) |powerBase1;
+	powerBase1 = (powerBase1<<24) | (powerBase1<<16) | (powerBase1<<8) | powerBase1;
 
-	for(index=0; index<6; index++)
-	{
-		writeVal = priv->MCSTxPowerLevelOriginalOffset[index] + ((index<2)?powerBase0:powerBase1);
+	for (index = 0; index < 6; index++) {
+		writeVal = priv->MCSTxPowerLevelOriginalOffset[index] + ((index < 2)?powerBase0:powerBase1);
 		byte0 = (u8)(writeVal & 0x7f);
 		byte1 = (u8)((writeVal & 0x7f00)>>8);
 		byte2 = (u8)((writeVal & 0x7f0000)>>16);
 		byte3 = (u8)((writeVal & 0x7f000000)>>24);
-		if(byte0 > 0x24)	// Max power index = 0x24
+
+		if (byte0 > 0x24)
+			/* Max power index = 0x24 */
 			byte0 = 0x24;
-		if(byte1 > 0x24)
+		if (byte1 > 0x24)
 			byte1 = 0x24;
-		if(byte2 > 0x24)
+		if (byte2 > 0x24)
 			byte2 = 0x24;
-		if(byte3 > 0x24)
+		if (byte3 > 0x24)
 			byte3 = 0x24;
 
 		//for tx power track
-		if(index == 3)
-		{
-			writeVal_tmp = (byte3<<24) | (byte2<<16) |(byte1<<8) |byte0;
+		if (index == 3) {
+			writeVal_tmp = (byte3<<24) | (byte2<<16) | (byte1<<8) | byte0;
 			priv->Pwr_Track = writeVal_tmp;
 		}
 
-		if(priv->bDynamicTxHighPower == TRUE)     //Add by Jacken 2008/03/06
-		{
-			// Emily, 20080613. Set low tx power for both MCS and legacy OFDM
+		if (priv->bDynamicTxHighPower == TRUE) {
+			/*Add by Jacken 2008/03/06
+			 *Emily, 20080613. Set low tx power for both MCS and legacy OFDM
+			 */
 			writeVal = 0x03030303;
-		}
-		else
-		{
-			writeVal = (byte3<<24) | (byte2<<16) |(byte1<<8) |byte0;
-		}
-		rtl8192_setBBreg(dev, RegOffset[index], 0x7f7f7f7f, writeVal);
+		} else {
+			writeVal = (byte3<<24) | (byte2<<16) | (byte1<<8) | byte0;
+			}
+			rtl8192_setBBreg(dev, RegOffset[index], 0x7f7f7f7f, writeVal);
 	}
 	return;
 
-- 
1.7.11.7

