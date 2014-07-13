Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaGMOck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:32:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62268 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaGMOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:32:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/16] staging: rtl8188eu: Remove unused function _rtw_enqueue_network()
Date: Sun, 13 Jul 2014 19:59:36 +0530
Message-Id: <1405261778-7653-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |   15 ---------------
 drivers/staging/rtl8188eu/include/rtw_mlme.h |    2 --
 2 files changed, 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 5ab6752..2aafac3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -127,21 +127,6 @@ void _rtw_free_mlme_priv(struct mlme_priv *pmlmepriv)
 	}
 }
 
-int	_rtw_enqueue_network(struct __queue *queue, struct wlan_network *pnetwork)
-{
-	if (pnetwork == NULL)
-		goto exit;
-
-	spin_lock_bh(&queue->lock);
-
-	list_add_tail(&pnetwork->list, &queue->queue);
-
-	spin_unlock_bh(&queue->lock);
-
-exit:
-	return _SUCCESS;
-}
-
 struct	wlan_network *_rtw_alloc_network(struct	mlme_priv *pmlmepriv)/* _queue *free_queue) */
 {
 	struct	wlan_network	*pnetwork;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index a234e8d..13f8702 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -569,8 +569,6 @@ void rtw_free_mlme_priv_ie_data(struct mlme_priv *pmlmepriv);
 
 void _rtw_free_mlme_priv(struct mlme_priv *pmlmepriv);
 
-int _rtw_enqueue_network(struct __queue *queue, struct wlan_network *pnetwork);
-
 struct wlan_network *_rtw_alloc_network(struct mlme_priv *pmlmepriv);
 
 void _rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
-- 
1.7.10.4

