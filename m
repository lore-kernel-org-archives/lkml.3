Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbaFXU5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:57:50 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:54294 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaFXU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:57:49 -0400
From: Clement Calmels <clement.calmels@free.fr>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20Calmels?= <clement.calmels@free.fr>
Subject: [PATCH] staging: rtl8723au: fix sparse warning
Date: Tue, 24 Jun 2014 22:57:54 +0200
Message-Id: <1403643474-7991-1-git-send-email-clement.calmels@free.fr>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clément Calmels <clement.calmels@free.fr>

Found running sparse on the rtl8723au driver.

  CHECK   drivers/staging/rtl8723au/core/rtw_cmd.c
drivers/staging/rtl8723au/core/rtw_cmd.c:1479:54: warning: incorrect type in argument 2 (different base types)
drivers/staging/rtl8723au/core/rtw_cmd.c:1479:54:    expected int [signed] gfp
drivers/staging/rtl8723au/core/rtw_cmd.c:1479:54:    got restricted gfp_t

Signed-off-by: Clement Calmels <clement.calmels@free.fr>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c    | 2 +-
 drivers/staging/rtl8723au/include/rtw_mlme.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 7170258..c6f4e47 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -125,7 +125,7 @@ void rtw_free_mlme_priv23a(struct mlme_priv *pmlmepriv)
 	rtw23a_free_mlme_priv_ie_data(pmlmepriv);
 }
 
-struct wlan_network *rtw_alloc_network(struct mlme_priv *pmlmepriv, int gfp)
+struct wlan_network *rtw_alloc_network(struct mlme_priv *pmlmepriv, gfp_t gfp)
 {
 	struct wlan_network *pnetwork;
 
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme.h b/drivers/staging/rtl8723au/include/rtw_mlme.h
index 4d327ba..f798078 100644
--- a/drivers/staging/rtl8723au/include/rtw_mlme.h
+++ b/drivers/staging/rtl8723au/include/rtw_mlme.h
@@ -344,7 +344,7 @@ void rtw23a_free_mlme_priv_ie_data(struct mlme_priv *pmlmepriv);
 
 void _rtw_free_mlme_priv23a(struct mlme_priv *pmlmepriv);
 
-struct wlan_network *rtw_alloc_network(struct mlme_priv *pmlmepriv, int gfp);
+struct wlan_network *rtw_alloc_network(struct mlme_priv *pmlmepriv, gfp_t gfp);
 
 int rtw_if_up23a(struct rtw_adapter *padapter);
 
-- 
2.0.0

