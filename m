Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaJ0H7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:59:18 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:51238 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0H7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:59:16 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <Larry.Finger@lwfinger.net>, <Jes.Sorensen@redhat.com>
CC: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.
Date: Mon, 27 Oct 2014 13:29:05 +0530
Message-ID: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rtw_cmd.c file that fixes
Error reported by checkpatch.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c | 83 +++++++++++++++-----------------
 1 file changed, 40 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 4eaa502..c1f6254 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -957,7 +957,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 		/*  check traffic for  powersaving. */
 			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
 			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
-			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
+			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
 				bEnterPS = false;
 			else
 				bEnterPS = true;
@@ -1017,46 +1017,44 @@ static void lps_ctrl_wk_hdl(struct rtw_adapter *padapter, u8 lps_ctrl_type)
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
 
@@ -1152,7 +1150,7 @@ static void rtw_chk_hi_queue_hdl(struct rtw_adapter *padapter)
 
 			cnt++;
 
-			if (cnt>10)
+			if (cnt > 10)
 				break;
 
 			val = rtl8723a_chk_hi_queue_empty(padapter);
@@ -1305,8 +1303,7 @@ int rtw_drvextra_cmd_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 
 	pdrvextra_cmd = (struct drvextra_cmd_parm *)pbuf;
 
-	switch (pdrvextra_cmd->ec_id)
-	{
+	switch (pdrvextra_cmd->ec_id) {
 	case DYNAMIC_CHK_WK_CID:
 		dynamic_chk_wk_hdl(padapter, pdrvextra_cmd->pbuf,
 				   pdrvextra_cmd->type_size);
-- 
1.7.11.7

