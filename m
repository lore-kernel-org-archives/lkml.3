Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbaEXFN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 01:13:29 -0400
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:36872 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750751AbaEXFN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 01:13:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:69:327:355:379:541:960:966:968:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2729:2828:2898:2910:3138:3139:3140:3141:3142:3865:3867:3868:3870:3871:3872:4225:4250:4321:4385:4605:5007:7652:7875:7903:8829:8957:9010:9391:10848:11026:11232:11233:11657:11914:12043:12291:12294:12296:12438:12517:12519:12555:12740:13138:13231:13868:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,
X-HE-Tag: name79_3a9aedff8fe23
X-Filterd-Recvd-Size: 49941
Message-ID: <1400908400.10357.4.camel@joe-AO725>
Subject: [PATCH] staging: Convert __FUNCTION__ to __func__
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Cho <acho@novell.com>, Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb <linux-usb@vger.kernel.org>
Date: Fri, 23 May 2014 22:13:20 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal mechanism for emitting a function name.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/bcm/Qos.c                          | 14 ++++-----
 drivers/staging/keucr/scsiglue.c                   |  2 +-
 drivers/staging/octeon-usb/octeon-hcd.c            |  2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |  2 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |  2 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |  2 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |  2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  | 34 +++++++++++-----------
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c | 10 +++----
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |  2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |  2 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    | 22 +++++++-------
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    | 10 +++----
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    | 10 +++----
 drivers/staging/rtl8192u/r8192U_dm.c               | 12 ++++----
 drivers/staging/rtl8192u/r8192U_wx.c               | 12 ++++----
 drivers/staging/rtl8192u/r819xU_firmware.c         |  6 ++--
 drivers/staging/rtl8723au/hal/hal_com.c            |  4 +--
 drivers/staging/rtl8723au/hal/odm.c                |  4 +--
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c       | 24 +++++++--------
 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c    |  2 +-
 drivers/staging/rtl8723au/hal/rtl8723au_recv.c     |  2 +-
 drivers/staging/rtl8723au/hal/usb_ops_linux.c      | 16 +++++-----
 .../rtl8723au/include/rtl8723a_bt-coexist.h        |  2 +-
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |  4 +--
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  2 +-
 26 files changed, 103 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 64ae92b..0c742da 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -591,7 +591,7 @@ static bool EthCSMatchSrcMACAddress(struct bcm_classifier_rule *pstClassifierRul
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	if (pstClassifierRule->ucEthCSSrcMACLen == 0)
 		return TRUE;
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s\n", __FUNCTION__);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s\n", __func__);
 	for (i = 0; i < MAC_ADDRESS_SIZE; i++) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n", i, Mac[i], pstClassifierRule->au8EThCSSrcMAC[i], pstClassifierRule->au8EThCSSrcMACMask[i]);
 		if ((pstClassifierRule->au8EThCSSrcMAC[i] & pstClassifierRule->au8EThCSSrcMACMask[i]) !=
@@ -607,7 +607,7 @@ static bool EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRu
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	if (pstClassifierRule->ucEthCSDestMACLen == 0)
 		return TRUE;
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "%s\n", __FUNCTION__);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "%s\n", __func__);
 	for (i = 0; i < MAC_ADDRESS_SIZE; i++) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n", i, Mac[i], pstClassifierRule->au8EThCSDestMAC[i], pstClassifierRule->au8EThCSDestMACMask[i]);
 		if ((pstClassifierRule->au8EThCSDestMAC[i] & pstClassifierRule->au8EThCSDestMACMask[i]) !=
@@ -624,9 +624,9 @@ static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule,
 		(pstClassifierRule->au8EthCSEtherType[0] == 0))
 		return TRUE;
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s SrcEtherType:%x CLS EtherType[0]:%x\n", __FUNCTION__, pstEthCsPktInfo->usEtherType, pstClassifierRule->au8EthCSEtherType[0]);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s SrcEtherType:%x CLS EtherType[0]:%x\n", __func__, pstEthCsPktInfo->usEtherType, pstClassifierRule->au8EthCSEtherType[0]);
 	if (pstClassifierRule->au8EthCSEtherType[0] == 1) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS EtherType[1]:%x EtherType[2]:%x\n", __FUNCTION__, pstClassifierRule->au8EthCSEtherType[1], pstClassifierRule->au8EthCSEtherType[2]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS EtherType[1]:%x EtherType[2]:%x\n", __func__, pstClassifierRule->au8EthCSEtherType[1], pstClassifierRule->au8EthCSEtherType[2]);
 
 		if (memcmp(&pstEthCsPktInfo->usEtherType, &pstClassifierRule->au8EthCSEtherType[1], 2) == 0)
 			return TRUE;
@@ -638,7 +638,7 @@ static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule,
 		if (eEth802LLCFrame != pstEthCsPktInfo->eNwpktEthFrameType)
 			return false;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  EthCS DSAP:%x EtherType[2]:%x\n", __FUNCTION__, pstEthCsPktInfo->ucDSAP, pstClassifierRule->au8EthCSEtherType[2]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  EthCS DSAP:%x EtherType[2]:%x\n", __func__, pstEthCsPktInfo->ucDSAP, pstClassifierRule->au8EthCSEtherType[2]);
 		if (pstEthCsPktInfo->ucDSAP == pstClassifierRule->au8EthCSEtherType[2])
 			return TRUE;
 		else
@@ -657,7 +657,7 @@ static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, s
 	B_UINT8 uPriority = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n", __FUNCTION__, ntohs(*((USHORT *)pstClassifierRule->usUserPriority)), pstClassifierRule->usVLANID);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n", __func__, ntohs(*((USHORT *)pstClassifierRule->usUserPriority)), pstClassifierRule->usVLANID);
 
 	/* In case FW didn't receive the TLV, the priority field should be ignored */
 	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID)) {
@@ -683,7 +683,7 @@ static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, s
 
 		usVLANID = ntohs(*(USHORT *)(skb->data + sizeof(struct bcm_eth_header))) & 0xFFF;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  Pkt VLANID %x Priority: %d\n", __FUNCTION__, usVLANID, uPriority);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  Pkt VLANID %x Priority: %d\n", __func__, usVLANID, uPriority);
 
 		if (usVLANID == ((pstClassifierRule->usVLANID & 0xFFF0) >> 4))
 			bClassificationSucceed = TRUE;
diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index ac3d34d..7d8d444 100644
--- a/drivers/staging/keucr/scsiglue.c
+++ b/drivers/staging/keucr/scsiglue.c
@@ -106,7 +106,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	/* check for state-transition errors */
 	if (us->srb != NULL) {
 		/* pr_info("Error in %s: us->srb = %p\n"
-				 __FUNCTION__, us->srb); */
+				 __func__, us->srb); */
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 8b8ce72..65ee7de 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -1536,7 +1536,7 @@ static void __cvmx_usb_start_channel_control(struct cvmx_usb_state *usb,
 	switch (transaction->stage) {
 	case CVMX_USB_STAGE_NON_CONTROL:
 	case CVMX_USB_STAGE_NON_CONTROL_SPLIT_COMPLETE:
-		cvmx_dprintf("%s: ERROR - Non control stage\n", __FUNCTION__);
+		cvmx_dprintf("%s: ERROR - Non control stage\n", __func__);
 		break;
 	case CVMX_USB_STAGE_SETUP:
 		usbc_hctsiz.s.pid = 3; /* Setup */
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index cac2056..68729c1 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -539,7 +539,7 @@ do { if (ieee80211_debug_level & (level)) \
 		{	\
 			int i;					\
 			u8 *pdata = (u8 *) data;			\
-			printk(KERN_DEBUG "ieee80211: %s()\n", __FUNCTION__);	\
+			printk(KERN_DEBUG "ieee80211: %s()\n", __func__);	\
 			for(i=0; i<(int)(datalen); i++)			\
 			{						\
 				printk("%2x ", pdata[i]);		\
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
index f2b1677..af2128b 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
@@ -444,7 +444,7 @@ static char *ieee80211_ccmp_print_stats(char *p, void *priv)
 
 void ieee80211_ccmp_null(void)
 {
-//    printk("============>%s()\n", __FUNCTION__);
+//    printk("============>%s()\n", __func__);
 	return;
 }
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index 93121b4..fcc90a5 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -773,6 +773,6 @@ void __exit ieee80211_crypto_tkip_exit(void)
 
 void ieee80211_tkip_null(void)
 {
-//    printk("============>%s()\n", __FUNCTION__);
+//    printk("============>%s()\n", __func__);
 	return;
 }
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
index f202236..8c1bf1f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
@@ -290,6 +290,6 @@ void __exit ieee80211_crypto_wep_exit(void)
 
 void ieee80211_wep_null(void)
 {
-//	printk("============>%s()\n", __FUNCTION__);
+//	printk("============>%s()\n", __func__);
 	return;
 }
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index a98414a..5a366fe 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -549,7 +549,7 @@ void ieee80211_indicate_packets(struct ieee80211_device *ieee, struct ieee80211_
 	u8 i = 0 , j=0;
 	u16 ethertype;
 //	if(index > 1)
-//		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): hahahahhhh, We indicate packet from reorder list, index is %u\n",__FUNCTION__,index);
+//		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): hahahahhhh, We indicate packet from reorder list, index is %u\n",__func__,index);
 	for(j = 0; j<index; j++)
 	{
 //added by amy for reorder
@@ -609,7 +609,7 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 	u16			WinEnd = (pTS->RxIndicateSeq + WinSize -1)%4096;
 	u8			index = 0;
 	bool			bMatchWinStart = false, bPktInBuf = false;
-	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): Seq is %d,pTS->RxIndicateSeq is %d, WinSize is %d\n",__FUNCTION__,SeqNum,pTS->RxIndicateSeq,WinSize);
+	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): Seq is %d,pTS->RxIndicateSeq is %d, WinSize is %d\n",__func__,SeqNum,pTS->RxIndicateSeq,WinSize);
 	/* Rx Reorder initialize condition.*/
 	if(pTS->RxIndicateSeq == 0xffff) {
 		pTS->RxIndicateSeq = SeqNum;
@@ -662,11 +662,11 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 		IEEE80211_DEBUG(IEEE80211_DL_REORDER, "Packets indication!! IndicateSeq: %d, NewSeq: %d\n",\
 				pTS->RxIndicateSeq, SeqNum);
 		prxbIndicateArray[0] = prxb;
-//		printk("========================>%s(): SeqNum is %d\n",__FUNCTION__,SeqNum);
+//		printk("========================>%s(): SeqNum is %d\n",__func__,SeqNum);
 		index = 1;
 	} else {
 		/* Current packet is going to be inserted into pending list.*/
-		//IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): We RX no ordered packed, insert to ordered list\n",__FUNCTION__);
+		//IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): We RX no ordered packed, insert to ordered list\n",__func__);
 		if(!list_empty(&ieee->RxReorder_Unused_List)) {
 			pReorderEntry = (PRX_REORDER_ENTRY)list_entry(ieee->RxReorder_Unused_List.next,RX_REORDER_ENTRY,List);
 			list_del_init(&pReorderEntry->List);
@@ -674,11 +674,11 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 			/* Make a reorder entry and insert into a the packet list.*/
 			pReorderEntry->SeqNum = SeqNum;
 			pReorderEntry->prxb = prxb;
-	//		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): pREorderEntry->SeqNum is %d\n",__FUNCTION__,pReorderEntry->SeqNum);
+	//		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): pREorderEntry->SeqNum is %d\n",__func__,pReorderEntry->SeqNum);
 
 			if(!AddReorderEntry(pTS, pReorderEntry)) {
 				IEEE80211_DEBUG(IEEE80211_DL_REORDER, "%s(): Duplicate packet is dropped!! IndicateSeq: %d, NewSeq: %d\n",
-					__FUNCTION__, pTS->RxIndicateSeq, SeqNum);
+					__func__, pTS->RxIndicateSeq, SeqNum);
 				list_add_tail(&pReorderEntry->List,&ieee->RxReorder_Unused_List);
 				{
 					int i;
@@ -713,7 +713,7 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 
 	/* Check if there is any packet need indicate.*/
 	while(!list_empty(&pTS->RxPendingPktList)) {
-		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): start RREORDER indicate\n",__FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): start RREORDER indicate\n",__func__);
 		pReorderEntry = (PRX_REORDER_ENTRY)list_entry(pTS->RxPendingPktList.prev,RX_REORDER_ENTRY,List);
 		if( SN_LESS(pReorderEntry->SeqNum, pTS->RxIndicateSeq) ||
 				SN_EQUAL(pReorderEntry->SeqNum, pTS->RxIndicateSeq))
@@ -732,7 +732,7 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 
 			IEEE80211_DEBUG(IEEE80211_DL_REORDER,"Packets indication!! IndicateSeq: %d, NewSeq: %d\n",pTS->RxIndicateSeq, SeqNum);
 			prxbIndicateArray[index] = pReorderEntry->prxb;
-		//	printk("========================>%s(): pReorderEntry->SeqNum is %d\n",__FUNCTION__,pReorderEntry->SeqNum);
+		//	printk("========================>%s(): pReorderEntry->SeqNum is %d\n",__func__,pReorderEntry->SeqNum);
 			index++;
 
 			list_add_tail(&pReorderEntry->List,&ieee->RxReorder_Unused_List);
@@ -758,7 +758,7 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 
 	if(bPktInBuf && pTS->RxTimeoutIndicateSeq==0xffff) {
 		// Set new pending timer.
-		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): SET rx timeout timer\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): SET rx timeout timer\n", __func__);
 		pTS->RxTimeoutIndicateSeq = pTS->RxIndicateSeq;
 		if(timer_pending(&pTS->RxPktPendingTimer))
 			del_timer_sync(&pTS->RxPktPendingTimer);
@@ -832,8 +832,8 @@ static u8 parse_subframe(struct sk_buff *skb,
 
 			if(skb->len<(ETHERNET_HEADER_SIZE + nSubframe_Length)) {
 				printk("%s: A-MSDU parse error!! pRfd->nTotalSubframe : %d\n",\
-						__FUNCTION__,rxb->nr_subframes);
-				printk("%s: A-MSDU parse error!! Subframe Length: %d\n",__FUNCTION__, nSubframe_Length);
+						__func__,rxb->nr_subframes);
+				printk("%s: A-MSDU parse error!! Subframe Length: %d\n",__func__, nSubframe_Length);
 				printk("nRemain_Length is %d and nSubframe_Length is : %d\n",skb->len,nSubframe_Length);
 				printk("The Packet SeqNum is %d\n",SeqNum);
 				return 0;
@@ -1027,7 +1027,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	else
 	{
 		PRX_TS_RECORD pRxTS = NULL;
-			//IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): QOS ENABLE AND RECEIVE QOS DATA , we will get Ts, tid:%d\n",__FUNCTION__, tid);
+			//IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): QOS ENABLE AND RECEIVE QOS DATA , we will get Ts, tid:%d\n",__func__, tid);
 		if(GetTs(
 				ieee,
 				(PTS_COMMON_INFO *) &pRxTS,
@@ -1037,7 +1037,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 				true))
 		{
 
-		//	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): pRxTS->RxLastFragNum is %d,frag is %d,pRxTS->RxLastSeqNum is %d,seq is %d\n",__FUNCTION__,pRxTS->RxLastFragNum,frag,pRxTS->RxLastSeqNum,WLAN_GET_SEQ_SEQ(sc));
+		//	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): pRxTS->RxLastFragNum is %d,frag is %d,pRxTS->RxLastSeqNum is %d,seq is %d\n",__func__,pRxTS->RxLastFragNum,frag,pRxTS->RxLastSeqNum,WLAN_GET_SEQ_SEQ(sc));
 			if(	(fc & (1<<11))  &&
 					(frag == pRxTS->RxLastFragNum) &&
 					(WLAN_GET_SEQ_SEQ(sc) == pRxTS->RxLastSeqNum)	)
@@ -1052,7 +1052,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		}
 		else
 		{
-			IEEE80211_DEBUG(IEEE80211_DL_ERR, "%s(): No TS!! Skip the check!!\n",__FUNCTION__);
+			IEEE80211_DEBUG(IEEE80211_DL_ERR, "%s(): No TS!! Skip the check!!\n",__func__);
 			goto rx_dropped;
 		}
 	}
@@ -1297,7 +1297,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	rxb = kmalloc(sizeof(struct ieee80211_rxb), GFP_ATOMIC);
 	if(rxb == NULL)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR,"%s(): kmalloc rxb error\n",__FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR,"%s(): kmalloc rxb error\n",__func__);
 		goto rx_dropped;
 	}
 	/* to parse amsdu packets */
@@ -1363,7 +1363,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	}
 	else
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): REORDER ENABLE AND PTS not NULL, and we will enter RxReorderIndicatePacket()\n",__FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): REORDER ENABLE AND PTS not NULL, and we will enter RxReorderIndicatePacket()\n",__func__);
 		RxReorderIndicatePacket(ieee, rxb, pTS, SeqNum);
 	}
 #ifndef JOHN_NOCPY
@@ -1929,7 +1929,7 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 				info_element->data[1] == 0x13 &&
 				info_element->data[2] == 0x74))
 			{
-				printk("========>%s(): athros AP is exist\n",__FUNCTION__);
+				printk("========>%s(): athros AP is exist\n",__func__);
 				network->atheros_cap_exist = true;
 			}
 			else
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 9caf6fd..1c210f6 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -271,7 +271,7 @@ inline void softmac_mgmt_xmit(struct sk_buff *skb, struct ieee80211_device *ieee
 			/* as for the completion function, it does not need
 			 * to check it any more.
 			 * */
-			printk("%s():insert to waitqueue!\n",__FUNCTION__);
+			printk("%s():insert to waitqueue!\n",__func__);
 			skb_queue_tail(&ieee->skb_waitQ[tcb_desc->queue_index], skb);
 		} else {
 			//printk("TX packet!\n");
@@ -670,7 +670,7 @@ inline struct sk_buff *ieee80211_authentication_req(struct ieee80211_network *be
 		auth->algorithm = WLAN_AUTH_SHARED_KEY;
 	else if(ieee->auth_mode == 2)
 		auth->algorithm = WLAN_AUTH_OPEN;//0x80;
-	printk("=================>%s():auth->algorithm is %d\n",__FUNCTION__,auth->algorithm);
+	printk("=================>%s():auth->algorithm is %d\n",__func__,auth->algorithm);
 	auth->transaction = cpu_to_le16(ieee->associate_seq);
 	ieee->associate_seq++;
 
@@ -1212,7 +1212,7 @@ inline struct sk_buff *ieee80211_association_req(struct ieee80211_network *beaco
 			memcpy(tag, realtek_ie_buf,realtek_ie_len -2 );
 		}
 	}
-//	printk("<=====%s(), %p, %p\n", __FUNCTION__, ieee->dev, ieee->dev->dev_addr);
+//	printk("<=====%s(), %p, %p\n", __func__, ieee->dev, ieee->dev->dev_addr);
 //	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len);
 	return skb;
 }
