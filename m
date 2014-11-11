Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaKKJ60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:58:26 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:60976 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaKKJ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:58:24 -0500
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <Larry.Finger@lwfinger.net>, <Jes.Sorensen@redhat.com>
CC: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] staging:rtl8723au: core: Fix checkpatch warning
Date: Tue, 11 Nov 2014 15:28:14 +0530
Message-ID: <1415699894-20243-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <wrfjy4rxzk5b.fsf@redhat.com>
References: <wrfjy4rxzk5b.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rtw_cmd.c file that fixes following
Warning by introducing temporary structure.

WARNING: line over 80 characters

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c | 42 ++++++++++++++++----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index cd2e915..6eccd86 100644
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
-			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
+			if (((ldi->NumRxUnicastOkInPeriod +
+			      ldi->NumTxOkInPeriod) > 8) ||
+			    ldi->NumRxUnicastOkInPeriod > 2)
 				bEnterPS = false;
 			else
 				bEnterPS = true;
@@ -971,15 +971,15 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 	} else
 		LPS_Leave23a(padapter);
 
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
-- 
1.7.11.7

