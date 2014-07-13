Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaGMOcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:32:13 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50942 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaGMOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:31:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/16] staging: rtl8188eu: Remove unused function _rtw_dequeue_network()
Date: Sun, 13 Jul 2014 19:59:35 +0530
Message-Id: <1405261778-7653-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |   19 -------------------
 drivers/staging/rtl8188eu/include/rtw_mlme.h |    2 --
 2 files changed, 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 6cfb729..5ab6752 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -142,25 +142,6 @@ exit:
 	return _SUCCESS;
 }
 
-struct	wlan_network *_rtw_dequeue_network(struct __queue *queue)
-{
-	struct wlan_network *pnetwork;
-
-	spin_lock_bh(&queue->lock);
-
-	if (list_empty(&queue->queue)) {
-		pnetwork = NULL;
-	} else {
-		pnetwork = container_of((&queue->queue)->next, struct wlan_network, list);
-
-		list_del_init(&(pnetwork->list));
-	}
-
-	spin_unlock_bh(&queue->lock);
-
-	return pnetwork;
-}
-
 struct	wlan_network *_rtw_alloc_network(struct	mlme_priv *pmlmepriv)/* _queue *free_queue) */
 {
 	struct	wlan_network	*pnetwork;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index e727cf0..a234e8d 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -571,8 +571,6 @@ void _rtw_free_mlme_priv(struct mlme_priv *pmlmepriv);
 
 int _rtw_enqueue_network(struct __queue *queue, struct wlan_network *pnetwork);
 
-struct wlan_network *_rtw_dequeue_network(struct __queue *queue);
-
 struct wlan_network *_rtw_alloc_network(struct mlme_priv *pmlmepriv);
 
 void _rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
-- 
1.7.10.4

