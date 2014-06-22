Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaFVIXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:23:05 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47250 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaFVIW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:22:59 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/42] staging: rtl8188eu: Remove rtw_list_insert_tail(), wrapper for list_add_tail()
Date: Sun, 22 Jun 2014 13:49:31 +0530
Message-Id: <1403425202-11942-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c           |    2 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    4 ++--
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |   12 ++++++------
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |    4 ++--
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    2 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c         |   12 ++++++------
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |    6 +++---
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |   20 ++++++++++----------
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    5 -----
 10 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index eb96c56..a51ae26 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -1176,7 +1176,7 @@ int rtw_acl_add_sta(struct adapter *padapter, u8 *addr)
 
 			paclnode->valid = true;
 
-			rtw_list_insert_tail(&paclnode->list, get_list_head(pacl_node_q));
+			list_add_tail(&paclnode->list, get_list_head(pacl_node_q));
 
 			pacl_list->num++;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index c7b7f15..0bcd8a8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -138,7 +138,7 @@ int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj)
 
 	spin_lock_irqsave(&queue->lock, irqL);
 
-	rtw_list_insert_tail(&obj->list, &queue->queue);
+	list_add_tail(&obj->list, &queue->queue);
 
 	spin_unlock_irqrestore(&queue->lock, irqL);
 
@@ -2124,7 +2124,7 @@ void rtw_createbss_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd)
 			}
 			pwlan->last_scanned = jiffies;
 		} else {
-			rtw_list_insert_tail(&(pwlan->list), &pmlmepriv->scanned_queue.queue);
+			list_add_tail(&(pwlan->list), &pmlmepriv->scanned_queue.queue);
 		}
 
 		pnetwork->Length = get_wlan_bssid_ex_sz(pnetwork);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 1a39b67..e44e76e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -74,7 +74,7 @@ int _rtw_init_mlme_priv(struct adapter *padapter)
 	for (i = 0; i < MAX_BSS_CNT; i++) {
 		_rtw_init_listhead(&(pnetwork->list));
 
-		rtw_list_insert_tail(&(pnetwork->list), &(pmlmepriv->free_bss_pool.queue));
+		list_add_tail(&(pnetwork->list), &(pmlmepriv->free_bss_pool.queue));
 
 		pnetwork++;
 	}
@@ -135,7 +135,7 @@ int	_rtw_enqueue_network(struct __queue *queue, struct wlan_network *pnetwork)
 
 	spin_lock_bh(&queue->lock);
 
-	rtw_list_insert_tail(&pnetwork->list, &queue->queue);
+	list_add_tail(&pnetwork->list, &queue->queue);
 
 	spin_unlock_bh(&queue->lock);
 
@@ -217,7 +217,7 @@ void _rtw_free_network(struct	mlme_priv *pmlmepriv , struct wlan_network *pnetwo
 	}
 	spin_lock_bh(&free_queue->lock);
 	rtw_list_delete(&(pnetwork->list));
-	rtw_list_insert_tail(&(pnetwork->list), &(free_queue->queue));
+	list_add_tail(&(pnetwork->list), &(free_queue->queue));
 	pmlmepriv->num_of_scanned--;
 	spin_unlock_bh(&free_queue->lock);
 }
@@ -231,7 +231,7 @@ void _rtw_free_network_nolock(struct	mlme_priv *pmlmepriv, struct wlan_network *
 	if (pnetwork->fixed)
 		return;
 	rtw_list_delete(&(pnetwork->list));
-	rtw_list_insert_tail(&(pnetwork->list), get_list_head(free_queue));
+	list_add_tail(&(pnetwork->list), get_list_head(free_queue));
 	pmlmepriv->num_of_scanned--;
 }
 
