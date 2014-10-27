Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaJ0HMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:12:17 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48244 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaJ0HMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:12:16 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg Donald <gdonald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ana Rey <anarey@gmail.com>,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>,
        Chaitanya Hazarey <c@24.io>,
        "Roxana Blaj" <roxanagabriela10@gmail.com>,
        Antoine Schweitzer-Chaput <antoine@schweitzer-chaput.fr>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers: staging: rtl8192u: Fix "space prohibited after
 that open parenthesis '('" errors
Thread-Topic: [PATCH] drivers: staging: rtl8192u: Fix "space prohibited
 after that open parenthesis '('" errors
Thread-Index: AQHP8VqDb+ujp4JejkOG3QeC2mb60JxDh3Xw
Date: Mon, 27 Oct 2014 07:12:11 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE950E879E5@EU-MBX-02.mgc.mentorg.com>
References: <1414354762-12715-1-git-send-email-gdonald@gmail.com>
In-Reply-To: <1414354762-12715-1-git-send-email-gdonald@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look ok.

Regards
Sanjeev Sharma

-----Original Message-----
From: Greg Donald [mailto:gdonald@gmail.com] 
Sent: Monday, October 27, 2014 1:49 AM
To: Greg Kroah-Hartman; Ana Rey; Peter P Waskiewicz Jr; Chaitanya Hazarey; Sharma, Sanjeev; Roxana Blaj; Antoine Schweitzer-Chaput; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Cc: Greg Donald
Subject: [PATCH] drivers: staging: rtl8192u: Fix "space prohibited after that open parenthesis '('" errors

Fix checkpatch.pl "space prohibited after that open parenthesis '('" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  | 22 +++++++++-------------  .../staging/rtl8192u/ieee80211/ieee80211_softmac.c | 11 ++++-------
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |  2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |  3 +--
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    | 16 ++++++----------
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    | 11 ++++-------
 6 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 73de9e9..d401dbf 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -713,8 +713,8 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 	while(!list_empty(&pTS->RxPendingPktList)) {
 		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): start RREORDER indicate\n",__func__);
 		pReorderEntry = (PRX_REORDER_ENTRY)list_entry(pTS->RxPendingPktList.prev,RX_REORDER_ENTRY,List);
