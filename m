Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaERGlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 02:41:47 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64835 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaERGlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 02:41:45 -0400
From: Karim Raslan <karim.allah.ahmed@gmail.com>
Cc: Karim Raslan <karim.allah.ahmed@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masanari Iida <standby24x7@gmail.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: rtw_sta_mgt: change rtw_alloc_stainfo23a to use gfp_t instead if int
Date: Sun, 18 May 2014 07:39:23 +0100
Message-Id: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix a few sparse warnings like the following:

  CHECK   drivers/staging/rtl8723au/core/rtw_ap.c
drivers/staging/rtl8723au/core/rtw_ap.c:1054:45: warning: incorrect type in argument 3 (different base types)
drivers/staging/rtl8723au/core/rtw_ap.c:1054:45:    expected int [signed] gfp
drivers/staging/rtl8723au/core/rtw_ap.c:1054:45:    got restricted gfp_t

Signed-off-by: Karim Raslan <karim.allah.ahmed@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c |    2 +-
 drivers/staging/rtl8723au/include/sta_info.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
index 7f1f66c..1ecfb87 100644
--- a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
@@ -106,7 +106,7 @@ u32	_rtw_free_sta_priv23a(struct	sta_priv *pstapriv)
 }
 
 struct sta_info *
-rtw_alloc_stainfo23a(struct sta_priv *pstapriv, u8 *hwaddr, int gfp)
+rtw_alloc_stainfo23a(struct sta_priv *pstapriv, u8 *hwaddr, gfp_t gfp)
 {
 	struct list_head	*phash_list;
 	struct sta_info	*psta;
diff --git a/drivers/staging/rtl8723au/include/sta_info.h b/drivers/staging/rtl8723au/include/sta_info.h
index 10d933e..e3bd31b 100644
--- a/drivers/staging/rtl8723au/include/sta_info.h
+++ b/drivers/staging/rtl8723au/include/sta_info.h
@@ -362,7 +362,7 @@ static inline u32 wifi_mac_hash(const u8 *mac)
 u32	_rtw_init_sta_priv23a(struct sta_priv *pstapriv);
 u32	_rtw_free_sta_priv23a(struct sta_priv *pstapriv);
 
-struct sta_info *rtw_alloc_stainfo23a(struct sta_priv *pstapriv, u8 *hwaddr, int gfp);
+struct sta_info *rtw_alloc_stainfo23a(struct sta_priv *pstapriv, u8 *hwaddr, gfp_t gfp);
 u32 rtw_free_stainfo23a(struct rtw_adapter *padapter, struct sta_info *psta);
 void rtw_free_all_stainfo23a(struct rtw_adapter *padapter);
 struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr);
-- 
1.7.9.5

