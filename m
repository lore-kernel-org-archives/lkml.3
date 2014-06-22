Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaFVIXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:23:16 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51818 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaFVIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:23:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/42] staging: rtl8188eu: Remove function rtw_end_of_queue_search()
Date: Sun, 22 Jun 2014 13:49:32 +0530
Message-Id: <1403425202-11942-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c           |   16 ++---
 drivers/staging/rtl8188eu/core/rtw_debug.c        |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |   13 ++---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |    7 +--
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |    4 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    8 +--
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |   10 ++--
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |   14 ++---
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    2 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   65 +++++----------------
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    8 ---
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c     |    2 +-
 13 files changed, 49 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index a51ae26..7682115 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -288,7 +288,7 @@ void	expire_timeout_chk(struct adapter *padapter)
 	plist = phead->next;
 
 	/* check auth_queue */
-	while ((rtw_end_of_queue_search(phead, plist)) == false) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info, auth_list);
 		plist = plist->next;
 
@@ -322,7 +322,7 @@ void	expire_timeout_chk(struct adapter *padapter)
 	plist = phead->next;
 
 	/* check asoc_queue */
-	while ((rtw_end_of_queue_search(phead, plist)) == false) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info, asoc_list);
 		plist = plist->next;
 
@@ -1146,7 +1146,7 @@ int rtw_acl_add_sta(struct adapter *padapter, u8 *addr)
 	phead = get_list_head(pacl_node_q);
 	plist = phead->next;
 
