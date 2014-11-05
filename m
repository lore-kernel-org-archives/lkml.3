Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaKELfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:35:18 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:44139 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKELfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:35:16 -0500
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <Larry.Finger@lwfinger.net>, <Jes.Sorensen@redhat.com>
CC: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v2] staging:rtl8723au: core: Fix error reported by checkpatch.
Date: Wed, 5 Nov 2014 17:05:03 +0530
Message-ID: <1415187303-28541-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <wrfjy4rxzk5b.fsf@redhat.com>
References: <wrfjy4rxzk5b.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rtw_cmd.c file that fixes
Error reported by checkpatch.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
Changes in v2:
  - Shorten variable name by taking temporary structure 

 drivers/staging/rtl8723au/core/rtw_cmd.c | 126 +++++++++++++++----------------
 1 file changed, 62 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 4eaa502..c6f6030 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -919,34 +919,34 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 	u8 bHigherBusyTxTraffic = false;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	int BusyThreshold = 100;
+	struct rt_link_detect *ldi = &pmlmepriv->LinkDetectInfo;
+
 	/*  */
 	/*  Determine if our traffic is busy now */
 	/*  */
 	if (check_fwstate(pmlmepriv, _FW_LINKED)) {
 		if (rtl8723a_BT_coexist(padapter))
 			BusyThreshold = 50;
-		else if (pmlmepriv->LinkDetectInfo.bBusyTraffic)
+		else if (ldi->bBusyTraffic)
 			BusyThreshold = 75;
 		/*  if we raise bBusyTraffic in last watchdog, using
 		    lower threshold. */
-		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > BusyThreshold ||
-		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > BusyThreshold) {
+		if (ldi->NumRxOkInPeriod > BusyThreshold ||
+		    ldi->NumTxOkInPeriod > BusyThreshold) {
 			bBusyTraffic = true;
 
-			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
-			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
+			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
 				bRxBusyTraffic = true;
 			else
 				bTxBusyTraffic = true;
 		}
 
 		/*  Higher Tx/Rx data. */
-		if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod > 4000 ||
-		    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod > 4000) {
+		if (ldi->NumRxOkInPeriod > 4000 ||
+		    ldi->NumTxOkInPeriod > 4000) {
 			bHigherBusyTraffic = true;
 
-			if (pmlmepriv->LinkDetectInfo.NumRxOkInPeriod >
-			    pmlmepriv->LinkDetectInfo.NumTxOkInPeriod)
+			if (ldi->NumRxOkInPeriod > ldi->NumTxOkInPeriod)
 				bHigherBusyRxTraffic = true;
 			else
 				bHigherBusyTxTraffic = true;
@@ -955,9 +955,9 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 		if (!rtl8723a_BT_coexist(padapter) ||
 		    !rtl8723a_BT_using_antenna_1(padapter)) {
 		/*  check traffic for  powersaving. */
-			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
-			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
-			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
+			if (((ldi->NumRxUnicastOkInPeriod +
+			      ldi->NumTxOkInPeriod) > 8) ||
+			    ldi->NumRxUnicastOkInPeriod > 2)
 				bEnterPS = false;
 			else
 				bEnterPS = true;
@@ -968,18 +968,19 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 			else
 				LPS_Leave23a(padapter);
 		}
-	} else
+	} else {
 		LPS_Leave23a(padapter);
+		}
 
-	pmlmepriv->LinkDetectInfo.NumRxOkInPeriod = 0;
-	pmlmepriv->LinkDetectInfo.NumTxOkInPeriod = 0;
-	pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod = 0;
-	pmlmepriv->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bTxBusyTraffic = bTxBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bRxBusyTraffic = bRxBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bHigherBusyTraffic = bHigherBusyTraffic;
-	pmlmepriv->LinkDetectInfo.bHigherBusyRxTraffic = bHigherBusyRxTraffic;
-	pmlmepriv->LinkDetectInfo.bHigherBusyTxTraffic = bHigherBusyTxTraffic;
+	ldi->NumRxOkInPeriod = 0;
+	ldi->NumTxOkInPeriod = 0;
+	ldi->NumRxUnicastOkInPeriod = 0;
+	ldi->bBusyTraffic = bBusyTraffic;
+	ldi->bTxBusyTraffic = bTxBusyTraffic;
+	ldi->bRxBusyTraffic = bRxBusyTraffic;
+	ldi->bHigherBusyTraffic = bHigherBusyTraffic;
+	ldi->bHigherBusyRxTraffic = bHigherBusyRxTraffic;
+	ldi->bHigherBusyTxTraffic = bHigherBusyTxTraffic;
 }
 
 static void dynamic_chk_wk_hdl(struct rtw_adapter *padapter, u8 *pbuf, int sz)
