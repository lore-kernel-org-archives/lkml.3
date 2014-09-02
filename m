Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaIBXak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:30:40 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:47604 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaIBXai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:30:38 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, Ana Rey <anarey@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Chaitanya Hazarey <c@24.io>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8192u: Fix "space prohibited after that open parenthesis '('" errors
Date: Tue,  2 Sep 2014 18:30:30 -0500
Message-Id: <1409700630-27078-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "space prohibited after that open parenthesis '('" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     | 18 +++++++-----
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |  4 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |  2 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    | 33 ++++++++++++++--------
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |  4 +--
 5 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 125c5ab..555b8ea 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2539,18 +2539,22 @@ extern u8 HTCCheck(struct ieee80211_device *ieee, u8 *pFrame);
 extern void HTResetIOTSetting(PRT_HIGH_THROUGHPUT  pHTInfo);
 extern bool IsHTHalfNmodeAPs(struct ieee80211_device *ieee);
 extern u16 HTHalfMcsToDataRate(struct ieee80211_device *ieee,  u8      nMcsRate);
-extern u16 HTMcsToDataRate( struct ieee80211_device *ieee, u8 nMcsRate);
-extern u16  TxCountToDataRate( struct ieee80211_device *ieee, u8 nDataRate);
+extern u16 HTMcsToDataRate(struct ieee80211_device *ieee, u8 nMcsRate);
+extern u16  TxCountToDataRate(struct ieee80211_device *ieee, u8 nDataRate);
 //function in BAPROC.c
-extern int ieee80211_rx_ADDBAReq( struct ieee80211_device *ieee, struct sk_buff *skb);
-extern int ieee80211_rx_ADDBARsp( struct ieee80211_device *ieee, struct sk_buff *skb);
+extern int ieee80211_rx_ADDBAReq(struct ieee80211_device *ieee,
+				 struct sk_buff *skb);
+extern int ieee80211_rx_ADDBARsp(struct ieee80211_device *ieee,
+				 struct sk_buff *skb);
 extern int ieee80211_rx_DELBA(struct ieee80211_device *ieee,struct sk_buff *skb);
-extern void TsInitAddBA( struct ieee80211_device *ieee, PTX_TS_RECORD   pTS, u8 Policy, u8 bOverwritePending);
-extern void TsInitDelBA( struct ieee80211_device *ieee, PTS_COMMON_INFO pTsCommonInfo, TR_SELECT TxRxSelect);
+extern void TsInitAddBA(struct ieee80211_device *ieee, PTX_TS_RECORD pTS,
+			u8 Policy, u8 bOverwritePending);
+extern void TsInitDelBA(struct ieee80211_device *ieee,
+			PTS_COMMON_INFO pTsCommonInfo, TR_SELECT TxRxSelect);
 extern void BaSetupTimeOut(unsigned long data);
 extern void TxBaInactTimeout(unsigned long data);
 extern void RxBaInactTimeout(unsigned long data);