-	while (!rtw_end_of_queue_search(phead, plist)) {
+	while (phead != plist) {
 		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
 		plist = plist->next;
 
@@ -1207,7 +1207,7 @@ int rtw_acl_remove_sta(struct adapter *padapter, u8 *addr)
 	phead = get_list_head(pacl_node_q);
 	plist = phead->next;
 
-	while (!rtw_end_of_queue_search(phead, plist)) {
+	while (phead != plist) {
 		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
 		plist = plist->next;
 
@@ -1505,7 +1505,7 @@ void associated_clients_update(struct adapter *padapter, u8 updated)
 		plist = phead->next;
 
 		/* check asoc_queue */
-		while ((rtw_end_of_queue_search(phead, plist)) == false) {
+		while (phead != plist) {
 			psta = container_of(plist, struct sta_info, asoc_list);
 
 			plist = plist->next;
@@ -1779,7 +1779,7 @@ int rtw_ap_inform_ch_switch(struct adapter *padapter, u8 new_ch, u8 ch_offset)
 	plist = phead->next;
 
 	/* for each sta in asoc_queue */
-	while (!rtw_end_of_queue_search(phead, plist)) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info, asoc_list);
 		plist = plist->next;
 
@@ -1813,7 +1813,7 @@ int rtw_sta_flush(struct adapter *padapter)
 	plist = phead->next;
 
 	/* free sta asoc_queue */
-	while ((rtw_end_of_queue_search(phead, plist)) == false) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info, asoc_list);
 
 		plist = plist->next;
@@ -1942,7 +1942,7 @@ void stop_ap_mode(struct adapter *padapter)
 	spin_lock_bh(&(pacl_node_q->lock));
 	phead = get_list_head(pacl_node_q);
 	plist = phead->next;
-	while ((rtw_end_of_queue_search(phead, plist)) == false) {
+	while (phead != plist) {
 		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
 		plist = plist->next;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index dd15163..1f72f7d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -853,7 +853,7 @@ int proc_get_all_sta_info(char *page, char **start,
 		phead = &(pstapriv->sta_hash[i]);
 		plist = phead->next;
 
-		while ((rtw_end_of_queue_search(phead, plist)) == false) {
+		while (phead != plist) {
 			psta = container_of(plist, struct sta_info, hash_list);
 
 			plist = plist->next;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index e44e76e..2fc294e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -278,7 +278,7 @@ void _rtw_free_network_queue(struct adapter *padapter, u8 isfreeall)
 	phead = get_list_head(scanned_queue);
 	plist = phead->next;
 
-	while (rtw_end_of_queue_search(phead, plist) == false) {
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 
 		plist = plist->next;
@@ -438,7 +438,7 @@ struct	wlan_network	*rtw_get_oldest_wlan_network(struct __queue *scanned_queue)
 	plist = phead->next;
 
 	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
+		if (phead == plist)
 			break;
 
 		pwlan = container_of(plist, struct wlan_network, list);
@@ -522,10 +522,7 @@ void rtw_update_scanned_network(struct adapter *adapter, struct wlan_bssid_ex *t
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork	= container_of(plist, struct wlan_network, list);
 
 		if (is_same_network(&(pnetwork->network), target))
@@ -537,7 +534,7 @@ void rtw_update_scanned_network(struct adapter *adapter, struct wlan_bssid_ex *t
 	}
 	/* If we didn't find a match, then get a new network slot to initialize
 	 * with this beacon's information */
-	if (rtw_end_of_queue_search(phead, plist) == true) {
+	if (phead == plist) {
 		if (_rtw_queue_empty(&(pmlmepriv->free_bss_pool)) == true) {
 			/* If there are no more slots, expire the oldest */
 			pnetwork = oldest;
@@ -1615,7 +1612,7 @@ int rtw_select_and_join_from_scanned_queue(struct mlme_priv *pmlmepriv)
 	phead = get_list_head(queue);
 	adapter = (struct adapter *)pmlmepriv->nic_hdl;
 	pmlmepriv->pscanned = phead->next;
-	while (!rtw_end_of_queue_search(phead, pmlmepriv->pscanned)) {
+	while (phead != pmlmepriv->pscanned) {
 		pnetwork = container_of(pmlmepriv->pscanned, struct wlan_network, list);
 		if (pnetwork == NULL) {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_, ("%s return _FAIL:(pnetwork==NULL)\n", __func__));
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 57e05ae..418fb21 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -6237,14 +6237,11 @@ static void issue_action_BSSCoexistPacket(struct adapter *padapter)
 		phead = get_list_head(queue);
 		plist = phead->next;
 
-		while (1) {
+		while (phead != plist) {
 			int len;
 			u8 *p;
 			struct wlan_bssid_ex *pbss_network;
 
-			if (rtw_end_of_queue_search(phead, plist))
-				break;
-
 			pnetwork = container_of(plist, struct wlan_network, list);
 
 			plist = plist->next;
@@ -8377,7 +8374,7 @@ u8 tx_beacon_hdl(struct adapter *padapter, unsigned char *pbuf)
 			xmitframe_phead = get_list_head(&psta_bmc->sleep_q);
 			xmitframe_plist = xmitframe_phead->next;
 
-			while (!rtw_end_of_queue_search(xmitframe_phead, xmitframe_plist)) {
+			while (xmitframe_phead != xmitframe_plist) {
 				pxmitframe = container_of(xmitframe_plist, struct xmit_frame, list);
 
 				xmitframe_plist = xmitframe_plist->next;
diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index 82c52ed..e6ce5ce 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -60,7 +60,7 @@ static u32 go_add_group_info_attr(struct wifidirect_info *pwdinfo, u8 *pbuf)
 	plist = phead->next;
 
 	/* look up sta asoc_queue */
-	while ((rtw_end_of_queue_search(phead, plist)) == false) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info, asoc_list);
 
 		plist = plist->next;
@@ -983,7 +983,7 @@ u32 process_p2p_devdisc_req(struct wifidirect_info *pwdinfo, u8 *pframe, uint le
 					plist = phead->next;
 
 					/* look up sta asoc_queue */
-					while ((rtw_end_of_queue_search(phead, plist)) == false) {
+					while (phead != plist) {
 						psta = container_of(plist, struct sta_info, asoc_list);
 
 						plist = plist->next;
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 9b969c5..8adfa7e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -255,7 +255,7 @@ void rtw_free_recvframe_queue(struct __queue *pframequeue,  struct __queue *pfre
 	phead = get_list_head(pframequeue);
 	plist = phead->next;
 
-	while (rtw_end_of_queue_search(phead, plist) == false) {
+	while (phead != plist) {
 		hdr = container_of(plist, struct recv_frame, list);
 
 		plist = plist->next;
@@ -1039,7 +1039,7 @@ static int validate_recv_ctrl_frame(struct adapter *padapter,
 			xmitframe_phead = get_list_head(&psta->sleep_q);
 			xmitframe_plist = xmitframe_phead->next;
 
-			if ((rtw_end_of_queue_search(xmitframe_phead, xmitframe_plist)) == false) {
+			if (xmitframe_phead != xmitframe_plist) {
 				pxmitframe = container_of(xmitframe_plist, struct xmit_frame, list);
 
 				xmitframe_plist = xmitframe_plist->next;
@@ -1471,7 +1471,7 @@ static struct recv_frame *recvframe_defrag(struct adapter *adapter,
 
 	plist = plist->next;
 
-	while (rtw_end_of_queue_search(phead, plist) == false) {
+	while (phead != plist) {
 		pnfhdr = container_of(plist, struct recv_frame, list);
 		pnextrframe = (struct recv_frame *)pnfhdr;
 
@@ -1777,7 +1777,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 	phead = get_list_head(ppending_recvframe_queue);
 	plist = phead->next;
 
-	while (rtw_end_of_queue_search(phead, plist) == false) {
+	while (phead != plist) {
 		hdr = container_of(plist, struct recv_frame, list);
 		pnextattrib = &hdr->attrib;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index 4d3dec4..39cc197 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -157,7 +157,7 @@ static void rtw_mfree_all_stainfo(struct sta_priv *pstapriv)
 	phead = get_list_head(&pstapriv->free_sta_queue);
 	plist = phead->next;
 
-	while ((rtw_end_of_queue_search(phead, plist)) == false) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info , list);
 		plist = plist->next;
 	}
@@ -185,7 +185,7 @@ u32	_rtw_free_sta_priv(struct	sta_priv *pstapriv)
 			phead = &(pstapriv->sta_hash[index]);
 			plist = phead->next;
 
-			while ((rtw_end_of_queue_search(phead, plist)) == false) {
+			while (phead != plist) {
 				int i;
 				psta = container_of(plist, struct sta_info , hash_list);
 				plist = plist->next;
@@ -441,7 +441,7 @@ void rtw_free_all_stainfo(struct adapter *padapter)
 		phead = &(pstapriv->sta_hash[index]);
 		plist = phead->next;
 
-		while ((!rtw_end_of_queue_search(phead, plist))) {
+		while (phead != plist) {
 			psta = container_of(plist, struct sta_info , hash_list);
 
 			plist = plist->next;
@@ -478,7 +478,7 @@ struct sta_info *rtw_get_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 	phead = &(pstapriv->sta_hash[index]);
 	plist = phead->next;
 
-	while ((!rtw_end_of_queue_search(phead, plist))) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info, hash_list);
 
 		if ((!memcmp(psta->hwaddr, addr, ETH_ALEN)) == true) {
@@ -539,7 +539,7 @@ u8 rtw_access_ctrl(struct adapter *padapter, u8 *mac_addr)
 	spin_lock_bh(&(pacl_node_q->lock));
 	phead = get_list_head(pacl_node_q);
 	plist = phead->next;
-	while ((!rtw_end_of_queue_search(phead, plist))) {
+	while (phead != plist) {
 		paclnode = container_of(plist, struct rtw_wlan_acl_node, list);
 		plist = plist->next;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 0aa2780..4b763bc 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1456,7 +1456,7 @@ void rtw_free_xmitframe_queue(struct xmit_priv *pxmitpriv, struct __queue *pfram
 	phead = get_list_head(pframequeue);
 	plist = phead->next;
 
-	while (!rtw_end_of_queue_search(phead, plist)) {
+	while (phead != plist) {
 		pxmitframe = container_of(plist, struct xmit_frame, list);
 
 		plist = plist->next;
@@ -1487,7 +1487,7 @@ static struct xmit_frame *dequeue_one_xmitframe(struct xmit_priv *pxmitpriv, str
 	xmitframe_phead = get_list_head(pframe_queue);
 	xmitframe_plist = xmitframe_phead->next;
 
-	if (!rtw_end_of_queue_search(xmitframe_phead, xmitframe_plist)) {
+	if (xmitframe_phead != xmitframe_plist) {
 		pxmitframe = container_of(xmitframe_plist, struct xmit_frame, list);
 
 		xmitframe_plist = xmitframe_plist->next;
@@ -1528,7 +1528,7 @@ struct xmit_frame *rtw_dequeue_xframe(struct xmit_priv *pxmitpriv, struct hw_xmi
 		sta_phead = get_list_head(phwxmit->sta_queue);
 		sta_plist = sta_phead->next;
 
-		while (!rtw_end_of_queue_search(sta_phead, sta_plist)) {
+		while (sta_phead != sta_plist) {
 			ptxservq = container_of(sta_plist, struct tx_servq, tx_pending);
 
 			pframe_queue = &ptxservq->sta_pending;
@@ -1884,7 +1884,7 @@ static void dequeue_xmitframes_to_sleeping_queue(struct adapter *padapter, struc
 	phead = get_list_head(pframequeue);
 	plist = phead->next;
 
-	while (!rtw_end_of_queue_search(phead, plist)) {
+	while (phead != plist) {
 		pxmitframe = container_of(plist, struct xmit_frame, list);
 
 		plist = plist->next;
@@ -1951,7 +1951,7 @@ void wakeup_sta_to_xmit(struct adapter *padapter, struct sta_info *psta)
 	xmitframe_phead = get_list_head(&psta->sleep_q);
 	xmitframe_plist = xmitframe_phead->next;
 
-	while (!rtw_end_of_queue_search(xmitframe_phead, xmitframe_plist)) {
+	while (xmitframe_phead != xmitframe_plist) {
 		pxmitframe = container_of(xmitframe_plist, struct xmit_frame, list);
 
 		xmitframe_plist = xmitframe_plist->next;
@@ -2032,7 +2032,7 @@ void wakeup_sta_to_xmit(struct adapter *padapter, struct sta_info *psta)
 		xmitframe_phead = get_list_head(&psta_bmc->sleep_q);
 		xmitframe_plist = xmitframe_phead->next;
 
-		while (!rtw_end_of_queue_search(xmitframe_phead, xmitframe_plist)) {
+		while (xmitframe_phead != xmitframe_plist) {
 			pxmitframe = container_of(xmitframe_plist, struct xmit_frame, list);
 
 			xmitframe_plist = xmitframe_plist->next;
@@ -2079,7 +2079,7 @@ void xmit_delivery_enabled_frames(struct adapter *padapter, struct sta_info *pst
 	xmitframe_phead = get_list_head(&psta->sleep_q);
 	xmitframe_plist = xmitframe_phead->next;
 
-	while (!rtw_end_of_queue_search(xmitframe_phead, xmitframe_plist)) {
+	while (xmitframe_phead != xmitframe_plist) {
 		pxmitframe = container_of(xmitframe_plist, struct xmit_frame, list);
 
 		xmitframe_plist = xmitframe_plist->next;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 5e4be7e..1b2e4b2 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -535,7 +535,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 	xmitframe_phead = get_list_head(&ptxservq->sta_pending);
 	xmitframe_plist = xmitframe_phead->next;
 
-	while (!rtw_end_of_queue_search(xmitframe_phead, xmitframe_plist)) {
+	while (xmitframe_phead != xmitframe_plist) {
 		pxmitframe = container_of(xmitframe_plist, struct xmit_frame, list);
 		xmitframe_plist = xmitframe_plist->next;
 
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index de3705a..d047b00 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -207,8 +207,6 @@ u32  _rtw_down_sema(struct semaphore *sema);
 
 void _rtw_init_queue(struct __queue *pqueue);
 u32  _rtw_queue_empty(struct __queue *pqueue);
-u32  rtw_end_of_queue_search(struct list_head *queue,
-			     struct list_head *pelement);
 
 u32  rtw_systime_to_ms(u32 systime);
 u32  rtw_ms_to_systime(u32 ms);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 8ddeaac..1443d4a 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1111,10 +1111,7 @@ static int rtw_wx_set_wap(struct net_device *dev,
 	phead = get_list_head(queue);
 	pmlmepriv->pscanned = phead->next;
 
-	while (1) {
-		if ((rtw_end_of_queue_search(phead, pmlmepriv->pscanned)) == true)
-			break;
-
+	while (phead != pmlmepriv->pscanned) {
 		pnetwork = container_of(pmlmepriv->pscanned, struct wlan_network, list);
 
 		pmlmepriv->pscanned = pmlmepriv->pscanned->next;
@@ -1402,10 +1399,7 @@ static int rtw_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist))
-			break;
-
+	while (phead != plist) {
 		if ((stop - ev) < SCAN_ITEM_SIZE) {
 			ret = -E2BIG;
 			break;
@@ -1490,14 +1484,7 @@ static int rtw_wx_set_essid(struct net_device *dev,
 	       phead = get_list_head(queue);
 	      pmlmepriv->pscanned = phead->next;
 
-		while (1) {
-			if (rtw_end_of_queue_search(phead, pmlmepriv->pscanned) == true) {
-				RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_warning_,
-					 ("rtw_wx_set_essid: scan_q is empty, set ssid to check if scanning again!\n"));
-
-				break;
-			}
-
+		while (phead != pmlmepriv->pscanned) {
 			pnetwork = container_of(pmlmepriv->pscanned, struct wlan_network, list);
 
 			pmlmepriv->pscanned = pmlmepriv->pscanned->next;
@@ -2563,10 +2550,7 @@ static int rtw_get_ap_info(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 
 		if (hwaddr_aton_i(data, bssid)) {
@@ -3066,10 +3050,7 @@ static int rtw_p2p_get_wps_configmethod(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 		if (!memcmp(pnetwork->network.MacAddress, peerMAC, ETH_ALEN)) {
 			u8 *wpsie;
@@ -3136,10 +3117,7 @@ static int rtw_p2p_get_go_device_address(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 		if (!memcmp(pnetwork->network.MacAddress, peerMAC, ETH_ALEN)) {
 			/*	Commented by Albert 2011/05/18 */
@@ -3220,10 +3198,7 @@ static int rtw_p2p_get_device_type(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 		if (!memcmp(pnetwork->network.MacAddress, peerMAC, ETH_ALEN)) {
 			u8 *wpsie;
@@ -3299,10 +3274,7 @@ static int rtw_p2p_get_device_name(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 		if (!memcmp(pnetwork->network.MacAddress, peerMAC, ETH_ALEN)) {
 			u8 *wpsie;
@@ -3370,10 +3342,7 @@ static int rtw_p2p_get_invitation_procedure(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 		if (!memcmp(pnetwork->network.MacAddress, peerMAC, ETH_ALEN)) {
 			/*	Commented by Albert 20121226 */
@@ -3452,10 +3421,7 @@ static int rtw_p2p_connect(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 		if (!memcmp(pnetwork->network.MacAddress, peerMAC, ETH_ALEN)) {
 			uintPeerChannel = pnetwork->network.Configuration.DSConfig;
@@ -3547,10 +3513,7 @@ static int rtw_p2p_invite_req(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
-
+	while (phead != plist) {
 		pnetwork = container_of(plist, struct wlan_network, list);
 
 		/*	Commented by Albert 2011/05/18 */
@@ -3697,9 +3660,7 @@ static int rtw_p2p_prov_disc(struct net_device *dev,
 	phead = get_list_head(queue);
 	plist = phead->next;
 
-	while (1) {
-		if (rtw_end_of_queue_search(phead, plist) == true)
-			break;
+	while (phead != plist) {
 
 		if (uintPeerChannel != 0)
 			break;
@@ -4402,7 +4363,7 @@ static int rtw_dbg_port(struct net_device *dev,
 					phead = &(pstapriv->sta_hash[i]);
 					plist = phead->next;
 
-					while ((rtw_end_of_queue_search(phead, plist)) == false) {
+					while (phead != plist) {
 						psta = container_of(plist, struct sta_info, hash_list);
 
 						plist = plist->next;
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 2ff4f14..da283f8 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -130,14 +130,6 @@ u32	  _rtw_queue_empty(struct __queue *pqueue)
 	return rtw_is_list_empty(&(pqueue->queue));
 }
 
-u32 rtw_end_of_queue_search(struct list_head *head, struct list_head *plist)
-{
-	if (head == plist)
-		return true;
-	else
-		return false;
-}
-
 inline u32 rtw_systime_to_ms(u32 systime)
 {
 	return systime * 1000 / HZ;
diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index 9172380..5abd805 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -185,7 +185,7 @@ static int rtw_mlcst2unicst(struct adapter *padapter, struct sk_buff *skb)
 	plist = phead->next;
 
 	/* free sta asoc_queue */
-	while (!rtw_end_of_queue_search(phead, plist)) {
+	while (phead != plist) {
 		psta = container_of(plist, struct sta_info, asoc_list);
 
 		plist = plist->next;
-- 
1.7.10.4

