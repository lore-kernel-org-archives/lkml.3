Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaFVIXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:23:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50245 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaFVIXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:23:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/42] staging: rtl8188eu: Remove rtw_is_list_empty(), wrapper for list_emty()
Date: Sun, 22 Jun 2014 13:49:33 +0530
Message-Id: <1403425202-11942-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |   12 ++++++------
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    4 ++--
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |    4 ++--
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    2 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   19 +------------------
 8 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 0bcd8a8..1f6587b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -155,7 +155,7 @@ struct	cmd_obj	*_rtw_dequeue_cmd(struct __queue *queue)
 
 
 	spin_lock_irqsave(&queue->lock, irqL);
-	if (rtw_is_list_empty(&(queue->queue))) {
+	if (list_empty(&(queue->queue))) {
 		obj = NULL;
 	} else {
 		obj = container_of((&queue->queue)->next, struct cmd_obj, list);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 418fb21..8b678b7 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -817,7 +817,7 @@ unsigned int OnAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 		pstat->auth_seq = 0;
 	} else {
 		spin_lock_bh(&pstapriv->asoc_list_lock);
-		if (!rtw_is_list_empty(&pstat->asoc_list)) {
+		if (!list_empty(&pstat->asoc_list)) {
 			rtw_list_delete(&pstat->asoc_list);
 			pstapriv->asoc_list_cnt--;
 		}
@@ -829,7 +829,7 @@ unsigned int OnAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 	}
 
 	spin_lock_bh(&pstapriv->auth_list_lock);
-	if (rtw_is_list_empty(&pstat->auth_list)) {
+	if (list_empty(&pstat->auth_list)) {
 		list_add_tail(&pstat->auth_list, &pstapriv->auth_list);
 		pstapriv->auth_list_cnt++;
 	}
@@ -1407,14 +1407,14 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 	pstat->state |= WIFI_FW_ASSOC_SUCCESS;
 
 	spin_lock_bh(&pstapriv->auth_list_lock);
-	if (!rtw_is_list_empty(&pstat->auth_list)) {
+	if (!list_empty(&pstat->auth_list)) {
 		rtw_list_delete(&pstat->auth_list);
 		pstapriv->auth_list_cnt--;
 	}
 	spin_unlock_bh(&pstapriv->auth_list_lock);
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
-	if (rtw_is_list_empty(&pstat->asoc_list)) {
+	if (list_empty(&pstat->asoc_list)) {
 		pstat->expire_to = pstapriv->expire_to;
 		list_add_tail(&pstat->asoc_list, &pstapriv->asoc_list);
 		pstapriv->asoc_list_cnt++;
@@ -1600,7 +1600,7 @@ unsigned int OnDeAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 			u8 updated = 0;
 
 			spin_lock_bh(&pstapriv->asoc_list_lock);
-			if (!rtw_is_list_empty(&psta->asoc_list)) {
+			if (!list_empty(&psta->asoc_list)) {
 				rtw_list_delete(&psta->asoc_list);
 				pstapriv->asoc_list_cnt--;
 				updated = ap_free_sta(padapter, psta, false, reason);
@@ -1664,7 +1664,7 @@ unsigned int OnDisassoc(struct adapter *padapter, struct recv_frame *precv_frame
 			u8 updated = 0;
 
 			spin_lock_bh(&pstapriv->asoc_list_lock);
-			if (!rtw_is_list_empty(&psta->asoc_list)) {
+			if (!list_empty(&psta->asoc_list)) {
 				rtw_list_delete(&psta->asoc_list);
 				pstapriv->asoc_list_cnt--;
 				updated = ap_free_sta(padapter, psta, false, reason);
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 8adfa7e..3371c7c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -1810,7 +1810,7 @@ static int recv_indicatepkts_in_order(struct adapter *padapter, struct recv_reor
 
 	/*  Handling some condition for forced indicate case. */
 	if (bforced) {
-		if (rtw_is_list_empty(phead))
+		if (list_empty(phead))
 			return true;
 
 		prhdr = container_of(plist, struct recv_frame, list);
@@ -1820,7 +1820,7 @@ static int recv_indicatepkts_in_order(struct adapter *padapter, struct recv_reor
 
 	/*  Prepare indication list and indication. */
 	/*  Check if there is any packet need indicate. */
-	while (!rtw_is_list_empty(phead)) {
+	while (!list_empty(phead)) {
 		prhdr = container_of(plist, struct recv_frame, list);
 		prframe = (struct recv_frame *)prhdr;
 		pattrib = &prframe->attrib;
diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index 39cc197..7bb2fa8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -362,7 +362,7 @@ u32	rtw_free_stainfo(struct adapter *padapter , struct sta_info *psta)
 		phead =		get_list_head(ppending_recvframe_queue);
 		plist = phead->next;
 
-		while (!rtw_is_list_empty(phead)) {
+		while (!list_empty(phead)) {
 			prhdr = container_of(plist, struct recv_frame, list);
 			prframe = (struct recv_frame *)prhdr;
 
@@ -382,7 +382,7 @@ u32	rtw_free_stainfo(struct adapter *padapter , struct sta_info *psta)
 #ifdef CONFIG_88EU_AP_MODE
 
 	spin_lock_bh(&pstapriv->auth_list_lock);
-	if (!rtw_is_list_empty(&psta->auth_list)) {
+	if (!list_empty(&psta->auth_list)) {
 		rtw_list_delete(&psta->auth_list);
 		pstapriv->auth_list_cnt--;
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 4b763bc..faecfda 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1618,7 +1618,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 
 	ptxservq = rtw_get_sta_pending(padapter, psta, pattrib->priority, (u8 *)(&ac_index));
 
-	if (rtw_is_list_empty(&ptxservq->tx_pending))
+	if (list_empty(&ptxservq->tx_pending))
 		list_add_tail(&ptxservq->tx_pending, get_list_head(phwxmits[ac_index].sta_queue));
 
 	list_add_tail(&pxmitframe->list, get_list_head(&ptxservq->sta_pending));
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index d047b00..0a2a499 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -200,7 +200,6 @@ void *rtw_malloc2d(int h, int w, int size);
 void _rtw_memcpy(void *dec, void *sour, u32 sz);
 
 void _rtw_init_listhead(struct list_head *list);
-u32  rtw_is_list_empty(struct list_head *phead);
 void rtw_list_delete(struct list_head *plist);
 
 u32  _rtw_down_sema(struct semaphore *sema);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 1443d4a..acce512 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -5176,7 +5176,7 @@ static int rtw_del_sta(struct net_device *dev, struct ieee_param *param)
 	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
 	if (psta) {
 		spin_lock_bh(&pstapriv->asoc_list_lock);
-		if (!rtw_is_list_empty(&psta->asoc_list)) {
+		if (!list_empty(&psta->asoc_list)) {
 			rtw_list_delete(&psta->asoc_list);
 			pstapriv->asoc_list_cnt--;
 			updated = ap_free_sta(padapter, psta, true, WLAN_REASON_DEAUTH_LEAVING);
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index da283f8..ba5531f 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -94,23 +94,6 @@ void _rtw_init_listhead(struct list_head *list)
 	INIT_LIST_HEAD(list);
 }
 
-/*
-For the following list_xxx operations,
-caller must guarantee the atomic context.
-Otherwise, there will be racing condition.
-*/
-u32	rtw_is_list_empty(struct list_head *phead)
-{
-	if (list_empty(phead))
-		return true;
-	else
-		return false;
-}
-
-/*
-Caller must check if the list is empty before calling rtw_list_delete
-*/
-
 u32 _rtw_down_sema(struct semaphore *sema)
 {
 	if (down_interruptible(sema))
@@ -127,7 +110,7 @@ void	_rtw_init_queue(struct __queue *pqueue)
 
 u32	  _rtw_queue_empty(struct __queue *pqueue)
 {
-	return rtw_is_list_empty(&(pqueue->queue));
+	return list_empty(&(pqueue->queue));
 }
 
 inline u32 rtw_systime_to_ms(u32 systime)
-- 
1.7.10.4

