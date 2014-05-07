Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaEGD71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:59:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35391 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbaEGD7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:59:25 -0400
X-Google-Original-Message-ID: <1399435056-32386-7-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/13] staging: rtl8188eu: Remove function rtw_os_recv_resource_free()
Date: Wed,  7 May 2014 09:27:29 +0530
Message-Id: <5369af9b.c3ee440a.04cc.1cce@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435056-32386-1-git-send-email-y>
References: <1399435056-32386-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

rtw_os_recv_resource_free() has empty defination, so we can remove it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c      |    2 --
 drivers/staging/rtl8188eu/include/recv_osdep.h |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    5 -----
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 56b1ef1..db6ab4f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -117,8 +117,6 @@ void _rtw_free_recv_priv (struct recv_priv *precvpriv)
 
 	rtw_free_uc_swdec_pending_queue(padapter);
 
-	rtw_os_recv_resource_free(precvpriv);
-
 	if (precvpriv->pallocated_frame_buf) {
 		vfree(precvpriv->pallocated_frame_buf);
 	}
diff --git a/drivers/staging/rtl8188eu/include/recv_osdep.h b/drivers/staging/rtl8188eu/include/recv_osdep.h
index f49ac56..44caea9 100644
--- a/drivers/staging/rtl8188eu/include/recv_osdep.h
+++ b/drivers/staging/rtl8188eu/include/recv_osdep.h
@@ -41,7 +41,6 @@ void rtw_free_recv_priv(struct recv_priv *precvpriv);
 
 int rtw_os_recv_resource_alloc(struct adapter *adapt,
 			       struct recv_frame *recvfr);
-void rtw_os_recv_resource_free(struct recv_priv *precvpriv);
 
 int rtw_os_recvbuf_resource_alloc(struct adapter *adapt, struct recv_buf *buf);
 int rtw_os_recvbuf_resource_free(struct adapter *adapt, struct recv_buf *buf);
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index c1fbe8d..d1ce639 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -37,11 +37,6 @@ int rtw_os_recv_resource_alloc(struct adapter *padapter,
 	return _SUCCESS;
 }
 
-/* free os related resource in struct recv_frame */
-void rtw_os_recv_resource_free(struct recv_priv *precvpriv)
-{
-}
-
 /* alloc os related resource in struct recv_buf */
 int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 				  struct recv_buf *precvbuf)
-- 
1.7.10.4