@@ -1398,7 +1398,7 @@ static void ieee80211_associate_procedure_wq(struct work_struct *work)
 		ieee->data_hard_stop(ieee->dev);
 
 	ieee80211_stop_scan(ieee);
-	printk("===>%s(), chan:%d\n", __FUNCTION__, ieee->current_network.channel);
+	printk("===>%s(), chan:%d\n", __func__, ieee->current_network.channel);
 	//ieee->set_chan(ieee->dev, ieee->current_network.channel);
 	HTSetConnectBwMode(ieee, HT_CHANNEL_WIDTH_20, HT_EXTCHNL_OFFSET_NO_EXT);
 
@@ -2636,7 +2636,7 @@ void ieee80211_start_protocol(struct ieee80211_device *ieee)
 
 	if (ieee->current_network.beacon_interval == 0)
 		ieee->current_network.beacon_interval = 100;
-//	printk("===>%s(), chan:%d\n", __FUNCTION__, ieee->current_network.channel);
+//	printk("===>%s(), chan:%d\n", __func__, ieee->current_network.channel);
 //	ieee->set_chan(ieee->dev,ieee->current_network.channel);
 
 	for(i = 0; i < 17; i++) {
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 6779bdd..c2ac58c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -188,7 +188,7 @@ int ieee80211_encrypt_fragment(
 
 	if (!(crypt && crypt->ops))
 	{
-		printk("=========>%s(), crypt is null\n", __FUNCTION__);
+		printk("=========>%s(), crypt is null\n", __func__);
 		return -1;
 	}
 #ifdef CONFIG_IEEE80211_CRYPT_TKIP
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index bdf67ec..0da23f1 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -792,7 +792,7 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 		break;
 
 	case IW_AUTH_80211_AUTH_ALG:
-		//printk("======>%s():data->value is %d\n",__FUNCTION__,data->value);
+		//printk("======>%s():data->value is %d\n",__func__,data->value);
 	//	ieee->open_wep = (data->value&IW_AUTH_ALG_OPEN_SYSTEM)?1:0;
 		if(data->value & IW_AUTH_ALG_SHARED_KEY){
 			ieee->open_wep = 0;
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
index 7bf55e3..b8cc6a5 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -113,7 +113,7 @@ static struct sk_buff *ieee80211_ADDBA(struct ieee80211_device *ieee, u8 *Dst, P
 	u16 tmp = 0;
 	u16 len = ieee->tx_headroom + 9;
 	//category(1) + action field(1) + Dialog Token(1) + BA Parameter Set(2) +  BA Timeout Value(2) +  BA Start SeqCtrl(2)(or StatusCode(2))
-	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "========>%s(), frame(%d) sentd to:%pM, ieee->dev:%p\n", __FUNCTION__, type, Dst, ieee->dev);
+	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "========>%s(), frame(%d) sentd to:%pM, ieee->dev:%p\n", __func__, type, Dst, ieee->dev);
 	if (pBA == NULL||ieee == NULL)
 	{
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "pBA(%p) is NULL or ieee(%p) is NULL\n", pBA, ieee);
@@ -201,7 +201,7 @@ static struct sk_buff *ieee80211_DELBA(
 	u16 len = 6 + ieee->tx_headroom;
 
 	if (net_ratelimit())
-	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "========>%s(), ReasonCode(%d) sentd to:%pM\n", __FUNCTION__, ReasonCode, dst);
+	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "========>%s(), ReasonCode(%d) sentd to:%pM\n", __func__, ReasonCode, dst);
 
 	memset(&DelbaParamSet, 0, 2);
 
@@ -240,7 +240,7 @@ static struct sk_buff *ieee80211_DELBA(
 
 	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA|IEEE80211_DL_BA, skb->data, skb->len);
 	if (net_ratelimit())
-	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "<=====%s()\n", __FUNCTION__);
+	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "<=====%s()\n", __func__);
 	return skb;
 }
 
