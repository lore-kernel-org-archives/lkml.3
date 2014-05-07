Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaEGD7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:59:50 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62946 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaEGD7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:59:47 -0400
X-Google-Original-Message-ID: <1399435056-32386-9-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/13] staging: rtl8188eu: Remove function rtw_os_recvbuf_resource_free()
Date: Wed,  7 May 2014 09:27:31 +0530
Message-Id: <5369afb2.045c440a.5c92.1e39@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435056-32386-1-git-send-email-y>
References: <1399435056-32386-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

Use usb_free_urb() instead of rtw_os_recvbuf_resource_free() to free URB.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    2 +-
 drivers/staging/rtl8188eu/include/recv_osdep.h |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    8 --------
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 2b45564..0f6222d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -97,7 +97,7 @@ void rtl8188eu_free_recv_priv(struct adapter *padapter)
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 
 	for (i = 0; i < NR_RECVBUFF; i++) {
-		rtw_os_recvbuf_resource_free(padapter, precvbuf);
+		usb_free_urb(precvbuf->purb);
 		precvbuf++;
 	}
 
diff --git a/drivers/staging/rtl8188eu/include/recv_osdep.h b/drivers/staging/rtl8188eu/include/recv_osdep.h
index 5333598..a4fd957 100644
--- a/drivers/staging/rtl8188eu/include/recv_osdep.h
+++ b/drivers/staging/rtl8188eu/include/recv_osdep.h
@@ -42,7 +42,6 @@ int rtw_os_recv_resource_alloc(struct adapter *adapt,
 			       struct recv_frame *recvfr);
 
 int rtw_os_recvbuf_resource_alloc(struct adapter *adapt, struct recv_buf *buf);
-int rtw_os_recvbuf_resource_free(struct adapter *adapt, struct recv_buf *buf);
 
 void rtw_os_read_port(struct adapter *padapter, struct recv_buf *precvbuf);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index edb7969..c0fa8fd 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -51,14 +51,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 	return res;
 }
 
-/* free os related resource in struct recv_buf */
-int rtw_os_recvbuf_resource_free(struct adapter *padapter,
-				 struct recv_buf *precvbuf)
-{
-	usb_free_urb(precvbuf->purb);
-	return _SUCCESS;
-}
-
 void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup)
 {
 	union iwreq_data wrqu;
-- 
1.7.10.4

