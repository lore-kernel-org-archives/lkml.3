Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaFVIXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:23:37 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34088 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaFVIXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:23:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/42] staging: rtl8188eu: Remove _rtw_init_listhead(), wrapper for INIT_LIST_HEAD()
Date: Sun, 22 Jun 2014 13:49:34 +0530
Message-Id: <1403425202-11942-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c           |    6 +++---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |   12 ++++++------
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |    6 +++---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |   10 +++++-----
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    2 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    4 ++--
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |   14 +++++++-------
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |   12 ++++++------
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h       |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    2 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    7 +------
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |    2 +-
 13 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index 7682115..c3c4649 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -1170,7 +1170,7 @@ int rtw_acl_add_sta(struct adapter *padapter, u8 *addr)
 		paclnode = &pacl_list->aclnode[i];
 
 		if (!paclnode->valid) {
-			_rtw_init_listhead(&paclnode->list);
+			INIT_LIST_HEAD(&paclnode->list);
 
 			memcpy(paclnode->addr, addr, ETH_ALEN);
 
@@ -1910,11 +1910,11 @@ void start_ap_mode(struct adapter *padapter)
 	pmlmepriv->p2p_probe_resp_ie = NULL;
 
 	/* for ACL */
-	_rtw_init_listhead(&(pacl_list->acl_node_q.queue));
+	INIT_LIST_HEAD(&(pacl_list->acl_node_q.queue));
 	pacl_list->num = 0;
 	pacl_list->mode = 0;
 	for (i = 0; i < NUM_ACL; i++) {
-		_rtw_init_listhead(&pacl_list->aclnode[i].list);
+		INIT_LIST_HEAD(&pacl_list->aclnode[i].list);
 		pacl_list->aclnode[i].valid = false;
 	}
 }
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 1f6587b..29f45e8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -651,7 +651,7 @@ u8 rtw_getbbreg_cmd(struct adapter  *padapter, u8 offset, u8 *pval)
 		return _FAIL;
 	}
 
-	_rtw_init_listhead(&ph2c->list);
+	INIT_LIST_HEAD(&ph2c->list);
 	ph2c->cmdcode = GEN_CMD_CODE(_GetBBReg);
 	ph2c->parmbuf = (unsigned char *)prdbbparm;
 	ph2c->cmdsz =  sizeof(struct readBB_parm);
@@ -715,7 +715,7 @@ u8 rtw_getrfreg_cmd(struct adapter  *padapter, u8 offset, u8 *pval)
 		goto exit;
 	}
 
-	_rtw_init_listhead(&ph2c->list);
+	INIT_LIST_HEAD(&ph2c->list);
 	ph2c->cmdcode = GEN_CMD_CODE(_GetRFReg);
 	ph2c->parmbuf = (unsigned char *)prdrfparm;
 	ph2c->cmdsz =  sizeof(struct readRF_parm);
@@ -774,7 +774,7 @@ u8 rtw_createbss_cmd(struct adapter  *padapter)
 		goto exit;
 	}
 
-	_rtw_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	pcmd->cmdcode = _CreateBss_CMD_;
 	pcmd->parmbuf = (unsigned char *)pdev_network;
 	pcmd->cmdsz = get_wlan_bssid_ex_sz((struct wlan_bssid_ex *)pdev_network);
@@ -801,7 +801,7 @@ u8 rtw_createbss_cmd_ex(struct adapter  *padapter, unsigned char *pbss, unsigned
 		goto exit;
 	}
 
-	_rtw_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	pcmd->cmdcode = GEN_CMD_CODE(_CreateBss);
 	pcmd->parmbuf = pbss;
 	pcmd->cmdsz =  sz;
@@ -944,7 +944,7 @@ u8 rtw_joinbss_cmd(struct adapter  *padapter, struct wlan_network *pnetwork)
 
 	pcmd->cmdsz = get_wlan_bssid_ex_sz(psecnetwork);/* get cmdsz before endian conversion */
 
-	_rtw_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	pcmd->cmdcode = _JoinBss_CMD_;/* GEN_CMD_CODE(_JoinBss) */
 	pcmd->parmbuf = (unsigned char *)psecnetwork;
 	pcmd->rsp = NULL;
