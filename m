Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaGBQte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:49:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51846 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaGBQta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:49:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/48] staging: rtl8188eu: Remove dummy function rtw_hal_c2h_handler()
Date: Wed,  2 Jul 2014 22:17:01 +0530
Message-Id: <1404319664-8327-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c     |    9 ---------
 drivers/staging/rtl8188eu/include/hal_intf.h |    4 ----
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index f002c43..279dd0b 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -376,15 +376,6 @@ void rtw_hal_reset_security_engine(struct adapter *adapter)
 		adapter->HalFunc.hal_reset_security_engine(adapter);
 }
 
-s32 rtw_hal_c2h_handler(struct adapter *adapter, struct c2h_evt_hdr *c2h_evt)
-{
-	s32 ret = _FAIL;
-
-	if (adapter->HalFunc.c2h_handler)
-		ret = adapter->HalFunc.c2h_handler(adapter, c2h_evt);
-	return ret;
-}
-
 c2h_id_filter rtw_hal_c2h_id_filter_ccx(struct adapter *adapter)
 {
 	return adapter->HalFunc.c2h_id_filter_ccx;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index fb797c7..f7ce9de 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -236,8 +236,6 @@ struct hal_ops {
 
 	void (*hal_notch_filter)(struct adapter *adapter, bool enable);
 	void (*hal_reset_security_engine)(struct adapter *adapter);
-	s32 (*c2h_handler)(struct adapter *padapter,
-			   struct c2h_evt_hdr *c2h_evt);
 	c2h_id_filter c2h_id_filter_ccx;
 };
 
@@ -342,8 +340,6 @@ int rtw_hal_iol_cmd(struct adapter  *adapter, struct xmit_frame *xmit_frame,
 void rtw_hal_notch_filter(struct adapter *adapter, bool enable);
 void rtw_hal_reset_security_engine(struct adapter *adapter);
 
-s32 rtw_hal_c2h_handler(struct adapter *adapter,
-			struct c2h_evt_hdr *c2h_evt);
 c2h_id_filter rtw_hal_c2h_id_filter_ccx(struct adapter *adapter);
 void indicate_wx_scan_complete_event(struct adapter *padapter);
 u8 rtw_do_join(struct adapter *padapter);
-- 
1.7.10.4