-		if( SN_LESS(pReorderEntry->SeqNum, pTS->RxIndicateSeq) ||
-				SN_EQUAL(pReorderEntry->SeqNum, pTS->RxIndicateSeq))
+		if (SN_LESS(pReorderEntry->SeqNum, pTS->RxIndicateSeq) ||
+		    SN_EQUAL(pReorderEntry->SeqNum, pTS->RxIndicateSeq))
 		{
 			/* This protect buffer from overflow. */
 			if(index >= REORDER_WIN_SIZE) {
@@ -800,9 +800,8 @@ static u8 parse_subframe(struct sk_buff *skb,
 	// Null packet, don't indicate it to upper layer
 	ChkLength = LLCOffset;/* + (Frame_WEP(frame)!=0 ?Adapter->MgntInfo.SecurityInfo.EncryptionHeadOverhead:0);*/
 
-	if( skb->len <= ChkLength ) {
+	if (skb->len <= ChkLength)
 		return 0;
-	}
 
 	skb_pull(skb, LLCOffset);
 
@@ -1035,10 +1034,9 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		{
 
 		//	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): pRxTS->RxLastFragNum is %d,frag is %d,pRxTS->RxLastSeqNum is %d,seq is %d\n",__func__,pRxTS->RxLastFragNum,frag,pRxTS->RxLastSeqNum,WLAN_GET_SEQ_SEQ(sc));
-			if(	(fc & (1<<11))  &&
-					(frag == pRxTS->RxLastFragNum) &&
-					(WLAN_GET_SEQ_SEQ(sc) == pRxTS->RxLastSeqNum)	)
-			{
+			if ((fc & (1<<11)) &&
+			    (frag == pRxTS->RxLastFragNum) &&
+			    (WLAN_GET_SEQ_SEQ(sc) == pRxTS->RxLastSeqNum)) {
 				goto rx_dropped;
 			}
 			else
@@ -2456,7 +2454,7 @@ static inline void ieee80211_process_probe_response(
 	//       then wireless adapter should do active scan from ch1~11 and
 	//       passive scan from ch12~14
 
-	if( !IsLegalChannel(ieee, network.channel) )
+	if (!IsLegalChannel(ieee, network.channel))
 		return;
 	if(ieee->bGlobalDomain)
 	{
@@ -2465,8 +2463,7 @@ static inline void ieee80211_process_probe_response(
 			// Case 1: Country code
 			if(IS_COUNTRY_IE_VALID(ieee) )
 			{
-				if( !IsLegalChannel(ieee, network.channel) )
-				{
+				if (!IsLegalChannel(ieee, network.channel)) {
 					printk("GetScanInfo(): For Country code, filter probe response at channel(%d).\n", network.channel);
 					return;
 				}
@@ -2487,8 +2484,7 @@ static inline void ieee80211_process_probe_response(
 			// Case 1: Country code
 			if(IS_COUNTRY_IE_VALID(ieee) )
 			{
-				if( !IsLegalChannel(ieee, network.channel) )
-				{
+				if (!IsLegalChannel(ieee, network.channel)) {
 					printk("GetScanInfo(): For Country code, filter beacon at channel(%d).\n",network.channel);
 					return;
 				}
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index a1c745b..9b87408 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1043,10 +1043,9 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 	{
 		ccxrm_ie_len = 6+2;
 	}
-	if( beacon->BssCcxVerNumber >= 2 )
-	{
+	if (beacon->BssCcxVerNumber >= 2)
 		cxvernum_ie_len = 5+2;
-	}
+
 #ifdef THOMAS_TURBO
 	len = sizeof(struct ieee80211_assoc_request_frame)+ 2
 		+ beacon->ssid_len//essid tagged val
@@ -1118,8 +1117,7 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 	ieee80211_MFIE_Brate(ieee, &tag);
 	ieee80211_MFIE_Grate(ieee, &tag);
 	// For CCX 1 S13, CKIP. Added by Annie, 2006-08-14.
-	if( beacon->bCkipSupported )
-	{
+	if (beacon->bCkipSupported) {
 		static u8	AironetIeOui[] = {0x00, 0x01, 0x66}; // "4500-client"
 		u8	CcxAironetBuf[30];
 		OCTET_STRING	osCcxAironetIE;
@@ -1158,8 +1156,7 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 		tag += osCcxRmCap.Length;
 	}
 
-	if( beacon->BssCcxVerNumber >= 2 )
-	{
+	if (beacon->BssCcxVerNumber >= 2) {
 		u8			CcxVerNumBuf[] = {0x00, 0x40, 0x96, 0x03, 0x00};
 		OCTET_STRING	osCcxVerNum;
 		CcxVerNumBuf[4] = beacon->BssCcxVerNumber; diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 82ea533..644368d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -374,7 +374,7 @@ int ieee80211_wx_set_scan(struct ieee80211_device *ieee, struct iw_request_info
 		goto out;
 	}
 
-	if ( ieee->state == IEEE80211_LINKED){
+	if (ieee->state == IEEE80211_LINKED) {
 		queue_work(ieee->wq, &ieee->wx_sync_scan_wq);
 		/* intentionally forget to up sem */
 		return 0;
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 57bef21..fca73c7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -529,8 +529,7 @@ static void ieee80211_query_protectionmode(struct ieee80211_device *ieee,
 		}
 		}
 	// For test , CTS replace with RTS
-	if( 0 )
-	{
+	if (0) {
 		tcb_desc->bCTSEnable	= true;
 		tcb_desc->rts_rate = MGN_24M;
 		tcb_desc->bRTSEnable	= true;
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
index 51552d4..278eb54 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -342,8 +342,7 @@ int ieee80211_rx_ADDBAReq(struct ieee80211_device *ieee, struct sk_buff *skb)
 	PSEQUENCE_CONTROL pBaStartSeqCtrl = NULL;
 	PRX_TS_RECORD	pTS = NULL;
 
-	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
-	{
+	if (skb->len < sizeof(struct ieee80211_hdr_3addr) + 9) {
 		IEEE80211_DEBUG(IEEE80211_DL_ERR,
 				" Invalid skb len in BAREQ(%d / %zu)\n",
 				skb->len,
@@ -444,8 +443,7 @@ int ieee80211_rx_ADDBARsp(struct ieee80211_device *ieee, struct sk_buff *skb)
 	PBA_PARAM_SET		pBaParamSet = NULL;
 	u16			ReasonCode;
 
-	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
-	{
+	if (skb->len < sizeof(struct ieee80211_hdr_3addr) + 9) {
 		IEEE80211_DEBUG(IEEE80211_DL_ERR,
 				" Invalid skb len in BARSP(%d / %zu)\n",
 				skb->len,
@@ -463,10 +461,9 @@ int ieee80211_rx_ADDBARsp(struct ieee80211_device *ieee, struct sk_buff *skb)
 
 	// Check the capability
 	// Since we can always receive A-MPDU, we just check if it is under HT mode.
-	if(     ieee->current_network.qos_data.active == 0  ||
-		ieee->pHTInfo->bCurrentHTSupport == false ||
-		ieee->pHTInfo->bCurrentAMPDUEnable == false )
-	{
+	if (ieee->current_network.qos_data.active == 0  ||
+	    ieee->pHTInfo->bCurrentHTSupport == false ||
+	    ieee->pHTInfo->bCurrentAMPDUEnable == false) {
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "reject to ADDBA_RSP as some capability is not ready(%d, %d, %d)\n",ieee->current_network.qos_data.active, ieee->pHTInfo->bCurrentHTSupport, ieee->pHTInfo->bCurrentAMPDUEnable);
 		ReasonCode = DELBA_REASON_UNKNOWN_BA;
 		goto OnADDBARsp_Reject;
@@ -577,8 +574,7 @@ int ieee80211_rx_DELBA(struct ieee80211_device *ieee, struct sk_buff *skb)
 	u16			*pReasonCode = NULL;
 	u8			*dst = NULL;
 
-	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 6)
-	{
+	if (skb->len < sizeof(struct ieee80211_hdr_3addr) + 6) {
 		IEEE80211_DEBUG(IEEE80211_DL_ERR,
 				" Invalid skb len in DELBA(%d / %zu)\n",
 				skb->len,
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 1ea2cd3..e60d926 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -602,8 +602,7 @@ void HTConstructCapabilityElement(struct ieee80211_device *ieee, u8 *posHTCap, u
 	// TODO: Nedd to take care of this part
 	IEEE80211_DEBUG(IEEE80211_DL_HT, "TX HT cap/info ele BW=%d MaxAMSDUSize:%d DssCCk:%d\n", pCapELE->ChlWidth, pCapELE->MaxAMSDUSize, pCapELE->DssCCk);
 
-	if( IsEncrypt)
-	{
+	if (IsEncrypt) {
 		pCapELE->MPDUDensity	= 7; // 8us
 		pCapELE->MaxRxAMPDUFactor	= 2; // 2 is for 32 K and 3 is 64K
 	}
@@ -951,8 +950,7 @@ void HTOnAssocRsp(struct ieee80211_device *ieee)
 	static u8				EWC11NHTCap[] = {0x00, 0x90, 0x4c, 0x33};		// For 11n EWC definition, 2007.07.17, by Emily
 	static u8				EWC11NHTInfo[] = {0x00, 0x90, 0x4c, 0x34};	// For 11n EWC definition, 2007.07.17, by Emily
 
-	if( pHTInfo->bCurrentHTSupport == false )
-	{
+	if (pHTInfo->bCurrentHTSupport == false) {
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "<=== HTOnAssocRsp(): HT_DISABLE\n");
 		return;
 	}
@@ -1043,7 +1041,7 @@ void HTOnAssocRsp(struct ieee80211_device *ieee)
 		// Replace MPDU factor declared in original association response frame format. 2007.08.20 by Emily
 		if (ieee->current_network.bssht.bdRT2RTAggregation)
 		{
-			if( ieee->pairwise_key_type != KEY_TYPE_NA)
+			if (ieee->pairwise_key_type != KEY_TYPE_NA)
 				// Realtek may set 32k in security mode and 64k for others
 				pHTInfo->CurrentAMPDUFactor = pPeerHTCap->MaxRxAMPDUFactor;
 			else
@@ -1332,8 +1330,7 @@ u8 HTCCheck(struct ieee80211_device *ieee, u8 *pFrame)  {
 	if(ieee->pHTInfo->bCurrentHTSupport)
 	{
-		if( (IsQoSDataFrame(pFrame) && Frame_Order(pFrame)) == 1)
-		{
+		if ((IsQoSDataFrame(pFrame) && Frame_Order(pFrame)) == 1) {
 			IEEE80211_DEBUG(IEEE80211_DL_HT, "HT CONTROL FILED EXIST!!\n");
 			return true;
 		}
--
1.9.1

