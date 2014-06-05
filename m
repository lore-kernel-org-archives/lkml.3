Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaFEU0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:26:18 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38996 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFEU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:26:04 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        peter.p.waskiewicz.jr@intel.com, anarey@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 3/3] Staging: rtl8192u: r8192U_core.c Converted some C99 comments to fix code-style errors
Date: Thu,  5 Jun 2014 13:25:58 -0700
Message-Id: <1401999958-17235-3-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401999958-17235-1-git-send-email-c@24.io>
References: <1401999958-17235-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted some C99 warnings to fix the following error:

ERROR: trailing statements should be on next line

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_core.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index a9922dd..9dba99d 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1433,7 +1433,7 @@ static void rtl8192_update_cap(struct net_device *dev, u16 cap)
 
 	if (net->mode & (IEEE_G|IEEE_N_24G)) {
 		u8 slot_time = 0;
-		if ((cap & WLAN_CAPABILITY_SHORT_SLOT) && (!priv->ieee80211->pHTInfo->bCurrentRT2RTLongSlotTime)) //short slot time
+		if ((cap & WLAN_CAPABILITY_SHORT_SLOT) && (!priv->ieee80211->pHTInfo->bCurrentRT2RTLongSlotTime)) /* short slot time */
 			slot_time = SHORT_SLOT_TIME;
 		else //long slot time
 			slot_time = NON_SHORT_SLOT_TIME;
@@ -1500,11 +1500,11 @@ u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
 
 	if (rtl8192_IsWirelessBMode(DataRate))
 	{
-		if (bManagementFrame || !bShortPreamble || DataRate == 10) // long preamble
+		if (bManagementFrame || !bShortPreamble || DataRate == 10) /* long preamble */
 			FrameTime = (u16)(144+48+(FrameLength*8/(DataRate/10)));
 		else // Short preamble
 			FrameTime = (u16)(72+24+(FrameLength*8/(DataRate/10)));
-		if ((FrameLength*8 % (DataRate/10)) != 0) //Get the Ceilling
+		if ((FrameLength*8 % (DataRate/10)) != 0) /* Get the Ceilling */
 			FrameTime++;
 	} else {	//802.11g DSSS-OFDM PLCP length field calculation.
 		N_DBPS = N_DBPSOfRate(DataRate);
@@ -1827,7 +1827,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 	tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 	tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-	if (tcb_desc->bAMPDUEnable) //AMPDU enabled
+	if (tcb_desc->bAMPDUEnable) /* AMPDU enabled */
 	{
 		tx_fwinfo->AllowAggregation = 1;
 		/* DWORD 1 */
@@ -2314,7 +2314,7 @@ void rtl8192_update_ratr_table(struct net_device *dev)
 		break;
 	case IEEE_N_24G:
 	case IEEE_N_5G:
-		if (ieee->pHTInfo->PeerMimoPs == 0) //MIMO_PS_STATIC
+		if (ieee->pHTInfo->PeerMimoPs == 0) /* MIMO_PS_STATIC */
 		{
 			ratr_value &= 0x0007F007;
 		} else {
@@ -2699,7 +2699,7 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 		else
 			priv->EEPROM_Def_Ver = 1;
 		RT_TRACE(COMP_EPROM, "EEPROM_DEF_VER:%d\n", priv->EEPROM_Def_Ver);
-		if (priv->EEPROM_Def_Ver == 0) //old eeprom definition
+		if (priv->EEPROM_Def_Ver == 0) /* old eeprom definition */
 		{
 			int i;
 			if (bLoad_From_EEPOM)
@@ -3111,14 +3111,14 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	//
 #ifdef TO_DO_LIST
 	if (Adapter->ResetProgress == RESET_TYPE_NORESET) {
-		if (pMgntInfo->RegRfOff == TRUE) // User disable RF via registry.
+		if (pMgntInfo->RegRfOff == TRUE) /* User disable RF via registry. */
 		{
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
 			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
 			// Those actions will be discard in MgntActSet_RF_State because of the same state
 			for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
-		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) // H/W or S/W RF OFF before sleep.
+		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) /* H/W or S/W RF OFF before sleep. */
 		{
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RfOffReason(%d) ----------\n", pMgntInfo->RfOffReason));
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
@@ -3647,7 +3647,7 @@ void rtl819x_watchdog_wqcallback(struct work_struct *work)
 	}
 	if ((priv->force_reset) || (priv->ResetProgress == RESET_TYPE_NORESET &&
 	    (priv->bForcedSilentReset ||
-	    (!priv->bDisableNormalResetCheck && ResetType == RESET_TYPE_SILENT)))) // This is control by OID set in Pomelo
+	    (!priv->bDisableNormalResetCheck && ResetType == RESET_TYPE_SILENT)))) /* This is control by OID set in Pomelo */
 	{
 		RT_TRACE(COMP_RESET, "%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n", __func__, priv->force_reset, priv->ResetProgress, priv->bForcedSilentReset, priv->bDisableNormalResetCheck, ResetType);
 		rtl819x_ifsilentreset(dev);
@@ -4209,7 +4209,7 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 
 
 	if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA) {
-		if (priv->undecorated_smoothed_pwdb < 0)	// initialize
+		if (priv->undecorated_smoothed_pwdb < 0)	/* initialize */
 			priv->undecorated_smoothed_pwdb = pprevious_stats->RxPWDBAll;
 		if (pprevious_stats->RxPWDBAll > (u32)priv->undecorated_smoothed_pwdb) {
 			priv->undecorated_smoothed_pwdb =
@@ -4252,10 +4252,10 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 		// <2> Showed on UI for engineering
 		if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA)
 		{
-			for (nspatial_stream = 0; nspatial_stream < 2; nspatial_stream++) // 2 spatial stream
+			for (nspatial_stream = 0; nspatial_stream < 2; nspatial_stream++) /* 2 spatial stream */
 			{
 				if (pprevious_stats->RxMIMOSignalQuality[nspatial_stream] != -1) {
-					if (priv->stats.rx_evm_percentage[nspatial_stream] == 0) // initialize
+					if (priv->stats.rx_evm_percentage[nspatial_stream] == 0) /* initialize */
 						priv->stats.rx_evm_percentage[nspatial_stream] = pprevious_stats->RxMIMOSignalQuality[nspatial_stream];
 					priv->stats.rx_evm_percentage[nspatial_stream] =
 						((priv->stats.rx_evm_percentage[nspatial_stream]* (Rx_Smooth_Factor-1)) +
@@ -4550,7 +4550,7 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 			rx_evmX /= 2;	//dbm
 
 			evm = rtl819x_evm_dbtopercentage(rx_evmX);
-			if (i == 0) // Fill value in RFD, Get the first spatial stream only
+			if (i == 0) /* Fill value in RFD, Get the first spatial stream only */
 				pstats->SignalQuality = precord_stats->SignalQuality = (u8)(evm & 0xff);
 			pstats->RxMIMOSignalQuality[i] = precord_stats->RxMIMOSignalQuality[i] = (u8)(evm & 0xff);
 		}
@@ -4559,7 +4559,7 @@ static void rtl8192_query_rxphystatus(struct r8192_priv *priv,
 		/* record rx statistics for debug */
 		rxsc_sgien_exflg = pofdm_buf->rxsc_sgien_exflg;
 		prxsc =	(phy_ofdm_rx_status_rxsc_sgien_exintfflag *)&rxsc_sgien_exflg;
-		if (pdrvinfo->BW)	//40M channel
+		if (pdrvinfo->BW)	/* 40M channel */
 			priv->stats.received_bwtype[1+prxsc->rxsc]++;
 		else				//20M channel
 			priv->stats.received_bwtype[0]++;
@@ -5394,7 +5394,7 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 
 	ieee->hwsec_active = 1;
 
-	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep) //add hwsec_support flag to totol control hw_sec on/off
+	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep) /* add hwsec_support flag to totol control hw_sec on/off */
 	{
 		ieee->hwsec_active = 0;
 		SECR_value &= ~SCR_RxDecEnable;
@@ -5427,7 +5427,7 @@ void setKey(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 		TargetCommand  = i+CAM_CONTENT_COUNT*EntryNo;
 		TargetCommand |= BIT31|BIT16;
 
-		if (i == 0) //MAC|Config
+		if (i == 0) /* MAC|Config */
 		{
 			TargetContent = (u32)(*(MacAddr+0)) << 16|
 					(u32)(*(MacAddr+1)) << 24|
@@ -5435,7 +5435,7 @@ void setKey(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 
 			write_nic_dword(dev, WCAMI, TargetContent);
 			write_nic_dword(dev, RWCAM, TargetCommand);
-		} else if (i == 1) //MAC
+		} else if (i == 1) /* MAC */
 		{
 			TargetContent = (u32)(*(MacAddr+2))	 |
 					(u32)(*(MacAddr+3)) <<  8|
-- 
1.9.1