@@ -575,7 +575,7 @@ void rtw_update_scanned_network(struct adapter *adapter, struct wlan_bssid_ex *t
 			/* bss info not receiving from the right channel */
 			if (pnetwork->network.PhyInfo.SignalQuality == 101)
 				pnetwork->network.PhyInfo.SignalQuality = 0;
-			rtw_list_insert_tail(&(pnetwork->list), &(queue->queue));
+			list_add_tail(&(pnetwork->list), &(queue->queue));
 		}
 	} else {
 		/* we have an entry and we are going to update it. But this entry may
@@ -830,7 +830,7 @@ static void free_scanqueue(struct	mlme_priv *pmlmepriv)
 	while (plist != phead) {
 		ptemp = plist->next;
 		rtw_list_delete(plist);
-		rtw_list_insert_tail(plist, &free_queue->queue);
+		list_add_tail(plist, &free_queue->queue);
 		plist = ptemp;
 		pmlmepriv->num_of_scanned--;
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 01cc80a..57e05ae 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -830,7 +830,7 @@ unsigned int OnAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 
 	spin_lock_bh(&pstapriv->auth_list_lock);
 	if (rtw_is_list_empty(&pstat->auth_list)) {
-		rtw_list_insert_tail(&pstat->auth_list, &pstapriv->auth_list);
+		list_add_tail(&pstat->auth_list, &pstapriv->auth_list);
 		pstapriv->auth_list_cnt++;
 	}
 	spin_unlock_bh(&pstapriv->auth_list_lock);
@@ -1416,7 +1416,7 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 	spin_lock_bh(&pstapriv->asoc_list_lock);
 	if (rtw_is_list_empty(&pstat->asoc_list)) {
 		pstat->expire_to = pstapriv->expire_to;
-		rtw_list_insert_tail(&pstat->asoc_list, &pstapriv->asoc_list);
+		list_add_tail(&pstat->asoc_list, &pstapriv->asoc_list);
 		pstapriv->asoc_list_cnt++;
 	}
 	spin_unlock_bh(&pstapriv->asoc_list_lock);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 25d2bc8..af1be19 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -983,7 +983,7 @@ void _rtw_mp_xmit_priv(struct xmit_priv *pxmitpriv)
 			goto exit;
 		}
 
-		rtw_list_insert_tail(&pxmitbuf->list, &(pxmitpriv->free_xmit_extbuf_queue.queue));
+		list_add_tail(&pxmitbuf->list, &(pxmitpriv->free_xmit_extbuf_queue.queue));
 		pxmitbuf++;
 	}
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 9e063d0..9b969c5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -84,7 +84,7 @@ int _rtw_init_recv_priv(struct recv_priv *precvpriv, struct adapter *padapter)
 	for (i = 0; i < NR_RECVFRAME; i++) {
 		_rtw_init_listhead(&(precvframe->list));
 
-		rtw_list_insert_tail(&(precvframe->list),
+		list_add_tail(&(precvframe->list),
 				     &(precvpriv->free_recv_queue.queue));
 
 		res = rtw_os_recv_resource_alloc(padapter, precvframe);
@@ -195,7 +195,7 @@ int rtw_free_recvframe(struct recv_frame *precvframe,
 
 	precvframe->len = 0;
 
-	rtw_list_insert_tail(&(precvframe->list), get_list_head(pfree_recv_queue));
+	list_add_tail(&(precvframe->list), get_list_head(pfree_recv_queue));
 
 	if (padapter != NULL) {
 		if (pfree_recv_queue == &precvpriv->free_recv_queue)
@@ -215,7 +215,7 @@ int _rtw_enqueue_recvframe(struct recv_frame *precvframe, struct __queue *queue)
 
 
 	rtw_list_delete(&(precvframe->list));
-	rtw_list_insert_tail(&(precvframe->list), get_list_head(queue));
+	list_add_tail(&(precvframe->list), get_list_head(queue));
 
 	if (padapter != NULL) {
 		if (queue == &precvpriv->free_recv_queue)
@@ -1572,7 +1572,7 @@ struct recv_frame *recvframe_chk_defrag(struct adapter *padapter,
 			/* Then enqueue the 0~(n-1) fragment into the defrag_q */
 
 			phead = get_list_head(pdefrag_q);
-			rtw_list_insert_tail(&pfhdr->list, phead);
+			list_add_tail(&pfhdr->list, phead);
 
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_, ("Enqueuq: ismfrag=%d, fragnum=%d\n", ismfrag, fragnum));
 
