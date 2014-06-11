Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbaFKR0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:26:54 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40045 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaFKR0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:26:52 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com, anarey@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 1/2] Staging: rtl8192u: r8192U_core.c Fixed open brace { placement
Date: Wed, 11 Jun 2014 10:26:43 -0700
Message-Id: <1402507604-15710-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed open brace placement to address the following code-style errors:

ERROR: that open brace { should be on the previous line

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_core.c | 69 ++++++++++++----------------------
 1 file changed, 23 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 9dba99d..512bf5c 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1115,8 +1115,7 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 		tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 		tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-		if (tcb_desc->bAMPDUEnable)
-		{//AMPDU enabled
+		if (tcb_desc->bAMPDUEnable) {//AMPDU enabled
 			tx_fwinfo->AllowAggregation = 1;
 			/* DWORD 1 */
 			tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
@@ -1331,8 +1330,7 @@ static void rtl8192_config_rate(struct net_device *dev, u16 *rate_config)
 
 	for (i = 0; i < net->rates_len; i++) {
 		basic_rate = net->rates[i]&0x7f;
-		switch (basic_rate)
-		{
+		switch (basic_rate) {
 			case MGN_1M:
 				*rate_config |= RRSR_1M;
 				break;
@@ -1371,11 +1369,9 @@ static void rtl8192_config_rate(struct net_device *dev, u16 *rate_config)
 				break;
 		}
 	}
-	for (i = 0; i < net->rates_ex_len; i++)
-	{
+	for (i = 0; i < net->rates_ex_len; i++) {
 		basic_rate = net->rates_ex[i]&0x7f;
-		switch (basic_rate)
-		{
+		switch (basic_rate) {
 			case MGN_1M:
 				*rate_config |= RRSR_1M;
 				break;
@@ -1498,8 +1494,7 @@ u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
 	u16	N_DBPS;
 	u16	Ceiling;
 
-	if (rtl8192_IsWirelessBMode(DataRate))
-	{
+	if (rtl8192_IsWirelessBMode(DataRate)) {
 		if (bManagementFrame || !bShortPreamble || DataRate == 10) /* long preamble */
 			FrameTime = (u16)(144+48+(FrameLength*8/(DataRate/10)));
 		else // Short preamble
@@ -1671,8 +1666,7 @@ static u8 MRateToHwRate8190Pci(u8 rate)
 {
 	u8  ret = DESC90_RATE1M;
 
-	switch (rate)
-	{
+	switch (rate) {
 		case MGN_1M:
 			ret = DESC90_RATE1M;
 			break;
@@ -1827,8 +1821,7 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 	tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 	tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-	if (tcb_desc->bAMPDUEnable) /* AMPDU enabled */
-	{
+	if (tcb_desc->bAMPDUEnable) { /* AMPDU enabled */
 		tx_fwinfo->AllowAggregation = 1;
 		/* DWORD 1 */
 		tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
@@ -2314,8 +2307,7 @@ void rtl8192_update_ratr_table(struct net_device *dev)
 		break;
 	case IEEE_N_24G:
 	case IEEE_N_5G:
-		if (ieee->pHTInfo->PeerMimoPs == 0) /* MIMO_PS_STATIC */
-		{
+		if (ieee->pHTInfo->PeerMimoPs == 0) { /* MIMO_PS_STATIC */
 			ratr_value &= 0x0007F007;
 		} else {
 			if (priv->rf_type == RF_1T2R)
@@ -2699,8 +2691,7 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 		else
 			priv->EEPROM_Def_Ver = 1;
 		RT_TRACE(COMP_EPROM, "EEPROM_DEF_VER:%d\n", priv->EEPROM_Def_Ver);
-		if (priv->EEPROM_Def_Ver == 0) /* old eeprom definition */
-		{
+		if (priv->EEPROM_Def_Ver == 0) { /* old eeprom definition */
 			int i;
 			if (bLoad_From_EEPOM)
 				priv->EEPROMTxPowerLevelCCK = (eprom_read(dev, (EEPROM_TxPwIndex_CCK>>1))&0xff) >> 8;
@@ -3111,15 +3102,13 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	//
 #ifdef TO_DO_LIST
 	if (Adapter->ResetProgress == RESET_TYPE_NORESET) {
-		if (pMgntInfo->RegRfOff == TRUE) /* User disable RF via registry. */
-		{
+		if (pMgntInfo->RegRfOff == TRUE) { /* User disable RF via registry. */
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
 			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
 			// Those actions will be discard in MgntActSet_RF_State because of the same state
 			for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
-		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) /* H/W or S/W RF OFF before sleep. */
-		{
+		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) { /* H/W or S/W RF OFF before sleep. */
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RfOffReason(%d) ----------\n", pMgntInfo->RfOffReason));
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
 		} else {
@@ -3128,8 +3117,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): RF is on ----------\n"));
 		}
 	} else {
-		if (pHalData->eRFPowerState == eRfOff)
-		{
+		if (pHalData->eRFPowerState == eRfOff) {
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
 			// Those actions will be discard in MgntActSet_RF_State because of the same state
 			for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++)
@@ -3138,8 +3126,7 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	}
 #endif
 	//config RF.
-	if (priv->ResetProgress == RESET_TYPE_NORESET)
-	{
+	if (priv->ResetProgress == RESET_TYPE_NORESET) {
 		rtl8192_phy_RFConfig(dev);
 		RT_TRACE(COMP_INIT, "%s():after phy RF config\n", __func__);
 	}
@@ -3647,8 +3634,7 @@ void rtl819x_watchdog_wqcallback(struct work_struct *work)
 	}
 	if ((priv->force_reset) || (priv->ResetProgress == RESET_TYPE_NORESET &&
 	    (priv->bForcedSilentReset ||
-	    (!priv->bDisableNormalResetCheck && ResetType == RESET_TYPE_SILENT)))) /* This is control by OID set in Pomelo */
-	{
+	    (!priv->bDisableNormalResetCheck && ResetType == RESET_TYPE_SILENT)))) { /* This is control by OID set in Pomelo */
 		RT_TRACE(COMP_RESET, "%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n", __func__, priv->force_reset, priv->ResetProgress, priv->bForcedSilentReset, priv->bDisableNormalResetCheck, ResetType);
 		rtl819x_ifsilentreset(dev);
 	}
@@ -3928,8 +3914,7 @@ static u8 HwRateToMRate90(bool bIsHT, u8 rate)
 	u8  ret_rate = 0xff;
 
 	if (!bIsHT) {
-		switch (rate)
-		{
+		switch (rate) {
 			case DESC90_RATE1M:
 				ret_rate = MGN_1M;
 				break;
@@ -3974,8 +3959,7 @@ static u8 HwRateToMRate90(bool bIsHT, u8 rate)
 		}
 
 	} else {
-		switch (rate)
-		{
+		switch (rate) {
 			case DESC90_RATEMCS0:
 				ret_rate = MGN_MCS0;
 				break;
@@ -4058,8 +4042,7 @@ static void UpdateRxPktTimeStamp8190(struct net_device *dev,
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 
-	if (stats->bIsAMPDU && !stats->bFirstMPDU)
-	{
+	if (stats->bIsAMPDU && !stats->bFirstMPDU) {
 		stats->mac_time[0] = priv->LastRxDescTSFLow;
 		stats->mac_time[1] = priv->LastRxDescTSFHigh;
 	} else {
@@ -4250,10 +4233,8 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 		}
 
 		// <2> Showed on UI for engineering
-		if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA)
-		{
-			for (nspatial_stream = 0; nspatial_stream < 2; nspatial_stream++) /* 2 spatial stream */
-			{
+		if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA) {
+			for (nspatial_stream = 0; nspatial_stream < 2; nspatial_stream++) { /* 2 spatial stream */
 				if (pprevious_stats->RxMIMOSignalQuality[nspatial_stream] != -1) {
 					if (priv->stats.rx_evm_percentage[nspatial_stream] == 0) /* initialize */
 						priv->stats.rx_evm_percentage[nspatial_stream] = pprevious_stats->RxMIMOSignalQuality[nspatial_stream];
@@ -4676,8 +4657,7 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 	else
 		preamble_guardinterval = 0;// long
 
-	switch (stats->rate)
-	{
+	switch (stats->rate) {
 		//
 		// CCK rate
 		//
@@ -5394,8 +5374,7 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 
 	ieee->hwsec_active = 1;
 
-	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep) /* add hwsec_support flag to totol control hw_sec on/off */
-	{
+	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep) { /* add hwsec_support flag to totol control hw_sec on/off */
 		ieee->hwsec_active = 0;
 		SECR_value &= ~SCR_RxDecEnable;
 	}
@@ -5427,16 +5406,14 @@ void setKey(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 		TargetCommand  = i+CAM_CONTENT_COUNT*EntryNo;
 		TargetCommand |= BIT31|BIT16;
 
-		if (i == 0) /* MAC|Config */
-		{
+		if (i == 0) { /* MAC|Config */
 			TargetContent = (u32)(*(MacAddr+0)) << 16|
 					(u32)(*(MacAddr+1)) << 24|
 					(u32)usConfig;
 
 			write_nic_dword(dev, WCAMI, TargetContent);
 			write_nic_dword(dev, RWCAM, TargetCommand);
-		} else if (i == 1) /* MAC */
-		{
+		} else if (i == 1) { /* MAC */
 			TargetContent = (u32)(*(MacAddr+2))	 |
 					(u32)(*(MacAddr+3)) <<  8|
 					(u32)(*(MacAddr+4)) << 16|
-- 
1.9.1