@@ -1194,7 +1194,7 @@ u8 rtw_getrttbl_cmd(struct adapter  *padapter, struct getratable_rsp *pval)
 		goto exit;
 	}
 
-	_rtw_init_listhead(&ph2c->list);
+	INIT_LIST_HEAD(&ph2c->list);
 	ph2c->cmdcode = GEN_CMD_CODE(_GetRaTable);
 	ph2c->parmbuf = (unsigned char *)pgetrttblparm;
 	ph2c->cmdsz =  sizeof(struct getratable_parm);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 2fc294e..f0ad0c5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -72,7 +72,7 @@ int _rtw_init_mlme_priv(struct adapter *padapter)
 	pnetwork = (struct wlan_network *)pbuf;
 
 	for (i = 0; i < MAX_BSS_CNT; i++) {
-		_rtw_init_listhead(&(pnetwork->list));
+		INIT_LIST_HEAD(&(pnetwork->list));
 
 		list_add_tail(&(pnetwork->list), &(pmlmepriv->free_bss_pool.queue));
 
@@ -1685,7 +1685,7 @@ int rtw_set_auth(struct adapter *adapter, struct security_priv *psecuritypriv)
 	pcmd->cmdsz =  (sizeof(struct setauth_parm));
 	pcmd->rsp = NULL;
 	pcmd->rspsz = 0;
-	_rtw_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 		 ("after enqueue set_auth_cmd, auth_mode=%x\n",
 		 psecuritypriv->dot11AuthAlgrthm));
@@ -1766,7 +1766,7 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
 	pcmd->cmdsz =  (sizeof(struct setkey_parm));
 	pcmd->rsp = NULL;
 	pcmd->rspsz = 0;
-	_rtw_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	res = rtw_enqueue_cmd(pcmdpriv, pcmd);
 	return res;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 8b678b7..6244555 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -7066,7 +7066,7 @@ void report_survey_event(struct adapter *padapter,
 		return;
 	}
 
-	_rtw_init_listhead(&pcmd_obj->list);
+	INIT_LIST_HEAD(&pcmd_obj->list);
 
 	pcmd_obj->cmdcode = GEN_CMD_CODE(_Set_MLME_EVT);
 	pcmd_obj->cmdsz = cmdsz;
@@ -7118,7 +7118,7 @@ void report_surveydone_event(struct adapter *padapter)
 		return;
 	}
 
-	_rtw_init_listhead(&pcmd_obj->list);
+	INIT_LIST_HEAD(&pcmd_obj->list);
 
 	pcmd_obj->cmdcode = GEN_CMD_CODE(_Set_MLME_EVT);
 	pcmd_obj->cmdsz = cmdsz;
@@ -7164,7 +7164,7 @@ void report_join_res(struct adapter *padapter, int res)
 		return;
 	}
 
-	_rtw_init_listhead(&pcmd_obj->list);
+	INIT_LIST_HEAD(&pcmd_obj->list);
 
 	pcmd_obj->cmdcode = GEN_CMD_CODE(_Set_MLME_EVT);
 	pcmd_obj->cmdsz = cmdsz;
@@ -7217,7 +7217,7 @@ void report_del_sta_event(struct adapter *padapter, unsigned char *MacAddr, unsi
 		return;
 	}
 
-	_rtw_init_listhead(&pcmd_obj->list);
+	INIT_LIST_HEAD(&pcmd_obj->list);
 
 	pcmd_obj->cmdcode = GEN_CMD_CODE(_Set_MLME_EVT);
 	pcmd_obj->cmdsz = cmdsz;
@@ -7272,7 +7272,7 @@ void report_add_sta_event(struct adapter *padapter, unsigned char *MacAddr, int
 		return;
 	}
 