@@ -266,7 +266,7 @@ static void ieee80211_send_ADDBAReq(struct ieee80211_device *ieee,
 	}
 	else
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "alloc skb error in function %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "alloc skb error in function %s()\n", __func__);
 	}
 	return;
 }
@@ -291,7 +291,7 @@ static void ieee80211_send_ADDBARsp(struct ieee80211_device *ieee, u8 *dst,
 	}
 	else
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "alloc skb error in function %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "alloc skb error in function %s()\n", __func__);
 	}
 
 	return;
@@ -320,7 +320,7 @@ static void ieee80211_send_DELBA(struct ieee80211_device *ieee, u8 *dst,
 	}
 	else
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "alloc skb error in function %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "alloc skb error in function %s()\n", __func__);
 	}
 	return ;
 }
@@ -380,7 +380,7 @@ int ieee80211_rx_ADDBAReq( struct ieee80211_device *ieee, struct sk_buff *skb)
 			true)	)
 	{
 		rc = ADDBA_STATUS_REFUSED;
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't get TS in %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't get TS in %s()\n", __func__);
 		goto OnADDBAReq_Fail;
 	}
 	pBA = &pTS->RxAdmittedBARecord;
@@ -391,7 +391,7 @@ int ieee80211_rx_ADDBAReq( struct ieee80211_device *ieee, struct sk_buff *skb)
 	if(pBaParamSet->field.BAPolicy == BA_POLICY_DELAYED)
 	{
 		rc = ADDBA_STATUS_INVALID_PARAM;
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "BA Policy is not correct in %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "BA Policy is not correct in %s()\n", __func__);
 		goto OnADDBAReq_Fail;
 	}
 		// Admit the ADDBA Request
@@ -479,7 +479,7 @@ int ieee80211_rx_ADDBARsp( struct ieee80211_device *ieee, struct sk_buff *skb)
 			TX_DIR,
 			false)	)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't get TS in %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't get TS in %s()\n", __func__);
 		ReasonCode = DELBA_REASON_UNKNOWN_BA;
 		goto OnADDBARsp_Reject;
 	}
@@ -603,7 +603,7 @@ int ieee80211_rx_DELBA(struct ieee80211_device *ieee,struct sk_buff *skb)
 				RX_DIR,
 				false)	)
 		{
-			IEEE80211_DEBUG(IEEE80211_DL_ERR,  "can't get TS for RXTS in %s()\n", __FUNCTION__);
+			IEEE80211_DEBUG(IEEE80211_DL_ERR,  "can't get TS for RXTS in %s()\n", __func__);
 			return -1;
 		}
 
