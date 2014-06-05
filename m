Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaFEU0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:26:36 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62416 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFEU0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:26:03 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        peter.p.waskiewicz.jr@intel.com, anarey@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 2/3] Staging: rtl8192u: r8192U_core.c Rearranged statements to fix code-style errors
Date: Thu,  5 Jun 2014 13:25:57 -0700
Message-Id: <1401999958-17235-2-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401999958-17235-1-git-send-email-c@24.io>
References: <1401999958-17235-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearranged statements around if and switch statements to address the following error:

ERROR: trailing statements should be on next line

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_core.c | 553 ++++++++++++++++++++++++---------
 1 file changed, 402 insertions(+), 151 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 2a9150d..a9922dd 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -905,7 +905,8 @@ inline u16 ieeerate2rtlrate(int rate)
 static u16 rtl_rate[] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540};
 inline u16 rtl8192_rate2rate(short rate)
 {
-	if (rate > 11) return 0;
+	if (rate > 11)
+		return 0;
 	return rtl_rate[rate];
 }
 
@@ -1114,7 +1115,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 		tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 		tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 		tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-		if (tcb_desc->bAMPDUEnable) {//AMPDU enabled
+		if (tcb_desc->bAMPDUEnable)
+		{//AMPDU enabled
 			tx_fwinfo->AllowAggregation = 1;
 			/* DWORD 1 */
 			tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
@@ -1329,36 +1331,87 @@ static void rtl8192_config_rate(struct net_device *dev, u16 *rate_config)
 
 	for (i = 0; i < net->rates_len; i++) {
 		basic_rate = net->rates[i]&0x7f;
-		switch (basic_rate) {
-		case MGN_1M:	*rate_config |= RRSR_1M;	break;
-		case MGN_2M:	*rate_config |= RRSR_2M;	break;
-		case MGN_5_5M:	*rate_config |= RRSR_5_5M;	break;
-		case MGN_11M:	*rate_config |= RRSR_11M;	break;
-		case MGN_6M:	*rate_config |= RRSR_6M;	break;
-		case MGN_9M:	*rate_config |= RRSR_9M;	break;
-		case MGN_12M:	*rate_config |= RRSR_12M;	break;
-		case MGN_18M:	*rate_config |= RRSR_18M;	break;
-		case MGN_24M:	*rate_config |= RRSR_24M;	break;
-		case MGN_36M:	*rate_config |= RRSR_36M;	break;
-		case MGN_48M:	*rate_config |= RRSR_48M;	break;
-		case MGN_54M:	*rate_config |= RRSR_54M;	break;
+		switch (basic_rate)
+		{
+			case MGN_1M:
+				*rate_config |= RRSR_1M;
+				break;
+			case MGN_2M:
+				*rate_config |= RRSR_2M;
+				break;
+			case MGN_5_5M:
+				*rate_config |= RRSR_5_5M;
+				break;
+			case MGN_11M:
+				*rate_config |= RRSR_11M;
+				break;
+			case MGN_6M:
+				*rate_config |= RRSR_6M;
+				break;
+			case MGN_9M:
+				*rate_config |= RRSR_9M;
+				break;
+			case MGN_12M:
+				*rate_config |= RRSR_12M;
+				break;
+			case MGN_18M:
+				*rate_config |= RRSR_18M;
+				break;
+			case MGN_24M:
+				*rate_config |= RRSR_24M;
+				break;
+			case MGN_36M:
+				*rate_config |= RRSR_36M;
+				break;
+			case MGN_48M:
+				*rate_config |= RRSR_48M;
+				break;
+			case MGN_54M:
+				*rate_config |= RRSR_54M;
+				break;
 		}
 	}
-	for (i = 0; i < net->rates_ex_len; i++) {
+	for (i = 0; i < net->rates_ex_len; i++)
+	{
 		basic_rate = net->rates_ex[i]&0x7f;
-		switch (basic_rate) {
-		case MGN_1M:	*rate_config |= RRSR_1M;	break;
-		case MGN_2M:	*rate_config |= RRSR_2M;	break;
-		case MGN_5_5M:	*rate_config |= RRSR_5_5M;	break;
-		case MGN_11M:	*rate_config |= RRSR_11M;	break;
-		case MGN_6M:	*rate_config |= RRSR_6M;	break;
-		case MGN_9M:	*rate_config |= RRSR_9M;	break;
-		case MGN_12M:	*rate_config |= RRSR_12M;	break;
-		case MGN_18M:	*rate_config |= RRSR_18M;	break;
-		case MGN_24M:	*rate_config |= RRSR_24M;	break;
-		case MGN_36M:	*rate_config |= RRSR_36M;	break;
-		case MGN_48M:	*rate_config |= RRSR_48M;	break;
-		case MGN_54M:	*rate_config |= RRSR_54M;	break;
+		switch (basic_rate)
+		{
+			case MGN_1M:
+				*rate_config |= RRSR_1M;
+				break;
+			case MGN_2M:
+				*rate_config |= RRSR_2M;
+				break;
+			case MGN_5_5M:
+				*rate_config |= RRSR_5_5M;
+				break;
+			case MGN_11M:
+				*rate_config |= RRSR_11M;
+				break;
+			case MGN_6M:
+				*rate_config |= RRSR_6M;
+				break;
+			case MGN_9M:
+				*rate_config |= RRSR_9M;
+				break;
+			case MGN_12M:
+				*rate_config |= RRSR_12M;
+				break;
+			case MGN_18M:
+				*rate_config |= RRSR_18M;
+				break;
+			case MGN_24M:
+				*rate_config |= RRSR_24M;
+				break;
+			case MGN_36M:
+				*rate_config |= RRSR_36M;
+				break;
+			case MGN_48M:
+				*rate_config |= RRSR_48M;
+				break;
+			case MGN_54M:
+				*rate_config |= RRSR_54M;
+				break;
 		}
 	}
 }
@@ -1432,7 +1485,8 @@ inline u8 rtl8192_IsWirelessBMode(u16 rate)
 {
 	if (((rate <= 110) && (rate != 60) && (rate != 90)) || (rate == 220))
 		return 1;
-	else return 0;
+	else
+		return 0;
 }
 
 u16 N_DBPSOfRate(u16 DataRate);
@@ -1444,7 +1498,8 @@ u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
 	u16	N_DBPS;
 	u16	Ceiling;
 
-	if (rtl8192_IsWirelessBMode(DataRate)) {
+	if (rtl8192_IsWirelessBMode(DataRate))
+	{
 		if (bManagementFrame || !bShortPreamble || DataRate == 10) // long preamble
 			FrameTime = (u16)(144+48+(FrameLength*8/(DataRate/10)));
 		else // Short preamble
@@ -1616,40 +1671,100 @@ static u8 MRateToHwRate8190Pci(u8 rate)
 {
 	u8  ret = DESC90_RATE1M;
 
-	switch (rate) {
-	case MGN_1M:    ret = DESC90_RATE1M;    break;
-	case MGN_2M:    ret = DESC90_RATE2M;    break;
-	case MGN_5_5M:  ret = DESC90_RATE5_5M;  break;
-	case MGN_11M:   ret = DESC90_RATE11M;   break;
-	case MGN_6M:    ret = DESC90_RATE6M;    break;
-	case MGN_9M:    ret = DESC90_RATE9M;    break;
-	case MGN_12M:   ret = DESC90_RATE12M;   break;
-	case MGN_18M:   ret = DESC90_RATE18M;   break;
-	case MGN_24M:   ret = DESC90_RATE24M;   break;
-	case MGN_36M:   ret = DESC90_RATE36M;   break;
-	case MGN_48M:   ret = DESC90_RATE48M;   break;
-	case MGN_54M:   ret = DESC90_RATE54M;   break;
-
-	// HT rate since here
-	case MGN_MCS0:  ret = DESC90_RATEMCS0;  break;
-	case MGN_MCS1:  ret = DESC90_RATEMCS1;  break;
-	case MGN_MCS2:  ret = DESC90_RATEMCS2;  break;
-	case MGN_MCS3:  ret = DESC90_RATEMCS3;  break;
-	case MGN_MCS4:  ret = DESC90_RATEMCS4;  break;
-	case MGN_MCS5:  ret = DESC90_RATEMCS5;  break;
-	case MGN_MCS6:  ret = DESC90_RATEMCS6;  break;
-	case MGN_MCS7:  ret = DESC90_RATEMCS7;  break;
-	case MGN_MCS8:  ret = DESC90_RATEMCS8;  break;
-	case MGN_MCS9:  ret = DESC90_RATEMCS9;  break;
-	case MGN_MCS10: ret = DESC90_RATEMCS10; break;
-	case MGN_MCS11: ret = DESC90_RATEMCS11; break;
-	case MGN_MCS12: ret = DESC90_RATEMCS12; break;
-	case MGN_MCS13: ret = DESC90_RATEMCS13; break;
-	case MGN_MCS14: ret = DESC90_RATEMCS14; break;
-	case MGN_MCS15: ret = DESC90_RATEMCS15; break;
-	case (0x80|0x20): ret = DESC90_RATEMCS32; break;
-
-	default:       break;
+	switch (rate)
+	{
+		case MGN_1M:
+			ret = DESC90_RATE1M;
+			break;
+		case MGN_2M:
+			ret = DESC90_RATE2M;
+			break;
+		case MGN_5_5M:
+			ret = DESC90_RATE5_5M;
+			break;
+		case MGN_11M:
+			ret = DESC90_RATE11M;
+			break;
+		case MGN_6M:
+			ret = DESC90_RATE6M;
+			break;
+		case MGN_9M:
+			ret = DESC90_RATE9M;
+			break;
+		case MGN_12M:
+			ret = DESC90_RATE12M;
+			break;
+		case MGN_18M:
+			ret = DESC90_RATE18M;
+			break;
+		case MGN_24M:
+			ret = DESC90_RATE24M;
+			break;
+		case MGN_36M:
+			ret = DESC90_RATE36M;
+			break;
+		case MGN_48M:
+			ret = DESC90_RATE48M;
+			break;
+		case MGN_54M:
+			ret = DESC90_RATE54M;
+			break;
+
+		// HT rate since here
+		case MGN_MCS0:
+			ret = DESC90_RATEMCS0;
+			break;
+		case MGN_MCS1:
+			ret = DESC90_RATEMCS1;
+			break;
+		case MGN_MCS2:
+			ret = DESC90_RATEMCS2;
+			break;
+		case MGN_MCS3:
+			ret = DESC90_RATEMCS3;
+			break;
+		case MGN_MCS4:
+			ret = DESC90_RATEMCS4;
+			break;
+		case MGN_MCS5:
+			ret = DESC90_RATEMCS5;
+			break;
+		case MGN_MCS6:
+			ret = DESC90_RATEMCS6;
+			break;
+		case MGN_MCS7:
+			ret = DESC90_RATEMCS7;
+			break;
+		case MGN_MCS8:
+			ret = DESC90_RATEMCS8;
+			break;
+		case MGN_MCS9:
+			ret = DESC90_RATEMCS9;
+			break;
+		case MGN_MCS10:
+			ret = DESC90_RATEMCS10;
+			break;
+		case MGN_MCS11:
+			ret = DESC90_RATEMCS11;
+			break;
+		case MGN_MCS12:
+			ret = DESC90_RATEMCS12;
+			break;
+		case MGN_MCS13:
+			ret = DESC90_RATEMCS13;
+			break;
+		case MGN_MCS14:
+			ret = DESC90_RATEMCS14;
+			break;
+		case MGN_MCS15:
+			ret = DESC90_RATEMCS15;
+			break;
+		case (0x80|0x20):
+			ret = DESC90_RATEMCS32;
+			break;
+
+		default:
+			break;
 	}
 	return ret;
 }
@@ -1712,7 +1827,8 @@ short rtl8192_tx(struct net_device *dev, struct sk_buff *skb)
 	tx_fwinfo->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 	tx_fwinfo->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
 	tx_fwinfo->Short = QueryIsShort(tx_fwinfo->TxHT, tx_fwinfo->TxRate, tcb_desc);
-	if (tcb_desc->bAMPDUEnable) {//AMPDU enabled
+	if (tcb_desc->bAMPDUEnable) //AMPDU enabled
+	{
 		tx_fwinfo->AllowAggregation = 1;
 		/* DWORD 1 */
 		tx_fwinfo->RxMF = tcb_desc->ampdu_factor;
@@ -2198,7 +2314,8 @@ void rtl8192_update_ratr_table(struct net_device *dev)
 		break;
 	case IEEE_N_24G:
 	case IEEE_N_5G:
-		if (ieee->pHTInfo->PeerMimoPs == 0) {//MIMO_PS_STATIC
+		if (ieee->pHTInfo->PeerMimoPs == 0) //MIMO_PS_STATIC
+		{
 			ratr_value &= 0x0007F007;
 		} else {
 			if (priv->rf_type == RF_1T2R)
@@ -2582,7 +2699,8 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 		else
 			priv->EEPROM_Def_Ver = 1;
 		RT_TRACE(COMP_EPROM, "EEPROM_DEF_VER:%d\n", priv->EEPROM_Def_Ver);
-		if (priv->EEPROM_Def_Ver == 0) { //old eeprom definition
+		if (priv->EEPROM_Def_Ver == 0) //old eeprom definition
+		{
 			int i;
 			if (bLoad_From_EEPOM)
 				priv->EEPROMTxPowerLevelCCK = (eprom_read(dev, (EEPROM_TxPwIndex_CCK>>1))&0xff) >> 8;
@@ -2993,13 +3111,15 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	//
 #ifdef TO_DO_LIST
 	if (Adapter->ResetProgress == RESET_TYPE_NORESET) {
-		if (pMgntInfo->RegRfOff == TRUE) { // User disable RF via registry.
+		if (pMgntInfo->RegRfOff == TRUE) // User disable RF via registry.
+		{
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
 			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
 			// Those actions will be discard in MgntActSet_RF_State because of the same state
 			for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
-		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) { // H/W or S/W RF OFF before sleep.
+		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) // H/W or S/W RF OFF before sleep.
+		{
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RfOffReason(%d) ----------\n", pMgntInfo->RfOffReason));
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
 		} else {
@@ -3008,7 +3128,8 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): RF is on ----------\n"));
 		}
 	} else {
-		if (pHalData->eRFPowerState == eRfOff) {
+		if (pHalData->eRFPowerState == eRfOff)
+		{
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
 			// Those actions will be discard in MgntActSet_RF_State because of the same state
 			for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++)
@@ -3017,7 +3138,8 @@ static bool rtl8192_adapter_start(struct net_device *dev)
 	}
 #endif
 	//config RF.
-	if (priv->ResetProgress == RESET_TYPE_NORESET) {
+	if (priv->ResetProgress == RESET_TYPE_NORESET)
+	{
 		rtl8192_phy_RFConfig(dev);
 		RT_TRACE(COMP_INIT, "%s():after phy RF config\n", __func__);
 	}
@@ -3525,7 +3647,8 @@ void rtl819x_watchdog_wqcallback(struct work_struct *work)
 	}
 	if ((priv->force_reset) || (priv->ResetProgress == RESET_TYPE_NORESET &&
 	    (priv->bForcedSilentReset ||
-	    (!priv->bDisableNormalResetCheck && ResetType == RESET_TYPE_SILENT)))) { // This is control by OID set in Pomelo
+	    (!priv->bDisableNormalResetCheck && ResetType == RESET_TYPE_SILENT)))) // This is control by OID set in Pomelo
+	{
 		RT_TRACE(COMP_RESET, "%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n", __func__, priv->force_reset, priv->ResetProgress, priv->bForcedSilentReset, priv->bDisableNormalResetCheck, ResetType);
 		rtl819x_ifsilentreset(dev);
 	}
@@ -3586,7 +3709,8 @@ int rtl8192_up(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	if (priv->up == 1) return -1;
+	if (priv->up == 1)
+		return -1;
 
 	return _rtl8192_up(dev);
 }
@@ -3612,7 +3736,8 @@ int rtl8192_down(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int i;
 
-	if (priv->up == 0) return -1;
+	if (priv->up == 0)
+		return -1;
 
 	priv->up = 0;
 	priv->ieee80211->ieee_up = 0;
@@ -3650,7 +3775,8 @@ void rtl8192_commit(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int reset_status = 0;
-	if (priv->up == 0) return;
+	if (priv->up == 0)
+		return;
 	priv->up = 0;
 
 	rtl8192_cancel_deferred_work(priv);
@@ -3802,50 +3928,110 @@ static u8 HwRateToMRate90(bool bIsHT, u8 rate)
 	u8  ret_rate = 0xff;
 
 	if (!bIsHT) {
-		switch (rate) {
-		case DESC90_RATE1M:   ret_rate = MGN_1M;         break;
-		case DESC90_RATE2M:   ret_rate = MGN_2M;         break;
-		case DESC90_RATE5_5M: ret_rate = MGN_5_5M;       break;
-		case DESC90_RATE11M:  ret_rate = MGN_11M;        break;
-		case DESC90_RATE6M:   ret_rate = MGN_6M;         break;
-		case DESC90_RATE9M:   ret_rate = MGN_9M;         break;
-		case DESC90_RATE12M:  ret_rate = MGN_12M;        break;
-		case DESC90_RATE18M:  ret_rate = MGN_18M;        break;
-		case DESC90_RATE24M:  ret_rate = MGN_24M;        break;
-		case DESC90_RATE36M:  ret_rate = MGN_36M;        break;
-		case DESC90_RATE48M:  ret_rate = MGN_48M;        break;
-		case DESC90_RATE54M:  ret_rate = MGN_54M;        break;
+		switch (rate)
+		{
+			case DESC90_RATE1M:
+				ret_rate = MGN_1M;
+				break;
+			case DESC90_RATE2M:
+				ret_rate = MGN_2M;
+				break;
+			case DESC90_RATE5_5M:
+				ret_rate = MGN_5_5M;
+				break;
+			case DESC90_RATE11M:
+				ret_rate = MGN_11M;
+				break;
+			case DESC90_RATE6M:
+				ret_rate = MGN_6M;
+				break;
+			case DESC90_RATE9M:
+				ret_rate = MGN_9M;
+				break;
+			case DESC90_RATE12M:
+				ret_rate = MGN_12M;
+				break;
+			case DESC90_RATE18M:
+				ret_rate = MGN_18M;
+				break;
+			case DESC90_RATE24M:
+				ret_rate = MGN_24M;
+				break;
+			case DESC90_RATE36M:
+				ret_rate = MGN_36M;
+				break;
+			case DESC90_RATE48M:
+				ret_rate = MGN_48M;
+				break;
+			case DESC90_RATE54M:
+				ret_rate = MGN_54M;
+				break;
 
-		default:
-			ret_rate = 0xff;
-			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
-			break;
+			default:
+				ret_rate = 0xff;
+				RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
+				break;
 		}
 
 	} else {
-		switch (rate) {
-		case DESC90_RATEMCS0:   ret_rate = MGN_MCS0;    break;
-		case DESC90_RATEMCS1:   ret_rate = MGN_MCS1;    break;
-		case DESC90_RATEMCS2:   ret_rate = MGN_MCS2;    break;
-		case DESC90_RATEMCS3:   ret_rate = MGN_MCS3;    break;
-		case DESC90_RATEMCS4:   ret_rate = MGN_MCS4;    break;
-		case DESC90_RATEMCS5:   ret_rate = MGN_MCS5;    break;
-		case DESC90_RATEMCS6:   ret_rate = MGN_MCS6;    break;
-		case DESC90_RATEMCS7:   ret_rate = MGN_MCS7;    break;
-		case DESC90_RATEMCS8:   ret_rate = MGN_MCS8;    break;
-		case DESC90_RATEMCS9:   ret_rate = MGN_MCS9;    break;
-		case DESC90_RATEMCS10:  ret_rate = MGN_MCS10;   break;
-		case DESC90_RATEMCS11:  ret_rate = MGN_MCS11;   break;
-		case DESC90_RATEMCS12:  ret_rate = MGN_MCS12;   break;
-		case DESC90_RATEMCS13:  ret_rate = MGN_MCS13;   break;
-		case DESC90_RATEMCS14:  ret_rate = MGN_MCS14;   break;
-		case DESC90_RATEMCS15:  ret_rate = MGN_MCS15;   break;
-		case DESC90_RATEMCS32:  ret_rate = (0x80|0x20); break;
+		switch (rate)
+		{
+			case DESC90_RATEMCS0:
+				ret_rate = MGN_MCS0;
+				break;
+			case DESC90_RATEMCS1:
+				ret_rate = MGN_MCS1;
+				break;
+			case DESC90_RATEMCS2:
+				ret_rate = MGN_MCS2;
+				break;
+			case DESC90_RATEMCS3:
+				ret_rate = MGN_MCS3;
+				break;
+			case DESC90_RATEMCS4:
+				ret_rate = MGN_MCS4;
+				break;
+			case DESC90_RATEMCS5:
+				ret_rate = MGN_MCS5;
+				break;
+			case DESC90_RATEMCS6:
+				ret_rate = MGN_MCS6;
+				break;
+			case DESC90_RATEMCS7:
+				ret_rate = MGN_MCS7;
+				break;
+			case DESC90_RATEMCS8:
+				ret_rate = MGN_MCS8;
+				break;
+			case DESC90_RATEMCS9:
+				ret_rate = MGN_MCS9;
+				break;
+			case DESC90_RATEMCS10:
+				ret_rate = MGN_MCS10;
+				break;
+			case DESC90_RATEMCS11:
+				ret_rate = MGN_MCS11;
+				break;
+			case DESC90_RATEMCS12:
+				ret_rate = MGN_MCS12;
+				break;
+			case DESC90_RATEMCS13:
+				ret_rate = MGN_MCS13;
+				break;
+			case DESC90_RATEMCS14:
+				ret_rate = MGN_MCS14;
+				break;
+			case DESC90_RATEMCS15:
+				ret_rate = MGN_MCS15;
+				break;
+			case DESC90_RATEMCS32:
+				ret_rate = (0x80|0x20);
+				break;
 
-		default:
-			ret_rate = 0xff;
-			RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
-			break;
+			default:
+				ret_rate = 0xff;
+				RT_TRACE(COMP_RECV, "HwRateToMRate90(): Non supported Rate [%x], bIsHT = %d!!!\n", rate, bIsHT);
+				break;
 		}
 	}
 
@@ -3872,7 +4058,8 @@ static void UpdateRxPktTimeStamp8190(struct net_device *dev,
 {
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 
-	if (stats->bIsAMPDU && !stats->bFirstMPDU) {
+	if (stats->bIsAMPDU && !stats->bFirstMPDU)
+	{
 		stats->mac_time[0] = priv->LastRxDescTSFLow;
 		stats->mac_time[1] = priv->LastRxDescTSFHigh;
 	} else {
@@ -4063,8 +4250,10 @@ static void rtl8192_process_phyinfo(struct r8192_priv *priv, u8 *buffer,
 		}
 
 		// <2> Showed on UI for engineering
-		if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA) {
-			for (nspatial_stream = 0; nspatial_stream < 2; nspatial_stream++) { // 2 spatial stream
+		if (pprevious_stats->bPacketToSelf || pprevious_stats->bPacketBeacon || pprevious_stats->bToSelfBA)
+		{
+			for (nspatial_stream = 0; nspatial_stream < 2; nspatial_stream++) // 2 spatial stream
+			{
 				if (pprevious_stats->RxMIMOSignalQuality[nspatial_stream] != -1) {
 					if (priv->stats.rx_evm_percentage[nspatial_stream] == 0) // initialize
 						priv->stats.rx_evm_percentage[nspatial_stream] = pprevious_stats->RxMIMOSignalQuality[nspatial_stream];
@@ -4487,45 +4676,104 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 	else
 		preamble_guardinterval = 0;// long
 
-	switch (stats->rate) {
+	switch (stats->rate)
+	{
 		//
 		// CCK rate
 		//
-	case MGN_1M:    rateIndex = 0;  break;
-	case MGN_2M:    rateIndex = 1;  break;
-	case MGN_5_5M:  rateIndex = 2;  break;
-	case MGN_11M:   rateIndex = 3;  break;
+		case MGN_1M:
+			rateIndex = 0;
+			break;
+		case MGN_2M:
+			rateIndex = 1;
+			break;
+		case MGN_5_5M:
+			rateIndex = 2;
+			break;
+		case MGN_11M:
+			rateIndex = 3;
+			break;
 		//
 		// Legacy OFDM rate
 		//
-	case MGN_6M:    rateIndex = 4;  break;
-	case MGN_9M:    rateIndex = 5;  break;
-	case MGN_12M:   rateIndex = 6;  break;
-	case MGN_18M:   rateIndex = 7;  break;
-	case MGN_24M:   rateIndex = 8;  break;
-	case MGN_36M:   rateIndex = 9;  break;
-	case MGN_48M:   rateIndex = 10; break;
-	case MGN_54M:   rateIndex = 11; break;
+		case MGN_6M:
+			rateIndex = 4;
+			break;
+		case MGN_9M:
+			rateIndex = 5;
+			break;
+		case MGN_12M:
+			rateIndex = 6;
+			break;
+		case MGN_18M:
+			rateIndex = 7;
+			break;
+		case MGN_24M:
+			rateIndex = 8;
+			break;
+		case MGN_36M:
+			rateIndex = 9;
+			break;
+		case MGN_48M:
+			rateIndex = 10;
+			break;
+		case MGN_54M:
+			rateIndex = 11;
+			break;
 		//
 		// 11n High throughput rate
 		//
-	case MGN_MCS0:  rateIndex = 12; break;
-	case MGN_MCS1:  rateIndex = 13; break;
-	case MGN_MCS2:  rateIndex = 14; break;
-	case MGN_MCS3:  rateIndex = 15; break;
-	case MGN_MCS4:  rateIndex = 16; break;
-	case MGN_MCS5:  rateIndex = 17; break;
-	case MGN_MCS6:  rateIndex = 18; break;
-	case MGN_MCS7:  rateIndex = 19; break;
-	case MGN_MCS8:  rateIndex = 20; break;
-	case MGN_MCS9:  rateIndex = 21; break;
-	case MGN_MCS10: rateIndex = 22; break;
-	case MGN_MCS11: rateIndex = 23; break;
-	case MGN_MCS12: rateIndex = 24; break;
-	case MGN_MCS13: rateIndex = 25; break;
-	case MGN_MCS14: rateIndex = 26; break;
-	case MGN_MCS15: rateIndex = 27; break;
-	default:        rateIndex = 28; break;
+		case MGN_MCS0:
+			rateIndex = 12;
+			break;
+		case MGN_MCS1:
+			rateIndex = 13;
+			break;
+		case MGN_MCS2:
+			rateIndex = 14;
+			break;
+		case MGN_MCS3:
+			rateIndex = 15;
+			break;
+		case MGN_MCS4:
+			rateIndex = 16;
+			break;
+		case MGN_MCS5:
+			rateIndex = 17;
+			break;
+		case MGN_MCS6:
+			rateIndex = 18;
+			break;
+		case MGN_MCS7:
+			rateIndex = 19;
+			break;
+		case MGN_MCS8:
+			rateIndex = 20;
+			break;
+		case MGN_MCS9:
+			rateIndex = 21;
+			break;
+		case MGN_MCS10:
+			rateIndex = 22;
+			break;
+		case MGN_MCS11:
+			rateIndex = 23;
+			break;
+		case MGN_MCS12:
+			rateIndex = 24;
+			break;
+		case MGN_MCS13:
+			rateIndex = 25;
+			break;
+		case MGN_MCS14:
+			rateIndex = 26;
+			break;
+		case MGN_MCS15:
+			rateIndex = 27;
+			break;
+		default:
+			rateIndex = 28;
+			break;
 	}
 	priv->stats.received_preamble_GI[preamble_guardinterval][rateIndex]++;
 	priv->stats.received_rate_histogram[0][rateIndex]++; //total
@@ -5146,7 +5394,8 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 
 	ieee->hwsec_active = 1;
 
-	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep) { //add hwsec_support flag to totol control hw_sec on/off
+	if ((ieee->pHTInfo->IOTAction&HT_IOT_ACT_PURE_N_MODE) || !hwwep) //add hwsec_support flag to totol control hw_sec on/off
+	{
 		ieee->hwsec_active = 0;
 		SECR_value &= ~SCR_RxDecEnable;
 	}
@@ -5178,14 +5427,16 @@ void setKey(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 		TargetCommand  = i+CAM_CONTENT_COUNT*EntryNo;
 		TargetCommand |= BIT31|BIT16;
 
-		if (i == 0) { //MAC|Config
+		if (i == 0) //MAC|Config
+		{
 			TargetContent = (u32)(*(MacAddr+0)) << 16|
 					(u32)(*(MacAddr+1)) << 24|
 					(u32)usConfig;
 
 			write_nic_dword(dev, WCAMI, TargetContent);
 			write_nic_dword(dev, RWCAM, TargetCommand);
-		} else if (i == 1) { //MAC
+		} else if (i == 1) //MAC
+		{
 			TargetContent = (u32)(*(MacAddr+2))	 |
 					(u32)(*(MacAddr+3)) <<  8|
 					(u32)(*(MacAddr+4)) << 16|
-- 
1.9.1