-	_rtw_init_listhead(&pcmd_obj->list);
+	INIT_LIST_HEAD(&pcmd_obj->list);
 
 	pcmd_obj->cmdcode = GEN_CMD_CODE(_Set_MLME_EVT);
 	pcmd_obj->cmdsz = cmdsz;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index af1be19..2469a82 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -971,7 +971,7 @@ void _rtw_mp_xmit_priv(struct xmit_priv *pxmitpriv)
 	pxmitbuf = (struct xmit_buf *)pxmitpriv->pxmit_extbuf;
 
 	for (i = 0; i < num_xmit_extbuf; i++) {
-		_rtw_init_listhead(&pxmitbuf->list);
+		INIT_LIST_HEAD(&pxmitbuf->list);
 
 		pxmitbuf->priv_data = NULL;
 		pxmitbuf->padapter = padapter;
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 3371c7c..a2bdcd7 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -82,7 +82,7 @@ int _rtw_init_recv_priv(struct recv_priv *precvpriv, struct adapter *padapter)
 	precvframe = (struct recv_frame *)precvpriv->precv_frame_buf;
 
 	for (i = 0; i < NR_RECVFRAME; i++) {
-		_rtw_init_listhead(&(precvframe->list));
+		INIT_LIST_HEAD(&(precvframe->list));
 
 		list_add_tail(&(precvframe->list),
 				     &(precvpriv->free_recv_queue.queue));
@@ -169,7 +169,7 @@ struct recv_frame *rtw_alloc_recvframe(struct __queue *pfree_recv_queue)
 void rtw_init_recvframe(struct recv_frame *precvframe, struct recv_priv *precvpriv)
 {
 	/* Perry: This can be removed */
-	_rtw_init_listhead(&precvframe->list);
+	INIT_LIST_HEAD(&precvframe->list);
 
 	precvframe->len = 0;
 }
diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index 7bb2fa8..60f2482 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -32,8 +32,8 @@ static void _rtw_init_stainfo(struct sta_info *psta)
 	memset((u8 *)psta, 0, sizeof (struct sta_info));
 
 	 spin_lock_init(&psta->lock);
-	_rtw_init_listhead(&psta->list);
-	_rtw_init_listhead(&psta->hash_list);
+	INIT_LIST_HEAD(&psta->list);
+	INIT_LIST_HEAD(&psta->hash_list);
 	_rtw_init_queue(&psta->sleep_q);
 	psta->sleepq_len = 0;
 
@@ -42,9 +42,9 @@ static void _rtw_init_stainfo(struct sta_info *psta)
 
 #ifdef CONFIG_88EU_AP_MODE
 
-	_rtw_init_listhead(&psta->asoc_list);
+	INIT_LIST_HEAD(&psta->asoc_list);
 
-	_rtw_init_listhead(&psta->auth_list);
+	INIT_LIST_HEAD(&psta->auth_list);
 
 	psta->expire_to = 0;
 
@@ -98,7 +98,7 @@ u32	_rtw_init_sta_priv(struct	sta_priv *pstapriv)
 	for (i = 0; i < NUM_STA; i++) {
 		_rtw_init_stainfo(psta);
 
-		_rtw_init_listhead(&(pstapriv->sta_hash[i]));
+		INIT_LIST_HEAD(&(pstapriv->sta_hash[i]));
 
 		list_add_tail(&psta->list, get_list_head(&pstapriv->free_sta_queue));
 
@@ -110,8 +110,8 @@ u32	_rtw_init_sta_priv(struct	sta_priv *pstapriv)
 	pstapriv->sta_dz_bitmap = 0;
 	pstapriv->tim_bitmap = 0;
 
-	_rtw_init_listhead(&pstapriv->asoc_list);
-	_rtw_init_listhead(&pstapriv->auth_list);
+	INIT_LIST_HEAD(&pstapriv->asoc_list);
+	INIT_LIST_HEAD(&pstapriv->auth_list);
 	spin_lock_init(&pstapriv->asoc_list_lock);
 	spin_lock_init(&pstapriv->auth_list_lock);
 	pstapriv->asoc_list_cnt = 0;
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index faecfda..8f380f3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -31,7 +31,7 @@ static u8 RFC1042_OUI[P80211_OUI_LEN] = { 0x00, 0x00, 0x00 };
 
 static void _init_txservq(struct tx_servq *ptxservq)
 {
-	_rtw_init_listhead(&ptxservq->tx_pending);
+	INIT_LIST_HEAD(&ptxservq->tx_pending);
 	_rtw_init_queue(&ptxservq->sta_pending);
 	ptxservq->qcnt = 0;
 }
@@ -44,8 +44,8 @@ void	_rtw_init_sta_xmit_priv(struct sta_xmit_priv *psta_xmitpriv)
 	_init_txservq(&psta_xmitpriv->bk_q);
 	_init_txservq(&psta_xmitpriv->vi_q);
 	_init_txservq(&psta_xmitpriv->vo_q);
-	_rtw_init_listhead(&psta_xmitpriv->legacy_dz);
-	_rtw_init_listhead(&psta_xmitpriv->apsd);
+	INIT_LIST_HEAD(&psta_xmitpriv->legacy_dz);
+	INIT_LIST_HEAD(&psta_xmitpriv->apsd);
 
 }
 
@@ -100,7 +100,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 	pxframe = (struct xmit_frame *)pxmitpriv->pxmit_frame_buf;
 
 	for (i = 0; i < NR_XMITFRAME; i++) {
-		_rtw_init_listhead(&(pxframe->list));
+		INIT_LIST_HEAD(&(pxframe->list));
 
 		pxframe->padapter = padapter;
 		pxframe->frame_tag = NULL_FRAMETAG;
@@ -138,7 +138,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 	pxmitbuf = (struct xmit_buf *)pxmitpriv->pxmitbuf;
 
 	for (i = 0; i < NR_XMITBUFF; i++) {
-		_rtw_init_listhead(&pxmitbuf->list);
+		INIT_LIST_HEAD(&pxmitbuf->list);
 
 		pxmitbuf->priv_data = NULL;
 		pxmitbuf->padapter = padapter;
@@ -178,7 +178,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 	pxmitbuf = (struct xmit_buf *)pxmitpriv->pxmit_extbuf;
 
 	for (i = 0; i < num_xmit_extbuf; i++) {
-		_rtw_init_listhead(&pxmitbuf->list);
+		INIT_LIST_HEAD(&pxmitbuf->list);
 
 		pxmitbuf->priv_data = NULL;
 		pxmitbuf->padapter = padapter;
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 0a2a499..23b75fc 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -199,7 +199,6 @@ void *rtw_malloc2d(int h, int w, int size);
 
 void _rtw_memcpy(void *dec, void *sour, u32 sz);
 
-void _rtw_init_listhead(struct list_head *list);
 void rtw_list_delete(struct list_head *plist);
 
 u32  _rtw_down_sema(struct semaphore *sema);
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 66467f7..c478bde 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -77,7 +77,7 @@ struct	evt_priv {
 
 #define init_h2fwcmd_w_parm_no_rsp(pcmd, pparm, code) \
 do {\
-	_rtw_init_listhead(&pcmd->list);\
+	INIT_LIST_HEAD(&pcmd->list);\
 	pcmd->cmdcode = code;\
 	pcmd->parmbuf = (u8 *)(pparm);\
 	pcmd->cmdsz = sizeof(*pparm);\
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index acce512..15748a5 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -4801,7 +4801,7 @@ static int set_group_key(struct adapter *padapter, u8 *key, u8 alg, int keyid)
 	pcmd->rsp = NULL;
 	pcmd->rspsz = 0;
 
-	_rtw_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 
 	res = rtw_enqueue_cmd(pcmdpriv, pcmd);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index ba5531f..1ef9c49 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -89,11 +89,6 @@ void *rtw_malloc2d(int h, int w, int size)
 	return a;
 }
 
-void _rtw_init_listhead(struct list_head *list)
-{
-	INIT_LIST_HEAD(list);
-}
-
 u32 _rtw_down_sema(struct semaphore *sema)
 {
 	if (down_interruptible(sema))
@@ -104,7 +99,7 @@ u32 _rtw_down_sema(struct semaphore *sema)
 
 void	_rtw_init_queue(struct __queue *pqueue)
 {
-	_rtw_init_listhead(&(pqueue->queue));
+	INIT_LIST_HEAD(&(pqueue->queue));
 	spin_lock_init(&(pqueue->lock));
 }
 
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index db8aab3..8015c3a 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -76,7 +76,7 @@ static int recvbuf2recvframe(struct adapter *adapt, struct sk_buff *pskb)
 			goto _exit_recvbuf2recvframe;
 		}
 
-		_rtw_init_listhead(&precvframe->list);
+		INIT_LIST_HEAD(&precvframe->list);
 		precvframe->len = 0;
 
 		update_recvframe_attrib_88e(precvframe, prxstat);
-- 
1.7.10.4

