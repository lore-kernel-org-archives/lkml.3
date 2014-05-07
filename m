Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaEGD7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:59:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52180 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbaEGD7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:59:05 -0400
X-Google-Original-Message-ID: <1399435056-32386-6-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/13] staging: rtl8188eu: Remove function rtw_os_recv_resource_init()
Date: Wed,  7 May 2014 09:27:28 +0530
Message-Id: <5369af88.8564420a.3494.ffffc54b@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435056-32386-1-git-send-email-y>
References: <1399435056-32386-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

rtw_os_recv_resource_init() has empty defination, so we can remove it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c      |    2 --
 drivers/staging/rtl8188eu/include/recv_osdep.h |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    7 -------
 3 files changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 5260fe5..56b1ef1 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -71,8 +71,6 @@ int _rtw_init_recv_priv(struct recv_priv *precvpriv, struct adapter *padapter)
 
 	precvpriv->free_recvframe_cnt = NR_RECVFRAME;
 
-	rtw_os_recv_resource_init(precvpriv, padapter);
-
 	precvpriv->pallocated_frame_buf = vzalloc(NR_RECVFRAME * sizeof(struct recv_frame) + RXFRAME_ALIGN_SZ);
 
 	if (precvpriv->pallocated_frame_buf == NULL) {
diff --git a/drivers/staging/rtl8188eu/include/recv_osdep.h b/drivers/staging/rtl8188eu/include/recv_osdep.h
index d76cc2d..f49ac56 100644
--- a/drivers/staging/rtl8188eu/include/recv_osdep.h
+++ b/drivers/staging/rtl8188eu/include/recv_osdep.h
@@ -39,7 +39,6 @@ void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup);
 int rtw_init_recv_priv(struct recv_priv *precvpriv, struct adapter *padapter);
 void rtw_free_recv_priv(struct recv_priv *precvpriv);
 
-int rtw_os_recv_resource_init(struct recv_priv *recvpr, struct adapter *adapt);
 int rtw_os_recv_resource_alloc(struct adapter *adapt,
 			       struct recv_frame *recvfr);
 void rtw_os_recv_resource_free(struct recv_priv *precvpriv);
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 29ec014..c1fbe8d 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -28,13 +28,6 @@
 #include <osdep_intf.h>
 #include <usb_ops.h>
 
-/* init os related resource in struct recv_priv */
-int rtw_os_recv_resource_init(struct recv_priv *precvpriv,
-			      struct adapter *padapter)
-{
-	return _SUCCESS;
-}
-
 /* alloc os related resource in struct recv_frame */
 int rtw_os_recv_resource_alloc(struct adapter *padapter,
 			       struct recv_frame *precvframe)
-- 
1.7.10.4

