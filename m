Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaE0PhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:37:22 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60323 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaE0PhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/15] staging: rtl8188eu:Remove unused function rtw_handle_dualmac()
Date: Tue, 27 May 2014 21:05:49 +0530
Message-Id: <1401204955-4093-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 6c9e9a1..c1195a0 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -1663,24 +1663,3 @@ void beacon_timing_control(struct adapter *padapter)
 }
 
 static struct adapter *pbuddy_padapter;
-
-int rtw_handle_dualmac(struct adapter *adapter, bool init)
-{
-	int status = _SUCCESS;
-
-	if (init) {
-		if (pbuddy_padapter == NULL) {
-			pbuddy_padapter = adapter;
-			DBG_88E("%s(): pbuddy_padapter == NULL, Set pbuddy_padapter\n", __func__);
-		} else {
-			adapter->pbuddy_adapter = pbuddy_padapter;
-			pbuddy_padapter->pbuddy_adapter = adapter;
-			/*  clear global value */
-			pbuddy_padapter = NULL;
-			DBG_88E("%s(): pbuddy_padapter exist, Exchange Information\n", __func__);
-		}
-	} else {
-		pbuddy_padapter = NULL;
-	}
-	return status;
-}
-- 
1.7.10.4

