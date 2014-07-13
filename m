Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaGMOb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:31:59 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32903 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbaGMObo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:31:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/16] staging: rtl8188eu: Make _rtw_free_network() static
Date: Sun, 13 Jul 2014 19:59:34 +0530
Message-Id: <1405261778-7653-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |    2 +-
 drivers/staging/rtl8188eu/include/rtw_mlme.h |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index fcd3f5a..6cfb729 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -194,7 +194,7 @@ exit:
 	return pnetwork;
 }
 
-void _rtw_free_network(struct	mlme_priv *pmlmepriv , struct wlan_network *pnetwork, u8 isfreeall)
+static void _rtw_free_network(struct	mlme_priv *pmlmepriv , struct wlan_network *pnetwork, u8 isfreeall)
 {
 	u32 curr_time, delta_time;
 	u32 lifetime = SCANQUEUE_LIFETIME;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 04d3b3d..e727cf0 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -575,9 +575,6 @@ struct wlan_network *_rtw_dequeue_network(struct __queue *queue);
 
 struct wlan_network *_rtw_alloc_network(struct mlme_priv *pmlmepriv);
 
-
-void _rtw_free_network(struct mlme_priv *pmlmepriv,
-		       struct wlan_network *pnetwork, u8 isfreeall);
 void _rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
 			      struct wlan_network *pnetwork);
 
-- 
1.7.10.4