@@ -1590,7 +1590,7 @@ struct recv_frame *recvframe_chk_defrag(struct adapter *padapter,
 		/* enqueue the last fragment */
 		if (pdefrag_q != NULL) {
 			phead = get_list_head(pdefrag_q);
-			rtw_list_insert_tail(&pfhdr->list, phead);
+			list_add_tail(&pfhdr->list, phead);
 
 			/* call recvframe_defrag to defrag */
 			RT_TRACE(_module_rtl871x_recv_c_, _drv_info_, ("defrag: ismfrag=%d, fragnum=%d\n", ismfrag, fragnum));
@@ -1791,7 +1791,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 
 	rtw_list_delete(&(prframe->list));
 
-	rtw_list_insert_tail(&(prframe->list), plist);
+	list_add_tail(&(prframe->list), plist);
 	return true;
 }
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index 341a6d1..4d3dec4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -100,7 +100,7 @@ u32	_rtw_init_sta_priv(struct	sta_priv *pstapriv)
 
 		_rtw_init_listhead(&(pstapriv->sta_hash[i]));
 
-		rtw_list_insert_tail(&psta->list, get_list_head(&pstapriv->free_sta_queue));
+		list_add_tail(&psta->list, get_list_head(&pstapriv->free_sta_queue));
 
 		psta++;
 	}
@@ -243,7 +243,7 @@ struct	sta_info *rtw_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 
 		spin_lock_bh(&(pstapriv->sta_hash_lock));
 
-		rtw_list_insert_tail(&psta->hash_list, phash_list);
+		list_add_tail(&psta->hash_list, phash_list);
 
 		pstapriv->asoc_sta_count++;
 
@@ -413,7 +413,7 @@ u32	rtw_free_stainfo(struct adapter *padapter , struct sta_info *psta)
 #endif	/*  CONFIG_88EU_AP_MODE */
 
 	spin_lock_bh(&(pfree_sta_queue->lock));
-	rtw_list_insert_tail(&psta->list, get_list_head(pfree_sta_queue));
+	list_add_tail(&psta->list, get_list_head(pfree_sta_queue));
 	spin_unlock_bh(&pfree_sta_queue->lock);
 
 exit:
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 1d83037..0aa2780 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -110,7 +110,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 		pxframe->buf_addr = NULL;
 		pxframe->pxmitbuf = NULL;
 
-		rtw_list_insert_tail(&(pxframe->list), &(pxmitpriv->free_xmit_queue.queue));
+		list_add_tail(&(pxframe->list), &(pxmitpriv->free_xmit_queue.queue));
 
 		pxframe++;
 	}
@@ -156,7 +156,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 
 		pxmitbuf->flags = XMIT_VO_QUEUE;
 
-		rtw_list_insert_tail(&pxmitbuf->list, &(pxmitpriv->free_xmitbuf_queue.queue));
+		list_add_tail(&pxmitbuf->list, &(pxmitpriv->free_xmitbuf_queue.queue));
 		pxmitbuf++;
 	}
 
@@ -190,7 +190,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 			goto exit;
 		}
 
-		rtw_list_insert_tail(&pxmitbuf->list, &(pxmitpriv->free_xmit_extbuf_queue.queue));
+		list_add_tail(&pxmitbuf->list, &(pxmitpriv->free_xmit_extbuf_queue.queue));
 		pxmitbuf++;
 	}
 