@@ -1017,46 +1018,44 @@ static void lps_ctrl_wk_hdl(struct rtw_adapter *padapter, u8 lps_ctrl_type)
 	    check_fwstate(pmlmepriv, WIFI_ADHOC_STATE))
 		return;
 
-	switch (lps_ctrl_type)
-	{
-		case LPS_CTRL_SCAN:
-			rtl8723a_BT_wifiscan_notify(padapter, true);
-			if (!rtl8723a_BT_using_antenna_1(padapter)) {
-				if (check_fwstate(pmlmepriv, _FW_LINKED))
-					LPS_Leave23a(padapter);
-			}
-			break;
-		case LPS_CTRL_JOINBSS:
+	switch (lps_ctrl_type) {
+	case LPS_CTRL_SCAN:
+		rtl8723a_BT_wifiscan_notify(padapter, true);
+		if (!rtl8723a_BT_using_antenna_1(padapter)) {
+			if (check_fwstate(pmlmepriv, _FW_LINKED))
 			LPS_Leave23a(padapter);
-			break;
-		case LPS_CTRL_CONNECT:
-			mstatus = 1;/* connect */
-			/*  Reset LPS Setting */
-			padapter->pwrctrlpriv.LpsIdleCount = 0;
-			rtl8723a_set_FwJoinBssReport_cmd(padapter, 1);
-			rtl8723a_BT_mediastatus_notify(padapter, mstatus);
-			break;
-		case LPS_CTRL_DISCONNECT:
-			mstatus = 0;/* disconnect */
-			rtl8723a_BT_mediastatus_notify(padapter, mstatus);
-			if (!rtl8723a_BT_using_antenna_1(padapter))
-				LPS_Leave23a(padapter);
-			rtl8723a_set_FwJoinBssReport_cmd(padapter, 0);
-			break;
-		case LPS_CTRL_SPECIAL_PACKET:
-			pwrpriv->DelayLPSLastTimeStamp = jiffies;
-			rtl8723a_BT_specialpacket_notify(padapter);
-			if (!rtl8723a_BT_using_antenna_1(padapter))
-				LPS_Leave23a(padapter);
-			break;
-		case LPS_CTRL_LEAVE:
-			rtl8723a_BT_lps_leave(padapter);
-			if (!rtl8723a_BT_using_antenna_1(padapter))
-				LPS_Leave23a(padapter);
-			break;
-
-		default:
-			break;
+		}
+		break;
+	case LPS_CTRL_JOINBSS:
+		LPS_Leave23a(padapter);
+		break;
+	case LPS_CTRL_CONNECT:
+		mstatus = 1;/* connect */
+		/*  Reset LPS Setting */
+		padapter->pwrctrlpriv.LpsIdleCount = 0;
+		rtl8723a_set_FwJoinBssReport_cmd(padapter, 1);
+		rtl8723a_BT_mediastatus_notify(padapter, mstatus);
+		break;
+	case LPS_CTRL_DISCONNECT:
+		mstatus = 0;/* disconnect */
+		rtl8723a_BT_mediastatus_notify(padapter, mstatus);
+		if (!rtl8723a_BT_using_antenna_1(padapter))
+			LPS_Leave23a(padapter);
+		rtl8723a_set_FwJoinBssReport_cmd(padapter, 0);
+		break;
+	case LPS_CTRL_SPECIAL_PACKET:
+		pwrpriv->DelayLPSLastTimeStamp = jiffies;
+		rtl8723a_BT_specialpacket_notify(padapter);
+		if (!rtl8723a_BT_using_antenna_1(padapter))
+			LPS_Leave23a(padapter);
+		break;
+	case LPS_CTRL_LEAVE:
+		rtl8723a_BT_lps_leave(padapter);
+		if (!rtl8723a_BT_using_antenna_1(padapter))
+			LPS_Leave23a(padapter);
+		break;
+	default:
+		break;
 	}
 }
 
@@ -1152,7 +1151,7 @@ static void rtw_chk_hi_queue_hdl(struct rtw_adapter *padapter)
 
 			cnt++;
 
-			if (cnt>10)
+			if (cnt > 10)
 				break;
 
 			val = rtl8723a_chk_hi_queue_empty(padapter);
@@ -1305,8 +1304,7 @@ int rtw_drvextra_cmd_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 
 	pdrvextra_cmd = (struct drvextra_cmd_parm *)pbuf;
 
-	switch (pdrvextra_cmd->ec_id)
-	{
+	switch (pdrvextra_cmd->ec_id) {
 	case DYNAMIC_CHK_WK_CID:
 		dynamic_chk_wk_hdl(padapter, pdrvextra_cmd->pbuf,
 				   pdrvextra_cmd->type_size);
-- 
1.7.11.7

