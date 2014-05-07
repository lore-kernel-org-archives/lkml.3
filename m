Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaEGD7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:59:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57700 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbaEGD7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:59:36 -0400
X-Google-Original-Message-ID: <1399435056-32386-8-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/13] staging: rtl8188eu: Remove function rtw_hostapd_mlme_rx()
Date: Wed,  7 May 2014 09:27:30 +0530
Message-Id: <5369afa7.054e440a.7fe4.1c64@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435056-32386-1-git-send-email-y>
References: <1399435056-32386-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

rtw_hostapd_mlme_rx() has empty defination, so we can remove it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c  |    2 --
 drivers/staging/rtl8188eu/include/recv_osdep.h |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    5 -----
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 55be52f..e854732 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -502,8 +502,6 @@ void mgt_dispatcher(struct adapter *padapter, struct recv_frame *precv_frame)
 		break;
 	default:
 		_mgt_dispatcher(padapter, ptable, precv_frame);
-		if (check_fwstate(pmlmepriv, WIFI_AP_STATE))
-			rtw_hostapd_mlme_rx(padapter, precv_frame);
 		break;
 	}
 #else
diff --git a/drivers/staging/rtl8188eu/include/recv_osdep.h b/drivers/staging/rtl8188eu/include/recv_osdep.h
index 44caea9..5333598 100644
--- a/drivers/staging/rtl8188eu/include/recv_osdep.h
+++ b/drivers/staging/rtl8188eu/include/recv_osdep.h
@@ -33,7 +33,6 @@ int rtw_recv_indicatepkt(struct adapter *adapter,
 			 struct recv_frame *recv_frame);
 void rtw_recv_returnpacket(struct  net_device *cnxt, struct sk_buff *retpkt);
 
-void rtw_hostapd_mlme_rx(struct adapter *padapter, struct recv_frame *recv_fr);
 void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup);
 
 int rtw_init_recv_priv(struct recv_priv *precvpriv, struct adapter *padapter);
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index d1ce639..edb7969 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -95,11 +95,6 @@ void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup)
 			    &wrqu, (char *)&ev);
 }
 
-void rtw_hostapd_mlme_rx(struct adapter *padapter,
-			 struct recv_frame *precv_frame)
-{
-}
-
 int rtw_recv_indicatepkt(struct adapter *padapter,
 			 struct recv_frame *precv_frame)
 {
-- 
1.7.10.4