@@ -1265,7 +1265,7 @@ s32 rtw_free_xmitbuf_ext(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
 
 	rtw_list_delete(&pxmitbuf->list);
 
-	rtw_list_insert_tail(&(pxmitbuf->list), get_list_head(pfree_queue));
+	list_add_tail(&(pxmitbuf->list), get_list_head(pfree_queue));
 	pxmitpriv->free_xmit_extbuf_cnt++;
 
 	spin_unlock_irqrestore(&pfree_queue->lock, irql);
@@ -1332,7 +1332,7 @@ s32 rtw_free_xmitbuf(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
 
 		rtw_list_delete(&pxmitbuf->list);
 
-		rtw_list_insert_tail(&(pxmitbuf->list), get_list_head(pfree_xmitbuf_queue));
+		list_add_tail(&(pxmitbuf->list), get_list_head(pfree_xmitbuf_queue));
 
 		pxmitpriv->free_xmitbuf_cnt++;
 		spin_unlock_irqrestore(&pfree_xmitbuf_queue->lock, irql);
@@ -1429,7 +1429,7 @@ s32 rtw_free_xmitframe(struct xmit_priv *pxmitpriv, struct xmit_frame *pxmitfram
 		pxmitframe->pkt = NULL;
 	}
 
-	rtw_list_insert_tail(&pxmitframe->list, get_list_head(pfree_xmit_queue));
+	list_add_tail(&pxmitframe->list, get_list_head(pfree_xmit_queue));
 
 	pxmitpriv->free_xmitframe_cnt++;
 	RT_TRACE(_module_rtl871x_xmit_c_, _drv_debug_, ("rtw_free_xmitframe():free_xmitframe_cnt=%d\n", pxmitpriv->free_xmitframe_cnt));
@@ -1619,9 +1619,9 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 	ptxservq = rtw_get_sta_pending(padapter, psta, pattrib->priority, (u8 *)(&ac_index));
 
 	if (rtw_is_list_empty(&ptxservq->tx_pending))
-		rtw_list_insert_tail(&ptxservq->tx_pending, get_list_head(phwxmits[ac_index].sta_queue));
+		list_add_tail(&ptxservq->tx_pending, get_list_head(phwxmits[ac_index].sta_queue));
 
-	rtw_list_insert_tail(&pxmitframe->list, get_list_head(&ptxservq->sta_pending));
+	list_add_tail(&pxmitframe->list, get_list_head(&ptxservq->sta_pending));
 	ptxservq->qcnt++;
 	phwxmits[ac_index].accnt++;
 exit:
@@ -1802,7 +1802,7 @@ int xmitframe_enqueue_for_sleeping_sta(struct adapter *padapter, struct xmit_fra
 		if (pstapriv->sta_dz_bitmap) {/* if any one sta is in ps mode */
 			rtw_list_delete(&pxmitframe->list);
 
-			rtw_list_insert_tail(&pxmitframe->list, get_list_head(&psta->sleep_q));
+			list_add_tail(&pxmitframe->list, get_list_head(&psta->sleep_q));
 
 			psta->sleepq_len++;
 
@@ -1827,7 +1827,7 @@ int xmitframe_enqueue_for_sleeping_sta(struct adapter *padapter, struct xmit_fra
 		if (pstapriv->sta_dz_bitmap&BIT(psta->aid)) {
 			rtw_list_delete(&pxmitframe->list);
 
-			rtw_list_insert_tail(&pxmitframe->list, get_list_head(&psta->sleep_q));
+			list_add_tail(&pxmitframe->list, get_list_head(&psta->sleep_q));
 
 			psta->sleepq_len++;
 
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 05cc352..de3705a 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -201,7 +201,6 @@ void _rtw_memcpy(void *dec, void *sour, u32 sz);
 
 void _rtw_init_listhead(struct list_head *list);
 u32  rtw_is_list_empty(struct list_head *phead);
-void rtw_list_insert_tail(struct list_head *plist, struct list_head *phead);
 void rtw_list_delete(struct list_head *plist);
 
 u32  _rtw_down_sema(struct semaphore *sema);
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 8067f9c..2ff4f14 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -107,11 +107,6 @@ u32	rtw_is_list_empty(struct list_head *phead)
 		return false;
 }
 
-void rtw_list_insert_tail(struct list_head *plist, struct list_head *phead)
-{
-	list_add_tail(plist, phead);
-}
-
 /*
 Caller must check if the list is empty before calling rtw_list_delete
 */
-- 
1.7.10.4

