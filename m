Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaLDCUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:20:43 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:41676 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaLDCUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:20:42 -0500
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix "'foo * bar' should be 'foo *bar'" errors
Date: Wed,  3 Dec 2014 20:19:59 -0600
Message-Id: <1417659599-29423-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "'foo * bar' should be 'foo *bar'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 .../rtl8723au/include/rtl8723a_bt-coexist.h        | 177 +++++++++++----------
 drivers/staging/rtl8723au/include/rtl8723a_recv.h  |   4 +-
 drivers/staging/rtl8723au/include/rtw_cmd.h        |   8 +-
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |   2 +-
 4 files changed, 102 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h b/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
index 0506965..7add5df 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
@@ -31,8 +31,8 @@ enum rt_media_status {
 
 void BT_SignalCompensation(struct rtw_adapter *padapter,
 			   u8 *rssi_wifi, u8 *rssi_bt);
-void BT_HaltProcess(struct rtw_adapter * padapter);
-void BT_LpsLeave(struct rtw_adapter * padapter);
+void BT_HaltProcess(struct rtw_adapter *padapter);
+void BT_LpsLeave(struct rtw_adapter *padapter);
 
 
 #define	BT_HsConnectionEstablished(Adapter)		false
@@ -1092,17 +1092,20 @@ enum hci_ext_bp_operation {
 	BTHCI_StateMachine(_Adapter, _StateToEnter, _StateCmd, _EntryNum);\
 }
 
-void BTHCI_EventParse(struct rtw_adapter * padapter, void *pEvntData, u32 dataLen);
+void BTHCI_EventParse(struct rtw_adapter *padapter, void *pEvntData,
+		      u32 dataLen);
 #define BT_EventParse BTHCI_EventParse
-u8 BTHCI_HsConnectionEstablished(struct rtw_adapter * padapter);
-void BTHCI_UpdateBTProfileRTKToMoto(struct rtw_adapter * padapter);
-void BTHCI_WifiScanNotify(struct rtw_adapter * padapter, u8 scanType);
-void BTHCI_StateMachine(struct rtw_adapter * padapter, u8 StateToEnter, enum hci_state_with_cmd StateCmd, u8 EntryNum);
-void BTHCI_DisconnectPeer(struct rtw_adapter * padapter, u8 EntryNum);
-void BTHCI_EventNumOfCompletedDataBlocks(struct rtw_adapter * padapter);
-void BTHCI_EventAMPStatusChange(struct rtw_adapter * padapter, u8 AMP_Status);
-void BTHCI_DisconnectAll(struct rtw_adapter * padapter);
-enum hci_status BTHCI_HandleHCICMD(struct rtw_adapter * padapter, struct packet_irp_hcicmd_data *pHciCmd);
+u8 BTHCI_HsConnectionEstablished(struct rtw_adapter *padapter);
+void BTHCI_UpdateBTProfileRTKToMoto(struct rtw_adapter *padapter);
+void BTHCI_WifiScanNotify(struct rtw_adapter *padapter, u8 scanType);
+void BTHCI_StateMachine(struct rtw_adapter *padapter, u8 StateToEnter,
+			enum hci_state_with_cmd StateCmd, u8 EntryNum);
+void BTHCI_DisconnectPeer(struct rtw_adapter *padapter, u8 EntryNum);
+void BTHCI_EventNumOfCompletedDataBlocks(struct rtw_adapter *padapter);
+void BTHCI_EventAMPStatusChange(struct rtw_adapter *padapter, u8 AMP_Status);
+void BTHCI_DisconnectAll(struct rtw_adapter *padapter);
+enum hci_status BTHCI_HandleHCICMD(struct rtw_adapter *padapter,
+				   struct packet_irp_hcicmd_data *pHciCmd);
 
 /*  ===== End of sync from SD7 driver COMMON/bt_hci.h ===== */
 
@@ -1157,9 +1160,10 @@ struct btdm_8723a_1ant {
 	u8		bRAChanged;
 };
 
-void BTDM_1AntSignalCompensation(struct rtw_adapter * padapter, u8 *rssi_wifi, u8 *rssi_bt);
-void BTDM_1AntForDhcp(struct rtw_adapter * padapter);
-void BTDM_1AntBtCoexist8723A(struct rtw_adapter * padapter);
+void BTDM_1AntSignalCompensation(struct rtw_adapter *padapter,
+				 u8 *rssi_wifi, u8 *rssi_bt);
+void BTDM_1AntForDhcp(struct rtw_adapter *padapter);
+void BTDM_1AntBtCoexist8723A(struct rtw_adapter *padapter);
 
 /*  ===== End of sync from SD7 driver HAL/BTCoexist/HalBtc87231Ant.h ===== */
 
@@ -1241,7 +1245,7 @@ struct btdm_8723a_2ant {
 	u8	btStatus;
 };
 
-void BTDM_2AntBtCoexist8723A(struct rtw_adapter * padapter);
+void BTDM_2AntBtCoexist8723A(struct rtw_adapter *padapter);
 /*  ===== End of sync from SD7 driver HAL/BTCoexist/HalBtc87232Ant.h ===== */
 
 /*  ===== Below this line is sync from SD7 driver HAL/BTCoexist/HalBtc8723.h ===== */
@@ -1310,15 +1314,17 @@ struct bt_coexist_8723a {
 	struct btdm_8723a_1ant			btdm1Ant;
 };
 
-void BTDM_SetFwChnlInfo(struct rtw_adapter * padapter, enum rt_media_status mstatus);
-u8 BTDM_IsWifiConnectionExist(struct rtw_adapter * padapter);
-void BTDM_SetFw3a(struct rtw_adapter * padapter, u8 byte1, u8 byte2, u8 byte3, u8 byte4, u8 byte5);
-void BTDM_QueryBtInformation(struct rtw_adapter * padapter);
-void BTDM_SetSwRfRxLpfCorner(struct rtw_adapter * padapter, u8 type);
-void BTDM_SetSwPenaltyTxRateAdaptive(struct rtw_adapter * padapter, u8 raType);
-void BTDM_SetFwDecBtPwr(struct rtw_adapter * padapter, u8 bDecBtPwr);
-u8 BTDM_BtProfileSupport(struct rtw_adapter * padapter);
-void BTDM_LpsLeave(struct rtw_adapter * padapter);
+void BTDM_SetFwChnlInfo(struct rtw_adapter *padapter,
+			enum rt_media_status mstatus);
+u8 BTDM_IsWifiConnectionExist(struct rtw_adapter *padapter);
+void BTDM_SetFw3a(struct rtw_adapter *padapter, u8 byte1, u8 byte2, u8 byte3,
+		  u8 byte4, u8 byte5);
+void BTDM_QueryBtInformation(struct rtw_adapter *padapter);
+void BTDM_SetSwRfRxLpfCorner(struct rtw_adapter *padapter, u8 type);
+void BTDM_SetSwPenaltyTxRateAdaptive(struct rtw_adapter *padapter, u8 raType);
+void BTDM_SetFwDecBtPwr(struct rtw_adapter *padapter, u8 bDecBtPwr);
+u8 BTDM_BtProfileSupport(struct rtw_adapter *padapter);
+void BTDM_LpsLeave(struct rtw_adapter *padapter);
 
 /*  ===== End of sync from SD7 driver HAL/BTCoexist/HalBtc8723.h ===== */
 
@@ -1340,8 +1346,9 @@ enum BT_A2DP_INDEX{
 #define BTDM_ANT_BT						2
 
 
-void BTDM_SingleAnt(struct rtw_adapter * padapter, u8 bSingleAntOn, u8 bInterruptOn, u8 bMultiNAVOn);
-void BTDM_CheckBTIdleChange1Ant(struct rtw_adapter * padapter);
+void BTDM_SingleAnt(struct rtw_adapter *padapter, u8 bSingleAntOn,
+		    u8 bInterruptOn, u8 bMultiNAVOn);
+void BTDM_CheckBTIdleChange1Ant(struct rtw_adapter *padapter);
 
 /*  ===== End of sync from SD7 driver HAL/BTCoexist/HalBtcCsr1Ant.h ===== */
 
@@ -1361,7 +1368,8 @@ void BTDM_CheckBTIdleChange1Ant(struct rtw_adapter * padapter);
 #define	BT_DACSWING_M7				2
 #define	BT_DACSWING_M10				3
 
-void BTDM_DiminishWiFi(struct rtw_adapter * Adapter, u8 bDACOn, u8 bInterruptOn, u8 DACSwingLevel, u8 bNAVOn);
+void BTDM_DiminishWiFi(struct rtw_adapter *Adapter, u8 bDACOn, u8 bInterruptOn,
+		       u8 DACSwingLevel, u8 bNAVOn);
 
 /*  ===== End of sync from SD7 driver HAL/BTCoexist/HalBtcCsr2Ant.h ===== */
 
@@ -1534,58 +1542,63 @@ struct bt_coexist_str {
 	u8			fw3aVal[5];
 };
 
-void BTDM_CheckAntSelMode(struct rtw_adapter * padapter);
-void BTDM_FwC2hBtRssi(struct rtw_adapter * padapter, u8 *tmpBuf);
+void BTDM_CheckAntSelMode(struct rtw_adapter *padapter);
+void BTDM_FwC2hBtRssi(struct rtw_adapter *padapter, u8 *tmpBuf);
 #define BT_FwC2hBtRssi BTDM_FwC2hBtRssi
-void BTDM_DisplayBtCoexInfo(struct rtw_adapter * padapter);
+void BTDM_DisplayBtCoexInfo(struct rtw_adapter *padapter);
 #define BT_DisplayBtCoexInfo BTDM_DisplayBtCoexInfo
-void BTDM_RejectAPAggregatedPacket(struct rtw_adapter * padapter, u8 bReject);
-u8 BTDM_IsHT40(struct rtw_adapter * padapter);
-u8 BTDM_Legacy(struct rtw_adapter * padapter);
-void BTDM_CheckWiFiState(struct rtw_adapter * padapter);
-s32 BTDM_GetRxSS(struct rtw_adapter * padapter);
-u8 BTDM_CheckCoexBcnRssiState(struct rtw_adapter * padapter, u8 levelNum, u8 RssiThresh, u8 RssiThresh1);
-u8 BTDM_CheckCoexRSSIState1(struct rtw_adapter * padapter, u8 levelNum, u8 RssiThresh, u8 RssiThresh1);
-u8 BTDM_CheckCoexRSSIState(struct rtw_adapter * padapter, u8 levelNum, u8 RssiThresh, u8 RssiThresh1);
-void BTDM_Balance(struct rtw_adapter * padapter, u8 bBalanceOn, u8 ms0, u8 ms1);
-void BTDM_AGCTable(struct rtw_adapter * padapter, u8 type);
-void BTDM_BBBackOffLevel(struct rtw_adapter * padapter, u8 type);
-void BTDM_FWCoexAllOff(struct rtw_adapter * padapter);
-void BTDM_SWCoexAllOff(struct rtw_adapter * padapter);
-void BTDM_HWCoexAllOff(struct rtw_adapter * padapter);
-void BTDM_CoexAllOff(struct rtw_adapter * padapter);
-void BTDM_TurnOffBtCoexistBeforeEnterIPS(struct rtw_adapter * padapter);
-void BTDM_SignalCompensation(struct rtw_adapter * padapter, u8 *rssi_wifi, u8 *rssi_bt);
-void BTDM_UpdateCoexState(struct rtw_adapter * padapter);
-u8 BTDM_IsSameCoexistState(struct rtw_adapter * padapter);
-void BTDM_PWDBMonitor(struct rtw_adapter * padapter);
-u8 BTDM_IsBTBusy(struct rtw_adapter * padapter);
+void BTDM_RejectAPAggregatedPacket(struct rtw_adapter *padapter, u8 bReject);
+u8 BTDM_IsHT40(struct rtw_adapter *padapter);
+u8 BTDM_Legacy(struct rtw_adapter *padapter);
+void BTDM_CheckWiFiState(struct rtw_adapter *padapter);
+s32 BTDM_GetRxSS(struct rtw_adapter *padapter);
+u8 BTDM_CheckCoexBcnRssiState(struct rtw_adapter *padapter, u8 levelNum,
+			      u8 RssiThresh, u8 RssiThresh1);
+u8 BTDM_CheckCoexRSSIState1(struct rtw_adapter *padapter, u8 levelNum,
+			    u8 RssiThresh, u8 RssiThresh1);
+u8 BTDM_CheckCoexRSSIState(struct rtw_adapter *padapter, u8 levelNum,
+			   u8 RssiThresh, u8 RssiThresh1);
+void BTDM_Balance(struct rtw_adapter *padapter, u8 bBalanceOn, u8 ms0, u8 ms1);
+void BTDM_AGCTable(struct rtw_adapter *padapter, u8 type);
+void BTDM_BBBackOffLevel(struct rtw_adapter *padapter, u8 type);
+void BTDM_FWCoexAllOff(struct rtw_adapter *padapter);
+void BTDM_SWCoexAllOff(struct rtw_adapter *padapter);
+void BTDM_HWCoexAllOff(struct rtw_adapter *padapter);
+void BTDM_CoexAllOff(struct rtw_adapter *padapter);
+void BTDM_TurnOffBtCoexistBeforeEnterIPS(struct rtw_adapter *padapter);
+void BTDM_SignalCompensation(struct rtw_adapter *padapter, u8 *rssi_wifi,
+			     u8 *rssi_bt);
+void BTDM_UpdateCoexState(struct rtw_adapter *padapter);
+u8 BTDM_IsSameCoexistState(struct rtw_adapter *padapter);
+void BTDM_PWDBMonitor(struct rtw_adapter *padapter);
+u8 BTDM_IsBTBusy(struct rtw_adapter *padapter);
 #define BT_IsBtBusy BTDM_IsBTBusy
-u8 BTDM_IsWifiBusy(struct rtw_adapter * padapter);
-u8 BTDM_IsCoexistStateChanged(struct rtw_adapter * padapter);
-u8 BTDM_IsWifiUplink(struct rtw_adapter * padapter);
-u8 BTDM_IsWifiDownlink(struct rtw_adapter * padapter);
-u8 BTDM_IsBTHSMode(struct rtw_adapter * padapter);
-u8 BTDM_IsBTUplink(struct rtw_adapter * padapter);
-u8 BTDM_IsBTDownlink(struct rtw_adapter * padapter);
-void BTDM_AdjustForBtOperation(struct rtw_adapter * padapter);
-void BTDM_ForHalt(struct rtw_adapter * padapter);
-void BTDM_WifiScanNotify(struct rtw_adapter * padapter, u8 scanType);
-void BTDM_WifiAssociateNotify(struct rtw_adapter * padapter, u8 action);
-void BTDM_MediaStatusNotify(struct rtw_adapter * padapter, enum rt_media_status mstatus);
-void BTDM_ForDhcp(struct rtw_adapter * padapter);
-void BTDM_ResetActionProfileState(struct rtw_adapter * padapter);
-void BTDM_SetBtCoexCurrAntNum(struct rtw_adapter * padapter, u8 antNum);
+u8 BTDM_IsWifiBusy(struct rtw_adapter *padapter);
+u8 BTDM_IsCoexistStateChanged(struct rtw_adapter *padapter);
+u8 BTDM_IsWifiUplink(struct rtw_adapter *padapter);
+u8 BTDM_IsWifiDownlink(struct rtw_adapter *padapter);
+u8 BTDM_IsBTHSMode(struct rtw_adapter *padapter);
+u8 BTDM_IsBTUplink(struct rtw_adapter *padapter);
+u8 BTDM_IsBTDownlink(struct rtw_adapter *padapter);
+void BTDM_AdjustForBtOperation(struct rtw_adapter *padapter);
+void BTDM_ForHalt(struct rtw_adapter *padapter);
+void BTDM_WifiScanNotify(struct rtw_adapter *padapter, u8 scanType);
+void BTDM_WifiAssociateNotify(struct rtw_adapter *padapter, u8 action);
+void BTDM_MediaStatusNotify(struct rtw_adapter *padapter,
+			    enum rt_media_status mstatus);
+void BTDM_ForDhcp(struct rtw_adapter *padapter);
+void BTDM_ResetActionProfileState(struct rtw_adapter *padapter);
+void BTDM_SetBtCoexCurrAntNum(struct rtw_adapter *padapter, u8 antNum);
 #define BT_SetBtCoexCurrAntNum BTDM_SetBtCoexCurrAntNum
-u8 BTDM_IsActionSCO(struct rtw_adapter * padapter);
-u8 BTDM_IsActionHID(struct rtw_adapter * padapter);
-u8 BTDM_IsActionA2DP(struct rtw_adapter * padapter);
-u8 BTDM_IsActionPAN(struct rtw_adapter * padapter);
-u8 BTDM_IsActionHIDA2DP(struct rtw_adapter * padapter);
-u8 BTDM_IsActionHIDPAN(struct rtw_adapter * padapter);
-u8 BTDM_IsActionPANA2DP(struct rtw_adapter * padapter);
-u32 BTDM_BtTxRxCounterH(struct rtw_adapter * padapter);
-u32 BTDM_BtTxRxCounterL(struct rtw_adapter * padapter);
+u8 BTDM_IsActionSCO(struct rtw_adapter *padapter);
+u8 BTDM_IsActionHID(struct rtw_adapter *padapter);
+u8 BTDM_IsActionA2DP(struct rtw_adapter *padapter);
+u8 BTDM_IsActionPAN(struct rtw_adapter *padapter);
+u8 BTDM_IsActionHIDA2DP(struct rtw_adapter *padapter);
+u8 BTDM_IsActionHIDPAN(struct rtw_adapter *padapter);
+u8 BTDM_IsActionPANA2DP(struct rtw_adapter *padapter);
+u32 BTDM_BtTxRxCounterH(struct rtw_adapter *padapter);
+u32 BTDM_BtTxRxCounterL(struct rtw_adapter *padapter);
 
 /*  ===== End of sync from SD7 driver HAL/BTCoexist/HalBtCoexist.h ===== */
 
@@ -1593,14 +1606,14 @@ u32 BTDM_BtTxRxCounterL(struct rtw_adapter * padapter);
 
 #define RTS_CTS_NO_LEN_LIMIT	0
 
-u8 HALBT_GetPGAntNum(struct rtw_adapter * padapter);
+u8 HALBT_GetPGAntNum(struct rtw_adapter *padapter);
 #define BT_GetPGAntNum HALBT_GetPGAntNum
-void HALBT_SetKey(struct rtw_adapter * padapter, u8 EntryNum);
-void HALBT_RemoveKey(struct rtw_adapter * padapter, u8 EntryNum);
-u8 HALBT_IsBTExist(struct rtw_adapter * padapter);
+void HALBT_SetKey(struct rtw_adapter *padapter, u8 EntryNum);
+void HALBT_RemoveKey(struct rtw_adapter *padapter, u8 EntryNum);
+u8 HALBT_IsBTExist(struct rtw_adapter *padapter);
 #define BT_IsBtExist HALBT_IsBTExist
-u8 HALBT_BTChipType(struct rtw_adapter * padapter);
-void HALBT_SetRtsCtsNoLenLimit(struct rtw_adapter * padapter);
+u8 HALBT_BTChipType(struct rtw_adapter *padapter);
+void HALBT_SetRtsCtsNoLenLimit(struct rtw_adapter *padapter);
 
 /*  ===== End of sync from SD7 driver HAL/HalBT.c ===== */
 
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_recv.h b/drivers/staging/rtl8723au/include/rtl8723a_recv.h
index 0177bbc..875d37b 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_recv.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_recv.h
@@ -56,8 +56,8 @@ struct interrupt_msg_format {
 	unsigned int  MSG_EX;
 };
 
-int rtl8723au_init_recv_priv(struct rtw_adapter * padapter);
-void rtl8723au_free_recv_priv(struct rtw_adapter * padapter);
+int rtl8723au_init_recv_priv(struct rtw_adapter *padapter);
+void rtl8723au_free_recv_priv(struct rtw_adapter *padapter);
 void rtl8723a_process_phy_info(struct rtw_adapter *padapter, void *prframe);
 void update_recvframe_attrib(struct recv_frame *precvframe, struct recv_stat *prxstat);
 void update_recvframe_phyinfo(struct recv_frame *precvframe, struct phy_stat *pphy_info);
diff --git a/drivers/staging/rtl8723au/include/rtw_cmd.h b/drivers/staging/rtl8723au/include/rtw_cmd.h
index 7104410..92c8ec4 100644
--- a/drivers/staging/rtl8723au/include/rtw_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtw_cmd.h
@@ -689,10 +689,10 @@ int rtw_disassoc_cmd23a(struct rtw_adapter *padapter, u32 deauth_timeout_ms, boo
 int rtw_setopmode_cmd23a(struct rtw_adapter *padapter, enum nl80211_iftype ifmode);
 int rtw_setdatarate_cmd(struct rtw_adapter  *padapter, u8 *rateset);
 int rtw_setbasicrate_cmd(struct rtw_adapter  *padapter, u8 *rateset);
-int rtw_setbbreg_cmd(struct rtw_adapter * padapter, u8 offset, u8 val);
-int rtw_setrfreg_cmd(struct rtw_adapter * padapter, u8 offset, u32 val);
-int rtw_getbbreg_cmd(struct rtw_adapter * padapter, u8 offset, u8 * pval);
-int rtw_getrfreg_cmd(struct rtw_adapter * padapter, u8 offset, u8 * pval);
+int rtw_setbbreg_cmd(struct rtw_adapter *padapter, u8 offset, u8 val);
+int rtw_setrfreg_cmd(struct rtw_adapter *padapter, u8 offset, u32 val);
+int rtw_getbbreg_cmd(struct rtw_adapter *padapter, u8 offset, u8 *pval);
+int rtw_getrfreg_cmd(struct rtw_adapter *padapter, u8 offset, u8 *pval);
 int rtw_setrfintfs_cmd(struct rtw_adapter  *padapter, u8 mode);
 int rtw_setrttbl_cmd(struct rtw_adapter  *padapter, struct setratable_parm *prate_table);
 int rtw_getrttbl_cmd(struct rtw_adapter  *padapter, struct getratable_rsp *pval);
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
index 51dba1f..ffb37b2 100644
--- a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
@@ -509,7 +509,7 @@ int rtw_check_bcn_info23a(struct rtw_adapter *Adapter,
 			  struct ieee80211_mgmt *mgmt, u32 packet_len);
 void update_IOT_info23a(struct rtw_adapter *padapter);
 void update_capinfo23a(struct rtw_adapter *Adapter, u16 updateCap);
-void update_wireless_mode23a(struct rtw_adapter * padapter);
+void update_wireless_mode23a(struct rtw_adapter *padapter);
 void update_tx_basic_rate23a(struct rtw_adapter *padapter, u8 modulation);
 void update_bmc_sta_support_rate23a(struct rtw_adapter *padapter, u32 mac_id);
 int update_sta_support_rate23a(struct rtw_adapter *padapter, u8 *pvar_ie,
-- 
1.9.1