-extern void ResetBaEntry( PBA_RECORD pBA);
+extern void ResetBaEntry(PBA_RECORD pBA);
 //function in TS.c
 extern bool GetTs(
 	struct ieee80211_device		*ieee,
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 0841239..9539bca 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -877,7 +877,7 @@ static struct sk_buff *ieee80211_assoc_resp(struct ieee80211_device *ieee,
 		crypt = ieee->crypt[ieee->tx_keyidx];
 	else crypt = NULL;
 
-	encrypt = ( crypt && crypt->ops);
+	encrypt = (crypt && crypt->ops);
 
 	if (encrypt)
 		assoc->capability |= cpu_to_le16(WLAN_CAPABILITY_PRIVACY);
@@ -1451,7 +1451,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 			 * if the network does broadcast and the user does not set essid it is OK
 			 * if the network does broadcast and the user did set essid chech if essid match
 			 */
-			( apset && apmatch &&
+			(apset && apmatch &&
 				((ssidset && ssidbroad && ssidmatch) || (ssidbroad && !ssidset) || (!ssidbroad && ssidset)) ) ||
 			/* if the ap is not set, check that the user set the bssid
 			 * and the network does broadcast and that those two bssid matches
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 7f9e655f..57bef21 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -876,7 +876,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (is_broadcast_ether_addr(header.addr1))
 			tcb_desc->bBroadcast = 1;
 		ieee80211_txrate_selectmode(ieee, tcb_desc);
-		if ( tcb_desc->bMulticast ||  tcb_desc->bBroadcast)
+		if (tcb_desc->bMulticast ||  tcb_desc->bBroadcast)
 			tcb_desc->data_rate = ieee->basic_rate;
 		else
 			//tcb_desc->data_rate = CURRENT_RATE(ieee->current_network.mode, ieee->rate, ieee->HTCurrentOperaRate);
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
index cb66bb9..51552d4 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -87,7 +87,7 @@ static u8 RxTsDeleteBA(struct ieee80211_device *ieee, PRX_TS_RECORD pRxTs)
  *	     PBA_RECORD		pBA //entry to be reset
  *  output:  none
 ********************************************************************************************************************/
-void ResetBaEntry( PBA_RECORD pBA)
+void ResetBaEntry(PBA_RECORD pBA)
 {
 	pBA->bValid			= false;
 	pBA->BaParamSet.shortData	= 0;
@@ -331,7 +331,7 @@ static void ieee80211_send_DELBA(struct ieee80211_device *ieee, u8 *dst,
  *  return:  0(pass), other(fail)
  *  notice:  As this function need support of QOS, I comment some code out. And when qos is ready, this code need to be support.
 ********************************************************************************************************************/
-int ieee80211_rx_ADDBAReq( struct ieee80211_device *ieee, struct sk_buff *skb)
+int ieee80211_rx_ADDBAReq(struct ieee80211_device *ieee, struct sk_buff *skb)
 {
 	 struct ieee80211_hdr_3addr *req = NULL;
 	u16 rc = 0;
@@ -344,16 +344,19 @@ int ieee80211_rx_ADDBAReq( struct ieee80211_device *ieee, struct sk_buff *skb)
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %zu)\n", skb->len,	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR,
+				" Invalid skb len in BAREQ(%d / %zu)\n",
+				skb->len,
+				(sizeof(struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 
 	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA|IEEE80211_DL_BA, skb->data, skb->len);
 
-	req = ( struct ieee80211_hdr_3addr *) skb->data;
+	req = (struct ieee80211_hdr_3addr *) skb->data;
 	tag = (u8 *)req;
 	dst = (u8 *)(&req->addr2[0]);
-	tag += sizeof( struct ieee80211_hdr_3addr);
+	tag += sizeof(struct ieee80211_hdr_3addr);
 	pDialogToken = tag + 2;  //category+action
 	pBaParamSet = (PBA_PARAM_SET)(tag + 3);   //+DialogToken
 	pBaTimeoutVal = (u16 *)(tag + 5);
@@ -431,7 +434,7 @@ OnADDBAReq_Fail:
  *  return:  0(pass), other(fail)
  *  notice:  As this function need support of QOS, I comment some code out. And when qos is ready, this code need to be support.
 ********************************************************************************************************************/
-int ieee80211_rx_ADDBARsp( struct ieee80211_device *ieee, struct sk_buff *skb)
+int ieee80211_rx_ADDBARsp(struct ieee80211_device *ieee, struct sk_buff *skb)
 {
 	 struct ieee80211_hdr_3addr *rsp = NULL;
 	PBA_RECORD		pPendingBA, pAdmittedBA;
@@ -443,13 +446,16 @@ int ieee80211_rx_ADDBARsp( struct ieee80211_device *ieee, struct sk_buff *skb)
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %zu)\n", skb->len,	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR,
+				" Invalid skb len in BARSP(%d / %zu)\n",
+				skb->len,
+				(sizeof(struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
-	rsp = ( struct ieee80211_hdr_3addr *)skb->data;
+	rsp = (struct ieee80211_hdr_3addr *)skb->data;
 	tag = (u8 *)rsp;
 	dst = (u8 *)(&rsp->addr2[0]);
-	tag += sizeof( struct ieee80211_hdr_3addr);
+	tag += sizeof(struct ieee80211_hdr_3addr);
 	pDialogToken = tag + 2;
 	pStatusCode = (u16 *)(tag + 3);
 	pBaParamSet = (PBA_PARAM_SET)(tag + 5);
@@ -573,7 +579,10 @@ int ieee80211_rx_DELBA(struct ieee80211_device *ieee, struct sk_buff *skb)
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 6)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %zu)\n", skb->len,	(sizeof( struct ieee80211_hdr_3addr) + 6));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR,
+				" Invalid skb len in DELBA(%d / %zu)\n",
+				skb->len,
+				(sizeof(struct ieee80211_hdr_3addr) + 6));
 		return -1;
 	}
 
@@ -585,9 +594,9 @@ int ieee80211_rx_DELBA(struct ieee80211_device *ieee, struct sk_buff *skb)
 	}
 
 	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA|IEEE80211_DL_BA, skb->data, skb->len);
-	delba = ( struct ieee80211_hdr_3addr *)skb->data;
+	delba = (struct ieee80211_hdr_3addr *)skb->data;
 	dst = (u8 *)(&delba->addr2[0]);
-	delba += sizeof( struct ieee80211_hdr_3addr);
+	delba += sizeof(struct ieee80211_hdr_3addr);
 	pDelBaParamSet = (PDELBA_PARAM_SET)(delba+2);
 	pReasonCode = (u16 *)(delba+4);
 
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 2694a08..1ea2cd3 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -278,7 +278,7 @@ u16 HTHalfMcsToDataRate(struct ieee80211_device *ieee,	u8	nMcsRate)
 }
 
 
-u16 HTMcsToDataRate( struct ieee80211_device *ieee, u8 nMcsRate)
+u16 HTMcsToDataRate(struct ieee80211_device *ieee, u8 nMcsRate)
 {
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
 
@@ -297,7 +297,7 @@ u16 HTMcsToDataRate( struct ieee80211_device *ieee, u8 nMcsRate)
  *  return:  tx rate
  *  notice:  quite unsure about how to use this function //wb
  * *****************************************************************************************************************/
-u16  TxCountToDataRate( struct ieee80211_device *ieee, u8 nDataRate)
+u16  TxCountToDataRate(struct ieee80211_device *ieee, u8 nDataRate)
 {
 	//PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
 	u16		CCKOFDMRate[12] = {0x02 , 0x04 , 0x0b , 0x16 , 0x0c , 0x12 , 0x18 , 0x24 , 0x30 , 0x48 , 0x60 , 0x6c};
-- 
1.9.1