@@ -621,7 +621,7 @@ int ieee80211_rx_DELBA(struct ieee80211_device *ieee,struct sk_buff *skb)
 			TX_DIR,
 			false)	)
 		{
-			IEEE80211_DEBUG(IEEE80211_DL_ERR,  "can't get TS for TXTS in %s()\n", __FUNCTION__);
+			IEEE80211_DEBUG(IEEE80211_DL_ERR,  "can't get TS for TXTS in %s()\n", __func__);
 			return -1;
 		}
 
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 53ec2d4..a9f44ca 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -130,7 +130,7 @@ void HTDebugHTCapability(u8 *CapIE, u8 *TitleString )
 	if(!memcmp(CapIE, EWC11NHTCap, sizeof(EWC11NHTCap)))
 	{
 		//EWC IE
-		IEEE80211_DEBUG(IEEE80211_DL_HT, "EWC IE in %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_HT, "EWC IE in %s()\n", __func__);
 		pCapELE = (PHT_CAPABILITY_ELE)(&CapIE[4]);
 	}else
 		pCapELE = (PHT_CAPABILITY_ELE)(&CapIE[0]);
@@ -167,7 +167,7 @@ void HTDebugHTInfo(u8 *InfoIE, u8 *TitleString)
 	if(!memcmp(InfoIE, EWC11NHTInfo, sizeof(EWC11NHTInfo)))
 	{
 		// Not EWC IE
-		IEEE80211_DEBUG(IEEE80211_DL_HT, "EWC IE in %s()\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_HT, "EWC IE in %s()\n", __func__);
 		pHTInfoEle = (PHT_INFORMATION_ELE)(&InfoIE[4]);
 	}else
 		pHTInfoEle = (PHT_INFORMATION_ELE)(&InfoIE[0]);
@@ -1134,7 +1134,7 @@ void HTInitializeHTInfo(struct ieee80211_device *ieee)
 	//
 	// These parameters will be reset when receiving deauthentication packet
 	//
-	IEEE80211_DEBUG(IEEE80211_DL_HT, "===========>%s()\n", __FUNCTION__);
+	IEEE80211_DEBUG(IEEE80211_DL_HT, "===========>%s()\n", __func__);
 	pHTInfo->bCurrentHTSupport = false;
 
 	// 40MHz channel support
@@ -1229,7 +1229,7 @@ void HTResetSelfAndSavePeerSetting(struct ieee80211_device *ieee,	struct ieee802
 	//
 	//  Save Peer Setting before Association
 	//
-	IEEE80211_DEBUG(IEEE80211_DL_HT, "==============>%s()\n", __FUNCTION__);
+	IEEE80211_DEBUG(IEEE80211_DL_HT, "==============>%s()\n", __func__);
 	/*unmark bEnableHT flag here is the same reason why unmarked in function ieee80211_softmac_new_net. WB 2008.09.10*/
 //	if( pHTInfo->bEnableHT &&  pNetwork->bssht.bdSupportHT)
 	if (pNetwork->bssht.bdSupportHT)
@@ -1397,7 +1397,7 @@ void HTSetConnectBwModeCallback(struct ieee80211_device *ieee)
 {
 	PRT_HIGH_THROUGHPUT pHTInfo = ieee->pHTInfo;
 
-	IEEE80211_DEBUG(IEEE80211_DL_HT, "======>%s()\n", __FUNCTION__);
+	IEEE80211_DEBUG(IEEE80211_DL_HT, "======>%s()\n", __func__);
 
 	if(pHTInfo->bCurBW40MHz)
 	{
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index 426f223..c451410 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -38,7 +38,7 @@ static void RxPktPendingTimeout(unsigned long data)
 
 	spin_lock_irqsave(&(ieee->reorder_spinlock), flags);
 	//PlatformAcquireSpinLock(Adapter, RT_RX_SPINLOCK);
-	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"==================>%s()\n",__FUNCTION__);
+	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"==================>%s()\n",__func__);
 	if(pRxTs->RxTimeoutIndicateSeq != 0xffff)
 	{
 		// Indicate the pending packets sequentially according to SeqNum until meet the gap.
@@ -144,7 +144,7 @@ void TSInitialize(struct ieee80211_device *ieee)
 	PRX_TS_RECORD		pRxTS  = ieee->RxTsRecord;
 	PRX_REORDER_ENTRY	pRxReorderEntry = ieee->RxReorderEntry;
 	u8				count = 0;
-	IEEE80211_DEBUG(IEEE80211_DL_TS, "==========>%s()\n", __FUNCTION__);
+	IEEE80211_DEBUG(IEEE80211_DL_TS, "==========>%s()\n", __func__);
 	// Initialize Tx TS related info.
 	INIT_LIST_HEAD(&ieee->Tx_TS_Admit_List);
 	INIT_LIST_HEAD(&ieee->Tx_TS_Pending_List);
@@ -361,7 +361,7 @@ bool GetTs(
 		// In WMM case: we use 4 TID only
 		if (!IsACValid(TID))
 		{
-			IEEE80211_DEBUG(IEEE80211_DL_ERR, " in %s(), TID(%d) is not valid\n", __FUNCTION__, TID);
+			IEEE80211_DEBUG(IEEE80211_DL_ERR, " in %s(), TID(%d) is not valid\n", __func__, TID);
 			return false;
 		}
 
@@ -463,7 +463,7 @@ bool GetTs(
 			}
 			else
 			{
-				IEEE80211_DEBUG(IEEE80211_DL_ERR, "in function %s() There is not enough TS record to be used!!", __FUNCTION__);
+				IEEE80211_DEBUG(IEEE80211_DL_ERR, "in function %s() There is not enough TS record to be used!!", __func__);
 				return false;
 			}
 		}
@@ -619,5 +619,5 @@ void TsStartAddBaProcess(struct ieee80211_device *ieee, PTX_TS_RECORD	pTxTS)
 		}
 	}
 	else
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "%s()==>BA timer is already added\n", __FUNCTION__);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "%s()==>BA timer is already added\n", __func__);
 }
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index 9fa12e4..b4264e1 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -2523,7 +2523,7 @@ static void dm_check_edca_turbo(
 	if(priv->ieee80211->pHTInfo->IOTAction & HT_IOT_ACT_DISABLE_EDCA_TURBO)
 		goto dm_CheckEdcaTurbo_EXIT;
 
-//	printk("========>%s():bis_any_nonbepkts is %d\n",__FUNCTION__,priv->bis_any_nonbepkts);
+//	printk("========>%s():bis_any_nonbepkts is %d\n",__func__,priv->bis_any_nonbepkts);
 	// Check the status for current condition.
 	if(!priv->ieee80211->bis_any_nonbepkts)
 	{
@@ -3183,7 +3183,7 @@ void dm_fsync_timer_callback(unsigned long data)
 
 static void dm_StartHWFsync(struct net_device *dev)
 {
-	RT_TRACE(COMP_HALDM, "%s\n", __FUNCTION__);
+	RT_TRACE(COMP_HALDM, "%s\n", __func__);
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c12cf);
 	write_nic_byte(dev, 0xc3b, 0x41);
 }
@@ -3192,7 +3192,7 @@ static void dm_EndSWFsync(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	RT_TRACE(COMP_HALDM, "%s\n", __FUNCTION__);
+	RT_TRACE(COMP_HALDM, "%s\n", __func__);
 	del_timer_sync(&(priv->fsync_timer));
 
 	// Let Register return to default value;
@@ -3216,7 +3216,7 @@ static void dm_StartSWFsync(struct net_device *dev)
 	u32			rateIndex;
 	u32			rateBitmap;
 
-	RT_TRACE(COMP_HALDM,"%s\n", __FUNCTION__);
+	RT_TRACE(COMP_HALDM,"%s\n", __func__);
 	// Initial rate record to zero, start to record.
 	priv->rate_record = 0;
 	// Initialize continue diff count to zero, start to record.
@@ -3251,7 +3251,7 @@ static void dm_StartSWFsync(struct net_device *dev)
 
 static void dm_EndHWFsync(struct net_device *dev)
 {
-	RT_TRACE(COMP_HALDM,"%s\n", __FUNCTION__);
+	RT_TRACE(COMP_HALDM,"%s\n", __func__);
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
 	write_nic_byte(dev, 0xc3b, 0x49);
 
@@ -3483,7 +3483,7 @@ static void dm_dynamic_txpower(struct net_device *dev)
 		txlowpower_threshold = TX_POWER_NEAR_FIELD_THRESH_LOW;
 	}
 
-//	printk("=======>%s(): txhipower_threshhold is %d,txlowpower_threshold is %d\n",__FUNCTION__,txhipower_threshhold,txlowpower_threshold);
+//	printk("=======>%s(): txhipower_threshhold is %d,txlowpower_threshold is %d\n",__func__,txhipower_threshhold,txlowpower_threshold);
 	RT_TRACE(COMP_TXAGC,"priv->undecorated_smoothed_pwdb = %ld \n" , priv->undecorated_smoothed_pwdb);
 
 	if(priv->ieee80211->state == IEEE80211_LINKED)
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 72db773..d0089b9 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -135,7 +135,7 @@ static int r8192_wx_force_reset(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	printk("%s(): force reset ! extra is %d\n",__FUNCTION__, *extra);
+	printk("%s(): force reset ! extra is %d\n",__func__, *extra);
 	priv->force_reset = *extra;
 	up(&priv->wx_sem);
 	return 0;
@@ -741,7 +741,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 	int ret=0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
-	//printk("===>%s()\n", __FUNCTION__);
+	//printk("===>%s()\n", __func__);
 
 
 	down(&priv->wx_sem);
@@ -820,7 +820,7 @@ static int r8192_wx_set_auth(struct net_device *dev,
 					union iwreq_data *data, char *extra)
 {
 	int ret=0;
-	//printk("====>%s()\n", __FUNCTION__);
+	//printk("====>%s()\n", __func__);
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_auth(priv->ieee80211, info, &(data->param), extra);
@@ -832,7 +832,7 @@ static int r8192_wx_set_mlme(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *wrqu, char *extra)
 {
-	//printk("====>%s()\n", __FUNCTION__);
+	//printk("====>%s()\n", __func__);
 
 	int ret=0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
@@ -847,13 +847,13 @@ static int r8192_wx_set_gen_ie(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *data, char *extra)
 {
-	   //printk("====>%s(), len:%d\n", __FUNCTION__, data->length);
+	   //printk("====>%s(), len:%d\n", __func__, data->length);
 	int ret=0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->data.length);
 	up(&priv->wx_sem);
-	//printk("<======%s(), ret:%d\n", __FUNCTION__, ret);
+	//printk("<======%s(), ret:%d\n", __func__, ret);
 	return ret;
 
 
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index 98a113a..04b8f5e 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -162,7 +162,7 @@ static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
 	return rt_status;
 
 CPUCheckMainCodeOKAndTurnOnCPU_Fail:
-	RT_TRACE(COMP_ERR, "ERR in %s()\n", __FUNCTION__);
+	RT_TRACE(COMP_ERR, "ERR in %s()\n", __func__);
 	rt_status = FALSE;
 	return rt_status;
 }
@@ -191,7 +191,7 @@ static bool CPUcheck_firmware_ready(struct net_device *dev)
 	return rt_status;
 
 CPUCheckFirmwareReady_Fail:
-	RT_TRACE(COMP_ERR, "ERR in %s()\n", __FUNCTION__);
+	RT_TRACE(COMP_ERR, "ERR in %s()\n", __func__);
 	rt_status = false;
 	return rt_status;
 
@@ -334,7 +334,7 @@ bool init_firmware(struct net_device *dev)
 	return rt_status;
 
 download_firmware_fail:
-	RT_TRACE(COMP_ERR, "ERR in %s()\n", __FUNCTION__);
+	RT_TRACE(COMP_ERR, "ERR in %s()\n", __func__);
 	rt_status = FALSE;
 	return rt_status;
 
diff --git a/drivers/staging/rtl8723au/hal/hal_com.c b/drivers/staging/rtl8723au/hal/hal_com.c
index 1ec2145..3126e43 100644
--- a/drivers/staging/rtl8723au/hal/hal_com.c
+++ b/drivers/staging/rtl8723au/hal/hal_com.c
@@ -594,7 +594,7 @@ void rtl8723a_on_rcr_am(struct rtw_adapter *padapter)
 {
 	rtl8723au_write32(padapter, REG_RCR,
 		    rtl8723au_read32(padapter, REG_RCR) | RCR_AM);
-	DBG_8723A("%s, %d, RCR = %x \n", __FUNCTION__, __LINE__,
+	DBG_8723A("%s, %d, RCR = %x \n", __func__, __LINE__,
 		  rtl8723au_read32(padapter, REG_RCR));
 }
 
@@ -602,7 +602,7 @@ void rtl8723a_off_rcr_am(struct rtw_adapter *padapter)
 {
 	rtl8723au_write32(padapter, REG_RCR,
 		    rtl8723au_read32(padapter, REG_RCR) & (~RCR_AM));
-	DBG_8723A("%s, %d, RCR = %x \n", __FUNCTION__, __LINE__,
+	DBG_8723A("%s, %d, RCR = %x \n", __func__, __LINE__,
 		  rtl8723au_read32(padapter, REG_RCR));
 }
 
diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index 05ddd72..6b3b2f0 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -1280,7 +1280,7 @@ u32 ODM_Get_Rate_Bitmap23a(struct dm_odm_t *pDM_Odm,
 		break;
 	}
 
-	/* printk("%s ==> rssi_level:0x%02x, WirelessMode:0x%02x, rate_bitmap:0x%08x \n", __FUNCTION__, rssi_level, WirelessMode, rate_bitmap); */
+	/* printk("%s ==> rssi_level:0x%02x, WirelessMode:0x%02x, rate_bitmap:0x%08x \n", __func__, rssi_level, WirelessMode, rate_bitmap); */
 	ODM_RT_TRACE(pDM_Odm, ODM_COMP_RA_MASK, ODM_DBG_LOUD, (" ==> rssi_level:0x%02x, WirelessMode:0x%02x, rate_bitmap:0x%08x \n", rssi_level, WirelessMode, rate_bitmap));
 
 	return rate_bitmap;
@@ -1336,7 +1336,7 @@ void odm_RefreshRateAdaptiveMask23aCE23a(struct dm_odm_t *pDM_Odm)
 		return;
 	}
 
-	/* printk("==> %s \n", __FUNCTION__); */
+	/* printk("==> %s \n", __func__); */
 
 	for (i = 0; i < ODM_ASSOCIATE_ENTRY_NUM; i++) {
 		struct sta_info *pstat = pDM_Odm->pODM_StaInfo[i];
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index ea34421..9265b67 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -179,7 +179,7 @@ void rtl8723a_set_FwPwrMode_cmd(struct rtw_adapter *padapter, u8 Mode)
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
 	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
 
-	DBG_8723A("%s: Mode =%d SmartPS =%d UAPSD =%d BcnMode = 0x%02x\n", __FUNCTION__,
+	DBG_8723A("%s: Mode =%d SmartPS =%d UAPSD =%d BcnMode = 0x%02x\n", __func__,
 			Mode, pwrpriv->smart_ps, padapter->registrypriv.uapsd_enable, pwrpriv->bcn_ant_mode);
 
 	/*  Forece leave RF low power mode for 1T1R to
@@ -211,7 +211,7 @@ static void ConstructBeacon(struct rtw_adapter *padapter, u8 *pframe, u32 *pLeng
 	struct wlan_bssid_ex *cur_network = &pmlmeinfo->network;
 	u8 bc_addr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
-	/* DBG_8723A("%s\n", __FUNCTION__); */
+	/* DBG_8723A("%s\n", __func__); */
 
 	pwlanhdr = (struct ieee80211_hdr *)pframe;
 
@@ -298,7 +298,7 @@ _ConstructBeacon:
 
 	*pLength = pktlen;
 
-	/* DBG_8723A("%s bcn_sz =%d\n", __FUNCTION__, pktlen); */
+	/* DBG_8723A("%s bcn_sz =%d\n", __func__, pktlen); */
 
 }
 
@@ -411,7 +411,7 @@ static void ConstructProbeRsp(struct rtw_adapter *padapter, u8 *pframe, u32 *pLe
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
 	struct wlan_bssid_ex *cur_network = &pmlmeinfo->network;
 
-	/* DBG_8723A("%s\n", __FUNCTION__); */
+	/* DBG_8723A("%s\n", __func__); */
 
 	pwlanhdr = (struct ieee80211_hdr *)pframe;
 
@@ -471,11 +471,11 @@ static void SetFwRsvdPagePkt(struct rtw_adapter *padapter, bool bDLFinished)
 	u32 TotalPacketLen;
 	struct rsvdpage_loc	RsvdPageLoc;
 
-	DBG_8723A("%s\n", __FUNCTION__);
+	DBG_8723A("%s\n", __func__);
 
 	ReservedPagePacket = kzalloc(1000, GFP_KERNEL);
 	if (ReservedPagePacket == NULL) {
-		DBG_8723A("%s: alloc ReservedPagePacket fail!\n", __FUNCTION__);
+		DBG_8723A("%s: alloc ReservedPagePacket fail!\n", __func__);
 		return;
 	}
 
@@ -582,7 +582,7 @@ static void SetFwRsvdPagePkt(struct rtw_adapter *padapter, bool bDLFinished)
 
 	rtl8723au_mgnt_xmit(padapter, pmgntframe);
 
-	DBG_8723A("%s: Set RSVD page location to Fw\n", __FUNCTION__);
+	DBG_8723A("%s: Set RSVD page location to Fw\n", __func__);
 	FillH2CCmd(padapter, RSVD_PAGE_EID, sizeof(RsvdPageLoc), (u8 *)&RsvdPageLoc);
 
 exit:
@@ -596,7 +596,7 @@ void rtl8723a_set_FwJoinBssReport_cmd(struct rtw_adapter *padapter, u8 mstatus)
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
 
-	DBG_8723A("%s mstatus(%x)\n", __FUNCTION__, mstatus);
+	DBG_8723A("%s mstatus(%x)\n", __func__, mstatus);
 
 	if (mstatus == 1) {
 		bool bRecover = false;
@@ -678,11 +678,11 @@ static void SetFwRsvdPagePkt_BTCoex(struct rtw_adapter *padapter)
 	u32 TotalPacketLen;
 	struct rsvdpage_loc	RsvdPageLoc;
 
-	DBG_8723A("+%s\n", __FUNCTION__);
+	DBG_8723A("+%s\n", __func__);
 
 	ReservedPagePacket = kzalloc(1024, GFP_KERNEL);
 	if (ReservedPagePacket == NULL) {
-		DBG_8723A("%s: alloc ReservedPagePacket fail!\n", __FUNCTION__);
+		DBG_8723A("%s: alloc ReservedPagePacket fail!\n", __func__);
 		return;
 	}
 
@@ -744,7 +744,7 @@ static void SetFwRsvdPagePkt_BTCoex(struct rtw_adapter *padapter)
 
 	rtl8723au_mgnt_xmit(padapter, pmgntframe);
 
-	DBG_8723A("%s: Set RSVD page location to Fw\n", __FUNCTION__);
+	DBG_8723A("%s: Set RSVD page location to Fw\n", __func__);
 	FillH2CCmd(padapter, RSVD_PAGE_EID, sizeof(RsvdPageLoc), (u8 *)&RsvdPageLoc);
 
 exit:
@@ -756,7 +756,7 @@ void rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(struct rtw_adapter *padapter)
 	struct hal_data_8723a *pHalData;
 	u8 bRecover = false;
 
-	DBG_8723A("+%s\n", __FUNCTION__);
+	DBG_8723A("+%s\n", __func__);
 
 	pHalData = GET_HAL_DATA(padapter);
 
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c b/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
index 97da414..d23525e 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
@@ -1099,7 +1099,7 @@ static void _PHY_SwChnl8723A(struct rtw_adapter *Adapter, u8 channel)
 	struct hal_data_8723a *pHalData = GET_HAL_DATA(Adapter);
 
 	if (Adapter->bNotifyChannelChange)
-		DBG_8723A("[%s] ch = %d\n", __FUNCTION__, channel);
+		DBG_8723A("[%s] ch = %d\n", __func__, channel);
 
 	/* s1. pre common command - CmdID_SetTxPowerLevel */
 	PHY_SetTxPowerLevel8723A(Adapter, channel);
diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_recv.c b/drivers/staging/rtl8723au/hal/rtl8723au_recv.c
index f0ce944..6075b6d 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_recv.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_recv.c
@@ -242,7 +242,7 @@ void update_recvframe_phyinfo(struct recv_frame *precvframe,
 	psta = rtw_get_stainfo23a(pstapriv, sa);
 	if (psta) {
 		pkt_info.StationID = psta->mac_id;
-		/* printk("%s ==> StationID(%d)\n", __FUNCTION__, pkt_info.StationID); */
+		/* printk("%s ==> StationID(%d)\n", __func__, pkt_info.StationID); */
 	}
 	pkt_info.Rate = pattrib->mcs_rate;
 
diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
index 73b49ac..a6404cd 100644
--- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
@@ -45,7 +45,7 @@ static int usbctrl_vendorreq(struct rtw_adapter *padapter, u8 request,
 
 	if (len > MAX_VENDOR_REQ_CMD_SIZE) {
 		DBG_8723A("[%s] Buffer len error , vendor request failed\n",
-			  __FUNCTION__);
+			  __func__);
 		status = -EINVAL;
 		goto exit;
 	}
@@ -56,7 +56,7 @@ static int usbctrl_vendorreq(struct rtw_adapter *padapter, u8 request,
 	pIo_buf = pdvobjpriv->usb_vendor_req_buf;
 
 	if (pIo_buf == NULL) {
-		DBG_8723A("[%s] pIo_buf == NULL \n", __FUNCTION__);
+		DBG_8723A("[%s] pIo_buf == NULL \n", __func__);
 		status = -ENOMEM;
 		goto release_mutex;
 	}
@@ -352,7 +352,7 @@ static void usb_read_interrupt_complete(struct urb *purb)
 	    padapter->bReadPortCancel) {
 		DBG_8723A("%s() RX Warning! bDriverStopped(%d) OR "
 			  "bSurpriseRemoved(%d) bReadPortCancel(%d)\n",
-			  __FUNCTION__, padapter->bDriverStopped,
+			  __func__, padapter->bDriverStopped,
 			  padapter->bSurpriseRemoved,
 			  padapter->bReadPortCancel);
 		return;
@@ -508,7 +508,7 @@ static int recvbuf2recvframe(struct rtw_adapter *padapter, struct sk_buff *pskb)
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
 				 ("recvbuf2recvframe: precvframe == NULL\n"));
 			DBG_8723A("%s()-%d: rtw_alloc_recvframe23a() failed! RX "
-				  "Drop!\n", __FUNCTION__, __LINE__);
+				  "Drop!\n", __func__, __LINE__);
 			goto _exit_recvbuf2recvframe;
 		}
 
@@ -520,7 +520,7 @@ static int recvbuf2recvframe(struct rtw_adapter *padapter, struct sk_buff *pskb)
 
 		if (pattrib->crc_err) {
 			DBG_8723A("%s()-%d: RX Warning! rx CRC ERROR !!\n",
-				  __FUNCTION__, __LINE__);
+				  __func__, __LINE__);
 			rtw_free_recvframe23a(precvframe);
 			goto _exit_recvbuf2recvframe;
 		}
@@ -532,7 +532,7 @@ static int recvbuf2recvframe(struct rtw_adapter *padapter, struct sk_buff *pskb)
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_,
 				 ("recvbuf2recvframe: pkt_len<= 0\n"));
 			DBG_8723A("%s()-%d: RX Warning!\n",
-				  __FUNCTION__, __LINE__);
+				  __func__, __LINE__);
 			rtw_free_recvframe23a(precvframe);
 			goto _exit_recvbuf2recvframe;
 		}
@@ -664,7 +664,7 @@ static void usb_read_port_complete(struct urb *purb)
 
 		DBG_8723A("%s()-%d: RX Warning! bDriverStopped(%d) OR "
 			  "bSurpriseRemoved(%d) bReadPortCancel(%d)\n",
-			  __FUNCTION__, __LINE__, padapter->bDriverStopped,
+			  __func__, __LINE__, padapter->bDriverStopped,
 			  padapter->bSurpriseRemoved, padapter->bReadPortCancel);
 		return;
 	}
@@ -679,7 +679,7 @@ static void usb_read_port_complete(struct urb *purb)
 			rtl8723au_read_port(padapter, RECV_BULK_IN_ADDR, 0,
 					    precvbuf);
 			DBG_8723A("%s()-%d: RX Warning!\n",
-				  __FUNCTION__, __LINE__);
+				  __func__, __LINE__);
 		} else {
 			rtw_reset_continual_urb_error(
 				adapter_to_dvobj(padapter));
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h b/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
index 154bb47..6151019 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
@@ -1099,7 +1099,7 @@ struct btdata_entry {
 
 #define BTHCI_SM_WITH_INFO(_Adapter, _StateToEnter, _StateCmd, _EntryNum)	\
 {										\
-	RTPRINT(FIOCTL, IOCTL_STATE, ("[BT state change] caused by ""%s"", line =%d\n", __FUNCTION__, __LINE__));							\
+	RTPRINT(FIOCTL, IOCTL_STATE, ("[BT state change] caused by ""%s"", line =%d\n", __func__, __LINE__));							\
 	BTHCI_StateMachine(_Adapter, _StateToEnter, _StateCmd, _EntryNum);\
 }
 
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
index 346ee16..8646cda 100644
--- a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
@@ -621,11 +621,11 @@ void mlmeext_sta_add_event_callback23a(struct rtw_adapter *padapter, struct sta_
 void linked_status_chk23a(struct rtw_adapter *padapter);
 
 #define set_survey_timer(mlmeext, ms) \
-	/*DBG_8723A("%s set_survey_timer(%p, %d)\n", __FUNCTION__, (mlmeext), (ms));*/ \
+	/*DBG_8723A("%s set_survey_timer(%p, %d)\n", __func__, (mlmeext), (ms));*/ \
 	mod_timer(&mlmeext->survey_timer, jiffies + msecs_to_jiffies(ms));
 
 #define set_link_timer(mlmeext, ms) \
-	/*DBG_8723A("%s set_link_timer(%p, %d)\n", __FUNCTION__, (mlmeext), (ms));*/ \
+	/*DBG_8723A("%s set_link_timer(%p, %d)\n", __func__, (mlmeext), (ms));*/ \
 	mod_timer(&mlmeext->link_timer, jiffies + msecs_to_jiffies(ms));
 
 int cckrates_included23a(unsigned char *rate, int ratelen);
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 23be848..5a0e95e 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -47,7 +47,7 @@ extern int usbip_use_debug ;
 
 #define pr_fmt(fmt)	"%s: %s: " fmt "\n", PROGNAME
 #define dbg_fmt(fmt)	pr_fmt("%s:%d:[%s] " fmt), "debug",	\
-		        __FILE__, __LINE__, __FUNCTION__
+		        __FILE__, __LINE__, __func__
 
 #define err(fmt, args...)						\
 	do {								\


